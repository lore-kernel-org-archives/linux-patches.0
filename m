Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E7E910A21;
	Sat,  3 Feb 2024 04:17:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933862; cv=none; b=SHKLUl9BYupdT/iFXyuFhbUWHosDYotCgzirCewj5rO6evp9iLc7NtkNuNTI+apuY1L+ltnXQfxfGhHBQa+Jyyjh7eefmOWAJxhx18t6U1Wm4ySSnrvIXozPVj04Hpd8f0zv7YTlw2KGvSMui9e2BHvoKno6PfmrXpGPC6eQvGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933862; c=relaxed/simple;
	bh=afhcPCyJfPv1Psz4hC5ljCviksq04LEtkXIlEltNPHE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=trkSGFvWWTqjifvbACzSRiHS9tgD84DKEWOjyIsIwB5TEGLJs+7mqR0A7Q8Va5gp23j6Ru99l4DVvhktU1DyWigJV31WhQ8SLbDM+5fPzNoZ8pgY+o0wM/3PT7NyOP3HiAokKXeLfW6w+QVM/qlOpL3jlkeUntzE2udLLd1MMAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eJRdeP1q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eJRdeP1q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06FF6C433C7;
	Sat,  3 Feb 2024 04:17:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933862;
	bh=afhcPCyJfPv1Psz4hC5ljCviksq04LEtkXIlEltNPHE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eJRdeP1qQPdl8GRenriw1xSjM/TywRcijQNFfRMniNh7CMqrhE7TlDVZRznNDs5Xe
	 sxu/ySi1+zWucAb/JAp9nBMp1FauUOv0dYVvc00Qf/24sAf0/sPG2F4holvHSfwO3r
	 y78wtFIwaAWfjrhp5QKU5piv6qZGEAYLYn/usnaQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Venkata Prasad Potturu <venkataprasad.potturu@amd.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 173/353] ASoC: amd: Add new dmi entries for acp5x platform
Date: Fri,  2 Feb 2024 20:04:51 -0800
Message-ID: <20240203035409.111769949@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
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
index 3bc4b2e41650..dea6d367b9e8 100644
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
@@ -47,6 +47,19 @@ static const struct config_entry config_table[] = {
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



