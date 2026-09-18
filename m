Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 392DC50EBE9;
	Fri, 18 Sep 2026 15:54:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789746862; cv=none; b=lBSSL5z8Gu+/P+t61I0XHS+vW178iAckTzXpe8LkFLmdTbwz9nRwrmWswa2eYwkBW1Fxn3qvKRDHM4mydajOQDhgKenN1Lw3JVa2ajQRTkEHcSdyOTSnY3IF6Ub4gQUNzHnAduCyHQ718nZ2lrcr0SvmkOjj/Ql5PxIrH9pBJso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789746862; c=relaxed/simple;
	bh=iw2hwh4nqaBk0ro521t1gMgj985Pb+sUyEIefCrWMbk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pfKLVVh4l0AM05cBAoG65cpvvUuddWyi2w5vwB8tBKXnKZ/kvgfYfSvtVYHOUkpGNaChf8vPWai0UtZGm8EByawVaxF47tedgKKgktAbpk6wJKUrsTfH+tGU6mc6wyqktFTQHaL15CmxhtkkNk969rPSfITcEZclUeT8ub3Pp8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JPCC6t5h; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JPCC6t5h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B66841F000FF;
	Fri, 18 Sep 2026 15:54:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789746860;
	bh=J4MNoaR/MNmLT3RFNxvpSS79yLUzde0GXWfAll/s8Bc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JPCC6t5hAiloOnE8j7AjpJBl1/rR/ROh4uNxIhCiXSV1gQWeDhpXFTxIX+vlb52od
	 jj5J3UK0Tq1LSpPSKFPm+uu+QrgiLw7uwJJhiQZQd9vR5RWqjym7YwyBvyEt93AskS
	 XU6RX7L3tHPgM5UWA+W8gumSpGsG2kv4RdbpVYpwJNwvxxd/R6W+KjNG64qUT8l+H3
	 e6UVNVcANv5V+0qn1Uy0OKZcTbS/lwuVWrdMuZXKw4HdIt5+7YNJ8nb0+dMJgdWTz2
	 JyTJcbw/JK6Z3uSxgCqZkp0cbgHQqlupeSNbPenrgkYufBaUsQ73uwK6qtFu1r8K2i
	 4GblHUicWuUAA==
From: Sasha Levin <sashal@kernel.org>
To: Peter Schneider <pschneider1968@googlemail.com>
Cc: Sasha Levin <sashal@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
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
	sr@sladewatkins.com
Subject: Re: [PATCH 6.12 0000/1102] 6.12.111-rc1 review
Date: Fri, 18 Sep 2026 11:54:06 -0400
Message-ID: <20260918151139.2101477304-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <aqxL2yCxD-sqNdi4@duo.ucw.cz>
References: <20260917151539.408551884@linuxfoundation.org> <dda6b1b0-5c9c-4417-976a-e20c4ee59ef4@googlemail.com> <aqxL2yCxD-sqNdi4@duo.ucw.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Thu, Sep 17, 2026 at 10:21:47PM +0200, Pavel Machek wrote:
> Seems to be identical / very similar to crash we see, and we have full
> log:
> 
> https://lava.ciplatform.org/scheduler/job/1510595

It is the same one - the photo shows the same
gather_bootmem_prealloc_parallel() fault as your LAVA log, and Peter's
and Brett's bisects both land on it. Dropped from the 6.12 queue:

  b1b7c045e808 ("mm/hugetlb: initialize gigantic bootmem hugepage
                 struct pages earlier")

Thanks both of you for correlating these - having the full oops next to
the bisect made this a quick call.

-- 
Thanks,
Sasha
