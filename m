Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019528;
	b=VghRzXVhkxQv3qY3aC8QD2Mh3EMbHXtKaX5HNOkkVSKopWF3U2/2T8cyulmI5E875bgZ
	 esUAzpV8OC2oriTeOdZQYduoovG0thlNDysrNZxrWY/1+k+qLC7WlrcyY4oifNW6jeQNC
	 r7k1FVcoNdJ5Om+C/xZI2CiuVG5QYcclfhQlc0Px6CvotGvVb/Z30Xi+U16f/5gmSBYd9
	 +8ueOMT1wNPKmMWWgGFN+c7HRGq5lIkLxz6SWCp6bHSR1o6e9E5a+xsfd9moUogQAtkcj
	 h28WORwggW9P7hit5xFIGIZ9xDK6oUpOJ0P6TVOF9MFP6H/tHqBs2X7yS5Tfq1/8KVA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019528;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=+n4Jd1l4jQ0OqDGrC5KubxffDsNS4o/QISdGyOWHefQ=;
	b=iaFBo4fsUN2gXoJRyBbiyDOlK9nMqiQaeVkdJfiNCEUyr7bGVoQVg683wcPdSmGm+Izm
	 oVjboJhYKEfFiZi7jVQI802x+axpk9ZFUjAl8B14OeZajcCZO4ukup3/qzdXXEuLltRw6
	 nQq8E7o3juEIQ+XlY9p7u7fn4shWjhoAxqjT5ZqXs3YrreX1x3J4UCfHkrP6FBx//WCF8
	 HF7LRQhT+1lWhQTK2hC6mrHDWIyT2ToK3UnjPOUm2TJnokj9hQqkIEnsk4CPTsTmiEaHX
	 E1b6LkmnjD7wk7uABknf1uVjxeXhWw1dcqIXXfqxZ5Fh4w/yIc2kpWIwwbtOb+HCXnw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UUkD99Xn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B25E606A33A;
	Wed, 18 Nov 2026 16:32:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UUkD99Xn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1ED81F000C4;
	Wed, 18 Nov 2026 16:32:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019528;
	bh=+n4Jd1l4jQ0OqDGrC5KubxffDsNS4o/QISdGyOWHefQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UUkD99Xn/cuBLYuuPksl8fynJ6ZrgttaBuk7Il0CpU4qN1nh6W6lddxnHmqHLM2hi
	 ruOnvXhFCOY9TCyRJCYPk9B5tGIAhs9zXwQfcuyXfW9fGQZA+jrsgYypXQjywvSPiD
	 FCILLm6EtCp1wU/lVCYdsrUEJiNat9Z6K1e75AZc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Steven Price <steven.price@arm.com>,
	=?UTF-8?q?Adri=C3=A1n=20Larumbe?= <adrian.larumbe@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1629/2651] drm/panfrost: Fix PM refcnt and autosuspend issues at device probe/remove
Date: Wed, 18 Nov 2026 15:47:49 +0100
Message-ID: <20261118150346.501985417@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panfrost/panfrost_drv.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/gpu/drm/panfrost/panfrost_drv.c b/drivers/gpu/drm/panfrost/panfrost_drv.c
index 130ec763343bb..b7eecbfc3b5e6 100644
--- a/drivers/gpu/drm/panfrost/panfrost_drv.c
+++ b/drivers/gpu/drm/panfrost/panfrost_drv.c
@@ -989,6 +989,11 @@ static int panfrost_probe(struct platform_device *pdev)
 		goto err_out0;
 	}
 
+	/* The reason we must manually set the PM status and usage counter is
+	 * we have just powered the device up but did not go through the PM
+	 * runtime resume callback, so we need to update these ourselves.
+	 */
+	pm_runtime_get_noresume(pfdev->base.dev);
 	pm_runtime_set_active(pfdev->base.dev);
 	pm_runtime_mark_last_busy(pfdev->base.dev);
 	pm_runtime_enable(pfdev->base.dev);
@@ -1003,13 +1008,16 @@ static int panfrost_probe(struct platform_device *pdev)
 	if (err < 0)
 		goto err_out1;
 
+	pm_runtime_put_autosuspend(pfdev->base.dev);
 
 	return 0;
 
 err_out1:
+	pm_runtime_dont_use_autosuspend(pfdev->base.dev);
 	pm_runtime_disable(pfdev->base.dev);
 	panfrost_device_fini(pfdev);
 	pm_runtime_set_suspended(pfdev->base.dev);
+	pm_runtime_put_noidle(pfdev->base.dev);
 err_out0:
 	return err;
 }
@@ -1021,9 +1029,12 @@ static void panfrost_remove(struct platform_device *pdev)
 	drm_dev_unregister(&pfdev->base);
 
 	pm_runtime_get_sync(pfdev->base.dev);
+	pm_runtime_dont_use_autosuspend(pfdev->base.dev);
 	pm_runtime_disable(pfdev->base.dev);
 	panfrost_device_fini(pfdev);
 	pm_runtime_set_suspended(pfdev->base.dev);
+	pm_runtime_put_noidle(pfdev->base.dev);
+
 }
 
 static ssize_t profiling_show(struct device *dev,
-- 
2.53.0



