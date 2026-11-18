Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049877;
	b=YIQEe1TcoKunnlPdJQkNHrSagHZ0bslTbl4eCKKLg/n+aYqz3GlJJ+Zg7i8cV3v8OMYg
	 kYmTlu0BtwSI255duURyYe+6q2Yt7jCr/5l0/BFQbAFnmjz3b1UzSW31c5OvmndhR5Etk
	 bKUw7AfJx6yK7VXH1GjZlwjQQnzoFrCfcKqMX4OB17QxEUnRacU+S1RAHoeO7vfSureZR
	 TZC16KKSHTp2uS9/5gShwhT+wtNvM42j+YcRjR3v5KlnOOb5e+dNJEsvPUVO5rRIuULZn
	 62VWoUASXzcaYCGoCsYKlB+zx8O3uRrqLQzsjGHt5Ogtx1lFY0y235BxP63KlaCRj9A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049877;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=szufM+9jOq4RwHrZ89LVlC8EJhEVfk+8zhomRZbacBU=;
	b=ZfU+JPJ8RWs/r/gMVyQ23sxpVTCLqUfUvEO3YuzPu3flNmWjV/sSKtYFlKB/LFLqimQK
	 kBea20hsR9Yc8Ie4yqi4hPnqyID7pvJusnDvZ952P17LLjIUve98fVVWyEFDkS8AB4iv1
	 0VM9GaGLsqoE67B9lxb1V1sU5UhycrLgrnsG4RpsGgY8hpcGSbOcyyp7RhzULw3+0xg4k
	 VmI58jJEAW4sIDRhU9Ih1yXJbryweQ5P3h86wisHIA4TC8FPXlPRp6qS4eRIFzn0Ejz3U
	 CCvX5ZqfoCKh57iyEVXTgcImjSLE3+MBPo9rp93fvXfT4JGPNosASlGork8s48Wclhw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=P8VWx0Be;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 035AD606A320;
	Thu, 19 Nov 2026 00:57:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=P8VWx0Be
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 579101F000C4;
	Thu, 19 Nov 2026 00:57:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049876;
	bh=szufM+9jOq4RwHrZ89LVlC8EJhEVfk+8zhomRZbacBU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P8VWx0BesS8Ap+ehuoNdW5A9B1ei0PkUL34yYnFlbNx7Ilfn3E6GS0jVJg9CeTRh8
	 IivPa0AOPu1LFeg8TrWzt2rtU65XqiM4bOkj02iVZmzcWSevO3eN0N6kWyjw7fIHRk
	 Rg+eV/V3AwhqBXjkxz/BbRVEV1oQ0cCA9oiOLzKc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2509/2857] net: selftests: use skb_share_check() in the loopback receive hook
Date: Wed, 18 Nov 2026 15:59:03 +0100
Message-ID: <20261118150331.885812587@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolai Buchwitz <nb@tipi-net.de>

[ Upstream commit fbd3a301b1378423a5cfc23a42e3c0b04e26192c ]

The loopback hook gets a shared skb when another ETH_P_IP handler is
bound to the device. skb_unshare() does not unshare it, so
skb_linearize() on a non-linear frame hits BUG_ON(skb_shared()).

Use skb_share_check() instead.

Fixes: 3e1e58d64c3d ("net: add generic selftest support")
Signed-off-by: Nicolai Buchwitz <nb@tipi-net.de>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20261007-nb-net-selftest-shared-net-v1-1-458369bfa1ba@tipi-net.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/selftests.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/selftests.c b/net/core/selftests.c
index 946e92cca2111..78c2c6acad427 100644
--- a/net/core/selftests.c
+++ b/net/core/selftests.c
@@ -190,7 +190,7 @@ static int net_test_loopback_validate(struct sk_buff *skb,
 	struct tcphdr *thdr;
 	struct iphdr *ihdr;
 
-	skb = skb_unshare(skb, GFP_ATOMIC);
+	skb = skb_share_check(skb, GFP_ATOMIC);
 	if (!skb)
 		goto out;
 
-- 
2.53.0



