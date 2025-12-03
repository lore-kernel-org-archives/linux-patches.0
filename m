Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72D3A33BBAC;
	Wed,  3 Dec 2025 15:54:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777251; cv=none; b=RwXVOtksSHRaoriwl/0FPJMbrXAw8eJMeLWGIge2VQmbZ6CoWnRtBIz+T5qHytnXkUiTH03PauidT70VrezKaovY3gLtfpDva2I7N1C9lLXnP+WkUI89fFhxnjhIhV0RAN7DHHsMgYOVOM62d9HVSBTHUCXIYrq3tjeFkoBLikk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777251; c=relaxed/simple;
	bh=2hMT/s2jhoI+nrwaNEsWkGGcfcKekTlnWrorsunJx7E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UrauYFBCNLV8hUDx6iJYkaszz/K+BJRC5GKkB/6rAUjVSCVE5zzMXm9nN18LQSRL68e5ohKv71gEpk0Vv4b3EKDM9MOt/8q6bsrYdCs1zwct3qJUNcEWZxGxOqOvfLJ79EB1eqiKHF6FgMngEheHUJzKcB0n9LfwVuKPdnxga8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hd8pyGnr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hd8pyGnr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C081EC116B1;
	Wed,  3 Dec 2025 15:54:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777251;
	bh=2hMT/s2jhoI+nrwaNEsWkGGcfcKekTlnWrorsunJx7E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hd8pyGnr4JNHkTu/sqzh64M5gFMX1Q5Y6KqmY86SPyVJB9e1OTdyPQ+NliKw4G82U
	 n6EXCXpL6LhVvN40t5/BgxMmFc2LbHXwxUBh+CXOlPVhCbTWYNBtGx2LGkbsQxECpk
	 WzBZjhTGhdw5rqE0dZmqVkGqZVbPBuGDIduSFvRo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sagar Ghuge <sagar.ghuge@intel.com>,
	Stuart Summers <stuart.summers@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>
Subject: [PATCH 6.17 128/146] drm/xe/guc: Fix stack_depot usage
Date: Wed,  3 Dec 2025 16:28:26 +0100
Message-ID: <20251203152351.145133093@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152346.456176474@linuxfoundation.org>
References: <20251203152346.456176474@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lucas De Marchi <lucas.demarchi@intel.com>

commit 0e234632e39bd21dd28ffc9ba3ae8eec4deb949c upstream.

Add missing stack_depot_init() call when CONFIG_DRM_XE_DEBUG_GUC is
enabled to fix the following call stack:

	[] BUG: kernel NULL pointer dereference, address: 0000000000000000
	[] Workqueue:  drm_sched_run_job_work [gpu_sched]
	[] RIP: 0010:stack_depot_save_flags+0x172/0x870
	[] Call Trace:
	[]  <TASK>
	[]  fast_req_track+0x58/0xb0 [xe]

Fixes: 16b7e65d299d ("drm/xe/guc: Track FAST_REQ H2Gs to report where errors came from")
Tested-by: Sagar Ghuge <sagar.ghuge@intel.com>
Cc: stable@vger.kernel.org # v6.17+
Reviewed-by: Stuart Summers <stuart.summers@intel.com>
Link: https://patch.msgid.link/20251118-fix-debug-guc-v1-1-9f780c6bedf8@intel.com
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
(cherry picked from commit 64fdf496a6929a0a194387d2bb5efaf5da2b542f)
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/xe_guc_ct.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/xe/xe_guc_ct.c
+++ b/drivers/gpu/drm/xe/xe_guc_ct.c
@@ -237,6 +237,9 @@ int xe_guc_ct_init_noalloc(struct xe_guc
 #if IS_ENABLED(CONFIG_DRM_XE_DEBUG)
 	spin_lock_init(&ct->dead.lock);
 	INIT_WORK(&ct->dead.worker, ct_dead_worker_func);
+#if IS_ENABLED(CONFIG_DRM_XE_DEBUG_GUC)
+	stack_depot_init();
+#endif
 #endif
 	init_waitqueue_head(&ct->wq);
 	init_waitqueue_head(&ct->g2h_fence_wq);


