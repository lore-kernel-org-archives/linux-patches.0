Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80B61472081;
	Mon, 31 Aug 2026 13:44:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183843; cv=none; b=gtGR/HP83i4Ds9QhZ61PVc3fxtZf1iwrVLUUE94W4Wjafd1sTHEFj4cje/8IYuXETzglo4VWGQq7VJm0SQdk9D0kfl5LK4EyRvvD9Oz2bzy+utCpGXHLPq6JUNF2Vzjg3uRt1NQftqFVTt6uiOJrIEWsV4K4pCoFhnpG2VFVgcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183843; c=relaxed/simple;
	bh=jEQl3cevuWXe6oQ5wgAqItEbA3nxIKiIqn6EsMYTIbU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y+y/5+0COzwZxE0pqjfzFzwOM03eJVzb6DlvB5t/zTvBl0h0bF2t4DC5rArA1Y/+TO9yVNPUaO1gnkDF87i4VKLHsP9KLi/oGRr6tdDzDuvosv5dx2ARk5zFoAq0gqe2cy6WZooup//m0YL0vEy2yuPyYFYqxa0pP7JS1Bh6hXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1ilzi+xN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1ilzi+xN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 945771F00A3E;
	Mon, 31 Aug 2026 13:44:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788183842;
	bh=cFgBhdP0xWZsEjpnV4J+y2w5/m4N1nf3pzegdoFuJ8Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1ilzi+xNmn00w0A+sUwAysRfd2GxK4B0zchfLJKU0+zhOAuykW9ZTslLQGIdLbKuu
	 trVKgH8wWC1Gg+W/ga4QzSNaF7g7ij7TPTHsey+vqn3Y6oHiKYgO0QjsZws7zuoxkL
	 jFAwckqVxaWbqj5UNbYRcLq0u112OvJhiD3Y7MYM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 7.1 59/76] crypto: qcom-rng - Allow zero as a random number
Date: Mon, 31 Aug 2026 15:34:31 +0200
Message-ID: <20260831133402.497869660@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.185608553@linuxfoundation.org>
References: <20260831133359.185608553@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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


