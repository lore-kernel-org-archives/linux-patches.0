Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041444;
	b=oXELjLAdytUpLFNNNGR2gwiNmLIuTPq1J0of6d/1W2JdYj/Csd6i2VYQ3WpU/A2PhUc4
	 ufB97LxmZiteXgFdjhotp8Ddd1qXvP6Fxf0IDO5O2OY3PuKK+g5G/2Rh6/m+21Yk3odHK
	 WFUhbXsLvEcLklCA4dS31RTLd4co0oiqIgMQ8PUWfele/V3XtOCTeOzMk/b51IflmxsUc
	 g1dnjXASNoyGKAa0Yc6NEPGHY/p12W0wrstnibKs9nBqfnIWqYOwsXkn5NvwJ3WQmukcz
	 8sDSKYGKfCyVz5BWhVsaHzlozKWUDn1j5vtKbRW23rrvbgoFwDeoPl6pl7ScjwSg/oQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041444;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WoBrHX91YvHkhWbRLcYp1E4Cg43b5IyAT1btTL+vZEs=;
	b=hOFBvTFVY4KtEd03OQVmWG+OFmGFLaqpKshcEBmT9hjjmxzfq9/teSzLYOjK0HTdcgbk
	 Hvo//OPRZ7Fy8L0Oa1eRvzTFRexOfPZUHjykjbtX+dNsC0VvgYQDi4Ivt0e52ycHFiHcT
	 ZmhVl36Ru/nZZQ33Id36CCciUUHK0HXl+qdTEsp7Uh9bi53m7pUWQyKR24B/23XnIzouq
	 GFT/50FXIdlx2OmjTWY7pmvIT3d19CLFckVaulj2brss3M8+yibnfi/T3gRhuBVZWmkmu
	 z4gjKrv9m6nuJHarXgstyCA7SWHGiUzeNgbpKsU4BZ5uFqwy//S5cWvQmN5vzwOeWtQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K0TfSmt7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6C19606A984;
	Wed, 18 Nov 2026 22:37:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K0TfSmt7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F32891F000D1;
	Wed, 18 Nov 2026 22:37:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041444;
	bh=WoBrHX91YvHkhWbRLcYp1E4Cg43b5IyAT1btTL+vZEs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K0TfSmt7yzQEXF/8d+Mm6DSU5E+vVAznxHJs1k6X45iiyZU4UOd3NHgw+CMhXLJ+C
	 5qwridqkRlh43ArGOB2e6NMsXaAUcn1JoeWsxCxbuuPsb30kGd2SdTQ8SMzWEBKi4q
	 UGcKv+hqGvzG4KQbL8m61iI2ROITavNr5hRVgWs8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mingxuan Guo <gmx472@qq.com>,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2817/3318] firmware: cs_dsp: clear dsp->running on the cs_dsp_run() error path
Date: Wed, 18 Nov 2026 15:57:19 +0100
Message-ID: <20261118150445.162560282@linuxfoundation.org>
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
index c015d2b4c5cf9..575b2f509f726 100644
--- a/drivers/firmware/cirrus/cs_dsp.c
+++ b/drivers/firmware/cirrus/cs_dsp.c
@@ -2834,6 +2834,8 @@ int cs_dsp_run(struct cs_dsp *dsp)
 	return 0;
 
 err:
+	dsp->running = false;
+
 	if (dsp->ops->stop_core)
 		dsp->ops->stop_core(dsp);
 	if (dsp->ops->disable_core)
-- 
2.53.0



