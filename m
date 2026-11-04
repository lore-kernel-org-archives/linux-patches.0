Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793826957;
	b=rEshAa8aJM99UFUDGUn4BCzNraDkv3cfl2K1rrwFTdbXL0HmaVxrsXe8QczQ/42AhoLJ
	 /eUNDw3ebOUgFhymzh4vJp3Qsdkrni/HlT07/EBEeDlBs9l6kpLB6X9ea+z4+1FwqH51y
	 7/lWDYCu9mfKX7Bk1IpS3CrWFwD+bip9IjUUSVdZkafPQ3KVnz2k6DfIL2PTZCTwgcZM6
	 opANt6YiMwRebZBnJlxwFDL7KWDnqWdqSJnCrxBiQeSYATNbYCqQc9MfcKsMcGW6OL+NF
	 CjyvUhyesBWAeaegfRrXFUWl3njTrpuEokzEOm5MherqDt/fpgqYNPfbysiCiUgzFrg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793826957;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=O/pNUG2Gts9LkOcDgIz49Ilg2yU/IKcFvInCIcfaoZA=;
	b=gTH+zJJMPgqKqHhWGoD6BXxh3RtRTY/lQayjRqf1p1GJ15cgl2c93wj7+0eucsWcHcy1
	 e4F3ATpFJJYX7BHo8oVqCu8g4cn7NJOO9AgmWfP6RU7kwOGgkzP66yojI9VUgSSj0r4Da
	 kyDGCyalrtMk7Ezg4GbL1sM2u7PHHGxv7NqEjJdGigkYJqgfIjwpeP1mwQE/tK/TfKoKr
	 lR6SVRxQ5MKlPHNwDvQz72seJb2vJ3WePGyyNxzHWmHyVJin0MPHPgyZLcXcazdqoD3un
	 l0uh2OZ21HJEyMoamyc1Q3IMD7S0Xn/F/RucYmGFf148QTuakEyGjst1PEmqJmkcmtQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2FtsXg8Q;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3705060709A1;
	Wed,  4 Nov 2026 21:15:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2FtsXg8Q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1C6D1F000C1;
	Wed,  4 Nov 2026 21:15:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793826957;
	bh=O/pNUG2Gts9LkOcDgIz49Ilg2yU/IKcFvInCIcfaoZA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2FtsXg8QjpbH+RCMBqpOd/d0kHt3hRzlD3zX66eVtmwGUn4mkNZ+TvdQZCs3VWa14
	 d/Ea5KBI6xeSFsFnemntMNi9E21e08sr5SqH8FWX9/NgXVBU0wV59p2NQ7eEBDCx1a
	 5y7dskX6lRMfbzpvrBjotuM7IKjMBzkODqsxUsXM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	"Daniel Thompson (RISCstar)" <danielt@kernel.org>,
	Lee Jones <lee@kernel.org>
Subject: [PATCH 7.3 109/547] backlight: lm3630a: Cancel delayed work before destroying workqueue
Date: Wed,  4 Nov 2026 16:04:53 -0500
Message-ID: <20261104211041.307248041@linuxfoundation.org>
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

From: Myeonghun Pak <mhun512@gmail.com>

commit 2cf184caab8b406fdd9db126ee40d62418237456 upstream.

The interrupt handler queues delayed work to read the interrupt status.
After free_irq() stops the producer, this work can still be waiting on its
timer. destroy_workqueue() cannot drain delayed work that has not yet been
queued by its timer, so the timer can outlive both the workqueue and the
devm-allocated chip containing the work.

Cancel the delayed work synchronously after freeing the IRQ and before
destroying the workqueue. This also waits for any running status read to
finish before the chip's resources are released.

This issue was identified during our ongoing static-analysis research
while reviewing kernel code.

Fixes: 0c2a665a648e ("backlight: add Backlight driver for lm3630 chip")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Reviewed-by: Daniel Thompson (RISCstar) <danielt@kernel.org>
Link: https://patch.msgid.link/20261003030439.599330-1-mhun512@gmail.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/backlight/lm3630a_bl.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/video/backlight/lm3630a_bl.c
+++ b/drivers/video/backlight/lm3630a_bl.c
@@ -591,6 +591,7 @@ static void lm3630a_remove(struct i2c_cl
 
 	if (pchip->irq) {
 		free_irq(pchip->irq, pchip);
+		cancel_delayed_work_sync(&pchip->work);
 		destroy_workqueue(pchip->irqthread);
 	}
 }


