Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 079891D1E6B;
	Wed,  2 Oct 2024 14:25:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879119; cv=none; b=JQDiIu3LFJY5JghFuGKO6AzIcv1ydWZWLiyGECLA5XrUeVVY25h5NMW7PxhLe1nOEbggJEusD68Nlr4IcDT2TXB/B+NrTv2tjdKvgI/V5UnrJ5udyaXxE3dv2dPZKsDpsGHO0CHsEQu8P4Curn5i9HTVN4uIRi787h/cCxC6zTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879119; c=relaxed/simple;
	bh=irRvSkXghAijIgLA5rw+vp+3yNErALjy/wee2d65bJA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bGLXq/OK9LLbrZOXVevvXViX0Za6yfRUkAFZkGl+Bdr4q1f0lUWU7mNJgOZt0jk3LhkAKuwocfHC4DlzkcnsgK8/LjOCjtI29Jc0B5CljZ4ojZ0moR7TML3PcqOEufkMsKCZBnn5EwGbSjoItb2BPiU/q0mSaNC+4Bk1k1IXkL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i1Bwidrk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i1Bwidrk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8559DC4CEC2;
	Wed,  2 Oct 2024 14:25:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879118;
	bh=irRvSkXghAijIgLA5rw+vp+3yNErALjy/wee2d65bJA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i1Bwidrkag82Pv8qz1KnwbScKGRRMJVWPNWlkvJQ2my18gTyK+uJgh6n+4WvdIiBz
	 wrdS4B2GzkVQfJIoV/qD1xADYH7N8fKOWYJ/qGH/UagAuFseEc8v9ImdageryK+gdC
	 QZHVnntDOXf12t/5AEYgc+He7np1n8RI6G52vRRw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	P Praneesh <quic_ppranees@quicinc.com>,
	Karthikeyan Kathirvel <quic_kathirve@quicinc.com>,
	Jeff Johnson <quic_jjohnson@quicinc.com>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 010/538] wifi: ath12k: match WMI BSS chan info structure with firmware definition
Date: Wed,  2 Oct 2024 14:54:09 +0200
Message-ID: <20241002125752.397679364@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: P Praneesh <quic_ppranees@quicinc.com>

[ Upstream commit dd98d54db29fb553839f43ade5f547baa93392c8 ]

struct wmi_pdev_bss_chan_info_event is not similar to the firmware
struct definition, this will cause some random failures.

Fix by matching the struct wmi_pdev_bss_chan_info_event with the
firmware structure definition.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.0.1-00029-QCAHKSWPL_SILICONZ-1

Fixes: d889913205cf ("wifi: ath12k: driver for Qualcomm Wi-Fi 7 devices")
Signed-off-by: P Praneesh <quic_ppranees@quicinc.com>
Signed-off-by: Karthikeyan Kathirvel <quic_kathirve@quicinc.com>
Acked-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://patch.msgid.link/20240331183232.2158756-3-quic_kathirve@quicinc.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/wmi.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath12k/wmi.h b/drivers/net/wireless/ath/ath12k/wmi.h
index 6549c3853be46..a19a2c29f2264 100644
--- a/drivers/net/wireless/ath/ath12k/wmi.h
+++ b/drivers/net/wireless/ath/ath12k/wmi.h
@@ -4034,7 +4034,6 @@ struct wmi_vdev_stopped_event {
 } __packed;
 
 struct wmi_pdev_bss_chan_info_event {
-	__le32 pdev_id;
 	__le32 freq;	/* Units in MHz */
 	__le32 noise_floor;	/* units are dBm */
 	/* rx clear - how often the channel was unused */
@@ -4052,6 +4051,7 @@ struct wmi_pdev_bss_chan_info_event {
 	/*rx_cycle cnt for my bss in 64bits format */
 	__le32 rx_bss_cycle_count_low;
 	__le32 rx_bss_cycle_count_high;
+	__le32 pdev_id;
 } __packed;
 
 #define WMI_VDEV_INSTALL_KEY_COMPL_STATUS_SUCCESS 0
-- 
2.43.0



