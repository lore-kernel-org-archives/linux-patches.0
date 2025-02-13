Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B481A26B091;
	Thu, 13 Feb 2025 15:15:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739459750; cv=none; b=tbuQwQlghfGtWzafyoWs197nAoHaGnKJKaN9XT+XJ/6v8RHpyouh2Bjp2BPi9Joc9TIPdoSIOTeOPPAxKwkvAgHWq3bLZl+i03N43tQwxdn5yp11aFP4BdH+k9cElOo2fdwNfFLK1yJh9Was2pilR952cS6q57vG5HeJNmYfy5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739459750; c=relaxed/simple;
	bh=hVSeY0T/3g9RBIMjq/E7d0WIje53RZaXqFLe23Xoud0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=piefqwHaGqJ9ap9I/GaUt9G+yPOANJ4qrsvmtz7jX3VFfkRdTw39tt3sMW/wqLQKMJUiUaztnDVjrZ0uSIqEz8D3Vr7JnqHZ4iZ+1gHZcqcjwhHzHme7mVNqSkonmgxsmnLyOMEi3fI+BL7UCgW+MhVWX1xL21+zm3zzPO/rTWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y+yalfBF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y+yalfBF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 237ECC4CED1;
	Thu, 13 Feb 2025 15:15:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739459750;
	bh=hVSeY0T/3g9RBIMjq/E7d0WIje53RZaXqFLe23Xoud0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y+yalfBFz0LyXELjogb+IPWitLcy9s4qsDkqn0r4wluMDYkgqmfHZj+XI6RjxdUWM
	 A7amBV1QY5McrvgW2xQNQh70CsucFpXs2JIMlhI7OYpW0O0rOIVCCMmhFim9EwvSxZ
	 2QYxi2eu64OGQsX/ONnhQfPsBW8nPkJSyP0IiSNE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rajendra Nayak <quic_rjendra@quicinc.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Johan Hovold <johan+linaro@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.13 354/443] soc: qcom: llcc: Enable LLCC_WRCACHE at boot on X1
Date: Thu, 13 Feb 2025 15:28:39 +0100
Message-ID: <20250213142454.276431461@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3004,6 +3004,7 @@ static const struct llcc_slice_config x1
 		.fixed_size = true,
 		.bonus_ways = 0xfff,
 		.cache_mode = 0,
+		.activate_on_init = true,
 	}, {
 		.usecase_id = LLCC_CAMEXP0,
 		.slice_id = 4,


