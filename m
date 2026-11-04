Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793830949;
	b=I/hmoUQz1OQUvTOs8CjN6sfDKq7iISM0Pe/cAEGmNc5MKsujLbkPR+8z3K0Z3Gg0q8l2
	 3gVxcuMftGLDOUBrlJZFQDjLPYKL3wsX/RB6Q2vyB8Dq8iCeRVRO01btgauah+l0dlOpU
	 0TElUwuEL1momhImi/9zfVDS7cF8iK39zpWaQrYvFPRIGkeB1jwzv8BcaPJkBMKJydu2N
	 8z8+sprytonBYdGsYGhH0NgB2LqMFXz4HAlvGAwd2MS94/PTtuoNsgdY0iurBR3jmoitE
	 KA8ZvWUXf2XrDOi5H/gtWzgfY9OSJow7HuzhRbabsWarurtiF3Euu5uKLSv1uaBDhTw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793830949;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7DpTd6eC5N5hl22DUOzPNYYIGND9aZXj5cWTgi20JbQ=;
	b=gonOIJoAR6h1izmqnPWzm2zm42lsF//UHbSj1ikSkh6jFAHh1lSZZHq9qM+2kK9tojM4
	 /rNDvHpoaTyMcHHMynlOfTji5/FzBogi+xW8uFGlFatmAS5ec/+G+SeT67dPJ57EvvQ0x
	 GH+s5Gt/8j+mTxmYI/q7nlz8EZHlSG1UC0y8bg904lnWcYPwQmQXBHJFNCOrJZWNlnCkj
	 wNXwJ713tOv9FTZi45crVKxmkh/G2L7o9pu+HH5VYh4Eeft2a4ExGarUQak1qcCClikwb
	 n1CmpCK5vRWVOwNlhVxqJQTjXc46iHU5m0OTjdLIbyhA/tinJmtrxKpPcJKe6Rxr5QQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Si6Dd+MZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21B60606A844;
	Wed,  4 Nov 2026 22:22:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Si6Dd+MZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77C171F000C1;
	Wed,  4 Nov 2026 22:22:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793830948;
	bh=7DpTd6eC5N5hl22DUOzPNYYIGND9aZXj5cWTgi20JbQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Si6Dd+MZkE8+db2b7UpcMz4w0IyKWHwVfJDLAhIKVx9tg4X3jipsNGYHmBuY/JVVd
	 3g6DwmLcMqvpGFQvuF6Log4b6W7fZu4fjLGmVdBSwzgB9SGf6mLMQ9YUMd1kL1WDUG
	 Blyhd2QpvKPUxMLbt3jRwy88R84GAlHftAoZYoUY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0417/1005] ksmbd: fix SMB2 byte-range lock end offset
Date: Wed,  4 Nov 2026 16:02:30 -0500
Message-ID: <20261104211055.774253694@linuxfoundation.org>
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

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 54d90311f9b4eb23f3b0b62650b0cfddb11a12ef ]

SMB2 describes a byte-range lock using an offset and a length, while
Linux file_lock uses an inclusive end offset. smb2_lock() currently sets
fl_end to start + length and consequently locks one extra byte for every
nonzero-length request.

Translate nonzero lengths to start + length - 1 and reject ranges that
cannot be represented by loff_t instead of silently truncating them at
OFFSET_MAX. Track zero-length locks from the request length so one-byte
ranges are not mistaken for zero-length locks after endpoint conversion.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2pdu.c | 44 +++++++++++++----------------------------
 1 file changed, 14 insertions(+), 30 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 16dea2c8b9267..fba9c75b9f878 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -7609,7 +7609,7 @@ static int smb2_set_flock_flags(struct file_lock *flock, int flags)
 }
 
 static struct ksmbd_lock *smb2_lock_init(struct file_lock *flock,
-					 unsigned int cmd, int flags,
+					 unsigned int cmd, int flags, bool zero_len,
 					 struct list_head *lock_list)
 {
 	struct ksmbd_lock *lock;
@@ -7623,8 +7623,7 @@ static struct ksmbd_lock *smb2_lock_init(struct file_lock *flock,
 	lock->start = flock->fl_start;
 	lock->end = flock->fl_end;
 	lock->flags = flags;
-	if (lock->start == lock->end)
-		lock->zero_len = 1;
+	lock->zero_len = zero_len;
 	INIT_LIST_HEAD(&lock->clist);
 	INIT_LIST_HEAD(&lock->flist);
 	INIT_LIST_HEAD(&lock->llist);
@@ -7717,32 +7716,18 @@ int smb2_lock(struct ksmbd_work *work)
 
 		lock_start = le64_to_cpu(lock_ele[i].Offset);
 		lock_length = le64_to_cpu(lock_ele[i].Length);
-		if (lock_start > U64_MAX - lock_length) {
+		if (lock_start > OFFSET_MAX ||
+		    (lock_length &&
+		     lock_length - 1 > OFFSET_MAX - lock_start)) {
 			pr_err("Invalid lock range requested\n");
 			rsp->hdr.Status = STATUS_INVALID_LOCK_RANGE;
 			locks_free_lock(flock);
 			goto out;
 		}
 
-		if (lock_start > OFFSET_MAX)
-			flock->fl_start = OFFSET_MAX;
-		else
-			flock->fl_start = lock_start;
-
-		lock_length = le64_to_cpu(lock_ele[i].Length);
-		if (lock_length > OFFSET_MAX - flock->fl_start)
-			lock_length = OFFSET_MAX - flock->fl_start;
-
-		flock->fl_end = flock->fl_start + lock_length;
-
-		if (flock->fl_end < flock->fl_start) {
-			ksmbd_debug(SMB,
-				    "the end offset(%llx) is smaller than the start offset(%llx)\n",
-				    flock->fl_end, flock->fl_start);
-			rsp->hdr.Status = STATUS_INVALID_LOCK_RANGE;
-			locks_free_lock(flock);
-			goto out;
-		}
+		flock->fl_start = lock_start;
+		flock->fl_end = lock_length ?
+			flock->fl_start + lock_length - 1 : flock->fl_start;
 
 		/* Check conflict locks in one request */
 		list_for_each_entry(cmp_lock, &lock_list, llist) {
@@ -7758,7 +7743,8 @@ int smb2_lock(struct ksmbd_work *work)
 			}
 		}
 
-		smb_lock = smb2_lock_init(flock, cmd, flags, &lock_list);
+		smb_lock = smb2_lock_init(flock, cmd, flags, !lock_length,
+					   &lock_list);
 		if (!smb_lock) {
 			err = -EINVAL;
 			locks_free_lock(flock);
@@ -7832,7 +7818,7 @@ int smb2_lock(struct ksmbd_work *work)
 				/* check zero byte lock range */
 				if (cmp_lock->zero_len && !smb_lock->zero_len &&
 				    cmp_lock->start > smb_lock->start &&
-				    cmp_lock->start < smb_lock->end) {
+				    cmp_lock->start <= smb_lock->end) {
 					spin_unlock(&conn->llist_lock);
 					up_read(&conn_list_lock);
 					pr_err("previous lock conflict with zero byte lock range\n");
@@ -7841,17 +7827,15 @@ int smb2_lock(struct ksmbd_work *work)
 
 				if (smb_lock->zero_len && !cmp_lock->zero_len &&
 				    smb_lock->start > cmp_lock->start &&
-				    smb_lock->start < cmp_lock->end) {
+				    smb_lock->start <= cmp_lock->end) {
 					spin_unlock(&conn->llist_lock);
 					up_read(&conn_list_lock);
 					pr_err("current lock conflict with zero byte lock range\n");
 					goto out;
 				}
 
-				if (((cmp_lock->start <= smb_lock->start &&
-				      cmp_lock->end > smb_lock->start) ||
-				     (cmp_lock->start < smb_lock->end &&
-				      cmp_lock->end >= smb_lock->end)) &&
+				if (cmp_lock->start <= smb_lock->end &&
+				    smb_lock->start <= cmp_lock->end &&
 				    !cmp_lock->zero_len && !smb_lock->zero_len) {
 					spin_unlock(&conn->llist_lock);
 					up_read(&conn_list_lock);
-- 
2.53.0



