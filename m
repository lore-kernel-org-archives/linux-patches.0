Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029195;
	b=hLApiZNVzRn84eI+o0W8QzL5NueGU2ROi+caO1WGUJt5UYQHrftDB26486IBV0kDI+d/
	 1KKq01COGL/6LfiLS6hDvNNpaIoZHyseGgaBOxhO9lNc3zbEXYo+A7l176uKCH2AYi7Ps
	 ikp6epHox1NG50LEVJx1JxvyErz4yX+YzIrpc+JqnevMeCcNpJVQ9nzCltm7zArUGzbAg
	 ZN3tNBK33o0ZuZymiswFqgASdqHAGVJJfYfTYW7gCvB+5Spd0hA2o1q0WGp4lhxHApU8v
	 fqRJrDIJ7DkX2NbBBabWGSdeDGCT3qgg5uCwERdvF5ROJFrTbmz6/tFNVqjxlQYOcvw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029195;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mpdIHnD1Ze+N7dkbeEWf3xOOuC+vY0r7dIwHxl4C9Lw=;
	b=3y0R9+TpxmqU0UNCAqBMP5v3ryD1P2d3i0Qyzpm29Y6skB/3LD4/2by7NxBBHxG+SkjH
	 3HtTbotsmP9ISZKf0yWM9azvIUgOjc+84EFJM3TijExCeyQ+qa2YJUvnf/1I+MG8m+FA4
	 dt1q0FFpG31sXoe4F7+GIR8kbI7XpHwKW3sqqhJDpFK7C3JmFh4p5qsCPgG42IBdaWMQ4
	 Y/7c3tmO9CDH12VoI5557arCAcoQcW2U5i0mBbQYGRSY7fTSv7PCJ1m8Y5RL0DvNHGOIi
	 VLNq7EUUHgvJk7WW0VaOcUCrlBqhIrnqSpR6Mgg+0ZNqBmKZjxeI2UfRG4cFMkEX1+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="wRjk/uO+";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB735606A320;
	Wed, 18 Nov 2026 19:13:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wRjk/uO+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 280B61F000C4;
	Wed, 18 Nov 2026 19:13:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029195;
	bh=mpdIHnD1Ze+N7dkbeEWf3xOOuC+vY0r7dIwHxl4C9Lw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wRjk/uO+wszG2RIJL5zCCbA6dnOpaUDTCFRpaLv9yv0CbuSntjfT9h+zn00RslWUj
	 mYCVm/6IsPfr+9HFPOmvOHj7hSMrYahE5Wif3VXjDgckfSVpn4A7+CNUaK8DwqEIxm
	 D17HRMxzE1l0pP/t+mWd5iT7Kb5xqm40QQLoMkRM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaoqing Pan <miaoqing.pan@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0217/1756] wifi: ath11k: fix sporadic WLAN initialization failures
Date: Wed, 18 Nov 2026 15:39:04 +0100
Message-ID: <20261118150016.959358576@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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
index 2e935d381b6b1..35d922885c803 100644
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
index ee40cd3be47e3..b9bf1c5a934cd 100644
--- a/drivers/net/wireless/ath/ath11k/ahb.c
+++ b/drivers/net/wireless/ath/ath11k/ahb.c
@@ -1357,5 +1357,6 @@ static struct platform_driver ath11k_ahb_driver = {
 
 module_platform_driver(ath11k_ahb_driver);
 
+MODULE_SOFTDEP("pre: qrtr_smd");
 MODULE_DESCRIPTION("Driver support for Qualcomm Technologies 802.11ax WLAN AHB devices");
 MODULE_LICENSE("Dual BSD/GPL");
-- 
2.53.0



