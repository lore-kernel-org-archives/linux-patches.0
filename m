Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47F1E76C99;
	Wed, 21 Feb 2024 13:57:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708523877; cv=none; b=LMQSnxQXkVIo8ZthR2nKn0BOrv08SBTdXxwC8uOpND6KMH8oL55PMfNUbUfwOh/bQcqc6sHrnOS8N0/paux7yL1IbaSNU53Lx7UK98APuayF6td4+rdZnxx/PCcBCf0a4ZQ9V6FHH8476dX5BRWiPIoaD165NfBBC99qJl3T+9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708523877; c=relaxed/simple;
	bh=E6sFRRWTAuDbJiJiNNLaE5jJl+S0cfgwrYGdptAy8J0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fxsJHE1ldkoJBB3MWYykPPtI7in6JZHVPCgR1AsFT1UeWqx3EIH6K460mF1ZFixNYCYvR2HB/CSWQGyvKWicXPPzxoYChhD2N4HQz7vNgaBfFO0tfr2iEXRjSc3PEWZq3TkWDOiOTT/5IkH8ZiPWZLcPuIu2cufjvkZWNMQshpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XeHagEJg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XeHagEJg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAA27C433F1;
	Wed, 21 Feb 2024 13:57:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708523877;
	bh=E6sFRRWTAuDbJiJiNNLaE5jJl+S0cfgwrYGdptAy8J0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XeHagEJgG6n/fzbKQ6s7hyZFSj+nW2dHlCoN9QzxkMWVpNTMxdlu2v/j5HLOLGb6u
	 0pYBLXlAkTJEJaT/MNdIgx7r50hzXyJki0ywgrBpZ8RqGP9E0FsprgJwHKjKpJTZ7Z
	 cVRmo3zjSHXCSsGa8t3xD7K48MNC+uKK+4s2e4+s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li zeming <zeming@nfschina.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 079/379] PM: core: Remove unnecessary (void *) conversions
Date: Wed, 21 Feb 2024 14:04:18 +0100
Message-ID: <20240221125957.246168319@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 6c334a65644c..402f3c4e3668 100644
--- a/drivers/base/power/main.c
+++ b/drivers/base/power/main.c
@@ -683,7 +683,7 @@ static bool dpm_async_fn(struct device *dev, async_func_t func)
 
 static void async_resume_noirq(void *data, async_cookie_t cookie)
 {
-	struct device *dev = (struct device *)data;
+	struct device *dev = data;
 	int error;
 
 	error = device_resume_noirq(dev, pm_transition, true);
@@ -822,7 +822,7 @@ static int device_resume_early(struct device *dev, pm_message_t state, bool asyn
 
 static void async_resume_early(void *data, async_cookie_t cookie)
 {
-	struct device *dev = (struct device *)data;
+	struct device *dev = data;
 	int error;
 
 	error = device_resume_early(dev, pm_transition, true);
@@ -986,7 +986,7 @@ static int device_resume(struct device *dev, pm_message_t state, bool async)
 
 static void async_resume(void *data, async_cookie_t cookie)
 {
-	struct device *dev = (struct device *)data;
+	struct device *dev = data;
 	int error;
 
 	error = device_resume(dev, pm_transition, true);
@@ -1275,7 +1275,7 @@ static int __device_suspend_noirq(struct device *dev, pm_message_t state, bool a
 
 static void async_suspend_noirq(void *data, async_cookie_t cookie)
 {
-	struct device *dev = (struct device *)data;
+	struct device *dev = data;
 	int error;
 
 	error = __device_suspend_noirq(dev, pm_transition, true);
@@ -1458,7 +1458,7 @@ static int __device_suspend_late(struct device *dev, pm_message_t state, bool as
 
 static void async_suspend_late(void *data, async_cookie_t cookie)
 {
-	struct device *dev = (struct device *)data;
+	struct device *dev = data;
 	int error;
 
 	error = __device_suspend_late(dev, pm_transition, true);
@@ -1734,7 +1734,7 @@ static int __device_suspend(struct device *dev, pm_message_t state, bool async)
 
 static void async_suspend(void *data, async_cookie_t cookie)
 {
-	struct device *dev = (struct device *)data;
+	struct device *dev = data;
 	int error;
 
 	error = __device_suspend(dev, pm_transition, true);
-- 
2.43.0



