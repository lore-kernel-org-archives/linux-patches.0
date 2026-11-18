Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028948;
	b=KqJErXfdhYtckPL6b4wdmgRRy2nTTOy5tT1lQBXNIWrwk4X+6K5jN7AIM+i9Jtmm6F7p
	 /hRp4oXkBhH8WqzEXTdc8tc2u/s3Bv6uQI3vTWQpl93J1MKrIg49/dikQJewsHda2DtJy
	 sIOLOAszoxvNNpaL7/oApFcszkwEt+qdE9wX0I5Rt6iXMT/4BVXTfME5F6WDQzg1i+lOc
	 xwXBGqSCk3JZH2q6ClmOP/QuqlclkBGS5gv7Oj/SSrnyppz9SRwgA2NDbl1aAdNTF9b2P
	 GSCAI6Ff41TAR9MBy6OPh+FhrslsktVc/10Z78IrvHDI07b3sa+Sv38tDFYLl+1oSHA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028948;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OUTkSfbXcbdk814nQH9+s1q7lbSufYXXmqjyTqkRqZs=;
	b=sRdfKEh3pddwF+5f1WsqBnM2MTptfji+m5j0gEjIuucgzvOOjUT2EAaT2s+QuGzENUB8
	 Y/i0oWFWJrcK5NO7P63jzs5MY8Z2ciaXoI11Gr8FxJYQX+h9ra3Lepvv4Rg21jRn6V05l
	 o8KAZnnM1Awey2CzXfer6GDwUUunmSxJNMW2zmy2pefUIgUv4D5J1bC9Ujovk0boJEAdn
	 hMszXEmi8IXngR+4scdHqUTidMGslWC3dj/iYjODosElPMEb9FJKK96wDsMmB+T/5lbZG
	 hbE1aoFYDVhRBieDAE/DS4qdL8YD954IXw6LY+8Mnkfw2c1wy4ZSFGe1YqgnGzaSP2A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cBmuhZcM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6346C606A33D;
	Wed, 18 Nov 2026 19:09:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cBmuhZcM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF1D31F000C4;
	Wed, 18 Nov 2026 19:09:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028948;
	bh=OUTkSfbXcbdk814nQH9+s1q7lbSufYXXmqjyTqkRqZs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cBmuhZcMtVXDBjh19s+SHR/NJNxKTclCE2b2enI6O9XVgfUD4ZS0jqzu94jtU7Bs7
	 YcjuiQ+5nSB+R7MtXbHXs0Pz3/Nm1aiTYNwBGlnRnv3xWSkIaxRCe8/SvJKkYEmfuK
	 B+Dn80Z1cpzIquaiKv69wLucsetBy5zWmTjMLFX4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anup Vishwakarma <anup.vishwakarma@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0177/1756] remoteproc: qcom_q6v5_adsp: Fix double jiffies conversion in adsp_start()
Date: Wed, 18 Nov 2026 15:38:24 +0100
Message-ID: <20261118150015.498627897@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 13c9898447b2d..a9caa028a7397 100644
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



