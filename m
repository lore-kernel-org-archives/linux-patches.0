Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829476;
	b=wF6vVSM/TjWI4/A2ctaEE0ihQlMLLXDTVjWlQmwIEwNfU5da05RIryigAL3oTaPpPf9/
	 qWiY7HKXHi9ab0W+BnkyNI7LXv2mXB939Snv6aoreT2KU/5XqLVcB+G6DTjciK8vxCaDT
	 NKodj89y3h43RVrxn4lMX7B9NpM/24TKdEs8VgVUgqXi2+we2X8iyvR/C1KxflX3mjbrf
	 Z4Cr64Li8HfAxwCgXoPxBukm4t4I9ZWOSvLSKx7LvOTVKfHNS4ie92CZ3/DKxCt2MnZFD
	 21AojDDWoWGP89Tf5PA/0LxDYqJdBMvj57HGMRjZgG0hm/VKm0SEXJoJlCL/8EKBD8w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829476;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=glkHwXU9r9m4zE+Q82ZxrRYiyv6ItwRUKt2xFOICGZg=;
	b=uObBm7iB1MtuJ3mli8WWioM1QfklkpcGvf695YfAv9Nx5JeP6MOmjtff38h+KN3hnsUY
	 /FpGpWmGHqWlULNpiGZqWatVcZ1IGLqXoqvm6mp6OuNyvsURm+WMKutByXjLVDikg+lnB
	 iNjfWehjivpfqewM7mZxN7fjRVz38nDrXvXXcKk09xXxisrxv8v/I21oAvLbM+DaIHI+S
	 ruydrri1JtTrWoQCrbsgiLnDG6pKYjErYG6cw+Ry5Up+0WrQ235IvocGge7WBEjenABGk
	 M95alDhoXJZHpVUt+c6Qd9T+mGstMHzhMovfQ9ZAPxf6rM/Gbv57i5nw1hWvD8/5mzQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aGxlUPwF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BBBF606AB20;
	Wed,  4 Nov 2026 21:57:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aGxlUPwF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A3B91F000C1;
	Wed,  4 Nov 2026 21:57:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829476;
	bh=glkHwXU9r9m4zE+Q82ZxrRYiyv6ItwRUKt2xFOICGZg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aGxlUPwFLTzRSUvgU8cSaKFZTi+ittTzcwxyrGl93S0G0W78GtSPfmuAGEbdLWzuF
	 UpE3BpkIN4cQxBzqJL7/XX+dFRMpizkLXW8rz9QkQihGuQTxTbv4DC5IFvQD7s5BSD
	 ABqAbBCPp+Zr65FMGxS1uoYOE5fpp6nNZnH1qUcU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Gmeiner <cgmeiner@igalia.com>,
	Lucas Stach <l.stach@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0150/1005] drm/etnaviv: check MMUv2 status after reset
Date: Wed,  4 Nov 2026 15:58:03 -0500
Message-ID: <20261104211047.915006457@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

From: Lucas Stach <l.stach@pengutronix.de>

[ Upstream commit 4720915ab48282429f9e22ad5984b7870e4e962c ]

A full GPU reset is the only way to disable the MMUv2 and the
driver depends on the MMU being disabled after a reset to be able
to properly restart the GPU. Validate this assumption by checking
that the reset actually did disable the MMU.

Reviewed-by: Christian Gmeiner <cgmeiner@igalia.com>
Link: https://patch.msgid.link/20260511085148.652256-2-l.stach@pengutronix.de
Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/etnaviv/etnaviv_gpu.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/gpu/drm/etnaviv/etnaviv_gpu.c b/drivers/gpu/drm/etnaviv/etnaviv_gpu.c
index 368e799fc0c5d..daba33052f524 100644
--- a/drivers/gpu/drm/etnaviv/etnaviv_gpu.c
+++ b/drivers/gpu/drm/etnaviv/etnaviv_gpu.c
@@ -598,6 +598,23 @@ static int etnaviv_hw_reset(struct etnaviv_gpu *gpu)
 			continue;
 		}
 
+		/* try resetting again if MMUv2 is not disabled */
+		if (gpu->identity.minor_features1 & chipMinorFeatures1_MMU_VERSION) {
+			if (gpu->sec_mode == ETNA_SEC_KERNEL) {
+				if (gpu_read(gpu, VIVS_MMUv2_SEC_CONTROL) &
+				    VIVS_MMUv2_SEC_CONTROL_ENABLE) {
+					dev_dbg(gpu->dev, "MMU is not disabled\n");
+					continue;
+				}
+			} else {
+				if (gpu_read(gpu, VIVS_MMUv2_CONTROL) &
+				    VIVS_MMUv2_CONTROL_ENABLE) {
+					dev_dbg(gpu->dev, "MMU is not disabled\n");
+					continue;
+				}
+			}
+		}
+
 		/* enable debug register access */
 		control &= ~VIVS_HI_CLOCK_CONTROL_DISABLE_DEBUG_REGISTERS;
 		gpu_write(gpu, VIVS_HI_CLOCK_CONTROL, control);
-- 
2.53.0



