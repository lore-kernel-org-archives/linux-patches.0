Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041475;
	b=C5mRZVOUSr262GQEnb09IEe5XqPp6UmdLPVIhqufpB6Lot47ZN0b+krUJ8Tf2utfdVgq
	 8VikSe2YEi7bGtAUhkFqswMySzxQQqZqJPgh86q4a9M5L5CXZhdJbo56s5Xzm4Y8+5Z05
	 LkruaLpD/MEMGY6MCEk6+jLVX1Ik8PQ+9H9QZLeUY0I7h2obQiBSuI98a6zlLnA7Y46dr
	 OP/IiQTNDRdGEr3mCtWAYGKze5HlVNjvAo/PFY0JtMIu1m+1x0gx37qMiiR8BHG02Y05C
	 JWaNDUY5ql9TDRI4IVkyJb45mK/EkN4kD59YZPgQVNKobWN9htDCoSsti+pogz9ZCuw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041475;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YtAwRzdYuTPdCT+VD4R3eYIxi12TqrC9m6JADNrRO9E=;
	b=OCXtXvGYmGf3C2B/NFXmP+XVrB0eYJ6efoFSErRR2K5Tk7pqJpGCnDslx57AbhlswT3z
	 6nXsdQj9CUuN8Ccq9Au8HAaU7fkNt+NmfaNNoahh+l6qFEwfpnTQ4Q2fkpwqO0CEdjhQ+
	 uKX/8pZDZJdaaFoQunBshyA+UnJi+9ureK4PyOxKP3gis0Cz8tGU8/rWQ7jQ3b9v3WVyZ
	 eWh/2t3sEvZHZFQsRUnkBejcg8OrufzuGbQzbN0lO3JQ1UvjVLvYK9qbpbBNoxJW9Fi1b
	 GUER24IlICkajIoQbwPC+DizY96f/1q3aGTsQOKdhriOnI/j7OQnd971Neim8hH4g6g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ajdJVSoO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C30B606B636;
	Wed, 18 Nov 2026 22:37:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ajdJVSoO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 895431F000C4;
	Wed, 18 Nov 2026 22:37:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041475;
	bh=YtAwRzdYuTPdCT+VD4R3eYIxi12TqrC9m6JADNrRO9E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ajdJVSoOQovWyyyYtx6demKQLspW/jLKDuFwnfxnGLVN48KbSLK27Jg6NSoNr9+t0
	 /SSVwYJ7d9EE3w8fJJqulGo9w4vuE+9dLphIUCKRsJogJcql8ZWncDee5d71C8e2X7
	 yJsB1jcX1eYPYBLOIFgoDG9z9o5QcO+ML3EYJswQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2827/3318] ASoC: intel: atom: Use __free(kfree) for stream pointer
Date: Wed, 18 Nov 2026 15:57:29 +0100
Message-ID: <20261118150445.445646636@linuxfoundation.org>
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
index 6f986c7bbc8bc..a6a3db0ab7262 100644
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



