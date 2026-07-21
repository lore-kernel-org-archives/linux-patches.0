Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEE42237180;
	Tue, 21 Jul 2026 20:33:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666006; cv=none; b=aMEfeW+aicN8G2sQzYgFSYI4Q1dveiQxaPhGPI6D0YI3rkgWPeUvfkuSUCmu3vZJZ8i0BVWSXE3x9I5ouappfOJjCeax4q6j0UWFOzBhYmnddyM2L5TB8hGcE+fygcHXSSbWYpdKlJXFyOodcNcCvFk0vl34RM+tVSEgab1AfwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666006; c=relaxed/simple;
	bh=pBPJX4cEmBDdSQIrUEGcC13iLGpEI2yXxPZpk1eTLfM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sSkPMDWx/9A10xnJsOm2S+xy7NfR8yw2DNRDCsg8Xiw9M53QbCn5uXQT2NdWAp2q3FsjURMA7O5glwIj+5xObH/WOaewVuz9n7XNITHqCBrbRZpcoUiIbdpQlxvzYz+G82XI5EkEk1LRiBuUUb4sVmiZ8lnGYQ+sGAO6rtNxdtU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IfqH/Bjb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IfqH/Bjb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F89E1F000E9;
	Tue, 21 Jul 2026 20:33:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666005;
	bh=MB6qDQEKOdaJfYDVmS2P0mfjKM/gIlTluzL+pBHLIAg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IfqH/Bjb+6pi2Krmw5aFQwRd6ewNAn55iFyeg1Q09rr9cNrWH1hGV9TAwSscp6YWL
	 Iw64w4+lMpSkFhPckKRL53GX+0QUwzXK3rONLNWseIevAsdw9YcsYQTYPlhCu/mnAw
	 JUgbprxCNElr/1FBDPwTGlu3xbs6tyGlcv3t0ucA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Leonardo Scorcia <l.scorcia@gmail.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0520/1266] pinctrl: mediatek: mt8167: Fix Schmitt trigger register offset of pins 34-39
Date: Tue, 21 Jul 2026 17:15:57 +0200
Message-ID: <20260721152453.488905764@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Luca Leonardo Scorcia <l.scorcia@gmail.com>

[ Upstream commit 439bc91d20188901dac698bed4921caac76d9074 ]

The correct Schmitt trigger register offset for pins 34-39 is 0xA00. Value
was verified with SoC data sheet.

Signed-off-by: Luca Leonardo Scorcia <l.scorcia@gmail.com>
Fixes: 82d70627e94a ("pinctrl: mediatek: Add MT8167 Pinctrl driver")
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/mediatek/pinctrl-mt8167.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/mediatek/pinctrl-mt8167.c b/drivers/pinctrl/mediatek/pinctrl-mt8167.c
index ba7f30c3296fec..07148f4a8c008b 100644
--- a/drivers/pinctrl/mediatek/pinctrl-mt8167.c
+++ b/drivers/pinctrl/mediatek/pinctrl-mt8167.c
@@ -244,7 +244,7 @@ static const struct mtk_pin_ies_smt_set mt8167_smt_set[] = {
 	MTK_PIN_IES_SMT_SPEC(24, 25, 0xA00, 12),
 	MTK_PIN_IES_SMT_SPEC(26, 30, 0xA00, 0),
 	MTK_PIN_IES_SMT_SPEC(31, 33, 0xA00, 1),
-	MTK_PIN_IES_SMT_SPEC(34, 39, 0xA900, 2),
+	MTK_PIN_IES_SMT_SPEC(34, 39, 0xA00, 2),
 	MTK_PIN_IES_SMT_SPEC(40, 40, 0xA10, 11),
 	MTK_PIN_IES_SMT_SPEC(41, 43, 0xA00, 10),
 	MTK_PIN_IES_SMT_SPEC(44, 47, 0xA00, 11),
-- 
2.53.0



