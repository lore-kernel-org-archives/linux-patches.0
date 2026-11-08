Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794156299;
	b=PlrytUUHJgFIhXASz6ulpM1CJdrpCKeEQoa66IT6OA+ozcR3xFTH0BcLwVO7M11klCAM
	 wQOdh02FNSDPDd8hkNTO6SH7K124PYfRMuD2LPpnzmipylrdiNqkNAGl049gwuLJU5bk8
	 Y5O/ufMu+FQp/mC0F8VUK7cL8FblEv/rc5bhbABSTP4k41y6RSrbVnNf6lQEphbRzIVwv
	 6umKo8W+7Cdw9x16Hg9yKu41TwRWTtFXQJJ6UTIvbfiwhJdgMQ1ugpZoSGun31/WijvwA
	 VswCecBOE613DkEgcLl5JQgUUEJ1MENatprULgxJRiLC77S6Cg06irFXmBjSmnaeusw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794156299;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=fo3HljCeNMh5lRC3Fu3GnOfdQa5wnRm3QZqPQNvYBAM=;
	b=NgwcAhIeazlqb15PmoVAzcFMzkmTyUvMpc+WFo7a0Oj/OyT7WN5mnvzdjvGWEU2b1kME
	 4ULz9Nd4YVjHa5ChNF9UyZ9R+ALjoOskE+YbAgovTflfgz34jRmmMFf3/eNhig6IYyuT7
	 gvQyLmTkOfF0FYpYiIUnFEB2K/RS25rbklksMUH7jAnVwggVZ7GSl1kARpSl+Fmm869gr
	 a2n+9/3CspqOHrm0QIshzSnByXTRf13zSp7NL5iT9+CTxDIYlelEjbnJCjwfBj6vjmAB4
	 j1x0JnhpQY3w6sZZ4C4dsiaZAVCaXorDc53uLG6bgHX++1a4QrNIOfImI6XEOlVPJkA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iWhWpZdy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F736606D811;
	Sun,  8 Nov 2026 16:44:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iWhWpZdy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD9841F008A1;
	Sun,  8 Nov 2026 16:44:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794156298;
	bh=fo3HljCeNMh5lRC3Fu3GnOfdQa5wnRm3QZqPQNvYBAM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iWhWpZdyOTIdqX/ZrCUx54xGwZ929QUgoJHZQJCFLxl2Vs6OKNjZzD2vZpiujbOzx
	 VQzGyKxu9Wg+1gw1bD/kmMZYlqBVMSjHCF3+By00XfJvxXDC3f2SqwBt/Y4tXxziY4
	 0pZ37z5NQB3M1lhLyHuai34A+5PQMpQtaFVOTcmRWI+0UpwZex1E1nwjE1UudVfgb/
	 33HQgFLcxJVjF7c/cAUZGhnk2iTBrLYukAJqWoc2+hh991zemqIyb6bYNXWIuFP3Ix
	 UbHR2bgho5PGycN+TwoRdDpB21Yr9rrGNPJVaBYNPnYkHCpKl8z5uh9hzc7JqSYxwF
	 TCH/Sr6ivUQBQ==
From: Sasha Levin <sashal@kernel.org>
To: "Barry K. Nathan" <barryn@pobox.com>
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
Subject: Re: [PATCH 7.3 0000/1257] 7.3.4-rc1 review
Date: Sun,  8 Nov 2026 11:44:48 -0500
Message-ID: <20261108-rc-reply-02-xfs-sched-ext-7.3.4-rc1@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <f6e0e225-a80e-49ee-9555-be300f169503@pobox.com>
References: <20261107134939.434104957@linuxfoundation.org> <f65916c7-470b-4f64-84d1-da8cf4c8e7e8@pobox.com> <f6e0e225-a80e-49ee-9555-be300f169503@pobox.com>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

>> 7.3.4-rc1, 6.18.63-rc1, and 6.12.117-rc1 are all giving me the same build
>> error with clang that I previously had with 7.3.2-rc1 and 6.18.61-rc1,
>> due to the same xfs patch as before ("xfs: cross-reference the primary
>> superblock"):

> I took 7.3.4-rc1, reverted "sched_ext: Fix the stall watchdog testing
> and blaming the wrong sched under bypass", and added the fix to
> initialize error to 0 in xchk_superblock() in fs/xfs/scrub/agheader.c
> (quoted above).

Thanks for testing. Both problems are now dropped: the sched_ext patch from
7.3, and "xfs: cross-reference the primary superblock" from 7.3, 6.18 and 6.12
(it had come back after the earlier drop).

The xfs build error can't be fixed with a local "error = 0" change, since
stable only takes upstream commits, so the patch is dropped instead.

-- 
Thanks,
Sasha
