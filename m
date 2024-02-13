Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CC5BA93C;
	Tue, 13 Feb 2024 17:40:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707846046; cv=none; b=XgaqOVc+LWFGQoK+UwAqYzXQqmR7bV7KnO+vauJoTQFrz/JXQcIzMWAUCNrqjwkp7PXcT8KiFfF5jTDZtIJ8FbTqHV2kYtPsQACH3p0aUsLqeOkBcArSA7knmdqvLrQy1/JC0m8EhuAiks1ionZ/+xV8tBJxjwh3qhJWeQaBHos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707846046; c=relaxed/simple;
	bh=c7lK6giwbSvg096fPclawhJGMosqt10/NGyHPh9+YwQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H4OX1I70xug94N7u/2po5lY7frb98V+lTRJNyJFHn9OMpO442AlODWqvUIYKK2aenob0QSRX0Dn2PngVqZs3YzDyvENELILQBmZIlvgSx5vuTvTLaS8OElk9gX/TsE1zxlY0DS3Hs6ZWhWRaqt4dvwjzy5xESVPNBcfXaVkR0xA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2EInz9aB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2EInz9aB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E5CEC433C7;
	Tue, 13 Feb 2024 17:40:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707846046;
	bh=c7lK6giwbSvg096fPclawhJGMosqt10/NGyHPh9+YwQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2EInz9aBlHOhm6VLBeYAwHhLVH9mtHnyTL8aP4Nb+y4Tn57wpNosTT03xpAKnqVRB
	 YeoJIq/MAtJp8dcGzVqmNeEdPSBI4dmihuXlkZMVpY5644HmpwpPTwrZb285ftoJdQ
	 gn+ZaEfhjROMFeVKa1LpOrrs8SToKegBFheJC2dM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ted Chang <tedchang2010@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Venkata Prasad Potturu <venkataprasad.potturu@amd.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 121/124] Revert "ASoC: amd: Add new dmi entries for acp5x platform"
Date: Tue, 13 Feb 2024 18:22:23 +0100
Message-ID: <20240213171857.262054284@linuxfoundation.org>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <20240213171853.722912593@linuxfoundation.org>
References: <20240213171853.722912593@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit 4b6986b170f2f23e390bbd2d50784caa9cb67093 which is
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


