Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D012B763F8;
	Mon, 27 May 2024 19:04:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716836653; cv=none; b=dSLT3gn4reuSUcfKBOUTYugOxxEWY3GCnwLflqB+9UIu0t0utYS1GLp9LXqttE51e3WJqBPV9TzHH0owaZesL4rRMUqsDAjgQZseqfqhNyZeVOYZsdhX4tD2fsoNVEU48apZd+wgcA4GuHI862Q8q87Q+1ApjXCWj8ma80GsoKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716836653; c=relaxed/simple;
	bh=EDEadB0d2lM/uAe238oip5Qn43YvAQcbvLqqX2Q23sE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VnAo8K2Jjr5Bf6+Mlg9WEfvHTaRxHHcPVLUqi3YS17xT7Le5/WvwCYKaS4BGL8+p5bsh8KXqE7CcT1ao/aB2zKGseKzBX8QU9iJbGgMCH6C7Q0i0ANoBjculgkS6otGVTLy4g1YHIWGVfK/Wcd1YBUMr1qK1wllFTR1UdCVBnoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rs1i2ojI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rs1i2ojI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0596DC2BBFC;
	Mon, 27 May 2024 19:04:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716836653;
	bh=EDEadB0d2lM/uAe238oip5Qn43YvAQcbvLqqX2Q23sE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rs1i2ojIL1QgnNowcN5dJV3n02XLGITbFUjJhIdB/82N5jy+t9yPdWwQJbYRiBuz/
	 gF4TW2wbcNX9xBrDCMLfe/IlC3azJw+56hX8bwTHE12U1iJarj5yOUaYEIvAkD9d+u
	 hchdxWOD3fIhxmvJ6sTy6WkJB11tfED+VtYdA3r0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aloka Dixit <quic_alokad@quicinc.com>,
	Jeff Johnson <quic_jjohnson@quicinc.com>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 095/427] wifi: ath12k: use correct flag field for 320 MHz channels
Date: Mon, 27 May 2024 20:52:22 +0200
Message-ID: <20240527185610.675612393@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
index 9d69a17699264..34de3d16efc09 100644
--- a/drivers/net/wireless/ath/ath12k/wmi.c
+++ b/drivers/net/wireless/ath/ath12k/wmi.c
@@ -1900,7 +1900,7 @@ static void ath12k_wmi_copy_peer_flags(struct wmi_peer_assoc_complete_cmd *cmd,
 		if (arg->bw_160)
 			cmd->peer_flags |= cpu_to_le32(WMI_PEER_160MHZ);
 		if (arg->bw_320)
-			cmd->peer_flags |= cpu_to_le32(WMI_PEER_EXT_320MHZ);
+			cmd->peer_flags_ext |= cpu_to_le32(WMI_PEER_EXT_320MHZ);
 
 		/* Typically if STBC is enabled for VHT it should be enabled
 		 * for HT as well
-- 
2.43.0



