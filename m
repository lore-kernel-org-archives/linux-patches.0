Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4769157A61;
	Tue, 23 Jul 2024 18:36:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721759801; cv=none; b=r35eQDUoQV/R5XyUTLSU7zI34rpiQxXVNM+WPBW56REjG96o5g8YRr+O7loZW9YPzYtnwsKGRQDV6Q42mx0VEWIX2nQCItcM5swd33ec3fCiPG7SIFVS0XGEtodlGy/JNhWZDpr9YPUTOij4sgAJwsYbCWcsR5K4saVA14dqvkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721759801; c=relaxed/simple;
	bh=g0+J7jJFjO/x163BM0p6EPm/gwY1+75CQzkiWlp1nvA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FegMso2MpAqSs2lFvJ+5fp/YUdbwaV2p5MTkUv3k6I3iktOwLvYOTvwxesjl4spXlopSGbg7jvj63dK4vGhxFeSXxofleR4cdWNcxVUvajTPvwXN6sDMe1qG9KYhtlOI6gcDxaKGUTBrNBSZQ+GrHHp6TSv4FdG+CrLjWd+FEa4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F6sej9GH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F6sej9GH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C31DC4AF09;
	Tue, 23 Jul 2024 18:36:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721759801;
	bh=g0+J7jJFjO/x163BM0p6EPm/gwY1+75CQzkiWlp1nvA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F6sej9GHAw1WeZlS0DZQXt5PiNLR4l9lOW1X9aaoxIOauFx5FKyPNIN7U8btDOgQ/
	 HnLxi548HDr4OBMWmzW9KPicAGpBV59/hIZweYgUKMIZMFsbVYC77LoleUPEwJPpOD
	 ra3P0gKnaAehrGZ3x5fc5g+NA8tFOf93jmIQURAc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vyacheslav Frantsishko <itmymaill@gmail.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 091/129] ASoC: amd: yc: Fix non-functional mic on ASUS M5602RA
Date: Tue, 23 Jul 2024 20:23:59 +0200
Message-ID: <20240723180408.302224849@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180404.759900207@linuxfoundation.org>
References: <20240723180404.759900207@linuxfoundation.org>
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

From: Vyacheslav Frantsishko <itmymaill@gmail.com>

[ Upstream commit 63b47f026cc841bd3d3438dd6fccbc394dfead87 ]

The Vivobook S 16X IPS needs a quirks-table entry for the internal microphone to function properly.

Signed-off-by: Vyacheslav Frantsishko <itmymaill@gmail.com>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://patch.msgid.link/20240626070334.45633-1-itmymaill@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/yc/acp6x-mach.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/soc/amd/yc/acp6x-mach.c b/sound/soc/amd/yc/acp6x-mach.c
index 1760b5d42460a..4e3a8ce690a45 100644
--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -283,6 +283,13 @@ static const struct dmi_system_id yc_acp_quirk_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "M5402RA"),
 		}
 	},
+        {
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "ASUSTeK COMPUTER INC."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "M5602RA"),
+		}
+	},
 	{
 		.driver_data = &acp6x_card,
 		.matches = {
-- 
2.43.0



