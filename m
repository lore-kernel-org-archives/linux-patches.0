Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061542;
	b=y5b9NYiraAz5AcFKDxeocX4vAv0AxWRqr7fVXWGL7YwPd4qEeSflgt/RcwXENNCwPWJH
	 fDaB6ikxPZCWqfug2dY8GwlgHBdUVuKI1rL5zVtCyQLZmvnbna2KraCeYPzg4L6/vgihN
	 dxpM+fnrbH0EnxbTRgp/VRXvQI7oJc3rw9YBvDPpfPVyNJCxeFVbrNYCEX+ER5r0XZ3Fx
	 52T0Le53Q/oeaTGzJAgWJOxELRhX5LtI4eHdybfYXa9kT9XXxNWzdIFzpVQguSLdzh30+
	 USZ8wn4aUX5JxC+BZGbybH7JylMiMhpxQLpzaMPRPMxFqXYVleRImDy5K3f8KGU+pWA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061542;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7PllYyO8QaZX4ZaSv/GDsY2dZteYPa13wCFmrm2gIt8=;
	b=QaYmh6NMd6xWFNmlEfuyCgDSZu/jjo6sAc2vAZUbNdV2rVZ451Z+vdwftIpamHhtxaSb
	 hd09qwTxOiFAwX6HkvQ8o160WFR9ekoHJWMYIbiiQf7gom4wue8+NNEbDcR8VxitbKq3x
	 v4YoNVY4umJ8047jIGJ4DTlzfkhWy8cd4libf2lPOo8KMsC5gWJNMZjS8FFQJomRh3xuw
	 /yK3PThfFn1J47omF9t01fZu1auxdNKTHADZC9Gja4dPRWIY347rARb54geU8E9oG0yx6
	 zaYTzYW17aWjANLPYtIBWXWLaT9z0tvqgqcE4ovzcAlUNtchW3UGis26f7UYtZWC+TA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="PwQjL/Cg";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4A4D606A326;
	Sat,  7 Nov 2026 14:25:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PwQjL/Cg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 923641F0089F;
	Sat,  7 Nov 2026 14:25:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061541;
	bh=7PllYyO8QaZX4ZaSv/GDsY2dZteYPa13wCFmrm2gIt8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PwQjL/CgyQgNP/wsOmakf4ExB0sT1+dejUYLsDbLSQvdmQZo7B61zVB+YxzpZxbUu
	 EdeODMNsuKu2j5mwQZ9gbbVUBC7+RPosBJA4OOcz1QcQCshJvz8wTEoP7w5cV67P3Y
	 P73D7Am/pkRguc8sGy33/0g2pSAt8PQa1BGfrDk4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	"Daniel Thompson (RISCstar)" <danielt@kernel.org>,
	Lee Jones <lee@kernel.org>
Subject: [PATCH 6.12 0578/1536] backlight: lm3630a: Cancel delayed work before destroying workqueue
Date: Sat,  7 Nov 2026 08:43:14 -0500
Message-ID: <20261107135013.791495282@linuxfoundation.org>
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


