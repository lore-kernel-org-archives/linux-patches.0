Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207491;
	b=agAHi8MiorXAEma8ZS8QAJT8HP0tHvaIMzzJVDn4fbILrn9xgqIYccsZ+HYhb8llTXBW
	 GIRhwgeA7MyNNgvYlVNVDQcegNxbNLQd0A2GiWDLiDpjJlQyGNAJZDG4xZ6cDFLIexvp0
	 uW2fX3qTTKmAarZIcyS+d9TiOu0pgJz9yjKJEEqklusJHdVEfjip5CI/oucn3X6l5euIE
	 1oRpE41saGWOFuqmUKIMyyvAo4aZWrPaMcrjDXrhyiKTC/mpeL/awVuhGKay5/5u/KaEg
	 439XgXw+RvppZ3QYsTIfxglJKWYgZjxL7GNckZkxExWb2t8McJLZjVs64H1lJ0I0vzw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207491;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uzrklgFpCpYt9+0BQnvH3P+4vaIjV4giBqwn8+Z0J/s=;
	b=wTbsAjlmKxmgTCV85qPBVw2SfkicyHh6xEph0LDNxtPGA4vihup6Qn4w/W2YpW3nnmXR
	 Ppn+Vgbmu89UeypZdEH11QXg5Pt68YszYeJLT0u48E05Q7H3nfXHZJrWytemGnF9NKFtP
	 ko9ellsBabcqRTsiiSYmBvovwtadm7eXD5kbWX9R4H1t4aI2bnfZuWX8bZQy+UrMRC6yc
	 VQNlkQ3zUOE7W3p9D4MMYxjNUpZX2j9GU8UYP6VZrtC3WwNnhQ/qAoNO0ymXHdu2th9CW
	 oez3v/FK2u4R+JO8TClQhdvvKOyeckxnd86TIeUyqrGtqdN4aTqisAYoeCdcHcTyXew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="CtSGpn//";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E1A7606A31A;
	Wed, 28 Oct 2026 17:11:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CtSGpn//
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D4B51F031EF;
	Wed, 28 Oct 2026 17:11:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207491;
	bh=uzrklgFpCpYt9+0BQnvH3P+4vaIjV4giBqwn8+Z0J/s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CtSGpn//jCM4okst0glASDJ3HBTniJ8PgU+wbOljtzIwqfIYYGGs7UTNh6YCyF3+5
	 KDufLv8yYhPbaw8uj7vFBMACqtusU9YrtZolIaoO6kZ4Fepx5nSTKGBdVl4Ui9iB+8
	 3+gkXEVq7FRHMcU1Bj7d6IGh3dGdw4lc+TljsmQQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 004/247] rose: clear neighbour pointer in rose_kill_by_device()
Date: Wed, 28 Oct 2026 17:56:47 +0100
Message-ID: <20261028165947.460440677@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165947.349197979@linuxfoundation.org>
References: <20261028165947.349197979@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bernard Pidoux <bernard.f6bvp@gmail.com>

rose_kill_by_device() drops the neighbour reference but leaves
rose->neighbour pointing at it, unlike every other rose_neigh_put() site
(see "rose: clear neighbour pointer after rose_neigh_put() in state
machines"). The heartbeat STATE_0 reaping path then puts the same
neighbour a second time, causing a rose_neigh refcount underflow and a
use-after-free.

Set rose->neighbour = NULL after the put, restoring the invariant.

Signed-off-by: Bernard Pidoux <bernard.f6bvp@gmail.com>

(cherry picked from commit 606e42d195b467480d4d405f8814c48d1651a76a)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rose/af_rose.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/net/rose/af_rose.c b/net/rose/af_rose.c
index 5aedbbf105c33..e0294a5183b47 100644
--- a/net/rose/af_rose.c
+++ b/net/rose/af_rose.c
@@ -216,8 +216,16 @@ static void rose_kill_by_device(struct net_device *dev)
 			 * looping forever in ROSE_STATE_0 with no owner.
 			 */
 			sock_set_flag(sk, SOCK_DESTROY);
-			if (rose->neighbour)
+			if (rose->neighbour) {
 				rose_neigh_put(rose->neighbour);
+				/* Clear the pointer after dropping the reference, as
+				 * every other rose_neigh_put() site does.  Otherwise
+				 * rose_heartbeat_expiry() (STATE_0 reaping) sees a stale
+				 * rose->neighbour and puts it a second time -> rose_neigh
+				 * refcount underflow / use-after-free.
+				 */
+				rose->neighbour = NULL;
+			}
 			netdev_put(rose->device, &rose->dev_tracker);
 			rose->device = NULL;
 		}
-- 
2.53.0



