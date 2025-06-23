Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 516821EE7C6;
	Mon, 23 Jun 2025 21:35:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714539; cv=none; b=WqPn4DcdFiwHrZAbnaywarQsrPjmkysiGOP6xBYajx60BrWUqo2jgQ6O3VZL3SILQfAfr6fQ/CMJ4Vcvr/uc+BmKqlIMtDP3hhbxNSFTyyjspC2NH/ioHfbg+VBtvV8GgczX7D3qpHwniXDtvjFAc8GlLwWpFUPSgDGKyAxDe80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714539; c=relaxed/simple;
	bh=WwXGbE7IIb9Y3RGPt9jcRG5JxZfRzzoemDYcaRr1zbI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h/lKnNJQvydVuPyqhsy6r+y0xfFrz9eS6scq5PTnN7EIrJAq8QdZ9Dz0n+nwrMu5ositR+vCz8YeaheqlfoTV4RwlizsDRXMN1851ok0eRtGRrvdJ9uuM8Z1OQhft+W313rEOC4s5Ku8Fn15dfgSzI87bOhjMP4wW6wIESRlhVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Le0VC0Bh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Le0VC0Bh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98AD2C4CEEA;
	Mon, 23 Jun 2025 21:35:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714538;
	bh=WwXGbE7IIb9Y3RGPt9jcRG5JxZfRzzoemDYcaRr1zbI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Le0VC0BhJOsNIYGkK/66w2ZY1Y6I3JHBoI7MpmwtJIqtVAe34spoup5unk4LBzSdG
	 avAzcH6lnAe8FSzs9kzGu4vng07s6U7PK37pk7DZj+h7sOteh2USYPmj1OwIjQcvqZ
	 aDovN2+r0PU+cn6kG7Ojm+L5OIYpP57XjH3MJ768=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hari Chandrakanthan <quic_haric@quicinc.com>,
	Nicolas Escande <nico.escande@gmail.com>,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Karthikeyan Periyasamy <quic_periyasa@quicinc.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 421/592] wifi: ath12k: fix link valid field initialization in the monitor Rx
Date: Mon, 23 Jun 2025 15:06:19 +0200
Message-ID: <20250623130710.450384528@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hari Chandrakanthan <quic_haric@quicinc.com>

[ Upstream commit 2826139f9295821fe2b049318a1cc057ec003131 ]

Currently, the link_valid field is not initialized in the monitor Rx path.
This can result in random values for the link_valid and link_id leads to
undefined behaviour in mac80211. Therefore, initialize the link_valid
field in the monitor Rx path.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.3.1-00173-QCAHKSWPL_SILICONZ-1
Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.0.c5-00481-QCAHMTSWPL_V1.0_V2.0_SILICONZ-3

Signed-off-by: Hari Chandrakanthan <quic_haric@quicinc.com>
Tested-by: Nicolas Escande <nico.escande@gmail.com>
Reviewed-by: Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>
Signed-off-by: Karthikeyan Periyasamy <quic_periyasa@quicinc.com>
Link: https://patch.msgid.link/20250324062518.2752822-2-quic_periyasa@quicinc.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/dp_mon.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/ath/ath12k/dp_mon.c b/drivers/net/wireless/ath/ath12k/dp_mon.c
index 600d97169f241..826c9723a7a68 100644
--- a/drivers/net/wireless/ath/ath12k/dp_mon.c
+++ b/drivers/net/wireless/ath/ath12k/dp_mon.c
@@ -2097,6 +2097,8 @@ static void ath12k_dp_mon_rx_deliver_msdu(struct ath12k *ar, struct napi_struct
 	bool is_mcbc = rxcb->is_mcbc;
 	bool is_eapol_tkip = rxcb->is_eapol;
 
+	status->link_valid = 0;
+
 	if ((status->encoding == RX_ENC_HE) && !(status->flag & RX_FLAG_RADIOTAP_HE) &&
 	    !(status->flag & RX_FLAG_SKIP_MONITOR)) {
 		he = skb_push(msdu, sizeof(known));
-- 
2.39.5



