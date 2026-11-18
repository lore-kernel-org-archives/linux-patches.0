Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026496;
	b=xHu8hPtYDHd3uciCnmSlF3YvzG3K2ndjVuukIlufE/pdAIfs2N7W6SPcyjQpvd09EfhA
	 noeQvEnhuxYAv6T4r+FZ1kdTbbDWDdy5Vlh+yG5/NtnsCcHeI4ZXeH0yGPhHPwtwfkFmb
	 03K2Iq52h8tODPml3L42DOr3Mjy3rL99lFTBsEajcq5/MSA6ofGfUkV9AiKGKxyiIBQ4a
	 +HYuC+Pj7sSdMWy2fLU5pK5Q29gDEbTYopRgHFUOf/Z6Ikb+VsL6yh5DuM6qolVb2SKPl
	 aMRDuKH0W5q3/ycTnGSzIZbCa2n1WuQErJcSdmOPoEBP6VdC+Kjnfqmem6kdJJG2Jkw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026496;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=d6B5cSTyZE68H/JtggEbhssVww9ggiNN2S/h1vtRxcI=;
	b=SXmX7efrDJcLQajPcvbAVDQ+I3KVHbG8eL1uWUoFqibNvXv8l2BHqOl5bSAsnzvz3xAE
	 2cUP/VSEbigDPxKiY2spUCABW7ISJplwSXa3/ZIhQJ3+3rYu04r/H8fc3YNAPuiOGJTNy
	 apFKduho8bOzkpKjIVzSyE6cAnusP6cR4G77O55TQ++eCdMx9ywNv4rYEwmg5JzCSHOxR
	 UE/E/25TFY7uAeGq26XYciD6esPAlxxNvAyAVXU3A9PFH5NZ4yiXfhWxU3Tq0CBzyelLD
	 xrnW3s2ZYiGIW+qzppMxTovvHCn/z7vLRY3O01GqZ5MP9wQqgYitJDt227E6SbI8DyQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=l5FX+FkI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B661606A31C;
	Wed, 18 Nov 2026 18:28:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=l5FX+FkI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE16F1F000C4;
	Wed, 18 Nov 2026 18:28:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026496;
	bh=d6B5cSTyZE68H/JtggEbhssVww9ggiNN2S/h1vtRxcI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l5FX+FkIkmzeo5UkeWDzRKHFwerydPlt5/2hTOFmYpO/9yQVPZSXSI7JI1K+yFm/y
	 OhCZKO/vFOi8d5qtRAvdUkp7qKlSxb01wiHtZF8y0p6eCh6yIL/bE/8mqOGt0c3UNj
	 g9pDxl84EorNUPN28OrAeYTCXr8r9ntJLpbEt3i0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1455/2151] ASoC: intel: atom: Use __free(kfree) for stream pointer
Date: Wed, 18 Nov 2026 15:53:10 +0100
Message-ID: <20261118150214.915268973@linuxfoundation.org>
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

From: bui duc phuc <phucduc.bui@gmail.com>

[ Upstream commit 4889a8a73f65b8e4feb49ea434b8a41806513574 ]

Declare 'stream' with __free(kfree) so it is automatically freed when
leaving scope. This allows direct returns from error paths and removes
the explicit kfree(stream) call.
Set 'stream' to NULL after ownership has been transferred to
runtime->private_data to prevent it from being freed on the success path.

This cleanup is a preparation step for upcoming locking changes.

Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Reviewed-by: Cezary Rojewski <cezary.rojewski@intel.com>
Link: https://patch.msgid.link/20260626082904.32344-4-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: e3bb57581104 ("ASoC: intel: atom: Fix .shutdown() being skipped on rollback")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/atom/sst-mfld-platform-pcm.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/sound/soc/intel/atom/sst-mfld-platform-pcm.c b/sound/soc/intel/atom/sst-mfld-platform-pcm.c
index 373d68b4cf88f..516b480559026 100644
--- a/sound/soc/intel/atom/sst-mfld-platform-pcm.c
+++ b/sound/soc/intel/atom/sst-mfld-platform-pcm.c
@@ -11,6 +11,7 @@
  */
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/cleanup.h>
 #include <linux/slab.h>
 #include <linux/io.h>
 #include <linux/module.h>
@@ -304,7 +305,7 @@ static int sst_media_open(struct snd_pcm_substream *substream,
 {
 	int ret_val = 0;
 	struct snd_pcm_runtime *runtime = substream->runtime;
-	struct sst_runtime_stream *stream;
+	struct sst_runtime_stream *stream __free(kfree) = NULL;
 
 	stream = kzalloc(sizeof(*stream), GFP_KERNEL);
 	if (!stream)
@@ -330,7 +331,7 @@ static int sst_media_open(struct snd_pcm_substream *substream,
 
 	ret_val = power_up_sst(stream);
 	if (ret_val < 0)
-		goto out_power_up;
+		return ret_val;
 
 	/*
 	 * Make sure the period to be multiple of 1ms to align the
@@ -347,12 +348,19 @@ static int sst_media_open(struct snd_pcm_substream *substream,
 	snd_pcm_hw_constraint_step(substream->runtime, 0,
 			   SNDRV_PCM_HW_PARAM_PERIODS, 2);
 
-	return snd_pcm_hw_constraint_integer(runtime,
-			 SNDRV_PCM_HW_PARAM_PERIODS);
+	ret_val = snd_pcm_hw_constraint_integer(runtime,
+						SNDRV_PCM_HW_PARAM_PERIODS);
+
+	if (ret_val < 0)
+		return ret_val;
+
+	stream = NULL;
+
+	return ret_val;
+
 out_ops:
 	mutex_unlock(&sst_lock);
-out_power_up:
-	kfree(stream);
+
 	return ret_val;
 }
 
-- 
2.53.0



