Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031722;
	b=TivNWNAbGFMAu7/NLHfMss/dbmVzOjQWV/gE8jRqf2pBPa9+qWA91X4e9paBURdsrqXf
	 J6NDTYEKUecMBN6NdXCocCgugeXL8mrqVmAxXYeu09Bxds2jCYrtvCekxcFJJ+sdIF9uM
	 lNr7crLeO2M76/8wsfP2HrOkoshdhn3AdbAJ+SHLgxGgC89ksNqzAVCzxHyM0TQ1KkYjO
	 ywxQ3VNYFQfCx1/TfsTfwEcf23Cr92vBXgv9Lhvp6zcpiz8y3o7uVCE0dgP7vjgF+2UJ2
	 VRFo3JeT13n6WK1dAn6MmuzK9PTZcC0REH3a2SJ1sKgZDnzjaYAL9lLfPRP6JOdOX0w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031722;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sXEAWtQ8XPDmZMJESvr2vH9lStSSQbEx9vLYfi9MekY=;
	b=WyvKwK3i4FJoayLtZon/K8DYF+ZKhIvyIlFaHCF/2a/QWReb1qIQ5rn/nrYxq66pfu6G
	 DwHvsCFPFoELZO6zaelE33UMeVLvfsItL01nQlgU9CB8TwqnFsiY01y20GMW+nAlBakVt
	 stX3pZ+wNppn2LLChDzAYgQgVY2qXpNZSUuTlEG+YIAqTAHESPxN69QxDCe6iug2DM6YO
	 5Ff5gM0Vs71MK5S17urtTFhaJsVYdUbhFoD7xzg+2Nruo1WX0o/7YRhGeILJUSxiEAJAX
	 gLBIB2k+vavytcTs8GvG4RW4vdjwFej6yOZgvC7e30w8LEnfDyNkPrha+wi2EnNGg3g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="LWWQ/05g";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8987E606A31C;
	Wed, 18 Nov 2026 19:55:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LWWQ/05g
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B0AC1F000C4;
	Wed, 18 Nov 2026 19:55:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031722;
	bh=sXEAWtQ8XPDmZMJESvr2vH9lStSSQbEx9vLYfi9MekY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LWWQ/05gSFUoUDBo3x4A64vTGlVZFitFzaPjUD3sLyAyVWbA8cq11T3wMWvsmECYi
	 IPoSEke+F98oTzr6K8M1rnnw+yI64LmgXdes7v/kq4G40BwGdacjzSNmHBNFqwCyKK
	 teJu13BOphO6MBlUIQhJA+GG45VpwbYej/4NJ/bY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1159/1756] ASoC: intel: atom: Use __free(kfree) for stream pointer
Date: Wed, 18 Nov 2026 15:54:46 +0100
Message-ID: <20261118150056.150761512@linuxfoundation.org>
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



