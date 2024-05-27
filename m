Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE8F317727;
	Mon, 27 May 2024 19:32:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716838359; cv=none; b=aJpQJBHBpjKUx/NRYJ89GvKlUOFCDGKGlSCGbXwvbY7rKbKgtMGjrs8dtQj9xluBgi2OjBdsFjWNoWsj5TGhIq2QxWLmDR8jIj+gHGp2XzqP0kB6wTWnscDE5rMrCuzlKu4NLXLqoRxVhqAQKmQXHAc+WiCGEKF7qXShyijV+E8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716838359; c=relaxed/simple;
	bh=jTryLUIa0tggS7cIpuigXo+Mai58s9seQYROhiJ9WqM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m8DuYnGYBAloBitYgCbz0Gcu4IKd6wfaKfJ+L3EjYVuOfWPMoVeCYJ+xhiECpdu8KsnS8/49FZ89TlSTAFduFV3lK+4VhefH1jPrSQmgykLNXyLUgIKdbHZGFMps5VGToJ9LOasRtc286O7wmdEgDoJ4uvSsc/Yj51jFePwvARk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yKvFPcRm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yKvFPcRm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5D23C2BBFC;
	Mon, 27 May 2024 19:32:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716838359;
	bh=jTryLUIa0tggS7cIpuigXo+Mai58s9seQYROhiJ9WqM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yKvFPcRm96QpnNOKCDMGhUbzNFdiJ04a9uB6TXByk+SMv/CeZQkoYfYIRfkNrMyO1
	 yZxq0fi5cSB8fsngc/QDQCrAFni7QV2bu3Hh13J+/u2sWmmyKnAYzwntqzt65npDqv
	 4j+dEASqWDfqdhRgwcWYnvvI9RTaBCeNjJ5/IUJo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 363/493] ASoC: Intel: avs: ssm4567: Do not ignore route checks
Date: Mon, 27 May 2024 20:56:05 +0200
Message-ID: <20240527185642.153342293@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

From: Cezary Rojewski <cezary.rojewski@intel.com>

[ Upstream commit e6719d48ba6329536c459dcee5a571e535687094 ]

A copy-paste from intel/boards/skl_nau88l25_ssm4567.c made the avs's
equivalent disable route checks as well. Such behavior is not desired.

Fixes: 69ea14efe99b ("ASoC: Intel: avs: Add ssm4567 machine board")
Signed-off-by: Cezary Rojewski <cezary.rojewski@intel.com>
Link: https://msgid.link/r/20240308090502.2136760-4-cezary.rojewski@intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/avs/boards/ssm4567.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/sound/soc/intel/avs/boards/ssm4567.c b/sound/soc/intel/avs/boards/ssm4567.c
index 4a0e136835ff5..b64be685dc23b 100644
--- a/sound/soc/intel/avs/boards/ssm4567.c
+++ b/sound/soc/intel/avs/boards/ssm4567.c
@@ -172,7 +172,6 @@ static int avs_ssm4567_probe(struct platform_device *pdev)
 	card->dapm_routes = card_base_routes;
 	card->num_dapm_routes = ARRAY_SIZE(card_base_routes);
 	card->fully_routed = true;
-	card->disable_route_checks = true;
 
 	ret = snd_soc_fixup_dai_links_platform_name(card, pname);
 	if (ret)
-- 
2.43.0



