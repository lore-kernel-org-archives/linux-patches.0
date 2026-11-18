Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051586;
	b=mPJIRjM1vWXtInborVkPDN8erw28Ge6bgWVVyz5cXLfccjujYSZWeUvhaKjNICB3DLaC
	 yoj+vAI9/5x4HNDnVD0cqDEDjR3Izauq50s06n3ZSZKvTdcvXfisE724D5kLePJMyXZ9Z
	 pz/y41WZs5fiIQHqCAwn2WhSZ9z/IEovGRK7tzjtMi3Qbiv7fs1LGOGz3ve0K554ZBR1g
	 kLazpdE70PC63//M8L5PnSegI49XLupzMnSuXDK6Ui+3KW3DlUJR8KWQzgDJeDvzVeGWi
	 eghUYC+qNkGqtjwWdlqphSBOEM6ItFk8Bt1vwvryn4ADvDL8nW/uPoeKDD+CpT/Sseg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051586;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dqv3mMA1ZZgGlMJeoVQghieuZJQUSHMHR34V9H3ZCs4=;
	b=fsyGiDV7taKiwiGFMAMCSUi+9Cx5shg8MEtPJ3FHm4LADGNDYuiLNlu91ktK+rO9kihU
	 TWeHDf0mFgU43wwb2I1FsdSYQWIS7UDLgUzOqoa/Ztfy7rPKH8thR1EkOpTZYyTDt8NN4
	 m5d3Fm1/c5wqQuKY71OJIX4JPY5wJPT70acPonmpYmRCoNTMGVlfDlOlRw5HvZo0bQ37X
	 iLb6ifPGZDpXzUUl2aVEi0CX/DMbHdak+DPXhpWW7+cFzRJBHMEgCyHijWqua+REaBchg
	 UvNt++KNl9TqgPa0bemkklfm7Dhdb9r+zZLoOf6jXyPv1K/fVYvr3W6O+MuZbO5MI7A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OWxB8mW1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F1F2606A325;
	Thu, 19 Nov 2026 01:26:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OWxB8mW1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85A6D1F000CF;
	Thu, 19 Nov 2026 01:26:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051586;
	bh=dqv3mMA1ZZgGlMJeoVQghieuZJQUSHMHR34V9H3ZCs4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OWxB8mW1cHErNOoK3tkBB2Q3vqAXT8MDoFrLUb5VXHkmgOF7Wka3lkUgteZkXOFut
	 CU/WPcsPdTARQ9Pbn7KNnznH5xbaVgheCLUFbm8krf1KRSwZ/Jcj0wlLDkfqrRyGii
	 u2xROyX0hUpzo//NrGdvwYGOsnxAG3Fh8WtNNptE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0214/2214] ksmbd: fix SMB2 byte-range lock end offset
Date: Wed, 18 Nov 2026 15:31:30 +0100
Message-ID: <20261118150018.732047173@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
 fs/ksmbd/smb2pdu.c | 44 ++++++++++++++------------------------------
 1 file changed, 14 insertions(+), 30 deletions(-)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index 1f55c1bf69b9f..b7f79ed7a2b00 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -6938,7 +6938,7 @@ static int smb2_set_flock_flags(struct file_lock *flock, int flags)
 }
 
 static struct ksmbd_lock *smb2_lock_init(struct file_lock *flock,
-					 unsigned int cmd, int flags,
+					 unsigned int cmd, int flags, bool zero_len,
 					 struct list_head *lock_list)
 {
 	struct ksmbd_lock *lock;
@@ -6952,8 +6952,7 @@ static struct ksmbd_lock *smb2_lock_init(struct file_lock *flock,
 	lock->start = flock->fl_start;
 	lock->end = flock->fl_end;
 	lock->flags = flags;
-	if (lock->start == lock->end)
-		lock->zero_len = 1;
+	lock->zero_len = zero_len;
 	INIT_LIST_HEAD(&lock->clist);
 	INIT_LIST_HEAD(&lock->flist);
 	INIT_LIST_HEAD(&lock->llist);
@@ -7033,32 +7032,18 @@ int smb2_lock(struct ksmbd_work *work)
 
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
@@ -7074,7 +7059,8 @@ int smb2_lock(struct ksmbd_work *work)
 			}
 		}
 
-		smb_lock = smb2_lock_init(flock, cmd, flags, &lock_list);
+		smb_lock = smb2_lock_init(flock, cmd, flags, !lock_length,
+					   &lock_list);
 		if (!smb_lock) {
 			err = -EINVAL;
 			locks_free_lock(flock);
@@ -7148,7 +7134,7 @@ int smb2_lock(struct ksmbd_work *work)
 				/* check zero byte lock range */
 				if (cmp_lock->zero_len && !smb_lock->zero_len &&
 				    cmp_lock->start > smb_lock->start &&
-				    cmp_lock->start < smb_lock->end) {
+				    cmp_lock->start <= smb_lock->end) {
 					spin_unlock(&conn->llist_lock);
 					up_read(&conn_list_lock);
 					pr_err("previous lock conflict with zero byte lock range\n");
@@ -7157,17 +7143,15 @@ int smb2_lock(struct ksmbd_work *work)
 
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



