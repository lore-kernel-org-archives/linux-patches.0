Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DA35402B87;
	Wed, 20 May 2026 18:49:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302959; cv=none; b=evxVa8u0xNQA4o1l8fjIXb2B0GimLbtN8Ov4GiiXcnXyMGxsOrKsm/JQgXbjfCpqnMDM/YInVq1TfRDQT8gGTgFep0uTNhPANCrvr8Un/QbB9JeReEaM3msj8mau7lt7bKX/mG+ysYYmoTPg1tqzwPO9WSJzV1CnSgrKV9+8nvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302959; c=relaxed/simple;
	bh=Ux1x5Dn405RwQpkUnpMbpuYGMFS37Hw/Bw0opNgag50=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TZavbi4vRV2cXU+WMFPe7iI6VI3EM/OB7ZEQlzjmrb2fk3ZjxWAPSNlSTErAXrpVB8mqbScnnJacn0wT0zOoRWn3pKzUFmFRQQX249yzGi573pVCXZ2AyC1+ksqQBy7VTfEfDWO9GSfqOhrp4LzNQMdFJJhlL+2mwvY5zlugB0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sl6qBBOa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sl6qBBOa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6BAA1F000E9;
	Wed, 20 May 2026 18:49:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302956;
	bh=TAorVrldkDVZJbPgsEWwufmoX7FFi+obyfvtkXWjXRE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sl6qBBOagok6ZDScEbxkvFVbd1GYCsO81fSZECLQmSFRnD+Y0Yk4VBJ6SslHQVZwB
	 rep4kylYi2tHU0gFIC0YiLptphYmOO80ALrii9f8QCGvjssGcGLeK/aWUtJ1dKoO//
	 udM7uzqJNFQOj83sDp6/NMVpuIR4HQEUZHUnIiOg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	=?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Alva Lan <alvalan9@foxmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 463/508] ASoC: SOF: Intel: hda-dai: remove dspless special case
Date: Wed, 20 May 2026 18:24:46 +0200
Message-ID: <20260520162108.630070460@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

[ Upstream commit daa09d0615ce9c781777802874cffa4380f883c3 ]

The existing code forces a parameter to be NULL but that parameter is
not used yet. Remove the special case in preparation for additional
changes.

Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Péter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://msgid.link/r/20240213101247.28887-9-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Alva Lan <alvalan9@foxmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/intel/hda-dai.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/sound/soc/sof/intel/hda-dai.c b/sound/soc/sof/intel/hda-dai.c
index 19ec1a45737ea..f5bfa17bf6505 100644
--- a/sound/soc/sof/intel/hda-dai.c
+++ b/sound/soc/sof/intel/hda-dai.c
@@ -83,12 +83,8 @@ hda_dai_get_ops(struct snd_pcm_substream *substream, struct snd_soc_dai *cpu_dai
 
 	sdev = widget_to_sdev(w);
 
-	/*
-	 * The swidget parameter of hda_select_dai_widget_ops() is ignored in
-	 * case of DSPless mode
-	 */
 	if (sdev->dspless_mode_selected)
-		return hda_select_dai_widget_ops(sdev, NULL);
+		return hda_select_dai_widget_ops(sdev, swidget);
 
 	sdai = swidget->private;
 
-- 
2.53.0



