Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62A215F54E;
	Tue, 13 Feb 2024 17:32:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707845561; cv=none; b=Kvh5G+QWmEvEn2MSZZ0a+0nAokm6TuiRjuAlXqL6g1JXFrzfO/1d2dYIbLy9FRUXR1/YmDSc1CZJIZjYeWWaoMnlEjj/qSekt1WZY1lN5yxfBNgF3uLlzys9R0oN35pMMF00xCiO+6Q1bnSs369aIo4Hga7RRtbQRr3zBQn4q/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707845561; c=relaxed/simple;
	bh=BAovPU9nt+qNEmgcEoLqFL8c6x7SBF18DrxB4AvK7Fs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oNefmjfyTVjbgqR6RaM5Yi7Kgl9/hXu1CQ0C2z4EAujmvKVU+2INOQS8vdnW2RJcf2Tq/02xOo2sMBTqI11SKfcB0MiH5Jjwvp3hK33WI1wXhOcpe0vsY+U4IAQAafEYRLA2lGndUbNMSHe3NKgnEhGG5evmTwHPlQUHHks0mBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d0OGHhL0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d0OGHhL0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC288C433C7;
	Tue, 13 Feb 2024 17:32:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707845561;
	bh=BAovPU9nt+qNEmgcEoLqFL8c6x7SBF18DrxB4AvK7Fs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d0OGHhL01dYB42QGXvyVMY0UNeqypBHk5xvnztemTuSvOSlgC6oB0c+UL/gZh3E1y
	 E/VXXNWsQU3IYZfARgumn9OtKoOVleoIJwKobEjQMaxKnnYhLG3Rhsyum0m6NXAxLu
	 sRfWTPgBj1Sp1HKscnizlhVO6QDJTWTH0ESgTbR0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ted Chang <tedchang2010@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Venkata Prasad Potturu <venkataprasad.potturu@amd.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 115/121] Revert "ASoC: amd: Add new dmi entries for acp5x platform"
Date: Tue, 13 Feb 2024 18:22:04 +0100
Message-ID: <20240213171856.344243501@linuxfoundation.org>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <20240213171852.948844634@linuxfoundation.org>
References: <20240213171852.948844634@linuxfoundation.org>
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

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit c87011986fad043ce31a5e749f113540a179a73f which is
commit c3ab23a10771bbe06300e5374efa809789c65455 upstream.

Link: https://lore.kernel.org/r/CAD_nV8BG0t7US=+C28kQOR==712MPfZ9m-fuKksgoZCgrEByCw@mail.gmail.com
Reported-by: Ted Chang <tedchang2010@gmail.com>
Cc: Takashi Iwai <tiwai@suse.de>
Cc: Venkata Prasad Potturu <venkataprasad.potturu@amd.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/amd/acp-config.c |   15 +--------------
 1 file changed, 1 insertion(+), 14 deletions(-)

--- a/sound/soc/amd/acp-config.c
+++ b/sound/soc/amd/acp-config.c
@@ -3,7 +3,7 @@
 // This file is provided under a dual BSD/GPLv2 license. When using or
 // redistributing this file, you may do so under either license.
 //
-// Copyright(c) 2021, 2023 Advanced Micro Devices, Inc.
+// Copyright(c) 2021 Advanced Micro Devices, Inc.
 //
 // Authors: Ajit Kumar Pandey <AjitKumar.Pandey@amd.com>
 //
@@ -45,19 +45,6 @@ static const struct config_entry config_
 				},
 			},
 			{}
-		},
-	},
-	{
-		.flags = FLAG_AMD_LEGACY,
-		.device = ACP_PCI_DEV_ID,
-		.dmi_table = (const struct dmi_system_id []) {
-			{
-				.matches = {
-					DMI_MATCH(DMI_SYS_VENDOR, "Valve"),
-					DMI_MATCH(DMI_PRODUCT_NAME, "Jupiter"),
-				},
-			},
-			{}
 		},
 	},
 	{


