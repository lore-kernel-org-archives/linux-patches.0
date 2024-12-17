Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 221231F75A6;
	Tue, 17 Dec 2024 17:32:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734456722; cv=none; b=miwuOt94wCuJzrRVNMCq4CXhovtsJWeJHiMyVK4TEdH36QXwehU8w1rrOfe0XMHuv+Mx1CCDou9HMhBaLTk9GCJH3nIfUH6IJNymZ6pF812U46Hk253j6amLGuPiGHn9BgKigM3F095lMq081anx6tYan41zgzRp6vPcHGVuVoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734456722; c=relaxed/simple;
	bh=iML2ElUzDJPqPSNgKzrvhf+/2XSD4lPLQtSUT+qHcRE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qfa3WZ3ro0MIpXKuLfZc199n4eJlzXc7NTbyc217jjy58tZLThhCVQlEZv/OFCQbpsLuMGj9ojPVmDWfTbJb56LknSCodkyy1kf6VVROzfiQ1H3AaL1uB+uF/U0oJgqcqfVL3Y8vIGXBuUdJk8nJb42OT+v8y6N+07GZ4VBakK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i5+7D7Qw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i5+7D7Qw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D583C4CED3;
	Tue, 17 Dec 2024 17:32:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734456722;
	bh=iML2ElUzDJPqPSNgKzrvhf+/2XSD4lPLQtSUT+qHcRE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i5+7D7Qw7eymVgQ21NnpJr/m4489TpwEBsJFicF8J7yzMaKMpriOyt9tARlxFuHTe
	 6yO55xHpXCEIcv2MXnTtU8GBcpr0GQwhXT7i8gJfVbrtW6Nto79ognw6cksFTA34I5
	 LuXevhJOKQotwJb5Br103zinLNeZiDEKjsAM+/ic=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Barker <paul.barker.ct@bp.renesas.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 118/172] Documentation: PM: Clarify pm_runtime_resume_and_get() return value
Date: Tue, 17 Dec 2024 18:07:54 +0100
Message-ID: <20241217170551.221268834@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170546.209657098@linuxfoundation.org>
References: <20241217170546.209657098@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 53d1996460ab..12f429359a82 100644
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



