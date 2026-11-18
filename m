Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015414;
	b=24mHJ/kMSfZA6NLHFtqaFZh9MasdQ83Ps4CKKhBDQ/kWseXY1wowV0no8S9pqqvlu1rc
	 uTyCTPLUQ69jnp6CNUOxd9w+hEOe85JBfYqCSCFyt/0cnexiFw4dosqNrNxxSBJXa1FFY
	 tFFZcqi9Vl5i1rCCrWrORmcRIMAMRTucwYdyU1iqlmV+TmLRp+CuhXPKmL8biyNStgWmS
	 nLmkEgTwtpWot+aMRTaWMqwa5gF9wuGvcBZ4XIFAqIq7ITzPYER4k68f/e/gWH+3ygCis
	 ZiZPkM4Fh862+iLjI5HsK7Admb5Vdk4TOEeqzFrgnjOssA+Vmw9Dr2o53XcTEgQGORA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015414;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ri1spFALclhaE0jcEs/JJ7nVupANEY7E0tynUYI//1o=;
	b=s+Ruo8FIRED2S89fqugMgyYhzamFI/a4ARpunFwF6boPWwMdX1Q830G/qjwEB94EbPGy
	 0lLUxlsDLguYxzNqkb3HgUQMQp2FjwfFjd0BZKcfYQbePShXpQxkHkod0FI4fFnIwmVyd
	 1Vs7dYgJCuPGs3SnrjLT2jAfUo90vs9oYVfkW/5Y1K/rg28FHD4ZgA8fr/ggewEYE/V/J
	 Gde11FlvHc2u+npvHjMVqU621fsUYowQXk7+fh8uBtQMQEHjN853HK+r4Se8UOMBxJiuH
	 SFDCen2SC2oowEFdV1p3FJfnQKGPsTpXdrbFPzRr86DkryYreXBNj81/8SUHoYVjIVA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XpHCHeuO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCD70606A330;
	Wed, 18 Nov 2026 15:23:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XpHCHeuO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C7271F000C6;
	Wed, 18 Nov 2026 15:23:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015414;
	bh=ri1spFALclhaE0jcEs/JJ7nVupANEY7E0tynUYI//1o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XpHCHeuOpfG9B7tR3B2ckEq/UfQXl5CH7/4PE2jStHelm8llo+y87aLFpA+u3G8VV
	 M1Ah8my4D4mQR3QxANr4ZC+in9ZyawnZpFwynpFb8NOl0jAot4+hOUu0g3wJjSrTIQ
	 9Xrhp74oXwsE3eh1YoTQyrSjw6F94IidrUbaZhz8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anup Vishwakarma <anup.vishwakarma@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0124/2651] remoteproc: qcom_q6v5_adsp: Fix double jiffies conversion in adsp_start()
Date: Wed, 18 Nov 2026 15:22:44 +0100
Message-ID: <20261118150252.327793717@linuxfoundation.org>
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
index 2e5fb5954fa9e..46d9169a37f6f 100644
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



