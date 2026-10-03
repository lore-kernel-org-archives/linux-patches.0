Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8C7639CCF0;
	Sat,  3 Oct 2026 22:37:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791067052; cv=none; b=HXi0cL49Ew/ORIcNGHd4YriluTJh5G4UvLEobmYB+CKrRizBFsPwG7KyMMkkB63QDJmuNsPtmUOwyZDGnBfEErANDJa6r4X0PkxxZ/4Vp5JWAW5pk50V5R/uoO1+X0Bf9Hp7JLp3j/cNFbZa8TQwFN89kcWecUnL11Mw4uySngI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791067052; c=relaxed/simple;
	bh=QVAgH41p4BJc78Moscm80zTLYvLvJck7d26uVrecZ1o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qD5sg2bYEaTxVc00rprWvE4RneUvg3AJMHj8yEudNru+wDkidFZfMwHsraoPKjpp29RIq5LtyHoWaySKyaFZm5L3CTgIdje2cURmzprlPDcUezzDPQ358rG+oNqsTg8Uj6l7xz3m+/gfFYedkTdLGhi0PwogOmdvzTcZvEDkzv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Jd7Spy1e; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Jd7Spy1e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3F931F0089B;
	Sat,  3 Oct 2026 22:37:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791067051;
	bh=MUDPJMjiCtKrdgVT2oAz4AHTRjDmiwLYrc1txS2LwDg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Jd7Spy1eETC3VtDOGwcI9GOKm3qd1EcIR7pluM1NIYOWDAH8cG9LWrOMgHUyox7o6
	 ni+M9MEAw+l+XnTNV3Qn1yNLfBfxBSPRuM0f/oUv2AtSGb2p1CQ0b/iGK0bVPsLWns
	 nj03qDaqkFUJOah2iL8QHEExktmQbGw50g5LM1EfAo3BxyhlXouc0uyem0rITicYd2
	 TUJbIOMnIlzg8gguotTgaeH47skr99Tbvc35ENBxcKd+na1Rbp4S3OOqkoBth25szB
	 ynsNRCoITXJ/R+Gds0ZcT1uj3scPzRwEFTQwYHRQSEP0GK7HALKNC/HmsXAeTcw1fS
	 id/up4b8bdqNw==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	Allison Henderson <achender@kernel.org>,
	Simon Horman <horms@kernel.org>,
	Praveen Kakkolangara <praveen.kakkolangara@aumovio.com>,
	Maoyi Xie <maoyixie.tju@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: Re: [PATCH 5.15 064/752] rds: filter RDS_INFO_* getsockopt by callers netns
Date: Sat,  3 Oct 2026 18:32:59 -0400
Message-ID: <2026-10-03-1-daily-reply-0018-re-rds-netns-filter-d2bfdbb6-queued@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <051245f8-42ee-4046-bff9-5fd2dbeaf807@oracle.com>
References: <20260930152358.131179731@linuxfoundation.org> <20260930152359.544074072@linuxfoundation.org> <051245f8-42ee-4046-bff9-5fd2dbeaf807@oracle.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> I think 5.15.y should take d2bfdbb69cf87676981b1043010b6224d84c6d3a
> ("rds_tcp: close NULL deref window in rds_tcp_set_callbacks"), adapting
> the counter context and retaining the namespace filters; thoughts?

Agreed. The netns filter already shipped without it in 6.18 and every older
tree, so I've queued Allison's backport for 6.18, 6.12, 6.6, 6.1, 5.15 and
5.10, thanks.

-- 
Thanks,
Sasha
