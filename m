Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC6D91F757B;
	Tue, 17 Dec 2024 17:14:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734455640; cv=none; b=Tv9wuOwbajS6MyuEby840ctrVIAwX/eNjyJvpcrTs+t08Cgs3tFj445S5eETaZoXqfoDjJW+enxai7gDE4gLOEtu/oxJgDdbN7+izwb14od7Ah2gXyp6n9DuGfQ7oKWb06/IRlX8Tn6qsxLFkUhGdnOzWB+lNNSJhQfWYcR8lCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734455640; c=relaxed/simple;
	bh=buICyUsYdv8MYmC4iQ2V+2Q3EAmTwd2BDSaO3A2sb7Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=US1KUzuiNu9Fb2QGllUsfkZDvFDUcE06musnOaQbvzKFmF6JGkyZPMI4fd7EHoUan5nPDjxGPMRLUM2v4js0l/ZCHWW9DDAN/uK2T421xExVYGmGoIAG9bdHeyd0e5A+PVahAXH8MdlvLIpL0S7yitwEf9LXzkyMSVnpwV3xRD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V2l+RnNK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V2l+RnNK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4582CC4CEDD;
	Tue, 17 Dec 2024 17:14:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734455640;
	bh=buICyUsYdv8MYmC4iQ2V+2Q3EAmTwd2BDSaO3A2sb7Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V2l+RnNK4S26niuZIg/xB0oSJuYaN9YYuDrdrJ7kcTU1B932O/amm2snD2KyPMN/v
	 IDWdHAyAFZhGtC0M249jqX/d+oXXLZnG6WZfq9+i8jxNM8XNzmjzUTGZzAH3XfyprB
	 UojWluu5apr51DN778H2s75bCEY0LG8x5ESfwyAs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Barker <paul.barker.ct@bp.renesas.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 34/51] Documentation: PM: Clarify pm_runtime_resume_and_get() return value
Date: Tue, 17 Dec 2024 18:07:27 +0100
Message-ID: <20241217170521.679574110@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170520.301972474@linuxfoundation.org>
References: <20241217170520.301972474@linuxfoundation.org>
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
index d6bf84f061f4..921f56dffea7 100644
--- a/Documentation/power/runtime_pm.rst
+++ b/Documentation/power/runtime_pm.rst
@@ -341,7 +341,9 @@ drivers/base/power/runtime.c and include/linux/pm_runtime.h:
 
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



