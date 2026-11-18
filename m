Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023009;
	b=JIcBkzy2Jc7ca0qxC4FnmIBraaYXVn8eExgb6eBKiQ5tZ9T4Z3NS+byR1zFsAu+7kiNE
	 p9pS4GYgLf3Im7SgoYJqgy2AdqzmWH8i2KkB5Hmd5JqUetkG1YsQG5jvgVm9khjqVg3VZ
	 xr7cjBvIxLAywxU1i0cTkf7QFjAKwZY9YNch3gNhe3zD8lGD3MJLMLKqQsqIep/XcQmod
	 5usgcFuU+3eHWumVSd5zauF50KJiGqD9ogJk8fJSZpArktuYZqsLbsIPjsATKQLCYyU1w
	 IRdGmk8xKsAEKxjtH2iz966BFBwi5zJ2Nzxz+NWO732Wf9ozDpU+JowlvzeCpZapCqQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023009;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=q/bQeFQBcaeo8WIoBALCfDjN+dUq06tgW++WOOaQJBk=;
	b=ICkdhrVX4yC1ArQzsNzE8ty7OhQC4rXOWAFyBvJT8WceXj52E5yUxAqrJpiFMYM+aC4S
	 cPouyN2C8YOydWrgCPAB+QcLINUIOGwxoAt/t4ZPBDP7PoHQsm5LigmT5jA+Ron0KIGlf
	 11PU+DqYW9LLI5RP76q4wInwVdDJVJZF6P1t4OJK7hGwFrTfV5YUI4XX04hhx7FyeJBp4
	 2y+fjFXWOlR69p76dYGAt9y55edsSQHArPsJx+p2ndk+0hn5UpbmycorJaKNxJhYVlxas
	 Md7kV8DsuDwwoLb2dul8JHFi7jkhAezwbPsruplsdmSBx5nUcTc/D7JbZrJHvd8GTPA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HhMVsRCM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F1B3606A32C;
	Wed, 18 Nov 2026 17:30:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HhMVsRCM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9ACC1F000C4;
	Wed, 18 Nov 2026 17:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023009;
	bh=q/bQeFQBcaeo8WIoBALCfDjN+dUq06tgW++WOOaQJBk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HhMVsRCMdn+9VNYANFkTXJs3ma5/wFZdJWQVQxX+WHNY6N5jb0e55Vx/UyidDOrQ9
	 YrUcnKnWDurI6CjQ5OVdlIs+Ty2pTZ7/2SjbVD7dud6RbQMjU5CZH8JQvtZOi02Efw
	 16uuEj08xJwBomek6+hf8ZDDO8JUGtdtYcB/FqIU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaoqing Pan <miaoqing.pan@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0215/2151] wifi: ath11k: fix sporadic WLAN initialization failures
Date: Wed, 18 Nov 2026 15:32:30 +0100
Message-ID: <20261118150129.611592004@linuxfoundation.org>
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

From: Miaoqing Pan <miaoqing.pan@oss.qualcomm.com>

[ Upstream commit 32ec8488d75d122768b1977501bcb5ec799230c4 ]

On WCN6750 platforms, reboot stress testing occasionally results in WLAN
initialization failures after boot. The WPSS firmware reaches the running
state successfully, but no WLAN interface is created.

Analysis shows that ath11k_ahb depends on the QRTR SMD transport for QMI
communication with WPSS firmware. However, this dependency is not
currently expressed in Kconfig, allowing qrtr_smd and ath11k_ahb to load
in either order when built as modules.

If ath11k_ahb is loaded before qrtr_smd becomes available, WLAN
initialization may not complete successfully.

Make the QRTR and QRTR_SMD dependencies explicit and add a soft
dependency to ensure qrtr_smd is loaded before ath11k_ahb.

Tested-on: WCN6750 hw1.0 AHB WLAN.MSL.2.0.c2-00204-QCAMSLSWPLZ-1

Fixes: 00402f49d26f ("ath11k: Add support for WCN6750 device")
Signed-off-by: Miaoqing Pan <miaoqing.pan@oss.qualcomm.com>
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Link: https://patch.msgid.link/20260806101331.484063-2-miaoqing.pan@oss.qualcomm.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/Kconfig | 3 +++
 drivers/net/wireless/ath/ath11k/ahb.c   | 1 +
 2 files changed, 4 insertions(+)

diff --git a/drivers/net/wireless/ath/ath11k/Kconfig b/drivers/net/wireless/ath/ath11k/Kconfig
index 659ef134ef168..a4519b2b025a6 100644
--- a/drivers/net/wireless/ath/ath11k/Kconfig
+++ b/drivers/net/wireless/ath/ath11k/Kconfig
@@ -15,6 +15,9 @@ config ATH11K_AHB
 	tristate "Atheros ath11k AHB support"
 	depends on ATH11K
 	depends on REMOTEPROC
+	select RPMSG
+	select QRTR
+	select QRTR_SMD
 	help
 	  This module adds support for AHB bus
 
diff --git a/drivers/net/wireless/ath/ath11k/ahb.c b/drivers/net/wireless/ath/ath11k/ahb.c
index 5d8c0457721cd..b6a146e9abf8a 100644
--- a/drivers/net/wireless/ath/ath11k/ahb.c
+++ b/drivers/net/wireless/ath/ath11k/ahb.c
@@ -1347,5 +1347,6 @@ static struct platform_driver ath11k_ahb_driver = {
 
 module_platform_driver(ath11k_ahb_driver);
 
+MODULE_SOFTDEP("pre: qrtr_smd");
 MODULE_DESCRIPTION("Driver support for Qualcomm Technologies 802.11ax WLAN AHB devices");
 MODULE_LICENSE("Dual BSD/GPL");
-- 
2.53.0



