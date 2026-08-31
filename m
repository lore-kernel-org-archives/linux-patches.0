Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF2464B5CC0;
	Mon, 31 Aug 2026 13:52:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184373; cv=none; b=DpYCTa5iDrh8Zj3IzL/aOL0jLqKtVyY7U7mqoi2q6wZHVFlJNDPN0F/ZahHgjY2WW5HN496wrusbL/4PuJYsk02noiYu1/ZTpURu+vWLYiZtPH5HPR0TSqMvKHhqmErkwf5qur3cighx/K/kO4wCy9woA/dGV+z9K5CK30oi054=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184373; c=relaxed/simple;
	bh=eIiCh/+9RQ6gjD3RYH7WGVjigrnz1sL5ty66ZUxz2+8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dJPqfqSQeH5KG1QPmjy0pRCKf9Dku5UiEBKgO3JGA1n6Y72K6XOWxAAmOQKJehPCbqrI5nNtjlyGopbBP7f9bviZmF03pJmKduxbOloiDhStDH0NbKHKpkxDzKrzezHGgSIZOGQzmgVZolCQ3cZ+CIBHEwt1icScH+7kCuVWLlc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rBdXfnmP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rBdXfnmP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8BF01F00A3E;
	Mon, 31 Aug 2026 13:52:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184371;
	bh=8/X52A5t/VS6u2akMCw1Gv+S/Nyzvw76IUMMAzkAtZA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rBdXfnmPs0onX6j2yxuLCxOV7Q3NJGzRylDMK+u6q4kWcNQgKClj76NgPO7WLI9I9
	 uI4FmUrpAcrrzn1ryZ5CygRtTE7R9yGy1TSrsBe068hbJ4CQai9gbGl+VDA06JOWfm
	 KOnsJbrauLJjBqc0pGmirGQfAMcGpvAf8Q0i6wF4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.12 84/99] crypto: qcom-rng - Allow zero as a random number
Date: Mon, 31 Aug 2026 15:34:53 +0200
Message-ID: <20260831133404.028015613@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.740409777@linuxfoundation.org>
References: <20260831133359.740409777@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -65,8 +65,6 @@ static int qcom_rng_read(struct qcom_rng
 			return ret;
 
 		val = readl_relaxed(rng->base + PRNG_DATA_OUT);
-		if (!val)
-			return -EINVAL;
 
 		if ((max - currsize) >= WORD_SZ) {
 			memcpy(data, &val, WORD_SZ);


