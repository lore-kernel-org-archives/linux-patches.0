Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 584193FADE9;
	Wed, 20 May 2026 17:06:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296781; cv=none; b=KNV0CfqgQcCXdZN3CoL9MknpzkkuEA3WgBSwozlwKAV1T3FFO/JfwW9j6akry3jqkmV+BS6otke9dE5aUCkQYtcEfXqZDiaHcOwcgNQvZb1CDPp0pdAYSEtoRqrNEKV5YIDy6RjfFBiVcNay21bpPoKYfDdaaYNB0+/w/sTz6XQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296781; c=relaxed/simple;
	bh=8FVKax+QEIXRoHwIGqL4mY6R1C0ivva4E3v8S/MMrHE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bfYz9hmRTJENYqeCRkkYV38XwEhfNlMXyJvnXnY8HxJWd/e8cBVIzYCpVCjsUbmK12N42D53zzDQPibUkUJObQCDwahou/dmLJsBS1MGCdJY1wop4e2964jop2PNt8ClfSsekuvxITiUc1eFOEngYbrGoIYjUI9e0Gu+lvYLh2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AtRUS28N; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AtRUS28N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCCD71F000E9;
	Wed, 20 May 2026 17:06:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296780;
	bh=x8PfNTQK9AGceS+gFUy86Ue2Lk8y0jw2+PPlB69yYIE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AtRUS28N3Y4jIygrkAXuPYPXS4pPG7zdlBn41DoBzBjb0r3z0YM2SlCpTjTLSyCiq
	 1Ig9Nedpmj/Ql5IzH7806OL04j8tSlQjPSl0OI6r4ve8WImZ/+m6C36yREoI8EiUwY
	 ymfNm/1N9f2CkVgXq48gRQAt13RuyBQLsOGi/O4k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0912/1146] ASoC: SOF: Intel: add an empty adr_link
Date: Wed, 20 May 2026 18:19:22 +0200
Message-ID: <20260520162208.880751522@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bard Liao <yung-chuan.liao@linux.intel.com>

[ Upstream commit 3c6f06a200796ae7b2b1065e8a6499b138e27a50 ]

An empty adr_link is expected to terminate the
for (adr_link = mach_params->links; adr_link->num_adr; adr_link++) loop.
Allocate link_num + 1 links to add an empty adr_link.

Fixes: 5226d19d4cae5 ("ASoC: SOF: Intel: use sof_sdw as default SDW machine driver")
Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/20260424105031.114053-1-yung-chuan.liao@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/intel/hda.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/sound/soc/sof/intel/hda.c b/sound/soc/sof/intel/hda.c
index 8a240dcb7fcb3..5fa773bb26788 100644
--- a/sound/soc/sof/intel/hda.c
+++ b/sound/soc/sof/intel/hda.c
@@ -1399,7 +1399,8 @@ static struct snd_soc_acpi_mach *hda_sdw_machine_select(struct snd_sof_dev *sdev
 		link_mask |= BIT(peripherals->array[i]->bus->link_id);
 
 	link_num = hweight32(link_mask);
-	links = devm_kcalloc(sdev->dev, link_num, sizeof(*links), GFP_KERNEL);
+	/* An empty adr_link is needed to terminate the adr_link loop */
+	links = devm_kcalloc(sdev->dev, link_num + 1, sizeof(*links), GFP_KERNEL);
 	if (!links)
 		return NULL;
 
-- 
2.53.0



