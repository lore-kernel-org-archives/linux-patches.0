Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019948;
	b=UvI1D4RbLXSRoQAHWmc35/IfL2wKmqyipIiEthL9bT6AC2uEhiu9hq/2KBE6UKpSSIXt
	 LGf/QUEekEwx+BG9fCnWsxlOl3/adLkhCHsDkkEKEhoBBikqSzb0gy+G8WWwAz23eedIx
	 Cb/2kyquviCp1vGh2MxSokWjLKrHTT22zxJv+29oGlm9POd6VhozEBjAO1TPrVBZbHoCb
	 tulCKA40uEBcjllV0+ysqAOC6kp9oqazG8YpE12Fl1z7pgTFlQtge+Yy9mdIuuNHPbglr
	 7PThjZ5YvI0J/IMub15Q2JqdAtRMKsL/OfdjvZPJ3Ckjn7f1FyEdEowCw5qTlxcuNrA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019948;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SxEpjDUYtKDI53GBz2/jnbZfI4Sc69DGkv+L/8ny3RY=;
	b=22+K44GtTlgdQctvi23Jy5r3IW9oj72wylA+CrISstrQa7APSyLvjzlxGpdiD+e+XQOH
	 4Yud4yIBw/8yN1VhBleoUOn1NELGCa+GRekx4t+RB+Zt7kO4jcAUxKgrJpLfAceZC0F32
	 3/sp3aiFkyBRnQLaA10TEjtEwcQ5/dFTgiEJy3jEmQQypl2vWkqhKv0CTWxfVahIOFYGy
	 asgRdrJJzrZ2mOTuce0btCcd5qQCTaIfYrNYWM6M6dEPPMDnxDfqkcnYXvNtcYVqq130c
	 Ni2okP50Tjon33RU0q0W7X7UJ51IoCNs8l3rgVBDy+boBsHPJfNvZKEysmXLVeFH1FQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="hJW/pVmu";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62C6F606A325;
	Wed, 18 Nov 2026 16:39:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hJW/pVmu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B19181F000C5;
	Wed, 18 Nov 2026 16:39:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019948;
	bh=SxEpjDUYtKDI53GBz2/jnbZfI4Sc69DGkv+L/8ny3RY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hJW/pVmuhks3xGRvAc5xNiGoltPyeANlnS8o1W9wWU0y4+F9PrMiBhBV7zluE3f+R
	 a3dCGV9ePUgd6ZyiMERUkWHLfNgZNU4cq5n9TNOQwKyzYwUaZaqhCaWw025WIaim40
	 QBqcu0t4dWwyDHiz1Qq5sg7WnMPRIQgP7hQFM7o0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mingxuan Guo <gmx472@qq.com>,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1776/2651] firmware: cs_dsp: clear dsp->running on the cs_dsp_run() error path
Date: Wed, 18 Nov 2026 15:50:16 +0100
Message-ID: <20261118150351.322914646@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Mingxuan Guo <gmx472@qq.com>

[ Upstream commit ad6be54d13496a0b5c6d1edeea99504e438cdb7a ]

cs_dsp_run() sets dsp->running = true once the core has been started, but
the error path below it only stops and disables the core, leaving the flag
set.  The first thing that can fail after that point is the post_run client
hook, and it is reachable in mainline: wm_adsp registers
wm_adsp_event_post_run(), which can fail in wm_adsp_buffer_init().

The core is then stopped and disabled, but dsp->running still reads true,
and that stale state is acted on elsewhere: cs_dsp_coeff_write_ctrl() and
cs_dsp_coeff_read_ctrl() talk to the DSP when ctl->dsp->running is set, and
client drivers use the flag to decide whether the firmware is up (cs35l41
checks cs_dsp.running before its early events and on hibernate/resume).

The flag cannot simply be moved below the hook: post_run hooks such as
wm_adsp_event_post_run() read controls while they run, and
cs_dsp_coeff_read_ctrl() only goes to the DSP when the flag is set.

Clear the flag on the error path, before the core is stopped - the order
cs_dsp_stop() already uses.

Fixes: f6bc909e7673 ("firmware: cs_dsp: add driver to support firmware loading on Cirrus Logic DSPs")
Signed-off-by: Mingxuan Guo <gmx472@qq.com>
Reviewed-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Link: https://patch.msgid.link/tencent_B839C5A92D762B5717B9637A5CFA0841C608@qq.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/cirrus/cs_dsp.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/firmware/cirrus/cs_dsp.c b/drivers/firmware/cirrus/cs_dsp.c
index bb93b24c659dd..838fece8dc01a 100644
--- a/drivers/firmware/cirrus/cs_dsp.c
+++ b/drivers/firmware/cirrus/cs_dsp.c
@@ -2960,6 +2960,8 @@ int cs_dsp_run(struct cs_dsp *dsp)
 	return 0;
 
 err:
+	dsp->running = false;
+
 	if (dsp->ops->stop_core)
 		dsp->ops->stop_core(dsp);
 	if (dsp->ops->disable_core)
-- 
2.53.0



