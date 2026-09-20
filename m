Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E66BD2BEFF5;
	Sun, 20 Sep 2026 00:47:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789865243; cv=none; b=RUsUEDRokxD00h1Zb8ZnPvXzfAogpyDQ7dBO1ItCoOY+2/l6SmLyc9LUo5iDJgxyVH9C9FSIjhxvbV20t2rmDr2zTMhZUgU6uV0jvpB5JzXni2r5MiawHzPorYFW/tQJ0JLJZEwruz/GAZ2+TD2tnX2l0pMiuwME7GQg5hW8DHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789865243; c=relaxed/simple;
	bh=ZYAreQvpUkfjImZwGFcyck1qO1o6goZzI3SdpEy1CxQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gSRuQAb+PFfvnR0FkEH/AkM8C4Kv8WJOAhaGVNRYU9ufnSohHfQyFu6KkTZWXH+6NsefFyUKRyei/EwOIwU/ECzVwMdWQ83/OdpwBMARncEZh5TcQblyx8+g7H/gfLLCMnFFaC7+7pJS3x4BXGI4Zy6sjGM/kWhPyO5xGzDz/2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cCbJhtrH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cCbJhtrH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFE7A1F0089D;
	Sun, 20 Sep 2026 00:47:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789865242;
	bh=UJGrN72spoTIlGHIM8qviJizpeaDoDq4huEc4z65UDE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cCbJhtrHZcMrdaYjKl0pxarKRE9JD//RCthgGACf2Csm+6DsS8EZxjC0+tEDTAkmi
	 grRJ38H+SeTz6sQ6RJDuDRj1TAX/BG7VEw6nh6xRTC9S1v5f6ODHUOonruBHWnwjwh
	 7tBO4r6GMgvQp7yipy/MyAG2Oowfc8bPVW6Q8TFTWwTpckKQuZO0XayqHIkKG/F8U8
	 CTifPC4+VMogjUmfPQfwrDxpPbviI8zi/Lafdseb8W82e9Os2fj5rqkIzc4kWDO33q
	 OxBFiVvMLXMzZLPcV7f31Q4M4RG03GTOeU5heIcLDLesXx+dWerPMtd8cd7Txam/PH
	 fdKj0H0OeS34A==
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
Date: Sat, 19 Sep 2026 20:47:10 -0400
Message-ID: <20260920000825.6-1-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <8ba23b23-e7f7-44fd-8238-1df3756e0c28@oracle.com>
References: <20260917151539.408551884@linuxfoundation.org> <20260917151547.226407448@linuxfoundation.org> <8ba23b23-e7f7-44fd-8238-1df3756e0c28@oracle.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Fri, Sep 19, 2026 at 07:47:55PM +0530, Harshit Mogalapalli wrote:
> That commit makes the nexthop-object walker inspect every group member
> and retain the best match.  In 6.12.y, rt6_nh_find_match() returns the
> first improvement, which stops the walk.
[...]
> I think 6.12.y should take 484bb9d164df before retaining
> 436d8d6c4487, thoughts?

Dropped from the 6.18, 6.12, 6.6, 6.1, 5.15 and 5.10 queues. I'll requeue
it as the full two-patch series with 484bb9d164df in front.

-- 
Thanks,
Sasha
