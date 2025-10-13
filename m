Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 000CA31076C;
	Mon, 13 Oct 2025 15:23:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369019; cv=none; b=aN5g+Z9Ij6xdLQE10nj3DOG3/IAdhrQxJfrmF8aHNvLhYWdC2a7ZMFRSsD8CY9HC6GyA5b1NV/QcyFWM9TfIuRbDfvgK3MBcgpOehcxrdT3a2L8UaLw6GHz6qKGE4OJY/wgLrO3V+WDPK6Dz745qQwdWzJ9QUtYMSu6WCQgV0bU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369019; c=relaxed/simple;
	bh=Zf2artIZsxWEeZbsAlcatk2XA/l0EyhFczqTOFJ8le4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qtfpklJcRf+ccagGeMakCL6sM3zczuPSmywbM4N8eA/pYURisVL4+qvm5ReOarm6a0juL9u+nESQPQSgBBITPBDDfVlZGb38FbjjkfGT7r9InqyFuRd2zM3GVp3vHsFOh72T2cwAQT8nzXnNfrCHa3vewUPVo2O7E1HFPawW2A0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q1QhFHBB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q1QhFHBB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28F14C4CEE7;
	Mon, 13 Oct 2025 15:23:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369018;
	bh=Zf2artIZsxWEeZbsAlcatk2XA/l0EyhFczqTOFJ8le4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q1QhFHBB3cmCUl7A6vq6xLTfxtFCPl+1/6zVvanTcINbL43/4QcwYqX4Pz0OWu5ut
	 61Fd1LddV9SQc2DZ6FGhUjmAzzHfw/bhshfR0mZvCZaD9DJRrcdMxECwI3Z5vP4Wwb
	 t+y217Gu7QBqOxRE8aWV9DEnla23I1yz5JvfUSyI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Yan <andyshrk@163.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 100/563] power: supply: cw2015: Fix a alignment coding style issue
Date: Mon, 13 Oct 2025 16:39:21 +0200
Message-ID: <20251013144414.917433213@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index f63c3c4104515..382dff8805c62 100644
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



