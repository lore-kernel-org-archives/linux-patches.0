Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C10150E590;
	Fri, 18 Sep 2026 15:54:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789746864; cv=none; b=M1uLcoGXjJW2BjdSs4MW9bG0dOW2IvmRCu5Hs5nzaz2ghLq6yXLHTm8hKgIqawRc35YPeBj0bQkXAKusmhvd7p/584Vm9I5ai1XE8tkyUpoQpPsOERArh2yu+WvP3crK/Bb9NP+1hzLvbbVLlfX+qBCorPOcYvN0wtwukU0Azj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789746864; c=relaxed/simple;
	bh=tq2aFE8qk8W08Dpe6HtCknDX8FIgl5aKryUBa5d/yBk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f/D/Km2mYRH+HBLZSBPtsKmTDsnlHCyoyKBEvMXQ1bopNear9v6O5Gadb4PsLEN5R2GraNSyyA1YZCC9ruvEFKwTSnu1pU7yLfKbd2qDf7Pw4K+3NRJEXS1MpTcaq7vRGabwpmWPj2JEE+JVQSIDeRQ2wu5TzWVkqjyhMy8IRZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Bm98SgwP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Bm98SgwP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1600E1F00898;
	Fri, 18 Sep 2026 15:54:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789746863;
	bh=/tQprN3z/v5xGa72y/P3ii6p47RjByq0SxNA7vQBM6s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Bm98SgwPfK3uLO2/YXScjJtjeowXcQvwbMslqUfZrApbWZ6VN5ucR8gy5K61M5qU3
	 k0xqYY0bXdMcklfFUUR46h1BEYiy7zGD9fD5mvxsRRZyCEL8sZkSIIX/JFoJ+qtANN
	 VoV/vtUZ3LCDXL7G8ozkS8SCs2ds/Rxp5IJuhQnLIlDOaVQ1a4AjsVShpdtyjunaI+
	 VsrojhwOG8oGF2JN7EK36C7z61yac49pnnVRHjtfVYpGclWJBXdEFSv+81484mrQVC
	 qSJa5LLNqFlVNSfimdux85VpHIJsu+AXuZgt4ge9I43doOPkMpxCAZGF2vRfUGcXxT
	 JCk8JJNfIVllw==
From: Sasha Levin <sashal@kernel.org>
To: Brett A C Sheffield <bacs@librecast.net>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sasha Levin <sashal@kernel.org>,
	stable@vger.kernel.org,
	patches@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org,
	akpm@linux-foundation.org,
	linux@roeck-us.net,
	shuah@kernel.org,
	patches@kernelci.org,
	lkft-triage@lists.linaro.org,
	pavel@nabladev.com,
	jonathanh@nvidia.com,
	f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com,
	rwarsow@gmx.de,
	conor@kernel.org,
	hargar@microsoft.com,
	broonie@kernel.org,
	achill@achill.org,
	sr@sladewatkins.com,
	Peter Schneider <pschneider1968@googlemail.com>
Subject: Re: [PATCH 6.12 0000/1102] 6.12.111-rc1 review
Date: Fri, 18 Sep 2026 11:54:07 -0400
Message-ID: <20260918151140.2101477305-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <1e80f4b3-3919-4568-aabd-f0172581831d@googlemail.com>
References: <20260917151539.408551884@linuxfoundation.org> <aqxBBu5GXVhHcqTz@auntie.librecast.net> <0dc35fd5-ee4c-4140-b154-78a49981ddb7@googlemail.com> <1e80f4b3-3919-4568-aabd-f0172581831d@googlemail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Fri, Sep 18, 2026 at 07:49:48AM +0200, Peter Schneider wrote:
> So I have bisected this warning, and the first bad commit is
> 
> [af5775004c9c02f37be06d2035a056b6abb1cb6c] sched/fair: Fix EEVDF entity
> placement bug causing scheduling lag

Thank you - a second bisect on top of a reverted tree is real work, and
it was the right call. Dropped from the 6.12 queue:

  6d71a9c61604 ("sched/fair: Fix EEVDF entity placement bug causing
                 scheduling lag")

> Trying to revert this from 6.12.111-rc1 however resulted in some
> conflicts I was unable to resolve. There are other dependencies like:

Right, which is why the three patches stacked on top of it came out at
the same time:

  6e3c0a4e1ad1 ("sched/fair: Fix lag clamp")
  51b0e68cfa0a ("sched/eevdf: Fix rb augmented with multi fields")
  9a8bc9bb4c3f ("sched/eevdf: Fix augmented max_slice")

Some background on why this only bites 6.12: the WARN_ON_ONCE(!load) you hit
needs 4423af84b297 ("sched/fair: optimize the PLACE_LAG when se->vlag is zero")
and c70fc32f4443 ("sched/fair: Adhere to place_entity() constraints", which is
a Fixes: for exactly this commit) to be shut up, and 6.12 has neither. More to
the point, upstream has since reverted 6d71a9c61604 outright - 101f3498b4bd
("sched/fair: Revert 6d71a9c61604 ...") from January, which concludes the
original commit "was wrong!" because avg_vruntime() already accounts for
cfs_rq->curr when it is on_rq. 6.12 only ever picked it up as a dependency of
the eevdf fixes above, so carrying placement math that mainline has disowned is
not something we want here.

-- 
Thanks,
Sasha
