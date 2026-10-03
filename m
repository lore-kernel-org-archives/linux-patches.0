Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A11736492D;
	Sat,  3 Oct 2026 01:30:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790991036; cv=none; b=iKGC4pLD7uLwe+n6oFcpBbhPlmP5rFqbgiojyZRixX7Txh7XkUWZpY9C6mrwo/q9FF7xY24e0Z/vLn6Z2wY4Z5aYAdsmEp2+mnkM8iaBUlFMH/nB0T7uNGKaz6nNRudL1FutDfNVzeZjujWEovqUUAhKcnLbb1InRTpfuYZcL3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790991036; c=relaxed/simple;
	bh=KjEJQA/uBIUliCyvfdfvDIeNyvD01k1btI/2wDRqAdg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Uj+WpFLQa0OULak7ItDG88U5ZIWpLQTXw6lyGZZLAuDjDom81xFUVPl/sxnXzUyl94UK2+38OQlJDEdqaYYe/PLo6peb6oLAgGiMdF7G0Z3m7nTXMeOzvozBPi4/iC9Tc8S2XFl3o8TKPYtMbXfgcmv3w3SDWQpKM5RTaCMMyk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fGYHGhdO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fGYHGhdO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17EB51F00893;
	Sat,  3 Oct 2026 01:30:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790991035;
	bh=sY4/7PLGfqkJd/xH1grOtgynRJp6iYaBMOW1ucZs61M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fGYHGhdOSLDO65KGl0pCR+wGRbQ9mMWukfHyopD2cKq+G7VNIsHnnzB5YHfMkezmP
	 W+7OWd6thZldmIQ5hbA3y9GTn1R0r7mIU33QLfzjta/S3+D/yJADIV7mvhAjjdOa2s
	 gtKM0ku0goDx1hfFaMQTSKQGGm6oJVzOKw7XmVJA/iGKtS06BJCIHTcjEfpEBGs4Bc
	 qELwo0Swhj4eQKH2d+UKyUV5Q/YNZbha0DBOjGILf6rxXgsr6DMSzU+cz05s63VLmh
	 aj/Lk7eg7Tjh4hOlZnUCW8TZHeX2rOgBJxdTwvbp1j/kKYeoklrDNmIkLOx6M8zc9e
	 uDbo3n8Wlfo3A==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: Re: [PATCH 6.12 746/877] ipv4: remove fib_devindex_hashfn()
Date: Fri,  2 Oct 2026 21:30:25 -0400
Message-ID: <2026-10-02-rc-reply-0005-re-ipv4-fib-devindex-hashfn@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <630d79b5-28a9-4443-8ab1-bea938ceec66@oracle.com>
References: <20260930152414.738996857@linuxfoundation.org> <20260930152430.793210817@linuxfoundation.org> <0d9af3d2-6656-4248-bdc9-0a09d5f7bd40@oracle.com> <630d79b5-28a9-4443-8ab1-bea938ceec66@oracle.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> This also belongs to - we need not/should not take the fix until we take 
> a prerequisite category. Could we drop this until we have a proper 
> backport ?

Dropped from the 6.12 queue, together with fc38b28365e5 ("ipv4: use
rcu in ip_fib_check_default()") and a3f5f4c2f9b6 ("ipv4: remove
fib_info_devhash[]"), which were queued alongside it, thanks.

The ipv6 flowlabel fix they were pulled in for, 8d6cd1885085 ("ipv6:
flowlabel: cap duplicate leases per socket"), doesn't actually depend
on any of the three, so it stays.

-- 
Thanks,
Sasha
