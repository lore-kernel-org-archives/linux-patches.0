Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625345;
	b=Fzl4IdSK4IUPdNGLyzsVhYT8mh4fNoJqB871w/lB/FdTZEBRqhjdomfajDwPpKuFyFGJ
	 7TOeDzzwL8VMqq0Vc285wOqAFUQHNsSeWpG3TXLUhVzg2DHdnO0v1zZHsfCJPbikWtQO5
	 wNGNcvTnmLh+5z05ueXsm33hpIMWoOOh70i9dEH8xYHB/Rav7GvHIU4sSZudhSVjrEtqq
	 b/tG+hl/r5rBSfxeNdactNaPP/RAb6rZ9KVhOtq4zt97/3dZ+R1BUYFbxkAERjCjAF0H/
	 HZClMWJFn7mXCvT89hSRDr62iTk6CTRmUTNEWFN7gryVZfofWDLhDhrb9rp6aCb2eHQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625345;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=K7zavZtjNRRVPxjPdIigiur1rRwU/4zxA6fLg1i7UV8=;
	b=zVqh/cTZo2LqR2235ViUu11tLj7lCBzykpdkuSYphjeAS2b+GprYU08enIUtuHEnSdHi
	 7wazp/2rlT4ekj2riqSHiXP8l5LqWf95tRSGSmpsXD1h0weFwDPE82vfvGgkWluleJXN6
	 I2WjLOFf5hgyvsARjGmWj0Rn9NmWgAXPNJmK5YzevSibTGYWKx8PgQ7nOz/dlJBY1Fkj9
	 eXpk6rTYXO3o2p2iVVoo2GT1ROzH9b718wKPiAgRrglyZtLUzzsBaX2rj1qvLSAl/9qMR
	 TXWZMnujk4EEJ9l66G9w5gXZVfQeHM2qzCmV5OpktUfBtGAXNEHBj3nlHmO3rPCBPKw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NDXe6lV1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F823606A31E;
	Wed, 25 Nov 2026 16:49:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NDXe6lV1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2ECE1F000C0;
	Wed, 25 Nov 2026 16:49:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625345;
	bh=K7zavZtjNRRVPxjPdIigiur1rRwU/4zxA6fLg1i7UV8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NDXe6lV1gavudmBqUZNS7OS+xI6NQ6Zq6Av+lB6qazWPR4W/XQVvKqvIEVPPbKoWG
	 Ym7xSmlJAlLRTOwghJLOPGIfbzV67jz0gFV1yjvmB+LSlNTNfW4zQXtEf3awNPb1hA
	 P9/Bd9+uyCCkIdbQyhYq1QzsMej2Vgr8mHZrCbB8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Steven Price <steven.price@arm.com>,
	=?UTF-8?q?Adri=C3=A1n=20Larumbe?= <adrian.larumbe@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 486/816] drm/panfrost: Fix PM refcnt and autosuspend issues at device probe/remove
Date: Wed, 25 Nov 2026 15:33:54 +0100
Message-ID: <20261125143900.443923975@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adrián Larumbe <adrian.larumbe@collabora.com>

[ Upstream commit e9672bf9382ff80be21d586f88e50339b85f5766 ]

During device probe(), failure to do a PM get() will leave the usage_count
set to 0, which is the value assigned at device creation time. That means
when the autosuspend delay expires, runtime suspend callback won't be
invoked, so the device will remain powered on forever.

On top of that, failure to call PM put() during device unplug means
Panfrost device's PM usage_count increases monotonically for every new
module reload.

The outcome of both of the above meant that:

- Devfreq OPP transition notifications would be printed all the time,
  even when no jobs are being submitted. This quickly fills the kernel
  ring buffer with junk.
- Because MMU interrupts are only enabled when the device is reset,
  the very first job targeting the tiler heap BO after device probe()
  would always time out, since the driver's PM runtime resume callback
  would not be invoked.

To fix the above:
- Manually adjust the PM refcnt at device probe and removal time.
- Ensure pm_runtime_dont_use_autosuspend is called in the wind-down path.
- Call pm_runtime_put_autosuspend() when device is ready to accept jobs

Fixes: 635430797d3f ("drm/panfrost: Rework runtime PM initialization")
Fixes: 876b15d2c88d ("drm/panfrost: Fix module unload")
Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>
Reviewed-by: Steven Price <steven.price@arm.com>
Link: https://patch.msgid.link/20261012-claude-fixes-v15-6-bc0a6c498553@collabora.com
Signed-off-by: Adrián Larumbe <adrian.larumbe@collabora.com>
[ sashal: Replaced pfdev->base.dev with pfdev->dev, adjusted context for the shrinker and drm_dev_put() paths, and added pm_runtime_mark_last_busy() before pm_runtime_put_autosuspend() in probe. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panfrost/panfrost_drv.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/gpu/drm/panfrost/panfrost_drv.c b/drivers/gpu/drm/panfrost/panfrost_drv.c
index c20a817dcd1f0..ef46ceb3e4c68 100644
--- a/drivers/gpu/drm/panfrost/panfrost_drv.c
+++ b/drivers/gpu/drm/panfrost/panfrost_drv.c
@@ -644,6 +644,11 @@ static int panfrost_probe(struct platform_device *pdev)
 		goto err_out0;
 	}
 
+	/* The reason we must manually set the PM status and usage counter is
+	 * we have just powered the device up but did not go through the PM
+	 * runtime resume callback, so we need to update these ourselves.
+	 */
+	pm_runtime_get_noresume(pfdev->dev);
 	pm_runtime_set_active(pfdev->dev);
 	pm_runtime_mark_last_busy(pfdev->dev);
 	pm_runtime_enable(pfdev->dev);
@@ -662,14 +667,19 @@ static int panfrost_probe(struct platform_device *pdev)
 	if (err)
 		goto err_out2;
 
+	pm_runtime_mark_last_busy(pfdev->dev);
+	pm_runtime_put_autosuspend(pfdev->dev);
+
 	return 0;
 
 err_out2:
 	drm_dev_unregister(ddev);
 err_out1:
+	pm_runtime_dont_use_autosuspend(pfdev->dev);
 	pm_runtime_disable(pfdev->dev);
 	panfrost_device_fini(pfdev);
 	pm_runtime_set_suspended(pfdev->dev);
+	pm_runtime_put_noidle(pfdev->dev);
 err_out0:
 	drm_dev_put(ddev);
 	return err;
@@ -684,9 +694,11 @@ static void panfrost_remove(struct platform_device *pdev)
 	panfrost_gem_shrinker_cleanup(ddev);
 
 	pm_runtime_get_sync(pfdev->dev);
+	pm_runtime_dont_use_autosuspend(pfdev->dev);
 	pm_runtime_disable(pfdev->dev);
 	panfrost_device_fini(pfdev);
 	pm_runtime_set_suspended(pfdev->dev);
+	pm_runtime_put_noidle(pfdev->dev);
 
 	drm_dev_put(ddev);
 }
-- 
2.53.0



