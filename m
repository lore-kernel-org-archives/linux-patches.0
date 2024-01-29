Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2BC8157E8F;
	Mon, 29 Jan 2024 17:12:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548376; cv=none; b=kim4xGj2VG5e6Ho/82QJcgwkx+JMfUwBZ62G/zF3jDUvdk/5mgNTHjDCMZDFxxs1zD1FAGGbcOaW9oTvyoGSZVssMU8GhC68+bOP6ueScWWmLHS+jnl0MEvqBHI7oR1ZqF2xLYCOFWr7ZxoyxXsvevCVu6d89q2EXN4Otc8kL8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548376; c=relaxed/simple;
	bh=bnnDrXZY31fnYyyPVNMXqFZdrx+biwiyE92xUUvuizA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V7yvHyZHwTRFrDbRr612j+9N4NqOJhqVyYmb7u8Jd5B5fo0xCJJqL1Xq3UShD2qAh7E+ngPoqB2GNbtp0st86kE/MIsWgAJzz7ciY8nNCUhlihUOckedat6DiNOAdubwmJPtEvA4UN5Hh71nljR1+yOzcd0Ky+Sk2oCs1aWPNMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1QGfaoPs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1QGfaoPs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DD82C43399;
	Mon, 29 Jan 2024 17:12:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548376;
	bh=bnnDrXZY31fnYyyPVNMXqFZdrx+biwiyE92xUUvuizA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1QGfaoPsmvj3lnsj/b8ZL9zRI62kFGKW1RajJWp7XBWDsCbMncRkmwO8aV4DkVqOw
	 FXlofzeEW6WZx8Uu3VV3mbXjRnfbzaOkLOp3UUWN0q3ZfD6T0rWjYJ1PFahhCkdT39
	 uUDsW+N6RZyN3rpyV5+KZ5/l7EBZ3fRau8a7f4MI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li zeming <zeming@nfschina.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 146/185] PM: core: Remove unnecessary (void *) conversions
Date: Mon, 29 Jan 2024 09:05:46 -0800
Message-ID: <20240129170003.274558916@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129165958.589924174@linuxfoundation.org>
References: <20240129165958.589924174@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li zeming <zeming@nfschina.com>

[ Upstream commit 73d73f5ee7fb0c42ff87091d105bee720a9565f1 ]

Assignments from pointer variables of type (void *) do not require
explicit type casts, so remove such type cases from the code in
drivers/base/power/main.c where applicable.

Signed-off-by: Li zeming <zeming@nfschina.com>
[ rjw: Subject and changelog edits ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Stable-dep-of: 7839d0078e0d ("PM: sleep: Fix possible deadlocks in core system-wide PM code")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/power/main.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
index c50139207794..f85f3515c258 100644
--- a/drivers/base/power/main.c
+++ b/drivers/base/power/main.c
@@ -679,7 +679,7 @@ static bool dpm_async_fn(struct device *dev, async_func_t func)
 
 static void async_resume_noirq(void *data, async_cookie_t cookie)
 {
-	struct device *dev = (struct device *)data;
+	struct device *dev = data;
 	int error;
 
 	error = device_resume_noirq(dev, pm_transition, true);
@@ -816,7 +816,7 @@ static int device_resume_early(struct device *dev, pm_message_t state, bool asyn
 
 static void async_resume_early(void *data, async_cookie_t cookie)
 {
-	struct device *dev = (struct device *)data;
+	struct device *dev = data;
 	int error;
 
 	error = device_resume_early(dev, pm_transition, true);
@@ -980,7 +980,7 @@ static int device_resume(struct device *dev, pm_message_t state, bool async)
 
 static void async_resume(void *data, async_cookie_t cookie)
 {
-	struct device *dev = (struct device *)data;
+	struct device *dev = data;
 	int error;
 
 	error = device_resume(dev, pm_transition, true);
@@ -1269,7 +1269,7 @@ static int __device_suspend_noirq(struct device *dev, pm_message_t state, bool a
 
 static void async_suspend_noirq(void *data, async_cookie_t cookie)
 {
-	struct device *dev = (struct device *)data;
+	struct device *dev = data;
 	int error;
 
 	error = __device_suspend_noirq(dev, pm_transition, true);
@@ -1450,7 +1450,7 @@ static int __device_suspend_late(struct device *dev, pm_message_t state, bool as
 
 static void async_suspend_late(void *data, async_cookie_t cookie)
 {
-	struct device *dev = (struct device *)data;
+	struct device *dev = data;
 	int error;
 
 	error = __device_suspend_late(dev, pm_transition, true);
@@ -1727,7 +1727,7 @@ static int __device_suspend(struct device *dev, pm_message_t state, bool async)
 
 static void async_suspend(void *data, async_cookie_t cookie)
 {
-	struct device *dev = (struct device *)data;
+	struct device *dev = data;
 	int error;
 
 	error = __device_suspend(dev, pm_transition, true);
-- 
2.43.0



