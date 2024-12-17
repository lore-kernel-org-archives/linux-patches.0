Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 288D31F7577;
	Tue, 17 Dec 2024 17:19:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734455940; cv=none; b=CVoOhMlE8cc3G+rX8BUNjGME7UuJxj1zhe8sOhFT3Tw+9guwP9UxJc/2Elz6DUEKGbAU02X+zjYYM0oI9wNbqeBZEr8MHQDWgZCZ1+RxqqozHm7Iu+0/FY2f3U+dHp8relNsp8O2HtAm1FrqOn/F99TNuTnHl+WPjsod7Auf/K4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734455940; c=relaxed/simple;
	bh=45sUZx4PU4nsgaAVHQUna2XVd5zmhews/dgK/8nRmBw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P5+e2Fbyojapm3urwUly7d8EL12bqEWo9yrLRaPz9Sph9ZtUAJtrbWWKvdVc/crYlnfGDkU8+v+nCSLOaEvgFr5xtK3NPrZNtRv8ov6Ibpq6OeMTTJNtipu3Sff1FJA6mAK8YIn/nagnTVdf7vlUfruKjhB2c7zdF81IJyP8EGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=edVWcSui; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="edVWcSui"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D4E8C4CED3;
	Tue, 17 Dec 2024 17:18:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734455940;
	bh=45sUZx4PU4nsgaAVHQUna2XVd5zmhews/dgK/8nRmBw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=edVWcSuidhP1tHo1durqtqBHafwNIQf6M75FRpyOnY2r6N3+OGLSpEdYX5v72nUKx
	 1CXFUYvYX4nl8vW9vYNaAxufxLxXN8qyjmBofzXwNCkDyfBlYO6LUx2CYC0IASuQWl
	 n3xo24paGrFZN+0+mLqf5vrHH2PryUHX8pJI5m5E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Barker <paul.barker.ct@bp.renesas.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 57/76] Documentation: PM: Clarify pm_runtime_resume_and_get() return value
Date: Tue, 17 Dec 2024 18:07:37 +0100
Message-ID: <20241217170528.635784508@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170526.232803729@linuxfoundation.org>
References: <20241217170526.232803729@linuxfoundation.org>
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

From: Paul Barker <paul.barker.ct@bp.renesas.com>

[ Upstream commit ccb84dc8f4a02e7d30ffd388522996546b4d00e1 ]

Update the documentation to match the behaviour of the code.

pm_runtime_resume_and_get() always returns 0 on success, even if
__pm_runtime_resume() returns 1.

Fixes: 2c412337cfe6 ("PM: runtime: Add documentation for pm_runtime_resume_and_get()")
Signed-off-by: Paul Barker <paul.barker.ct@bp.renesas.com>
Link: https://patch.msgid.link/20241203143729.478-1-paul.barker.ct@bp.renesas.com
[ rjw: Subject and changelog edits, adjusted new comment formatting ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/power/runtime_pm.rst | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/Documentation/power/runtime_pm.rst b/Documentation/power/runtime_pm.rst
index 65b86e487afe..b6d5a3a8febc 100644
--- a/Documentation/power/runtime_pm.rst
+++ b/Documentation/power/runtime_pm.rst
@@ -347,7 +347,9 @@ drivers/base/power/runtime.c and include/linux/pm_runtime.h:
 
   `int pm_runtime_resume_and_get(struct device *dev);`
     - run pm_runtime_resume(dev) and if successful, increment the device's
-      usage counter; return the result of pm_runtime_resume
+      usage counter; returns 0 on success (whether or not the device's
+      runtime PM status was already 'active') or the error code from
+      pm_runtime_resume() on failure.
 
   `int pm_request_idle(struct device *dev);`
     - submit a request to execute the subsystem-level idle callback for the
-- 
2.39.5



