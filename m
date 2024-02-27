Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 305F4145B24;
	Tue, 27 Feb 2024 13:30:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709040620; cv=none; b=EzXTDZNkmqdaaBTz7MWOPSjuqX2hnFHYlJLPRpvkDJQyjadeFvt/S+uDk8z9PT0lg/2A/S7XlPLhvL5VDz7iWgdJq4W7SeSOaKwF6hTce40Iz0XtSkFtrM+uyFurQ0TzURnBhKosbS9hFdyUY7zozaEO85MC/h55yiTB/2mTFHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709040620; c=relaxed/simple;
	bh=gXFfDRicLDZS/HTPalYSX6AcPAg+OlEhb7VNc3KFPXI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PPXy8sRg7m3uFi5L8k4uXYxyUOkJvtxKaYuvNEzcwLI5wnHNYjbSwc7eMsCCdmMuruU93hQ5HQhoWG+R/aOY1Sf3r5Xiqp2tb7cT4Yi+QnOiRWDXj2u0zY70MQXTB4lnSAog4x+ORosiSqbxAC7nkrYcdl41Io0MjwhdIbtVjU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ugAlbXX+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ugAlbXX+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5278EC43390;
	Tue, 27 Feb 2024 13:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709040619;
	bh=gXFfDRicLDZS/HTPalYSX6AcPAg+OlEhb7VNc3KFPXI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ugAlbXX+fbZz5S6eHfdtDvEdk0jUKK3Gve6FVMDQf8Ju5ZdMHsBDIKv5TvZri83yd
	 W+EmKUVCXD/2eGjWESPq6bxmYNNVAk7SpRe4zAkI/LGYkqCyPLjeH0CR0EIo9C36UE
	 afRx5HDSZ/5fPJfg7vxqSglLZvzwXQz4/tDUyRWU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kenzo Gomez <kenzo.sgomez@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 049/334] ALSA: hda: cs35l41: Support additional ASUS Zenbook UX3402VA
Date: Tue, 27 Feb 2024 14:18:27 +0100
Message-ID: <20240227131632.167617349@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
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

From: Kenzo Gomez <kenzo.sgomez@gmail.com>

[ Upstream commit c16dfab33f99fc3ff43d48253bc2784ccb84c1de ]

Add new model entry into configuration table.

Signed-off-by: Kenzo Gomez <kenzo.sgomez@gmail.com>
Link: https://lore.kernel.org/r/20240127164621.26431-1-kenzo.sgomez@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/cs35l41_hda_property.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/pci/hda/cs35l41_hda_property.c b/sound/pci/hda/cs35l41_hda_property.c
index 35277ce890a46..59504852adc69 100644
--- a/sound/pci/hda/cs35l41_hda_property.c
+++ b/sound/pci/hda/cs35l41_hda_property.c
@@ -76,6 +76,7 @@ static const struct cs35l41_config cs35l41_config_table[] = {
 	{ "10431533", 2, INTERNAL, { CS35L41_LEFT, CS35L41_RIGHT, 0, 0 }, 0, 1, -1, 1000, 4500, 24 },
 	{ "10431573", 2, INTERNAL, { CS35L41_LEFT, CS35L41_RIGHT, 0, 0 }, 1, 2, 0, 1000, 4500, 24 },
 	{ "10431663", 2, INTERNAL, { CS35L41_LEFT, CS35L41_RIGHT, 0, 0 }, 1, -1, 0, 1000, 4500, 24 },
+	{ "104316A3", 2, EXTERNAL, { CS35L41_LEFT, CS35L41_RIGHT, 0, 0 }, 1, 2, 0, 0, 0, 0 },
 	{ "104316D3", 2, EXTERNAL, { CS35L41_LEFT, CS35L41_RIGHT, 0, 0 }, 1, 2, 0, 0, 0, 0 },
 	{ "104316F3", 2, EXTERNAL, { CS35L41_LEFT, CS35L41_RIGHT, 0, 0 }, 1, 2, 0, 0, 0, 0 },
 	{ "104317F3", 2, INTERNAL, { CS35L41_LEFT, CS35L41_RIGHT, 0, 0 }, 0, 1, -1, 1000, 4500, 24 },
@@ -410,6 +411,7 @@ static const struct cs35l41_prop_model cs35l41_prop_model_table[] = {
 	{ "CSC3551", "10431533", generic_dsd_config },
 	{ "CSC3551", "10431573", generic_dsd_config },
 	{ "CSC3551", "10431663", generic_dsd_config },
+	{ "CSC3551", "104316A3", generic_dsd_config },
 	{ "CSC3551", "104316D3", generic_dsd_config },
 	{ "CSC3551", "104316F3", generic_dsd_config },
 	{ "CSC3551", "104317F3", generic_dsd_config },
-- 
2.43.0



