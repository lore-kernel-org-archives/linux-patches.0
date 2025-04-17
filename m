Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65862185920;
	Thu, 17 Apr 2025 18:48:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744915721; cv=none; b=dXPwPVpcx10I4RNMSmwS/s+uh+tfF9w364FftaZMB/xju2UHJET6nqIITNZOovFryqgkpDgN18VCNuYDa4WehwNTXJ95u6/bfKeBlyHO8lvcd8D4qqyfJXTgFoe13/FbbRSUKcpmroyS3Ojt5mH0Z+iBj38sJw8hDozcfguzubM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744915721; c=relaxed/simple;
	bh=kbk1qMiX2lwEGZW2V0HovsbGKxHuwR/0H4BwDPub/BE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JLFykgtMzAPAv0AABRTWbqcpVq5Fdf/rpt+C+OLuTz0QqYmIkrx5mQ6C2eh9WzcBSjvwqm6zOOBjpemqY5dE9PWVjOZe3EZ1oWy3AmeeEj3Srg43cfiMh9HD0RJ8fYLwXxv/4jQyfWZYd4p2/evfhs7qCfFDHffueAxzt9dk6TE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K0pafkDC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K0pafkDC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52B04C4CEE4;
	Thu, 17 Apr 2025 18:48:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744915720;
	bh=kbk1qMiX2lwEGZW2V0HovsbGKxHuwR/0H4BwDPub/BE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K0pafkDC3g4a5yV+82M4eSXsrq3h1blF6vz3EecRIDdT+E65X4TVVhTEaBldnHscX
	 A16E0g3DaVOprh51byicDJ/0wY1Tu6zKFMO8z+F4rFMaZB5TP7/Qa5ofwXJ1ISuvHe
	 LVQPvDEkjgrGJdW8TQn26svBcXt7FFBHfwYrss4E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.12 217/393] Revert "media: imx214: Fix the error handling in imx214_probe()"
Date: Thu, 17 Apr 2025 19:50:26 +0200
Message-ID: <20250417175116.311858379@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
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

From: Sakari Ailus <sakari.ailus@linux.intel.com>

commit abd88757252c2a2cea7909f3922de1f0e9e04002 upstream.

This reverts commit 9bc92332cc3f06fda3c6e2423995ca2da0a7ec9a.

Revert this "fix" as it's not really helpful but makes backporting a
proper fix harder.

Fixes: 9bc92332cc3f ("media: imx214: Fix the error handling in imx214_probe()")
Cc: stable@vger.kernel.org # for >= v6.12
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/i2c/imx214.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/media/i2c/imx214.c
+++ b/drivers/media/i2c/imx214.c
@@ -1114,7 +1114,6 @@ free_ctrl:
 	v4l2_ctrl_handler_free(&imx214->ctrls);
 error_power_off:
 	pm_runtime_disable(imx214->dev);
-	regulator_bulk_disable(IMX214_NUM_SUPPLIES, imx214->supplies);
 
 	return ret;
 }


