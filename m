Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30644242D9B;
	Mon, 31 Aug 2026 01:39:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788140366; cv=none; b=JLgeg1pVUMxde3teNZ1wjBHcO6tiDRWsGJ8xWYPtkyXb4JHbMd35QpWurs32/Lq59E4Z7o1CuD+qFA3A5jChzthW/XR8Rz4cVOAB0U2TUgXSFGrvVVTSmt7SM1/JWXKaoBsqzongFBJAzSrQ/SRLlS77IgJoBodDnBbdY/S7T+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788140366; c=relaxed/simple;
	bh=EyfyDMfz5iXIvIGYNGacBa2DbdPXe/Usl+9PLaxb2pU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iswsV7+aVUDuNdMbFyprKq5SmE/PebdPCNS6B2PrBtxbXRUXjRYDkbrcQ06v37quX4jqKPnQHto/LOUYi8v/s3rYkavAyLvKK8+bE6xn2yFfPZToG8fC2CPCD/dQ4su4iNtxkZOdgS4psojwBcaLNH/5uGeAgMlYz9Xbk22Pujc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ehzkbp4P; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ehzkbp4P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C67371F00A3E;
	Mon, 31 Aug 2026 01:39:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788140364;
	bh=2w/QyiVRlKJlvamF6UhNH3OakGYy3ud/rLQtAxasD/U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ehzkbp4PmbR84P+pt/LVA77wYaP24tS6XFn0WrX1ksu7ub6pttF1AUSccuHylOc2J
	 p8o1CUV6E3X482u9bSkUHo75EXFp5vnrAZOya+DUFThurPRDr0QNHyrb8K7I1jAbKl
	 scdsDdiaJMALNDUlChJgDkRHBmCdWgjH0QAmydrFk0e6qjSqLcSMZvayy4xr3HKNoA
	 gs312k2i6oUMwOiQ6zqnPu3OFgbr52YBW3WEengDDpRysR/we5SKemxQD/lF1Q43iz
	 +eim3CWlx1WD+MtM+VlrpqgZA+Lmu36XzJCNuOmVPIjqujK/2kmPNUnLFd5y++7tR8
	 QpZRy1atG6MeA==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Stephen Smalley <stephen.smalley.work@gmail.com>,
	Paul Moore <paul@paul-moore.com>,
	Vegard Nossum <vegard.nossum@oracle.com>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: Re: [PATCH 6.12 016/220] selinux: require every boolean value to be defined
Date: Sun, 30 Aug 2026 21:39:08 -0400
Message-ID: <20260830194600.0002-1-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <d3b0885f-30f2-4022-8790-321092db16fe@oracle.com>
References: <d3b0885f-30f2-4022-8790-321092db16fe@oracle.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> Upstream already had cf6a513f1937 ("selinux: switch two allocations to
> use kzalloc_objs()") and therefore has:
>
>         p->bool_val_to_struct = kzalloc_objs(...);
>
> 6.12.y instead has:
>
>         p->bool_val_to_struct = kmall

Queued for 7.1, 6.18, 6.12, 6.6, 6.1, 5.15 and 5.10, thanks. Used
kcalloc() on 6.6 and older, where kzalloc_objs() doesn't exist yet.

-- 
Thanks,
Sasha
