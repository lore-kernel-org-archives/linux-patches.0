Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A78773ED13E;
	Wed, 30 Sep 2026 19:34:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796843; cv=none; b=QWaq6NFGCF1zJs+BOdzGalOZxoRTcVFuMVfdibiPEW+xTLakGNY2PRNOr2/YxMwnTI5B+M6st+38DZlQ+CjBaBX73GG49D3fdYK0jFjODnnHljkhuLn47ClCyD1sSTyR/T7Nyp5r/WXglpsKxVvIpk1Nt4aDKsUa+TlHcHFBpaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796843; c=relaxed/simple;
	bh=MVtk64EBy8fbfbebdWLTZSVkS+WYAwdKi0w5DHjTAQQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Oh6UH2KtP5lEZs2pOeYR/mP0tTiR87A8l1d0PKBo7OSlraXa93kINoQvL40k/mneQxe3jQTBU8x8HXplNGIDgunPjKJ2hqTPACMApfbJRXJgIg6TkTUP8L0JrEIvUaEM7YBDhyKsEiNK+80BycO4nWHH7MYA3mwhvdvfnfHsxtU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UsSli+uQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UsSli+uQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15E261F000FF;
	Wed, 30 Sep 2026 19:34:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796842;
	bh=jJfkv2zpjuCsqb8bLCDVRHfm2u+2UXFE792lECtprsY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UsSli+uQGAzpZiXr+HQ4G57LYWkjgl/uOI75wiHDG6w6ukm6lp7iFIA4XDUvY8evQ
	 FhrQl3A7V3p2Itbe8VaLY/N40xlrr/lx8Of5r6VchZNfRrdtih0a2y36y3hr8HfGj+
	 9+/wuctrQQhtnHFHOA7QAhbEdac5vx7tb5ABu3I0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1057/1193] driver core: Better advertise dev_err_probe()
Date: Wed, 30 Sep 2026 17:29:01 +0200
Message-ID: <20260930152457.711688574@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 72ca11da6986f..8e17aeabd6e80 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -5131,13 +5131,14 @@ define_dev_printk_level(_dev_info, KERN_INFO);
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



