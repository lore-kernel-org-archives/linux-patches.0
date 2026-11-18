Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054663;
	b=L/lBrvt9T7wc61tZ9J0B4J/7FpNQMYY6J+tO50vhkki36eSZ29TFh7YOeP6Ai2yoK1OT
	 YdVZyEPgvTy4XBYx+xG1A2FQIjexsJtANeUmpwot8tCEZEs/hhVT+ZGjLQoxVExlsve8D
	 9ex9+ARcTDtftCs7A+2biHeH54OXF2+UcyJCVAoBOJxzK6yHUskJe6R7VpnyLvH/LuqcL
	 Y9VkKRcSXl7o529pYdIwEC2/Hxt0TgNtHU27jOLxhiFFiDilgvI33FRkLuwak3atAO3Sg
	 zR1UGmjRAsjd98BHbdh1LpkdJ/wLdxoiATKF6YYC4VTpQegfEfTQoaL59lmEIvDn8pw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054663;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=K9ABhi0gRxcfWXjjFwylClf6jQhaWeEu4nu2LphJCuQ=;
	b=QQEQ8ziLWq9TsrDeuK6fYJABN5D0H8Ey6wU/oDqPI2MM7LiaUnfZTOphlMcPeJDor3ah
	 8l2LtODz1HuPhvu+x1xUS5bvY5YPy0m+ojopZTQ4WWPDVLl3dJt8LK0bCE9TiRUAfJWDD
	 iTXFOy602z2XHuHPrQPrLqqHdjyKcYariSQqs5hGHkyq4/52kQUbvHbCAwnOFLRWeNiND
	 MdBzncrS6vPS8KVvQQa9fIKmfgSgBBVHVr/xOQWJLKJweIsRllsUz+ivd4dh1tl45GrzN
	 +i0jN7k/m3eo409e3+zZq60mHq6zXjBAPwXGFVIXf7Ulg35ZiVnef//gIHsXZNkR8gA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pzlB+1Hg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0883606A320;
	Thu, 19 Nov 2026 02:17:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pzlB+1Hg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD6CA1F000C4;
	Thu, 19 Nov 2026 02:17:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054663;
	bh=K9ABhi0gRxcfWXjjFwylClf6jQhaWeEu4nu2LphJCuQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pzlB+1HgYaLPkoXTlw/GBj2Qq7i2mAqXNhSfHczc/ljKadC50EBfgs1jcFBf644Xm
	 q4eTiMxoksJzFusM4P1P0LD5MIom1XhXLS1RxoI1yhZT1U3UKcqXFvabl0EEQ75IFo
	 GTqHKpT5J+LQmfgiKXbfBlHR/Qa09Vx0mdylUlGc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anup Vishwakarma <anup.vishwakarma@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1355/2214] remoteproc: qcom_q6v5_adsp: Fix double jiffies conversion in adsp_start()
Date: Wed, 18 Nov 2026 15:50:31 +0100
Message-ID: <20261118150105.630691914@linuxfoundation.org>
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

From: Anup Vishwakarma <anup.vishwakarma@oss.qualcomm.com>

[ Upstream commit f559ef6316971fe39dc5f5edd6a483429ba03768 ]

adsp_start() computes 5 * HZ, an already-converted jiffies count, and
passes it into msecs_to_jiffies(), which expects milliseconds --
reinterpreting the value and shrinking the intended timeout. Every
other caller (q6v5_start() in qcom_q6v5_mss.c, qcom_pas_start() in
qcom_q6v5_pas.c) passes msecs_to_jiffies(5000) directly, matching
qcom_q6v5_wait_for_start()'s kerneldoc, which documents @timeout as
already being in jiffies.

On CONFIG_HZ=250 this shrinks the intended 5 second timeout to
~1.25 seconds, causing a DSP that legitimately takes 2-3 seconds to
signal ready to be spuriously torn down as a boot failure.

Fix by passing msecs_to_jiffies(5000) directly, matching every other
caller.

Signed-off-by: Anup Vishwakarma <anup.vishwakarma@oss.qualcomm.com>
Fixes: dc160e449122 ("remoteproc: qcom: Introduce Non-PAS ADSP PIL driver")
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260831-b4-adsp_start_jiffies_fix_upstream-v1-1-9f8cf85ea220@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/qcom_q6v5_adsp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/remoteproc/qcom_q6v5_adsp.c b/drivers/remoteproc/qcom_q6v5_adsp.c
index c10d452c97032..0e772d535d40f 100644
--- a/drivers/remoteproc/qcom_q6v5_adsp.c
+++ b/drivers/remoteproc/qcom_q6v5_adsp.c
@@ -230,7 +230,7 @@ static int adsp_start(struct rproc *rproc)
 		goto disable_adsp_clks;
 	}
 
-	ret = qcom_q6v5_wait_for_start(&adsp->q6v5, msecs_to_jiffies(5 * HZ));
+	ret = qcom_q6v5_wait_for_start(&adsp->q6v5, msecs_to_jiffies(5000));
 	if (ret == -ETIMEDOUT) {
 		dev_err(adsp->dev, "start timed out\n");
 		goto disable_adsp_clks;
-- 
2.53.0



