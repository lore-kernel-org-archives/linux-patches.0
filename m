Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052064;
	b=zPG6FK/+i00e9wKo7+l/sNnvoIbc6NkfvMCfXkmgxeappg81H/HDLDofhglID2sOEgPR
	 v4u3hQ3Oqc69lAINptUMFNB9JkW83CKSDKrbIy7gf1+0j0JQSA/8uurRyguQFIWTW3V78
	 IDGOFzRNFrrTmhuNqEJfB2alE3QH15uncGpU75ndJoWD0xLmqTtjdvOOnB/G+21W8wM3a
	 C6H6qL64b+XCa+COrv3CyzlnT8yf6+kz035k71AyR3NXwezQbx0sbTxwzAmR6IUHsCSYe
	 ks0lU/0c0ldqlfTsonBunVQGN7x/eUjlAd2RT0a7uDrP0oejgAikhscTKPYkL9Eg7CA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052064;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mI7o6zCpMlb3pj8Vi47DTy26KT3N0xWmsnFpSEd6eFY=;
	b=0Vdm9REWiQ11Nv/+ZfVGSs6Df/31K+PiSA3f/8AwZjEB5odQnW8uMm0MdZJF7RUjiuEg
	 5iQOlFcwhkHoYOBtBpBk8+6tPZ4I9o8K0uo1+gL7MzJrbqaM08mLXNMgO2QaQjvVYE+kg
	 9Xlm47TzOuN1Wd+hIowf8sILzYMN2xbUafYUuYQx9gPpn6VkrxvTWpq0NaSD4DLG0UlEu
	 xspbgx9qHQepgyUruhuCeH7HmxeXBr3RkcJFO6928ZIwbfvRY7RB9dyCnM0fHCrnR75uA
	 FmsO7lIBNYHDNGJzNKWQWVTQa9XHIpZBgpuyCTxiD6N754IBmlCb8dwkUMvcuZ+qnSw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZMDgs8G4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B864606A320;
	Thu, 19 Nov 2026 01:34:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZMDgs8G4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A694B1F000C4;
	Thu, 19 Nov 2026 01:34:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052064;
	bh=mI7o6zCpMlb3pj8Vi47DTy26KT3N0xWmsnFpSEd6eFY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZMDgs8G4LkefzsskXgBjj6yY7uvxVlV4jGea73WuB/hbZOo21JYVyurl2GSI9Uguk
	 M3Jsl0jU8hJ0+R0kdGY72ItdvNdfvXcY6xVud5Aok2TFqQyCp+Q5Jsg6+t4rBVaiuV
	 d1pm2tfEaOdjp60An+gYbzXf1TjLPbXyOFHlzxlI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrzej Hajda <andrzej.hajda@intel.com>,
	Fan Wu <fanwu01@zju.edu.cn>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0432/2214] media: s5p-mfc: use timer_shutdown_sync() for the self-rearming watchdog
Date: Wed, 18 Nov 2026 15:35:08 +0100
Message-ID: <20261118150028.266734778@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fan Wu <fanwu01@zju.edu.cn>

[ Upstream commit 63069b5917cba2e15b1a78b3f4ff99e45102c56f ]

The MFC watchdog timer (s5p_mfc_watchdog) is self-rearming: every
callback re-arms itself with add_timer() and, on a timeout, schedules
watchdog_work. s5p_mfc_remove() tears this down with timer_delete_sync()
followed by flush_work().

timer_delete_sync() dequeues the timer and waits for a callback that is
already running, but it does not prevent a subsequent re-arm. Because the
watchdog callback re-arms via add_timer(), this is the wrong shutdown
primitive: once the wait returns nothing guarantees a just-queued re-arm
will not fire later, dereferencing dev (clock on/off, deinit_hw,
load_firmware, init_hw) after video_unregister_device(), DMA teardown and
s5p_mfc_final_pm() have run, a potential use-after-free.

Use timer_shutdown_sync(), which puts the timer into a shutdown state so
that any add_timer()/mod_timer() from the callback becomes a no-op and no
later firing is possible. Switch flush_work() to cancel_work_sync() so any
watchdog_work that was already queued before the timer was stopped is
cancelled rather than allowed to run to completion against the torn-down
device.

This issue was found by an in-house static analysis tool. No runtime
reproducer is available.

Fixes: af9357467810 ("[media] MFC: Add MFC 5.1 V4L2 driver")
Cc: stable@vger.kernel.org
Cc: Andrzej Hajda <andrzej.hajda@intel.com>
Assisted-by: Codex:gpt-5.6
Signed-off-by: Fan Wu <fanwu01@zju.edu.cn>
Reviewed-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
[ sashal: Adjusted context for the existing del_timer_sync() call instead of timer_delete_sync(). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/s5p-mfc/s5p_mfc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
index 4c511b026bd72..36cc6c85a5c59 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
@@ -1447,8 +1447,8 @@ static int s5p_mfc_remove(struct platform_device *pdev)
 	}
 	mutex_unlock(&dev->mfc_mutex);
 
-	del_timer_sync(&dev->watchdog_timer);
-	flush_work(&dev->watchdog_work);
+	timer_shutdown_sync(&dev->watchdog_timer);
+	cancel_work_sync(&dev->watchdog_work);
 
 	video_unregister_device(dev->vfd_enc);
 	video_unregister_device(dev->vfd_dec);
-- 
2.53.0



