Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8474D472520;
	Sun, 20 Sep 2026 17:50:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789926654; cv=none; b=d00Q3HiZkxtPY4dJWOoImNef9m7VGmUt5+76RnUHS/1z6V6oDk/PCDNn13RiQgwcGmcy3+cKcLrrLP+5QrAuCD3zq7mPVWw+XCEJ5rsb1Vy1yvKTXteJKpg2kX+e3t1nKszJESH99y9hT5BcXPV0JX+BI9R8g4hnFF4FKPZ1juo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789926654; c=relaxed/simple;
	bh=/sZ/NzMqUga0tTfLJ0HV8WDGwcyfb23IYBG/azvlUok=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qgjPDJt+Oyy321uA0HbBAVytYRpeOikkWP+cbWmt55gus3KsE76XkyMo8JGytKuzJrLD8O85TZg4d0oES13ndeVSiI9N5DSyuObvoKT+a9g4aCSbIw3mvCQ7ivl4ziebp6ie9GypOmyfXKkcRJGAV73O/P5UtvEwQJwfGS7TH88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jC9RAXjl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jC9RAXjl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D5021F00893;
	Sun, 20 Sep 2026 17:50:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789926653;
	bh=+sW5CxfWfxL2InU85kBaVapkrbqHMjDfx97Fj9cR9Aw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jC9RAXjlGip2jec+hNjUrZ4XyEAcUN4vfhmCfQXGN/1dd0CtCSbwSa28QrcuzuxBp
	 +M0MSdPuzllbAu5siCbKnEN8AOM2DMpiAV4fj5bMdZPxxwhP5kXgZtNJeHY3qJgjRu
	 zVLypvl0XNVfgfQ6EOw1hrddndpOS7Vj1dEILM/3egm+NmHrVSKJjBYfmZabPWs33w
	 X6zK9gVD7O6YiH0lDSk3HENrI3T9BTBit6Tsq2BpqhZL9eg4+fX31QgQsBPIkPYHaD
	 T6YVbkMH8MO/wUgG/XWk9ZnAl1m+0l3l43J2PrCZEu2oKln+sbHymUpahg20whCcEw
	 mT5g3NiBTaE/g==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	David Ahern <dsahern@kernel.org>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Vegard Nossum <vegard.nossum@oracle.com>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: Re: [PATCH 6.12 0303/1102] ipv6: Honor oif when choosing nexthop for locally generated traffic
Date: Sun, 20 Sep 2026 13:50:36 -0400
Message-ID: <2026-09-20-daily-reply-0004-re-ipv6-honor-oif-nexthop@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <8ba23b23-e7f7-44fd-8238-1df3756e0c28@oracle.com>
References: <8ba23b23-e7f7-44fd-8238-1df3756e0c28@oracle.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> That commit makes the nexthop-object walker inspect every group member
> and retain the best match.  In 6.12.y, rt6_nh_find_match() returns the
> first improvement, which stops the walk.  If that member does not match
> the requested oif, a later matching member is never considered and the
> new have_oif_match guard remains false.
>
> I think 6.12.y should take 484bb9d164df before retaining
> 436d8d6c4487, thoughts?

Agreed, the guard is dead without the walker change. Queued as the
ordered pair, that one first, for 6.18, 6.12, 6.6, 6.1, 5.15 and 5.10,
thanks.

-- 
Thanks,
Sasha
