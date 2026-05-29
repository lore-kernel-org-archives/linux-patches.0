Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A14A83E0C7A;
	Fri, 29 May 2026 12:44:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780058657; cv=none; b=RNX5+4fM9xErjGDNDWjCfhvZPlhfqVB0bGqLYN1ry6E556izNZQxjZE+m64nGaTrYxjNZeqDnhuqfYa8Vt3l9yJcnkmAHLV8L3lOwaB1QcgWrfLTwfpgQSruaiA7XIUZdQg1Ka0l8ASnZ+6Fme+CPfuw16FbYZjb02Q1H8EdIFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780058657; c=relaxed/simple;
	bh=zFf0vqoSvwdAUNw/Zbh6klg8QnhlL2zzlsAw4korEqY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bFRfCZuVQ9njPqOwcM2PvH9VbSc450u6AtunDnIqCJHHPzfAJLqG36n/Lww+ssLRozgOS7iQ7m/BQzXPHKgimXUS4ueUTmOVQZxoCuwKNvQsqHSIt5QKxaHsmM13k9ppXpwKJUrrBniJIvhqJfpX2wKHRJ+aWe82Fhnss/HlsEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OqX5bOuG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OqX5bOuG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6E3A1F00898;
	Fri, 29 May 2026 12:44:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780058656;
	bh=dKR2NQWZLnvue8OybyMx9PfcdgZuhq9MpOKGheaAxgY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OqX5bOuGxd6l2XvtQRnc2ypnk8wm/rNuz2ITQwEl+mmNGyLpktisFqcFUqxNPHrqw
	 FuL91B43M6L+wP5qyhJxkw7CD6Rq2zacZ1pn47Y/lRiYWpkqm5B8ix4PbKR5xiZUWU
	 KRyydmzBN0d2xgHO8OXA5TnRzO7TPvom2+dLCJwp6w90Xj0TPg53GKB0h8n4E0YWcm
	 rj8ippn2EE6gNB+qtF7GrAprUn0692MTN1zajv2ARYHu1R5X4TCY3skmbchKcdOSXZ
	 0POVdQ7Aich0O1Fr3m0JqR5iEevQRvDTPmCwxIVK+WhB+GZlU5X6sXGjFIXxkHw0Uq
	 +mUy8aQsh2jxg==
From: Sasha Levin <sashal@kernel.org>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Sasha Levin <sashal@kernel.org>,
	gregkh@linuxfoundation.org,
	achill@achill.org,
	akpm@linux-foundation.org,
	broonie@kernel.org,
	conor@kernel.org,
	f.fainelli@gmail.com,
	hargar@microsoft.com,
	jonathanh@nvidia.com,
	linux-kernel@vger.kernel.org,
	linux@roeck-us.net,
	lkft-triage@lists.linaro.org,
	patches@kernelci.org,
	patches@lists.linux.dev,
	pavel@nabladev.com,
	rwarsow@gmx.de,
	shuah@kernel.org,
	sr@sladewatkins.com,
	stable@vger.kernel.org,
	sudipm.mukherjee@gmail.com,
	torvalds@linux-foundation.org,
	Anuj Gupta <anuj20.g@samsung.com>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org
Subject: Re: [PATCH 6.12 000/272] 6.12.92-rc1 review
Date: Fri, 29 May 2026 08:44:06 -0400
Message-ID: <20260529122623.bio-integrity-rc-prereq@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <ahlN6TPTgMwBT9_d@duo.ucw.cz>
References: <20260528194629.379955525@linuxfoundation.org> <20260529060918.123155-1-ojeda@kernel.org> <ahlN6TPTgMwBT9_d@duo.ucw.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Fri, May 29, 2026 at 10:27:21AM +0200, Pavel Machek wrote:
> > I am seeing:
> >
> >     ./include/linux/bio-integrity.h:101:12: error: unused function 'bio_integrity_map_user' [-Werror,-Wunused-function]
> >
> > This looks like it needs:
> >
> >   546d191427cf ("block: make bio_integrity_map_user() static inline")
> >
> We see that, too:
> https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/jobs/14592368004
> We don't see the problem on 6.6, 6.18 or 7.0-stable.

Thanks! I've queued up 546d191427cf ("block: make bio_integrity_map_user()
static inline").

--
Thanks,
Sasha
