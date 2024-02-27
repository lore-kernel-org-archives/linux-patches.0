Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 989F413DB98;
	Tue, 27 Feb 2024 13:30:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709040622; cv=none; b=Bw9AKaSwkM0j2HgvFbbhEBZ9GFmI8v+lWJmY230QaNSndbp7PvNzu0cAmPj8bWLwKPDt0rnePfYP8XiKP4PmlgnYktBGxLFxptJ7I/UptgbCNfRJdtBKgi8GL6XmrQ0Dt0e0q3Fk7lpXGZpjoMqZ1DTS5JVPY7hIjW036/up7QI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709040622; c=relaxed/simple;
	bh=NjvNgov7qhHvn6MotvJ88jMBbd2PgnqOZd45BiJuRxU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YlrSKQPww0pl61vcaBiMc7yovcIJ+7Sc+vc+P8ZV4yXV53uf9jEaoWjgi1+bERiOjIuEKzahgD9QWC/qEKlnu9Cwc4M0bdbvnpeR8A0ZSaIeJOlFRk8B2TnoVkewCErJSc63G7Kg3tSsUt8H/RNdiKN4yzt/crFNhyRJxQXqNTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1uGV2oUx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1uGV2oUx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24721C433C7;
	Tue, 27 Feb 2024 13:30:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709040622;
	bh=NjvNgov7qhHvn6MotvJ88jMBbd2PgnqOZd45BiJuRxU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1uGV2oUxYj/zh0R7X58N10CU9JVnFEL/Bk1K1WsgfDdTk/mQiq+Y3FjfMFjxtQbY1
	 XcnDrxLMliqZl9blWcxkf7R1T2+5uLOujEHu643NtFiUETd7SfPzd3y2omSshd5CjX
	 VXPJY2UXwWwkE6q2QI7EL6PPrdIdMfA9DSbOh7uk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chhayly Leang <clw.leang@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 050/334] ALSA: hda: cs35l41: Support ASUS Zenbook UM3402YAR
Date: Tue, 27 Feb 2024 14:18:28 +0100
Message-ID: <20240227131632.197711268@linuxfoundation.org>
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

From: Chhayly Leang <clw.leang@gmail.com>

[ Upstream commit be220d2e5544ff094142d263db5cf94d034b5e39 ]

Adds sound support for ASUS Zenbook UM3402YAR with missing DSD

Signed-off-by: Chhayly Leang <clw.leang@gmail.com>
Link: https://lore.kernel.org/r/20240126080912.87422-1-clw.leang@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/cs35l41_hda_property.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/pci/hda/cs35l41_hda_property.c b/sound/pci/hda/cs35l41_hda_property.c
index 59504852adc69..d74cf11eef1ea 100644
--- a/sound/pci/hda/cs35l41_hda_property.c
+++ b/sound/pci/hda/cs35l41_hda_property.c
@@ -76,6 +76,7 @@ static const struct cs35l41_config cs35l41_config_table[] = {
 	{ "10431533", 2, INTERNAL, { CS35L41_LEFT, CS35L41_RIGHT, 0, 0 }, 0, 1, -1, 1000, 4500, 24 },
 	{ "10431573", 2, INTERNAL, { CS35L41_LEFT, CS35L41_RIGHT, 0, 0 }, 1, 2, 0, 1000, 4500, 24 },
 	{ "10431663", 2, INTERNAL, { CS35L41_LEFT, CS35L41_RIGHT, 0, 0 }, 1, -1, 0, 1000, 4500, 24 },
+	{ "10431683", 2, EXTERNAL, { CS35L41_LEFT, CS35L41_RIGHT, 0, 0 }, 0, 1, -1, 0, 0, 0 },
 	{ "104316A3", 2, EXTERNAL, { CS35L41_LEFT, CS35L41_RIGHT, 0, 0 }, 1, 2, 0, 0, 0, 0 },
 	{ "104316D3", 2, EXTERNAL, { CS35L41_LEFT, CS35L41_RIGHT, 0, 0 }, 1, 2, 0, 0, 0, 0 },
 	{ "104316F3", 2, EXTERNAL, { CS35L41_LEFT, CS35L41_RIGHT, 0, 0 }, 1, 2, 0, 0, 0, 0 },
@@ -411,6 +412,7 @@ static const struct cs35l41_prop_model cs35l41_prop_model_table[] = {
 	{ "CSC3551", "10431533", generic_dsd_config },
 	{ "CSC3551", "10431573", generic_dsd_config },
 	{ "CSC3551", "10431663", generic_dsd_config },
+	{ "CSC3551", "10431683", generic_dsd_config },
 	{ "CSC3551", "104316A3", generic_dsd_config },
 	{ "CSC3551", "104316D3", generic_dsd_config },
 	{ "CSC3551", "104316F3", generic_dsd_config },
-- 
2.43.0



