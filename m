Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1CDD2550DD;
	Mon, 23 Jun 2025 13:28:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685301; cv=none; b=UvMH6bLasDu8l8dSPDARG+o3wgcqVULBOWuiPjRdfzIWZEW2FMvvsV7QyFdrkX+IYourvslyH1aLQQy3nQWDJW3nNfmpJJDluheQOqSb9CVamWr7Ud0OWtLxRja8dIUCxbiuuPR+n8QwwX7LCyRxcpVUx9sFjWh7dMCA5d2azUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685301; c=relaxed/simple;
	bh=2SbrJChU862i8Aoshx6Bgzkry4xn94hl9mec2dT6nSQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OLp80rgzoO38XMG391KcUfuRdG9UmaRVhXln4wmvH113TQ9UMksLKMTe6WIisWNCRffEEHQokyrfpFtn7TFUqVKqXUw8oYCg2K/MY9BunED+xUE57Kx5kLDq4NMhIogXj52d16K33Lk8LSzk+ZGXhBi8S0p2EalDy6XtrqNpzb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=js+55BAB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="js+55BAB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 776D0C4CEEA;
	Mon, 23 Jun 2025 13:28:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685300;
	bh=2SbrJChU862i8Aoshx6Bgzkry4xn94hl9mec2dT6nSQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=js+55BABNJ54Li3mic57wjbgQDS8prIoSqVcq/F/hJZ4KpmRsjC8kJp8sFhfg7zYn
	 rOOtuf3qSDQkak2puaW3P3JHnl/sRLjbdqKR3O1LKRTijuDTVupTmGq4bq+IZ9ygyJ
	 MRIxCg5XrUGqwNLip4RxorkVNKd2zLMX7nGUEI3o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Binding <sbinding@opensource.cirrus.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 222/592] ALSA: hda: cs35l41: Fix swapped l/r audio channels for Acer Helios laptops
Date: Mon, 23 Jun 2025 15:03:00 +0200
Message-ID: <20250623130705.571712809@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Binding <sbinding@opensource.cirrus.com>

[ Upstream commit e43a93c41982e82c1b703dd7fa9c1d965260fbb3 ]

Fixes audio channel assignment from ACPI using configuration table.

Signed-off-by: Stefan Binding <sbinding@opensource.cirrus.com>
Link: https://patch.msgid.link/20250515162848.405055-3-sbinding@opensource.cirrus.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/cs35l41_hda_property.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/sound/pci/hda/cs35l41_hda_property.c b/sound/pci/hda/cs35l41_hda_property.c
index 61d2314834e7b..d8249d997c2a0 100644
--- a/sound/pci/hda/cs35l41_hda_property.c
+++ b/sound/pci/hda/cs35l41_hda_property.c
@@ -31,6 +31,9 @@ struct cs35l41_config {
 };
 
 static const struct cs35l41_config cs35l41_config_table[] = {
+	{ "10251826", 2, EXTERNAL, { CS35L41_LEFT, CS35L41_RIGHT, 0, 0 }, 0, -1, -1, 0, 0, 0 },
+	{ "1025182C", 2, EXTERNAL, { CS35L41_LEFT, CS35L41_RIGHT, 0, 0 }, 0, -1, -1, 0, 0, 0 },
+	{ "10251844", 2, EXTERNAL, { CS35L41_LEFT, CS35L41_RIGHT, 0, 0 }, 0, -1, -1, 0, 0, 0 },
 	{ "10280B27", 2, INTERNAL, { CS35L41_LEFT, CS35L41_RIGHT, 0, 0 }, 1, 2, 0, 1000, 4500, 24 },
 	{ "10280B28", 2, INTERNAL, { CS35L41_LEFT, CS35L41_RIGHT, 0, 0 }, 1, 2, 0, 1000, 4500, 24 },
 	{ "10280BEB", 2, EXTERNAL, { CS35L41_LEFT, CS35L41_RIGHT, 0, 0 }, 1, -1, 0, 0, 0, 0 },
@@ -452,6 +455,9 @@ struct cs35l41_prop_model {
 static const struct cs35l41_prop_model cs35l41_prop_model_table[] = {
 	{ "CLSA0100", NULL, lenovo_legion_no_acpi },
 	{ "CLSA0101", NULL, lenovo_legion_no_acpi },
+	{ "CSC3551", "10251826", generic_dsd_config },
+	{ "CSC3551", "1025182C", generic_dsd_config },
+	{ "CSC3551", "10251844", generic_dsd_config },
 	{ "CSC3551", "10280B27", generic_dsd_config },
 	{ "CSC3551", "10280B28", generic_dsd_config },
 	{ "CSC3551", "10280BEB", generic_dsd_config },
-- 
2.39.5



