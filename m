Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061983;
	b=ZspQ08Hjmghxn1GXwP6QnLSFdGjuc4s5NKEpQX0hDaML62RSg/qYK7sqfyHofqnCfq94
	 a+REzNCLxg5poPGK+JCasdx9WB4AVLm38TIb1KsN6BoWZzbJEz1K7BcNoFtZV3wVid6co
	 CRhQEWNqJcyEmDYImsRTCPPZ09skGBa4JNibqiRzoQ7m2W2hdUMRSvMfErDgHwjhzgbVL
	 iex6U4DxFM0Awlpkq+vuxO/k/OTkOkbaYk59nXkEISaVxKmbVSNORxyALCZPMXC1JXyY9
	 g/Sf57oJjbisFLg0cFiUCA+AFK4dPUG0K5JkKwcqCEdGVcjhvGuuCAi5Fs9RE5X0GfA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061983;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sP7vUbfuH2cehjAABEOOuIeYJcP61Dq9J6qL9ZoJH8w=;
	b=h8+CnQYJDCABbuunU3k/NceO/Ec+q7lsi6Fm+BzMrYbvW+uWPjQXwS1mlNF5af3DdG4L
	 PwZf3CEuJKt8Er/vVbZFqncCpZmq+4n0qqhq8D3y/gW0933q2l+hD9uF7zDtGFQdGkVud
	 AbO1wFmPEEmKWw6Jft6capK9ocyMJZi5NbDVJ/PlNfU3APPtKf1P+iILQg7+syc+EzC4G
	 fmxvM9xc+uoNFGvnwenFEtbxTgWzgdiUE23Nrp0WWEvTOQfHHgxT2RI/pITYZXywDYhC/
	 HHjKlOR+s/k7zsOIdHDO+eIbEgyLrI/nCCahZoixhhUox+Ri7ETetWgu8EyGsj7rfkg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HkH1BSS2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24C2F606A333;
	Sat,  7 Nov 2026 14:33:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HkH1BSS2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA3BB1F0089F;
	Sat,  7 Nov 2026 14:33:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061983;
	bh=sP7vUbfuH2cehjAABEOOuIeYJcP61Dq9J6qL9ZoJH8w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HkH1BSS2WX+0Qdan5KqEC0Hsp1hKv+htDPTJOBRW7yrR10uXF2izVxFBLUf4N5uBB
	 FTkPd9QHC8Mff5cHVQBQ92WlPaHODHutrcmAyuanD8Zxyg+s49gDrJZpezWXIA0RVR
	 Nd6ZknASq/fKJOH0XUEU2K07FsqeEOwGn6fMK9uc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0976/1536] lib/842: require a complete history block for repeat templates
Date: Sat,  7 Nov 2026 08:49:52 -0500
Message-ID: <20261107135025.062452569@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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



