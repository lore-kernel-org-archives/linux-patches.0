Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D62944E3EE1;
	Mon, 31 Aug 2026 13:39:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183598; cv=none; b=Bd1hWASB21e5kNkJp0aOu1qIz+vEeSGa9iAIlY3gEphr/WHhjVfMp3T2Ev5pdoF0rH8worU/+YBxpdLZekn3isOTtDIRl0RDnuweZGFP1LZ8XEpTHm2JfsF4urGPxTsM5GPZYe3oXZ18v52ph6rWFQLCvZLTKecGE3szfjhHJnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183598; c=relaxed/simple;
	bh=UaVjcA9Sgmu8U8YiQpO7PAV9usq9pK8zeQAfrK7FP9Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uwCqUA6WkrTvyJhau/DGX2FVgjYANRijYAAP5+QmM3jdU0k9aWYz0XNocrLYtu9QVQsmixC0mRzAYbXvQuDLJ+dM3hauPfm3QsgrV6ZLDR4/qiYwdUuwT/el9euQG/+t919iB6wy007JDeUv7KXPZ4yXuODEVexb6JnVxTz1vpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LFkKlphx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LFkKlphx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CCF11F00A3D;
	Mon, 31 Aug 2026 13:39:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788183596;
	bh=RDBIvOhWmpwSV2UOGxMaUkPCjAPw8nz65G2HQWIbXO4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LFkKlphxzgvPpibRCzxt9NIqSon2TDfBoLzg0D+h1txUYET2FhP276IsbmKYov2Rz
	 cq/lkSFfW4uBMBdZTt6ll0dB5zW2Em1RcA0l6KAyqRbCcBEfSmIMaggvHzstHVapBs
	 qFjoFNV35LsMKsU45dXkFMhOrDB6aIumXk/6b/Fg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 7.2 52/71] crypto: qcom-rng - Allow zero as a random number
Date: Mon, 31 Aug 2026 15:34:17 +0200
Message-ID: <20260831133401.929838331@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.055927882@linuxfoundation.org>
References: <20260831133359.055927882@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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


