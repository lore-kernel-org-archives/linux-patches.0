Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 155763BB680;
	Tue, 21 Jul 2026 22:40:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673652; cv=none; b=epDWuNN/4aLcGWuIF0Ig3s4LAgGlKRXbT1IM+oPLHAGSh8WEnPOs8A2e7PxXlJ78tkDOH+27+Bsww5fRjCV8qR2du3xXdxd9Ih1acrnL2zXT8Q/C+F2v7D1qCJRyKOrHmQ4qWw6BDSWNa6vVNsK/bwrtbPsi9rKDfiAEwFsPzAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673652; c=relaxed/simple;
	bh=/zTmBzs2IiqJV2H2AWPqQvdIVCEBcgfKvxIEpqMZwZE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mt2ii1laDkYpnyRWXluxgJvghJmK7+3uS255DwEUC+mXZt0tg5d4XW/63ERCqsC/BwO1E3HmoJWx3PT43WTGMcrEIsA99RzIyaKSmfDqqyyBVhItoKNXwvY//b2o10QwAUbvBRjI/Ib758zwuPYfpsKliTA575Nj2K0CXtjj/7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r+CGyTIj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r+CGyTIj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71A2D1F000E9;
	Tue, 21 Jul 2026 22:40:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673650;
	bh=ujg7A9P8ExEOu2ykHTiJtz3JtpuxshmVTEbUdoefo7M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r+CGyTIjH1WNTxdKQj77KADGBI+SBuSa/jOq2aVzSL4KMVR+gURESwv1Ti25WvtDX
	 7wFGODKmHw9q0aubSCHjox9zMQhD1NRXWUsfzZNTJIaP3HaHBF8/aGj5vfmYdi74FB
	 2TD0rC39HV7KOwswLHD4R4y7gUMsnnu5iCCCzlr8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Leonardo Scorcia <l.scorcia@gmail.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 243/699] pinctrl: mediatek: mt8516: Fix Schmitt trigger register offset of pins 34-39
Date: Tue, 21 Jul 2026 17:20:02 +0200
Message-ID: <20260721152401.178881483@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luca Leonardo Scorcia <l.scorcia@gmail.com>

[ Upstream commit 1c3044cab23a056ea28da47da1cdd667a39df0b8 ]

The correct Schmitt trigger register offset for pins 34-39 is 0xA00.

Signed-off-by: Luca Leonardo Scorcia <l.scorcia@gmail.com>
Fixes: 264667112ef0 ("pinctrl: mediatek: Add MT8516 Pinctrl driver")
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/mediatek/pinctrl-mt8516.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/mediatek/pinctrl-mt8516.c b/drivers/pinctrl/mediatek/pinctrl-mt8516.c
index b375426aa61e41..9e0f447bb35089 100644
--- a/drivers/pinctrl/mediatek/pinctrl-mt8516.c
+++ b/drivers/pinctrl/mediatek/pinctrl-mt8516.c
@@ -252,7 +252,7 @@ static const struct mtk_pin_ies_smt_set mt8516_smt_set[] = {
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



