Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C1FE47CC7E;
	Sat, 28 Feb 2026 17:55:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301333; cv=none; b=Wn4zago5YfgH3iL94dddrWv2NZr8oFK/Nc9axOcYcvSfFBMGk9d9sFUs7bSKl5nry5wkinCzv5Ujfd0C3DYYyZmw8xGPdfHXAWH6aAtOHaogOOWtMWuyJbHDWQK3XZyaKmontv5SSOxZLojBT4kjpt5X9Linpo9z6sXhI5jtRj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301333; c=relaxed/simple;
	bh=tfkBBqKStCnHLqu7rxJkkFEuyEAHDngvzTEOd1OAGIw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d7jfCfllVcXCP8gXZjN/jPWjjWFO83x9YOM1joya6KZv25KDz9USOcV/G71AtfFPo2OPnL2wME80x+UMtVkZOkCyBNxGIYd0EiEgH3bQVFtb4f/ctuOnYYH4BhVcs1Xk7bmb+HG9hcf0CIca8hwPNw87E5GO/sdQXiKETY4ljBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gt8Dt7/i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gt8Dt7/i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FA93C19423;
	Sat, 28 Feb 2026 17:55:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301333;
	bh=tfkBBqKStCnHLqu7rxJkkFEuyEAHDngvzTEOd1OAGIw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gt8Dt7/irJ2MACOZ3A85INLFWYvRZjhbyfLQqSxo4XMC+xBChqk94GInc3JkgAIal
	 CIQsDZubmSiTF/A/2yLLLhmDwnpWAcC3ghNVGDediKO5Ryn6fAvGA262DIRxQh4XAe
	 wHsmRkRr7n9uLo4I+E+TK4QIigm4yT6JqiKOIgg2ZkRQHFVY0czMljGDIUz3Ry3cOZ
	 RTYaZG8hpO0TbYdE+j81JI8jYrVjEkEI5yYhqPv5+8TEFJUUBO6PSwkQhcOUW38I0e
	 ci76p79FeEf7atacyNjecejgvDLtkGaDM9lMPOH25rNbK4K3WQ3KCISxlVhtDBEPUG
	 Lk/U9dd58onIg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Hans de Goede <hansg@kernel.org>,
	stable@vger.kernel.org,
	Mehdi Djait <mehdi.djait@linux.intel.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 520/752] media: i2c: ov01a10: Fix passing stream instead of pad to v4l2_subdev_state_get_format()
Date: Sat, 28 Feb 2026 12:43:51 -0500
Message-ID: <20260228174750.1542406-520-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Hans de Goede <hansg@kernel.org>

[ Upstream commit f8563a375e7fba7c776eb591d4498be592c19098 ]

The 2 argument version of v4l2_subdev_state_get_format() takes the pad
as second argument, not the stream.

Fixes: bc0e8d91feec ("media: v4l: subdev: Switch to stream-aware state functions")
Cc: stable@vger.kernel.org
Signed-off-by: Hans de Goede <hansg@kernel.org>
Tested-by: Mehdi Djait <mehdi.djait@linux.intel.com> # Dell XPS 9315
Reviewed-by: Mehdi Djait <mehdi.djait@linux.intel.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/ov01a10.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/ov01a10.c b/drivers/media/i2c/ov01a10.c
index 1e22df12989ae..dd2b6d381175a 100644
--- a/drivers/media/i2c/ov01a10.c
+++ b/drivers/media/i2c/ov01a10.c
@@ -731,7 +731,7 @@ static int ov01a10_set_format(struct v4l2_subdev *sd,
 					 h_blank);
 	}
 
-	format = v4l2_subdev_state_get_format(sd_state, fmt->stream);
+	format = v4l2_subdev_state_get_format(sd_state, fmt->pad);
 	*format = fmt->format;
 
 	return 0;
-- 
2.51.0

