Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54C38514753;
	Wed, 30 Sep 2026 16:42:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786527; cv=none; b=ekr+aUC0y6REf7dZgqFLoziciPkjda0mBgjHPDddcKcfC9t7nKx7boQezAsQMIf0uSiTacf7Y0O5PDccl/MBpHjMtIJo+ts4QCETdzvey84p4KRDakBh4FH3IIAm9ex6p0gtgJr3JtF2PrGG7m0f6Gzicz0c5wsEWhfgf50EaXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786527; c=relaxed/simple;
	bh=C5ZCf+09hKvyuQ8p3rK2zuphUUSZ06OaPcShSD6Ydl0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rffWuMXBOuEoDJy/QWETi5RGSCEklhL1blAsP6TQGKdknp+ib1jQlEMiyySN8QAYnrS6qT68qK7AkJmXSJEIUkTxyYoh6T1hZgDaSq+rlFg/spf91zWUumHgzJ75VGNl+iqlFw4sdg4nw28cx3DP4zchnrhDGpjtVtNHd6vQ0vY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eum1YkvK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eum1YkvK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A67DF1F000FF;
	Wed, 30 Sep 2026 16:42:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786526;
	bh=0TPThcCiQw719GPqvkdjJC+MVolFekqPpackklf/HTs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eum1YkvKKLKzSg1M5d4XTnOTe21pKRg2d21kU2KUwYck2mWIa9V7fLy1Ti20i+AEo
	 Mn8XvtM2FjHinL8xaRpiLQGH8o5j3ERfO3m1PaZCXWe5zFY35XQxLrGdt4gbV0N1YL
	 CFw0TDZq/IKslOgZ+RG6x8viethbGHWUOoVNC7D4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 894/982] driver core: Better advertise dev_err_probe()
Date: Wed, 30 Sep 2026 17:27:10 +0200
Message-ID: <20260930152435.947892048@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit 532888a59505da2a3fbb4abac6adad381cedb374 ]

Describing the usage of dev_err_probe() as being (only?) "deemed
acceptable" has a bad connotation. In fact dev_err_probe() fulfills
three tasks:

 - handling of EPROBE_DEFER (even more than degrading to dev_dbg())
 - symbolic output of the error code
 - return err for compact error code paths

Advertise these better and claim the usage to be "fine" to get rid of
the bad connotation.

Acked-by: Rafael J. Wysocki <rafael@kernel.org>
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Link: https://lore.kernel.org/r/20231215174540.2438601-2-u.kleine-koenig@pengutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 4eb3f195ef08 ("tg3: use random MAC address when tg3_get_device_address fails")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/core.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 81a8fe313f6a4..09114e717800b 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -5042,13 +5042,14 @@ define_dev_printk_level(_dev_info, KERN_INFO);
  *
  * 	return dev_err_probe(dev, err, ...);
  *
- * Note that it is deemed acceptable to use this function for error
- * prints during probe even if the @err is known to never be -EPROBE_DEFER.
+ * Using this helper in your probe function is totally fine even if @err is
+ * known to never be -EPROBE_DEFER.
  * The benefit compared to a normal dev_err() is the standardized format
- * of the error code and the fact that the error code is returned.
+ * of the error code, it being emitted symbolically (i.e. you get "EAGAIN"
+ * instead of "-35") and the fact that the error code is returned which allows
+ * more compact error paths.
  *
  * Returns @err.
- *
  */
 int dev_err_probe(const struct device *dev, int err, const char *fmt, ...)
 {
-- 
2.53.0



