Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9AA02A1BA;
	Tue,  8 Jul 2025 16:33:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992435; cv=none; b=GTscp7car7JF05f/EImAkj9MvVBjWDeg4IN1daihNNlxpCCKMgzDwYnEPRzCM7DutYRyu067EFI2Zo1nQcpVoGOR+CtbZ6rvN51BogRrqcQSyrmQgJKAxjRCGKMgITsyEd5gBWxc82V+eNMTFnG53tjJOoFAhRUPC8gZx0VMmvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992435; c=relaxed/simple;
	bh=Sk10YMh7IGvxa5UhQoiR2x6BVURfUyM0Xc74MR4OV1Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TEShMvZFJ0OMLuWCHsK++cH1fR4G61XIE/f2DZg9q86EyIxquGSODknqMHDprSOptnME9EjSriMlIvxk4lFVjh0x5gAmNM8DAHOLnS0S4GxDbmz0qQemMdOp+6nHUX11YgNYukXatzYtZcu1INOJVYW40FXmHARJLw2COIBZ63g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v/46etRk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v/46etRk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42140C4CEED;
	Tue,  8 Jul 2025 16:33:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992435;
	bh=Sk10YMh7IGvxa5UhQoiR2x6BVURfUyM0Xc74MR4OV1Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v/46etRkENHOD3zSHxIaKoWVzfJfVLA28INIrWPxBdXbwuq21GCVLp3QnUOxUaAdE
	 ck/fFwUqAheSo2NJlv7zBSseO1sMhoONzRRmNDvvQP49ldGr/r09UGpXcCadr3xTgl
	 DLTmdTNkpDW0TaRyId068RV9e+6ar5d2w/xtvdi8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raven Black <ravenblack@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 091/132] ASoC: amd: yc: update quirk data for HP Victus
Date: Tue,  8 Jul 2025 18:23:22 +0200
Message-ID: <20250708162233.284295594@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162230.765762963@linuxfoundation.org>
References: <20250708162230.765762963@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Raven Black <ravenblack@gmail.com>

[ Upstream commit 13b86ea92ebf0fa587fbadfb8a60ca2e9993203f ]

Make the internal microphone work on HP Victus laptops.

Signed-off-by: Raven Black <ravenblack@gmail.com>
Link: https://patch.msgid.link/20250613-support-hp-victus-microphone-v1-1-bebc4c3a2041@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/yc/acp6x-mach.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/soc/amd/yc/acp6x-mach.c b/sound/soc/amd/yc/acp6x-mach.c
index 1547cf8b46b13..429e61d47ffbb 100644
--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -521,6 +521,13 @@ static const struct dmi_system_id yc_acp_quirk_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "OMEN by HP Gaming Laptop 16z-n000"),
 		}
 	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "HP"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Victus by HP Gaming Laptop 15-fb2xxx"),
+		}
+	},
 	{
 		.driver_data = &acp6x_card,
 		.matches = {
-- 
2.39.5



