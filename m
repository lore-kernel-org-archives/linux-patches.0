Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A86D423748
	for <patches@lists.linux.dev>; Mon, 18 Sep 2023 16:17:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A0C0C433CB;
	Mon, 18 Sep 2023 16:17:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1695053852;
	bh=DQQ6e5dUAGAEmHLUF+dLJ6eP+3jZnMJLKtK6MB24T8A=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=as5A4WtXZ8nNG6ESDvjGEal20NONI6D/wFrUdtWOSW0wM7nw76n9M2Nbv4ettHLSn
	 fM+hHfKJGN5QRIQvDlWvxNxFLjBseestJr4hva2awD+zIPWqORaTZiCfqck5ojaF6x
	 oeZ9+3OlNBrTv/rVkfcBxPy7mwpWcQYRy8NKo9LrK+x9d3gMGwjxPJ3tMBETONw5JL
	 YWquEwNNB5VLS7l1+PnSWHCJnhgUCf9qg8GTxvTWJgUPNZkFPPwah1foDZqTIUvp45
	 syRNHdHTC0eOVeogx0X6pDsYtoK6XmU/V0f7teDBKOIpnffzQiYGcO1Ihbg3UG8P9H
	 wMpIkFCkP9/0A==
Date: Mon, 18 Sep 2023 18:17:27 +0200
From: Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, Lee Jones
 <lee@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 261/406] leds: Fix BUG_ON check for
 LED_COLOR_ID_MULTI that is always false
Message-ID: <20230918181727.74a28f4a@dellmb>
In-Reply-To: <2023091836-papaya-jackknife-2867@gregkh>
References: <20230917191101.035638219@linuxfoundation.org>
	<20230917191108.094879104@linuxfoundation.org>
	<20230918160004.3511ae2e@dellmb>
	<2023091836-papaya-jackknife-2867@gregkh>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Mon, 18 Sep 2023 17:22:59 +0200
Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> On Mon, Sep 18, 2023 at 04:00:04PM +0200, Marek Beh=C3=BAn wrote:
> > Greg, please drop this patch from both 5.10 and 5.15.
> >=20
> > Reference:=20
> >   https://lore.kernel.org/linux-leds/ZQLelWcNjjp2xndY@duo.ucw.cz/T/ =20
>=20
> But this is already in released kernels:
> 	6.1.53 6.4.16 6.5.3 6.6-rc1
>=20
> > I am going to send a fix to drop the check altogether. =20
>=20
> We will be glad to queue up the fix as well when it hits Linus's tree,
> please be sure to tag it for stable backporting so we can get it in all
> locations.
>=20
> But for now, being bug-compatible makes more sense, right?  Or is this
> really critical and should not be in these kernels now?

According to that e-mail, the patch breaks booting for some systems, so
if it would be possible to avoid it...

I've sent a fixup patch which removes the BUG_ON altogether, and
referenced the patch that broke booting in the Fixes tag. But I don't
know how long it will take to hit Linus' tree, it may take several
weeks.

Marek
