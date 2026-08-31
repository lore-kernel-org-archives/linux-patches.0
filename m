Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F83456854D;
	Mon, 31 Aug 2026 13:48:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184089; cv=none; b=pEJIL7vcRl1nBqY3+Kpq1tYQUTFPb3MnfwHl5GVnb+6by6p4BxnIRXnXhlfKqI+hPWNOakn4Rc0TwMV/6113Jf21DHlQ86XJjS+AV3Byyj/kGVCufDjpfi0XXjfIoyVCMRpjuyLofDm+/k98MnvIWEyQNso+ZnmgaxN2bNNI6Vw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184089; c=relaxed/simple;
	bh=ycRQRATawsPQJ2oCqQpemFUkNLBoKYqb8bXWMTGHDeQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rIj80KxmgGF0+ISeuu/dsJ2YtZP95LpMXLIa0dj2Jv502sGDmIRD4bQry8e1YuUSjMKsyinRY80plc39pi0j4IeWcYcybMuevpu1Vic/cpYqTVK0z7S04edV+vXiTuyACEGd3rKAk14h2NPwrr0fUVdkiLIV8Q1ucBREq7PBT0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VElSlO5l; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VElSlO5l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 634641F00A3D;
	Mon, 31 Aug 2026 13:48:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184087;
	bh=rWjcSRt/4BL1RDdvRbTbsUxn3VM0UvCYdNRyc3o4CM8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VElSlO5lF8H10ws6y6unCSnkd59KUCtuPJAc68sDy3jsLhpQ/5ijs9OqLoYsrKmbi
	 BU7pvhWF6CZgP4Cv55yylDZvkEfHiSFWyq/X3wAXy22514tTHdnoSJFIhPL8TPwlH7
	 AFfjc9LLi1x1VpBaGlkbY8op8HPtLTIrTjW95dmM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.18 68/83] crypto: qcom-rng - Allow zero as a random number
Date: Mon, 31 Aug 2026 15:34:44 +0200
Message-ID: <20260831133402.955422551@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.207714926@linuxfoundation.org>
References: <20260831133359.207714926@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Biggers <ebiggers@kernel.org>

commit 4ef04bdc0c9f98836d1638be516f6bf1bad55f69 upstream.

Zero is a valid random number and needs to be allowed.  Otherwise the
output is distinguishable from random.

Fixes: f29cd5bb64c2 ("crypto: qcom-rng - Add hw_random interface support")
Cc: stable@vger.kernel.org
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/qcom-rng.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/crypto/qcom-rng.c
+++ b/drivers/crypto/qcom-rng.c
@@ -54,8 +54,6 @@ static int qcom_rng_read(struct qcom_rng
 			return ret;
 
 		val = readl_relaxed(rng->base + PRNG_DATA_OUT);
-		if (!val)
-			return -EINVAL;
 
 		if ((max - currsize) >= WORD_SZ) {
 			memcpy(data, &val, WORD_SZ);


