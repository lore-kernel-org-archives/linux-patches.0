Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 721BC17B515;
	Fri, 27 Sep 2024 12:29:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727440153; cv=none; b=YVjm5oy2tZd5PptluR6DL0rEc80iB57c8gu8xJnzmD93/3rIF7dqYXgpKJJh86D38M7gYaTu9i8WCIX8tJR26DLv1euJKw3C+VgUvavR6xDWsvH/weSbSStt4A6vhjq/Qq6pHQFfHD5BGTPsSi4VutIdQN1HNEH5oJQA1agz02U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727440153; c=relaxed/simple;
	bh=h1p6pJTNwNk4Zep2qW4Qn4/uMI48+3Dx+rozGP/zgGQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cQmQ/niUCyYNq8L2rDrhnJtsJRIZP/HcdVSs7eNk0QO+LYaduLwr5UN5Lj7WWgfbnSs/avdlO0YAPSkyJ79Uh+IFCL4kYsw+/Iu80UqWRecvdVSmv1FYJiU9tnGg/4RE+e1eadrZg5ADA6wmD89FnmkN5IDgogoCuwJ2rf8V5Bw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j8iMOE7t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j8iMOE7t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00850C4CEC4;
	Fri, 27 Sep 2024 12:29:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727440153;
	bh=h1p6pJTNwNk4Zep2qW4Qn4/uMI48+3Dx+rozGP/zgGQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j8iMOE7tURC/UnmVWVRWAnbJYP46oOIkCHPXhCLOUrSwUASftyOOIN1gypjSw5lFy
	 XcC/knOjhX64CMKzNINvrZOWF7vF9JvTFqbUJC079x7TqBcTvAaaCtiUerPn2UVoau
	 8DnhIf9f2HhvRM0RslAAaiN/Hu9hruxAOIulYRPI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 25/58] ASoC: Intel: soc-acpi-cht: Make Lenovo Yoga Tab 3 X90F DMI match less strict
Date: Fri, 27 Sep 2024 14:23:27 +0200
Message-ID: <20240927121719.821917295@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20240927121718.789211866@linuxfoundation.org>
References: <20240927121718.789211866@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 839a4ec06f75cec8fec2cc5fc14e921d0c3f7369 ]

There are 2G and 4G RAM versions of the Lenovo Yoga Tab 3 X90F and it
turns out that the 2G version has a DMI product name of
"CHERRYVIEW D1 PLATFORM" where as the 4G version has
"CHERRYVIEW C0 PLATFORM". The sys-vendor + product-version check are
unique enough that the product-name check is not necessary.

Drop the product-name check so that the existing DMI match for the 4G
RAM version also matches the 2G RAM version.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://patch.msgid.link/20240823074305.16873-1-hdegoede@redhat.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/common/soc-acpi-intel-cht-match.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/sound/soc/intel/common/soc-acpi-intel-cht-match.c b/sound/soc/intel/common/soc-acpi-intel-cht-match.c
index 5e2ec60e2954b..e4c3492a0c282 100644
--- a/sound/soc/intel/common/soc-acpi-intel-cht-match.c
+++ b/sound/soc/intel/common/soc-acpi-intel-cht-match.c
@@ -84,7 +84,6 @@ static const struct dmi_system_id lenovo_yoga_tab3_x90[] = {
 		/* Lenovo Yoga Tab 3 Pro YT3-X90, codec missing from DSDT */
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "Intel Corporation"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "CHERRYVIEW D1 PLATFORM"),
 			DMI_MATCH(DMI_PRODUCT_VERSION, "Blade3-10A-001"),
 		},
 	},
-- 
2.43.0



