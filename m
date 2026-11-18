Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023581;
	b=bpHK3eaJL00z3DWIk4pVnClA3JbY5tpvlEN6KI9ikzO5oRvYeujmp/FOQFQEL3suX/aq
	 GMfPSNiFK4x3xKKWAApS2VeYM5076cJk7RM+UcMrl5pum/H8I7Wmof78Czsoutk2d5GaW
	 BgEdXHP0SLAG9Uw/dec9tyPVxGnLzaTZvhesMYcuJgkTbyJXdhdX591vs/lg0KSi+Tsbf
	 g209na1Vw1qbN/nnVAi50ecBboA9QCLp7Ma76jWhAVRMeCCJjSqwj6jMXnwt8ommp/U3i
	 MNSsbn/zHGshNZv3sZZnngBGpJvzHVoIkzzEdSUamZO5kkLJM31VRzfcY8P0FWKM1aw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023581;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RIAcoxJJKpX6b4qvZ2jbMOyQUDVQ5EA9XLWYSMJPlcE=;
	b=RfXV4HaQzR1YiK1Ti/onX4C6WhfCdKOW/nCvbAPAutAaLZe5CTgUitpe/3PpYPnrUwYe
	 6UMpGKsmJi/C9jYPdR1WgrSLNGzFQWMAZzDFTKmf1v+v9SEl2IlGijS+VQ1Gj7Gu1EAvG
	 24Lg2DuIN5SdazmreM+fwNMeBdxmAe/kuDsVf0NBL9VVJFjVYDBTyw6uE7R1rMlbjMF6Y
	 llHysqBFRWfAZjOcw2Vr8ud8o0ojGNGyjdn0bAzNJg1chj4uR4i+xsTLLiFIon4LiUFCn
	 aIoDWBWt+PP8xm9SmfD3A9cJNAh9VPoVZ/bu9TrSZRn7EZORXtCjz1PQ/a+5tcjkFsQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OyI+M240;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B26EE606A33A;
	Wed, 18 Nov 2026 17:39:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OyI+M240
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC70F1F000C5;
	Wed, 18 Nov 2026 17:39:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023581;
	bh=RIAcoxJJKpX6b4qvZ2jbMOyQUDVQ5EA9XLWYSMJPlcE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OyI+M240BX1NTkAEFGUKr6jw4PDT/G7gy6k6mkbDbAOvnXvfHmCjitFE0VxO8sFNc
	 nTb/YH3lOoPahQtTZVjW4hOkHPNGBadWxRRpv5UO/Ux8YzgCfKHuyF1fQU1kCBvD0H
	 k3bv2/ajKuz241BnRPBoQrscmcJAEOh6tH1ThlSg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0419/2151] virtio: synchronize callbacks after device reset
Date: Wed, 18 Nov 2026 15:35:54 +0100
Message-ID: <20261118150137.316819986@linuxfoundation.org>
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

From: Michael S. Tsirkin <mst@redhat.com>

[ Upstream commit dd75508e6fe77116589c49658d0d18897688dc0b ]

virtio_reset_device says:
	Note: this guarantees that vq callbacks are not in progress
but in practice, only virtio pci correctly synchronizes the cbs.

On other transports, a callback that is already executing, keeps running
while the driver tears down the state it uses.

Add virtio_synchronize_cbs to virtio_reset_device fixing this for all
transports that correctly implement synchronize_cbs().

Reported-by: Karl Mehltretter <kmehltretter@gmail.com>
Link: https://lore.kernel.org/all/20260818040433.66986-1-kmehltretter@gmail.com/
Fixes: c46eccdaadab ("virtio: document virtio_reset_device")
Tested-by: Karl Mehltretter <kmehltretter@gmail.com>
Acked-by: Karl Mehltretter <kmehltretter@gmail.com>
Assisted-by: LLM
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Message-ID: <8ae2995ee649adcfe1398f7f1c4fc9f7028c3db1.1789204858.git.mst@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/virtio/virtio.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/virtio/virtio.c b/drivers/virtio/virtio.c
index 4ced08886d0b8..d85cb55247ba3 100644
--- a/drivers/virtio/virtio.c
+++ b/drivers/virtio/virtio.c
@@ -264,6 +264,8 @@ void virtio_reset_device(struct virtio_device *dev)
 #endif
 
 	dev->config->reset(dev);
+	/* Flush pending VQ/configuration callbacks. */
+	virtio_synchronize_cbs(dev);
 }
 EXPORT_SYMBOL_GPL(virtio_reset_device);
 
-- 
2.53.0



