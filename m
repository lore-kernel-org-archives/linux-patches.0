Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E25D7251793;
	Wed, 25 Feb 2026 01:28:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771982928; cv=none; b=JEXRafeYjOWagJ5V4VwFGRvSjZcA2GKcUbhUJV5ONwVIMluyGuruDr9kIccCVoIbdk5UM18Ekiktt0eUy7+5MPigknqgaRMPipfO5qIUXPkWdVjz0vqTiBojrv+cwf0wYzi9yQcW92AFrNphYRoFGWasD1+gJ06spk6KoaxuL/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771982928; c=relaxed/simple;
	bh=lL+oelOPQjN606oL2/XeQXmRuAM+f+MqQWJ1Jk53Nw4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f8PC0joPPImoPsIxXewwzzKEEVcoSgoPTwEyEexxrAiY9AaKuRn4+FShy3gJGIPzy8/3T5wCVVgFoKq+EGqUUYg4q6Sw86+lAQD+ujuTsxHLpGfDSjUIckwujOrKyIm05irFrfZF2Im3OoLkNYqRlkMMeKENg+LnHQ3ouxRoCyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xlFDyjn5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xlFDyjn5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACDBEC116D0;
	Wed, 25 Feb 2026 01:28:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771982927;
	bh=lL+oelOPQjN606oL2/XeQXmRuAM+f+MqQWJ1Jk53Nw4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xlFDyjn5Mc0edWvWDlrFrUZcXHqC3urYlU+7rd8pk4ygiXg2USX6aEjEpnPCjB2Un
	 oGicaDlArr8iLcP2djOxFzf2C4y9fpWxsy+P4kogqUG97x4zE58ye/T11FuNfRj0Mg
	 QooRe/Nxzd1tkAS2m36MqKMpqkuIT3uMFZL7uQeI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 105/781] seqlock: fix scoped_seqlock_read kernel-doc
Date: Tue, 24 Feb 2026 17:13:34 -0800
Message-ID: <20260225012402.260503129@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit f88a31308db6a856229150039b0f56d59696ed31 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/seqlock.h | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/include/linux/seqlock.h b/include/linux/seqlock.h
index 221123660e710..f827cc3cb1460 100644
--- a/include/linux/seqlock.h
+++ b/include/linux/seqlock.h
@@ -1303,15 +1303,14 @@ __scoped_seqlock_next(struct ss_tmp *sst, seqlock_t *lock, enum ss_state target)
 	     __scoped_seqlock_next(&_s, _seqlock, _target))
 
 /**
- * scoped_seqlock_read (lock, ss_state) - execute the read side critical
- *                                        section without manual sequence
- *                                        counter handling or calls to other
- *                                        helpers
- * @lock: pointer to seqlock_t protecting the data
- * @ss_state: one of {ss_lock, ss_lock_irqsave, ss_lockless} indicating
- *            the type of critical read section
- *
- * Example:
+ * scoped_seqlock_read() - execute the read-side critical section
+ *                         without manual sequence counter handling
+ *                         or calls to other helpers
+ * @_seqlock: pointer to seqlock_t protecting the data
+ * @_target: an enum ss_state: one of {ss_lock, ss_lock_irqsave, ss_lockless}
+ *           indicating the type of critical read section
+ *
+ * Example::
  *
  *     scoped_seqlock_read (&lock, ss_lock) {
  *         // read-side critical section
-- 
2.51.0



