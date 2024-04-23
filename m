Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6984A20B3E;
	Tue, 23 Apr 2024 21:41:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908490; cv=none; b=on5z47BKHNwajle3+URHx7+BmvT1mlOnLRxqukUzlRB3zsBHOS4DVx7unFKYVbGtHqi3lhdboKmDS4uIQhhiluJpypbpvDPn9+AwYiIq7BXbW+utksDnCB5wAiagk9i7g6ESRxzjaz16IiHqbtBuzPF9b7h2aFoGbEFzMSBRslA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908490; c=relaxed/simple;
	bh=BSXwlkmgEluoKho7D7hIwu4R8o7nKijOGLjnU3ITD0E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fdIhbH2XtWe5192FVWzzReSADg1cxzSBUG8OdeZk7MMjoNeRroRP9Vl5EYRa6BRNmuF9VFQndeanJ/wZL8W5Otv8aVlzQbSJD1h8M2BRDLg+JL9sw4tT/Mkfbk1DYfZpZo3BN8I2gSmseDR5kDjcrN5GortklE1BMmylyg4xrpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tq0Xkamw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tq0Xkamw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3882BC32783;
	Tue, 23 Apr 2024 21:41:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908490;
	bh=BSXwlkmgEluoKho7D7hIwu4R8o7nKijOGLjnU3ITD0E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tq0Xkamw8OyCaeqcTkSzj/Ie/Qi60HBlzMjpecQbx+CjGUa4clmFCDoLGWgq8i3gG
	 AJo+kkh9OggwE7TXWLWJGhP/Odrf9R4l8Ckdx3F7K2XfuAar1I7JxCBuFwjqC2MUtd
	 fLg0EgVXZ803MNFOQmNsC1yYEi7gnAu2AkOJUmgs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tvrtko Ursulin <tursulin@igalia.com>,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
	Tvrtko Ursulin <tvrtko.ursulin@igalia.com>,
	Jose Maria Casanova Crespo <jmcasanova@igalia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 065/158] drm/v3d: Dont increment `enabled_ns` twice
Date: Tue, 23 Apr 2024 14:38:07 -0700
Message-ID: <20240423213858.074572206@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.824778126@linuxfoundation.org>
References: <20240423213855.824778126@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maíra Canal <mcanal@igalia.com>

[ Upstream commit 35f4f8c9fc972248055096d63b782060e473311b ]

The commit 509433d8146c ("drm/v3d: Expose the total GPU usage stats on sysfs")
introduced the calculation of global GPU stats. For the regards, it used
the already existing infrastructure provided by commit 09a93cc4f7d1 ("drm/v3d:
Implement show_fdinfo() callback for GPU usage stats"). While adding
global GPU stats calculation ability, the author forgot to delete the
existing one.

Currently, the value of `enabled_ns` is incremented twice by the end of
the job, when it should be added just once. Therefore, delete the
leftovers from commit 509433d8146c ("drm/v3d: Expose the total GPU usage
stats on sysfs").

Fixes: 509433d8146c ("drm/v3d: Expose the total GPU usage stats on sysfs")
Reported-by: Tvrtko Ursulin <tursulin@igalia.com>
Signed-off-by: Maíra Canal <mcanal@igalia.com>
Reviewed-by: Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
Reviewed-by: Jose Maria Casanova Crespo <jmcasanova@igalia.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240403203517.731876-2-mcanal@igalia.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/v3d/v3d_irq.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/gpu/drm/v3d/v3d_irq.c b/drivers/gpu/drm/v3d/v3d_irq.c
index afc76390a197a..b8f9f2a3d2fb3 100644
--- a/drivers/gpu/drm/v3d/v3d_irq.c
+++ b/drivers/gpu/drm/v3d/v3d_irq.c
@@ -105,7 +105,6 @@ v3d_irq(int irq, void *arg)
 		struct v3d_file_priv *file = v3d->bin_job->base.file->driver_priv;
 		u64 runtime = local_clock() - file->start_ns[V3D_BIN];
 
-		file->enabled_ns[V3D_BIN] += local_clock() - file->start_ns[V3D_BIN];
 		file->jobs_sent[V3D_BIN]++;
 		v3d->queue[V3D_BIN].jobs_sent++;
 
@@ -126,7 +125,6 @@ v3d_irq(int irq, void *arg)
 		struct v3d_file_priv *file = v3d->render_job->base.file->driver_priv;
 		u64 runtime = local_clock() - file->start_ns[V3D_RENDER];
 
-		file->enabled_ns[V3D_RENDER] += local_clock() - file->start_ns[V3D_RENDER];
 		file->jobs_sent[V3D_RENDER]++;
 		v3d->queue[V3D_RENDER].jobs_sent++;
 
@@ -147,7 +145,6 @@ v3d_irq(int irq, void *arg)
 		struct v3d_file_priv *file = v3d->csd_job->base.file->driver_priv;
 		u64 runtime = local_clock() - file->start_ns[V3D_CSD];
 
-		file->enabled_ns[V3D_CSD] += local_clock() - file->start_ns[V3D_CSD];
 		file->jobs_sent[V3D_CSD]++;
 		v3d->queue[V3D_CSD].jobs_sent++;
 
@@ -195,7 +192,6 @@ v3d_hub_irq(int irq, void *arg)
 		struct v3d_file_priv *file = v3d->tfu_job->base.file->driver_priv;
 		u64 runtime = local_clock() - file->start_ns[V3D_TFU];
 
-		file->enabled_ns[V3D_TFU] += local_clock() - file->start_ns[V3D_TFU];
 		file->jobs_sent[V3D_TFU]++;
 		v3d->queue[V3D_TFU].jobs_sent++;
 
-- 
2.43.0



