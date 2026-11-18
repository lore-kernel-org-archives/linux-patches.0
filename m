Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035757;
	b=Xt1fFGY6cvNPAeLnQcEG41E0eOjELGFNFHnvMYn/ADMr+dxCT2e3qoAvfafsvmPh1ys/
	 SiWfexv4uLNzdfJL3sJHYkiP+8XvBIEMm+37ApR92UiPmE6al0YQt02VO5NeApN14ksiI
	 zdUFfCm3s3vhqs6QY2LZ/pOI3YQ2YtzWhQ7QjI5w0zLJYp49tdtI6QSOB7z0ITlB02TV3
	 CBF8SFdwvskXleYo65ioDaM4HpAl5TKWXZNV6cIPdmNTMzbZEjvkxzKAGARoxh9toyy7n
	 ArUERiP0NoMsfYmhOCJOQ0HiZm8Tr2EAp13Dne6cX4o+tvfGqL13L3n1YXbb9WKZYfw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035757;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=G6VfzjIs4hyuOU131h5njQvbK6RQG7tywvFXmqFHI+g=;
	b=Z4PMGw+QJg/ShHxRrhmIEvHwB3IGeBk2r8OGIlHbIDtJI24D3DEb6hiKaUJKrpHQub9P
	 L+f1FeoyAFn+ZdilDCFJ+lDV6Y4RRnQUdem02dGeSlH22KpWuLMnc7wHZABWNqq3XoQrG
	 kfkcXUkAI2VuryGEMyuAiMyOAV42M3ClCMK8jd40rGhuNjVm1z6M3iIsES9BiH/vvlrp2
	 vTiz56Z/eMKcZ876SQqI55gQ1rysr4U3z5/8tbmKs451M7wvKFv0K99aQMDb0ZBaXVnAi
	 kc8nJ/w0pUWno1PNBymJ4s8248hAcWz1ph7l0iTaCdmLrpdRNIo2OYkegNPoalFItxA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NHU2T9NB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30B24606A31C;
	Wed, 18 Nov 2026 21:02:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NHU2T9NB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3125A1F000C4;
	Wed, 18 Nov 2026 21:02:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035756;
	bh=G6VfzjIs4hyuOU131h5njQvbK6RQG7tywvFXmqFHI+g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NHU2T9NBVNrsMtNiVMOilEzst25cUPrirs/1iSElY8DL9gekZOFW1NASX9nz4E//+
	 ljxbEQLTonvijy8ov2cmaNFVpz8pq28RLfiIHr331oJB2HqSeqqxrcPHtFG+jSsfPJ
	 jsnR9FcAyt73xiSRXWntD38XUxHn15kqHJplvPrw=
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
Subject: [PATCH 6.6 0789/3318] media: s5p-mfc: use timer_shutdown_sync() for the self-rearming watchdog
Date: Wed, 18 Nov 2026 15:23:31 +0100
Message-ID: <20261118150342.541360996@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: adjusted context for del_timer_sync() instead of timer_delete_sync() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/samsung/s5p-mfc/s5p_mfc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/samsung/s5p-mfc/s5p_mfc.c b/drivers/media/platform/samsung/s5p-mfc/s5p_mfc.c
index e30e54935d79a..1386208b092f5 100644
--- a/drivers/media/platform/samsung/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/platform/samsung/s5p-mfc/s5p_mfc.c
@@ -1454,8 +1454,8 @@ static void s5p_mfc_remove(struct platform_device *pdev)
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



