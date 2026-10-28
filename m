Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216291;
	b=nozX4PgsQF+z/Wj5uGtzIgkHNMEPPD74KvVO1arg00rO1q84kWjGZhJ24O4tj3BeNv/b
	 T5T5mCtSxJntZy+M/lzzpNahVhOq+1Ix9k2mcYS2q2cLD7PlrOsNZgrQordF7CBMXVjtG
	 jBYZI5k1Oft/ZeZUUWzzNwI0TzVRbeozpRDFkOX2BS5H5t3sgMoaxd3vmxviIwh5FpWkQ
	 cbY2MAzfty5pWpMvEduLkwV02zwtv58VmcmDNc95tSHUP5kBdsCoqgbL/jwYwPyyGwzyh
	 yJ0qiPUE6c6jxuQek6qpFsEQBGS7WfeJ2A/+QrK4CG3UkOE66kN27sqpbXUyR3wHD1w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216291;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=unNoqfNuHciDPiPTn9m5yHDDRLbILKw8asRCcUBVfUo=;
	b=RLT2DjtiYJTEHv7vs1d7Mt45rs6OgWkX/n1qfw+fO3NzaoYDh7V/Yqz9VB+9bMCa9hZD
	 TC7a80T7bb1Esz2Fc0H1Q6RWaH7X5XiajCQnFHLBVQYxjEfWZvIZRnNB/QK/tRmS+ishj
	 Xu8xHfbTeHWBEU1d6u0tRZ7j8Qt58bPaqkW5/qzrNEJq0NsN1fVSQYHkG8aBZfIiq/WFi
	 IgkkUnxY62NZEgCBPl9by+oPSGEY4gulsgkxqq9LEOfqImOiDPSwkpYM9tfdeoi69ugFK
	 Q1BhjoYO15l5fZsctkQ8Ep07iFaJKC6V2AKM79ASRE0B7TdaXWEVanA0bwHbkOgOW9Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K5YmgrN7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 092B5606A31E;
	Wed, 28 Oct 2026 19:38:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K5YmgrN7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59C7F1F01825;
	Wed, 28 Oct 2026 19:38:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216290;
	bh=unNoqfNuHciDPiPTn9m5yHDDRLbILKw8asRCcUBVfUo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K5YmgrN76Kw+M9XdzBiPruDnxXIg1Y9hxikwUNzp1EFzx5EoXIt9GgCC/cP2suiFz
	 BPsliA8SkAoIBwajy0ZjzExEkjltI2YQBRgguzd/SGCk9yVu75Q5ogs3gCWMX0gRTA
	 JwSz7wzUwQabwZhvndFFVsofPMKDEMbqWsBXXsYs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Eric Farman <farman@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1463/1887] s390/vfio_ccw: Ensure first IDAW remains constant
Date: Wed, 28 Oct 2026 17:59:19 +0100
Message-ID: <20261028170532.749238720@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Eric Farman <farman@linux.ibm.com>

[ Upstream commit 565bef268d75bf7df665bce6923a88cd0eb74592 ]

The first IDAW in a list does not need to be on a 2K/4K boundary
like all others, and so is read separately to accurately calculate
the size of the buffer needed to read the full IDAL.

Verify that the address found in the first IDAW is unchanged between
reads, to ensure a consistent set of IDAWs being worked with.

Fixes: 01aa26c672c0 ("s390/cio: Combine direct and indirect CCW paths")
Cc: stable@vger.kernel.org
Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>
Signed-off-by: Eric Farman <farman@linux.ibm.com>
Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/cio/vfio_ccw_cp.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/s390/cio/vfio_ccw_cp.c b/drivers/s390/cio/vfio_ccw_cp.c
index 3a234cd20cfb0..96e8d5eb2a9f6 100644
--- a/drivers/s390/cio/vfio_ccw_cp.c
+++ b/drivers/s390/cio/vfio_ccw_cp.c
@@ -617,6 +617,13 @@ static int ccwchain_fetch_direct(struct ccwchain *chain,
 		if (ret)
 			goto out_unpin;
 
+		/* Unexpected mismatch from earlier read */
+		if (idaws[0] != iova) {
+			pa->pa_nr = 0;
+			ret = -EINVAL;
+			goto out_unpin;
+		}
+
 		/*
 		 * Copy guest IDAWs into page_array, in case the memory they
 		 * occupy is not contiguous.
-- 
2.53.0



