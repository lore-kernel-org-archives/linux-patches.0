Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90BA635CEAE;
	Tue, 26 Aug 2025 14:37:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756219021; cv=none; b=fogbeMmJwXK7sDKETev7OP8SD7wz4zMPD8RPSb53vrn31TeZ7Yns75gbR5DltI0w412WUuwqBK+ufWpN5nsouJamOa7jOEgcx5b+hZeGaHA3O4sC23ytGjdhlD2p3+4Hl1Q2uV4sDrtxgWk4XqdgKUY2OOSChJ+k+FZYoqXCVWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756219021; c=relaxed/simple;
	bh=oK36NFpHeyxaunZQXEsG4sGoUHw+NWB5E7mowQ8a1HM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K/96U1eaqTMSQR/9s3+SjRd47TTX+VZlaKpm/dMNRUnkvJAcxWTGx7wWEm91Ez5Bn4gKHB9gYHJyYrNWedQdW0SEoy31gTeiGO3llneU6OA3B7raIFYZpbkEE+l61NsWF1wSwyzEL5nY6PUMfo3NTSibiJe4Lr5786X6UNz9XkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eskpNStI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eskpNStI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21A32C4CEF1;
	Tue, 26 Aug 2025 14:37:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756219021;
	bh=oK36NFpHeyxaunZQXEsG4sGoUHw+NWB5E7mowQ8a1HM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eskpNStIQ1l6x0a2gzxR0pGMsEn9QmI6gF1Rx/ILnVjkfULeSoRsqSFRmK9SqWZXA
	 OPa7vQfT1uucVresAYnbE+39bJ7luIx8GCdKjqtyySFKgilkEmjKP2Wgl5Him49ymC
	 6CU3ZeQzEd0KETGsrDK0o6Ji7dWLDEFsIdL0P5bE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 191/403] selftests: tracing: Use mutex_unlock for testing glob filter
Date: Tue, 26 Aug 2025 13:08:37 +0200
Message-ID: <20250826110912.149805031@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Masami Hiramatsu (Google) <mhiramat@kernel.org>

[ Upstream commit a089bb2822a49b0c5777a8936f82c1f8629231fb ]

Since commit c5b6ababd21a ("locking/mutex: implement
mutex_trylock_nested") makes mutex_trylock() as an inlined
function if CONFIG_DEBUG_LOCK_ALLOC=y, we can not use
mutex_trylock() for testing the glob filter of ftrace.

Use mutex_unlock instead.

Link: https://lore.kernel.org/r/175151680309.2149615.9795104805153538717.stgit@mhiramat.tok.corp.google.com
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Acked-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../testing/selftests/ftrace/test.d/ftrace/func-filter-glob.tc  | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/ftrace/test.d/ftrace/func-filter-glob.tc b/tools/testing/selftests/ftrace/test.d/ftrace/func-filter-glob.tc
index f4e92afab14b..9a7b7c62cbd9 100644
--- a/tools/testing/selftests/ftrace/test.d/ftrace/func-filter-glob.tc
+++ b/tools/testing/selftests/ftrace/test.d/ftrace/func-filter-glob.tc
@@ -33,7 +33,7 @@ ftrace_filter_check 'schedule*' '^schedule.*$'
 ftrace_filter_check '*pin*lock' '.*pin.*lock$'
 
 # filter by start*mid*
-ftrace_filter_check 'mutex*try*' '^mutex.*try.*'
+ftrace_filter_check 'mutex*unl*' '^mutex.*unl.*'
 
 # Advanced full-glob matching feature is recently supported.
 # Skip the tests if we are sure the kernel does not support it.
-- 
2.39.5



