Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774015;
	b=dDcNOMGzv+F4iypyPg2beELyZzifzHoRStQw214g4NAWZ2DbNtDl9w92BvYRhJBPm4GA
	 TCj955uX4Sg5DwzOS4dt/MF9Rtr6Xsnc+XbUg6Hwl9bL4TyvxxIWfi+d/kJ+lzm/wP7i0
	 NhbkTpkZaV61g1dmq8GZMUlgOfsLYcNNYX85Rc1k29b5p/AOMrhfyZ8hIQSFx99ccVclG
	 tiu+v6ZxfIirtyWKx3njR0ztva8V1yWrPAuols2TzBv9gHqzMOejQ9kgafkmxDftx9mrF
	 NROTAxoLQVbSs8qTuhDkKs3y76z2J3E0dwhM1XkJ/r/xcCHyrO+66fiDpL1TJmz+/7A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774015;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qO0Bt5QvU4m5ZS9YT6SiHEQMcyJyA4KBpSC+zcNkbjE=;
	b=YUHTQHSc6f/XY5Ic0HrjgzTExywWJXe42x3Ne201EoGR9indBzxlMNBJy8+Mr/95bTzV
	 angE8//V1CKeHlnLoTJh44wHQaLVXn1VFq2eLt9VUHI8B+GU1ajFMmNwEHnSaRJwFqbPB
	 Po2gpokyrfk8LRshlLUYr4M5Xw4GclP+5XEXhKIhqFTG9Hl9GJqIMiM/Vsf1pJDxHIXHz
	 Or4IbCp0c3HsUr+LMD01M0I3V+sPXNo75t43t6hj+Yxdts0C3kMk9qgKgRQhbwKYUR+cw
	 hwAfvAABvpPH3K16w5tFGnhaZidji2nznybdOSYRQmtoJ/U7iX3FEDIRBGY01Bd236Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="m/1HnCJU";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A5E7606A31A;
	Fri, 23 Oct 2026 16:46:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m/1HnCJU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A8141F01825;
	Fri, 23 Oct 2026 16:46:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774015;
	bh=qO0Bt5QvU4m5ZS9YT6SiHEQMcyJyA4KBpSC+zcNkbjE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m/1HnCJUeoxPawrbqEk5AaSJAKLMN7eohFqZi6xbGtoiIFr78ytd4J4jttrlvm4xY
	 223G/ogak0ao3hKWr/tbWLVVzdS7mrDvE9iWNQjjLKDIOPnyAYsjAXBiXAhDc0jayQ
	 B2omje4+greLkKlqbVXyZbmXJda5+X+dBJ39ADDY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Loic Poulain <loic.poulain@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 6.18 091/193] i2c: qcom-cci: Fix HALT_ACK reset request being dropped
Date: Fri, 23 Oct 2026 18:36:08 +0200
Message-ID: <20261023163716.358627862@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163714.201276352@linuxfoundation.org>
References: <20261023163714.201276352@linuxfoundation.org>
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

From: Loic Poulain <loic.poulain@oss.qualcomm.com>

commit 195f3d74b5de98969dc4fad956393bb00787efd1 upstream.

A HALT_ACK interrupt indicates that the corresponding I2C master has
entered the halted state and must be reset before further operation.

The M0 and M1 HALT_ACK status bits may be asserted simultaneously in a
single interrupt. However, the interrupt handler currently overwrites
the reset mask when processing each HALT_ACK condition, causing the
first reset request to be lost if both events are reported together.

Accumulate reset requests instead of overwriting them so that both
masters are properly reset when M0 and M1 HALT_ACK events occur in the
same interrupt.

Fixes: e517526195de4 ("i2c: Add Qualcomm CCI I2C driver")
Signed-off-by: Loic Poulain <loic.poulain@oss.qualcomm.com>
Cc: <stable@vger.kernel.org> # v5.8+
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Link: https://patch.msgid.link/20261012-cci-fixes-v1-1-8cd4eb1fc5f9@oss.qualcomm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-qcom-cci.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/i2c/busses/i2c-qcom-cci.c
+++ b/drivers/i2c/busses/i2c-qcom-cci.c
@@ -167,12 +167,12 @@ static irqreturn_t cci_isr(int irq, void
 	}
 
 	if (unlikely(val & CCI_IRQ_STATUS_0_I2C_M0_Q0Q1_HALT_ACK)) {
-		reset = CCI_RESET_CMD_M0_MASK;
+		reset |= CCI_RESET_CMD_M0_MASK;
 		ret = IRQ_HANDLED;
 	}
 
 	if (unlikely(val & CCI_IRQ_STATUS_0_I2C_M1_Q0Q1_HALT_ACK)) {
-		reset = CCI_RESET_CMD_M1_MASK;
+		reset |= CCI_RESET_CMD_M1_MASK;
 		ret = IRQ_HANDLED;
 	}
 


