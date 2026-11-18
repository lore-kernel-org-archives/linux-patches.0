Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044819;
	b=TJqwkwcdiFQlvS/nZlC7V225cMenqMS3KDisfcJ7SG1cSlw9l7mhCcwbatB8Pc3hG/CW
	 VQrk/4QQTvJz6VdEUyVZJLHvHDHXatMF9okBrG/4QNX6pt/9UXh/kfjAs1jSQj6QEAlSy
	 RWDmeRJ7n42x/MOwf+8AJna5TfHg2a3+MAaMYReMWnb97TnR+blnFQey2EjgLEkW3O4n6
	 brOAxPzhTM6u4svXyp+mppIOf6ZxXk0vAXiK0eZLjO16UpzVn6erXYF8uYANq/EuX0OUA
	 uV4ClHcqarHgxLFPEsBM1cHV1SKVJJ55F52LicPPdwHlZsH4LBKV980PNlh8TQ5jrvg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044819;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=emH3RfIyH07om7YEmNs6X/OT9d3lLKq7nwHq27d/x8c=;
	b=pKkP9Aaxzk98XKmzuMHpDXmI3E+pLUqhU8Tdf44+8AaBjeiBbZo2Y/Ijwoj0MprwhWyA
	 bcaRfpop3CeMhsgOVs1H11DcSEeokwhD7OBRoNK2VY1GeX5VZBTnEHHr/2utrrahdh+RM
	 yYOclW2BSenyP2gz7ca4wlYRfQC8tBgSEuQTBZ5nRLew9ipdwcUp6B0TnuRg1XrzFERkl
	 lmhBM+NkxdsNPk4UMQd6ByhF/o/2wPKIYu+FO7MoeQNoATNQ7OXmSoeDDJUIriIhYhSrW
	 Kq0Z4viUmDRrXDVqButp5nzuL3xuz3fLhKHJnAy67ZDNyYq8TE4R6YHYsU1MvrcNXCw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UCtYcspR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5036560A263D;
	Wed, 18 Nov 2026 23:33:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UCtYcspR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63FC81F000C4;
	Wed, 18 Nov 2026 23:33:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044818;
	bh=emH3RfIyH07om7YEmNs6X/OT9d3lLKq7nwHq27d/x8c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UCtYcspRD9D6XG5IPgtWa3avGobLZ5OSMM67xRIelexPiluW/0ZfxzY4GNoJmk+D0
	 WO9cRwcJGcEyfw0Haoj8m7zCKd6NiwmwRU9ugFtW/JFbUqlytXXtrbr0NFG54EImUg
	 gQK9EhzjNXKS5UfJxTSHRFekMvedmR+hcO9IHN8Y=
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
Subject: [PATCH 6.1 0703/2857] media: s5p-mfc: use timer_shutdown_sync() for the self-rearming watchdog
Date: Wed, 18 Nov 2026 15:28:57 +0100
Message-ID: <20261118150226.867076429@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: adapted the timer replacement to the existing del_timer_sync() call instead of timer_delete_sync() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/samsung/s5p-mfc/s5p_mfc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/samsung/s5p-mfc/s5p_mfc.c b/drivers/media/platform/samsung/s5p-mfc/s5p_mfc.c
index 007c7dbee0377..58479d2a69fa0 100644
--- a/drivers/media/platform/samsung/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/platform/samsung/s5p-mfc/s5p_mfc.c
@@ -1440,8 +1440,8 @@ static int s5p_mfc_remove(struct platform_device *pdev)
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



