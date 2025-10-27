Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAFC6304BD3;
	Mon, 27 Oct 2025 19:23:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592991; cv=none; b=pEsY1wMpsi2084ZCLRa5DMyGzNlpeMETJqUr2EidH6Jubw2L1hQ7E8V9kKdNdJkJBcHg8xY0xC3XQk9BmROeVxrhOmeARIg0pgible5XgReLSQYA65zF+uMJHwhMka/enKf3fSL+JAouHCnrM83k0rWMDU+61K9lLP8Q1tj5a5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592991; c=relaxed/simple;
	bh=THiRIQoHt0UbS1XgfdZqNN1+GdX9sH1Gtw6czyjDlIg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IDBU7NZHWOvMYx/azIarEFgfhJmPRR/6rZEGGPU/f844OiccQf63T3jx2ilx9Y46Jh5ioNOdgy2dXy2vTrC9GgGiGmIZbVEWlXYnz/els724yrzGsET8Zec3OsxAkC1s5GAm+TIo8PtjQfnc3KIGoFIeiBlef3tlsuM/L0FUU8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HOuzuOv/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HOuzuOv/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4E70C4CEF1;
	Mon, 27 Oct 2025 19:23:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592991;
	bh=THiRIQoHt0UbS1XgfdZqNN1+GdX9sH1Gtw6czyjDlIg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HOuzuOv/B0aFA+1/Nm89Wp0myx4nONhxGrvBWuSrC6m4DgqOum2VxKoheRF0MBvuV
	 YRqEhgA4/D5HpaBbhpG8Z/pRrjME4r4hw173kiWxnB1DAJN5gkYArl184nuE8OaJyF
	 FmTGqg9WLKT6C8aW8r4Z3bDhLlPfJn8itqdBGCAc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Breno Leitao <leitao@debian.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 089/117] sched: Remove never used code in mm_cid_get()
Date: Mon, 27 Oct 2025 19:36:55 +0100
Message-ID: <20251027183456.432711613@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183453.919157109@linuxfoundation.org>
References: <20251027183453.919157109@linuxfoundation.org>
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

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 53abe3e1c154628cc74e33a1bfcd865656e433a5 ]

Clang is not happy with set but unused variable (this is visible
with `make W=1` build:

  kernel/sched/sched.h:3744:18: error: variable 'cpumask' set but not used [-Werror,-Wunused-but-set-variable]

It seems like the variable was never used along with the assignment
that does not have side effects as far as I can see.  Remove those
altogether.

Fixes: 223baf9d17f2 ("sched: Fix performance regression introduced by mm_cid")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Tested-by: Eric Biggers <ebiggers@kernel.org>
Reviewed-by: Breno Leitao <leitao@debian.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/sched.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index a441990fe808d..cf541c4502d92 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -3731,11 +3731,9 @@ static inline int __mm_cid_get(struct rq *rq, struct mm_struct *mm)
 static inline int mm_cid_get(struct rq *rq, struct mm_struct *mm)
 {
 	struct mm_cid __percpu *pcpu_cid = mm->pcpu_cid;
-	struct cpumask *cpumask;
 	int cid;
 
 	lockdep_assert_rq_held(rq);
-	cpumask = mm_cidmask(mm);
 	cid = __this_cpu_read(pcpu_cid->cid);
 	if (mm_cid_is_valid(cid)) {
 		mm_cid_snapshot_time(rq, mm);
-- 
2.51.0



