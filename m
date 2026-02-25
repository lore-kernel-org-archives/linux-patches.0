Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDE651FE45D;
	Wed, 25 Feb 2026 01:30:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983060; cv=none; b=fFpIUVwcrMgUySJ+avAuoj92VdxGzsfJMbNaa7ob3B3JOUfFGOeQQBN7o1AzLu9nZiu19MRJWTbE4G5ywjTL4pVVw950vX8qQaOimvrd1V7CIaNWr4MQ7bzY+ZmIAVQeqVCaL3F0/antQSz/aI72S8aNEHLDfPypOuIYKMgPBsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983060; c=relaxed/simple;
	bh=gGWOeW+z2jhZADuQRbHFrHpL+bLTUdeR8azPzaRdJpM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fu628TJWt0tBZUMdCgKFRnjJW97O3HV8nRWoFuLZVmn7ejYiLVNGg2N9zV1yW6ZOZ6g+3t7/LsuX8p+JpIdDD7h5evXvP7ApgVEUSqlsppxRgp02Nhb69E33OW0aTQlrOJmNe0qFt9YfEuevfOfvyrfW+mSiqzVMCl5KBrm/F34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sr1MQz3r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sr1MQz3r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACC92C116D0;
	Wed, 25 Feb 2026 01:30:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983059;
	bh=gGWOeW+z2jhZADuQRbHFrHpL+bLTUdeR8azPzaRdJpM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sr1MQz3rOqDhO20nRnNfitVFWiGBvfYkt3aQKeInBINvvrZUx4xIVzkxK3FcXuUWv
	 806jOBwzLFFAXARG+XMwetBl2YMfOUXEknCWnClXgwx7N+Mqq7r7XMS1k4MPW0i8nA
	 Pa6EF2sjL5v9o3c5OfF7iT6GrLDcTS/YIVHVH//I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Trimmer <simont@opensource.cirrus.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 224/781] ASoC: SDCA: Allow sample width wild cards in set_usage()
Date: Tue, 24 Feb 2026 17:15:33 -0800
Message-ID: <20260225012405.205318764@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

From: Simon Trimmer <simont@opensource.cirrus.com>

[ Upstream commit 87783532d34050e2bff6749a4fe9860e624a0540 ]

The SDCA spec allows the sample rate and width to be wild cards, but the
current implementation of set_usage() only checked for a wild card of
the sample rate.

Fixes: 4ed357f72a0e ("ASoC: SDCA: Add hw_params() helper function")
Signed-off-by: Simon Trimmer <simont@opensource.cirrus.com>
Reviewed-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/20251216142204.183958-1-simont@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sdca/sdca_asoc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/sdca/sdca_asoc.c b/sound/soc/sdca/sdca_asoc.c
index 2d328bbb95b94..498aba9df5d9b 100644
--- a/sound/soc/sdca/sdca_asoc.c
+++ b/sound/soc/sdca/sdca_asoc.c
@@ -1478,7 +1478,7 @@ static int set_usage(struct device *dev, struct regmap *regmap,
 		unsigned int rate = sdca_range(range, SDCA_USAGE_SAMPLE_RATE, i);
 		unsigned int width = sdca_range(range, SDCA_USAGE_SAMPLE_WIDTH, i);
 
-		if ((!rate || rate == target_rate) && width == target_width) {
+		if ((!rate || rate == target_rate) && (!width || width == target_width)) {
 			unsigned int usage = sdca_range(range, SDCA_USAGE_NUMBER, i);
 			unsigned int reg = SDW_SDCA_CTL(function->desc->adr,
 							entity->id, sel, 0);
-- 
2.51.0



