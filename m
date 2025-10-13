Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96A9E30F7FA;
	Mon, 13 Oct 2025 15:08:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368107; cv=none; b=nbs7SL1v0m+gTCWoPudoUO55rH02cdMHEm5VrtO5ulVqj/bdTLWQq0dCEANYWELJ/7JNOIWIUHLQOJA1YQ1WwCPxTaAqvfJPZ/EPQ23U9OBIUdXnFeY+rsZpHFoI3Ibc0mqhD797p5Shjc68r9+L+ni2z6ksFxGONGEnZXU1KmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368107; c=relaxed/simple;
	bh=ahPAIgUXjdha2I3mzIGsNCEUHcKP3w0JfHcXGbveVEY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aXE7zKBVFlpL7VHpvltEmHPg9Ky/LzaWHgOYrXIVQdda+sIo7rAgR/netS0cfI5uFi9CPn81M0NhSBQoczLLkZzVMhqe0s79qyTigNsQfvQNZMCJNpmzsNpt1YNwCWap1QFuP+1zYMVYrolGLVGG9tKf/Nj4yFDKmpM0AhxWER8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eE3jFD2K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eE3jFD2K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23D8AC4CEE7;
	Mon, 13 Oct 2025 15:08:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368107;
	bh=ahPAIgUXjdha2I3mzIGsNCEUHcKP3w0JfHcXGbveVEY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eE3jFD2KdjN2Vn4vl24kGKguVcKwkNvSjAKCYVcD/XG1NZOdyWsWyiUU3eT52PE6I
	 TTPazwdQTx1VGhpU3dMpuLpZwra+chBV7Ls4FGt1OcyKrTQLNn6rIhQCFusEZwthAr
	 axyzrnLrhIr3a5ByGB154cWjUiiBk7aGHeed5dj0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Yan <andyshrk@163.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 047/262] power: supply: cw2015: Fix a alignment coding style issue
Date: Mon, 13 Oct 2025 16:43:09 +0200
Message-ID: <20251013144327.824921931@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144326.116493600@linuxfoundation.org>
References: <20251013144326.116493600@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



