Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041479;
	b=ayyZlVy/OhRN2CX3dIjDuhGsfcP+Z6GQN+l/wXd0bQDKtQXR7oOqRMiSeooL84gSPu4r
	 hg9iUJKUkzryQU48kndeuBJzSxs4ge2UI98qSw2gyjgZDetI0vwk05wAnJjVIFRmfei20
	 g+/w8HamZVKsTJMnSR4wj/LPX3mS68BQ+G5JGfhkZ48I3udh4N/fLRTSYOGd2dDjJsKrk
	 q+HIFGMt9hwImMbbFQFxdQaSvhoiEcmjgR9ZOyEQvzs+BRh+k46+tx70MM6diebBz3ep/
	 MWJGN8jqtpaPKUNcwN+AhlQ/m31br3yD/Xc4wwK+xmuj4TnEsj6RynXPRpyVhGmXQoA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041479;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5NC9AIvdvPbzSGlsQXYO6KBDVzDPq+23M+dEnF1hxy4=;
	b=Zt6eC7oW5IK2AcbuihWbALUeyu7c1YbKz0ZN46hyW9lUt6C0mbIHD1ZYC7k8ehk3zNC4
	 zNU/17xy7Xpm8Q89irBiyZN7cPJxbBAWwnGDmI/V7wAX4V+GyiVDCnvsPEva2IlsmuyDs
	 AU4Uh1zxgtaNGXv3AjetViytTIO99Yb3L7ASH4deoTDXP5Mn/o2TrLjCtzMWBxGESSpKp
	 J3GKggimDHENF1tFPk23F0L7xaO4j40v36/1VR9dRCXWFu2OFvBC6S8P28P0deJsae3Sr
	 A8YF/4JSMZ9qX4Fh0xxIVHBkdrpR6DHUJQ7BKvIi/dvKYDVa3bYr3IMbbZgjMagn3+A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m6caloNs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7974D60A6F59;
	Wed, 18 Nov 2026 22:37:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m6caloNs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 904A51F000CF;
	Wed, 18 Nov 2026 22:37:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041479;
	bh=5NC9AIvdvPbzSGlsQXYO6KBDVzDPq+23M+dEnF1hxy4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m6caloNsxjjey5GJt6FLJGwKSjxRNkc0Vk8lws0IXyW81+eG0Y5baWEkSQ5AXJrPb
	 Uq2Y8E54upJIPbJt1yjgBu4feID+2zm08Ni7Z/g/xZyUOm2SirD+wfzsVHsdw1LrXL
	 BmRHZPJg+B/aucQazT9KQZ4mExgQ0Hmk3E48gYtc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2828/3318] ASoC: Intel: atom: Use scoped_guard() for scoped locking
Date: Wed, 18 Nov 2026 15:57:30 +0100
Message-ID: <20261118150445.475927662@linuxfoundation.org>
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

[ Upstream commit 08d2d5e683e85a7dc33c1abfd50fdc380bfafb5a ]

Clean up the code using scoped_guard() for mutex locks.
Merely code refactoring, and no behavior change.

Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Reviewed-by: Cezary Rojewski <cezary.rojewski@intel.com>
Link: https://patch.msgid.link/20260626082904.32344-6-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: e3bb57581104 ("ASoC: intel: atom: Fix .shutdown() being skipped on rollback")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/atom/sst-atom-controls.c     | 38 ++++++++++----------
 sound/soc/intel/atom/sst-mfld-platform-pcm.c | 20 ++++-------
 2 files changed, 27 insertions(+), 31 deletions(-)

diff --git a/sound/soc/intel/atom/sst-atom-controls.c b/sound/soc/intel/atom/sst-atom-controls.c
index 38116c7587174..ec1dd9aec2fa1 100644
--- a/sound/soc/intel/atom/sst-atom-controls.c
+++ b/sound/soc/intel/atom/sst-atom-controls.c
@@ -761,27 +761,29 @@ int sst_handle_vb_timer(struct snd_soc_dai *dai, bool enable)
 			return ret;
 	}
 
-	mutex_lock(&drv->lock);
-	if (enable)
-		timer_usage++;
-	else
-		timer_usage--;
-
-	/*
-	 * Send the command only if this call is the first enable or last
-	 * disable
-	 */
-	if ((enable && (timer_usage == 1)) ||
-	    (!enable && (timer_usage == 0))) {
-		ret = sst_fill_and_send_cmd_unlocked(drv, SST_IPC_IA_CMD,
-				SST_FLAG_BLOCKED, SST_TASK_SBA, 0, &cmd,
-				sizeof(cmd.header) + cmd.header.length);
-		if (ret && enable) {
+	scoped_guard(mutex, &drv->lock) {
+		if (enable)
+			timer_usage++;
+		else
 			timer_usage--;
-			enable  = false;
+
+		/*
+		 * Send the command only if this call is the first enable or last
+		 * disable
+		 */
+		if ((enable && timer_usage == 1) ||
+		    (!enable && timer_usage == 0)) {
+			ret = sst_fill_and_send_cmd_unlocked(drv, SST_IPC_IA_CMD,
+							     SST_FLAG_BLOCKED,
+							     SST_TASK_SBA, 0, &cmd,
+							     sizeof(cmd.header) +
+							     cmd.header.length);
+			if (ret && enable) {
+				timer_usage--;
+				enable  = false;
+			}
 		}
 	}
-	mutex_unlock(&drv->lock);
 
 	if (!enable)
 		sst->ops->power(sst->dev, false);
diff --git a/sound/soc/intel/atom/sst-mfld-platform-pcm.c b/sound/soc/intel/atom/sst-mfld-platform-pcm.c
index a6a3db0ab7262..b5a6a262fe817 100644
--- a/sound/soc/intel/atom/sst-mfld-platform-pcm.c
+++ b/sound/soc/intel/atom/sst-mfld-platform-pcm.c
@@ -313,15 +313,14 @@ static int sst_media_open(struct snd_pcm_substream *substream,
 	spin_lock_init(&stream->status_lock);
 
 	/* get the sst ops */
-	mutex_lock(&sst_lock);
-	if (!sst ||
-	    !try_module_get(sst->dev->driver->owner)) {
-		dev_err(dai->dev, "no device available to run\n");
-		ret_val = -ENODEV;
-		goto out_ops;
+	scoped_guard(mutex, &sst_lock) {
+		if (!sst ||
+		    !try_module_get(sst->dev->driver->owner)) {
+			dev_err(dai->dev, "no device available to run\n");
+			return -ENODEV;
+		}
+		stream->ops = sst->ops;
 	}
-	stream->ops = sst->ops;
-	mutex_unlock(&sst_lock);
 
 	stream->stream_info.str_id = 0;
 
@@ -356,11 +355,6 @@ static int sst_media_open(struct snd_pcm_substream *substream,
 
 	stream = NULL;
 
-	return ret_val;
-
-out_ops:
-	mutex_unlock(&sst_lock);
-
 	return ret_val;
 }
 
-- 
2.53.0



