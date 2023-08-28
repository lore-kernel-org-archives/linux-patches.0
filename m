Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1725811C83
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 10:19:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BABCC433C7;
	Mon, 28 Aug 2023 10:19:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693217977;
	bh=pvtc7lN47pImJWuWI54srE3V6jwxyjQuheebtRU+pzM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bY+yTCPQE6SNTn4MrUyN9iX3W4+y2+Qjuw+3sfkO7e68Y1SN7DrXXHxD3PAXOjEXT
	 oiUnLhJwQxC0A2pSGaynpLq6KDTl2mzcssleMdDxhCWnosbK5RbSBX6kkB+GJgN854
	 2TCQ5a4ktguMrpqGYjXamUlk3+XgHE12SmIEK+ig=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	BrenoRCBrito <brenorcbrito@gmail.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.4 051/129] ASoC: amd: yc: Add VivoBook Pro 15 to quirks list for acp6x
Date: Mon, 28 Aug 2023 12:12:10 +0200
Message-ID: <20230828101159.076249284@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230828101157.383363777@linuxfoundation.org>
References: <20230828101157.383363777@linuxfoundation.org>
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

6.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: BrenoRCBrito <brenorcbrito@gmail.com>

commit 3b1f08833c45d0167741e4097b0150e7cf086102 upstream.

VivoBook Pro 15 Ryzen Edition uses Ryzen 6800H processor, and adding to
 quirks list for acp6x will enable internal mic.

Signed-off-by: BrenoRCBrito <brenorcbrito@gmail.com>
Link: https://lore.kernel.org/r/20230818211417.32167-1-brenorcbrito@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/amd/yc/acp6x-mach.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -251,6 +251,13 @@ static const struct dmi_system_id yc_acp
 	{
 		.driver_data = &acp6x_card,
 		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "ASUSTeK COMPUTER INC."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "M6500RC"),
+		}
+	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
 			DMI_MATCH(DMI_BOARD_VENDOR, "Alienware"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "Alienware m17 R5 AMD"),
 		}


