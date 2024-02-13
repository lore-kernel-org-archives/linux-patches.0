Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B23725FBB5;
	Tue, 13 Feb 2024 17:26:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707845164; cv=none; b=QlDsQycLtfDHOtawCKzAv3rrFDAULto0Q653md2Fjrwp17ZqQaW4K9xdW1z2l7r6a1v44L2MnqQ/vWR826belVbnzXADl1mQErA4AjE5Khy/YE6w6Gb9QUmNhFBFtj7F6loSEZ4SFz/wCJ4FWxW6frL3JMI+pbiLw22mEaPI+0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707845164; c=relaxed/simple;
	bh=m4aqpmSgiBFt2gb/qZXXOWcCOl4kyjx9afM2Duz8TH4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LFUj5XIQK/QSVVt/2DOSKnEK9Z9rP356SA9jKeBoV/AWXHIqoY70ilztUvgq8hjctTldorHgnBaZRZE/I5+dOLUQ51TQ5wond7AqEm/LpuVE4dysyDd/qWXhKC/p277czuzDemiczW/XKS1eLPWhS3aW3oFlyiCGEWU4lSDw814=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NIUFV0WE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NIUFV0WE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 118BCC433C7;
	Tue, 13 Feb 2024 17:26:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707845164;
	bh=m4aqpmSgiBFt2gb/qZXXOWcCOl4kyjx9afM2Duz8TH4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NIUFV0WEV29JEUWnRo54dU/c3GIl4Yfo33QPpbft+yRl6w2i8owx7fdehYxPtvKc5
	 GNfOWJ+zTN7WVC5SMVpJoGhEplegm4vydDpy5B3cKKHf4nFYpDrR/FmwLg9hoAaAgP
	 uww45U3E/sFhMpDDWb1MXlNXTWIMGalhjuhn8fZY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ted Chang <tedchang2010@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Venkata Prasad Potturu <venkataprasad.potturu@amd.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 59/64] Revert "ASoC: amd: Add new dmi entries for acp5x platform"
Date: Tue, 13 Feb 2024 18:21:45 +0100
Message-ID: <20240213171846.592477759@linuxfoundation.org>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <20240213171844.702064831@linuxfoundation.org>
References: <20240213171844.702064831@linuxfoundation.org>
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

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit 48ad42cd95acc2da22b38497f22d53cb433863a1 which is
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
@@ -33,19 +33,6 @@ static const struct config_entry config_
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


