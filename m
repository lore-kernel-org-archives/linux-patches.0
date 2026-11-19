Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795104542;
	b=JTMYwPhz8IHoLufqOPwne5xwswqhbK3xQZT+j1T2ZQH4euXdiEZdOpDKJ2M6kCO3UhNz
	 ua3ktxy/zccP/BXxMsUjhMasFT1tXWzfq6q6V0ye3Crj5g6/OyFYDbfhQJ+kO3wg0J8JO
	 6lkRkIMCVxaqK7um37xlAPhlrkIwVZS2qU+wGaaO6wlE5tE9lxJR09McopNTHn6BfRpMd
	 jsObrQfkZA0bw3mJpjEoAY+2RNThdTmoscrniJFbN4TyXgy38LuzV56bN82WDea8/3muX
	 gZdkBslHAfUBLhwJg4EiC9ncBHV+2eXFOTpJllITA/LcbZimf9IZzBNIOnIwKp+t0VA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795104542;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=kh52LSMncJuZXp9Lka+gCj3RdlJjfbNFlPv5v7tFRDk=;
	b=YhGD34ZrxAUplyj7nLZXELyYeF/nFX/UPRher8ot/3bij1tfxOmGyTOuzXK9WuxVN4cl
	 PVk0fWS/hvGAunhbY9Hu53rG+R5DmRG7ZAN/TRaobbGtlvSwCm6g4ZAZJ6/Dx6j2rjetS
	 PEaYSv+UrD/nTRbqKQ79Co4O9gRlrWsuLRBXIwEZ15IOt8s7mugaIDRPk9eaNmvPSWWSv
	 q1Wd6v1rojsDOGJp0SbbikC7qzzUVyydexO3Y0F/j2OldpR63cBmbONHtbqX7+S+gb6UP
	 VvLl81YcoWja9ficC5kHzqDKlkUWrqcjzhRAKEtIy/4M1J0VMMEgQJhBcYmFFUUl0Cg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=U20YdjXp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E635606A32C;
	Thu, 19 Nov 2026 16:09:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=U20YdjXp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60B051F000CA;
	Thu, 19 Nov 2026 16:08:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795104541;
	bh=kh52LSMncJuZXp9Lka+gCj3RdlJjfbNFlPv5v7tFRDk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U20YdjXpN4T+YAAoQlQr1o1UXpHdvu2xZOl42c0Ms5IlbJHoiU0nGV2IlV8JDZR4f
	 omA8z5bd8WgqqDdQTWkAgOdv5ZfpAliC2K4sRZlADhthoMhX4oKidrpfdwqDxZ3mKh
	 zuxrisSoyEaHIkgSocrlexxQkj8wBc5ECTRIZT6zCoZBDUdQNMtRMhoO2+SixAzip0
	 QUa9Ofd2cInNrqo+i8LIY3It0HBD46wKH3iqrk8F9ht++CAlVDjYx744CxF0+lj0kN
	 ZkmBu2SZKvQ2tT/YIcSS7exrWwygK9K8d1VGcwOPOSekjW62Xtlb770Z8Yfq6XnmsC
	 hezaU24Y/35PA==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
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
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Thorsten Leemhuis <linux@leemhuis.info>
Subject: Re: [PATCH 7.3 0000/2651] 7.3.6-rc1 review
Date: Thu, 19 Nov 2026 11:08:27 -0500
Message-ID: <2026-11-19-1-daily-reply-0025@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <b1aecdb0-5076-4df1-82a0-e4f5dc755578@leemhuis.info>
References: <b1aecdb0-5076-4df1-82a0-e4f5dc755578@leemhuis.info>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

> This failed to build for me on s390x while building tools/perf/:
> > util/annotate-data.c: In function ‘global_var__collect’:
> > util/annotate-data.c:785:30: error: implicit declaration of function ‘die_get_type_die’

Thanks. Queued the missing prerequisite for 7.3.

I'm dropping c6dd6161815d ("perf trace: Enhance BTF type formatting to
symbolise kernel function pointers") from the 7.3, 6.18 and 6.12 queues, and
14ca0a28de37 ("perf annotate-data: Resolve type DIEs in the debug file they
came from") from 6.18 and 6.12.

-- 
Thanks,
Sasha
