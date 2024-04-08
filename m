Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E98C142046;
	Mon,  8 Apr 2024 13:33:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583230; cv=none; b=hdj9+S+0NMOCeZXLxJthtcwyKQKZ9DgO1mTwyeEcNslRn7GWnaRmYm3AL5UzEfIzEj0N5T0+rmfY24MOIIzgjn1vu4Fb9HYEC/h4Kn7RBgIdehVLQNUlmuBzt3LqLhICh52vu7QtRj27yLyzX86Yu8vDyIZLFGgvFsfUV39OimA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583230; c=relaxed/simple;
	bh=3HCpQYVREw9ReSFuXvksQW+ecotZ9Wf8neP5jorJEd8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jW8XqvkGngvCEpz6q1xny0xL304h9+YBf/Gq8bA4NNd2cIMiwUxav+d08ANBgEei8juOaH+Pqoh9yed7TCTwOqetpLJ5WMktnZl+Sxdh5ka2cxHDFoLKylLJngGibuwXXk/LCouk3PTpGrAUcMeOvoy13nzi8T1kogcS88B7gUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TQ8neMiQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TQ8neMiQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 703F6C433F1;
	Mon,  8 Apr 2024 13:33:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583229;
	bh=3HCpQYVREw9ReSFuXvksQW+ecotZ9Wf8neP5jorJEd8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TQ8neMiQjUIq+SeOCCoeZ/AMYLmNRCuo7gYLfBZSrygXl7brQ6zMkEGMb0M7MawRz
	 6nQgmeOI+b0zBGE8GnHyXSatYzsTXFKI+8sLZJMIxF/WIx6Aiu56XgCkRlyBrdzwGf
	 QYZWeS4fJKhpT8G7N3gwxvFYlVpOjSNQE7ewxneA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Trimmer <simont@opensource.cirrus.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 154/273] ALSA: hda: cs35l56: Add ACPI device match tables
Date: Mon,  8 Apr 2024 14:57:09 +0200
Message-ID: <20240408125314.060383154@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125309.280181634@linuxfoundation.org>
References: <20240408125309.280181634@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Simon Trimmer <simont@opensource.cirrus.com>

[ Upstream commit 2d0401ee38d43ab0e4cdd02dfc9d402befb2b5c8 ]

Adding the ACPI HIDs to the match table triggers the cs35l56-hda modules
to be loaded on boot so that Serial Multi Instantiate can add the
devices to the bus and begin the driver init sequence.

Signed-off-by: Simon Trimmer <simont@opensource.cirrus.com>
Fixes: 73cfbfa9caea ("ALSA: hda/cs35l56: Add driver for Cirrus Logic CS35L56 amplifier")
Message-ID: <20240328121355.18972-1-simont@opensource.cirrus.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/cs35l56_hda_i2c.c | 13 +++++++++++--
 sound/pci/hda/cs35l56_hda_spi.c | 13 +++++++++++--
 2 files changed, 22 insertions(+), 4 deletions(-)

diff --git a/sound/pci/hda/cs35l56_hda_i2c.c b/sound/pci/hda/cs35l56_hda_i2c.c
index a9ef6d86de839..09a810a50a12b 100644
--- a/sound/pci/hda/cs35l56_hda_i2c.c
+++ b/sound/pci/hda/cs35l56_hda_i2c.c
@@ -53,10 +53,19 @@ static const struct i2c_device_id cs35l56_hda_i2c_id[] = {
 	{}
 };
 
+static const struct acpi_device_id cs35l56_acpi_hda_match[] = {
+	{ "CSC3554", 0 },
+	{ "CSC3556", 0 },
+	{ "CSC3557", 0 },
+	{}
+};
+MODULE_DEVICE_TABLE(acpi, cs35l56_acpi_hda_match);
+
 static struct i2c_driver cs35l56_hda_i2c_driver = {
 	.driver = {
-		.name		= "cs35l56-hda",
-		.pm		= &cs35l56_hda_pm_ops,
+		.name		  = "cs35l56-hda",
+		.acpi_match_table = cs35l56_acpi_hda_match,
+		.pm		  = &cs35l56_hda_pm_ops,
 	},
 	.id_table	= cs35l56_hda_i2c_id,
 	.probe		= cs35l56_hda_i2c_probe,
diff --git a/sound/pci/hda/cs35l56_hda_spi.c b/sound/pci/hda/cs35l56_hda_spi.c
index 080426de90830..04f9fe6197dc5 100644
--- a/sound/pci/hda/cs35l56_hda_spi.c
+++ b/sound/pci/hda/cs35l56_hda_spi.c
@@ -53,10 +53,19 @@ static const struct spi_device_id cs35l56_hda_spi_id[] = {
 	{}
 };
 
+static const struct acpi_device_id cs35l56_acpi_hda_match[] = {
+	{ "CSC3554", 0 },
+	{ "CSC3556", 0 },
+	{ "CSC3557", 0 },
+	{}
+};
+MODULE_DEVICE_TABLE(acpi, cs35l56_acpi_hda_match);
+
 static struct spi_driver cs35l56_hda_spi_driver = {
 	.driver = {
-		.name		= "cs35l56-hda",
-		.pm		= &cs35l56_hda_pm_ops,
+		.name		  = "cs35l56-hda",
+		.acpi_match_table = cs35l56_acpi_hda_match,
+		.pm		  = &cs35l56_hda_pm_ops,
 	},
 	.id_table	= cs35l56_hda_spi_id,
 	.probe		= cs35l56_hda_spi_probe,
-- 
2.43.0



