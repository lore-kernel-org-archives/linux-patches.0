Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061867;
	b=VXMr0S+ef/Ql+zAH3npfa2twyF5PlfPt8cBCoQyEN0as8BNg326pyxuo2mOAqh6mP3KA
	 Ex3HuhVlwlRbNW0tEb0J9d/K2Nj2oiyZB7YLty8+GLumuvYe6uJ6npCr1+oaAh/Y5b/gT
	 d1wdi2GRD8KgcM353MMzfBfJccR8UKor+6OaPqOIc3ykpcEqJ+thimpTIuXvT9YQnoozr
	 hiFXma5gCxEQV3YxSXERKwYwyBKdPwTWIEGmSUxsbA1kQE7vCQUw7x6QAk/FLipZ1fbCP
	 uyl3FlRlrtTFGF0m+PSYdbRIOItrK8l8UsqVC/XyYDbz41f4Y+XQyfi1g8ifhAsZ9Dg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061867;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lN4S0OPjgmJ8BqdkP/0SISCP8nNyHDTWMn2P0ztt0a8=;
	b=lM3fndKC9EZ3gP4sDKRceliuFjeEH4AsR9Owop87B0pgTzoLyKPaCOWAQ7gL7gvQFbAY
	 KGz5+Jdx1lL9kV1HssVR8zRziozEkT0/xYETM1Ywv/WC5+mt0uBXzvt5XVd9cZtJ5Onrf
	 iOJ/B7feqC8PFxzqe4UYRAymlWW9m8k8a26RcViR1zJ7bcodxA9ByNcjvUKlEdkdsouTE
	 ubWm+8RvOHbi0nofottB1W230uCUWQkWNj+0WFFygn4xakwNOdhKCvXpxnPXguAW8Pv4J
	 8cT3m3sBlKPEPG4ZhcdtgS5OC54nQOIVvBs7zceWJ//eGtrKdTKAkozEGvMoTxQYVdg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kjFosJRZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5B96606A326;
	Sat,  7 Nov 2026 14:31:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kjFosJRZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 974771F0089F;
	Sat,  7 Nov 2026 14:31:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061866;
	bh=lN4S0OPjgmJ8BqdkP/0SISCP8nNyHDTWMn2P0ztt0a8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kjFosJRZ3lrLo8w7N1MLWW42z7ufNIuVqUEnTWYyvC126o1m3cZ7peKXTC9NGcT7m
	 JSM5Mm4cxcH9MMSSvNGrg0+EeA0ZHsMn6h2SjI8hRommdl0PaOV37kyyWM+kUddoZM
	 MFP9Sqk7RiTGekpb7zlK8Z3NuiQ3MWhx/l1I4Y+E=
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
Subject: [PATCH 6.12 0883/1536] media: s5p-mfc: use timer_shutdown_sync() for the self-rearming watchdog
Date: Sat,  7 Nov 2026 08:48:19 -0500
Message-ID: <20261107135022.426543026@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: adapted the timer replacement to remove del_timer_sync() instead of timer_delete_sync() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/samsung/s5p-mfc/s5p_mfc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/samsung/s5p-mfc/s5p_mfc.c b/drivers/media/platform/samsung/s5p-mfc/s5p_mfc.c
index 50451984d59f7..eb844ddfd8a2d 100644
--- a/drivers/media/platform/samsung/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/platform/samsung/s5p-mfc/s5p_mfc.c
@@ -1458,8 +1458,8 @@ static void s5p_mfc_remove(struct platform_device *pdev)
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



