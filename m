Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047775;
	b=Qv87begDU9D1orTN6yD1xnd/+GTUjAufa1quEPSTs32dIhc42b/IrjYhBUeIyD3ytuM5
	 RjBtNuvrrNgmJQ65KthApxhObMCg1jsa0ttug1jZeqs5lKsZAiKDVXKZwVSLDSkPlRzcO
	 qvZDlFN9PPS0bevdXHd8lLWr3pq7eG52nEXhBOU9DeQ+AB4N/IwVCvOtEXVBONmJZR5AT
	 nP7ca5CXhhOoPi7YUpxAkjFtX4auxk3I4soS8rq0FiXXPSMjaIajHs2t1tBVolUABLPsE
	 jPuepl3wT8SVCYCV+5NRE9jyH0j57QnOBUW5vx+qAuVxVeS7i1rW8z5Owi27MSMeUSg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047775;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GNzTHZV7SXN9/X+L5FGjtPYU9jP34HHIHPqtLF+GYcQ=;
	b=TUMUXuu3Zj53HevMhNxPnKr7u7VUFuI13bBneCoCbkP8HFDeMLkc6w4QREgBxKemeFpe
	 +D1Gc6/rYq/d/diTgGuu07ESZDt7xcbrEvKpNtUN91DiJshfvE9hrXebETPpfz+RBIYE3
	 jd6VPAXm10zs392Hty2ti9QHID2n5cFECXxRS5pVKklSIWYpYVVwxZ9Dyb3BSeFPSkRpQ
	 DWbH8vqUHdP4C4w4A0a5+E8KS7ODY553dv9DFS5EkjVm2Jc6+GPu7DMyvaq6HvcPkJw37
	 WwUuSsuJOqI5PV4u9tygnqDIG5hzgMtY7f5RKVHDCKIrhu2tlizMxjgntBlCcahtU2w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="BVscaFY/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3424F606A325;
	Thu, 19 Nov 2026 00:22:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BVscaFY/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8919B1F000C4;
	Thu, 19 Nov 2026 00:22:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047775;
	bh=GNzTHZV7SXN9/X+L5FGjtPYU9jP34HHIHPqtLF+GYcQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BVscaFY/gc/m10081oGuGLVVpIqm1bE/pEu8ypQ3IZH7iJ6bvk1QYkwk/bExWk1do
	 O7IHxj+W45StREbokjZI6Lyve9BjZ1mDr5NY4wKTEjH227S6nRytexAk4StxBmavQW
	 HXIMcrcJsJArgfNUcJP0L5r5gJu8kx0/ph+0TF/s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anup Vishwakarma <anup.vishwakarma@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1758/2857] remoteproc: qcom_q6v5_adsp: Fix double jiffies conversion in adsp_start()
Date: Wed, 18 Nov 2026 15:46:32 +0100
Message-ID: <20261118150304.589376617@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 4c9a1b99cd511..efc4740074713 100644
--- a/drivers/remoteproc/qcom_q6v5_adsp.c
+++ b/drivers/remoteproc/qcom_q6v5_adsp.c
@@ -376,7 +376,7 @@ static int adsp_start(struct rproc *rproc)
 		goto disable_adsp_clks;
 	}
 
-	ret = qcom_q6v5_wait_for_start(&adsp->q6v5, msecs_to_jiffies(5 * HZ));
+	ret = qcom_q6v5_wait_for_start(&adsp->q6v5, msecs_to_jiffies(5000));
 	if (ret == -ETIMEDOUT) {
 		dev_err(adsp->dev, "start timed out\n");
 		goto disable_adsp_clks;
-- 
2.53.0



