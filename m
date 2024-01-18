Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E5B91B96D;
	Thu, 18 Jan 2024 10:53:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575235; cv=none; b=Upm6NlX8ltOsUsRlaL/8WjdLV2lyLExnmeJZ7uVoLiyTQ4169Y8PFd58FzOvBobpgLqerJYSpPrwD/hnXspQnt34Yra6iKIjZ5kB09A7D481xMp3c4WsOhjiD+pitIEjGZJCSyWEB8Yga0qIV3dPJv9A++txKC2Yg8Qf0LNW/hw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575235; c=relaxed/simple;
	bh=eiy4Ce5z/fxN5zMw5Df7Vk0SHiWVVbDciIrfoAwsK3M=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Type:
	 Content-Transfer-Encoding; b=n7sm0F9mEz/yV0s1kt49zrcd3/xyzXr4TQ/tkbc0IHLOQ7sCHa6Y+NQ6+v5wzwwamFFsvgpvuBnmjtLTR1A8uoE1p/dISHMfKUXg8f5v4tqaYOl8wxQabQNjzgCDVQLgVNhWtDzx22rS4hegK7IUx7i3JqQh6Mu2MpPRZkjiImg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f8dW1U9J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f8dW1U9J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C82E2C433F1;
	Thu, 18 Jan 2024 10:53:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575235;
	bh=eiy4Ce5z/fxN5zMw5Df7Vk0SHiWVVbDciIrfoAwsK3M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f8dW1U9J6x4XII7ZLm3wQqyluriuE7XMd09I3PDF2UfUQ0rmr7qcXgLT+H63+Ogtq
	 rgbGF/BgVxJ6eI4+A2ZLxISnmNEO0r9WQe6gCIYG4RCQtL3IS/cRq4T8ek0QEkSmBx
	 r/71cUBDtMs5cxPrxnTciTHdRgyOgjQ0qY7gUQf0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kamil Duljas <kamil.duljas@gmail.com>,
	=?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= <amadeuszx.slawinski@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 031/150] ASoC: Intel: Skylake: Fix mem leak in few functions
Date: Thu, 18 Jan 2024 11:47:33 +0100
Message-ID: <20240118104321.530398596@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240118104320.029537060@linuxfoundation.org>
References: <20240118104320.029537060@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Kamil Duljas <kamil.duljas@gmail.com>

[ Upstream commit d5c65be34df73fa01ed05611aafb73b440d89e29 ]

The resources should be freed when function return error.

Signed-off-by: Kamil Duljas <kamil.duljas@gmail.com>
Reviewed-by: Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>
Link: https://lore.kernel.org/r/20231116125150.1436-1-kamil.duljas@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/skylake/skl-pcm.c     | 4 +++-
 sound/soc/intel/skylake/skl-sst-ipc.c | 4 +++-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/sound/soc/intel/skylake/skl-pcm.c b/sound/soc/intel/skylake/skl-pcm.c
index ac3dc8c63c26..29a03ee3d7f7 100644
--- a/sound/soc/intel/skylake/skl-pcm.c
+++ b/sound/soc/intel/skylake/skl-pcm.c
@@ -252,8 +252,10 @@ static int skl_pcm_open(struct snd_pcm_substream *substream,
 	snd_pcm_set_sync(substream);
 
 	mconfig = skl_tplg_fe_get_cpr_module(dai, substream->stream);
-	if (!mconfig)
+	if (!mconfig) {
+		kfree(dma_params);
 		return -EINVAL;
+	}
 
 	skl_tplg_d0i3_get(skl, mconfig->d0i3_caps);
 
diff --git a/sound/soc/intel/skylake/skl-sst-ipc.c b/sound/soc/intel/skylake/skl-sst-ipc.c
index 7a425271b08b..fd9624ad5f72 100644
--- a/sound/soc/intel/skylake/skl-sst-ipc.c
+++ b/sound/soc/intel/skylake/skl-sst-ipc.c
@@ -1003,8 +1003,10 @@ int skl_ipc_get_large_config(struct sst_generic_ipc *ipc,
 
 	reply.size = (reply.header >> 32) & IPC_DATA_OFFSET_SZ_MASK;
 	buf = krealloc(reply.data, reply.size, GFP_KERNEL);
-	if (!buf)
+	if (!buf) {
+		kfree(reply.data);
 		return -ENOMEM;
+	}
 	*payload = buf;
 	*bytes = reply.size;
 
-- 
2.43.0



