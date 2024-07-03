Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5499B1741C4;
	Wed,  3 Jul 2024 11:05:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720004729; cv=none; b=txDsfK480BRNlc9ykaBm35wL2H7Aedxlgv8TyZ4RXr/nwQ6A0wtM6WzhALWcuq6nZ4nsJI+4fPx/sQGuA0IjSJYclFZ0GRXJf+n+/YWg2RYAjA81Cuqhe2TJtjCBOpmsoTH0DLInNoxKrBtEmh+qG4Om3DwRRoWWy1przNf3OjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720004729; c=relaxed/simple;
	bh=r5llSuXW6fD0YsOwI7F/YOoHhB5E6/kYf2MTTJy7ynE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X3G+ZECTAjl2DoexI+VcJl2cuQKYiQUuC9IzCkOUTZ7wmadDBGPvs94ljQ28Xwe9oFL03u72YrUvYl2WlTcHTy+DRrxA8QC/+kZg0xBd+IbCmyjwXCH5QnDAK0fBJrA2MgleyZ/3mjG6KIQT2KJP6mkHHvz+80d7MBRQbjTh3WI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tEW1/TLw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tEW1/TLw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC68FC2BD10;
	Wed,  3 Jul 2024 11:05:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720004729;
	bh=r5llSuXW6fD0YsOwI7F/YOoHhB5E6/kYf2MTTJy7ynE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tEW1/TLwPfn10fHc7kCcIMQSYSeGcv7OgRjNF+sfSkpHT5soNo0FU9Fc88Zs5w/ND
	 jpKjy2lzQ8YDAHJllhn2QBYKQ3kin0KQVBd6M6KUG3jKBfSXjhbjteXlJduG64cZ0O
	 GvAZ+fETAaRyrDfRsQ21M9/zhHtrnUxwaCQOX+6U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 122/290] ASoC: Intel: sof_sdw: add JD2 quirk for HP Omen 14
Date: Wed,  3 Jul 2024 12:38:23 +0200
Message-ID: <20240703102908.798124489@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102904.170852981@linuxfoundation.org>
References: <20240703102904.170852981@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

[ Upstream commit 4fee07fbf47d2a5f1065d985459e5ce7bf7969f0 ]

The default JD1 does not seem to work, use JD2 instead.

Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20240411220347.131267-4-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/sof_sdw.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/sound/soc/intel/boards/sof_sdw.c b/sound/soc/intel/boards/sof_sdw.c
index f36a0fda1b6ae..25bf73a7e7bfa 100644
--- a/sound/soc/intel/boards/sof_sdw.c
+++ b/sound/soc/intel/boards/sof_sdw.c
@@ -216,6 +216,15 @@ static const struct dmi_system_id sof_sdw_quirk_table[] = {
 		},
 		.driver_data = (void *)(SOF_SDW_PCH_DMIC),
 	},
+	{
+		.callback = sof_sdw_quirk_cb,
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "HP"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "OMEN Transcend Gaming Laptop"),
+		},
+		.driver_data = (void *)(RT711_JD2),
+	},
+
 	/* LunarLake devices */
 	{
 		.callback = sof_sdw_quirk_cb,
-- 
2.43.0



