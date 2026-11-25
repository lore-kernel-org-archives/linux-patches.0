Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619711;
	b=evSO4+Wb34hfMBvNRdLdGdId6llgMY8kucVsgJl+PanGgX8nxsDBdKL7pPwF6HU+a/f8
	 tfCrsMyt1ZED/fNj08zzTp3Hg1ocpLjxudp+dW5ngN6cBEpxFn84aBayrqpFf/VbJK9Dp
	 WAWLtqRXr07koV2qyA87IAQ1K9VSgvSGclvR892SoU6ekbNx4SmlGoRvicEzPTqDC+CnD
	 NIyied2Rq2D6jkVdmX3idTsPXbBiriVkTamj2kI+j8Iivtds/tahw19p/KEWG1Y1FyqBA
	 E/lDzNiJSLxu8VLuEvuoM0SixhPZTplLkFBj9ifXDsh2Deeicb10fYYodOZ+pOW10nw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619711;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mHhQTz19dmQ276VWQJD8TKIncQ+7Q5RBJrucopg2Fx8=;
	b=yWHpaGT4O9Tx0a03/H1YxvwyiS/u7gEJZy46jpd/u1XLCN3cwnC+kqhgCV+bq848UoCj
	 fCBDsixkJK8PmubTqEyH5w8/i+D/4IUg5ogDvj9zmrcDnCYJZysTQGqpjRbGWNj3Scta0
	 5lvSODGN/AQy2G8EaUy/fi77bm9+Ca6KdcNgFPvjp7MqEGFmptfLqMwwF8JSc/ITJ6PrN
	 8vY6AhbmawnlzYyYPAJv2Nam3FOmP2YWaO80d7JhZdmAZHDpi6Ux/R4Fibbpq5utEj4D+
	 k/1nsEBHs1M2InZRZRR87spytNKPPwFXbln1WTgFua66z8/Y9wSlsOZkZhxIlFdTiCA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oMU77Gel;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E6F6606A32A;
	Wed, 25 Nov 2026 15:15:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oMU77Gel
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB18A1F000D4;
	Wed, 25 Nov 2026 15:15:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619710;
	bh=mHhQTz19dmQ276VWQJD8TKIncQ+7Q5RBJrucopg2Fx8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oMU77GelKpDOP9VfWBtZwExYH1+YO5go3ln8xhU0e0XErg+FwSJSgy3jCzZZxNOjC
	 f98PR6YqKeIgAz+dHD4alff1tyVxXzg1Vfl8DSdp5SsPJ5VWAwmJwVMPMBVvr6k0VK
	 TzH/0tfcAFjnfYKyGZx2+GQriI0ZKiZ2uxFBgFPc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baoli Zhang <baoli.zhang@linux.intel.com>,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 7.3 0683/1005] ASoC: SOF: ipc4-topology: Fix pin format leak in process widget setup
Date: Wed, 25 Nov 2026 15:33:41 +0100
Message-ID: <20261125143837.753104845@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Baoli Zhang <baoli.zhang@linux.intel.com>

commit e5c09fe3f9c8d9da33b177ee432db15b6ab46884 upstream.

sof_ipc4_widget_setup_comp_process() allocates the input and output pin
format arrays via sof_ipc4_get_audio_fmt(). When the following
sof_ipc4_widget_setup_msg() fails, e.g. because the firmware does not
provide a module matching the widget UUID, the error path jumps to the
'err' label, which frees the process struct and clears swidget->private
but skips sof_ipc4_free_audio_fmt(). The arrays are then unreachable and
are reported by kmemleak:

    sof_ipc4_get_audio_fmt+0xc9/0x420 [snd_sof]
    sof_ipc4_widget_setup_comp_process+0x8e/0x200 [snd_sof]
    snd_sof_load_topology+0x71a/0x840 [snd_sof]
    sof_pcm_probe+0x77/0x120 [snd_sof]
    snd_soc_component_probe+0x21/0x60 [snd_soc_core]
    ...

Jump to 'free_available_fmt' instead, as the other process widget error
paths after sof_ipc4_get_audio_fmt() already do.

The other IPC4 widget setup functions (pga, mixer, src, asrc) free the
audio formats in their common error label and are not affected.

Fixes: f9efae954905 ("ASoC: SOF: ipc4-topology: Add support for base config extension")
Cc: stable@vger.kernel.org
Signed-off-by: Baoli Zhang <baoli.zhang@linux.intel.com>
Acked-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://patch.msgid.link/20261109005604.1004362-1-baoli.zhang@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/sof/ipc4-topology.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/soc/sof/ipc4-topology.c
+++ b/sound/soc/sof/ipc4-topology.c
@@ -1310,7 +1310,7 @@ static int sof_ipc4_widget_setup_comp_pr
 
 	ret = sof_ipc4_widget_setup_msg(swidget, &process->msg);
 	if (ret)
-		goto err;
+		goto free_available_fmt;
 
 	/* parse process init module payload config type from module info */
 	fw_module = swidget->module_info;


