Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795626064;
	b=2rmQyMXwlLeM3Tg7Ki5UofHiKEcYD+SSmiumBYk29JxemRLTisNpNZe2uRONdbVtiIA/
	 5MdlU2mZzuqM/fdjCjMwJqsstU0gbHLSsV4CtV74ml0LiM27djmFm9MznLXn490hAQ+G+
	 X/uMiNF8o2zrT1shD8p8nVQffOvzwjFNyIe5CQHKyUy20H4BpwCTsKR+B5Vcplhm7JmWN
	 2dcYUokkxbqGZ1lELCPHwEQ+lEswujzrXp0uKVHbb9IOkzQpvl6z8bZB66B3NbokxbEc6
	 iqaXyBH3L4VCgOQQGV0d+/UFEzmg2QJ5GdkRbvrjawly8YlPLVEdQrYS+SrpABJP6Ng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795626064;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tQ1uNGzDiiw4LwmAQra51rTrXfpG34YsRFT2cCh3Cw4=;
	b=ufCA18l48nq83IxWsBjYgLZzX9YW3zLgRSHq5uzJvtHfJWE0u1agGCNBCe8bOpV/+9tr
	 K0n0MoB/kIrgTwXhZyLud1n7YExhaPswYPRq2BYiKj0tutRJX/uqsNWdmP38rR29fodTK
	 f7wT+SDxIjOyP4JFce1iruPTnu4249lNs7YaTPUULkX/62hk67si2MtfQBVES55DjJlLg
	 q2t1DMw8GKMSGhvSs87yLpc5a1ZKKD9EiuKO4vKdb2aWg4nC/oPfmjhB+vMjoabWP2O+0
	 VI6LTz+ci3pkbIAeGuJSzBe97IZ/Um6Q31vTlC38d0muL8wXqQsNVFMntypAIqgSnBg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FGcVcjuu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C2E8606A331;
	Wed, 25 Nov 2026 17:01:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FGcVcjuu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 621181F000D0;
	Wed, 25 Nov 2026 17:01:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795626063;
	bh=tQ1uNGzDiiw4LwmAQra51rTrXfpG34YsRFT2cCh3Cw4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FGcVcjuu8WMhkPKO5wATqpXflx7dXZg3W/L/J8l/QA6Gv9LFoa1uhlhH3+o/G9xXN
	 jjO8Sv61iz4sR6UDLSrXejwjCtcOEBapYnm7pA/KEmIOdnMY5ib3qujN0Sw8fBxA3Q
	 +v19LZ+/e8H5tFDdcFLdaJxz6rxWoga8y7kEJXmY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>
Subject: [PATCH 6.12 721/816] comedi: addi_apci_1500: fix clearing of the gate enable
Date: Wed, 25 Nov 2026 15:37:49 +0100
Message-ID: <20261125143905.867683466@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

From: Josef Bacik <josef@toxicpanda.com>

commit ade85ceef46892425a08f3ee52ca06729ee4922e upstream.

INSN_CONFIG_SET_GATE_SRC reads the mode register of the counter/timer,
is meant to clear the External Gate Enable bit, sets it again if the
external gate was asked for, and writes the register back.  The mask lacks
its '~': all the bits but EGE are cleared instead.  So

 - the external gate can be enabled but never be disabled again, and
 - the instruction wipes the mode (continuous or single cycle, external
   output, count and trigger enables, retrigger, duty cycle) which
   INSN_CONFIG_SET_COUNTER_MODE has programmed: the timer silently falls
   back to a single cycle pulse.

With the right mask, the instruction only changes the gate bit.  An
application which sets the gate source after the counter mode now keeps
the mode it has asked for.

Fixes: a8c66b684efa ("staging: comedi: addi_apci_1500: rewrite the subdevice support functions")
Cc: stable <stable@kernel.org>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Link: https://patch.msgid.link/20261027-llm-char-misc-comedi-v1-2-1899771ee15b@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/comedi/drivers/addi_apci_1500.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/comedi/drivers/addi_apci_1500.c
+++ b/drivers/comedi/drivers/addi_apci_1500.c
@@ -696,7 +696,7 @@ static int apci1500_timer_insn_config(st
 			return -EINVAL;
 
 		val = z8536_read(dev, Z8536_CT_MODE_REG(chan));
-		val &= Z8536_CT_MODE_EGE;
+		val &= ~Z8536_CT_MODE_EGE;
 		if (data[1] == 1)
 			val |= Z8536_CT_MODE_EGE;
 		else if (data[1] > 1)


