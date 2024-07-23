Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB64D13D600;
	Tue, 23 Jul 2024 18:40:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721760051; cv=none; b=ikPHO+Rbn9Tr0QLdMHNg90QhHObn4osOn+E8X/yo8UKWrMOW0OaSw6Kx24RxIyvEEmAOhVGanoDBFNFvuHImWPLtrcIpcoRYQAJ4vRoUzV0ZB2uLKV90kcwklRNLxeMg7lg8mtDeFee/R9M36/cDzDwzdu6Jru6pdcrjAGuUhYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721760051; c=relaxed/simple;
	bh=iIXzWbgeWj70E8lpCvoFF6bQLniZ1vgCwOyGbBOOu6k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j/v+4Bub+mB4+7GSBYgWPw9BIDBsSgXsd9Hz36pJGPeUAm7gd/7dswIJkErAEmZoCPAOmlVqhB0fxURvdUo6kypa+vJ7ipjqsabXTOBdmeNqHeBWlZe8aOut/4iB07PIxFod4OiX7fXp7lv/dOQonU1otgo1NNQrvfBKqmTdurw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t93Cmeyz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t93Cmeyz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73326C4AF09;
	Tue, 23 Jul 2024 18:40:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721760050;
	bh=iIXzWbgeWj70E8lpCvoFF6bQLniZ1vgCwOyGbBOOu6k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t93CmeyzL1dVqOQsR3qi/XCHMRuGONHpA47OCOIhMjysK40AW966Drcn06xQKFQSA
	 J50PED+RqLPZS3B9/SLs9fhLirYbWhoSugC1Hl63h4aLMfm4/3wGAjZ0UJetnkxHye
	 mT7UbcFynR4m2or2H966aJoqoSij8RjcILSbucw0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Binding <sbinding@opensource.cirrus.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 069/163] ALSA: hda: cs35l41: Support Lenovo Thinkbook 13x Gen 4
Date: Tue, 23 Jul 2024 20:23:18 +0200
Message-ID: <20240723180146.135372160@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180143.461739294@linuxfoundation.org>
References: <20240723180143.461739294@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Binding <sbinding@opensource.cirrus.com>

[ Upstream commit b32f92d1af3789038f03c2899e3be0d00b43faf2 ]

This laptop does not contain _DSD so needs to be supported using the
configuration table.

Signed-off-by: Stefan Binding <sbinding@opensource.cirrus.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://lore.kernel.org/r/20240606130351.333495-3-sbinding@opensource.cirrus.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/cs35l41_hda_property.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/sound/pci/hda/cs35l41_hda_property.c b/sound/pci/hda/cs35l41_hda_property.c
index e034828df4452..6ad6cb176d43a 100644
--- a/sound/pci/hda/cs35l41_hda_property.c
+++ b/sound/pci/hda/cs35l41_hda_property.c
@@ -118,6 +118,8 @@ static const struct cs35l41_config cs35l41_config_table[] = {
 	{ "17AA38B5", 2, EXTERNAL, { CS35L41_LEFT, CS35L41_RIGHT, 0, 0 }, 0, 1, -1, 0, 0, 0 },
 	{ "17AA38B6", 2, EXTERNAL, { CS35L41_LEFT, CS35L41_RIGHT, 0, 0 }, 0, 1, -1, 0, 0, 0 },
 	{ "17AA38B7", 2, EXTERNAL, { CS35L41_LEFT, CS35L41_RIGHT, 0, 0 }, 0, 1, -1, 0, 0, 0 },
+	{ "17AA38C7", 4, INTERNAL, { CS35L41_LEFT, CS35L41_RIGHT, CS35L41_LEFT, CS35L41_RIGHT }, 0, 2, -1, 1000, 4500, 24 },
+	{ "17AA38C8", 4, INTERNAL, { CS35L41_LEFT, CS35L41_RIGHT, CS35L41_LEFT, CS35L41_RIGHT }, 0, 2, -1, 1000, 4500, 24 },
 	{ "17AA38F9", 2, EXTERNAL, { CS35L41_RIGHT, CS35L41_LEFT, 0, 0 }, 0, 2, -1, 0, 0, 0 },
 	{ "17AA38FA", 2, EXTERNAL, { CS35L41_RIGHT, CS35L41_LEFT, 0, 0 }, 0, 2, -1, 0, 0, 0 },
 	{}
@@ -511,6 +513,8 @@ static const struct cs35l41_prop_model cs35l41_prop_model_table[] = {
 	{ "CSC3551", "17AA38B5", generic_dsd_config },
 	{ "CSC3551", "17AA38B6", generic_dsd_config },
 	{ "CSC3551", "17AA38B7", generic_dsd_config },
+	{ "CSC3551", "17AA38C7", generic_dsd_config },
+	{ "CSC3551", "17AA38C8", generic_dsd_config },
 	{ "CSC3551", "17AA38F9", generic_dsd_config },
 	{ "CSC3551", "17AA38FA", generic_dsd_config },
 	{}
-- 
2.43.0



