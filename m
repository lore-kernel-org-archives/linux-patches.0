Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061008;
	b=xvuHrIlG9RAQdA9qlmhz3vggL+P31z5m8OdZM4VRto7dWk+kXuJqOBxVCTgB5yPMIRH8
	 iCWJG77Jamm5rNKJ2lGlIYX5yAdDHfmL4kBczL6cEl2AMM9OHLLbcV6Mb32lLlSQ94fp5
	 JBj75FcoT1PAoKIlmjNU2ZRK1pBD19RvohtSI8elrYlNzYs1SDKYluJqwvJ0VCq3DSBuY
	 FL1bAi9eXfOZ1dC9Kw/ldcH3yxLrn60ZC0werTzjkp1LrwEQ50sMMaZyc+PoWZ3GKL5+c
	 TqFJ6jzeTnMSFJuOymmXXyF8yWZDsDVBBzLZBQH50xEGQULxTjihISR/+8J8loLVt4Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061008;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=j9xmWbZ5+jRLC4PsRcNBEo7C4v3GeqygFqyaE6VxZFs=;
	b=J6r1oqiSdrVEA9AV3lKzEj/ueYZ9WalQF+UgU1dzDENKU+28vNNNgX208Bj5jsEsFnWB
	 mqoDYT0+eU37l6gyXl7gMdebs0tD6hMQ/qF/uahohvx2zQYBOPhxYW3MvG1tEIODY5pwC
	 AU2iDvkQCvrRQYSXoEFnQimJWo7uLvLTyBvSoDdyIgkIST8V2OMj7S3GsOTm6csjLmMpr
	 xApJA0Fzopnoffg+ewDhZFYbCgn3B4GZ3sd+UPvl8nSk99al9LGeSX9vL6XHsRvH4gotX
	 ECJrOBUIfKK3KF3KBkDrnxb5My8uZoXMAiBxOh5oZB3oAF0iX9F8PH1XkojKb67Cd0A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NjTmbuby;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3198606D80E;
	Sat,  7 Nov 2026 14:16:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NjTmbuby
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B5361F008A2;
	Sat,  7 Nov 2026 14:16:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061007;
	bh=j9xmWbZ5+jRLC4PsRcNBEo7C4v3GeqygFqyaE6VxZFs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NjTmbubyZqW7OPjonvFbA7TgvM51rqN5Cw3h/7c6AnQi3r/hFAfl8KCzPSWtXUqG2
	 FIpJIOpUK2HAdBdkeNbSnlpzhYWg1t9lVFo5F1GvQygiP+U1Ld56V+BIshMdSF8zLx
	 hvxHVdIoJ8WhzyGrKNmBw62S+JGxBUsplIDAOjOI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0351/1536] ksmbd: fix SMB2 byte-range lock end offset
Date: Sat,  7 Nov 2026 08:39:27 -0500
Message-ID: <20261107135007.530058877@linuxfoundation.org>
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
index 1df6c8a20b458..5cee1fbdf8af5 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -7569,7 +7569,7 @@ static int smb2_set_flock_flags(struct file_lock *flock, int flags)
 }
 
 static struct ksmbd_lock *smb2_lock_init(struct file_lock *flock,
-					 unsigned int cmd, int flags,
+					 unsigned int cmd, int flags, bool zero_len,
 					 struct list_head *lock_list)
 {
 	struct ksmbd_lock *lock;
@@ -7583,8 +7583,7 @@ static struct ksmbd_lock *smb2_lock_init(struct file_lock *flock,
 	lock->start = flock->fl_start;
 	lock->end = flock->fl_end;
 	lock->flags = flags;
-	if (lock->start == lock->end)
-		lock->zero_len = 1;
+	lock->zero_len = zero_len;
 	INIT_LIST_HEAD(&lock->clist);
 	INIT_LIST_HEAD(&lock->flist);
 	INIT_LIST_HEAD(&lock->llist);
@@ -7670,32 +7669,18 @@ int smb2_lock(struct ksmbd_work *work)
 
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
@@ -7711,7 +7696,8 @@ int smb2_lock(struct ksmbd_work *work)
 			}
 		}
 
-		smb_lock = smb2_lock_init(flock, cmd, flags, &lock_list);
+		smb_lock = smb2_lock_init(flock, cmd, flags, !lock_length,
+					   &lock_list);
 		if (!smb_lock) {
 			err = -EINVAL;
 			locks_free_lock(flock);
@@ -7785,7 +7771,7 @@ int smb2_lock(struct ksmbd_work *work)
 				/* check zero byte lock range */
 				if (cmp_lock->zero_len && !smb_lock->zero_len &&
 				    cmp_lock->start > smb_lock->start &&
-				    cmp_lock->start < smb_lock->end) {
+				    cmp_lock->start <= smb_lock->end) {
 					spin_unlock(&conn->llist_lock);
 					up_read(&conn_list_lock);
 					pr_err("previous lock conflict with zero byte lock range\n");
@@ -7794,17 +7780,15 @@ int smb2_lock(struct ksmbd_work *work)
 
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



