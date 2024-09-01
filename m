Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6107617CA1F;
	Sun,  1 Sep 2024 16:59:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209980; cv=none; b=R/frzGaq94H7ElVoP7H9gYuIlOXQ4+3ROpjrggs57OKo4OGfezIM1xdlynBA3EoIKCHuB/YA8mJXamq891mKUS0esEbO7Q1RlJ+ju9/Y5oEqsFvR8Lj3tTb9wfUKLZVG/qlZfLs9UvkXetTcV7uqFSEETacDLqSoAwvlcxJN88U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209980; c=relaxed/simple;
	bh=WuRGFnCs8uepIwtO0jCjtI7M1TIntrnZ+MFfRddwSn4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o0z/jlipg0vouOLTK8fZeiYzkQ/0yEH9ihHxO7bl/95mIRjLTsQ64refmgO1wiIFJ0MF8dkxzddF/l6oXkkPl6xEepsCN5dfaEgjYu3mjD2d4UYja7fi6gh9Rq142Oao2WpuoW7jRFqCRbM3TO8MQuYnD6k+okrIskOTT3Z3Y8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S9h2qiLI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S9h2qiLI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C38BDC4CEC3;
	Sun,  1 Sep 2024 16:59:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209980;
	bh=WuRGFnCs8uepIwtO0jCjtI7M1TIntrnZ+MFfRddwSn4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S9h2qiLIdQkneSbp6+SVyYfokY9a4yBuYilnFGz6y4YVc4GCHcLY+vCI0Va/HvRP6
	 hpQ4IsDYyV1Y2xNJpMXz5FkuCXctGSg3jATqECKEXBb0dn9wBl/2bmNx4FpMPwVFg4
	 wZMjhBes0Jky2Yc3l7i0mjYRbv/61fM1oA0wlkzA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 052/215] media: radio-isa: use dev_name to fill in bus_info
Date: Sun,  1 Sep 2024 18:16:04 +0200
Message-ID: <20240901160825.319414179@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160823.230213148@linuxfoundation.org>
References: <20240901160823.230213148@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

[ Upstream commit 8b7f3cf4eb9a95940eaabad3226caeaa0d9aa59d ]

This fixes this warning:

drivers/media/radio/radio-isa.c: In function 'radio_isa_querycap':
drivers/media/radio/radio-isa.c:39:57: warning: '%s' directive output may be truncated writing up to 35 bytes into a region of size 28 [-Wformat-truncation=]
   39 |         snprintf(v->bus_info, sizeof(v->bus_info), "ISA:%s", isa->v4l2_dev.name);
      |                                                         ^~
drivers/media/radio/radio-isa.c:39:9: note: 'snprintf' output between 5 and 40 bytes into a destination of size 32
   39 |         snprintf(v->bus_info, sizeof(v->bus_info), "ISA:%s", isa->v4l2_dev.name);
      |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/radio/radio-isa.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/radio/radio-isa.c b/drivers/media/radio/radio-isa.c
index c591c0851fa28..ad49151f5ff09 100644
--- a/drivers/media/radio/radio-isa.c
+++ b/drivers/media/radio/radio-isa.c
@@ -36,7 +36,7 @@ static int radio_isa_querycap(struct file *file, void  *priv,
 
 	strscpy(v->driver, isa->drv->driver.driver.name, sizeof(v->driver));
 	strscpy(v->card, isa->drv->card, sizeof(v->card));
-	snprintf(v->bus_info, sizeof(v->bus_info), "ISA:%s", isa->v4l2_dev.name);
+	snprintf(v->bus_info, sizeof(v->bus_info), "ISA:%s", dev_name(isa->v4l2_dev.dev));
 	return 0;
 }
 
-- 
2.43.0



