Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58823411FB3;
	Wed, 16 Sep 2026 19:28:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789586958; cv=none; b=WCOljUi/Rk4Q/rTO2mKuTukwFh9d+4BVISezus88t7Oq68oH/8lVuZwHcJoN12VaEDWQHjgiIajP1Lk3yEPLD46+8YMUM4kwJQVD0gPBTzOsOX7EX4k7jvryI45wyZzcrjacJPVnYMI9EPni4jIT50gvhSU7Ui+46MZSR2IoWEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789586958; c=relaxed/simple;
	bh=x02VE3J4t0tzAitMpbMPudaDwa+wGZOPq0pX3HqR6ag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RvwtmrDhokHz/gdADeY3dZXTBuSAOskKxtMz36k+0PulTM5u1hBNYj53CH9LY4cjmPW9v8eTo/+sS2Nl/pugEzPEA5VBkxOeuPGDeQq3yeX12sqUVTyivfOnd/XAHMW5AyBmptMZvhlw2kBfXVixxw+rGDcnwMz+JL60/Y3pgeU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S+nUc0WB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S+nUc0WB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA6421F0089B;
	Wed, 16 Sep 2026 19:28:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789586922;
	bh=L9HSPUKYVhnzvdfaiO2OQ9jP6jT0h2yF9r+fJcaguXQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S+nUc0WBJcFWQNgsxM51eEM9v+Y9G3e/b6F7fH9T+ZVcZz+oMU0dPqu1+alfVBrZf
	 bW8SIaIcGp4pJPwpZ5yeo8Kve9kPE1aXFhY3ip/BNy4EFBA52+YZB9oXo0Zj7xutbO
	 2L+oASWEVNe74/48uMprAsZj5u/XihtrwCRtecAK6IY7w+4juN6K6tozekl5Qny/GJ
	 MVKHPb8eXpfYzAE8TCjQTpMnoT3wXTejrsfrI0BvE/g4DYpDYQ1gOjbE0HNTXydgyF
	 bB57LgXBC8AeD7JKN3XQQDqgCQ7C0qOl8LMjoM+OpQoE8uusTQ6SW3a5V4ZHF/b8HC
	 A7oBGvxyn05+Q==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Ingo Molnar <mingo@redhat.com>,
	James Clark <james.clark@linaro.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Kan Liang <kan.liang@linux.intel.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Weilin Wang <weilin.wang@intel.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Vegard Nossum <vegard.nossum@oracle.com>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: Re: [PATCH 6.12 0353/1376] perf tests metrics: Permission related fixes
Date: Wed, 16 Sep 2026 15:28:03 -0400
Message-ID: <daily-reply-20260916-0013-re-perf-evsel-eopnotsupp@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <b0e3573a-1a02-4f21-bbd3-775f78a90c75@oracle.com>
References: <b0e3573a-1a02-4f21-bbd3-775f78a90c75@oracle.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> I think 6.12.y misses f0869f31562bde, "perf evsel: Add per-thread 
> warning for EOPNOTSUPP open failues". Thoughts ?

Queued for 6.12 and 6.6, thanks.

-- 
Thanks,
Sasha
