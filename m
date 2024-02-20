Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DD9314A4E6;
	Tue, 20 Feb 2024 21:29:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464569; cv=none; b=Mt4lQBdTlNhGqDG6OHFCgsr45XJM6bFb3cztZ3f5cpRRoyc3Kl8iiKSZa99xawWFLqWQV75hyDALL0Aw32ENEvQ/0HptRpOVs2AicIXobSicE+mz2fG6Sr1zTlFqx2c/wYE8z7xh8oGQv/9IGraHs1Oh8M8A8TwzVYenfF8wl6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464569; c=relaxed/simple;
	bh=v4bk9j6HyffpCSpWYzMrlGyAVYNTa9q48/yX+034pTQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uEgB4L8bxDooc2huMjKhYPPgN+4+ZPzn/CIryNN2quemv0MGcaHMZnHMoz56I0xsd/QnWQQ7YbiGrU/DEPedg1LtMeTdQuQ7b6mLa4Myr2KPQaGRysEDPzCpI/xCUIYh3EtS3QZodtGJ3Hj9m5usEAH9m9j5ELUUIoxFH9VizTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XS4uVxYX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XS4uVxYX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E87DCC433C7;
	Tue, 20 Feb 2024 21:29:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464569;
	bh=v4bk9j6HyffpCSpWYzMrlGyAVYNTa9q48/yX+034pTQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XS4uVxYXRX056UYkqsvBRc3yJz4ItMMNTXAjbfpWRD91CJDz6fUHNwhnZDZWsAIru
	 tJq+NtmrtC2v/e8QMn/PyH2lqOF8yCNMBk0Qp2hhShCoRN0KoaE+YznpbixhMqoVdO
	 J3sxdWP1yRlLxKCe3JXHxyUp82bZZPkauQEPRELQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	=?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= <amadeuszx.slawinski@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 025/309] ASoC: Intel: avs: Fix dynamic port assignment when TDM is set
Date: Tue, 20 Feb 2024 21:53:04 +0100
Message-ID: <20240220205633.973197919@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>

[ Upstream commit 44d3b8a19b91cd2af11f918b2fd05628383172de ]

In case TDM is set in topology on SSP0, parser will overwrite vindex
value, because it only checks if port is set. Fix this by checking whole
field value.

Fixes: e6d50e474e45 ("ASoC: Intel: avs: Improve topology parsing of dynamic strings")
Reviewed-by: Cezary Rojewski <cezary.rojewski@intel.com>
Signed-off-by: Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>
Link: https://lore.kernel.org/r/20240207112624.2132821-1-amadeuszx.slawinski@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/avs/topology.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/intel/avs/topology.c b/sound/soc/intel/avs/topology.c
index c74e9d622e4c..41020409ffb6 100644
--- a/sound/soc/intel/avs/topology.c
+++ b/sound/soc/intel/avs/topology.c
@@ -857,7 +857,7 @@ assign_copier_gtw_instance(struct snd_soc_component *comp, struct avs_tplg_modcf
 	}
 
 	/* If topology sets value don't overwrite it */
-	if (cfg->copier.vindex.i2s.instance)
+	if (cfg->copier.vindex.val)
 		return;
 
 	mach = dev_get_platdata(comp->card->dev);
-- 
2.43.0



