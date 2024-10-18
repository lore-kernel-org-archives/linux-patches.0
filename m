Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77725188010;
	Fri, 18 Oct 2024 22:21:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729290090; cv=none; b=J9INd72rTS1PWSwrbFaG5H3M1i/BEvLI0htYNeXEEsU41vkOt9Ib6md5XPo2EGzoKxd/RBcGrft0n0pLT6Q6VsPgmZgiq/UqJGH1sJvCbBOgBm7FiF++WkUN+fwxDFKQrybwVDWE1Tn0dTaWVRZwmoPrkBUuGApzC91HUMGBObc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729290090; c=relaxed/simple;
	bh=4n1E6zsPjzDBUO6wxiwsX5e+eLod/+yScuo03zOPR40=;
	h=Message-ID:Content-Type:MIME-Version:In-Reply-To:References:
	 Subject:From:Cc:To:Date; b=uO4NsQFEivxdqSWwXpTvkeUb3VWCz0AS1Il/dtVXCD0mYknp6pIFSkr2T2QpStSIal4XI68HC0mDrTLTYauS9qSUgOShiDIg8wkBS/7iXeoC70hCPTcbVjFqUJ9iRSk9MhHfheRx9pM/8cl4mcwVGOCp5DCMKwPeLRRp/Klaf4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iMQoa/qo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iMQoa/qo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC0A1C4CEC3;
	Fri, 18 Oct 2024 22:21:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729290090;
	bh=4n1E6zsPjzDBUO6wxiwsX5e+eLod/+yScuo03zOPR40=;
	h=In-Reply-To:References:Subject:From:Cc:To:Date:From;
	b=iMQoa/qoSjlkez69IQUfIaQg55pR7xccB5L//NsWX/f+2c9eYSkuB0gkNJgmnipVL
	 gdSVXm7ZdVFVQjXanjro6UWW8FdEGwXCcizrrnhVpKtr/QBaejcB/drZulXaoeknq9
	 ys4nvVE3KEYAKRN6VZ52xXErVdZ0gNRWayCrSdGp3TPALMJenjlsV+G+QytbqAYBGc
	 ah6qKr+EKBKO6xnqzXUCn06jXweLTn4x74Cd91h1iJ0GhnhceLx0PxDQ97eRP+vPzP
	 6gVw+AFUP8meeemHJhB/mPJ5SFksEFgWmpb7S6q1na0ASXhGQIHUs6MNhNc7i0ci7k
	 fvrtx+BOQfNxQ==
Message-ID: <38153cbf2616a4a6706412952778eec1.sboyd@kernel.org>
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20241017203810.GA814469-robh@kernel.org>
References: <20241016212016.887552-1-sboyd@kernel.org> <20241017203810.GA814469-robh@kernel.org>
Subject: Re: [PATCH] of: Allow overlay kunit tests to run CONFIG_OF_OVERLAY=n
From: Stephen Boyd <sboyd@kernel.org>
Cc: Saravana Kannan <saravanak@google.com>, linux-kernel@vger.kernel.org, patches@lists.linux.dev, devicetree@vger.kernel.org, kunit-dev@googlegroups.com
To: Rob Herring <robh@kernel.org>
Date: Fri, 18 Oct 2024 15:21:27 -0700
User-Agent: alot/0.10

Quoting Rob Herring (2024-10-17 13:38:10)
> On Wed, Oct 16, 2024 at 02:20:15PM -0700, Stephen Boyd wrote:
> > Some configurations want to enable CONFIG_KUNIT without enabling
> > CONFIG_OF_OVERLAY. The kunit overlay code already skips if
> > CONFIG_OF_OVERLAY isn't enabled, so this select here isn't really doing
> > anything besides making it easier to run the tests without them
> > skipping. Remove the select and move the config setting to the
> > drivers/of/.kunitconfig file so that the overlay tests can be run with
> > or without CONFIG_OF_OVERLAY set to test either behavior.
> >=20
> > Fixes: 5c9dd72d8385 ("of: Add a KUnit test for overlays and test manage=
d APIs")
>=20
> Doesn't really seem like a fix.

Ok. Feel free to drop the tag.

> Does this need to go into 6.12?

It's only important for 6.12 if kernel configurators want to build the
kernel with OF_OVERLAY_KUNIT_TEST enabled and not be forced to enable
CONFIG_OF_OVERLAY. I don't mind if it waits a while.
