Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620105;
	b=aiebvxALSvIEZX5zVFco78VuZ1O5+sP01XWisSk1Ju1Ra+zeK7IOzWgoQJ8TculR33St
	 Y9Nrr6TzlM9iYghK7zyJbpN2is2ilDWqnoPKt1ztYkYOjyGvduSVREj2RYvNU5wSXo7VY
	 vEc5IC0osU1LVA92LG5PjvGIohaCRQP5WCKjxjW1hxl/Zbx9x+QdhJ08lyMGw1pk3hpcD
	 4v9ORxz4sqiPDM/fYJ2Pv0h+5FKa0NQnyh+IARrdmH/ckMgWwyTVeREjo21zLiCbxTtih
	 l5i2mPCw0MOzv7qS8K1ZIea2SSK5zV4ClZcudFr9cohqbqQGbYJoyGqNUS3xQPJwhdQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620105;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ooqjLtLCE1PcSq8IyolPWC4szutegVgAbPiiJ3Zyx8k=;
	b=baFp8V40jm7ruwOmWNaOOQE3VRa2Avo5aQBaMUkbEItF94FiesS66NFlXskq7dT2Xl15
	 a0rn+2B7CYI1Ipu0nmzCz2XSo3DDmSVjEzkefYlPNuFB0pyLOO4HobW7jyAsKmEZCIE0u
	 RgTy2eUHD+F8zozJteAlR5HIsmCJEibcnD3OWvCxOXKOd2oPo/Cx0SQ104S6XIG9e9had
	 9Mojnh0xlOAkJgytyUNUM9j4xa91W0VFRjENG/VAAUIeH5aZjk8MKDQY/yb8Gk9vbVWz3
	 jm0bpBlMIgPM5vzK+vywFu3eYkFTxmxp3vzlGoAAeJsugYxwgIFM3UdH+KEUeeaz8eA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gRn+cHf2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62E7F606A321;
	Wed, 25 Nov 2026 15:21:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gRn+cHf2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C7C41F000C0;
	Wed, 25 Nov 2026 15:21:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620104;
	bh=ooqjLtLCE1PcSq8IyolPWC4szutegVgAbPiiJ3Zyx8k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gRn+cHf2UBn6mu4sdUWSTKE9q4pjtXt4hpedXK/ix4TAivJZCbQx3++AuwpJLJij0
	 MdyWhl5KfkULlJxMUtYi464b6v9a//58OQYH1CtjkGUBnvB6V4ymCJEYp7A1ur/gdz
	 rza07wl9FLZCpsRMOCtjYvQ/UBrdA+r8WCqjMxL0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Billy Tsai <billy_tsai@aspeedtech.com>,
	Andrew Jeffery <andrew@codeconstruct.com.au>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Subject: [PATCH 7.3 0810/1005] gpio: aspeed: Preserve the pending G7 interrupt status on control writes
Date: Wed, 25 Nov 2026 15:35:48 +0100
Message-ID: <20261125143840.704893143@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Billy Tsai <billy_tsai@aspeedtech.com>

commit 18cc1d1ad94df8a6760fff2617d3d6923550cba0 upstream.

On G7 each line has its own control register, and its interrupt status
bit (bit 12) is write-1-to-clear. aspeed_g7_reg_bit_set() updates a
field by reading the control register, replacing that field and writing
the value back. When the line's interrupt is pending, the status bit
reads as 1 and is written back as 1, so updating an unrelated field
such as the interrupt enable, trigger type, direction or debounce
selection also clears the pending interrupt.

Mask out the status bit when composing the value to write, so it is
written as 1 only when the status field itself is being set to ack the
interrupt.

Fixes: b2e861bd1eaf ("gpio: aspeed: Support G7 Aspeed gpio controller")
Cc: stable@vger.kernel.org
Signed-off-by: Billy Tsai <billy_tsai@aspeedtech.com>
Reviewed-by: Andrew Jeffery <andrew@codeconstruct.com.au>
Link: https://patch.msgid.link/20261104-gpio-aspeed-irq-status-v1-2-9805645f856d@aspeedtech.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpio-aspeed.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/gpio/gpio-aspeed.c
+++ b/drivers/gpio/gpio-aspeed.c
@@ -1168,7 +1168,13 @@ static void aspeed_g7_reg_bit_set(struct
 	u32 write_val;
 
 	if (mask) {
-		write_val = (ioread32(addr) & ~(mask)) | field_prep(mask, val);
+		/*
+		 * The interrupt status bit is write-1-to-clear. Keep it zero
+		 * unless it is the field being written, so that updating any
+		 * other field leaves a pending interrupt latched.
+		 */
+		write_val = ioread32(addr) & ~(mask | GPIO_G7_CTRL_IRQ_STS);
+		write_val |= field_prep(mask, val);
 		iowrite32(write_val, addr);
 	}
 }


