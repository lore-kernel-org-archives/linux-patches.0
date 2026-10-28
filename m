Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210210;
	b=OWfDz9fMsCs/VFGDbqp+IoQ8t3tZszJtU+AVsiSrAPomY5z1CU0kIT1z2tF8XgOZ8OFH
	 yEflVtjE1s5CebQeL6zN33YNtAu8XzvlBpilcHhEecgl3hXST6V4lhFmifbbprvio9LxG
	 S5YWMYg18sD7In1Z6CKBvbSXtaYb9rp0n5Q31dBfLwUrOZXfz6o8hTc26RjfymZJKr8eu
	 frVTiG7vgNfv4pIhDlDrEOp9Jk6IS4K3eMYVEvEUzKnIftNLzWzTvRm8rW0C+4qR2rpif
	 uK7g9ONjtZbFOLE+Pfx0TIWCF273RPfqqXHU8rngfk7aWwve1kxEjTAHpGM4YtsyGAw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210210;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UzK/FJYDGwgl4ZQdMl9vI+qAvsdXrr04DG6IjCddqL4=;
	b=xNKCQLCl93Nnbfy0lR9ShfYFLF06bC9+hP9bO9HvvlblX0w8bUSOBNkv2JILRDwgoTqu
	 1eLvSr7Po5OrqAs/zD3Tx15nrAbVAGdcSEOJKEoQ6+IBNiuJvqq883za5JVF4WJQW4myr
	 xnIRIlRAHqcS3oB0jD7DolHkzJ3zHzqj4ve1vh3APfHiKMQg1gUa8uqgrgiNcMghTYVim
	 CWQ454Zft7PLezlMGlaMRNS1dIcLZHkkWDYch292c5shMM52xf+UV2MCy1/Y1Qn7TQG9+
	 3jUPbqHskfsAkFxyUMmYff0EvSX70IqjIfWLosvyljh2OAlWP42mxt4812wnmURDEZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=W6vQAQXJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18D30606A31A;
	Wed, 28 Oct 2026 17:56:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=W6vQAQXJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EA241F01825;
	Wed, 28 Oct 2026 17:56:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210210;
	bh=UzK/FJYDGwgl4ZQdMl9vI+qAvsdXrr04DG6IjCddqL4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W6vQAQXJ6apubEGY3gSssSRM2Jt2VPgvEYQWz0uXFmfFwS9obFOrsj/kZz2QYPAl1
	 UcwsggeqpFUGddk/37QiqpfT1j9hv1uPDU63y9388vCmIwwLif0ClPV7Xa4MhNuDuw
	 nUiSfNaalBpXUIz1SCXsDTplSlJmnofG0fLTXOSo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Horman <horms@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	Jiri Slaby <jirislaby@kernel.org>,
	Tonghao Zhang <tonghao@bamaicloud.com>,
	Hangbin Liu <liuhangbin@gmail.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Jay Vosburgh <jv@jvosburgh.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 116/168] net: bonding: update the slave array for broadcast mode
Date: Wed, 28 Oct 2026 18:00:52 +0100
Message-ID: <20261028165945.833523532@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165943.089486480@linuxfoundation.org>
References: <20261028165943.089486480@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tonghao Zhang <tonghao@bamaicloud.com>

[ Upstream commit e0caeb24f538c3c9c94f471882ceeb43d9dc2739 ]

This patch fixes ce7a381697cb ("net: bonding: add broadcast_neighbor option for 802.3ad").
Before this commit, on the broadcast mode, all devices were traversed using the
bond_for_each_slave_rcu. This patch supports traversing devices by using all_slaves.
Therefore, we need to update the slave array when enslave or release slave.

Fixes: ce7a381697cb ("net: bonding: add broadcast_neighbor option for 802.3ad")
Cc: Simon Horman <horms@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>
Cc: <stable@vger.kernel.org>
Reported-by: Jiri Slaby <jirislaby@kernel.org>
Tested-by: Jiri Slaby <jirislaby@kernel.org>
Link: https://lore.kernel.org/all/a97e6e1e-81bc-4a79-8352-9e4794b0d2ca@kernel.org/
Signed-off-by: Tonghao Zhang <tonghao@bamaicloud.com>
Reviewed-by: Hangbin Liu <liuhangbin@gmail.com>
Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>
Acked-by: Jay Vosburgh <jv@jvosburgh.net>
Link: https://patch.msgid.link/20251016125136.16568-1-tonghao@bamaicloud.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/bonding/bond_main.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index e799791daa457..69cf5b970a114 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -2314,7 +2314,9 @@ int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev,
 			bpf_prog_inc(bond->xdp_prog);
 	}
 
-	if (bond_mode_can_use_xmit_hash(bond))
+	/* broadcast mode uses the all_slaves to loop through slaves. */
+	if (bond_mode_can_use_xmit_hash(bond) ||
+	    BOND_MODE(bond) == BOND_MODE_BROADCAST)
 		bond_update_slave_arr(bond, NULL);
 
 	bond_xdp_set_features(bond_dev);
@@ -2457,7 +2459,8 @@ static int __bond_release_one(struct net_device *bond_dev,
 
 	bond_upper_dev_unlink(bond, slave);
 
-	if (bond_mode_can_use_xmit_hash(bond))
+	if (bond_mode_can_use_xmit_hash(bond) ||
+	    BOND_MODE(bond) == BOND_MODE_BROADCAST)
 		bond_update_slave_arr(bond, slave);
 
 	slave_info(bond_dev, slave_dev, "Releasing %s interface\n",
-- 
2.53.0



