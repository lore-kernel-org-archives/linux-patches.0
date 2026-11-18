Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025099;
	b=IMG1Ukj94ysHV8HEanYYCzAnKkB5XBAKxxF1DK1fgSL3p0+wbwyCOj9vWL8VXIDLw702
	 9I1s5BMM2yL90ZZVqTuuxrLyueXdAaJbDPfDi24VeSfAIyDGFmuXYHyzhBcdxHmXAopBy
	 rMVEq6/G0nVH04fmOG9NAUgl1eSHxCxVdE0+3Oed8TYaCAHIQC6/OydFqhvduER7CrA5J
	 pufUpZAFnnuAIHrGTe3kEIVH5dje18Wl7fodO/Pbq9lRZgWNJawDKXXiWnakv7JKNCUyV
	 HlNjzeQPCdroe8a2MsF2dE8IX71fq/f89OEfaUUwSnbFqU+xteD7FiprkrNH9F8K0gg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025099;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3emBemrPlRNKSoWmkHkHpDfjp3WCMKz1VOi56kBRb7s=;
	b=lNobXxYErxvjk0JzClWUBhaW9LMhchVZGID4mc4iNh5Tn85kU04BbB5jv9BC/R6CBxeB
	 D83Pzqc41JZAP0J0y3CIndiN0GWKLSIMff26O0jeHDao+Cpx2bTFOufYWYSoaVB+DpiWz
	 DDVuXx0T8G5gZz2hXtgRJ/T6kdEFDTUabmBNlnJ4burzWy9d5Gx5+NxJbEwKrazNlV9A+
	 Zt38AejgSw7JDXjLrdLcJWOBziYjaH5QsGyncu1eUKaQIzFEtYTVsjpOZEb0QXP1barTy
	 eU22oGUmWQwtTfSQsteHBDHY6kTJ+OEZtpp7b48B9J6CfeENfgbGRn9FvQmHXWM0cWw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=f9qCNwNc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19A66606A31C;
	Wed, 18 Nov 2026 18:04:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=f9qCNwNc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C0151F000C4;
	Wed, 18 Nov 2026 18:04:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025099;
	bh=3emBemrPlRNKSoWmkHkHpDfjp3WCMKz1VOi56kBRb7s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f9qCNwNcpejkQ68zJdvIawZzLz8QdjHWWG3P84PO2CC6z3BC+GLUvybsHznM4q5Az
	 nWj2nEysHjSzdl7fvhbwZNgLbNlL7sEE3mMs6IYiigznwYGZLBcRk8BWY7DHKWJrq9
	 hs5cHifGtNlBJF7+uhYI3tC7u41HwhX6DFp/UCeI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Zahka <daniel.zahka@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0958/2151] eth: fbnic: take netif_addr_lock_bh() around rx mode address programming
Date: Wed, 18 Nov 2026 15:44:53 +0100
Message-ID: <20261118150157.360582785@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Zahka <daniel.zahka@gmail.com>

[ Upstream commit 96e7f9122aae0ed000ee321f324b812a447906d9 ]

When __fbnic_set_rx_mode() is called from contexts other than
.ndo_set_rx_mode_async(), the uc and mc addr lists are accessed
without the addr lock that __hw_addr_sync_dev() and
__hw_addr_unsync_dev() require. Wrap these unprotected accesses with
netif_addr_lock_bh(). fbnic_clear_rx_mode() has similar issues.

Fixes: eb690ef8d1c2 ("eth: fbnic: Add L2 address programming")
Signed-off-by: Daniel Zahka <daniel.zahka@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260617-linux-fbnic-hwaddr-v1-1-3f9f5dee7f99@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: d261a371e3b7 ("fbnic: Rework the BMC state pulled from the capabilities message")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/meta/fbnic/fbnic_netdev.c | 7 ++++++-
 drivers/net/ethernet/meta/fbnic/fbnic_pci.c    | 4 ++++
 drivers/net/ethernet/meta/fbnic/fbnic_rpc.c    | 2 ++
 3 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/meta/fbnic/fbnic_netdev.c b/drivers/net/ethernet/meta/fbnic/fbnic_netdev.c
index d6100ce2bdc1c..fe995632a42c6 100644
--- a/drivers/net/ethernet/meta/fbnic/fbnic_netdev.c
+++ b/drivers/net/ethernet/meta/fbnic/fbnic_netdev.c
@@ -262,8 +262,11 @@ static int fbnic_set_mac(struct net_device *netdev, void *p)
 
 	eth_hw_addr_set(netdev, addr->sa_data);
 
-	if (netif_running(netdev))
+	if (netif_running(netdev)) {
+		netif_addr_lock_bh(netdev);
 		__fbnic_set_rx_mode(fbn->fbd, &netdev->uc, &netdev->mc);
+		netif_addr_unlock_bh(netdev);
+	}
 
 	return 0;
 }
@@ -308,8 +311,10 @@ void fbnic_clear_rx_mode(struct fbnic_dev *fbd)
 	/* Write updates to hardware */
 	fbnic_write_macda(fbd);
 
+	netif_addr_lock_bh(netdev);
 	__dev_uc_unsync(netdev, NULL);
 	__dev_mc_unsync(netdev, NULL);
+	netif_addr_unlock_bh(netdev);
 }
 
 static int fbnic_hwtstamp_get(struct net_device *netdev,
diff --git a/drivers/net/ethernet/meta/fbnic/fbnic_pci.c b/drivers/net/ethernet/meta/fbnic/fbnic_pci.c
index 74bd390026e4c..0ae0f0cf24ad0 100644
--- a/drivers/net/ethernet/meta/fbnic/fbnic_pci.c
+++ b/drivers/net/ethernet/meta/fbnic/fbnic_pci.c
@@ -135,7 +135,9 @@ void fbnic_up(struct fbnic_net *fbn)
 
 	fbnic_rss_reinit_hw(fbn->fbd, fbn);
 
+	netif_addr_lock_bh(fbn->netdev);
 	__fbnic_set_rx_mode(fbn->fbd, &fbn->netdev->uc, &fbn->netdev->mc);
+	netif_addr_unlock_bh(fbn->netdev);
 
 	/* Enable Tx/Rx processing */
 	fbnic_napi_enable(fbn);
@@ -176,7 +178,9 @@ static int fbnic_fw_config_after_crash(struct fbnic_dev *fbd)
 	}
 
 	fbnic_rpc_reset_valid_entries(fbd);
+	netif_addr_lock_bh(fbd->netdev);
 	__fbnic_set_rx_mode(fbd, &fbd->netdev->uc, &fbd->netdev->mc);
+	netif_addr_unlock_bh(fbd->netdev);
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/meta/fbnic/fbnic_rpc.c b/drivers/net/ethernet/meta/fbnic/fbnic_rpc.c
index fe95b6f696463..bc0f38b6a2b2b 100644
--- a/drivers/net/ethernet/meta/fbnic/fbnic_rpc.c
+++ b/drivers/net/ethernet/meta/fbnic/fbnic_rpc.c
@@ -244,7 +244,9 @@ void fbnic_bmc_rpc_check(struct fbnic_dev *fbd)
 
 	if (fbd->fw_cap.need_bmc_tcam_reinit) {
 		fbnic_bmc_rpc_init(fbd);
+		netif_addr_lock_bh(fbd->netdev);
 		__fbnic_set_rx_mode(fbd, &fbd->netdev->uc, &fbd->netdev->mc);
+		netif_addr_unlock_bh(fbd->netdev);
 		fbd->fw_cap.need_bmc_tcam_reinit = false;
 	}
 
-- 
2.53.0



