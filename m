Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831477;
	b=RziOZwhrYtDMhAu+7UBswxju0KBlt6Q8GpQEUv9khj3UVTIl+W7ZzNA2oK5Ll+gIkerx
	 +PpBGarCwnsO9FLiu5NQUAU04f4MXELvFT87ee9NQ7/UtaTzQ0CEKuTltYJ5mgU8gj9Ab
	 tuqAnS8k1XKQswGc2o42f6hp0ah9MBUw19IXja2sa3lb8dB+sTcKUfo2uGu9whW/x0+tp
	 78r2aJqMshg0ZR9WeV7CIelUj5ZWMhVT0JIKIzEashlm6/g/6Ubro1TucaSUqT64uXJzF
	 SumOzvSt3kFbwlP72RQI30AlNSaURVhORhcpk8uMLs7ZJ0I1BdIJzCkVBgAAgypNJ+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831477;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EFYWagbdaJ/Dg4ucioCkGic+H7BL5U0AKytV9tydK/k=;
	b=iJTTyW1Lsrp4aqtnzwaHkIeCN4Ij5ryoMgLGcP0FCvDOv37jhP+OLDx11i6+82BLNPBM
	 Vc/QNfcre6N+ZRaHC2GTfhbJjko303DeiIbT0iSJx/vdBYAPBQ26DEfIFd6CNFJekH3gE
	 oVHYiRiuZptlUWj22eYnCnQa36ZRJYNvUwVgkglQnQV9UdbLjyXYLcgd3CkZZ55Xl+VHG
	 l3V3pgwaYpY9tYBF093ntNPYtuuovcYajxtbfeCZCMHNzSVGY8juDLPFq7c452rL73jFn
	 9Qoshv+2CtQmF6uzr07iR2T+srbxd8JZSl0eK1a4KPQ0rlCiyIekK2PIfUHFW6fC7ZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JWaGbq5G;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E75C606AC2A;
	Wed,  4 Nov 2026 22:31:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JWaGbq5G
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC0EF1F000C1;
	Wed,  4 Nov 2026 22:31:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831477;
	bh=EFYWagbdaJ/Dg4ucioCkGic+H7BL5U0AKytV9tydK/k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JWaGbq5G3LLKZVmQ/G7YiJlUXUGQSFcbjUYyJd9jDXksf3pLWJ4HUg+IFAbAZaKNx
	 CVxMRc/lF+hZY28BdWoDBZHZhvqnjlSrilrCyGkbbIo4q/sQ9txXtrJAJ7jga+0UlR
	 iCF3T7d6TOd6PqIT8WbObljounIvwnQAyZtxCcrs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrzej Hajda <andrzej.hajda@intel.com>,
	Fan Wu <fanwu01@zju.edu.cn>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.18 0728/1005] media: s5p-mfc: use timer_shutdown_sync() for the self-rearming watchdog
Date: Wed,  4 Nov 2026 16:07:41 -0500
Message-ID: <20261104211103.891532101@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


