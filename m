Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 605687E0EB;
	Mon,  8 Apr 2024 13:42:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583751; cv=none; b=Oa6/LX+6d+OQhemREBd4D+izkFblaxj0gtdINsI1ac9+IM6jrcWkePya1BLaHQ0NPQH3aCywADw4xHR2dlIh9GVdWVe11ZP89no7InV8D62ABeZ6tjz/U2k6T3qpcBBNVi9h/wPjHCu9ut7HjbOTzjz+bWKNvtzTEIDs2lhEUg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583751; c=relaxed/simple;
	bh=jgbPvQm+Ma66b6n/ICT5idl+ltVfvtiDwhwUSZX4FVw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=axj8iPS6BvfKmmZvnH/2IzvmD7rCR+91vBUVtPYwzlJU5zgP9E4N0Qh5Pq9LnkOgJWJK2Wyr5uaq8noqXZOBZVVhCYrgd3JNth7QR8E+qMgh6uPj1lyWfhM5ZFRzPs2S0cob94OKDCRfWCyA47eevYlVWNqzOb207StMJtPO3Do=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SGhHCIlI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SGhHCIlI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC422C43390;
	Mon,  8 Apr 2024 13:42:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583751;
	bh=jgbPvQm+Ma66b6n/ICT5idl+ltVfvtiDwhwUSZX4FVw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SGhHCIlIfAtz3hpusf1/TEeKyty64hLbyscv+OlORjcoDj1FLCzzlp2qjWMGFAV7o
	 +DZOJk96KbGEJCmNnDvvvrET63Tdq7RDDqfL6Qquf9fNixUW0Gw0pU61EV50XP0HIA
	 aYdnmdSlCaamAFcoMfaOot336cWccQA55ts8t7Sw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 281/690] NFSD: Clean up _lm_ operation names
Date: Mon,  8 Apr 2024 14:52:27 +0200
Message-ID: <20240408125409.780460720@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 35aff0678f99b0623bb72d50112de9e163a19559 ]

The common practice is to name function instances the same as the
method names, but with a uniquifying prefix. Commit aef9583b234a
("NFSD: Get reference of lockowner when coping file_lock") missed
this -- the new function names should both have been of the form
"nfsd4_lm_*".

Before more lock manager operations are added in NFSD, rename these
two functions for consistency.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/nfs4state.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index fc0d7fbe5d4a6..5f3adb59c1ffd 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -6552,7 +6552,7 @@ nfs4_transform_lock_offset(struct file_lock *lock)
 }
 
 static fl_owner_t
-nfsd4_fl_get_owner(fl_owner_t owner)
+nfsd4_lm_get_owner(fl_owner_t owner)
 {
 	struct nfs4_lockowner *lo = (struct nfs4_lockowner *)owner;
 
@@ -6561,7 +6561,7 @@ nfsd4_fl_get_owner(fl_owner_t owner)
 }
 
 static void
-nfsd4_fl_put_owner(fl_owner_t owner)
+nfsd4_lm_put_owner(fl_owner_t owner)
 {
 	struct nfs4_lockowner *lo = (struct nfs4_lockowner *)owner;
 
@@ -6596,8 +6596,8 @@ nfsd4_lm_notify(struct file_lock *fl)
 
 static const struct lock_manager_operations nfsd_posix_mng_ops  = {
 	.lm_notify = nfsd4_lm_notify,
-	.lm_get_owner = nfsd4_fl_get_owner,
-	.lm_put_owner = nfsd4_fl_put_owner,
+	.lm_get_owner = nfsd4_lm_get_owner,
+	.lm_put_owner = nfsd4_lm_put_owner,
 };
 
 static inline void
-- 
2.43.0



