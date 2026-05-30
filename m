Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC8F92F3C3E;
	Sat, 30 May 2026 18:41:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780166472; cv=none; b=XbHjwQPeIWm+8f0utcErX2RFl3pbe3uMa8jVXuq9As/rvqDnPjjQ6d0ui8TR7WFgLdzad8aStpLiXlhmPmEK6cad65Bc4bIjebWlzd14So5yl0Tp4hFHq9z124g4tRqYUGPPdUqrnSUlD/eP0MVH9wD2h6QEp/36gH9/790XsP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780166472; c=relaxed/simple;
	bh=avWouDphLSLl3QRzJsjXaQkw/Gneh6dmejGZOkqjLxE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nDN7p3fVCyznmCoNGAAJwz6BsOzQKjaOQCw9ukJT8oB1ieuV3oE2W5+p488SPS8XE2UhpV+t9qOJQgkBCJAv5S7o30MAcBfW7+qv0PIgxwrQaiBM/0C4Uc5w5EPvCBqtQwcXFhzR4XQd+Q8S9PfTuSe5JPO5S3wHrLbZGXseLEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v7POL6gN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v7POL6gN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6EEC1F00893;
	Sat, 30 May 2026 18:41:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780166471;
	bh=UomlxWQQ37qoVqtdYxFTvJk1ugCuLSkb5+I/t/mqDis=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v7POL6gN2Q4c2OA9wmIYaRfUz9oeadjp4NSvm5A3rWzGHBv6x4p+gVnU44QAh/NZ0
	 eeEyq0qH9TkVZwCWEVKfAe2dH+vOKCPrzz/VM9DmBOuK9qK6ibdf1vAm03I1Z4iBlv
	 7GYP1rMLvv7pWArldT2A7JGQ4x7Fk/QWGaPBqt/U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu-Chun Lin <eleanor15x@gmail.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 383/589] pinctrl: abx500: Fix type of argument variable
Date: Sat, 30 May 2026 18:04:24 +0200
Message-ID: <20260530160234.868513242@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



