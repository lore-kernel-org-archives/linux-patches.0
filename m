Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C33018FC86;
	Wed, 19 Feb 2025 08:31:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739953916; cv=none; b=FxSoN58aan8oVpnXw8frxnazy0MCI706vknkhHSIMt40PBb8MjUk0whxWhFgl1JHpdRCCwXJnDswXqUmr7KvKiAHGmpuFvWxCHxYw9zUOqZX9eT6Sa2oh60YTfYpintoNBA4aLoOgyBs3xOZoKiMngLUTBNyQ6VY1QlDvMnlufI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739953916; c=relaxed/simple;
	bh=TwryS8608p3wJMOqYQHi4F97mSvbJM6S3h6PxCAMILI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vs+p7Fr801MRdUFpV6lY8aZsJp+ms4eQoyi5flghKrV4L38tooPmrSTzyWxWrC7RArq2HGovd0b/2NFTnA8kIGwujfaALWQn8ITrp4C9vus3GzirzYA0uuQakreRzQwAcnvlAR/XRzYA07ToMlLXx1hIOb4cP18kAvVsdu7MooE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dto2MncZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dto2MncZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5DD9C4CEE6;
	Wed, 19 Feb 2025 08:31:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739953916;
	bh=TwryS8608p3wJMOqYQHi4F97mSvbJM6S3h6PxCAMILI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Dto2MncZE8F0mm3EudyJwU5U+N7NRiJkrBQdiDj9l/JA8R1yTu5hol3r3lDEcIqA6
	 Zb3k6pYqMtf3H8tKNzhzxlTmHYif/4tkYGFN90xtyrXFDaaMh7ZsH/qVtCt+UoITLy
	 GUZy0dZ4xF2td1uRPuQv4IrB0YVehAOulSVqgzCc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 007/274] pinctrl: cy8c95x0: Fix off-by-one in the regmap range settings
Date: Wed, 19 Feb 2025 09:24:21 +0100
Message-ID: <20250219082609.821565920@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082609.533585153@linuxfoundation.org>
References: <20250219082609.533585153@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 6f36f103cff1737094f2187b1f9a7b312820d377 ]

The range_max is inclusive, so we need to use the number of
the last accessible register address.

Fixes: 8670de9fae49 ("pinctrl: cy8c95x0: Use regmap ranges")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/20250203131506.3318201-2-andriy.shevchenko@linux.intel.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinctrl-cy8c95x0.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-cy8c95x0.c b/drivers/pinctrl/pinctrl-cy8c95x0.c
index 0d6c2027d4c18..5c6bcbf6c3377 100644
--- a/drivers/pinctrl/pinctrl-cy8c95x0.c
+++ b/drivers/pinctrl/pinctrl-cy8c95x0.c
@@ -1438,15 +1438,15 @@ static int cy8c95x0_probe(struct i2c_client *client)
 	switch (chip->tpin) {
 	case 20:
 		strscpy(chip->name, cy8c95x0_id[0].name);
-		regmap_range_conf.range_max = CY8C95X0_VIRTUAL + 3 * MUXED_STRIDE;
+		regmap_range_conf.range_max = CY8C95X0_VIRTUAL + 3 * MUXED_STRIDE - 1;
 		break;
 	case 40:
 		strscpy(chip->name, cy8c95x0_id[1].name);
-		regmap_range_conf.range_max = CY8C95X0_VIRTUAL + 6 * MUXED_STRIDE;
+		regmap_range_conf.range_max = CY8C95X0_VIRTUAL + 6 * MUXED_STRIDE - 1;
 		break;
 	case 60:
 		strscpy(chip->name, cy8c95x0_id[2].name);
-		regmap_range_conf.range_max = CY8C95X0_VIRTUAL + 8 * MUXED_STRIDE;
+		regmap_range_conf.range_max = CY8C95X0_VIRTUAL + 8 * MUXED_STRIDE - 1;
 		break;
 	default:
 		return -ENODEV;
-- 
2.39.5



