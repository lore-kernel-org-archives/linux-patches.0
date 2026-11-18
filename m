Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026465;
	b=TfcOvjnhOeecOsrACzu2UsC2dD1SeP9KompGhtih4cXsra7wUgsV6NjOH5tDm9O0j6Tx
	 yXFKRwXbBqos03517DZ87aBfZpO4IaTadFusem70th1nqYrFFcn2+REFTdtYJXoHXJNXl
	 WFKdLv/03oVSj8mL7kT6xRdt2p31cyxrnwm4ParyugjAvLdHSVg1GTRWEKQ75gdJKTqc+
	 UgYWk++/5EofJh4KVZkekLebVCCQ4Y5vGkbGw4NG5OYcdwqcBc+UycXXZyOmSh2jALH7w
	 zGBEHvF7Z/elEuHTuSS2sknFNcdT7CSnq/VB9XtKa1RtMCiYPqNCgoslXHYxnf6fEsw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026465;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FnxG4R7DZNeGIy+5feNN5SUlUi1OnGnssg39BKFp7gE=;
	b=G0Y5KFWH1GwzAc27G4RL+ZqoOwE5o9YbbJHDHeUNX+BuErDHF1w/BC4H6ITqzshFSaLe
	 DtWXW2kutesW7fiLEVXSrBS0S5lDU+yxzISbA+6QN77U1+nwyLhsnQdfZpfDUW94EQ+Dq
	 tfIM3UqXDV1gVjWszSI6TMnTpwsj/o3PfFeZ8rup3mCHhe5pO6dNnu/TUf1fNp/goEJHy
	 gOv8+PcD/I8/VRhPrUp5US9w17p/M8RuINaF746ZfKgbss3OdBhNwQ/tSW6POzog5G1ap
	 YPfr797+ID8/dG36XXWPqy1TnUC+OK7/2KEmVlF0Rnn1L9omlFuao9iiClfF6ilWOcg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qX0RKu2e;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84D6E606A325;
	Wed, 18 Nov 2026 18:27:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qX0RKu2e
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D89981F000C5;
	Wed, 18 Nov 2026 18:27:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026465;
	bh=FnxG4R7DZNeGIy+5feNN5SUlUi1OnGnssg39BKFp7gE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qX0RKu2eEJaoCJWPj1s68Rr7RgTMmdmWNd6F8GqJZOzCLrKxxbPLCj0rcgAq4Dd2w
	 dwcBHuDH31gJAin3ahha2DlnbrxOYr9HNdhIPHxNAl6B5DQ0Amv2jiz6z1xFAJzrXe
	 OvKZEEoC7eyd1+uje1BPxdJ12dk9KFd6C/wB10T4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mingxuan Guo <gmx472@qq.com>,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1445/2151] firmware: cs_dsp: clear dsp->running on the cs_dsp_run() error path
Date: Wed, 18 Nov 2026 15:53:00 +0100
Message-ID: <20261118150214.567647646@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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
index 7ca56777a1da5..15710c97f9fb0 100644
--- a/drivers/firmware/cirrus/cs_dsp.c
+++ b/drivers/firmware/cirrus/cs_dsp.c
@@ -2911,6 +2911,8 @@ int cs_dsp_run(struct cs_dsp *dsp)
 	return 0;
 
 err:
+	dsp->running = false;
+
 	if (dsp->ops->stop_core)
 		dsp->ops->stop_core(dsp);
 	if (dsp->ops->disable_core)
-- 
2.53.0



