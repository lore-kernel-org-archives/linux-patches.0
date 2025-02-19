Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EE661C5F2F;
	Wed, 19 Feb 2025 08:32:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739953922; cv=none; b=LbtHJSDXEHQVSmYYG9I0weJKsEuDuHXdSvvc36ma+ibYBn3+ARUwQELKrTAdezYNv3m3yqed7I0FnvhWHcOT4T0DWwkZbaBhCA8gkvsCctvC0vx2PuOEO9A648UAWAgGrnJoEV94ku32pRfJESWNMzIgRYPiZC2eYQbttWDzQNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739953922; c=relaxed/simple;
	bh=WDad//lJaRJGvVTVVOmQRndtEvSNxrurdxMjQEI/7sQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rWs9K07najgnc2ALgl50OdtwJgXcbqbxLm0/b6TN1iQKmw0QXQ85+xHOBMD7ZGovBmtYuFKRqvVXAvWLU8pFWhnH73H3MUJyobM+L9mElfpgDIeyh9ITfOobB3hsGktLM0LiDdB+0wRETpX/prtytWfVAfKnB15a76DUnP1Ifbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y7B/rDx+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y7B/rDx+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F7E0C4CEE9;
	Wed, 19 Feb 2025 08:32:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739953922;
	bh=WDad//lJaRJGvVTVVOmQRndtEvSNxrurdxMjQEI/7sQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y7B/rDx+ivOerFfj61w8miHb3Ug+ucSKJ6HIR4vFGzEe0sr2CBnccxrJF1czmA0i9
	 mHmmt0lcqdaFREnEhzqp5wdy8tKxLiLm4jWbCbg+72jq1oixEt7hc6TzgwdCat3CeE
	 AoOUJCLisyd6VdYb4/bANw297s8UNJH8ncUm4kqs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 009/274] pinctrl: cy8c95x0: Enable regmap locking for debug
Date: Wed, 19 Feb 2025 09:24:23 +0100
Message-ID: <20250219082609.899472533@linuxfoundation.org>
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

[ Upstream commit aac4470fa6e695e4d6ac94cc77d4690b57f1d2bc ]

When regmap locking is disabled, debugfs is also disabled.
Enable locking for debug when CONFIG_DEBUG_PINCTRL is set.

Fixes: f71aba339a66 ("pinctrl: cy8c95x0: Use single I2C lock")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/20250203131506.3318201-4-andriy.shevchenko@linux.intel.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinctrl-cy8c95x0.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/pinctrl/pinctrl-cy8c95x0.c b/drivers/pinctrl/pinctrl-cy8c95x0.c
index c787a9aadfdfb..bfa16f70e29ce 100644
--- a/drivers/pinctrl/pinctrl-cy8c95x0.c
+++ b/drivers/pinctrl/pinctrl-cy8c95x0.c
@@ -470,7 +470,11 @@ static const struct regmap_config cy8c9520_i2c_regmap = {
 	.max_register = 0,		/* Updated at runtime */
 	.num_reg_defaults_raw = 0,	/* Updated at runtime */
 	.use_single_read = true,	/* Workaround for regcache bug */
+#if IS_ENABLED(CONFIG_DEBUG_PINCTRL)
+	.disable_locking = false,
+#else
 	.disable_locking = true,
+#endif
 };
 
 static inline int cy8c95x0_regmap_update_bits_base(struct cy8c95x0_pinctrl *chip,
-- 
2.39.5



