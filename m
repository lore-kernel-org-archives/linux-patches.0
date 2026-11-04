Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793830929;
	b=iMQ99JM4ZcDxFNpz0ljeiUKySCeeB+mcXmDTUeh3OFeVOdJb09g9IYLXXZ/szEK/n2Sf
	 LvycFCiQQwwChGOZNynLSHXl6KckK1n/J98wdaShyTDHiMBk+kknZ+DbIPpMB5d1s8DbG
	 tIrIN09at3KaK/Oe++1UC95TfJtv4/gm6H2yd/INTKgcIvn25qPlqPeWa8aqaP1e1O+eA
	 ACkfvXHkL55XnwhoXV5BQE2vh26bvyvQ537uxShJGfnfLb8ruNVCqA4x3tYqaZwV7m/iX
	 c5g4KnkroMxIrtCFZx9pGm9WA3WPbpLzE4qGw+V6NT0P3RT1KjJu1dKbCCr3gDcqNjQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793830929;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZEorYstGDMvtQuBBWATXuxwnVinsWILAMDUTuPQb2ag=;
	b=INZfAJ8aQS13t1P4rm0SRqmuRU3Y+9bJ5NAzRQehLCJPdl3dKp277/bMo/CSG64kjXdD
	 kWWE5CevS90j1WnpPbWut+wuq7OWurUb7Vh4NQQjDHugZcs2a7y1tMX/wpPo9UUtJvtFG
	 3IoImOw2r2GV1gXbl4woVDevdbYqR8M20ogPAfZICOn4Cg1+aUuQh64fgK+GVpsZkKI6Q
	 TqedwSpceM19WB+LVH6sYeqiXeaGhb0UMwqTxbehCWUCfa57h1Npt5UpV38KSzzVbNDdr
	 tg8Uv0uNcsJ+ViSqEI6qFSHWNqvxCwet1DAmlpfxHZnhvM5fJe1eMNC/WwfOPmgWkHQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AZNhEi6j;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08310606AB08;
	Wed,  4 Nov 2026 22:22:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AZNhEi6j
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95E8D1F0093A;
	Wed,  4 Nov 2026 22:22:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793830928;
	bh=ZEorYstGDMvtQuBBWATXuxwnVinsWILAMDUTuPQb2ag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AZNhEi6jAnYMlbYhbvXurovq4Ebx00K9ivxRhNBiXHEIFUQzr248dwKY/u+LSLf/9
	 n8xWohFznQcCA3alp8RcyOTSEwfqEKh0foBadaQvaFpPjIol3UIftk4L+gUlgLJ9dj
	 C+FWr4+Lw9JfnHtRhN8UFalXt8s3qZV/pLQMf6D8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gael Blivet <gael.blivet@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0408/1005] ksmbd: fix off-by-one rejecting minimal COPYCHUNK query-limits request
Date: Wed,  4 Nov 2026 16:02:21 -0500
Message-ID: <20261104211055.504761581@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

From: Gael Blivet <gael.blivet@gmail.com>

[ Upstream commit d68d4b3293034f549d55f407a23b4c0a6c90e50a ]

The FSCTL_COPYCHUNK/FSCTL_COPYCHUNK_WRITE input length check uses
in_buf_len <= sizeof(struct copychunk_ioctl_req), which rejects a
buffer that is exactly sizeof(struct copychunk_ioctl_req) bytes -- the
minimal, valid request containing only the fixed header with
ChunkCount=0 and no chunk entries, used by clients to query the
server's copy limits before issuing a real copychunk.

Since copychunk_ioctl_req ends in a flexible array member, the correct
minimum is that the buffer covers the fixed header, so use
offsetof(..., Chunks) with '<' instead of '<=' against sizeof(): same
value, but the boundary case is now correctly accepted.

Assisted-by: Claude:claude-sonnet-5
Signed-off-by: Gael Blivet <gael.blivet@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2pdu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index eec5cb16bfe53..b17296c7b64ee 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -8581,7 +8581,7 @@ int smb2_ioctl(struct ksmbd_work *work)
 			goto out;
 		}
 
-		if (in_buf_len <= sizeof(struct copychunk_ioctl_req)) {
+		if (in_buf_len < offsetof(struct copychunk_ioctl_req, Chunks)) {
 			ret = -EINVAL;
 			goto out;
 		}
-- 
2.53.0



