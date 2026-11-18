Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022912;
	b=taM9bWVoazCHeisO64PotmF34/3qPQhkyq02IvrL43P40apbeQBgyCGUr+GRsQnfqZ2R
	 cvvn/KD1Jq0pzkaQxDNCKubxfUlvjbPn+V8KaBlwAkmfYxQfYoFBMTNjbfJTZWWP5rfHI
	 Vt0Q04ImLAL3UZcRyaxGemfMTa0q4xU4J5yhPGMalBJm0QUlhcn7yIgKQTdEvR3+IAxTB
	 +Dx1ESfgpBsFkrp+ywjN/nNdCaavNJj3fId84h9vpCQ0YVFNaUQPes8QvtpSTfaH3Aido
	 q248CaFFNeSHA8pLBWCpfcoZk62M+Uj2XeCzD77yP7Pgi58op3m1AsajEOTkGWX126Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022912;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kbvIdErdAy/ssvp6WLYkfOowJrtyOB26EPQhoDnb+FE=;
	b=oWXmDga31NIuUwVw6Wv14iUvM3kGU0R+GlPZQW7PTDeu7MEFx+LYKNCrLX+uBb4Y2AoS
	 zQ9EZcPAD/4Np9PbsPYBqDDIPlS+17AwqZ+4TCUelyxB1Q3IIkdD+gs2kUCV7gR7Srhfv
	 ZDRFVZc23hNuDaes9ZIoLc0A0S5FV6OyWXLi3Pme9+FX8TkYpYg+QP/Xynz8yyLjd3Ns2
	 t+Ay6+yLzF/7K4G/Doyn1CQHtfYSg435pEVXIWGsn2b5APxXtDS3kkangYPgnGmf8/YXt
	 ahByO56RacTDK5XjpeEjq0ytXEZmukeWt4+FKYvFMHsEDBsZKDvKH1hyjUh36/x7Zig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AdbF74Wr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79190606A755;
	Wed, 18 Nov 2026 17:28:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AdbF74Wr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBA071F000C7;
	Wed, 18 Nov 2026 17:28:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022912;
	bh=kbvIdErdAy/ssvp6WLYkfOowJrtyOB26EPQhoDnb+FE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AdbF74WrYseRJLAf6ugAP3CtYFDiRL4Vyi+4sZy3o5Yz1rURh0ZPr1NJPpbGqXNLr
	 eDtSxp8ib2nhQkfhSbLh7Hr2uLV25EXCa32iP381l1sWgPD4oC2lZaltBcEzuvCVYP
	 1YcHFqlubTI2dq2CRbvDDiv8IA1UtdyoS1gZbWNk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cai Xinchen <caixinchen1@huawei.com>,
	Paul Moore <paul@paul-moore.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0180/2151] lsm: dont call security_backing_file_free() multiple times
Date: Wed, 18 Nov 2026 15:31:55 +0100
Message-ID: <20261118150128.286904901@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Cai Xinchen <caixinchen1@huawei.com>

[ Upstream commit 3a84fc1a21577dbc8da7e4b6a49c9d8b07c07000 ]

I found the following path:

alloc_empty_backing-file
    init_file(&ff->file, xxx)
        -> file_ref_init(&f->f_ref, 1); // only 1
    error = init_backing_file
        -> security_backing_file_alloc
        -> rc = call_int_hook(backing_file_alloc, ...)
           if (unlikely(rc))
           	security_backing_file_free(backing_file); // first call
    if (unlikely(error)) {
        fput(&ff->file);
         -> if (unlikely(file_ref_put(&file->f_ref))) // zero
                __fput_deferred(file);
                 -> ____fput -> __fput -> file_free(file);
                 -> backing_file_free(backing_file(f));
                 -> security_backing_file_free(&ff->file); // second call

Currently, only SELinux has the lsm backing_file_alloc hook, and it always
return 0. When security_backing_file_free is called for the first time,
the blobs pointer is set to NULL. Therefore, double free will not occur in
the code.

Fixes: 6af36aeb147a ("lsm: add backing_file LSM hooks")
Signed-off-by: Cai Xinchen <caixinchen1@huawei.com>
[PM: subject line tweaks]
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/security.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/security/security.c b/security/security.c
index 9285909908ab8..a611a63af574b 100644
--- a/security/security.c
+++ b/security/security.c
@@ -3040,9 +3040,8 @@ void security_backing_file_free(struct file *backing_file)
 {
 	void *blob = backing_file_security(backing_file);
 
-	call_void_hook(backing_file_free, backing_file);
-
 	if (blob) {
+		call_void_hook(backing_file_free, backing_file);
 		backing_file_set_security(backing_file, NULL);
 		kmem_cache_free(lsm_backing_file_cache, blob);
 	}
-- 
2.53.0



