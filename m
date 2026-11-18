Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049672;
	b=oERQ0pU2phvnuciFalAggosd0AOLbMLmbmteRogS3YJSEWhVzJQRpiJHSv+2aPiEFz7n
	 MFY2QbD3HwcY46dfhgxNzKLTf31G7kyQVBhFmUbTZEiXPUSPiDwhwJpQ4q830H12gBHLe
	 dalpNLqyjzSZ7phU8YXjqYVOHU4508HIBHL5ysV6acAzs5GHVRj8olFsxFJzePlOuWl24
	 KuNd1r00RnB0FTnq2kczXbvcIHTTIgRahTz7MlhHzr96ngVS0EAUz8kqgn/+Pb9fpQAEp
	 H8FaeLIOR8agX77reTxuqDCGw5N46cj4n873aK5C3Xm2q6x4N8HhyanVy48BTMLl0fw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049672;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jqRAsd+8YP+w7DWuaE1UukzMltWWgG11UFwixoYoy/Y=;
	b=WsvBdXz0WSHZX1mGEcbdQpFEaUD8cUi3/hbCbmEEpV7oCvFIchynydpNPJSd80lfYGh3
	 Q6KkQyU/erQ9sjp8S9y9ykR9JGL/g01f6ABXhFMNLXY1RJncKzoBFrsrWK2+c6ltB6LIo
	 gMit4C5YHUqOtW4tKWf0T20ac+JkxINlGkUihxRLYb0Ozxc4CKlMNXwEeIsDORh2Y8TqP
	 SGWLl7JIIk/dbTxu5PUXXBwbH/x3X+08DMtXcBxeft8a5tipxraihPxgNl2UnXvXZxvj6
	 5hipdBGBavkg2sQs29wBgUtE/NBpdsUaU8SEIyGrZY5XwC9zF1hQD6Wf+i1ZFnvw+Zg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PGUFJSgQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A048606A31C;
	Thu, 19 Nov 2026 00:54:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PGUFJSgQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2050E1F000C5;
	Thu, 19 Nov 2026 00:54:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049671;
	bh=jqRAsd+8YP+w7DWuaE1UukzMltWWgG11UFwixoYoy/Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PGUFJSgQOMTcJsE7aDHQIab47ZtxQ7p5MOEqfESzrQxSZZ1yu/D2iLe7ScIcDlXOp
	 fPkL9sl3EKYZ3WBi0ygJO+z4b0GFwsPLxBHmWymsZBVZPEclhcoSqyfRanIjHUkTwp
	 VVeQ062UjCAeHgfyZ1jq+Qrex3TaO/0ioKw0AgLY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mingxuan Guo <gmx472@qq.com>,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2434/2857] firmware: cs_dsp: clear dsp->running on the cs_dsp_run() error path
Date: Wed, 18 Nov 2026 15:57:48 +0100
Message-ID: <20261118150329.208009427@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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
index cf4f4da0cb874..e7988e29a0006 100644
--- a/drivers/firmware/cirrus/cs_dsp.c
+++ b/drivers/firmware/cirrus/cs_dsp.c
@@ -2801,6 +2801,8 @@ int cs_dsp_run(struct cs_dsp *dsp)
 	return 0;
 
 err:
+	dsp->running = false;
+
 	if (dsp->ops->stop_core)
 		dsp->ops->stop_core(dsp);
 	if (dsp->ops->disable_core)
-- 
2.53.0



