Received: from out198-175.us.a.mail.aliyun.com (out198-175.us.a.mail.aliyun.com [47.90.198.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 911DD4BEE57
	for <patches@lists.linux.dev>; Sun, 13 Sep 2026 01:58:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=47.90.198.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789264697; cv=none; b=l2U94XGjVWYirjkTYQTyJiDrQ7R5COmiuFLUauSZb0V4834DRWwTv3eu6fQ54hIoGrmYOobDi5Q9xkz3ZHbZBXjoTN5xP2Bks/pugqScBlWNHr5Gn7lSMneJ1wddyJx4T5DpSYLYyi9U0FhT9f2ph5EfQeXQxw/S5sdACGBKTco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789264697; c=relaxed/simple;
	bh=b7WY0ahVn/aE/5FGCh46x1pEbKQLLTPOFjFRjZxGpQ8=;
	h=Date:From:To:Subject:Cc:In-Reply-To:References:Message-Id:
	 MIME-Version:Content-Type; b=TbvqwgbXA8f7NoNmH+ZFly6sUNWjP8qJspmKLasDFtfL+Flsz0E2sgx7OPZdghM5O3HxIP6YntPWiuZFv/w8VLME89N+D7jXDbu2Jd4CqzhRXkWTOUHmkm7Rnqny5PbZ8LjYLH245uNiJCalcptAn95emfk7UUbLHObXpBfm1z0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=e16-tech.com; spf=pass smtp.mailfrom=e16-tech.com; arc=none smtp.client-ip=47.90.198.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=e16-tech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=e16-tech.com
X-Alimail-AntiSpam:AC=CONTINUE;BC=0.04675983|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_social|0.00318378-2.85123e-05-0.996788;FP=16853340347964188643|0|0|0|0|-1|-1|-1;HT=maildocker-contentspam033032062159;MF=wangyugui@e16-tech.com;NM=1;PH=DS;RN=14;RT=14;SR=0;TI=SMTPD_---.jCJT4pX_1789261007;
Received: from 192.168.2.112(mailfrom:wangyugui@e16-tech.com fp:SMTPD_---.jCJT4pX_1789261007 cluster:ay29)
          by smtp.aliyun-inc.com;
          Sun, 13 Sep 2026 08:56:49 +0800
Date: Sun, 13 Sep 2026 08:56:49 +0800
From: Wang Yugui <wangyugui@e16-tech.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 6.18 0908/1518] perf c2c: Use perf_env e_machine rather than arch
Cc: stable@vger.kernel.org,
 patches@lists.linux.dev,
 Ian Rogers <irogers@google.com>,
 Namhyung Kim <namhyung@kernel.org>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Heiko Carstens <hca@linux.ibm.com>,
 Honglei Wang <jameshongleiwang@126.com>,
 Jan Polensky <japo@linux.ibm.com>,
 Sumanth Korikkar <sumanthk@linux.ibm.com>,
 Thomas Richter <tmricht@linux.ibm.com>,
 Vasily Gorbik <gor@linux.ibm.com>,
 Arnaldo Carvalho de Melo <acme@redhat.com>,
 Sasha Levin <sashal@kernel.org>
In-Reply-To: <20260912065643.993908175@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org> <20260912065643.993908175@linuxfoundation.org>
Message-Id: <20260913085648.B79E.409509F4@e16-tech.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.83.03 [en]

Hi,

> 6.18-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Ian Rogers <irogers@google.com>
> 
> [ Upstream commit 70b3c4f734bbfd5664cd6e4eb007c108bf2b1c43 ]
> 
> Use the e_machine rather than arch string matching for AARCH64.
> 
> Add include of dwarf-regs.h in case the EM_AARCH64 isn't defined, sort
> the headers given this include.
> 
> Signed-off-by: Ian Rogers <irogers@google.com>
> Acked-by: Namhyung Kim <namhyung@kernel.org>
> Cc: Alexander Gordeev <agordeev@linux.ibm.com>
> Cc: Heiko Carstens <hca@linux.ibm.com>
> Cc: Honglei Wang <jameshongleiwang@126.com>
> Cc: Jan Polensky <japo@linux.ibm.com>
> Cc: Sumanth Korikkar <sumanthk@linux.ibm.com>
> Cc: Thomas Richter <tmricht@linux.ibm.com>
> Cc: Vasily Gorbik <gor@linux.ibm.com>
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> Stable-dep-of: f53f5c2437c1 ("perf c2c: Fix error masking, OOM, and unchecked caller errors in hpp_list__parse()")
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  tools/perf/builtin-c2c.c | 40 ++++++++++++++++++++++------------------
>  1 file changed, 22 insertions(+), 18 deletions(-)

Please drop this patch for 6.18.y because of build failure.

builtin-c2c.c:3277:21: warning: implicit declaration of function 'perf_env__e_machine'; did you mean 'thread__e_machine'? [-Wimplicit-function-declaration]
 3277 |                 if (perf_env__e_machine(env, /*e_flags=*/NULL) == EM_AARCH64)
      |                     ^~~~~~~~~~~~~~~~~~~
      |                     thread__e_machine

Best Regards
Wang Yugui (wangyugui@e16-tech.com)
2026/09/13

