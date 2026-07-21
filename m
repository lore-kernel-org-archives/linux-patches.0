Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3150471417;
	Tue, 21 Jul 2026 20:10:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664650; cv=none; b=I1GlB2boAS3MlijQ/SWvgwPkXLSAyuUyKG0nn94RSTlIUs/ig762kwzbdNIwmu8fTAY0lruDOdvxDSIAh72d9YTbgfzJZn3coBy+hOcR4AFwxH6swuIcDBrmJ89yUOXVUuHCsNoGq4fqXi2Q3oaTXC2TXMtj4Y1Kkx4OUfPsqw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664650; c=relaxed/simple;
	bh=fTH+4eCDezAAh+wjjIkO3IWxWZVCiWlckFIminZvdwg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ftRmlTkvucE0AAYil1TIJxZakZwcgTRvh2i2H04AIIE/v3pQarsePR5csFPQwof6Qi/x+K1N10DnQyijLlKkPpd74fbKOH9/1L06DCRBxNsNjelO/P2cUJfuCJdlmlUV7xsArciJxj/N9qYbJWNceHkH+UQzs6TnR6E8TZ1F6hI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NTCgmJ7Q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NTCgmJ7Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AFA11F000E9;
	Tue, 21 Jul 2026 20:10:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664648;
	bh=20HuPbtlx1xlrPoO+AfLNDVEmw4d3PCZCg1rjRIRy9s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NTCgmJ7QmryYfz6TJiT2FTILTsNZ49wr/tTaMF5+g9KYGioGYZb3qoA1+viKo1kKG
	 z1v6jLLrLvQu4K++u43+MWFzmyNmlcuvjOnBT7g3oehwF3VBdWIq2vJFmbDtYkLgvy
	 PUqJ++PtvS1+61XZOz4eaAtv4512qtjYG112hxJs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 6.12 1250/1276] seqlock: fix scoped_seqlock_read kernel-doc
Date: Tue, 21 Jul 2026 17:28:13 +0200
Message-ID: <20260721152514.068382234@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Randy Dunlap <rdunlap@infradead.org>

commit f88a31308db6a856229150039b0f56d59696ed31 upstream.

Eliminate all kernel-doc warnings in seqlock.h:

- correct the macro to have "()" immediately following the macro name
- don't include the macro parameters in the short description (first line)
- make the parameter names in the comments match the actual macro
  parameter names.
- use "::" for the Example

WARNING: include/linux/seqlock.h:1341 This comment starts with '/**', but isn't a kernel-doc comment.
 * scoped_seqlock_read (lock, ss_state) - execute the read side critical
Documentation/locking/seqlock:242: include/linux/seqlock.h:1351: WARNING:
  Definition list ends without a blank line; unexpected unindent. [docutils]
Warning: include/linux/seqlock.h:1357 function parameter '_seqlock' not described in 'scoped_seqlock_read'
Warning: include/linux/seqlock.h:1357 function parameter '_target' not described in 'scoped_seqlock_read'

Fixes: cc39f3872c08 ("seqlock: Introduce scoped_seqlock_read()")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://patch.msgid.link/20260123183749.3997533-1-rdunlap@infradead.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/seqlock.h |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

--- a/include/linux/seqlock.h
+++ b/include/linux/seqlock.h
@@ -1277,15 +1277,14 @@ __scoped_seqlock_next(struct ss_tmp *sst
 	     __scoped_seqlock_next(&_s, _seqlock, _target))
 
 /**
- * scoped_seqlock_read (lock, ss_state) - execute the read side critical
- *                                        section without manual sequence
- *                                        counter handling or calls to other
- *                                        helpers
- * @lock: pointer to seqlock_t protecting the data
- * @ss_state: one of {ss_lock, ss_lock_irqsave, ss_lockless} indicating
- *            the type of critical read section
+ * scoped_seqlock_read() - execute the read-side critical section
+ *                         without manual sequence counter handling
+ *                         or calls to other helpers
+ * @_seqlock: pointer to seqlock_t protecting the data
+ * @_target: an enum ss_state: one of {ss_lock, ss_lock_irqsave, ss_lockless}
+ *           indicating the type of critical read section
  *
- * Example:
+ * Example::
  *
  *     scoped_seqlock_read (&lock, ss_lock) {
  *         // read-side critical section


