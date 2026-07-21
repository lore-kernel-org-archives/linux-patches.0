Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 812E2449B0B;
	Tue, 21 Jul 2026 15:56:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649401; cv=none; b=SHGy/yhP4lEd/ODpkLrsOtVFx132mWPetdnbg/wu4gje7L74SYZUamZPj8w7wfcSsDR0GK4iXQlw/YAEUcu2AAs1hqwpNRq/YpR7EdgJ0jvCTg6RhgutLukZzM7C+5qP7qsMM1/al2ab/U1GE2EohEpiiumnwVAubB375j/CmrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649401; c=relaxed/simple;
	bh=NmuQBBFQKgBjA0TDrcMzOUV2C+W14FXDiIuDrWcr+JQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eelP7nbrSZ1Oo/KDI/M1XeE53iGJc/XnRyBM+Kjj1MRe4nKRLDLQIVzTE02NCkuU7+SoXzlQ5FNTgPknXw/JNJ6K91I/3hv0hsUX4CRbdptywYkBkMsKxa9CGjJRV3v/YULdzjwAg6nnbwlt6kcgyeQ95KBE+zrnlBqqBGP1E88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OeAMmVxj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OeAMmVxj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E64861F000E9;
	Tue, 21 Jul 2026 15:56:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649400;
	bh=GQyc38FH001XpbByqw6DqMYxkC1M0fGtQVlc0FhUK0Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OeAMmVxjDxAYZt5eOkMx/1ODG+ng+ON1QoDCnO5MT4UR8XtUbaLu686WryuoScYei
	 PvLHs6jT6OXBP2KSQiN2phpa+7VZOQ1AsXj9SLFnuvKSvmZYex/FzGdE+TyEEDy9vo
	 5U8fdgSn/8/eznton8Q3l9YN9hIYpe+uJyNVxFBw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Leonardo Scorcia <l.scorcia@gmail.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0565/2077] pinctrl: mediatek: mt8516: Fix Schmitt trigger register offset of pins 34-39
Date: Tue, 21 Jul 2026 17:03:58 +0200
Message-ID: <20260721152606.138141214@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index abda75d4354e28..68d6638e7f4b18 100644
--- a/drivers/pinctrl/mediatek/pinctrl-mt8516.c
+++ b/drivers/pinctrl/mediatek/pinctrl-mt8516.c
@@ -244,7 +244,7 @@ static const struct mtk_pin_ies_smt_set mt8516_smt_set[] = {
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



