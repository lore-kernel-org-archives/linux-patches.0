Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FD7B33AD99;
	Mon, 20 Apr 2026 15:50:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776700243; cv=none; b=Y9+ZyMbD+uh9/8i3Jk3NpAuZ4s82NWLuTeHFFv/saN+IGImZh6VPu73ZOGV/7At8fmUQxMOtMUtRZgYkVg3tcilGMzIkqZ9YJmdpGmfaupFk12VotlVi55Mqu32uqS39ZUaYwO0nNxzU6vb+aV69vLxnrYamgWO7uGoNAjE15ug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776700243; c=relaxed/simple;
	bh=p5SscrKmoQL5PyNYrOGfzx6j+tbiWHMRe0paPspHkqw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pJW/avh2s5mSmlGT0YNXtSkMYAi7AEHLlA9LTp5USwu1pYlm+hvTsRQVnB10GfpSyz7LT6ha1riF772WBUugqSe+Vthi7Yq7Ct0Xw4IhfxwphmuSXnQk1ZghP9PzSwBOXrCetnOthuKZ78cwexnekx9aR+E7NtB3jmulXv1IWiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VqriQD6Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VqriQD6Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8CAFC19425;
	Mon, 20 Apr 2026 15:50:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776700243;
	bh=p5SscrKmoQL5PyNYrOGfzx6j+tbiWHMRe0paPspHkqw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VqriQD6YuOw38Sdh6jDFFFDn/Kz4zYnGtVKM7wb9FHrovvactjCcOaIpI4bLWwO1B
	 GLgP+AL6c88tHFJfCZby4XKCClnfMnJ+FX4hHS87D5FVx+z3qktoFHU3QDOeV6WL9l
	 sve/6V7j04gnWXVmsJx6X6xzojA9E7XLo03EE1S4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maciej Strozek <mstrozek@opensource.cirrus.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 096/220] ASoC: SOF: Intel: Fix endpoint index if endpoints are missing
Date: Mon, 20 Apr 2026 17:40:37 +0200
Message-ID: <20260420153937.490346465@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153934.013228280@linuxfoundation.org>
References: <20260420153934.013228280@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maciej Strozek <mstrozek@opensource.cirrus.com>

[ Upstream commit 86facd80a2a37536937f06de637abf9e8cabdb4b ]

In case of missing endpoints, the sequential numbering will cause wrong
mapping. Instead, assign the original DAI index from codec_info_list.

Fixes: 5226d19d4cae ("ASoC: SOF: Intel: use sof_sdw as default SDW machine driver")
Signed-off-by: Maciej Strozek <mstrozek@opensource.cirrus.com>
Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Link: https://patch.msgid.link/20260402064531.2287261-2-yung-chuan.liao@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/intel/hda.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/sof/intel/hda.c b/sound/soc/sof/intel/hda.c
index 686ecc040867a..882198308319e 100644
--- a/sound/soc/sof/intel/hda.c
+++ b/sound/soc/sof/intel/hda.c
@@ -1197,7 +1197,7 @@ static struct snd_soc_acpi_adr_device *find_acpi_adr_device(struct device *dev,
 						 codec_info_list[i].dais[j].dai_type))
 				continue;
 
-			endpoints[ep_index].num = ep_index;
+			endpoints[ep_index].num = j;
 			if (codec_info_list[i].dais[j].dai_type == SOC_SDW_DAI_TYPE_AMP) {
 				/* Assume all amp are aggregated */
 				endpoints[ep_index].aggregated = 1;
-- 
2.53.0



