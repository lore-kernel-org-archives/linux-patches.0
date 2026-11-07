Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062898;
	b=IBLyU8oOuFVgos3sOiKw7s+iJSBjVD4o9m/u+tswOXVBLpSGm+Rb1/f83R/4RVFzUtS4
	 MyY82VlJRTnvTBClnj199AiuggcN0dBgmfvRZtqaFg50hh310B0So5boXJN7n2ccbjrG/
	 Y31k+yA2z0E907FhiZNQBVQRRy8894toZMTiHH8f/egy4dilc+uoXoUTwgTACxVw8rc2C
	 D10yJKpCJvNbeY5S6PyGFGF2zR36AAZQbIUB6BoTFduNBMSaKHoPwpfArWtSP144MhYyf
	 +13An9yH48qfmWH/jbuqIXnaBWhFg3x+VMZsiUabXieZo4PpbbfiP1hakbO6MloeC3g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062898;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mN3BFvTtfWoiNA+1P/xaGb9nxtljSlMiRLh+4CXSBRU=;
	b=SriQWRPNzByhAYVVsldR8blZYs02xv4lFDrKWaIlQeJgprn0c6nR/8lrNoh8gc08dal6
	 nrWlLeGbT79Sy1zajT7eCRMMKFNeBBQ3JRyVEHmHTEMz3w8C+OXgPamSZGYgarIXxycwt
	 W2JcnZUlnSH32fIkj/eBp0Ovlpai/YG7f4meY1L2SCEMO8hbazZ/bTjLlvQxHkWHBL3nt
	 yVxx34IPAbsLfKQhfbXDSdGzz9Sov9WkRP1/XQMQoM/W3CpxAKaNef6EztHiEj8v0TMDc
	 MXvLNoqwvQMW8wTDwNkyViov8SunPE0wyGbWGa9ben2fllp+SC30f+9p8P7TNEckg7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EpkwiUDF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6443606A326;
	Sat,  7 Nov 2026 14:48:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EpkwiUDF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 508C01F0089F;
	Sat,  7 Nov 2026 14:48:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062897;
	bh=mN3BFvTtfWoiNA+1P/xaGb9nxtljSlMiRLh+4CXSBRU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EpkwiUDFMgGKmvqyZwB1UsmkdoKbPt9Pm8+eJmaiiqiey7JZaoIZjjFS6hwqA6LPU
	 C/4lsxa3PIuyaofvwxs6qp1+xK3zSCwikLPO7xgzNhxB2aUqBMJD+gB1nvYDLa/mMj
	 Zkps0O9CQo5b8SRIWD7wsw86u7/9Hl2x5TzAmCZY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 129/869] lib/842: require a complete history block for repeat templates
Date: Sat,  7 Nov 2026 08:46:51 -0500
Message-ID: <20261107134856.844430695@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit deb631649882bbf43f7c2fc79b5990139fd744ba ]

An 842 repeat template copies the preceding eight-byte output block. The
decoder rejects a repeat only when no output has been produced. A
short-data operation can produce between one and seven bytes before a
repeat.

Such a stream makes the repeat copy read before the start of the output
buffer. Depending on the surrounding mapping, this can fault or bring
preceding memory into the decompressed data.

This is also reachable through zram's compressed writeback path. With 842
selected, targeted corruption of the compressed data on its backing device
to a short-data-then-repeat stream made a KASAN kernel report a
vmalloc-out-of-bounds read when zram read the page back.

Require at least one complete output block before accepting a repeat.

Fixes: 2da572c959dd ("lib: add software 842 compression/decompression")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/842/842_decompress.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/842/842_decompress.c b/lib/842/842_decompress.c
index 87d1e0f8a4926..45a9815abd637 100644
--- a/lib/842/842_decompress.c
+++ b/lib/842/842_decompress.c
@@ -309,7 +309,7 @@ int sw842_decompress(const u8 *in, unsigned int ilen,
 			if (ret)
 				return ret;
 
-			if (p.out == out) /* no previous bytes */
+			if (p.out - p.ostart < 8) /* no complete previous block */
 				return -EINVAL;
 
 			/* copy rep + 1 */
-- 
2.53.0



