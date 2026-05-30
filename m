Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0AF423392B;
	Sat, 30 May 2026 18:05:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780164311; cv=none; b=q+AFkpVToWo8hImHB+lHuWX9TK/PX2tcFFATfqMwnux0AJfHwel5sKqg07yQ9wWtcT3DSE6yeLUh+TtRFzKr4kSCueWWiZFpV/0N8fMOtbFIvHRWDZpysWeWYiXAVpc133DYGXyQ+8CWPtngXzRtobrfNylVZDOzA4fXmGiEhhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780164311; c=relaxed/simple;
	bh=PQwQqWrWTaU148Du+tyUVXeJmPLNfKZWyIlf9oafoQk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lY3CCkLsLuecrLQbQdlMw4/MCc9ffqg2hUuycLaXG1zdWQ5UrS6GdKhyim5UnpI11fHiFrQGDLxxem6uHitpEnQSoy0pVHh+zF+xIOt8INy5ybHg60/nDbZdSDiGmz9dMfU8xykVZdV03fDxDKf8AreKbjPRoq8UlV5k5lF2QAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VhDjbklZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VhDjbklZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 104E01F00893;
	Sat, 30 May 2026 18:05:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780164310;
	bh=8xO4+ERICRdqQLXlZHYHKHj3HsevCc/hpSMOpQxsLcQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VhDjbklZzSmvw6TZSJeB+gSuM5ZKrMFQTDde8NaCgLEoxv516PCOgvYUk6HULDbbX
	 8GCqTCzipGhvGcjSWTHmJpOZanxWBcGlhWF/PmiM1ppjiSeQrlGu2TirUnLNM5zP5+
	 qB4eBAYOrehy3XLT4Cuo6qx9ZMs8N6uR3k24fdeQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu-Chun Lin <eleanor15x@gmail.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 516/776] pinctrl: abx500: Fix type of argument variable
Date: Sat, 30 May 2026 18:03:50 +0200
Message-ID: <20260530160253.582383983@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 7aa534576a459..609313d93e31a 100644
--- a/drivers/pinctrl/nomadik/pinctrl-abx500.c
+++ b/drivers/pinctrl/nomadik/pinctrl-abx500.c
@@ -850,7 +850,7 @@ static int abx500_pin_config_set(struct pinctrl_dev *pctldev,
 	int ret = -EINVAL;
 	int i;
 	enum pin_config_param param;
-	enum pin_config_param argument;
+	unsigned int argument;
 
 	for (i = 0; i < num_configs; i++) {
 		param = pinconf_to_config_param(configs[i]);
-- 
2.53.0



