Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59C9B1F17E5;
	Wed, 19 Feb 2025 08:45:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954758; cv=none; b=GEhhWqrtwEW5/9XqtmMAi03a4SsHgxhFclxfXdqNM/qqGB9X+0u9Ttyue8t47jx/mY8frHKd9+xs4C9mEnCvtKaNxs1RGV5xeSrCrjgk6uPwxoo6DZNtdBXd/KopNq/gD8HFj4JOiio/QfP/C8UGi1aKgiPzHKXbuJDs1DjuEYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954758; c=relaxed/simple;
	bh=AnidAMJAXWfS7QE5WU+6lmBSIUa2JC0f97ICh3k19fk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=klVclZGY5wDjk3CXtx6qkI/e+b8d7Y17iOCVtvi0A3gVRfDU2fkHewbhjFj8lf/dFkgaUVnHy69TCllJEDJaIohI6Ian6f93MHrqGaWVo2NxqGR8Va/auEDfhEJZDOd2V17eqLHHrsMQy0VPJtGOjG7jZPSvYYtb/ZSmUHSalqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qllFr6Mn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qllFr6Mn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75748C4CED1;
	Wed, 19 Feb 2025 08:45:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954757;
	bh=AnidAMJAXWfS7QE5WU+6lmBSIUa2JC0f97ICh3k19fk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qllFr6MnYktydF6gP+b0o/rCqqchEV14qdXrtCSd/zTcUvbsvffIs5eggTYOXHU0d
	 VxGv/0zUKenOKkweFQWhROzs4Xhq2T4sR52lRKFthZOzDnDlTzh0mPkC3O/BtIFYiC
	 mhkksHDAQoKKrb1jVWcUFetRvV6ecD7wCn6D/V2E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 006/230] pinctrl: cy8c95x0: Enable regmap locking for debug
Date: Wed, 19 Feb 2025 09:25:23 +0100
Message-ID: <20250219082601.944666549@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082601.683263930@linuxfoundation.org>
References: <20250219082601.683263930@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 05224808d92be..c0f094f51da84 100644
--- a/drivers/pinctrl/pinctrl-cy8c95x0.c
+++ b/drivers/pinctrl/pinctrl-cy8c95x0.c
@@ -472,7 +472,11 @@ static const struct regmap_config cy8c9520_i2c_regmap = {
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



