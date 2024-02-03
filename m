Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDD80FC11;
	Sat,  3 Feb 2024 04:09:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933397; cv=none; b=AjMj7kXSiUEnmIaI6LWzBX2UVm5JYAFRNszigqJsnR1538yNd8Tfk4uuBpqBZQIrk2AFs2Q7hJpzsFc0MLx8wOyZT+b3W4d3uI3RNZ6e6PWKZspZeKtvf++pUeHUPxKrR08L+l9bOTrFe1tFavZSTCCBuggkFEQe6gOI3Uff8qU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933397; c=relaxed/simple;
	bh=9UvlZR4TiWv0f6inN0KqdjrUMJ0iEg82ZO3e4rlPhYc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DCFffGvt0AwGXnNnxlbSXPAWjUleFA0OUQ7tp8e5Ow4j9SxXDieAtaWStlecQ6Oq6zbOC/lhCdqatW8SZEWryg2AF5Cg68FnHilNDR/MPyTtLLJE2sk0SNY1BX9kXuDeoRGUMYINh/4ygYNcb9wcU7VBmKcRXl6uyWSIIzqp8Tk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Du3ZhBfY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Du3ZhBfY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30401C433C7;
	Sat,  3 Feb 2024 04:09:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933397;
	bh=9UvlZR4TiWv0f6inN0KqdjrUMJ0iEg82ZO3e4rlPhYc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Du3ZhBfYiVVxNO6zKxG/1KJ1+/w2wgNxFjLoAVYxm3gaK+SMaXCRVUKTXdbVXjNcH
	 k2R7YmaGNLCHB1Az4Yv530e+h4OzJc9D8nkBvDEy+sNFjY2naA894JqVGq0g8ptUve
	 sGkra/oPms/B7AhJ8uEcefFU3ovbn2MJVADo7jl8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Venkata Prasad Potturu <venkataprasad.potturu@amd.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 113/219] ASoC: amd: Add new dmi entries for acp5x platform
Date: Fri,  2 Feb 2024 20:04:46 -0800
Message-ID: <20240203035333.262615997@linuxfoundation.org>
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

From: Venkata Prasad Potturu <venkataprasad.potturu@amd.com>

[ Upstream commit c3ab23a10771bbe06300e5374efa809789c65455 ]

Add sys_vendor and product_name dmi entries for acp5x platform.

Signed-off-by: Venkata Prasad Potturu <venkataprasad.potturu@amd.com>
Link: https://lore.kernel.org/r/20231206110620.1695591-1-venkataprasad.potturu@amd.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/acp-config.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/sound/soc/amd/acp-config.c b/sound/soc/amd/acp-config.c
index 0932473b6394..9ee71a99a087 100644
--- a/sound/soc/amd/acp-config.c
+++ b/sound/soc/amd/acp-config.c
@@ -3,7 +3,7 @@
 // This file is provided under a dual BSD/GPLv2 license. When using or
 // redistributing this file, you may do so under either license.
 //
-// Copyright(c) 2021 Advanced Micro Devices, Inc.
+// Copyright(c) 2021, 2023 Advanced Micro Devices, Inc.
 //
 // Authors: Ajit Kumar Pandey <AjitKumar.Pandey@amd.com>
 //
@@ -35,6 +35,19 @@ static const struct config_entry config_table[] = {
 			{}
 		},
 	},
+	{
+		.flags = FLAG_AMD_LEGACY,
+		.device = ACP_PCI_DEV_ID,
+		.dmi_table = (const struct dmi_system_id []) {
+			{
+				.matches = {
+					DMI_MATCH(DMI_SYS_VENDOR, "Valve"),
+					DMI_MATCH(DMI_PRODUCT_NAME, "Jupiter"),
+				},
+			},
+			{}
+		},
+	},
 	{
 		.flags = FLAG_AMD_SOF,
 		.device = ACP_PCI_DEV_ID,
-- 
2.43.0



