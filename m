Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67AE9151988;
	Wed,  5 Feb 2025 14:33:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766021; cv=none; b=BMvUfhsSTBfOahWGJ+n55b5P0vv1oPg4hNtj7w2TzUUyUEKDNdFscdLsbJIiw4L3Y2TdDKoyo1qwtGloOuUEBpZVgwgyxX8vc8D5ApLhHGngqRFjlWc6y9Tr6deiAl3xEZ6y2XWLLYE89TloVVlP/QXWAiHriB1w9VPl9trMLRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766021; c=relaxed/simple;
	bh=egme6ltK9AP4V+Jnbe3NOX/K2Prf7K486ET8/sp74pE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bKN0RoZgJMVnuINTACo+DLU8bOV/Qi0z/v5TQ4qhRfqHMCKdtROYKUyxlaBzG+jbswVqV+zKGKf1QyOtNnA8SY8O2OK1iyVIhaJdXYDnacM1jJoQMWFEYmrJhy45vZMtN0JU07ptGLUbHGBgk92xh8HLlaptbEbfcfWsgKto8DA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cT1g5SsL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cT1g5SsL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC590C4CED1;
	Wed,  5 Feb 2025 14:33:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766021;
	bh=egme6ltK9AP4V+Jnbe3NOX/K2Prf7K486ET8/sp74pE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cT1g5SsLmUyzlZU2CnBIRQwa9RoxzLvEN1sIvgYfQcsFUUyFSQ2ugq3U1LmFFNJEn
	 IftS3Bsqn33Ke50vW6jAaAxUZrJE1tnPv5i10LT3ByEAmliX4qGZZpw7fcfUJrfV2g
	 9TBBc1dapZNZ2UcBEL3nhBdun1DZvUBDzSBwXFZc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= <amadeuszx.slawinski@linux.intel.com>,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 276/590] ASoC: Intel: avs: Fix init-config parsing
Date: Wed,  5 Feb 2025 14:40:31 +0100
Message-ID: <20250205134505.835211970@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>

[ Upstream commit e9ca3db9f01a7ce91ceab35cd5fa52f0c5aca174 ]

When parsing init configs correct token should be looked up.

Fixes: 1b4217ebbb3e ("ASoC: Intel: avs: Add topology parsing support for initial config")
Signed-off-by: Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>
Signed-off-by: Cezary Rojewski <cezary.rojewski@intel.com>
Link: https://patch.msgid.link/20250109122216.3667847-5-cezary.rojewski@intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/avs/topology.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/intel/avs/topology.c b/sound/soc/intel/avs/topology.c
index 5cda527020c7b..d612f20ed9893 100644
--- a/sound/soc/intel/avs/topology.c
+++ b/sound/soc/intel/avs/topology.c
@@ -1466,7 +1466,7 @@ avs_tplg_path_template_create(struct snd_soc_component *comp, struct avs_tplg *o
 
 static const struct avs_tplg_token_parser mod_init_config_parsers[] = {
 	{
-		.token = AVS_TKN_MOD_INIT_CONFIG_ID_U32,
+		.token = AVS_TKN_INIT_CONFIG_ID_U32,
 		.type = SND_SOC_TPLG_TUPLE_TYPE_WORD,
 		.offset = offsetof(struct avs_tplg_init_config, id),
 		.parse = avs_parse_word_token,
@@ -1519,7 +1519,7 @@ static int avs_tplg_parse_initial_configs(struct snd_soc_component *comp,
 		esize = le32_to_cpu(tuples->size) + le32_to_cpu(tmp->size);
 
 		ret = parse_dictionary_entries(comp, tuples, esize, config, 1, sizeof(*config),
-					       AVS_TKN_MOD_INIT_CONFIG_ID_U32,
+					       AVS_TKN_INIT_CONFIG_ID_U32,
 					       mod_init_config_parsers,
 					       ARRAY_SIZE(mod_init_config_parsers));
 
-- 
2.39.5



