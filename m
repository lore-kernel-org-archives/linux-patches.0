Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CA057E787;
	Wed, 21 Feb 2024 13:29:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708522161; cv=none; b=kd5Pne1jpKM+J0TrKOPvvq0jmNWddde807a5qn6ygi+w4GTQQmEAuHXrQHiPkAtOSr+drk7jrQ2k8Wi9WAdJwgaHwC88bg1p5p39MX9UO7dS2J5WcpxacZnUdyBfH6hgQb1ySnSyRcCnklJ0E0SVeU5XJamS7UNxXoupm5smR7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708522161; c=relaxed/simple;
	bh=mgrFRrJO+hQeNxR0SNaTFYeYKICTfV4SBNdEfLCnWJY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ikpsl9QWcnKCTV+UB9ToUaTv20VW/5oFBLsdyiK1vVQVCpmqy6k5mgees1fHUCdgmkIV39jKIzjmCoWbbzJFri37O9ovGhsjFuvs8LlBr4n4+sFqSa3wWzizICkYGmlrXba54vTUdQE7cVOl76iFbk3Hm0yOXTUQlEYw5/U89rU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=luIfljzr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="luIfljzr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E6B3C433C7;
	Wed, 21 Feb 2024 13:29:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708522160;
	bh=mgrFRrJO+hQeNxR0SNaTFYeYKICTfV4SBNdEfLCnWJY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=luIfljzr0lHvNN5MCebDTFbLLuxe5W2UqsyTxVEUBTH8Sw3ajcdcz3WVPKDfj5Wxy
	 wjOnv9LgWFygmqnVDszZ5FVyyOZE62yNaQagpxcmQGWkSo5IzRMmFwxOKYBjMKYgQF
	 WnwwPt0oiYBXjr6AJBL8RBS3sw9s8eGrjGAPu0hg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li zeming <zeming@nfschina.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 095/476] PM: core: Remove unnecessary (void *) conversions
Date: Wed, 21 Feb 2024 14:02:26 +0100
Message-ID: <20240221130011.507304429@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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
index 8c4819fe73d4..b4cd003d3e39 100644
--- a/drivers/base/power/main.c
+++ b/drivers/base/power/main.c
@@ -680,7 +680,7 @@ static bool dpm_async_fn(struct device *dev, async_func_t func)
 
 static void async_resume_noirq(void *data, async_cookie_t cookie)
 {
-	struct device *dev = (struct device *)data;
+	struct device *dev = data;
 	int error;
 
 	error = device_resume_noirq(dev, pm_transition, true);
@@ -819,7 +819,7 @@ static int device_resume_early(struct device *dev, pm_message_t state, bool asyn
 
 static void async_resume_early(void *data, async_cookie_t cookie)
 {
-	struct device *dev = (struct device *)data;
+	struct device *dev = data;
 	int error;
 
 	error = device_resume_early(dev, pm_transition, true);
@@ -983,7 +983,7 @@ static int device_resume(struct device *dev, pm_message_t state, bool async)
 
 static void async_resume(void *data, async_cookie_t cookie)
 {
-	struct device *dev = (struct device *)data;
+	struct device *dev = data;
 	int error;
 
 	error = device_resume(dev, pm_transition, true);
@@ -1272,7 +1272,7 @@ static int __device_suspend_noirq(struct device *dev, pm_message_t state, bool a
 
 static void async_suspend_noirq(void *data, async_cookie_t cookie)
 {
-	struct device *dev = (struct device *)data;
+	struct device *dev = data;
 	int error;
 
 	error = __device_suspend_noirq(dev, pm_transition, true);
@@ -1455,7 +1455,7 @@ static int __device_suspend_late(struct device *dev, pm_message_t state, bool as
 
 static void async_suspend_late(void *data, async_cookie_t cookie)
 {
-	struct device *dev = (struct device *)data;
+	struct device *dev = data;
 	int error;
 
 	error = __device_suspend_late(dev, pm_transition, true);
@@ -1731,7 +1731,7 @@ static int __device_suspend(struct device *dev, pm_message_t state, bool async)
 
 static void async_suspend(void *data, async_cookie_t cookie)
 {
-	struct device *dev = (struct device *)data;
+	struct device *dev = data;
 	int error;
 
 	error = __device_suspend(dev, pm_transition, true);
-- 
2.43.0



