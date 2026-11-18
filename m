Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018611;
	b=k33LWgEWQ/9AnNnM61hDpFjR5eCrJETg7N+CUVa6qMVSpZJDUBUqk8qSAN3Dk/K6HLT5
	 HU4OOXTjwzhTKmY/rloZU/M9xHvl006asbZhmDCdYeESocaYurz/TxqULWtPLd7HcYWoc
	 Hhge9Tc92zat3MUJOGEqwzzJe+KHWoDRd22ILBVwYec7f7rBUIBplK6+III8tQ0EIoQN6
	 3y5Jg4HPPVgo8IFoc7fcDwWL5R/r53IeVLgBEv7Sot/StK4xPO75EcAGI8Xp6B73ZR1Fj
	 yAAGhxxpEjtSwz6ORinulSDg//Sf1vabMbgGDT88Nqpsw4f/82TtDSWtgrqbmD8dhFg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018611;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OK2GcT5G6sNJjJZxUkfOT3die8TVceaYTsiult25sAk=;
	b=nsNdxsElMVpiw+fMfMieW0pwl+EWODLeyF0iqghPN5ECCMtJ0G/UGh4McQUEtlScAXSE
	 IUFRkr7a+dugaddTf3WHECa6V30yFn+zYdqnjJGRqjN89KpOmfPjtB8YxkrW04wFLtvC8
	 vGBSnJv6do/o2QfzmCT8pypExEh+Wk0r54vfyaP6npHAfTOqR0i5scdNvKTacWFlA6YOB
	 ++WEo6VzGzEbPGpiZOWTLye2J3ZutIlyjsDaBwGPp5JmH2xRzx6vbDrhiN+kZ8HwP0mhr
	 Vu613xVG0B+1WP0bmu+MW4xmWY/01g8PaSTf96WZu8tksZDJNY6waHqdW5Yk0swVJyA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1+7iE5He;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F648606A331;
	Wed, 18 Nov 2026 16:16:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1+7iE5He
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C27471F000CB;
	Wed, 18 Nov 2026 16:16:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018611;
	bh=OK2GcT5G6sNJjJZxUkfOT3die8TVceaYTsiult25sAk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1+7iE5HenueLLTlgZrBarzljIoZZJ+Cu4VPmkPRn5DvfNPSf+DEFv4o/pCLb/B7iB
	 Q5Jb6IQXqmGh/DQ+YLTUWQZUOPWD2kUOo8/sK0pvpUCy8zlfkxjmz7nrrnLA1xUFox
	 6YBg3cxoRNrihY6a2qfoLWB041JGKESvWuT4reQA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joonhoe Kim <26rote@gmail.com>,
	Pengyu Luo <mitltlatltl@gmail.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1300/2651] drm/msm/dpu: round up the compressed INTF width
Date: Wed, 18 Nov 2026 15:42:20 +0100
Message-ID: <20261118150334.768815085@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joonhoe Kim <26rote@gmail.com>

[ Upstream commit 6b93e8b453fa27a1b6a1d472f3ff8663e6811fae ]

For DSI with DSC, drm_mode_to_intf_timing_params() scales the INTF
active width by bpp / (3 * bits_per_component) and rounds down. The DSI
host computes the same width with DIV_ROUND_UP, both for the pixel clock
(dsi_adjust_pclk_for_compression()) and for the active width it programs
(dsi_timing_setup(), from bytes per line). When the division is not
exact the INTF line is one pclk shorter than the DSI line, and the DSI
FIFO overflows.

Example: a bonded DSI video-mode panel, 952 pixels per link, DSC 8 bpp at
10 bpc: 952 * 8 / 30 = 253.87, so the INTF uses 253 and the DSI 254.

Round up, as the DSI host does. Qualcomm's downstream SDE driver also
rounds this width up, and Pengyu Luo needed the same rounding on the
Legion Y700 gen 4 [1].

Tested on a Lenovo Legion Tab Y700 gen 5 (SM8850) with that panel, with a
module parameter selecting the rounding: rounding down, DPMS off/on gives
no vblank and 14000-17000 DSI FIFO error interrupts per second
(dsi_err_worker: status=4); rounding up, the picture comes back and there
are no errors. Only tested on this device.

Link: https://lore.kernel.org/all/CAH2e8h6oinKxN1ndcvHCSc+=bFLXVVDZVAVF0cQHoiaMvEwhPQ@mail.gmail.com/ [1]
Fixes: f9ce482d7dc0 ("drm/msm/dpu: fix video mode DSC for DSI")
Assisted-by: LLM
Signed-off-by: Joonhoe Kim <26rote@gmail.com>
Reviewed-by: Pengyu Luo <mitltlatltl@gmail.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Patchwork: https://patchwork.freedesktop.org/patch/757958/
Link: https://lore.kernel.org/r/20261004102758.84436-1-26rote@gmail.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys_vid.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys_vid.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys_vid.c
index ba810f26ea309..2ac517db50fcd 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys_vid.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys_vid.c
@@ -134,8 +134,8 @@ static void drm_mode_to_intf_timing_params(
 		 * TODO: replace drm_dsc_get_bpp_int with logic to handle
 		 * fractional part if there is fraction
 		 */
-		timing->width = timing->width * drm_dsc_get_bpp_int(dsc) /
-				(dsc->bits_per_component * 3);
+		timing->width = DIV_ROUND_UP(timing->width * drm_dsc_get_bpp_int(dsc),
+					     dsc->bits_per_component * 3);
 		timing->xres = timing->width;
 		timing->dce_bytes_per_line = msm_dsc_get_bytes_per_line(dsc);
 	}
-- 
2.53.0



