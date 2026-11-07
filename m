Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065416;
	b=5n9sL5d1i9lj+MjSqTCLFAz/kFl1OzaLokSTouApy33y/qPWWATklWAUjvGPUi+YEjLM
	 hwcsBZvXGaghiLdi9Y/OIdy8Em/ga2GAZaMctzlsxKIL5jZO40SemJfUiILSFPQDhOVzJ
	 OtyZ4swlbCSKmfEPHJLF2HcQ+f9P+yN85XLYzZrf3loZ6QFDlZTB1zBIfwpaMvmTRZ772
	 YCC5Z7WzRk5OwaUqtW+OgpTd9GIBR4Agblb+ox5lHU7e3Wl6HrT3RETjuwtSyLh48wesQ
	 2o5NgcxBz3BHO76nIjc3VwQuD1zTCff2Bo3BznvDOc6VY4FtD+syXJRqlh1igPrADjA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065416;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9qXyMFxBgGxviX69DvYrHYBg3HfHd6BE0IY/KNIBzw4=;
	b=R6vEzpiHlgd4cJIBQM/Efzk5YQeSGGtmsLzJdpYlSS0Fwn653hV0dAEsp72CmjTfYDBd
	 5pMHAOnigHvSktNbtmFEDSF49frxVMRfHgaTyuXfC+TlencHqK6cDaqn51PhdjVlHuvZb
	 g1RJffNZhRBVZ++5/3sI9/Bv4EnUBrKugS87c++1gQyBiEGm4bjXXnf27v/MDdGOjI6qn
	 I9roTCcEhO+b0KBNcvmcLKgQvJfYh21hPfCbEBOcBa71uz8Jai8m0bHRZV2vNd7Q5eC5u
	 QATtM9hEeKL1IUkTKwR6XsSHAsF6uKhunxTkfpY4FIVEGaXegViPaDwlhkS4u4xmz7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kZd6Wx8Y;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFFED606D80F;
	Sat,  7 Nov 2026 15:30:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kZd6Wx8Y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E5D91F008A2;
	Sat,  7 Nov 2026 15:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065415;
	bh=9qXyMFxBgGxviX69DvYrHYBg3HfHd6BE0IY/KNIBzw4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kZd6Wx8Y4Rx28GIGEikPCub+DHQGJvBQaFdSzVOgwp0k1RsPwXNPKa7hDfPgMS+E5
	 hkfnMsyIVnZ63XYkA9Dc2dXfqvJ3N6g6fMZAaT5t5ORjCYizPwxP/6S1oXCocLblFF
	 0bqEuvN5GlaiD2t3AjFta13F0Vode/+aOUwvvvcc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sung byeongchan <tjdqudcks0424@naver.com>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1132/1257] ceph: validate fscrypt auth blob length
Date: Sat,  7 Nov 2026 08:57:08 -0500
Message-ID: <20261107135010.495088071@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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
index 845b69ba890c3..46acdaf9a822a 100644
--- a/fs/ceph/crypto.c
+++ b/fs/ceph/crypto.c
@@ -30,6 +30,9 @@ static int ceph_crypt_get_context(struct inode *inode, void *ctx, size_t len)
 		return -ENOBUFS;
 
 	ctxlen = le32_to_cpu(cfa->cfa_blob_len);
+	if (ctxlen > ci->fscrypt_auth_len -
+		     offsetof(struct ceph_fscrypt_auth, cfa_blob))
+		return -ENOBUFS;
 	if (len < ctxlen)
 		return -ERANGE;
 
-- 
2.53.0



