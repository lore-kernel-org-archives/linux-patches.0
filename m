Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1751715EFC3;
	Mon, 27 May 2024 19:24:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837848; cv=none; b=jRrKdw/dUVI2jucTp96UdvCMrTpBEdi1nwnp7Yv1ygElt7svO1+yvqi2A/fSsR/Biu+84Zkn3yCkY5pEeRvToqueLkNo3OFWgAwbVibIEBB0bionPm7EB1K8w2phaS2zjBih40l0RtRQv+EIHxdv+GB8DHjh+qYZRyRHskSJcTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837848; c=relaxed/simple;
	bh=7DPJXShouZSaVfmKRJy+J00BHADVAXifQPGp9CJHRlI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E8V/5MQoYFEuuuVmvKNsc5uf3g0EQY4derwmWRLdFZvEvApaV5Ay+ecyZxYvA40RADhnlSjTo++csUV7kZ3URkO6V0ot90k4GR+ME79hbMw1NIrThfXRgCpvOVeSYe/W31AD+YbD0To2rhB0mP03O/U7O9p0G/7wc3+WfEdoznI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ezaG1mpl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ezaG1mpl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99AB1C2BBFC;
	Mon, 27 May 2024 19:24:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837847;
	bh=7DPJXShouZSaVfmKRJy+J00BHADVAXifQPGp9CJHRlI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ezaG1mpl/g189iBrxvr26ACyJZKxRTRZsv8yonZ+G9+pA2j3Gf5LFNig5ymhF3iE1
	 OBkFCjBIzdayMBs7kDsSD6E8ZLUwd2y25w1ZmDkw5JPK3axQ4TIOodPsfWWHSIPidm
	 6lXI6HXOz4beHu57Xm0NlRNkbsfqRGDtjr64sI+Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aloka Dixit <quic_alokad@quicinc.com>,
	Jeff Johnson <quic_jjohnson@quicinc.com>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 166/493] wifi: ath12k: use correct flag field for 320 MHz channels
Date: Mon, 27 May 2024 20:52:48 +0200
Message-ID: <20240527185635.794896979@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aloka Dixit <quic_alokad@quicinc.com>

[ Upstream commit 020e08ae5e68cbc0791e8d842443a86eb6aa99f6 ]

Due to an error during rebasing the patchset 320 MHz channel support got
broken. ath12k was setting the QoS bit instead of the correct flag.
WMI_PEER_EXT_320MHZ (0x2) is defined as an extended flag, replace
peer_flags by peer_flags_ext while sending peer data.

This affected both QCN9274 and WCN7850 which use the same flag.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.0.1-00029-QCAHKSWPL_SILICONZ-1

Fixes: 6734cf9b4cc7 ("wifi: ath12k: peer assoc for 320 MHz")
Signed-off-by: Aloka Dixit <quic_alokad@quicinc.com>
Acked-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://msgid.link/20240314204651.11075-1-quic_alokad@quicinc.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/wmi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath12k/wmi.c b/drivers/net/wireless/ath/ath12k/wmi.c
index 11cc3005c0f98..035d8f247e23e 100644
--- a/drivers/net/wireless/ath/ath12k/wmi.c
+++ b/drivers/net/wireless/ath/ath12k/wmi.c
@@ -1836,7 +1836,7 @@ static void ath12k_wmi_copy_peer_flags(struct wmi_peer_assoc_complete_cmd *cmd,
 		if (arg->bw_160)
 			cmd->peer_flags |= cpu_to_le32(WMI_PEER_160MHZ);
 		if (arg->bw_320)
-			cmd->peer_flags |= cpu_to_le32(WMI_PEER_EXT_320MHZ);
+			cmd->peer_flags_ext |= cpu_to_le32(WMI_PEER_EXT_320MHZ);
 
 		/* Typically if STBC is enabled for VHT it should be enabled
 		 * for HT as well
-- 
2.43.0



