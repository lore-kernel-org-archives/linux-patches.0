Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1B6BF9F6;
	Sat,  3 Feb 2024 04:09:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933366; cv=none; b=WpSUaefAw52dHRmKDFEC+Zbm2C2E62I8nL4e2dUYrulW0xwWsqsMBXNuFzCiPfUVMsjAZuXvmFa2W2uPTHyf80tXs05Sk3cAs4URmQEOYaqVXgof1KQrszN5m7+3LZ1Qg/zFX/ujpOOaVAVFHj+tYahnnUdB7oVcPHXJUtjWtkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933366; c=relaxed/simple;
	bh=x6F14fs4nxydXWieNonTaMprG9Z/Nuj8lmjrvAvW9MI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GVd14HIsvXpRlYlLCJh7luVpNA7Rpp//U2lgLyVuZrpXLVfXrmFUqQUr2YhzTZKaRzACBUFMkNBm3WCQDQ2DfVQ6LnRoTpC1Xt0aPpbQ2X467HF+bpBpqoKm29c8ZkQ2Jx9bAR/kouBQF/JPxqiEiWiV0raCRKDYvRtKTVqNWKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=orInam1/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="orInam1/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69ECDC433F1;
	Sat,  3 Feb 2024 04:09:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933366;
	bh=x6F14fs4nxydXWieNonTaMprG9Z/Nuj8lmjrvAvW9MI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=orInam1/iRNR9E7Csi+hh1SKwGRabJBMF7Kn2fMozaofayAn2+IRHJDXwBVEeXxc+
	 0OxsXpOELkfC1YvDUBwyRo62pwDDxbZqtAAKQYWXEroNsN7oebvm1u74H9zMb/UxpA
	 RK9eRSDqyNdMA8C658rcPc7+tFXnQ9HaNgcoqdwg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shiji Yang <yangshiji66@outlook.com>,
	Stanislaw Gruszka <stf_xl@wp.pl>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 048/219] wifi: rt2x00: correct wrong BBP register in RxDCOC calibration
Date: Fri,  2 Feb 2024 20:03:41 -0800
Message-ID: <20240203035323.502238324@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035317.354186483@linuxfoundation.org>
References: <20240203035317.354186483@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shiji Yang <yangshiji66@outlook.com>

[ Upstream commit 50da74e1e8b682853d1e07fc8bbe3a0774ae5e09 ]

Refer to Mediatek vendor driver RxDCOC_Calibration() function, when
performing gainfreeze calibration, we should write register 140
instead of 141. This fix can reduce the total calibration time from
6 seconds to 1 second.

Signed-off-by: Shiji Yang <yangshiji66@outlook.com>
Acked-by: Stanislaw Gruszka <stf_xl@wp.pl>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/TYAP286MB0315B13B89DF57B6B27BB854BCAFA@TYAP286MB0315.JPNP286.PROD.OUTLOOK.COM
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
index 12b700c7b9c3..517d9023aae3 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
@@ -8672,7 +8672,7 @@ static void rt2800_rxdcoc_calibration(struct rt2x00_dev *rt2x00dev)
 	rt2800_rfcsr_write_bank(rt2x00dev, 5, 4, saverfb5r4);
 	rt2800_rfcsr_write_bank(rt2x00dev, 7, 4, saverfb7r4);
 
-	rt2800_bbp_write(rt2x00dev, 158, 141);
+	rt2800_bbp_write(rt2x00dev, 158, 140);
 	bbpreg = rt2800_bbp_read(rt2x00dev, 159);
 	bbpreg = bbpreg & (~0x40);
 	rt2800_bbp_write(rt2x00dev, 159, bbpreg);
-- 
2.43.0



