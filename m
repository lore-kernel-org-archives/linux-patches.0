Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4589D3EA979;
	Sun, 13 Sep 2026 11:26:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789298801; cv=none; b=tRNWkxVDsdAgnNy/nRLjCKW6LnvLMrJ3syi3cec6ZjBCQMh+uSQccNKscZYwji+gi//H8S0GXCDh70m4MPkwnbsUD6lDURmcIVuXCSIYWOtXieRPMxbxzbMvqMN9ez1htUo1pNoctrmSHq6WVFwQnwJd8UDmstd0+gOnE+LBOIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789298801; c=relaxed/simple;
	bh=YLQRIEOC7B/w+IPX7gc1u0wKRq2rjuB+Tdse+xH9MnA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ilOEIAdLU2Fuv0E5OPyrNQWJR/5qQRo7wrzl9Tb766puQzjaNBAFSsp53wcglQ0mShHHd3CtJcTcDGEAOD3WslV7VTOUd8Hth9QZorkYM+iYdG6ANsDQI7JYiArLF3/G9CgkZ5npkERAbKNvsxiMwBjTF8TRQY7qF1wdk72zCkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QQmamKuB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QQmamKuB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A23431F00893;
	Sun, 13 Sep 2026 11:26:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789298797;
	bh=bMI4u498aDi+UwaiZ6lRKi6pXB+VEcqGq2YCSXeOy7M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QQmamKuB5LxNbZJDkbZfSDwjbL7UjFI2wQIJRbczhi/k9GqWpKvPxJsrJax+sFHen
	 J2WVZkYBTh1D0IAUNBpjgS3UcdU3zsEB0HjaYCd/hOuWgKJTCKG3GqDekz+lo4Om2i
	 F+yzJw/wIr0AVpKbbkW9A+ROG7sj+M/cYS6dubVsdDAyH07tU+52sCvZWSWqxQWPAE
	 UJ5kf+jJpxdkt5UJoUcz6F788FV5ILNhE2jMTLurZmhzZRd3Pu5lRgVyzogFX+AXxk
	 w8DQ56QmcmIqE0teT0TXcKxfPlLnsouEtORo1oZ3OKc+ZYe6QUuLcDstSYYewr7xP5
	 7XgD3jiKqT27Q==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sasha Levin <sashal@kernel.org>,
	stable@vger.kernel.org,
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
	Wang Yugui <wangyugui@e16-tech.com>
Subject: Re: [PATCH 6.18 0908/1518] perf c2c: Use perf_env e_machine rather than arch
Date: Sun, 13 Sep 2026 07:26:21 -0400
Message-ID: <rc-reply-report-013-perf-c2c-20260913@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260913085648.B79E.409509F4@e16-tech.com>
References: <20260912065623.398859879@linuxfoundation.org> <20260912065643.993908175@linuxfoundation.org> <20260913085648.B79E.409509F4@e16-tech.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> Please drop this patch for 6.18.y because of build failure.
>
> builtin-c2c.c:3277:21: warning: implicit declaration of function 'perf_env__e_machine'; did you mean 'thread__e_machine'? [-Wimplicit-function-declaration]

Dropped from the 6.18 queue along with the following two dependent patches:
  - "perf c2c: Fix error masking, OOM, and unchecked caller errors in
    hpp_list__parse()"
  - "perf c2c: Clean up registered formats on c2c_hists__init() and
    c2c_hists__reinit() failure"

Thanks for the report.

-- 
Thanks,
Sasha
