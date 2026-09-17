Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EAD351DAF0;
	Thu, 17 Sep 2026 17:11:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665079; cv=none; b=G9TUpm+pya7pCKmUJ7aHu9vRz5SoRrYXiIB/TYBZAwoyrqgbjRFrvoTfS/I0a4WOBOdyLii0M+WBpvV6gDuiV5yfaTuEQo99DjBAlFn2Mhjxb1OiFZSE4dysjUC4Ow4tlBd/wuM6QbdUK0yfNq/JXZVagjgmkcAoMBs3RGjiiEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665079; c=relaxed/simple;
	bh=ruiYRJGrbDFmG4zA9MpyM1TplIOFTnnyyHhEjeelFwE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tl19rH22rOBi6NCsjWZnN6QN5sEzx/XDI8QY+Z3D4peNEE5OQlbMHItG9I5asoGoNBv9YDsCOYTnCFBgHcsvPDWpocJbuq2xyds79B2RKVt64RcvYBYh4QExYwyiplcduF35tColuGAqlpTjdkcoF9WfSsC4jgAeaEYOnbRvafs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Le2joVlj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Le2joVlj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 838891F00893;
	Thu, 17 Sep 2026 17:11:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665077;
	bh=M6f3b/cST1CMzBwdE/Jb5TQKfRmMDdVGhbnB9NzB0w8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Le2joVljbzpz+3j5w9ru7xS/ap9952LeEdcyLW5jLSY+HujrIUQBcNVkp7d+mYBRE
	 9oCeB3WDtxs1ktIup6aEM6B+drSxGmrkeSt8T+YMQQ3Qxg7hFhhXODF81t0X5wxBq/
	 r7MGcCj0+TaBW7Oe5JV84d9+0sMQjz9/R4/WDQP4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Heng <zhangheng@kylinos.cn>,
	CuerdOS Dev Team <cuerdoslinux@proton.me>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0558/1250] ASoC: amd: yc: Add DMI quirk for HP Victus Laptop 16-e1xxx
Date: Thu, 17 Sep 2026 16:05:53 +0100
Message-ID: <20260917151607.057485306@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Heng <zhangheng@kylinos.cn>

[ Upstream commit 38417f5fc8e3323218c19bd7e419eec4fb0697bd ]

Add DMI quirk to enable ACP6x sound card for HP Victus by HP Laptop
16-e1xxx, which fixes microphone not working issue.

Without this quirk, the DMIC on acp6x device is not properly enabled,
causing the microphone to not work.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=218926
Link: https://github.com/CuerdOS/linux-kernel-nhs/commit/b29ba27a0ed672664071b4b345e63b62a419d31d
Signed-off-by: Zhang Heng <zhangheng@kylinos.cn>
Reported-by: CuerdOS Dev Team <cuerdoslinux@proton.me>
Signed-off-by: CuerdOS Dev Team <cuerdoslinux@proton.me>
Link: https://patch.msgid.link/20260730123920.104525-1-zhangheng@kylinos.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/yc/acp6x-mach.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/soc/amd/yc/acp6x-mach.c b/sound/soc/amd/yc/acp6x-mach.c
index 03735eec3af0f..85ef6dcbaa17d 100644
--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -675,6 +675,13 @@ static const struct dmi_system_id yc_acp_quirk_table[] = {
 			DMI_MATCH(DMI_BOARD_NAME, "8E35"),
 		}
 	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "HP"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Victus by HP Laptop 16-e1xxx"),
+		}
+	},
 	{
 		.driver_data = &acp6x_card,
 		.matches = {
-- 
2.53.0



