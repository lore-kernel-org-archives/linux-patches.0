Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3F53317160;
	Wed, 20 May 2026 16:53:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296008; cv=none; b=quH9nk16LGYlz3flPSLfu8dSigg8fLLqrqWc4+EAe6ujEapw9jcgNjLOJBtddxiKW8xrudgxDaAaAA8Zmkwn9u+VqblKrzD6sqrcoTA4mu37veu/O+paL8QtR4p1x6ZW6CHXxW0TJg6Eupld4qwRmtWg5PmuQPapDV2nwwSvF4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296008; c=relaxed/simple;
	bh=tc1mfRnUU7RQDH0IPM3U90Z8ld/9Z4IK0qfb8PghgNE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L2VStihstVtFhSnJhUSwZ9PmFdubGRrqD2ny/KNI7XQTliQIjbswUXr/KBDwls42v34yuAwKWMsLZ8GZjk6Bp3z8fFsbOcklWa6TZEO7q4ziUMXdW7fxbghPiM2u7klq0v9txYZWfn67I61lN/gdS2WI47gtjctoejKcN/e1JrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rBhtiUE0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rBhtiUE0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44D9B1F000E9;
	Wed, 20 May 2026 16:53:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296007;
	bh=xQXgfcPrl/3Hj3nryxzARTmbTDBFVCOZiZwlm+zjsr8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rBhtiUE0tauUJ/apU63431qVUUK5azmpMAKTZ+bPgvN5GVNYimVRrn8QCWX+W/kde
	 FVYM0Uwnys8hOkrRbZ5qzLuahAa4lw6zXNKTlAWOwcxZcbIS+L2HN60Al2ddQ2ES0G
	 vcT9jQ0NsE7BDhYlCDyp3NQGkDP8QWCXnHnNI6N4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu-Chun Lin <eleanor15x@gmail.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0635/1146] pinctrl: abx500: Fix type of argument variable
Date: Wed, 20 May 2026 18:14:45 +0200
Message-ID: <20260520162202.553934354@linuxfoundation.org>
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

From: Yu-Chun Lin <eleanor15x@gmail.com>

[ Upstream commit 34006f77890d050e6d80cbee365b5d703c1140b4 ]

The argument variable is assigned the return value of
pinconf_to_config_argument(), which returns a u32. Change its type from
enum pin_config_param to unsigned int to correctly store the configuration
argument.

Fixes: 03b054e9696c ("pinctrl: Pass all configs to driver on pin_config_set()")
Signed-off-by: Yu-Chun Lin <eleanor15x@gmail.com>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/nomadik/pinctrl-abx500.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/nomadik/pinctrl-abx500.c b/drivers/pinctrl/nomadik/pinctrl-abx500.c
index fc7ebeda8440e..858fbaebcf8e5 100644
--- a/drivers/pinctrl/nomadik/pinctrl-abx500.c
+++ b/drivers/pinctrl/nomadik/pinctrl-abx500.c
@@ -852,7 +852,7 @@ static int abx500_pin_config_set(struct pinctrl_dev *pctldev,
 	int ret = -EINVAL;
 	int i;
 	enum pin_config_param param;
-	enum pin_config_param argument;
+	unsigned int argument;
 
 	for (i = 0; i < num_configs; i++) {
 		param = pinconf_to_config_param(configs[i]);
-- 
2.53.0



