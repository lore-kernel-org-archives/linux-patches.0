Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053858;
	b=xiBYz9IpTL0+zvWuAdBK7tOPXjuaWVPQlMTWABwsPkerLQhjHeYgGdkkn4sQwCrLlv5f
	 a618MxPtMx3M7ExN1eDt2uc9yXD28YVSbO2enO92efljnDd8xqWeG4uJN9G6cCUmKQozW
	 IFds8AhkaZJv978VkBrQ4Hxhy5caYJJLi9Lw3r5jrZbKIyd4/QkZkY8MJuh/SZupiJD1n
	 L8o3hFXcar4/q021nNtnkQyrjkp6tDW0WF7V0Gx920ab/RwDMrKTpjy0M0xachVT1hHzL
	 Qr5jTF1w/NrtfTzP0ngYCx4FBYjReoeNGVNvgbErVdIFknr5r8ROOWBqatvH1/7hGqg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053858;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sfr/Xt3/7QBYNuY1ahHQHUSNDApRkNTHmdTUw2HaFoM=;
	b=EdOHlWzrmOguvRjtrlD4TFUG9mT6ytlku3iT6w6rDDNqCj3YIv0cKFWpqOKnwV7sRc7F
	 TBzBKFR0RXXNDpu7rcMVZolHkY8CQfUG6/C6y83aO3UBVDDKd7LMlJcHq9US2w52/SwFe
	 kYb9pFuERT3kFYCa/h+MZH/ZwpLpaZ2t3Sm+6gP2CbVgDNY4gXk19Ooj0mZ8NTjka0kVf
	 hh5HC37zPh+3astOmKVHF0AZDB6zRDChpmeNOFGw3e+nkgwfjr4OUh1NWXfjN/DJgtPgi
	 acGvJ6T9++YtX66E2IXqTY3gyl9Vm9JyK8Ho98Jl3pW4iS686GHErbwhECkLue8bgJQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PXiRIio3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0334606A31C;
	Thu, 19 Nov 2026 02:04:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PXiRIio3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D95C31F000C5;
	Thu, 19 Nov 2026 02:04:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053858;
	bh=sfr/Xt3/7QBYNuY1ahHQHUSNDApRkNTHmdTUw2HaFoM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PXiRIio3ousJD+0EbW+IaPXPcZLKqFs5dtA8zTl3L1SQSbJTCkshwUgvFR2jIsgta
	 WZDwHPWc3s+Vp/+4cqnoscGPN7b2vWKJwmvuLDlLD2NuG+Ao2NmJFRDD/du26SKGoi
	 nIwwf0VyN9mzNSLnY51JpzTiLtXWb9dD542oChlw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bin Yu <byu@xidian.edu.cn>,
	Cheng Wen <wencheng@xidian.edu.cn>,
	YuanZhe Liu <25031212351@stu.xidian.edu.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1027/2214] ALSA: hwdep: Serialize DSP load requests
Date: Wed, 18 Nov 2026 15:45:03 +0100
Message-ID: <20261118150053.424430316@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: YuanZhe Liu <25031212351@stu.xidian.edu.cn>

[ Upstream commit aee83c204f80d56b4d55f53acdb8594308ddcd4a ]

The check of the loaded DSP indices and the call of the driver's
dsp_load callback in snd_hwdep_dsp_load() are not serialized.  A hwdep
file descriptor can be shared among threads, or inherited across fork,
so two SNDRV_HWDEP_IOCTL_DSP_LOAD requests for the same index can both
observe the index as unloaded and enter the driver's callback
concurrently, even though the device itself is opened exclusively.

This breaks the assumption behind hw->dsp_loaded that a firmware index
is loaded only once.  For example, snd-usb-usx2y hits
WARN_ON(usx2y->as04.buffer) in usx2y_async_seq04_init() and may
allocate the US-428 sequence URBs twice.

Serialize the check, the callback invocation and the bookkeeping with a
per-hwdep mutex, so that the second request returns -EBUSY.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Co-developed-by: Bin Yu <byu@xidian.edu.cn>
Signed-off-by: Bin Yu <byu@xidian.edu.cn>
Co-developed-by: Cheng Wen <wencheng@xidian.edu.cn>
Signed-off-by: Cheng Wen <wencheng@xidian.edu.cn>
Signed-off-by: YuanZhe Liu <25031212351@stu.xidian.edu.cn>
Link: https://patch.msgid.link/20261029084810.21910-2-25031212351@stu.xidian.edu.cn
Signed-off-by: Takashi Iwai <tiwai@suse.de>

5.10 and 5.15 still build with -std=gnu89, so guard() cannot be used
after the early returns of this function.  Take the mutex explicitly
and release it on every exit path instead.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/sound/hwdep.h |  1 +
 sound/core/hwdep.c    | 14 ++++++++++----
 2 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/include/sound/hwdep.h b/include/sound/hwdep.h
index 8d6cdb254039d..137be4b4074b2 100644
--- a/include/sound/hwdep.h
+++ b/include/sound/hwdep.h
@@ -57,6 +57,7 @@ struct snd_hwdep {
 
 	struct mutex open_mutex;
 	int used;			/* reference counter */
+	struct mutex dsp_mutex;		/* serializes DSP load requests */
 	unsigned int dsp_loaded;	/* bit fields of loaded dsp indices */
 	unsigned int exclusive:1;	/* exclusive access mode */
 };
diff --git a/sound/core/hwdep.c b/sound/core/hwdep.c
index e95fa275c2893..f7cde6bb8a061 100644
--- a/sound/core/hwdep.c
+++ b/sound/core/hwdep.c
@@ -212,14 +212,19 @@ static int snd_hwdep_dsp_load(struct snd_hwdep *hw,
 		return -ENXIO;
 	if (info->index >= 32)
 		return -EINVAL;
+	mutex_lock(&hw->dsp_mutex);
 	/* check whether the dsp was already loaded */
-	if (hw->dsp_loaded & (1u << info->index))
-		return -EBUSY;
+	if (hw->dsp_loaded & (1u << info->index)) {
+		err = -EBUSY;
+		goto unlock;
+	}
 	err = hw->ops.dsp_load(hw, info);
 	if (err < 0)
-		return err;
+		goto unlock;
 	hw->dsp_loaded |= (1u << info->index);
-	return 0;
+unlock:
+	mutex_unlock(&hw->dsp_mutex);
+	return err;
 }
 
 static int snd_hwdep_dsp_load_user(struct snd_hwdep *hw,
@@ -377,6 +382,7 @@ int snd_hwdep_new(struct snd_card *card, char *id, int device,
 
 	init_waitqueue_head(&hwdep->open_wait);
 	mutex_init(&hwdep->open_mutex);
+	mutex_init(&hwdep->dsp_mutex);
 	hwdep->card = card;
 	hwdep->device = device;
 	if (id)
-- 
2.53.0



