Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BDD02EBDF9;
	Mon, 13 Oct 2025 15:00:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367601; cv=none; b=q3b4aWotfHsc1tyT3ysDve0/qGtpaFqm7vZgWD43eDUwnO10XlrL17TrIkVPClFS0zhi4V8hs4DRB/fHs/leIcrC9oSAitig2PwowSmrZ+b8IVznMMYDWalSNqKCaWEyYD/F7UQRTI57yBaUA3RXGQR7hqqzDflObuKBA5BT+rA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367601; c=relaxed/simple;
	bh=zmXQ+l14dXtm+84E9D78Xp2vzjOv3UHP/9vCyS32ZAo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RFdZR1b+4wOV4XG0cA0BOMQCkNY4n5bkZziXiJVeLT9cVI97D9CGHQUF3fuUDMB1SzIjf86FLcCAl7hO4ac+/XqPQQEknBri+yS57L8K2/d7jKRnpFRhdZpYr+1UEJFZHLV90DH60tEyLwCFqWgToGYAIORzzrneREcAi/FRdSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sTdB59/7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sTdB59/7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 518D1C113D0;
	Mon, 13 Oct 2025 15:00:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367601;
	bh=zmXQ+l14dXtm+84E9D78Xp2vzjOv3UHP/9vCyS32ZAo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sTdB59/7YicuhRWHtAJvsX8pJlw/3lkx6axYi/4lXNZ2u0st6lIe8wBSpdD1Yr2FO
	 AOuAc4zes1Itwa7mMbkB3VxXdrFYIXqxhEjIWXlDXpocuwBeu0Fnvo0QrTArIgD+GW
	 dfv1vmwjoBERE8rLtIW6XOhV8PWvF96gIUnui+ZA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Yan <andyshrk@163.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 035/196] power: supply: cw2015: Fix a alignment coding style issue
Date: Mon, 13 Oct 2025 16:43:46 +0200
Message-ID: <20251013144316.473873461@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144315.184275491@linuxfoundation.org>
References: <20251013144315.184275491@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Yan <andyshrk@163.com>

[ Upstream commit def5612170a8c6c4c6a3ea5bd6c3cfc8de6ba4b1 ]

Fix the checkpatch warning:
CHECK: Alignment should match open parenthesis

Fixes: 0cb172a4918e ("power: supply: cw2015: Use device managed API to simplify the code")
Signed-off-by: Andy Yan <andyshrk@163.com>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/cw2015_battery.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/power/supply/cw2015_battery.c b/drivers/power/supply/cw2015_battery.c
index 99f3ccdc30a6a..434e3233c9f8c 100644
--- a/drivers/power/supply/cw2015_battery.c
+++ b/drivers/power/supply/cw2015_battery.c
@@ -702,8 +702,7 @@ static int cw_bat_probe(struct i2c_client *client)
 	if (!cw_bat->battery_workqueue)
 		return -ENOMEM;
 
-	devm_delayed_work_autocancel(&client->dev,
-							  &cw_bat->battery_delay_work, cw_bat_work);
+	devm_delayed_work_autocancel(&client->dev, &cw_bat->battery_delay_work, cw_bat_work);
 	queue_delayed_work(cw_bat->battery_workqueue,
 			   &cw_bat->battery_delay_work, msecs_to_jiffies(10));
 	return 0;
-- 
2.51.0



