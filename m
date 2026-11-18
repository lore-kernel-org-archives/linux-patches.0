Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040883;
	b=AaA/P8fEktzaawG81ku/8aCD+PhA4WObL+dJPCrMaCbpeqKD9ubidJp/be9OCxm5oxOZ
	 ChJvGxvmLUoG+BrUeInIujxdt+jfBli0HoTkFDyDQuKIuUROGL6oG6jhgVex0WJIgJR5m
	 /YMdNzCeOrq3P4YKgtW9FKQ5qruPlFaVorFsuCYP3/jRX8xCnxOLzMzsvjlL1TnL0ADFt
	 GihdQ6E3Tlr5CHsAC9gk2FGafpCybdDmRO7Cy9qFxvnGZ4klTUWoocwFO4ZWk1ca+DJbN
	 xe6LCVVgU68r7s5CnHvc/clweczbW7gQcDoRVbaRrZSGGa9tj6CptEZyNQUTjB49EIQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040883;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XmfleCTkx7jrf12YOaEYRCP0msdDaU2wn2SRe9VM7h4=;
	b=sXzMrYXLC3XwwBsQilphce0usTBwtefmWMcK/2d9yJh5QEBITGUgG8AmYgqpUS/YOocE
	 7XZh/GgihzR4RWzfO6W1ynqc42bLWEZUYXh2h7ybmYTyTsPVpJxaTVqmH7wYussg5CByu
	 IHMz4yNnfOu+9X0CBCewH8EiIlLL6sbcTckwOzfeBatjZB6Hq2/ZhTLpaQDcmUgvRwHRC
	 i2nCdpFrTP0kCPm8UzMaErcVuNl5O5OL7D7yuh8FOvWen2r/sgHyhaXXrzgy/paPeSnDT
	 Gu+rERSqiDnfrv6tXNF2XoQk1yUJ4KnCjzr/M8gJJ+vbL8G68v96xyaqmDPZMukiMuA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hxolQbL7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CEF3606A325;
	Wed, 18 Nov 2026 22:28:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hxolQbL7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62B3B1F000C5;
	Wed, 18 Nov 2026 22:28:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040882;
	bh=XmfleCTkx7jrf12YOaEYRCP0msdDaU2wn2SRe9VM7h4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hxolQbL7bKkepD1RoC/bcvFHYkl8f7F04RsOQZ+X6vX100reaheFGnBJ1VYVkFoh1
	 cOOTxoiGJX1Y329BU6qOh2vryv5/skOzFtEBzFlp/WdeY/i4RgEgArTAaUtMPGSgRQ
	 02DmkuiXqd/68XKeMSNSIqAb1bZiulYVmqqtNjfg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Linus Walleij <linusw@kernel.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2614/3318] dmaengine: ste_dma40: Validate DMA specifier length
Date: Wed, 18 Nov 2026 15:53:56 +0100
Message-ID: <20261118150439.548696633@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

From: Linus Walleij <linusw@kernel.org>

[ Upstream commit 9f1064ebe17cf3ab65ac6eb166398e02678aea33 ]

The DMA40 binding requires three cells, but d40_xlate() reads args[0],
args[1], and args[2] without checking args_count. A malformed provider node
can specify fewer cells, leaving some of these values uninitialized when
the OF DMA core invokes the translation callback.

Reject specifiers that do not contain exactly three cells before reading
the argument array.

Fixes: fa332de5c6b3 ("dmaengine: ste_dma40: Supply full Device Tree parsing support")
Assisted-by: LLM
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/20260927-dma40-fixes-v7-17-89f595e8851d@kernel.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/ste_dma40.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index 7048274fcfeb8..240a42af1b207 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -2397,6 +2397,9 @@ static struct dma_chan *d40_xlate(struct of_phandle_args *dma_spec,
 	dma_cap_mask_t cap;
 	u32 flags;
 
+	if (dma_spec->args_count != 3)
+		return NULL;
+
 	memset(&cfg, 0, sizeof(struct stedma40_chan_cfg));
 
 	dma_cap_zero(cap);
-- 
2.53.0



