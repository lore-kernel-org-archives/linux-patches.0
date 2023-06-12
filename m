Received: from sipsolutions.net (s3.sipsolutions.net [144.76.43.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A77EF134DD
	for <patches@lists.linux.dev>; Mon, 12 Jun 2023 11:43:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=yvCB3v5gxtnLTEpQPY5JHQKObtHsN7WRN1uVn8i+7tA=;
	t=1686570219; x=1687779819; b=mGGIS/z1irq/w5L5DlanD9LaXZp0ZlWUU67hoxEt8XePWWj
	c/Im7swD1DtA6bR/zO5Z2X7twzFdZlOgm5bGqhAGGE2+Hd8ykAPZIyCQ2UU9BkEFzm3ORUXKSOQmi
	yGFZcyr7f1dHflhlqo814/mRuhONeUIoMKvbpu1Tenonh25EbjfXpswi5hKHpQLiJCnHd+Flabsh6
	kc8j7Sh0oTNEQx3jsatxuQcx5eyXy0BtNU6cQE8n1dH2UbCaiehZ0e/VLFhLv0zgnsxJAQsfRaDKC
	Y3chZ9dxqBDvxp6Tc+YfDz3UeHyoB/yMLFNV0E/hlUyLtSUs8keF8MGQtSjamEkQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <johannes@sipsolutions.net>)
	id 1q8fxE-003tT5-0k;
	Mon, 12 Jun 2023 13:43:25 +0200
Message-ID: <23db24e1efd0ce7904d0e57289009852cd58e29b.camel@sipsolutions.net>
Subject: Re: [PATCH 6.3 038/160] wifi: cfg80211: fix locking in regulatory
 disconnect
From: Johannes Berg <johannes@sipsolutions.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "stable@vger.kernel.org" <stable@vger.kernel.org>
Cc: "patches@lists.linux.dev" <patches@lists.linux.dev>, Sasha Levin
	 <sashal@kernel.org>
Date: Mon, 12 Jun 2023 13:43:23 +0200
In-Reply-To: <20230612101716.793331479@linuxfoundation.org>
References: <20230612101715.129581706@linuxfoundation.org>
	 <20230612101716.793331479@linuxfoundation.org>
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

On Mon, 2023-06-12 at 10:26 +0000, Greg Kroah-Hartman wrote:
> From: Johannes Berg <johannes.berg@intel.com>
>=20
> [ Upstream commit f7e60032c6618dfd643c7210d5cba2789e2de2e2 ]
>=20
> This should use wiphy_lock() now instead of requiring the
> RTNL, since __cfg80211_leave() via cfg80211_leave() is now
> requiring that lock to be held.

You should perhaps hold off on this. While all this is correct, I missed
something that Dan found later:

https://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless.git/commi=
t/?id=3D996c3117dae4c02b38a3cb68e5c2aec9d907ec15

I'll have this in the next pull request.

I suppose _both_ should go to stable, and nobody ever seems to run into
this patch (at least lockdep would loudly complain), but stills seems
better in the short term to have missing locking than a deadlock.

johannes
