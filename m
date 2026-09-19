Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B9D82E8DEB;
	Sat, 19 Sep 2026 17:07:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789837644; cv=none; b=FB4qyiqeQ48URXkJ3OVwhBJFTBcdtFKoLcyNFw6Ul1Wa0S0/DmZeTgvaU2NfDkzljC43MhxCUohfecD1wrU1+W/j3mevNTCP+04ylwS4IYchrCUVpMPE8927U55+JrYvoLioFNd1Nk1imEgHhTToNjUt6xKLV4Y2Gp28x6Xg+4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789837644; c=relaxed/simple;
	bh=8rBsJdt96krUf8mZ3ofhFwaD0Oj6wvryd53TwKn+rmY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fu/NDbMgObBn8sxXaL4NjrfeqSdMyCWPezL9usoO/emM+CQiRRX9/j1+R7Dh9wiP/ATPu/OqOkw4pClD1y9bxv9ssowbEv4cw9gjVilomOR38YX1DAu+Z7vNjXFBcvsrWGN3B7mHr2cbhkgOswtl1zuCKqYw5LtdsP9tsh36o4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OH18l8d7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OH18l8d7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63AC91F000FF;
	Sat, 19 Sep 2026 17:07:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789837642;
	bh=oPt6k1SU2rZ5GUciEked3ObqN8vGIC3bKt2iePvZ4ec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OH18l8d76tvib9jY4wRTNxx2/Jto2mRnBazas4Cod9TUf/6Aor9FgRpd9vTFwNQaj
	 WRaJKG6WlpReMNWjBp+Oh4I7K5O2SRvtrJOEEKwaHJI7mnfhrXAh+tedR9gDL7fJte
	 llku0Okd2vuFnQxq/UyefLQv4wKA0xNT6lDy+TCRCEZUKqkvyScwPYb2PmNpyzCUns
	 E1CKRv3MBScyOzN8dk044SQ6XiYvOV713f+yS46frW9gsMx2gW+UBMlycnTblLZzNO
	 pyNC45nQ5CkVBA0VOnKzlkfQ41lqmU2I4BIIkFjy/Mj3Yo+AzmtUbVx3ckIdwQcRNI
	 pdFiFTDEVlGow==
From: Sasha Levin <sashal@kernel.org>
To: "Barry K. Nathan" <barryn@pobox.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Eric Dumazet <edumazet@google.com>
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
	sr@sladewatkins.com
Subject: Re: [PATCH 6.12 0000/1102] 6.12.111-rc1 review
Date: Sat, 19 Sep 2026 13:07:17 -0400
Message-ID: <ce4ba85b47cf4c2e8f7def41@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <49dc2e4f-7a94-430c-8b02-6f3d422222f3@pobox.com>
References: <20260917151539.408551884@linuxfoundation.org> <be8641ad-ed0c-4e6e-a915-0874076159d3@pobox.com> <49dc2e4f-7a94-430c-8b02-6f3d422222f3@pobox.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

On Sat, Sep 19, 2026 at 03:54:25AM -0700, Barry K. Nathan wrote:
>> [   98.363843] RTNL: assertion failed at net/ipv6/mcast.c (1014)
>> [   98.363896] WARNING: CPU: 6 PID: 961 at net/ipv6/mcast.c:1014 __ipv6_dev_mc_dec+0x17b/0x190 [ipv6]

> I bisected it to this patch:
> ipv6-mcast-don-t-hold-rtnl-for-ipv6_drop_membership-.patch.

Your bisect is right, and thanks for chasing it all the way down --
the splat is real and the patch you landed on is the trigger.

I've dropped the ipv6 mcast RTNL conversion patches from the 6.12, 6.6
and 5.15 queues.

> If I take 6.12.110, apply the current stable-queue (as of commit
> 01b20bb84b994fdcda64fd07a66ba84c85d0168f), then revert the
> following patches:
>
> ipv6-mcast-don-t-hold-rtnl-for-ipv6_drop_membership-.patch
> ipv6-mcast-don-t-hold-rtnl-for-mcast_-socket-options.patch
> ipv6-mcast-use-copy-on-write-rcu-updates-in-ip6_mc_s.patch
>
> then the resulting kernel no longer shows these warnings at all.

The root cause is a prerequisite we never picked up, rather than anything wrong
with the patches themselves. Upstream commit e01b193e0b50a ("ipv6: mcast: Use
in6_dev_get() in ipv6_dev_mc_dec().") is the commit in that series which
deletes the now-stale ASSERT_RTNL() from __ipv6_dev_mc_dec(), and it was never
backported to 6.12.y, 6.6.y or 5.15.y. So we took the patches that stop holding
RTNL across the setsockopt paths while the assertion they were meant to retire
was still sitting there -- hence net/ipv6/mcast.c:1014 firing on every
IPV6_DROP_MEMBERSHIP. The queued patches are byte-identical cherry-picks of the
upstream commits; this is a series-ordering gap on our side, not a botched
backport.

7.2 and 6.18 carry the whole series, including e01b193e0b50a, so they
are not affected and keep their copies.

One difference from your experiment: I removed four patches rather than the
three you reverted. The extra one is 1767bb2d47b7 ("ipv6: mcast: Don't hold
RTNL for IPV6_ADD_MEMBERSHIP and MCAST_JOIN_GROUP."), which is a pure refactor
of the join path and was only ever queued as a dependency of the others. It is
harmless on its own so consistent with you not needing to revert it, but with
the rest gone there is no reason to keep it, and dropping it keeps the series
intact for a clean requeue.

The plan is to requeue the complete ordered set, e01b193e0b50a included,
once this RC is out.

-- 
Thanks,
Sasha
