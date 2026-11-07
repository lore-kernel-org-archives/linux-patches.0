Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062592;
	b=3pkrcwfCrqbL5d+5ddfaW1cELChKV19iftdg35m05dURSQF391QSxL1IARH+jnu0d5aE
	 TWs+t5s49JwRNPcezio+ei4qlJoPwZwDkL+vbbi9MDmXOv/ueOVtX7WecW/51GM42KZDi
	 vtR0ydf3b/13sIbthOpF/HYE4HIP7Fvp2oyLu6qY5sr/GhXpA9UVNSQBsc+jmCj5vVVzL
	 yH1eoYqhlQWzMPsrfaeC9Vlys1XtezWfqC/2JvKigXYe/8DAXeUSvT0Hy6MSdkdQO2QJ5
	 55PJB83pH91dqPNNouJaoezqCtBFz3+RNO6gJD5mFM68PAoS5BlnlFlkcbDo2rogrhw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062592;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3Ll/J45jp/2TgkSn/D8V222F3+0l7upQ9CXVlNbceYc=;
	b=wA2+veE9K8SIq8TfR/+dCD5hU3I+AtxHsQ+SoOjKj4rRoYDViqShjevzPWW1ubk/vAcS
	 xgCig8bNxWrXvoaV5A+rxKEOVvy/MX4PSk0Wl0X3bDZZ0fu45v6Rvajpmn8vgQbxF/bt/
	 eWUtNIb4NXb/R986hcCe3ztiXwhh8ZTGCTnsRLfrX4THANnHlayMWJzDsinHjczUH6pKh
	 1vN/vUwRLsoyO/1SG9xBZPgOLhFrfKDc2bjuRLXvkLmNYoF+Lz2oeDODrCJbx3UhGec94
	 uSoCVn8q7/167/cq8eczuj1r/lgjzHg4ug7qEGqXCPayiqD3vmpUbtj7zWmBqcTLuiA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=J5lS+YuH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF012606A330;
	Sat,  7 Nov 2026 14:43:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=J5lS+YuH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DE411F0089F;
	Sat,  7 Nov 2026 14:43:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062591;
	bh=3Ll/J45jp/2TgkSn/D8V222F3+0l7upQ9CXVlNbceYc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J5lS+YuHb7AXVEKAJIxCwCG0ch2LZS+LwUvr+v7HMbvxelPMMbF6ywbF1UWo0MEiX
	 I1zuhG7b6U50TBZ+rlih2tEXEDL6V1gzo90DyyRNH9kWyIl793d49eS1z/EES2m6Qm
	 SNPpuMNElpvntU3ajPq4oiyXLAOzejqZNRnM8mGc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sung byeongchan <tjdqudcks0424@naver.com>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1469/1536] ceph: validate fscrypt auth blob length
Date: Sat,  7 Nov 2026 08:58:05 -0500
Message-ID: <20261107135039.104528398@linuxfoundation.org>
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
index ed6b32f821a8d..f955a37d6b17d 100644
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



