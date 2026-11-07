Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063044;
	b=Uos7wH1KE2LAtX8uT1SjJBgP9UepgUytB9u2FjtBmhsszAWkFtDvSh6fwgK5GQe7GFEF
	 XkenettJ+btdC/Kik9lpgbTVbemWNyw/V8Bzga/4EcL038JGzoghA3cRqJSXp/PRUX5t5
	 F6JD14EPwZmh08hJSCjahbsMSG5EKYv1v4ueQfUnXGfMbCSGoa8AAYYPBb2fsqyDm43JZ
	 ee3GrKmmgElLh78LYhqkaDAl+nL7NVGUCkDaAy432vi40DSt3GwQ11dxwvpqKjHjYIWgf
	 YZjV66IxLUhmmCQHy4U4I6lWj7pSdvwIO2NTt6sKg0YpLcfdI2PCE1gF4QrcemCR9PQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063044;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wxesNjBL4NxLNy1HI/njYn3w+QL1MT4FN5l45CRI4J4=;
	b=hK/631YNwwFE1LxBeZah/TFUAvu8apDkXyu+HQtS1c+DU1EGSTmgwy2BMFuYhRUva6x0
	 Xla7ddaBK45f3pdHTJXlR5T3roFHIZ+8ym4nLbAY0x7b/BTWRuR0jHqqQOE3ti3GPGbCM
	 FDzdO/N7zCZGCKSfCnbIJkE0gi38MK3JJVdem0SP4NSY2kp02aHOGHq2VqYBXGFV5WdeC
	 nGHBajH4FFJYD8f4vTjDOJRA2Ox1B0OKSWxivYQ03mC3SAPplv6tZWzLW0azJEoGQoHJ4
	 Wwlf+bw1272AS8p9dxhA8w4nVPb7yIgBzf9c6IK9jMXiAmvFEgWV/fLKGxwMCOAiYoA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sQvItcDl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09400606D806;
	Sat,  7 Nov 2026 14:50:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sQvItcDl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACDCB1F0089F;
	Sat,  7 Nov 2026 14:50:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063043;
	bh=wxesNjBL4NxLNy1HI/njYn3w+QL1MT4FN5l45CRI4J4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sQvItcDlhXE/DjLgQRcrKqNe4M2p4TZzFQkuOcWw4dV8f11k8D5qoYIo7ofL5MoU+
	 zYVu9v6ULkRNI0JJ7GRvXBiZGnxDB821c+/byfZNsgQzcsi/JyYveWS7nUrUGww5Mv
	 aRGODIgn75tcHve5mHwjaoKvWD1EAkVk5bSnFjpw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 290/869] m68k: dmasound: Keep the Q40 IRQ handler registered
Date: Sat,  7 Nov 2026 08:49:32 -0500
Message-ID: <20261107134901.739863942@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

From: Runyu Xiao <runyu.xiao@seu.edu.cn>

[ Upstream commit fa2e77ac5bf81a60864e71fc72196227692d7162 ]

Q40PlayNextFrame() re-registers the sample IRQ after stopping it. This
function can be called with dmasound.lock held and from the sample IRQ
handler, so free_irq() and request_irq() can sleep or deadlock. A failed
re-registration can also leave playback without an IRQ.

Register one handler for the lifetime of the driver and select mono or
stereo sample handling inside that handler. Call the frame completion
path after releasing dmasound.lock so it can refill the queue safely.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
Link: https://patch.msgid.link/20260929085400.2068977-1-runyu.xiao@seu.edu.cn
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/oss/dmasound/dmasound_q40.c | 65 ++++++++++++++-----------------
 1 file changed, 29 insertions(+), 36 deletions(-)

diff --git a/sound/oss/dmasound/dmasound_q40.c b/sound/oss/dmasound/dmasound_q40.c
index e25a78dd1bf2a..339311e5d8070 100644
--- a/sound/oss/dmasound/dmasound_q40.c
+++ b/sound/oss/dmasound/dmasound_q40.c
@@ -49,9 +49,8 @@ static int Q40SetFormat(int format);
 static int Q40SetVolume(int volume);
 static void Q40PlayNextFrame(int index);
 static void Q40Play(void);
-static irqreturn_t Q40StereoInterrupt(int irq, void *dummy);
-static irqreturn_t Q40MonoInterrupt(int irq, void *dummy);
-static void Q40Interrupt(void);
+static irqreturn_t q40_audio_interrupt(int irq, void *dummy);
+static void q40_frame_done(void);
 
 
 /*** Mid level stuff *********************************************************/
@@ -372,8 +371,8 @@ static void Q40Free(void *ptr, unsigned int size)
 static int __init Q40IrqInit(void)
 {
 	/* Register interrupt handler. */
-	if (request_irq(Q40_IRQ_SAMPLE, Q40StereoInterrupt, 0,
-		    "DMA sound", Q40Interrupt))
+	if (request_irq(Q40_IRQ_SAMPLE, q40_audio_interrupt, 0,
+			"DMA sound", q40_frame_done))
 		return 0;
 
 	return(1);
@@ -384,7 +383,7 @@ static int __init Q40IrqInit(void)
 static void Q40IrqCleanUp(void)
 {
         master_outb(0,SAMPLE_ENABLE_REG);
-	free_irq(Q40_IRQ_SAMPLE, Q40Interrupt);
+	free_irq(Q40_IRQ_SAMPLE, q40_frame_done);
 }
 #endif /* MODULE */
 
@@ -403,7 +402,6 @@ static void Q40PlayNextFrame(int index)
 	u_char *start;
 	u_long size;
 	u_char speed;
-	int error;
 
 	/* used by Q40Play() if all doubts whether there really is something
 	 * to be played are already wiped out.
@@ -420,15 +418,6 @@ static void Q40PlayNextFrame(int index)
 	speed=(dmasound.hard.speed==10000 ? 0 : 1);
 
 	master_outb( 0,SAMPLE_ENABLE_REG);
-	free_irq(Q40_IRQ_SAMPLE, Q40Interrupt);
-	if (dmasound.soft.stereo)
-		error = request_irq(Q40_IRQ_SAMPLE, Q40StereoInterrupt, 0,
-				    "Q40 sound", Q40Interrupt);
-	  else
-		error = request_irq(Q40_IRQ_SAMPLE, Q40MonoInterrupt, 0,
-				    "Q40 sound", Q40Interrupt);
-	if (error && printk_ratelimit())
-		pr_err("Couldn't register sound interrupt\n");
 
 	master_outb( speed, SAMPLE_RATE_REG);
 	master_outb( 1,SAMPLE_CLEAR_REG);
@@ -456,31 +445,35 @@ static void Q40Play(void)
 	spin_unlock_irqrestore(&dmasound.lock, flags);
 }
 
-static irqreturn_t Q40StereoInterrupt(int irq, void *dummy)
-{
-	spin_lock(&dmasound.lock);
-        if (q40_sc>1){
-            *DAC_LEFT=*q40_pp++;
-	    *DAC_RIGHT=*q40_pp++;
-	    q40_sc -=2;
-	    master_outb(1,SAMPLE_CLEAR_REG);
-	}else Q40Interrupt();
-	spin_unlock(&dmasound.lock);
-	return IRQ_HANDLED;
-}
-static irqreturn_t Q40MonoInterrupt(int irq, void *dummy)
+static irqreturn_t q40_audio_interrupt(int irq, void *dummy)
 {
+	bool frame_done = false;
+
 	spin_lock(&dmasound.lock);
-        if (q40_sc>0){
-            *DAC_LEFT=*q40_pp;
-	    *DAC_RIGHT=*q40_pp++;
-	    q40_sc --;
-	    master_outb(1,SAMPLE_CLEAR_REG);
-	}else Q40Interrupt();
+	if (dmasound.hard.stereo) {
+		if (q40_sc > 1) {
+			*DAC_LEFT = *q40_pp++;
+			*DAC_RIGHT = *q40_pp++;
+			q40_sc -= 2;
+			master_outb(1, SAMPLE_CLEAR_REG);
+		} else {
+			frame_done = true;
+		}
+	} else if (q40_sc > 0) {
+		*DAC_LEFT = *q40_pp;
+		*DAC_RIGHT = *q40_pp++;
+		q40_sc--;
+		master_outb(1, SAMPLE_CLEAR_REG);
+	} else {
+		frame_done = true;
+	}
 	spin_unlock(&dmasound.lock);
+	if (frame_done)
+		q40_frame_done();
 	return IRQ_HANDLED;
 }
-static void Q40Interrupt(void)
+
+static void q40_frame_done(void)
 {
 	if (!write_sq.active) {
 	          /* playing was interrupted and sq_reset() has already cleared
-- 
2.53.0



