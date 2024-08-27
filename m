Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E9C0DDC1;
	Tue, 27 Aug 2024 15:00:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770828; cv=none; b=o1jZ+Y9wtFuuAg78ZHKchYJlJ1i/Lz04ymSNsAoWFYitPF5r6oTE6d9uYmwXi/YJ8UKQRvYlhxiuBBdB7PMKGK9kaY+AXPhCoCb4R0Zq+UtgnIxYoo7muGHYnjz3UkLISAlF423rP8JDXu38QJoJkx5qEzud3jBP6VGJb3+5bNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770828; c=relaxed/simple;
	bh=5bfum5RmnohhU6L2FbvT94JC4mEa8nBhO/Mwh13CzZo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tKGy+KOzUS5JIjci/EuQkW3KQFjhUIUMrm75yO71fHqegOIZjUisjYTh/+fkvteiTD0C454LwuExpk84/tG2OEpZAMkX8Z0HMtHAP/5uzKEarMBLsNHG1lcRKSlFKoRYZEvFiwLWL1pGszC9e8EVyNEOpGadmodyZ7MxggHBTu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y4tFaeMn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y4tFaeMn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC721C4AF1C;
	Tue, 27 Aug 2024 15:00:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770828;
	bh=5bfum5RmnohhU6L2FbvT94JC4mEa8nBhO/Mwh13CzZo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y4tFaeMnZJVbNkphT4aBAWx6/7+f3Ol8WIHW5MkWo96G9DVGVhLZ1/m8fpcukH6cz
	 N2XC5gPTsApJNbY7aG0Jn5oY2/ozYUtP6SJL9+qN2z1th5nPj3fmbv3a3u0Ymppt7z
	 7tHkpuwkvHBJ/hclX/I+I1Pcm0WxB6et5Sze5+Xk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Richard Acayan <mailingradian@gmail.com>
Subject: [PATCH 6.6 327/341] drm/msm/mdss: specify cfg bandwidth for SDM670
Date: Tue, 27 Aug 2024 16:39:18 +0200
Message-ID: <20240827143855.840630373@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

commit 8d35217149daa33358c284aca6a56d5ab92cfc6c upstream.

Lower the requested CFG bus bandwidth for the SDM670 platform. The
default value is 153600 kBps, which is twice as big as required by the
platform according to the vendor kernel.

Fixes: a55c8ff252d3 ("drm/msm/mdss: Handle the reg bus ICC path")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Tested-by: Richard Acayan <mailingradian@gmail.com>
Patchwork: https://patchwork.freedesktop.org/patch/572182/
Link: https://lore.kernel.org/r/20231215013222.827975-1-dmitry.baryshkov@linaro.org
Signed-off-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/msm/msm_mdss.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/msm/msm_mdss.c
+++ b/drivers/gpu/drm/msm/msm_mdss.c
@@ -600,6 +600,7 @@ static const struct msm_mdss_data sm6125
 	.ubwc_dec_version = UBWC_3_0,
 	.ubwc_swizzle = 1,
 	.highest_bank_bit = 1,
+	.reg_bus_bw = 76800,
 };
 
 static const struct msm_mdss_data sm8250_data = {


