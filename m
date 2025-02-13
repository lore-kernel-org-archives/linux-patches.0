Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC5DA26B08A;
	Thu, 13 Feb 2025 14:49:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739458159; cv=none; b=J9h5vLZBv2HscPKjSmglPAcKSc42ON0bsYWJm1XmvOFutxPo7s3suoEKIYOi1miawLNtq9CUkG2AKHbUvUYAvWvONSbwZ6AZ49ZPfChs+cISdpVH58XA1/loh+FDd0Sre5z8olomcGOHcfcA0wu0xkcGcBVziwRCmBlgy2yP3OA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739458159; c=relaxed/simple;
	bh=kc3pXEjzb8wj+y3sSsc/L+p8px80NCH5J0KxgZ2M22o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NuKOnHYR2JE/R44+uTutrnYcxqnoxih9VFbpWAkGLYxDErvwDmTzMG2hawg/Czd+rfycj5dCSVadnIJfKqJ0NRu4zzPvY78/Ghc5QuhplbJRuHGlxvdu9naWwVjSvnUAa5DbTAxTDn9pB3+T6KE8rM4E7n0AWVkkJS7eB1kv+Xw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zpih2sXx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zpih2sXx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CD37C4CED1;
	Thu, 13 Feb 2025 14:49:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739458159;
	bh=kc3pXEjzb8wj+y3sSsc/L+p8px80NCH5J0KxgZ2M22o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zpih2sXxhYDVvonQ9IP6k1E7ZQUKKw+SXW2hgD/r9+zY7TaK5BvIxXMM1oN5IviuX
	 Zt523CSBSW5TmSTHaUF3qm2WQIiboFCgXFTgsIG938KWxLpt0KiqDIaEcIuOqx6hus
	 cwZmYgdSm5El5R280qrFM4JfMpkZ6ItfV05akahw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rajendra Nayak <quic_rjendra@quicinc.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Johan Hovold <johan+linaro@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.12 319/422] soc: qcom: llcc: Enable LLCC_WRCACHE at boot on X1
Date: Thu, 13 Feb 2025 15:27:48 +0100
Message-ID: <20250213142448.859489187@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

commit 35d8bc131de0f0f280f0db42499512d79f05f456 upstream.

The Last Level Cache is split into many slices, each one of which can
be toggled on or off.

Only certain slices are recommended to be turned on unconditionally,
in order to reach optimal performance/latency/power levels.

Enable WRCACHE on X1 at boot, in accordance with internal
recommendations.

No significant performance difference is expected.

Fixes: b3cf69a43502 ("soc: qcom: llcc: Add configuration data for X1E80100")
Cc: stable@vger.kernel.org
Reviewed-by: Rajendra Nayak <quic_rjendra@quicinc.com>
Signed-off-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Johan Hovold <johan+linaro@kernel.org>
Tested-by: Johan Hovold <johan+linaro@kernel.org>
Link: https://lore.kernel.org/r/20241219-topic-llcc_x1e_wrcache-v3-1-b9848d9c3d63@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/soc/qcom/llcc-qcom.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/soc/qcom/llcc-qcom.c
+++ b/drivers/soc/qcom/llcc-qcom.c
@@ -2511,6 +2511,7 @@ static const struct llcc_slice_config x1
 		.fixed_size = true,
 		.bonus_ways = 0xfff,
 		.cache_mode = 0,
+		.activate_on_init = true,
 	}, {
 		.usecase_id = LLCC_CAMEXP0,
 		.slice_id = 4,


