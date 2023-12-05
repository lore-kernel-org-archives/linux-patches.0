Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EB686FB1;
	Tue,  5 Dec 2023 03:38:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pc0adegJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02289C433C7;
	Tue,  5 Dec 2023 03:38:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701747523;
	bh=XtiM4wFB4arNbEgf0AnXlltNRWxfWnNFTE4WsmmnCHo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pc0adegJlafCtxIz/EnGO08LfjhhW+JxAsUVZMD3MkMg5tp6BgOG8zXKTXMkEPuXl
	 O/vfDlOKbs9RUUiDvp8HnOtkb2DU/ZXiZgMyeRBhDnGqcB5q1tQABRL0TZP/WLSJ4L
	 zVCGBadM79SuDfx4+sbiGfxXSzvHVoP2snEUWtjY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 107/135] ASoC: SOF: sof-pci-dev: use community key on all Up boards
Date: Tue,  5 Dec 2023 12:17:08 +0900
Message-ID: <20231205031537.506669657@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031530.557782248@linuxfoundation.org>
References: <20231205031530.557782248@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

[ Upstream commit 405e52f412b85b581899f5e1b82d25a7c8959d89 ]

There are already 3 versions of the Up boards with support for the SOF
community key (ApolloLake, WhiskyLake, TigerLake). Rather than
continue to add quirks for each version, let's add a wildcard.

For WHL and TGL, the authentication supports both the SOF community
key and the firmware signed with the Intel production key. Given two
choices, the community key is the preferred option to allow developers
to sign their own firmware. The firmware signed with production key
can still be selected if needed with a kernel module
option (snd-sof-pci.fw_path="intel/sof")

Tested-by: Péter Ujfalusi <peter.ujfalusi@linux.intel.com>
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Péter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://lore.kernel.org/r/20211119231327.211946-1-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 7dd692217b86 ("ASoC: SOF: sof-pci-dev: Fix community key quirk detection")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/sof-pci-dev.c | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/sound/soc/sof/sof-pci-dev.c b/sound/soc/sof/sof-pci-dev.c
index fe9feaab6a0ac..571dc679ff7c1 100644
--- a/sound/soc/sof/sof-pci-dev.c
+++ b/sound/soc/sof/sof-pci-dev.c
@@ -59,17 +59,9 @@ static const struct dmi_system_id sof_tplg_table[] = {
 
 static const struct dmi_system_id community_key_platforms[] = {
 	{
-		.ident = "Up Squared",
+		.ident = "Up boards",
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "AAEON"),
-			DMI_MATCH(DMI_BOARD_NAME, "UP-APL01"),
-		}
-	},
-	{
-		.ident = "Up Extreme",
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "AAEON"),
-			DMI_MATCH(DMI_BOARD_NAME, "UP-WHL01"),
 		}
 	},
 	{
-- 
2.42.0



