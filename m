Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216322;
	b=Y7WsTyiUUjnLBRAfB0PxYtn+O/t7C8JrNlPVaav++YLGQaegN4h3Vy7eFvxNZoV2M6al
	 vYjJFSjAiA4LeUZVWTDv1Zc9avACym/NUOmAl9nyy3toHu8019PkmiWzZOhgVu0bxF4WY
	 YT97clZyuzCxF9gYCOn+PfK77q0ixIwvUkPZzSZhFhMlsCLD4xh6Yr33j394H/HIu4DVw
	 ZR1K3vPEFogWI2XnWT/bJ0JuNZWiB6ShF3dUKiik3w2hRrGnTiWUGxLUfV1jSBO3sleSq
	 twt3vXPovFga4uMNCZoSVKpbUNiB1kpkVhIKj1TD+ZGfsXS3UvI0ZwYOeVdC9IB+s3g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216322;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=h6fxKAtXVi5wssAAVk8/Mw2gHjWZUqhEjL3i0KbXCJQ=;
	b=oNYfQ1NHWnZHIThkudl93ObIlYnDYcHrnwfAjjhqkcp5q3/5OFr219a8Kk98zWNweLxh
	 Ey8nZsYoubiDIcIgpIIHvsjWqFYuViMKLQ3ClOGk2OAUNmrAN3E9igTXcqtDtY/5TzZSZ
	 6/6JRMOnAZVNcJUqf//FF4oTBmvOEySuW8Bw8uURPTe4Yx4VM3FEbBhQACkeFfhCY2nVb
	 8nfHsb8n4wZnBbQYxjSxmbfeIIP+CmswhIUN2B45KbHOfzVk1GMeEhDYJ2m+UevJwAxrG
	 8qYvF/e2vOthFZW3cXpicl1emkogHL8nJlrJ2tGw9LHVrg98VvDYSTQODCnwQf3mz2w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1ZNSSEXY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 633C1606A31A;
	Wed, 28 Oct 2026 19:38:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1ZNSSEXY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3C911F01825;
	Wed, 28 Oct 2026 19:38:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216322;
	bh=h6fxKAtXVi5wssAAVk8/Mw2gHjWZUqhEjL3i0KbXCJQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1ZNSSEXY7uqboPjkXkKjB8wmy6LkWTO7AAuxpcB2vCwaPAVAA0I6rfJtOAypnC9BE
	 aqs9Ab/Ddb0YChYRNn/bcAyWYjqUdtx/Uvf1xFIgcmMHydv9sDh8EGEx0b8p2GPY6b
	 Sz22eQBojaP3Hzu5mEFvbkVmZYS1KvgpL5B3b88k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1519/1887] NFSv4.1: zero referring call lists before decoding
Date: Wed, 28 Oct 2026 18:00:15 +0100
Message-ID: <20261028170534.030181575@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>

[ Upstream commit 8fa4804fe62ca4155a2d8fc2789d630376cbf2fc ]

decode_cb_sequence_args() allocates csa_rclists with kmalloc_objs(), so
each referring_call_list starts uninitialized. decode_rc_list() assigns
rcl_refcalls only when rcl_nrefcalls is nonzero. A valid list with zero
referring calls therefore leaves the pointer uninitialized, and
nfs4_callback_sequence() later passes stale slab contents to kfree().

Allocate csa_rclists with kzalloc_objs() so every rcl_refcalls member is
NULL from the beginning, including valid empty referring call lists.

Fixes: 4aece6a19cf7 ("nfs41: cb_sequence xdr implementation")
Assisted-by: Codex:gpt-5
Signed-off-by: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/callback_xdr.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/nfs/callback_xdr.c b/fs/nfs/callback_xdr.c
index fa519ce5c841f..5b538ade22100 100644
--- a/fs/nfs/callback_xdr.c
+++ b/fs/nfs/callback_xdr.c
@@ -419,9 +419,9 @@ static __be32 decode_cb_sequence_args(struct svc_rqst *rqstp,
 	args->csa_nrclists = ntohl(*p++);
 	args->csa_rclists = NULL;
 	if (args->csa_nrclists) {
-		args->csa_rclists = kmalloc_array(args->csa_nrclists,
-						  sizeof(*args->csa_rclists),
-						  GFP_KERNEL);
+		args->csa_rclists = kcalloc(args->csa_nrclists,
+					    sizeof(*args->csa_rclists),
+					    GFP_KERNEL);
 		if (unlikely(args->csa_rclists == NULL))
 			return htonl(NFS4ERR_RESOURCE);
 
-- 
2.53.0



