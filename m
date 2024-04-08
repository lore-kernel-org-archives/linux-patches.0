Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B162F7D09F;
	Mon,  8 Apr 2024 13:36:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583366; cv=none; b=OZYFTemDFwN65NDiMdFzMTXw5hEHcZvaGJx4RSHODdt21bxjt7IyW2rCNBIsujCp3UiPeSDLJg3p1Tr15W6wLMRcfhJrQxm7CGY7PSGkiQVZoXxOG7vhlimsdq1coZfX6F4BC4tK81pcOa5lX3Z1E+KFolpwWQz9lWJyLJFP5to=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583366; c=relaxed/simple;
	bh=v9Yyugpl5ZGZ6XRnT9lsWxmTVQ+yP7RjTNwrcj0p7tU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mqoCxBE+P5kyGeexjY5PWPzvNLF9YCmtBPgI1ozDXQFUB8aQO9davSlrHMlgZRyFHCQcYfiNDuc4NCTiC8l+WxOLR0bm7JgBnqj9X4PPxbHOurnpqGAvVS2DXj+ahXKvOEqdRmZpialUiJJiLXKiXU1j0OTPs+lef17szYkQ0VE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s4y4sot4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s4y4sot4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A963C433C7;
	Mon,  8 Apr 2024 13:36:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583366;
	bh=v9Yyugpl5ZGZ6XRnT9lsWxmTVQ+yP7RjTNwrcj0p7tU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s4y4sot467lkNlpcED1bWHHZ2KQKz7oNGPAzW1oDqxBLI7hkvncxiyPHLxLf+E5j9
	 j8vGdoVHcxs74k4Z7EMHJJPJoIBrr+aYJZ9oUDbp8C69YLVLANZrij40/mdw00h2t3
	 99HBRfBW+hzvgYGclx0/jeG/clKd87QJtbF2uOW4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Trimmer <simont@opensource.cirrus.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 164/252] ALSA: hda: cs35l56: Add ACPI device match tables
Date: Mon,  8 Apr 2024 14:57:43 +0200
Message-ID: <20240408125311.740628407@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125306.643546457@linuxfoundation.org>
References: <20240408125306.643546457@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 757a4d193e0fb..c31f60b0421e5 100644
--- a/sound/pci/hda/cs35l56_hda_i2c.c
+++ b/sound/pci/hda/cs35l56_hda_i2c.c
@@ -49,10 +49,19 @@ static const struct i2c_device_id cs35l56_hda_i2c_id[] = {
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
index 756aec342eab7..52c9e04b3c55f 100644
--- a/sound/pci/hda/cs35l56_hda_spi.c
+++ b/sound/pci/hda/cs35l56_hda_spi.c
@@ -49,10 +49,19 @@ static const struct spi_device_id cs35l56_hda_spi_id[] = {
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



