Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99A4D1F91E3;
	Mon, 13 Oct 2025 14:50:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367035; cv=none; b=E8osxetWVZHVpTPl5ShIvvahewfjyjoF/wKNZi85IQ4obyMNIFF+eziVrmu/2bFWhCnIY7KuWRTpUfCwtQ7329OHqbCxUoJgUfWyGi25Yh+EpOdxtHzX0gEp0Fak5dyBcxyTd168BC3b3MvrW9yucNAeDGN36lV6iWZqIDmBNZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367035; c=relaxed/simple;
	bh=VFV3DYtz5VhCuyuCY9XoeRGycwnAWfqh49Yh30SjW5E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O4yba9UnTbn1cw5Qnnt4N7zG5PSVib5fDyQHMc7I+4ys8GfwOpFH1MxMZyKyaNc5ZSaON0oa1ggqGHB42RrLSgfBenviO7oTxyQH+FaHuuNwtLJCDSBUUeeSj79sek4PUze2vFC9jt9RDHAwDOW35tHY82BMD1YCiIWnHwBiymA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R3mJu3O+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R3mJu3O+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26569C4CEE7;
	Mon, 13 Oct 2025 14:50:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367035;
	bh=VFV3DYtz5VhCuyuCY9XoeRGycwnAWfqh49Yh30SjW5E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R3mJu3O+8KKMVbZcqPHuCJT0cT2wE1qfcXcDRMnOPmomjlJCl0U0WI5dBM2hdNB3t
	 tV6vu40THLh63YfjcOEv3CEvTIbFypCyNoHvHf1nR/bFDH01DUEwxoynjHgBlJXBe7
	 7FPGu/ynCMJ622inw7RM/gXfW8/NAxL9VOnRbVDM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Yan <andyshrk@163.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 069/196] power: supply: cw2015: Fix a alignment coding style issue
Date: Mon, 13 Oct 2025 16:44:02 +0200
Message-ID: <20251013144317.075683279@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144314.549284796@linuxfoundation.org>
References: <20251013144314.549284796@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 9d957cf8edf07..ae6f46b452101 100644
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



