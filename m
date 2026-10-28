Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210136;
	b=I1G3+CuTFhNuZ6nMHyiPK6WxtBQMNADOwjnyuhsSiFAw2ocoIP+OViENuPXwdfx8FIWW
	 TyAoZvud5biP0gw9YWuYiJWnau4q3kzbzEqExTz32v8bAkU+u4aIrF9Gn79T9s/gU9B12
	 7tUjQPFRGfyK86WkSLndL0xihZtf2+5IlHKgew+ZHr/DfmvZgJy1uXQTte8ciSjbq0WOz
	 bQB9FQK/LhSWJTauJmYPr4fkt8ly2w0aUm3ekJj3drr7nbEYobNGFTmXbQr63qJVbotFn
	 hmgC02grzlPv48OM7Hvi5eJwtaf2XZ+VrDI1wcy7z40sBV+03SdMdu29WhxEFOVM9kQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210136;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=93DVdv1C2E/TpW41E7tWZFuTEj5esAjYbu28oa2BcDw=;
	b=BEJ1tbyHU+ygCkFUE00LPuaqtG3h8DmHB7eWEcNRMc504UkGn7udvTUnsAoowz19K2In
	 VXtBKvIK42WlINlNx3cO5YqSWOv4aU0B0azVadWqz36UUQjSUxid7hxntZQzPT+bAw0Vv
	 jHHIT+yuOVQ/wKUMYY0IAtIZFpY/c+JyTieMCs8t3A+GJxgaxqgoQvj8wB8sJSVGelHf2
	 vzMxSD5QqJMneXai97i2NinpP8mmaP5oqOnqDQi6EhpwYQ5/Vb8cUfJmfw7x5AmLp2LJq
	 roYuyu9G/KvQIoAI4pdj6K+86W9Ed8yZ/Sb2ak5fsvPHDYvqa0O/p4QzaGqCxgv6kCA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="j1fvGJn/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 557C7606A31C;
	Wed, 28 Oct 2026 17:55:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=j1fvGJn/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A360C1F01828;
	Wed, 28 Oct 2026 17:55:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210136;
	bh=93DVdv1C2E/TpW41E7tWZFuTEj5esAjYbu28oa2BcDw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j1fvGJn/5/V/p6K2yyModoEi9ueEWQMAr/jTmbCWLpsD4xjLmfBvN3lH0z8nVFATy
	 WBtWgdNgoJlP+k8ZP3congRUkIBvpLKEHMlEyEvjLtA4oiLRhc3BHEQu2vnI56bsNp
	 XF76u3ZFzYzNC54FP6KsYS4Yv/zRxZUa/UYDWRZM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Loic Poulain <loic.poulain@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 6.6 052/168] i2c: qcom-cci: Fix HALT_ACK reset request being dropped
Date: Wed, 28 Oct 2026 17:59:48 +0100
Message-ID: <20261028165944.320345930@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165943.089486480@linuxfoundation.org>
References: <20261028165943.089486480@linuxfoundation.org>
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
 


