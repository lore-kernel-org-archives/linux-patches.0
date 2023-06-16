Received: from sipsolutions.net (s3.sipsolutions.net [144.76.43.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D8301ACDB
	for <patches@lists.linux.dev>; Fri, 16 Jun 2023 20:06:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=XMyky9NnGRex5d9J6o+89iENFnkLTHlH4e4jijnATl0=;
	t=1686946003; x=1688155603; b=vxmi4bDMZ7Uowat/tgv2mY7j00OZu+aXtSBmgf7ZwdNFOkj
	c4lrDdACDhZF7pnI9aKivZlCHpf4uzY35P24Uu3kpVsNb+EF2b0e2RpsaRSPtxBiNI0LgUXOjcHVw
	w79WlpsKoV/BTu6aGWt0QJ8mUs4xguUE8Vf2nquwrvxRaR8FWNbVPQxXd2ll5SJcRj9dzNlXQ5Pw4
	EZ2Tes9Xkk+46ygGJij+AU0wvLfpFSQqC8jVRjtqQ7zDIzufc14tHVkG4w7+OXYzr/YgsXYY0F6m+
	R1xzHvsfuLpzuTMci07+qwwISQDGaJoeWOTKcC+Ht91dOm8YX3uIAT/hMT9bxL0g==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <johannes@sipsolutions.net>)
	id 1qAFiS-008bMN-02;
	Fri, 16 Jun 2023 22:06:40 +0200
Message-ID: <dd21d369706b89d5a4033e6af344ed7045465077.camel@sipsolutions.net>
Subject: Re: [PATCH 6.3 038/160] wifi: cfg80211: fix locking in regulatory
 disconnect
From: Johannes Berg <johannes@sipsolutions.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "stable@vger.kernel.org" <stable@vger.kernel.org>, 
	"patches@lists.linux.dev"
	 <patches@lists.linux.dev>, Sasha Levin <sashal@kernel.org>
Date: Fri, 16 Jun 2023 22:06:38 +0200
In-Reply-To: <2023061628-nimbly-ebook-3635@gregkh>
References: <20230612101715.129581706@linuxfoundation.org>
	 <20230612101716.793331479@linuxfoundation.org>
	 <23db24e1efd0ce7904d0e57289009852cd58e29b.camel@sipsolutions.net>
	 <2023061216-pry-mournful-beed@gregkh>
	 <1bcc48094ecae8b810e394abb7101bb8f4acb860.camel@sipsolutions.net>
	 <2023061628-nimbly-ebook-3635@gregkh>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.3 (3.48.3-1.fc38) 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-malware-bazaar: not-scanned

On Fri, 2023-06-16 at 20:48 +0200, Greg Kroah-Hartman wrote:
> On Fri, Jun 16, 2023 at 06:51:15PM +0200, Johannes Berg wrote:
> > On Mon, 2023-06-12 at 14:10 +0200, Greg Kroah-Hartman wrote:
> > > On Mon, Jun 12, 2023 at 01:43:23PM +0200, Johannes Berg wrote:
> > > > On Mon, 2023-06-12 at 10:26 +0000, Greg Kroah-Hartman wrote:
> > > > > From: Johannes Berg <johannes.berg@intel.com>
> > > > >=20
> > > > > [ Upstream commit f7e60032c6618dfd643c7210d5cba2789e2de2e2 ]

> > > > https://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless.g=
it/commit/?id=3D996c3117dae4c02b38a3cb68e5c2aec9d907ec15

> I can pick them up from here, as the git ids are present and that's all
> I need, right?

Correct, thanks!

Note that in 6.0 the indentation for the second patch changed, but
otherwise the logic is the same (just additional indentation due to
multi-link support.) But I can also just send a fixed version when you
bounce it back due to not applying.

Also, FWIW, I did verify all this in the meantime, and in fact there's
an additional bug here since 6.0, I'll send a separate fix. Also another
problem with OCB iftype ... oh well. More fixes to come later, I guess,
though that's probably not that interesting for stable.

Thanks,
johannes
