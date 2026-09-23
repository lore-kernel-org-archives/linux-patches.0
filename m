Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6998F3AB291;
	Wed, 23 Sep 2026 14:19:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173151; cv=none; b=ihx6jUSWkQd8a5WWroTLI507ia4QCYX4+qGl2K/l7DtHpGkzFSe189TG+h0LVHheVu0CaICpmoFKlDMimHcyFqTHrcP1q+BFtJENtxquTDMunjSDnPS1YJnOomA5TekVMbWGCWzaCDGZiChUCGqVwp+oARycVzs9Kmf8NVw+p/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173151; c=relaxed/simple;
	bh=gtDRaryAox6WmR9FCzdgcKrrT5iFStfmFmGuqAqN/hI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TyVGzo2Sjov3LV/zy33jNP0fhazX3XoQ1AW9edyCSpRAPBXS8rhelqBAOXkZfN8j+huYRQJy9FlAyl3tyiQlKOaiEnrwzfOiR5Vuc6o3HgqW/sQGsPYj7IquNmDp36Tg9c8mHGlXLVuUpwvnKwDF4Liz7+pSNvJiVtpydEvRlms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UNLPQB0L; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UNLPQB0L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2FDA1F00893;
	Wed, 23 Sep 2026 14:19:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790173150;
	bh=3zQqYA2aB9ECmUgt/UHMrnRIHMvVZWIEN2Mb8NJNcj0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UNLPQB0Lz+iiVUN+YZhA4vv8lmDDubrUJhI/ovUfstxH00Ojl40XyjedyGpDEbQkK
	 jg4rm6ISDija+daWXIWIBj0GPQdUfKdIjE3zq9nuXqjG7HIhedMoSpTkEM04VeitdO
	 GNcRryLDLQ63aMa74Sh4dkYHmIVJaz3g5ALz+13I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Joel Granados <joel.granados@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 157/438] sysctl: Check range in proc_dointvec_ms_jiffies_minmax
Date: Wed, 23 Sep 2026 16:02:58 +0200
Message-ID: <20260923140648.839689781@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuniyuki Iwashima <kuniyu@google.com>

[ Upstream commit 82431877d837a6c2593efd8e66ba28b35a220ca4 ]

Add the range check to do_proc_int_conv_ms_jiffies_minmax that commit
d174174c6776 ("sysctl: replace SYSCTL_INT_CONV_CUSTOM macro with
functions") incorrectly removed.

Fixes: d174174c6776 ("sysctl: replace SYSCTL_INT_CONV_CUSTOM macro with functions")
Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Signed-off-by: Joel Granados <joel.granados@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/time/jiffies.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/time/jiffies.c b/kernel/time/jiffies.c
index d51428867a339..f4c43b9716f89 100644
--- a/kernel/time/jiffies.c
+++ b/kernel/time/jiffies.c
@@ -181,7 +181,7 @@ static int do_proc_int_conv_ms_jiffies_minmax(bool *negp, ulong *u_ptr,
 					      int *k_ptr, int dir,
 					      const struct ctl_table *tbl)
 {
-	return proc_int_conv(negp, u_ptr, k_ptr, dir, tbl, false,
+	return proc_int_conv(negp, u_ptr, k_ptr, dir, tbl, true,
 			     sysctl_u2k_int_conv_ms, sysctl_k2u_int_conv_ms);
 }
 
-- 
2.53.0



