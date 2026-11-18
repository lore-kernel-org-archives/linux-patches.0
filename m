Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059591;
	b=dGVJLq61GpyWhW2yGDOKA5eX7V55oCPaCVeC9gHd1RkdPCWOIZ7/t8yBvTl9t5lyMScD
	 l7moBYCiIcoDLzsh0zYjkMtuRb2Uio5+8qK4VG/a041ODDf7OHvfPCaxkdjoHn/2iTVm8
	 TySahQmVEiUgifYJSs/oozjijmtGMjaJxH5Y5tWoMhH7uqBRGz7QnJC4yW4sPSqzAS5Fs
	 l6lnyEhx3fy/xVbsCbudUfLfSNeKUVR4CbC1PqhJEkiQiVSL4JOFWAv/Q3Q3vc8uJUSWK
	 lL2ZunlqtI051DkOKPMxnlpXdIUUi8HV9WYprCftUuCnEO6uo/elqNISRTa9NB3mE0A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059591;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BkaWiQ6bwwmojKdt6xlMAIBg+dUcH1kdhrnmbOYDYZw=;
	b=LZ2WVqHSru84rGWcUUqppSgPl32Qru5MBPS/WbVZJcB5SJ0ob20/ATv8LZqMpkmVbyir
	 ARB1KKsOkHUXE1qDB9twasUgy0svyuT8oryDLlMUKa9tHRf+aWY4vBkoiZj3IrJ2QFK8s
	 zNqRW6ZwOJrWfQeyZyaQBk7xtigxKBpHWkD1+vtBldX4d4U79yvTpA5ZoX9nDLtOfX2kJ
	 c8/BywyHOSuMWT+7Deq+00tgFRz4ukSpin2N5qrzaTvNB7rpimdsNmR3mvCWrfxE0s3Rj
	 BrMK5QlmUTWahirkA89KblraqRBQLLcKJ3PJpCVX1MNK/xWlF9bLUz4lHF5grZ6ReaQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="OYxI/I9v";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA8CA606A332;
	Thu, 19 Nov 2026 03:39:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OYxI/I9v
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 101501F000CC;
	Thu, 19 Nov 2026 03:39:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059591;
	bh=BkaWiQ6bwwmojKdt6xlMAIBg+dUcH1kdhrnmbOYDYZw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OYxI/I9v2AWRxxarDEcDIR+ru/ERtr+GLwSYTrE5i6/6CaCqUX/CQ63ddLp3J1Iqs
	 /JOA9bZ2qrQ2h9LWP3UzmHB/aeV+oKQsYBJlAbUISjd+xXwxE2P3WNDO66B+aqKuCp
	 52/c85lqyjIxdjlc5opNLKaaf8G7CdQ7QbhZduNQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0897/1848] ALSA: mpu401: shut down timer before freeing MPU
Date: Wed, 18 Nov 2026 15:48:55 +0100
Message-ID: <20261118145954.209213169@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Runyu Xiao <runyu.xiao@seu.edu.cn>

[ Upstream commit 9332af5220d42341bb1446a62c545c0518e990ef ]

When an MPU401 interface has no usable IRQ, the driver polls raw-MIDI
input and output with a timer. During raw-MIDI teardown, the timer callback
can already be running when snd_mpu401_uart_remove_timer() clears the last
mode bit and calls timer_delete(). That API neither waits for a running
callback nor prevents it from rearming the timer, and free_irq() does not
synchronize timer callbacks. snd_mpu401_uart_free() can therefore release
mpu while the timer callback still uses it.

Initialize the timer once when the MPU object is created and only rearm it
while a timer mode is active. Shut it down synchronously after freeing the
IRQ so an in-flight callback completes before mpu and its resources are
released.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
Link: https://patch.msgid.link/20260927093809.681726-1-runyu.xiao@seu.edu.cn
Signed-off-by: Takashi Iwai <tiwai@suse.de>
[ sashal: Replaced unavailable timer_shutdown_sync() with timer_delete_sync(). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/drivers/mpu401/mpu401_uart.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/sound/drivers/mpu401/mpu401_uart.c b/sound/drivers/mpu401/mpu401_uart.c
index 65982d6babfc6..b8df6bf288ad4 100644
--- a/sound/drivers/mpu401/mpu401_uart.c
+++ b/sound/drivers/mpu401/mpu401_uart.c
@@ -161,14 +161,15 @@ static void snd_mpu401_uart_timer(struct timer_list *t)
 
 	spin_lock_irqsave(&mpu->timer_lock, flags);
 	/*mpu->mode |= MPU401_MODE_TIMER;*/
-	mod_timer(&mpu->timer,  1 + jiffies);
+	if (mpu->timer_invoked)
+		mod_timer(&mpu->timer,  1 + jiffies);
 	spin_unlock_irqrestore(&mpu->timer_lock, flags);
 	if (mpu->rmidi)
 		_snd_mpu401_uart_interrupt(mpu);
 }
 
 /*
- * initialize the timer callback if not programmed yet
+ * arm the timer if it is not already active
  */
 static void snd_mpu401_uart_add_timer (struct snd_mpu401 *mpu, int input)
 {
@@ -176,7 +177,6 @@ static void snd_mpu401_uart_add_timer (struct snd_mpu401 *mpu, int input)
 
 	spin_lock_irqsave (&mpu->timer_lock, flags);
 	if (mpu->timer_invoked == 0) {
-		timer_setup(&mpu->timer, snd_mpu401_uart_timer, 0);
 		mod_timer(&mpu->timer, 1 + jiffies);
 	} 
 	mpu->timer_invoked |= input ? MPU401_MODE_INPUT_TIMER :
@@ -484,6 +484,7 @@ static void snd_mpu401_uart_free(struct snd_rawmidi *rmidi)
 	struct snd_mpu401 *mpu = rmidi->private_data;
 	if (mpu->irq >= 0)
 		free_irq(mpu->irq, (void *) mpu);
+	timer_delete_sync(&mpu->timer);
 	release_and_free_resource(mpu->res);
 	kfree(mpu);
 }
@@ -537,6 +538,7 @@ int snd_mpu401_uart_new(struct snd_card *card, int device,
 	spin_lock_init(&mpu->input_lock);
 	spin_lock_init(&mpu->output_lock);
 	spin_lock_init(&mpu->timer_lock);
+	timer_setup(&mpu->timer, snd_mpu401_uart_timer, 0);
 	mpu->hardware = hardware;
 	mpu->irq = -1;
 	if (! (info_flags & MPU401_INFO_INTEGRATED)) {
-- 
2.53.0



