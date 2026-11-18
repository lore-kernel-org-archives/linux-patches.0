Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039310;
	b=xjIR2xqYnNDwupoCU1KJaoKvuentVQQvVFjUdpesYSFr5RRP98Cc6GWj2ruzrWIlipco
	 hOsJbP+mmZFKdetafoa4jo4DIG9/T4cvOxWDEhldXJGI2DOSH6fFeYJ16pfhcQSxWeC8S
	 V5e0ZyZpfVJWleh21C418DiO2rI6SsFMbBqqHCXr2UTQQHh+hyIomtDIBnGOGvKVLcn29
	 5altvs5d4H5ZUMEiOJvyGywtYFE86YC1IogDPb/83+Doq414q+tyOOHc4n9kpphXklcS7
	 SaPgFWagdfNJ8PTMHjcjoSs4uXx00b8kFujViqVGCzyr065bZ1MI3axVerkso0cMhVg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039310;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6LssNK6WIHl6+Z4T71veGQSzSoSkHUjOTTH9CZs5bcs=;
	b=MharsaZcxUB5Cj0Pnoxxq/dt0vwIrV3GoDEYNJ3D9lKCVcH02r7itOdmUTmod+qFcTaC
	 Gs7bDqkJMcO22Tcx7BFjmyORk3s4WhC8/TT1q8LxZR1/hLsnkIQL0l2FYj1Wkb49FGmSL
	 6R+L5V2lxFyRfRrPvG5LXDuXA18t/12uaj33z0lR/J8bwlmhcqCHBf4rsMyAi3nR191xA
	 dkdklvbtU+XILhgqkczaiatMzuA3A+3k3qUj6qIOI7yqxE+q33crC1FUyrtnq0C6Jfuan
	 rkNXH/yWQHYRJ3EWNhZ+UXTUaIsqUWDUQUpuTCO75fNEN8FXW/h/TT7H/Zc0IOMYTAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GPkBXblV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA09D606A320;
	Wed, 18 Nov 2026 22:01:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GPkBXblV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 074C71F000C4;
	Wed, 18 Nov 2026 22:01:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039310;
	bh=6LssNK6WIHl6+Z4T71veGQSzSoSkHUjOTTH9CZs5bcs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GPkBXblV8VrqmjQOHES/l5K2l8tpTZyPJ6Euj4El+KPCmlijxaMYJ0TkoUizDNMTT
	 q+atf/S4MFdSWku4KGPpWJkTYVjWg8DX0SdXBfgrKo70BPTC3bmt6mpq15R9XcmulQ
	 GDSW8T2/VxgFVqZaXv7+G57c/CAKqNr2NZ8sz+I8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anup Vishwakarma <anup.vishwakarma@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2014/3318] remoteproc: qcom_q6v5_adsp: Fix double jiffies conversion in adsp_start()
Date: Wed, 18 Nov 2026 15:43:56 +0100
Message-ID: <20261118150422.461141793@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 6b1d7c32a44b1..2c9c13c5a51e0 100644
--- a/drivers/remoteproc/qcom_q6v5_adsp.c
+++ b/drivers/remoteproc/qcom_q6v5_adsp.c
@@ -438,7 +438,7 @@ static int adsp_start(struct rproc *rproc)
 		goto disable_adsp_clks;
 	}
 
-	ret = qcom_q6v5_wait_for_start(&adsp->q6v5, msecs_to_jiffies(5 * HZ));
+	ret = qcom_q6v5_wait_for_start(&adsp->q6v5, msecs_to_jiffies(5000));
 	if (ret == -ETIMEDOUT) {
 		dev_err(adsp->dev, "start timed out\n");
 		goto disable_adsp_clks;
-- 
2.53.0



