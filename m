Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA7E91A1872;
	Thu,  6 Jun 2024 14:13:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683186; cv=none; b=KK4htNmlE+MVhszJ41e7IdpGJEEn7nXV+05xpw5JGGm++5hu0QrdqQRdsNyv6OkanIbun3hwAIMDieB5pgRUkiIXCLabrY8sDnwV90SNdpfx0fKkIhP5ewr0ssgGi1n90jZrCRCjLV4wfISMv9S9E+q7756+L88JJlxhuonuO1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683186; c=relaxed/simple;
	bh=GJa2xQX3YW6SAQxlTJeM8fY2g0XHs9g2kf1DXiZjc6w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ee7CDV5YuomFPy2U4WEDElyV9Lifm7JGBD6xcrlE+PKUvLKTLvZTLkn0CVHCV6DlsXD+xIdBpwBX0wTweLich+V5i8op6TecFUnOIY/BUBI4uqwmkSpmKQIfV9nHifyP/9hr8BqoaZCMdveFHTE9XO3avIQH9rxQwd/X9MoRCzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EfvTI+w/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EfvTI+w/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E3A4C2BD10;
	Thu,  6 Jun 2024 14:13:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683186;
	bh=GJa2xQX3YW6SAQxlTJeM8fY2g0XHs9g2kf1DXiZjc6w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EfvTI+w/NDG7WC7lHhRFuqJM084Wydb4+k7txGIEM1iN/dJIb+yBXuZFDP8Dh1a2l
	 yBYsI6+DfORX6FdloQtyTCtVSmFv00soWzWZ6fGeOxw54HjyHoUlv6U9o6Ua6kNpzK
	 uaG0/Yr+bb2Y3eVx6Wy1Sb3psHiIcjR/fjG5oGUQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aloka Dixit <quic_alokad@quicinc.com>,
	Jeff Johnson <quic_jjohnson@quicinc.com>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 130/744] wifi: ath12k: use correct flag field for 320 MHz channels
Date: Thu,  6 Jun 2024 15:56:42 +0200
Message-ID: <20240606131736.601806707@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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
index d308a0e7f1871..cd89032fa25e1 100644
--- a/drivers/net/wireless/ath/ath12k/wmi.c
+++ b/drivers/net/wireless/ath/ath12k/wmi.c
@@ -1834,7 +1834,7 @@ static void ath12k_wmi_copy_peer_flags(struct wmi_peer_assoc_complete_cmd *cmd,
 		if (arg->bw_160)
 			cmd->peer_flags |= cpu_to_le32(WMI_PEER_160MHZ);
 		if (arg->bw_320)
-			cmd->peer_flags |= cpu_to_le32(WMI_PEER_EXT_320MHZ);
+			cmd->peer_flags_ext |= cpu_to_le32(WMI_PEER_EXT_320MHZ);
 
 		/* Typically if STBC is enabled for VHT it should be enabled
 		 * for HT as well
-- 
2.43.0



