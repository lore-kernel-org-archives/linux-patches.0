Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063672;
	b=sfDGLp5ql+ceMNmQpTDfQdZmQgqgZHoZaKbIGJep2LOWzsFPLdYHLIhY4Cv9e8VwrAJ/
	 Zmz1Pa6ibGq28n/2EHpp0o8kzza1VWHhO+8vAnTqWbTYnQgbZPcpudfWE4e5UfTqtI1uu
	 UZSfTjtOrp17Eeur5ElGcByhnKg0GVyeGQLJTyt9ztDkdBDckqAw6YhM1lOoHrmv1TTxo
	 e2BwKgowfOJI0G+++ujQ851y1nPxme9nPWAissraWuOlWhRUK36HoppilLKKaNQLCtLwi
	 b1mSavRQA3Q/Fce7kCazIOivHuo8y/WKVddT5PbZcoT5+iiyFgn6XEms4U8vp6dpfLw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063672;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NLI00r9hxFpLUyvV7Vf04qdIj4wmMaM7ZeKOo++hFVk=;
	b=30ZbjZ25egWnYgNds/vYiaDbakjrT+hhZoIAaMpB/XOPExSHoxhn/RgiCMY/Sy2Ok8IO
	 MhICqMg4kJx53QjAzn8QSwngMXTTcR0RcAO1HOP40IS7a0TJ1UqtztFIWrX5N1yY9x5oN
	 ugc9VdP8hEh0DHEjFbIqGgNdiYDF81o+9jnkts3yznm2fjU4+U3i7ny337PiZmphfc4LE
	 niOXTB/24rvVHPyTa2d+c+B7fzwBOowE80fXltkLh5s/0pkCdnB0mHfqA8KP5O3G/U6Ei
	 keSKzPMQMZ9TnBplz+3r5FAIBYW2LOQvDiYynOnAT9ziS9W8tY6kEDgcbBGynsbhx2g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yHh7nEEP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB27C606A9EF;
	Sat,  7 Nov 2026 15:01:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yHh7nEEP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 590B11F0089F;
	Sat,  7 Nov 2026 15:01:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063671;
	bh=NLI00r9hxFpLUyvV7Vf04qdIj4wmMaM7ZeKOo++hFVk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yHh7nEEPwgkSl1KzpxRvYxlh+c16XqNOrJFO/7uNs4wrH1tjyOxa2/fBd4xW2Phfp
	 0VRXsQnDbqZKX1Aar5nTrbWx2YqHsXWChYSqugtCQy75I+uxIj+ap1m9/luIkbK4Rv
	 tecnmMjiCdFGUMQk1bdbrxTDJAW0NOOrSGPDmcc8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sung byeongchan <tjdqudcks0424@naver.com>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 782/869] ceph: validate fscrypt auth blob length
Date: Sat,  7 Nov 2026 08:57:44 -0500
Message-ID: <20261107134919.190559465@linuxfoundation.org>
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

From: sung byeongchan <tjdqudcks0424@naver.com>

[ Upstream commit bc418e234e5be14b97dec90e84a680e615b4134e ]

ceph_crypt_get_context() trusts cfa_blob_len after checking only that the
inode-owned fscrypt_auth allocation contains the fixed header and one byte.
An MDS can therefore place a larger inner length in a shorter outer object,
causing memcpy() to read beyond the allocation when a caller requests the
encryption nonce.

Require the complete blob to fit in the inode-owned allocation before using
the inner length.

On the tested baseline, the malformed reply produced the same KASAN
slab-out-of-bounds read twice. An ordinary UID obtained sixteen wire-absent
SLUB redzone bytes in two non-KASAN production-path runs. The input was
rejected twice after this change, while a complete context still worked.

Cc: stable@vger.kernel.org
Fixes: 2d332d5bc424 ("ceph: fscrypt_auth handling for ceph")
Assisted-by: LLM
Signed-off-by: sung byeongchan <tjdqudcks0424@naver.com>
Reviewed-by: Alex Markuze <amarkuze@redhat.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/crypto.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/ceph/crypto.c b/fs/ceph/crypto.c
index a236035f3a7a4..f23ba5c148780 100644
--- a/fs/ceph/crypto.c
+++ b/fs/ceph/crypto.c
@@ -83,6 +83,9 @@ static int ceph_crypt_get_context(struct inode *inode, void *ctx, size_t len)
 		return -ENOBUFS;
 
 	ctxlen = le32_to_cpu(cfa->cfa_blob_len);
+	if (ctxlen > ci->fscrypt_auth_len -
+		     offsetof(struct ceph_fscrypt_auth, cfa_blob))
+		return -ENOBUFS;
 	if (len < ctxlen)
 		return -ERANGE;
 
-- 
2.53.0



