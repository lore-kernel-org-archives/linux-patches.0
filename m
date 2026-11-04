Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793827161;
	b=DnTK/AJS+5qa9qnU1mI/+mg78eOX1ZHaP+r6AKKYUxEFUiyb8SMTSgHQTMf8BNyqdO2d
	 rlFygOQt03nqZEB6VO3ZkL2JSop1AAU7wyNLq0zubSfIUAh1fPowZrzUC14+rB8EQTzmI
	 OCHuw3Hx98NVH2CYB98RB0LvwXBE0DMSCt+hdx9s8yIlMf1rS3sWguuZmn3oxVW50wcoq
	 2ATyjrh+qdUGhXCPlbZot6kJiMm+RHsKVVrZ2vO8TN+pzmRNzyf9s31Zsg3Zi/4dpjci9
	 Okdia5TKOh/hvCghOzWW+MPV+ol6NJ/DOTdSugcR5Y+sZQSBrpk/6FGCOSEWbhV7p2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793827161;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cIukMbgNpLK3zrgZZ/wZyGVPBkNOGzkg71M09qlpcYE=;
	b=thEJKrobFzLJprKcHatWX6UUBcuCjPNlLAqv18T3ZuMVZGdTQ6+ilt/oSFtcrfc/gjyC
	 9aLTtvfnGrQIK5EZS1PWTJbhWa1HvldnoQDRrAsw8tAy0vvmSBvLPkkzjXLneS839KeJJ
	 f+DsNLuhjgwq48CE2lMbw64DbMgqid8TY8czNobM1aMp39T8jUe4/xlJfPUwRj1jKR9na
	 0nmTJVzq9HNJxh4yLT/HSwk+7YNNYCQL4mx2lE1T7pCWSB7PygZs7bkXJw1hJqO9YgQzg
	 1zeFrHIuGOW6xvFbB4Rw8Md1YV7049IWxBp+hehKxAmKpKfWH9BKpVvp4b/xHUgXd5g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G4y4nwKe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3386606A86E;
	Wed,  4 Nov 2026 21:19:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G4y4nwKe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FF061F0093A;
	Wed,  4 Nov 2026 21:19:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793827160;
	bh=cIukMbgNpLK3zrgZZ/wZyGVPBkNOGzkg71M09qlpcYE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G4y4nwKe+YY6SJbO6FBWQABdsGeUISeHK4BKnijYoyz29ixEuvWsevlJdEDLz3nvh
	 usGi7l3rTUn2xSZMv72ksl6YKjmDNZaksxYxQ6fXUCUW2nNnsP3zvGNYnudUwEsoAg
	 ODbr94Vin44oSHeLYZsYIxoZyZChb+8YGleEB1CY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrzej Hajda <andrzej.hajda@intel.com>,
	Fan Wu <fanwu01@zju.edu.cn>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 7.3 232/547] media: s5p-mfc: use timer_shutdown_sync() for the self-rearming watchdog
Date: Wed,  4 Nov 2026 16:06:56 -0500
Message-ID: <20261104211044.749889244@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fan Wu <fanwu01@zju.edu.cn>

commit 63069b5917cba2e15b1a78b3f4ff99e45102c56f upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/samsung/s5p-mfc/s5p_mfc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/media/platform/samsung/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/platform/samsung/s5p-mfc/s5p_mfc.c
@@ -1474,8 +1474,8 @@ static void s5p_mfc_remove(struct platfo
 	}
 	mutex_unlock(&dev->mfc_mutex);
 
-	timer_delete_sync(&dev->watchdog_timer);
-	flush_work(&dev->watchdog_work);
+	timer_shutdown_sync(&dev->watchdog_timer);
+	cancel_work_sync(&dev->watchdog_work);
 
 	video_unregister_device(dev->vfd_enc);
 	video_unregister_device(dev->vfd_dec);


