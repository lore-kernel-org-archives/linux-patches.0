Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9B47215075;
	Thu, 20 Aug 2026 04:19:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787199579; cv=none; b=HNxyLx+4hM5hNbveoTadMsH78VmfVcr7u0TjODqjUipPk15DvMGBwKeUuJZcz+CEL79giy+gYOwCmYfTNDVvmHtft3H3czXEL5pkpDLM8yw8LFn1xo/Ye11JgMe6/nmCxSLfYqonAtJWp+3YiTC1ZiYnuKWT5lMjj4mbwhN8KGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787199579; c=relaxed/simple;
	bh=AQSp/rYxb/nOnIwfk0hUrd1pXRzjTBLErT5O/N9P4h8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s5wvC7KOEf9v9s6SC9KvdeDq001FQjvJaS5wYGd3Pcl2BERNwOk+eMV6GT26vV/XCqUCLiuC6BUFD+CUgJnWlJFJWQnZo1hpLUOw4zbmk0G/6E1fi53VS32uGw1XNXJV9QB27zfjBXwdOtNaOKdMUzAaaIx3Xwyf5fy9/k9ufJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mftU5V4H; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mftU5V4H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCBDA1F00A3D;
	Thu, 20 Aug 2026 04:19:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787199578;
	bh=n9qwPhgD9uOTt88ruC7UrDBHtOPMYulY1xm19Qi+2Zk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mftU5V4HyryeX0uBruUcR8b5JcuJBWPujyA9ELQ62JKabfi0z5/LqwbRzGDzxF9mK
	 pBvhmbJn6KGIbWDieC5mb9kkUWHjsyGBpuBnsv83/54cZcx/xgwOk4k2f5G4iXHBzA
	 dKlogqKvPC5PRdroY74kXOLvy98QSOFL3c46eRlESzCWZvBRJ+Psl+WYAdnEqsrI6F
	 YNYDXnTvtD/abp4Ut6nbMYWw+1gV9ogY2Wx9cR+rbKJSYgC5tqeVrU3krpyPjDrspg
	 sRu3sI8vH3eGH+ZXCAR9pYr3QcTxqmO3L8DV8r9wQyz+rvWJV57JjdcCeC8pC6ixAb
	 uLZWSNBsZMuig==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sasha Levin <sashal@kernel.org>,
	stable@vger.kernel.org,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
	patches@lists.linux.dev,
	"Jose Fernandez (Anthropic)" <jose.fernandez@linux.dev>
Subject: Re: [PATCH 6.18 227/250] eventfs: Use children field for rcu head and add memory barriers
Date: Thu, 20 Aug 2026 00:19:28 -0400
Message-ID: <20260820040907.7@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <aoU1on2mnwB4pSGa@linux.dev>
References: <aoU1on2mnwB4pSGa@linux.dev>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Wed, Aug 19, 2026 at 04:49:37AM +0000, Jose Fernandez wrote:
> 6.18.y also lacks 4d9b262031ff ("eventfs: Simplify code using
> guard()s"), so the new direct return leaks the SRCU read lock. The same
> fixup works here.
> 
> 6.6 needs the same fixup too. 7.1 has 4d9b262031ff, so it is fine.

Confirmed, and sorry for the missing reply here - I only announced this in
Harshit's 6.12 thread. The patch is dropped from 6.18, 6.12 and 6.6, and
kept on 7.1, where guard(srcu) makes the early return safe.

If someone posts a properly adapted backport for the older trees I'm happy
to take it.

-- 
Thanks,
Sasha
