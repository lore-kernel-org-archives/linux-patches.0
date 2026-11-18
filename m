Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022890;
	b=4QApfHbk/QBE/TBEd42ZiTy57beiu1Vbp06wsrwyQtGpY7E4L/e7FHhkRT7q6wpQvpDm
	 xw+GzfsAKPcgmRGNJ2QgbEIvD9u6DLFaUasoY1n9oQ1ltm1G5I2AjRQiItv+SL5mIIyFA
	 YKeq9uNFyWwgrFNelQT5CuJgV7V0r8bTxSCnBxrKbtuk2eqft8+PTYFMtTp+EbwRaKJv6
	 sM/7fAI5co5lqPLrnxcZfIsAWOVBV0gveR5svsK3c4Snlkw3km+Hke3TGOxf/ChTPV0bl
	 bS/V//TuVMqCQtRnVPbwZ+50LhxIWbmHq+JnGvug16yv16xzGKWV8XE8J9CSN9LjxKQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022890;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RJaSVD0qN3S7+eUy7MGDgWWnwxDkPjk97H3bbB2ImNI=;
	b=QgBGO2Uvn1BU2wv73yhZGjn8zYZTOYEix4dHirL+wo/lsT/qy9oejTrEK/W9bUApH7IJ
	 QR2aubbivMJxm//BpJj3IbacHjz8wWvIs5Ar2OPwarlPj0FtD34foDTKaTprQdE8fdd/q
	 jiOqOnMcbQbs8lAYcICIvYq2iBDcojvpNdSM4EpL4WisXPn30iBlN2G1skXM9OklHGBGA
	 0DsiSn6ySLX60xI5kmRENuli7odbFWgTnrd6UZ+7/pe3+UW3vUbyfzp2bYAuXnDr031Gl
	 nUpMzOkXYKCuyAktfCPnekCYpUxRatclVrGaZBTxTH8fkz8BjQDJnAo2sLpR7yN8G/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HOtMXrCL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F190606CA67;
	Wed, 18 Nov 2026 17:28:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HOtMXrCL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93F711F000C4;
	Wed, 18 Nov 2026 17:28:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022890;
	bh=RJaSVD0qN3S7+eUy7MGDgWWnwxDkPjk97H3bbB2ImNI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HOtMXrCLtJTADmgkitAXCPkEefOTpBOwz+JlvnBePo5RtqC/oIKDldS+2w7a6CdMy
	 MoxsQYfZMtZ/6rqapA0UApmC+YvSttZV0BfXZ3xmoqggX3huWesrcrw2EhooW9fpCZ
	 ZlOCI0rxGAeEpvVQL5xNdzA0yzlh0jzbcafcot3w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anup Vishwakarma <anup.vishwakarma@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0173/2151] remoteproc: qcom_q6v5_adsp: Fix double jiffies conversion in adsp_start()
Date: Wed, 18 Nov 2026 15:31:48 +0100
Message-ID: <20261118150128.045146359@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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
index 004dab45cf3c7..29c65021b4d3e 100644
--- a/drivers/remoteproc/qcom_q6v5_adsp.c
+++ b/drivers/remoteproc/qcom_q6v5_adsp.c
@@ -430,7 +430,7 @@ static int adsp_start(struct rproc *rproc)
 		goto disable_adsp_clks;
 	}
 
-	ret = qcom_q6v5_wait_for_start(&adsp->q6v5, msecs_to_jiffies(5 * HZ));
+	ret = qcom_q6v5_wait_for_start(&adsp->q6v5, msecs_to_jiffies(5000));
 	if (ret == -ETIMEDOUT) {
 		dev_err(adsp->dev, "start timed out\n");
 		goto disable_adsp_clks;
-- 
2.53.0



