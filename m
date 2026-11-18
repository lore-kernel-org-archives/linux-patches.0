Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028959;
	b=YKkm7sJTrXQPPCA7694J6FKnwoogfoefF3At0ZOtV61Q9f5vqKV21pCO5EgzY5dI0m0B
	 z+mk5fyR917mqRSKQfoVwkrdm3dqPs+BeRHUyX3QPvXIZ2YLebRryfSFgbeq9VKXuupUj
	 Db5VwtKc/YspwotMCaIUAUeR3YJ625Ix0FLrpx35+kxrvJestWDnhjlx7aIjegDU/FdXC
	 2LrlbDsHNJ/xHEdEEKOp2mANCmwv5J2pY7KCzjYnczjDgZ1Hbxv4NybG/IfBwPxS3ZmNB
	 NKjTTsdHnddVhaKFhXVp3V6NJuC/d/LiQq6xK4dVSST22LyzZTW7zDd5l84u4S/QMjw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028959;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vBYrCUoi4AIGEbNxT+dW+Ae66Qt7BqWErkwHwj/sKBU=;
	b=1ju0viDfjj/xKHc/ttmvs+O4RMUqHvEb8WOHYrorGFRC2tXg+RJppqDZ6cpnbVPKjNCA
	 D+5RvrqekGHBd0YMLQfiWxO2ps3eTIFyrfQxR2/a0mAjmjP00zzraGTYFN2dGRMRfDG5Q
	 cdQ8BFsqhKOuyZ8mAvWL+7yLi4LrZx/Jefq9xezGbYPL+cFP+SvBZGN/zLIMSiusnCqLF
	 Sc/wbc0nI6n9ndYGpNanQBYtTe1ZnCLz4Ju4rFwYCf9VmuZ3NavbzCix9Pcv4V/DEAMSI
	 TA1o4PJfWOJ++ON33SorzsUwkoUS/6SwuwadxBOtel3ZgOdtNp+1n/FxMVRNgAitcxQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bgR6LTqQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C897606A339;
	Wed, 18 Nov 2026 19:09:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bgR6LTqQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE9001F000C4;
	Wed, 18 Nov 2026 19:09:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028959;
	bh=vBYrCUoi4AIGEbNxT+dW+Ae66Qt7BqWErkwHwj/sKBU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bgR6LTqQHubTizNew0SjGE2BsrcnebwL1O+aYZRdBFfAFhxcDi7iGHEFJg2CpdRLW
	 NcxOff4D9AKpdZAhbwZdBXXO7qiWul3/fOTDZJMgLL9YXzwqEw9bhaegqW4EYRLT38
	 pKyqV/IfOuYd+QYDS91fW+2ofkHNjMtL3zf2dnDY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cai Xinchen <caixinchen1@huawei.com>,
	Paul Moore <paul@paul-moore.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0180/1756] lsm: dont call security_backing_file_free() multiple times
Date: Wed, 18 Nov 2026 15:38:27 +0100
Message-ID: <20261118150015.601101986@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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
index b31fd25f4e5e3..8e11b0793b8fc 100644
--- a/security/security.c
+++ b/security/security.c
@@ -2967,9 +2967,8 @@ void security_backing_file_free(struct file *backing_file)
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



