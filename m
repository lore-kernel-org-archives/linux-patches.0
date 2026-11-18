Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016342;
	b=c2ExTEWHkHYwcDmOChe3ZZhobd8SM26xNjbBrqIQn32kd2VKJWUGwq+0BvxWJ23sKhcO
	 /nuIteHO5J/OjRlF6FTDHN+6Ltqhmu0QArlDgcqrfK8iBNGttFhsTLkQK4/kP78ZF0c8l
	 A5TyNVbNwPvDccfEJAfF/4SfcK13igqfEqdDnoO0DMZ8XbqTGXloK/Tp2Q4BWv5LF2cvs
	 JZ8EqMwKfmC3Z3gRGF6zTaFmIrQGvoZj6lvjnNKz9xZtN/PBgVMU2Ku1g5/ZXRBqUpYUL
	 PvLDPdfesweT6/Dt6FCmfzb9wUKtnVVzKoPJoB5vw5zxWU7btjgF9MQZocw8kiZm3Yg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016342;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5q4mLGdo0y6KgSOZ3mHqP26PiBmv9myMTBQV0S5PffQ=;
	b=yCQnVydAg0XCgpzusgsC/WDy+xyfCziqA6YPSQfKiVFsPWJlpbE7LHnav0LhMtqGZLkh
	 XeiJcW5RFfHcQn/OXpQh/+nsyeWuqeUTnwcn0umvCeFqLJhtQaqdW46OQD+Et3Ekgu8YI
	 0kDjS3HOQnvzEWFVg4BqnshK4K14WGyd2sMwX8gxj8BZDM4dEeQ7j2RBBjvRGpljLz/sA
	 RDri7Zj9TWmtlOAItEUoN4r1GgrC9I0pIeSe3LO1T/iOGTjO6oSOkg5BjR1xxYcGAJm4V
	 +i7iNbOOZnZILSy+sWPPM4rtf1l3uI5dbJhO/fnyIJJL3Iade1Zk9XglqXox1UiFlxA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hhTLFD7J;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8ED460A2611;
	Wed, 18 Nov 2026 15:39:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hhTLFD7J
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4172F1F000C6;
	Wed, 18 Nov 2026 15:39:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016342;
	bh=5q4mLGdo0y6KgSOZ3mHqP26PiBmv9myMTBQV0S5PffQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hhTLFD7JknLy5YJbmOaCI3WHYR5yUn4xSuOCnYe7gFVaY76wnY3harihaDt7O8hP3
	 Vl9dxSik0rnD26WseBSHW/mWdprveaRyhbIhtzKqF0LeqWcFXd09p+YSTb5saVBue1
	 BSX83uVEGakeU8V32+W0O5GaHnAVI6tudO9tdWLY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Georgi Djakov <djakov@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0495/2651] interconnect: qcom: icc-rpm: Dont skip small votes
Date: Wed, 18 Nov 2026 15:28:55 +0100
Message-ID: <20261118150305.594245689@linuxfoundation.org>
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

From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

[ Upstream commit 40ea86fa389cf7fbc2280bebef353c36b1ec9b94 ]

Small votes (such as 1 or 100) can end up being rounded down to 0
midway through the calculations. Use qcom_bw_div() when dividing to
prevent that.

Assisted-by: LLM
Fixes: 30c8fa3ec61a ("interconnect: qcom: Add MSM8916 interconnect provider driver")
Signed-off-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Reviewed-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Link: https://patch.msgid.link/20260909-topic-icc_rpm_smd_qol-v1-2-6dc5b5e97626@oss.qualcomm.com
Signed-off-by: Georgi Djakov <djakov@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/interconnect/qcom/icc-rpm.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/interconnect/qcom/icc-rpm.c b/drivers/interconnect/qcom/icc-rpm.c
index ca4c8a944755e..f571f002ccbd2 100644
--- a/drivers/interconnect/qcom/icc-rpm.c
+++ b/drivers/interconnect/qcom/icc-rpm.c
@@ -298,25 +298,25 @@ static u64 qcom_icc_calc_rate(struct qcom_icc_provider *qp, struct qcom_icc_node
 	u64 agg_avg_rate, agg_peak_rate, agg_rate;
 
 	if (qn->channels)
-		agg_avg_rate = div_u64(qn->sum_avg[ctx], qn->channels);
+		agg_avg_rate = qcom_bw_div(qn->sum_avg[ctx], qn->channels);
 	else
 		agg_avg_rate = qn->sum_avg[ctx];
 
 	if (qn->ab_coeff) {
 		agg_avg_rate = agg_avg_rate * qn->ab_coeff;
-		agg_avg_rate = div_u64(agg_avg_rate, 100);
+		agg_avg_rate = qcom_bw_div(agg_avg_rate, 100);
 	}
 
 	if (qn->ib_coeff) {
 		agg_peak_rate = qn->max_peak[ctx] * 100;
-		agg_peak_rate = div_u64(agg_peak_rate, qn->ib_coeff);
+		agg_peak_rate = qcom_bw_div(agg_peak_rate, qn->ib_coeff);
 	} else {
 		agg_peak_rate = qn->max_peak[ctx];
 	}
 
 	agg_rate = max_t(u64, agg_avg_rate, agg_peak_rate);
 
-	return div_u64(agg_rate, qn->buswidth);
+	return qcom_bw_div(agg_rate, qn->buswidth);
 }
 
 /**
-- 
2.53.0



