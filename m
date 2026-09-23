Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8E1C175A8D;
	Wed, 23 Sep 2026 14:14:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790172899; cv=none; b=IdWgXAVF2CvnWvOOXR1EKWvqVtiUKMcBZ3YBPcfExgv+iDa/+RXEzo8W0hbXy+kbnT5DH3ArPUkQ1azxf2rb9jTXQEPiXm3X4JOyYUgXCtZvwE1BCVgRW/Q4eAXUkT0rV2kW1TtM6H3glQY/k4qzbsIrGfQJQuBNCIF0NagleCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790172899; c=relaxed/simple;
	bh=w8DmWLKbUc8MuQ2epHA5pbSxkNbL+rVaWnlsc8XuHYU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nWT13ZEAiUGsdppXVeKIL+AzO3zQpo3OK4URliMLcZAr1j9YK0Omeew+p3MlqSu6sHbZBc5QYF2ELyG7yG++TEA+mka6pWhw0DBGMG32HN8xwZjHq8tYtjp0mR9vcIXIcAklhjfYBi7D52KtX7V4Om+1bh5pSkoOb2MaYt6nuNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DE56UvL1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DE56UvL1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DC1D1F000FF;
	Wed, 23 Sep 2026 14:14:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790172896;
	bh=UBub/GUGGklHgev1Q6Th/Y0IUXxVdA8Ck1TrOuxCppI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DE56UvL1U4jU45/77q9Dgv+b2uJsBAl4JloeRLtr1ay/8/eBR/yCxw0pzJHToI921
	 d8dLwNBrwxicrSeJ86EtrdlxCxXYENOOIhlWfn/H9dATqd+K6anMXl9yXu2TqrEJGU
	 6s4x+wBCmbP5RMvqwkns4yyytlTvwLvFCbafZnw8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 093/438] scsi: pm80xx: Fix the use_msix, use_tasklet and read_wwn parameter descriptions
Date: Wed, 23 Sep 2026 16:01:54 +0200
Message-ID: <20260923140647.190500140@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit 264bf9655c3d067d775a46f05eb8c871c488a864 ]

The MODULE_PARM_DESC() lines of use_msix, use_tasklet and read_wwn all
name a parameter zoned, which does not exist, and the use_tasklet one
repeats the use_msix text. modinfo shows three "zoned" entries and no
description for the real parameters.

Name the right parameters and describe use_tasklet.

Fixes: efa1fca45082 ("scsi: pm8001: Remove PM8001_USE_MSIX")
Fixes: 205430290ad0 ("scsi: pm8001: Remove PM8001_USE_TASKLET")
Fixes: 80975adc79dd ("scsi: pm8001: Remove PM8001_READ_VPD")
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Link: https://patch.msgid.link/20260906170925.2524-1-kmehltretter@gmail.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/pm8001/pm8001_init.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index 54b35893261a6..5af81c73a8f87 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -58,15 +58,15 @@ MODULE_PARM_DESC(link_rate, "Enable link rate.\n"
 
 bool pm8001_use_msix = true;
 module_param_named(use_msix, pm8001_use_msix, bool, 0444);
-MODULE_PARM_DESC(zoned, "Use MSIX interrupts. Default: true");
+MODULE_PARM_DESC(use_msix, "Use MSIX interrupts. Default: true");
 
 static bool pm8001_use_tasklet = true;
 module_param_named(use_tasklet, pm8001_use_tasklet, bool, 0444);
-MODULE_PARM_DESC(zoned, "Use MSIX interrupts. Default: true");
+MODULE_PARM_DESC(use_tasklet, "Use tasklets for interrupt handling. Default: true");
 
 static bool pm8001_read_wwn = true;
 module_param_named(read_wwn, pm8001_read_wwn, bool, 0444);
-MODULE_PARM_DESC(zoned, "Get WWN from the controller. Default: true");
+MODULE_PARM_DESC(read_wwn, "Get WWN from the controller. Default: true");
 
 uint pcs_event_log_severity = 0x03;
 module_param(pcs_event_log_severity, int, 0644);
-- 
2.53.0



