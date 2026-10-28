Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207616;
	b=PMh2HcZRbvEn+er/brOfwp/p7Jvd7FSxwOx7n385uUSqGcl38B0kBwxRhj3LuCw7O4KG
	 Cc7ZOzxFFggTCrhHJS11LRMQS4tEk8p1dkYjBgw6EP2SSfQYrE+ZcdJ0duLmTJvYT7Eh+
	 iD633gGVH6aKxQHhMnf47bpKbigsM+b5zvrX8ecJvE8st1XIM1TdKNVSJl0dAgh5IyGAJ
	 uSkyHN7u1GGqClmErMQ1AjSihmD+cEX9Rfx3W2qG4UC6DZNAuGp1HJVkC1uZNnvJzM4Xc
	 eYkNSlS7s33bHLsuFNDHCnQsypNQq9CzHMW2be4z4pzcaKo9sxG2chJ3f4MiXnO5BYw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207616;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IZWamuaxjWaVfpwfZzjNe/49fFP5pbm107AFuYw5EXU=;
	b=ad7rO/3czgftIo+LUqeHu/H9IVJvGCSId+gDBv9JC91pUhbIHOirtezBVjppb9Aw78DC
	 FNLrRfZO20zvYVmgUAm0mYZx6HqESp3XE95O/tQzs14BcDGoLHeKASOkfKSfkwHsgqVGd
	 6wQ0TdH0iWRniFo9U+ZmUx2lrdd15S1KiTsEoOfpZwwPgO/1ThE/mQJg2I7rb4Jzfg6Ym
	 za7Gj1WF1HqqLYqQIDPnTba9M64k8g8joqx4ughh3IhfTBwyXf9A8dD2RHj3GYgCBbXBD
	 jqwQK8elLX9Zd5+SrK5ilsQWG4Z+oie+jmugccwaB+NZLxxBKmSmQrJFV7LledK0xAw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=y8vxln9W;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 899F7606A31C;
	Wed, 28 Oct 2026 17:13:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=y8vxln9W
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA2D41F01825;
	Wed, 28 Oct 2026 17:13:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207616;
	bh=IZWamuaxjWaVfpwfZzjNe/49fFP5pbm107AFuYw5EXU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y8vxln9WErcM6gcfcXWjiBBvGGycMScyec0D6OulP1nxrJ0bNXOeJtwYmUmKDJpE9
	 61ZotxB6mCTk7QvXDoleKhPah3wx8y1EAQ/yyPhPhHZw3dZDsUyAkmg3oWRUos7XfA
	 JDf9dd9ty0M4kJhuR7O5NYDu5+WX7GO3OxG/W5As=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Loic Poulain <loic.poulain@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 6.12 077/247] i2c: qcom-cci: Fix HALT_ACK reset request being dropped
Date: Wed, 28 Oct 2026 17:58:00 +0100
Message-ID: <20261028165949.216190960@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165947.349197979@linuxfoundation.org>
References: <20261028165947.349197979@linuxfoundation.org>
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
 


