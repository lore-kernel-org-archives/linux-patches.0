Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793217040;
	b=zQyo/YVTRE5KtvdEq6w1Q/Jg0ubRNCPnjJNrOVlaQyP6XbUztoLjIwM6n3B3b/4Lldfm
	 OF182FLo6FbOYNnZqM8vkDg09IC6hdWpwsDFTWyK8jtSf7xmF6CaW8pKI7s4aZlXTSSpR
	 V4xmh3eBxDA0fKVx5p0Ea+8aO2/6y6pqEBizTPUEZcYVQHpgEEBAfFWNiMg0DoRorzomP
	 XebstyZVx0aK+4x9VTj5hnHLBO85PVig2RLVzGFEoKfVtn5qRkAEJSGqT1wJFC8zJ5r33
	 E5KaW73SVj0CIbocv0q4L+a8GvduOesg2j9ip40zOYNCZ+PUZczE+oJ1zhgwHHEJ4sA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793217040;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kpa6XD+8AZSpB8cLYcQtKhwlzyOabdckmOqUf5GyNAY=;
	b=OkS7np/48nI6/tgQhvD5bc9vbXNWhANvW01UzTVlvVlWq1y+YNn2EDrvHgjHw/L80EEF
	 v/L1MhHPy69mNA4fqgleihHi03E/u6csMxJX39Jx6S/z1f43dg/STJw+vooJe5E2TKT7r
	 Tmp06gLHaVD9F2jRyYfvxQ+LmJNL/HgL2XysUNKkX3XTguRCMNbTajcXDICcBE/vQX8SS
	 LLXPQblfuvwXmmLIKeFh+9IGNbQ76EbRVGvQ4B23G9nxzfmIaBXFJ1ysj2TlVFx54pnUf
	 YqGXY+B8BSYdmTlRxys6XGwOsLCWSJQ2/P6bh8tEyA8Kie4uz9nLEm7LdhHMKOJ0DLA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jNggmBYO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46444606A33C;
	Wed, 28 Oct 2026 19:50:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jNggmBYO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9368A1F01825;
	Wed, 28 Oct 2026 19:50:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793217040;
	bh=kpa6XD+8AZSpB8cLYcQtKhwlzyOabdckmOqUf5GyNAY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jNggmBYO8Nx3KgVQEcNBPe6god+esuCSav1KUbirwjIXOh132l7eJHRcK1IdnSwQO
	 Dm9IBjjTG7+N0Sy07Gtbn/yCAir37F9maEgvltAWGGPdBC4YBs4e9V2VDqr0bjzZml
	 M2vJZhd14/8izg6coTyITTp71eLnhlZ62mfQGOlY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Loic Poulain <loic.poulain@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 6.1 1740/1887] i2c: qcom-cci: Fix HALT_ACK reset request being dropped
Date: Wed, 28 Oct 2026 18:03:56 +0100
Message-ID: <20261028170539.050924161@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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
@@ -168,12 +168,12 @@ static irqreturn_t cci_isr(int irq, void
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
 


