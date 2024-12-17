Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6818A140E38;
	Tue, 17 Dec 2024 17:23:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734456214; cv=none; b=D3CZ5zkjRgfpT+D9OJbtSrInUKXbwJIptGhUz4q3IRMJGy+7psr0U7P4KdcBX8MSvLpry2K344ZVYQvZiG9MmPiTe8n+05+Cr9vGjiYm5mqlRRtPlTymh+MmL9KTnE3vI2+k3jPl51mi1kD5ZDw3BwVHCq0nwRPKedMiFfnl8ko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734456214; c=relaxed/simple;
	bh=0G4dYahSHZ5OPdKAQoStvcFrInKt0Wl0/gpRdNjMScA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K3UVrPhNj4yRE8/E8I1GIsK4BuPD3vkgZCCcrBNo36+59yRWNn8F673M6LiBgCzhwkZ58VFR/Akn2xUokvYiTT4P4i760FYAr8mn4aS7sB3xP/PlL+4s/K5/JGXZ+HnrA/5IJjB7gag+qReQpmgspnLnGx1QAf+kPazDa30YnbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T/ovCbXd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T/ovCbXd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC1EBC4CED3;
	Tue, 17 Dec 2024 17:23:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734456214;
	bh=0G4dYahSHZ5OPdKAQoStvcFrInKt0Wl0/gpRdNjMScA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T/ovCbXdgwMuhoT2FMo4NLnuFfoXicppKnPmeSEjPFT1SA6GgdeNnOgFD7HIkxelk
	 DnF4eNB/7v2T7tCWv+8QXFghx70iZKRRcLBclrTtIZeceS7XGnvyT6/FscBAEFBxjS
	 F5F5l9cCwjpFQ16tcBjlH2BD5kLNDILjkpV9HfbE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Barker <paul.barker.ct@bp.renesas.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 067/109] Documentation: PM: Clarify pm_runtime_resume_and_get() return value
Date: Tue, 17 Dec 2024 18:07:51 +0100
Message-ID: <20241217170536.181252675@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170533.329523616@linuxfoundation.org>
References: <20241217170533.329523616@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



