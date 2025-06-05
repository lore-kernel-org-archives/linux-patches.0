Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C5161AC88B;
	Thu,  5 Jun 2025 14:23:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749133416; cv=none; b=VyzaAX23fDdRVz7ZRzCfOGxhrypCbyPun9SOwGo+fBkz/F/Hsa5ouOvL5vdtBz1/TbSV9BVXq+Amf5fPYiDed1QzXxy6vGQrQOnzl33RpwvytYZ2SeF0N37HxeverI6PZjto/pgspA6LjXOizE4qJZN7zB/KOYQLF9srRlO29L4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749133416; c=relaxed/simple;
	bh=ICEhpStYwnPnDyu8FpwrS3Mq3E3gV6qqQ6x0X1KN6cA=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JXEoD8Shq1X46VL64cqs6nQU2B7NmSZqqgmF6UVbqv+NIdwtZFiacS71vs2y4uHmgh/gyo9SWnghBhnfI1ydJDHqJFvB+8H/2DKlVKfqbdXSPfvQDJNeygjIo3/4C7xs8B1/+P53/TTdTLTOcLBHhQroN+oSmPBAuSL1SKt6FSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Olti2mks; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Olti2mks"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85F9EC4CEE7;
	Thu,  5 Jun 2025 14:23:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749133416;
	bh=ICEhpStYwnPnDyu8FpwrS3Mq3E3gV6qqQ6x0X1KN6cA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Olti2mksDuBvFKHgqSrtEMjHuJAhNYZ+zVEMthfYle1UAQbOS7LcRAu54EWKwq4pf
	 ftTZM2wmn/xcB+Tk+z2tPVrBV3LKrG8jopO0PJFZPQWkxB4kTGBhoaKHvkX12MY9qh
	 vjqQy56jC82utGF5lmLQn3VS+1VQVCpJBaoJkaYsQ3Yw0brHv0gHy+L5PzwFSrPzdY
	 AD0TW9WTVk1JrNnsgz8D7HBdb0G/vxmqdsY9vU+aJVBoIcOA4gBHRyH3S9RGUAa0bf
	 ZdqXdJL5wI4WQiz60lBMk3E+W6D9oHSHHCimJiDVdhcHHOjDAbd7nXfr4VGfBfkjLm
	 /JB159mArxT9g==
Date: Thu, 5 Jun 2025 07:23:34 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Greg KH <greg@kroah.com>
Cc: Ilya Maximets <i.maximets@ovn.org>, Sasha Levin <sashal@kernel.org>,
 patches@lists.linux.dev, stable@vger.kernel.org, Eelco Chaudron
 <echaudro@redhat.com>, Simon Horman <horms@kernel.org>, aconole@redhat.com,
 netdev@vger.kernel.org, dev@openvswitch.org
Subject: Re: [PATCH AUTOSEL 6.15 044/118] openvswitch: Stricter validation
 for the userspace action
Message-ID: <20250605072334.256dc524@kernel.org>
In-Reply-To: <2025060440-gristle-viewable-ef6a@gregkh>
References: <20250604005049.4147522-1-sashal@kernel.org>
	<20250604005049.4147522-44-sashal@kernel.org>
	<38ef1815-5bc1-4391-b487-05a18e84c94e@ovn.org>
	<2025060449-arena-exceeding-a090@gregkh>
	<7bc258ad-3f65-4d6e-a9f5-840a6c174d90@ovn.org>
	<2025060440-gristle-viewable-ef6a@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 4 Jun 2025 10:28:09 +0200 Greg KH wrote:
> Nothing that ends up on Linus's tree should not be allowed also to be in
> a stable kernel release as there is no difference in the "rule" that "we
> will not break userspace".
> 
> So this isn't an issue here, if you need/want to make parsing more
> strict, due to bugs or whatever, then great, let's make it more strict
> as long as it doesn't break anyone's current system.  It doesn't matter
> if this is in Linus's release or in a stable release, same rule holds
> for both.

For sure, tho, I think the question is inverted here. We seem to be
discussing arguments why something should not be backported, rather
than arguments why something should be backported. You seem to be
saying that the barrier of entry to stable is lower than what we'd
normally send to Linus for an -rc, which perhaps makes sense in other
parts of the kernel, but in networking that doesn't compute.

We go by simple logic of deciding if something is a fix. 
This is not a fix. Neither is this:
https://lore.kernel.org/all/20250604005049.4147522-54-sashal@kernel.org/
