Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031800;
	b=4iDxgWmauVWydyloph6HXqcX5QXSEUvi/j/cYbgKMbckCqgbnZWNjEHE9wFdssDfXl+P
	 Y1MgqVf/5MN5dpdxlj3uSHfhN/gUcRUe+LMaUiDltvHI/sHtHPjH84xXeXPu/8CIFjb4h
	 K//RXfXpWuS57keHEEWRoMM3uLgHqvqB3EseDmln14wLtL45Ocy0Ys9fDvpLspqn8GIYC
	 fVyjgeRZDW8uUiuYaCWoF+YhT+ckJhEG0RQ5dMaWYIv46QxBeiOAmO00Wsf0AYmCRb3IT
	 t98Xi5CWDxCYV6I7VUEDv4Qkc0SlHuHK18I/c98Bhsj5qw56G/qGoTTVirEDhJRJ1qQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031800;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2vON+hkEJOqXyavYCT3o9FFRE/DWrrOy7/n1DRONaM0=;
	b=ipSQCuVeJRZ63aQ8MqN2XVigMPGD2ZOXztlXLmcvMm2mfVYXQ9hubGuMMqzZ3KZXDq8d
	 FnIMEh3UhfXm7JYnG2wpeWd6j/TQfgGmMW8txePtDbbcRBhDlLl3eHB2YCr46kqiZZXUM
	 fdHI8j3xmRUW/UV0pyX7b8rCVkR3Ieg8dDzRCQ6LbIsv767AzZran6b/0MDZ4itsItJCm
	 OoT2ITqkZAokf79jCHc9KssyO4KDwER662BQN/Lsl78GZU9Xt7nRuc/pS+7MNvJAEuA5D
	 lmT6eOyO1x5dmFXt/mMybYBa1ex2xfGNC3ukDTCnVSAnExxAhauOtzpIPiMbFFVKqaA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cZ4e9jAI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92B51606A320;
	Wed, 18 Nov 2026 19:56:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cZ4e9jAI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E73911F000C4;
	Wed, 18 Nov 2026 19:56:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031800;
	bh=2vON+hkEJOqXyavYCT3o9FFRE/DWrrOy7/n1DRONaM0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cZ4e9jAIK1Jz8y1nVYskQ5Dtb5h4oO8AwwTmBOGL6jMPD8i6TsxE1kBNZe86PBO4r
	 eV33fTd+xvaRYrjb7Ay9XY3dUUij50mhhHDICL7eBw0UofK5cDW0hvMfonAzVAdRIM
	 R0fJ8nTjama7l00QVuzo8P0Ia/kO64iUiNta1Ids=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mingxuan Guo <gmx472@qq.com>,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1149/1756] firmware: cs_dsp: clear dsp->running on the cs_dsp_run() error path
Date: Wed, 18 Nov 2026 15:54:36 +0100
Message-ID: <20261118150055.784927555@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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
index ea452f1908542..ff1d0793a7ca0 100644
--- a/drivers/firmware/cirrus/cs_dsp.c
+++ b/drivers/firmware/cirrus/cs_dsp.c
@@ -2872,6 +2872,8 @@ int cs_dsp_run(struct cs_dsp *dsp)
 	return 0;
 
 err:
+	dsp->running = false;
+
 	if (dsp->ops->stop_core)
 		dsp->ops->stop_core(dsp);
 	if (dsp->ops->disable_core)
-- 
2.53.0



