Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015331;
	b=niDl15eXl5XNLWeAUDFHuw77exCLwewy9NIN13b7dhFZ5DsCXSjPGD8CoFnhYZMj1aUN
	 RnQT0XFZo+nT7beyQox/5ilcUVI4kZ0i08/8JiaYVXlz0NxPmW1g3u9fu/l5RSEDwaU1b
	 V/wefO2/W7Q9r8IDt9ArY1Z75sJXytTMh0sSjt9T8jxx/v+UQNNj3j44ZvoLEg4pNerXh
	 FC/hXU0fA/WZo0r7Oiqy5I6Dpi37+HveaTzC4K33ZCXXJLbV0ldZ/WB9s9Vq4ceIJceiy
	 LwBgHUzl+UepSmVAULSfhapwnrB2wlAUmFY7ULTSqGG6oH8jUtQ4+LhgnuEYi1B6pTw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015331;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1dup64gc5cVj7itHy4U3xq2oeQumef1ge/WnCUAbrfk=;
	b=SgoE0Kqqi8ZWaL0+bqdfjAIYFmEOgniD8GLvqgiaxIOwVa2sLpsyNLDCQY5aa/4m0MDL
	 8Dr1xysYq2kuexG7d7eOND4fr0xapu1b0ss7oMqee0cECzCwtwlI5XziNZibmKKaduUzO
	 jxAyeUs0RCx/ybwrD+M+nsq6KoKV5Crk9NEI5MGrA4G0FgeTxETFSeMW9To4FAVtFgl9u
	 TUxJqhGVjHiR6zTZwj+m4N3YlwxMfR00eS/pbXbhSHpGMMnYVUl7dgNJtUonisoaA83RH
	 k5eg1dwZRvkOH896VQY8eOkQrpIGbTCoAZC3cYgAsIBYLnC0QYcVyZt5x1XU2sIiwMQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VlMhRZv+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4951E606A325;
	Wed, 18 Nov 2026 15:22:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VlMhRZv+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 563511F000C4;
	Wed, 18 Nov 2026 15:22:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015330;
	bh=1dup64gc5cVj7itHy4U3xq2oeQumef1ge/WnCUAbrfk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VlMhRZv+9GjDCnrpangYrrI1r1030QB4xOIXuVsl+UcPQtoc67FkS7bAjvtDmVrEL
	 79Zvg+6AufSl1Thekegi/nMiG7p/fD7gkOI+pbMmwxMvsgGli7t3f82PSBo+vD/RCt
	 OAdyAjffwpfM/iCzWaS1NeMvedwjLCa5mLjJNuk4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cai Xinchen <caixinchen1@huawei.com>,
	Paul Moore <paul@paul-moore.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0135/2651] lsm: dont call security_backing_file_free() multiple times
Date: Wed, 18 Nov 2026 15:22:55 +0100
Message-ID: <20261118150252.714166867@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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
index 2ee276ab15c5b..208738238e37f 100644
--- a/security/security.c
+++ b/security/security.c
@@ -2486,9 +2486,8 @@ void security_backing_file_free(struct file *backing_file)
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



