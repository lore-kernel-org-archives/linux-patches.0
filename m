Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B178739FCE;
	Mon, 14 Oct 2024 14:32:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916358; cv=none; b=HR6n2eEcBoO6BOn4/y4FCVvtAwMSs9LyZJDfSmXn7JSCtd194zxpZGzgrcesy87Uk2OVc91R7xOuIzDUhLMncsnxgn1euKOrDW7ZzckXCZPsU/tcC2vo5wpTVhU0F+AbM9XW7knjLnGDeEkoQp5IxhRAxAKc/6II28nbhDY4iHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916358; c=relaxed/simple;
	bh=8hfmwvNc8f3XWsxzEsGeKr9V81+G1Es09nIJD50p3MY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EX4ucZzwJ12DMek85aVJcru5wmgHip7GhmOiSyrkvqt/tgmEnewgC3/KKxWa5zeBFPSiACsl6Th8z/4+u7eX6ZK/md2Y/NyaEs4SMppNnPAKjx5eCbdDeWGDTEh300Cq5DL4TIf1d62aSP2SPNjKQYKQ4OwwmYHG1Ootc58PYOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ReoGFDsH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ReoGFDsH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20221C4CEC3;
	Mon, 14 Oct 2024 14:32:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916358;
	bh=8hfmwvNc8f3XWsxzEsGeKr9V81+G1Es09nIJD50p3MY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ReoGFDsH3pR1LuoRnBKRAa2LB9Qnqrx1a1rBqIb/WNLwat8Vzjix8lrtrX/GdojUQ
	 B+ZJl47D1bUEHnwt3hzKVMIGuTbVR0aOY+UkrAb+VIPbWp9MnGJ2mMhuLCATs4juKo
	 CGzYkzOv4vLr79yujx0IDTPC4Z/pjl4R4t21kQbg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Matt Roper <matthew.d.roper@intel.com>,
	Gustavo Sousa <gustavo.sousa@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 129/214] drm/xe: Make wedged_mode debugfs writable
Date: Mon, 14 Oct 2024 16:19:52 +0200
Message-ID: <20241014141050.027434223@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141044.974962104@linuxfoundation.org>
References: <20241014141044.974962104@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matt Roper <matthew.d.roper@intel.com>

[ Upstream commit 1badf482816417dca71f8120b4c540cdc82aa03c ]

The intent of this debugfs entry is to allow modification of wedging
behavior, either from IGT tests or during manual debug; it should be
marked as writable to properly reflect this.  In practice this hasn't
caused a problem because we always access wedged_mode as root, which
ignores file permissions, but it's still misleading to have the entry
incorrectly marked as RO.

Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Fixes: 6b8ef44cc0a9 ("drm/xe: Introduce the wedged_mode debugfs")
Signed-off-by: Matt Roper <matthew.d.roper@intel.com>
Reviewed-by: Gustavo Sousa <gustavo.sousa@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241002230620.1249258-2-matthew.d.roper@intel.com
(cherry picked from commit 93d93813422758f6c99289de446b19184019ef5a)
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_debugfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/xe/xe_debugfs.c b/drivers/gpu/drm/xe/xe_debugfs.c
index 1011e5d281fa9..c87e6bca64d86 100644
--- a/drivers/gpu/drm/xe/xe_debugfs.c
+++ b/drivers/gpu/drm/xe/xe_debugfs.c
@@ -190,7 +190,7 @@ void xe_debugfs_register(struct xe_device *xe)
 	debugfs_create_file("forcewake_all", 0400, root, xe,
 			    &forcewake_all_fops);
 
-	debugfs_create_file("wedged_mode", 0400, root, xe,
+	debugfs_create_file("wedged_mode", 0600, root, xe,
 			    &wedged_mode_fops);
 
 	for (mem_type = XE_PL_VRAM0; mem_type <= XE_PL_VRAM1; ++mem_type) {
-- 
2.43.0



