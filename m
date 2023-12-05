Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88D0F6AC2;
	Tue,  5 Dec 2023 03:42:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o2gxRoEC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA6BBC433C7;
	Tue,  5 Dec 2023 03:42:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701747747;
	bh=Uwufbe2ELrcvHV3Q9D0OgKzxlbkxNglPJSFLqWbmztI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o2gxRoECJEUR8hi6vgsacEX5/3hFuM599wv/VyC+E5UN3q+SZWOAwB8ed9Ax1KzYw
	 m3BwFCmG+nbx8vwTTfbEno8CAqxzVNEOSyUL1T4qiR18fyaLRKOXwPPMU1yY41DS/7
	 ArKZLyU18fP2HeOPWeF030ZGSiae4dsDh6maiPTU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 53/67] ASoC: SOF: sof-pci-dev: use community key on all Up boards
Date: Tue,  5 Dec 2023 12:17:38 +0900
Message-ID: <20231205031522.919009133@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031519.853779502@linuxfoundation.org>
References: <20231205031519.853779502@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 3b4c011e02834..c1cd156996b43 100644
--- a/sound/soc/sof/sof-pci-dev.c
+++ b/sound/soc/sof/sof-pci-dev.c
@@ -64,17 +64,9 @@ static const struct dmi_system_id sof_tplg_table[] = {
 
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



