Received: from sipsolutions.net (s3.sipsolutions.net [144.76.43.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5FA91ACBF
	for <patches@lists.linux.dev>; Fri, 16 Jun 2023 16:51:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=zqjLRS5ULsCC7Xjlxjra+VOWosXaiA2+x91ErZ8Mdf8=;
	t=1686934285; x=1688143885; b=Efc6OH73HVKvz2WDWSAOD8oTdaREdEBYY/uVBE4T+gC0tok
	savgIp39bHYM6CSEEKdMJA+4vj1RD/ZiDpc3mn88apceD0EZRAdGAtD+eiyXqcmhJU7n0+1Kly9bQ
	mjRx9h4DD66IFQsZL5XVcoCMIIIUJoL1TaMm/Kx43BSvnN6KawPy0URgXtLVygolsKlClekQKcLsc
	w1pRr6Ieila+jW6PrIBX2c8Lxsj0D5q8xuC9zE1oPovTQfUqh2NEWeqRUFB0UvbV+ZRaD3RW5+d23
	SN9quDT4BOxusC3KLEP/MPfsKp5SRU70amsnmFG8W3eMHn2r9HX+eUyx9E0Gtqng==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <johannes@sipsolutions.net>)
	id 1qACfL-008WTL-2w;
	Fri, 16 Jun 2023 18:51:16 +0200
Message-ID: <1bcc48094ecae8b810e394abb7101bb8f4acb860.camel@sipsolutions.net>
Subject: Re: [PATCH 6.3 038/160] wifi: cfg80211: fix locking in regulatory
 disconnect
From: Johannes Berg <johannes@sipsolutions.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "stable@vger.kernel.org" <stable@vger.kernel.org>, 
	"patches@lists.linux.dev"
	 <patches@lists.linux.dev>, Sasha Levin <sashal@kernel.org>
Date: Fri, 16 Jun 2023 18:51:15 +0200
In-Reply-To: <2023061216-pry-mournful-beed@gregkh>
References: <20230612101715.129581706@linuxfoundation.org>
	 <20230612101716.793331479@linuxfoundation.org>
	 <23db24e1efd0ce7904d0e57289009852cd58e29b.camel@sipsolutions.net>
	 <2023061216-pry-mournful-beed@gregkh>
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

On Mon, 2023-06-12 at 14:10 +0200, Greg Kroah-Hartman wrote:
> On Mon, Jun 12, 2023 at 01:43:23PM +0200, Johannes Berg wrote:
> > On Mon, 2023-06-12 at 10:26 +0000, Greg Kroah-Hartman wrote:
> > > From: Johannes Berg <johannes.berg@intel.com>
> > >=20
> > > [ Upstream commit f7e60032c6618dfd643c7210d5cba2789e2de2e2 ]
> > >=20
> > > This should use wiphy_lock() now instead of requiring the
> > > RTNL, since __cfg80211_leave() via cfg80211_leave() is now
> > > requiring that lock to be held.
> >=20
> > You should perhaps hold off on this. While all this is correct, I misse=
d
> > something that Dan found later:
> >=20
> > https://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless.git/c=
ommit/?id=3D996c3117dae4c02b38a3cb68e5c2aec9d907ec15
> >=20
> > I'll have this in the next pull request.
> >=20
> > I suppose _both_ should go to stable, and nobody ever seems to run into
> > this patch (at least lockdep would loudly complain), but stills seems
> > better in the short term to have missing locking than a deadlock.
>=20
> Thanks for letting me know, I've dropped this from all queues now.
>=20

The above commit has landed in Linus's tree, and I think you actually
should pick up both of these now - there's a lockdep assertion there and
locking issues triggered that I (if erroneously) fixed. Seems that we
hardly ever get to that code though.

Should I send those patches individually?

johannes
