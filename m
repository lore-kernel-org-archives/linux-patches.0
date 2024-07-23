Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B50F713D600;
	Tue, 23 Jul 2024 18:33:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721759608; cv=none; b=bUvTdaQC1LJaCsUtM2nWcdi0Bp/C7ydzEkzNG8KbDLMkGbhLh+gNl5S7PMMlG2DZ0ZLE8DIWgtf6YNhFJ5ChWpyPz1sMLl+o8kShB4jWbbaoyfyGrNFPlB46BYUzmnBH+zn2pXiVdg+VBaOP/r22mCCdsJQQqYlFTmceKe7BC74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721759608; c=relaxed/simple;
	bh=jnj/NRXC+M0k8rvKG3Vlf8TODqmJRhAuy1lmoqKAf5w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pUVIeG+jA7GR8P6vPqRPgBkVXy1W3h6M+4+A/l2uWNo2KCxZ0R74wfYDkcoa0Jlgul7OgRnC8211WRPhMTaC+dCF0o49ESewEROgzDKmYGxKumBExp3G7Drqw6SD6gv119ay7MArTVFBj9Bf7RbD8PjHo2vBloNx2Yjt4//10bU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y9gjlLFz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y9gjlLFz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37B56C4AF09;
	Tue, 23 Jul 2024 18:33:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721759608;
	bh=jnj/NRXC+M0k8rvKG3Vlf8TODqmJRhAuy1lmoqKAf5w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y9gjlLFzkhdIdv9zBo8uGQXuInsAqUvM1BfdiYAsOz+tOVeXk0VMAaanwPJIDUQTy
	 imaMIyyFr4sVdGxRAPAmZz5zA0TrslT+7WGWitKGcjWLbLgsgKPfb6m2NoiGwjGYi7
	 TZODFdTGU/DREDtJjn0jZpC7HLvVnPakEWDv48nk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	=?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= <amadeuszx.slawinski@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 068/129] ASoC: topology: Do not assign fields that are already set
Date: Tue, 23 Jul 2024 20:23:36 +0200
Message-ID: <20240723180407.412887472@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180404.759900207@linuxfoundation.org>
References: <20240723180404.759900207@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>

[ Upstream commit daf0b99d4720c9f05bdb81c73b2efdb43fa9def3 ]

The routes are allocated with kzalloc(), so all fields are zeroed by
default, skip unnecessary assignments.

Reviewed-by: Cezary Rojewski <cezary.rojewski@intel.com>
Signed-off-by: Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>
Link: https://lore.kernel.org/r/20240603102818.36165-4-amadeuszx.slawinski@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/soc-topology.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/sound/soc/soc-topology.c b/sound/soc/soc-topology.c
index c63545b27d450..8b58a7864703e 100644
--- a/sound/soc/soc-topology.c
+++ b/sound/soc/soc-topology.c
@@ -1072,11 +1072,7 @@ static int soc_tplg_dapm_graph_elems_load(struct soc_tplg *tplg,
 			break;
 		}
 
-		/* set to NULL atm for tplg users */
-		route->connected = NULL;
-		if (strnlen(elem->control, SNDRV_CTL_ELEM_ID_NAME_MAXLEN) == 0) {
-			route->control = NULL;
-		} else {
+		if (strnlen(elem->control, SNDRV_CTL_ELEM_ID_NAME_MAXLEN) != 0) {
 			route->control = devm_kmemdup(tplg->dev, elem->control,
 						      min(strlen(elem->control),
 							  SNDRV_CTL_ELEM_ID_NAME_MAXLEN),
-- 
2.43.0



