Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829552;
	b=kIUlftNQUy65V7/WMoQA0imQcjXG6B1aaviZ1T3Cbu/uELPeasFZsLm6LHZ5RFIyA8Dt
	 4JjJbXWimIM0++WW6rdTLL8lvRVmuQ3W+wDIm+eOmHOmaPECrNz/NkTD7refuVkPi75KV
	 OW6afHczYOwbCd1aQ/wknru8QD6jxco81MSPGHAQrKQiuEbShCoBw2k1l+XWwgEySIcEY
	 SYSzv9RFaXbFk98LK0SfYz4Ks8mzNknk6tXZFbVAiuTDHjvJA9t8ua11FYj933e66Ll2q
	 myC49/LssW2uzruvSTzqKrbomcAhs90LCR3YUhoFwe3OrbSjr3u4Km+IZUJOjGSBeIw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829552;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Zo0azLKB9JoGBHBVxjJ0V1jI6Gbu5bweXEYnwXbn+HA=;
	b=DvxZlDSjd5q9vh/fdmEtQUQrRblIJOMZXRieLXJK3f2xdDldreuW/pksg5jcXN6W8rsf
	 3Bpth98KnJrGWpb2ukOIrD9EBNXEcwK/eagad+TpfygNP54xR5SjLh8+erYACYNQ0wkJz
	 9GvZfcUlfBibop6IWi9VDby8tL/Kop9MsNHeztSwb1TICeEeQd5KCkH9OSJM3fGcz2q1J
	 uKADI5hLk7jtmmhl7i4+KqoKSF/5IxcJoh3WCatUAszcH53BcO6VpcGL/P5H8vmNsUABm
	 NngKb72N7NvPA5LlN46iLhxF3Wd95xPp6n2tRpZA2rqtPjKBo2AcUFjUJvKvk8uRd/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Av2MObTS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B88D606A846;
	Wed,  4 Nov 2026 21:59:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Av2MObTS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF39C1F00919;
	Wed,  4 Nov 2026 21:59:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829552;
	bh=Zo0azLKB9JoGBHBVxjJ0V1jI6Gbu5bweXEYnwXbn+HA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Av2MObTS3jsBX87oYFI0krWHU75MjNQ2uW5dU84Xn5kFZzKJCoobSP6d4SXecKRKy
	 trYnMB3o1qEPUSZHJ6mLdS6+T9e3sDfWN9xFkbCTl2xZIQLf/fzblY0cXON4R0okeM
	 OZgYGsKpzjSf8KiM9bepzXljzS1DwgP6+B4etEV4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aditya Sherawat <asherawa@qti.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Akhil P Oommen <akhilpo@oss.qualcomm.com>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0198/1005] drm/msm/adreno: Add support for A704 GPU
Date: Wed,  4 Nov 2026 15:58:51 -0500
Message-ID: <20261104211049.340351504@linuxfoundation.org>
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

From: Aditya Sherawat <asherawa@qti.qualcomm.com>

[ Upstream commit 1f69339da06255a7f8560b4768fff83992c03deb ]

Adreno A704 GPU found in Shikra is an IP reuse of A702 GPU with very
minimal changes. The only KMD facing difference is the chipid and the
zap firmware which is specified via devicetree.

Just add the new chipid to enable support for A704 GPU in Shikra.

Signed-off-by: Aditya Sherawat <asherawa@qti.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Akhil P Oommen <akhilpo@oss.qualcomm.com>
Patchwork: https://patchwork.freedesktop.org/patch/738931/
Message-ID: <20260710-shikra-gpu-v6-1-b388ec5dce77@oss.qualcomm.com>
Signed-off-by: Rob Clark <robin.clark@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/adreno/a6xx_catalog.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/adreno/a6xx_catalog.c b/drivers/gpu/drm/msm/adreno/a6xx_catalog.c
index b43850966a5f6..bbfee7fef6dc0 100644
--- a/drivers/gpu/drm/msm/adreno/a6xx_catalog.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_catalog.c
@@ -1417,7 +1417,7 @@ DECLARE_ADRENO_REGLIST_LIST(a750_ifpc_reglist);
 
 static const struct adreno_info a7xx_gpus[] = {
 	{
-		.chip_ids = ADRENO_CHIP_IDS(0x07000200),
+		.chip_ids = ADRENO_CHIP_IDS(0x07000200, 0x07000400),
 		.family = ADRENO_6XX_GEN1, /* NOT a mistake! */
 		.fw = {
 			[ADRENO_FW_SQE] = "a702_sqe.fw",
-- 
2.53.0



