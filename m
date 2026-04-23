Received: from fhigh-a7-smtp.messagingengine.com (fhigh-a7-smtp.messagingengine.com [103.168.172.158])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0112B18A6CF
	for <patches@lists.linux.dev>; Thu, 23 Apr 2026 12:17:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.158
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776946664; cv=none; b=tX25wzC6FTAe4xr94CpYn8fbF2DodPL7Lwh2dmuuI1CBZdYAj2iybrxBeqI4Z46lOlUPsuv7dqsLRtwuxrIIfVTC5YgOUhAcXTAMhAQSgbWBIVt67iVQY9ZbA6ehL/l86awxoG94Ypt9T0qXidwTEWSSITsQKuA3OvLj6AGonFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776946664; c=relaxed/simple;
	bh=eZAfRTd+nMUMw9Hyt/ax5nQGgHXRCzpGt513hPu7CWM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GYRjqZJOEeA3quKnRyyKO/XyxY4qwrxtjlS9pO7SGN3nzSPfHrodxcYUaz90Bc8FDjXDhnFi1a9vE5acq+h9iwc/+wO68SMHTMWthz0PLeGHsBeg4+IuY1DCJWgC0ucBjPPg7aoYBiBbX6jO1bdB7s1oYKlFPHnjABn+QZT5KCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kroah.com; spf=pass smtp.mailfrom=kroah.com; dkim=pass (2048-bit key) header.d=kroah.com header.i=@kroah.com header.b=fEzGpYvE; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=paEhe8gL; arc=none smtp.client-ip=103.168.172.158
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kroah.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kroah.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kroah.com header.i=@kroah.com header.b="fEzGpYvE";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="paEhe8gL"
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 3C33A1400130;
	Thu, 23 Apr 2026 08:17:42 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-02.internal (MEProxy); Thu, 23 Apr 2026 08:17:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
	:cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm2; t=1776946662; x=1777033062; bh=tbOiZ7lJrP
	kg6OKoUP+o1ryHrq0J8Sqp4fZFwVyXb4g=; b=fEzGpYvEvBQd3C7tJ7dbtQUvk7
	1eqRJaSu7mBjfo1unCuU0zOZWNqWOcNeJ9RGlb2ANeBqAHVicKwgxfgXRqk1k3Nl
	U2dPuYutNwoR2ftPySlpjwmZQ9J9YUGRTwqq2+WVK3Nyu6I3QuiXRus3nW1vzXEn
	CKRHumOxIs0qbUpyhZr3r60p6G/9fOr0mNmywp2Dy0oC46kdr4V2p7c3wRhhI8Hg
	KGo84yVItx+kGUZGTO/zWRa014hJwnxeAVuygqYr8r/r6rZ0nOllX5Rym4Yrzk5z
	JWO/3dXslWgOtk92TPgN/NSEiHiOPLTYbChN15rb92tKh8qspT6h2WxoLUiw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1776946662; x=1777033062; bh=tbOiZ7lJrPkg6OKoUP+o1ryHrq0J8Sqp4fZ
	FwVyXb4g=; b=paEhe8gLHFqprspiXmNYdBocHJ1sN53uhQE8eU9Pzu+1ylptJ+r
	wID/ggVH52BVRLhv6hyKNDWfXnuzjJMrzt6ZdqU0VbBkwZpkQBnLVsxplQ0wK5HR
	Lc+cuGVrEXLZpyUxS7fh1UoPK29wIUV5z0Ih6/QD8MEBT5osesk/hX+TrlMku8RR
	NDScQxt+ipTxRIku7xddQbV15Cx7L1LNKo6/cA7kGcIJyj9VgXkgIlfwtLZp6mMO
	Tw8wMR2avVhoECNFvNXRSqrQYWRlFqq9FxOxv4xy6Mc38bXRlUwPNmN9qA6HN8Ih
	6PYKn/qRFOXA/+B3zvjg/z2uhjUeY+GMfGQ==
X-ME-Sender: <xms:5Q3qaVpc0KqpUdKLsKGTVC96i08UeENBvzpQWHhTc_ennaEqXq_nsQ>
    <xme:5Q3qaUV6UiojtUAGO0svT7qjdFkzUt1K5znaHOJd-TKHnn_cJ4h9-KogUdNtOvpTK
    KyKUatKYSxNhhIgZoeOsM1GahAykGpzTIe42f8_tVWthqisnQ>
X-ME-Received: <xmr:5Q3qaWHwgSa7mdqJwyT4u35dQyyUiDuPnQp9oh3nH3-5rzTFgOhwFjWitYK9-0TM84zGxo3-TruEt4eOp5PVCElLvQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdeijedufecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcumffj
    uceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeehgedvvedvle
    ejuefgtdduudfhkeeltdeihfevjeekjeeuhfdtueefhffgheekteenucevlhhushhtvghr
    ufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtg
    homhdpnhgspghrtghpthhtohepuddvpdhmohguvgepshhmthhpohhuthdprhgtphhtthho
    pegsvghnseguvggtrgguvghnthdrohhrghdruhhkpdhrtghpthhtohepshgrshhhrghlse
    hkvghrnhgvlhdrohhrghdprhgtphhtthhopehprghttghhvghssehlihhsthhsrdhlihhn
    uhigrdguvghvpdhrtghpthhtohepqhhuihgtpghjihhlvghssehquhhitghinhgtrdgtoh
    hmpdhrtghpthhtoheprghlvgigrghnughrvgdrsggvlhhlohhnihessghoohhtlhhinhdr
    tghomhdprhgtphhtthhopehsthgrsghlvgesvhhgvghrrdhkvghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:5Q3qabByfHi-eewxJAaORODJDPF3YpHWzQmg599dquXImkrBDPlNWw>
    <xmx:5g3qaYxCvj30yAbZQAvfenjih_gMiK1RToSdO3UU4mpV1Gp3k57lyg>
    <xmx:5g3qaRdlXCsisBFyXzrYYAOw9bwN_hZRvpTqJ4MSOzqdrpcoGyFoSA>
    <xmx:5g3qads8yLu85L1-TOVH_1UrEhJSCUjkK45NbiStcNoOaxdL34MDqA>
    <xmx:5g3qaYeihaG_Pyb3M23LvVg_f0nlBUYjX_cZM7Ca1rB3jva7kp5cyz1X>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 23 Apr 2026 08:17:41 -0400 (EDT)
Date: Thu, 23 Apr 2026 14:17:40 +0200
From: Greg KH <greg@kroah.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Sasha Levin <sashal@kernel.org>, patches@lists.linux.dev,
	Jamie Iles <quic_jiles@quicinc.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	stable <stable@vger.kernel.org>
Subject: Re: [PATCH 5.10 005/147] i3c: remove i2c board info from i2c_dev_desc
Message-ID: <2026042332-anatomist-ditto-2252@gregkh>
References: <20260228181736.1605592-1-sashal@kernel.org>
 <20260228181736.1605592-5-sashal@kernel.org>
 <f7285cc36ec39c4a6cef633add170518f2e34b3a.camel@decadent.org.uk>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f7285cc36ec39c4a6cef633add170518f2e34b3a.camel@decadent.org.uk>

On Tue, Mar 17, 2026 at 02:13:42PM +0100, Ben Hutchings wrote:
> On Sat, 2026-02-28 at 13:15 -0500, Sasha Levin wrote:
> > From: Jamie Iles <quic_jiles@quicinc.com>
> > 
> > [ Upstream commit 31b9887c7258ca47d9c665a80f19f006c86756b1 ]
> > 
> > I2C board info is only required during adapter setup so there is no
> > requirement to keeping a pointer to it once running.  To support dynamic
> > device addition we can't rely on board info - user-space creation
> > through sysfs won't have a boardinfo.
> [...]
> 
> This was broken and needs commit 6cbf8b38dfe3 "i3c: fix uninitialized
> variable use in i2c setup" as a follow-up.

Sorrya bout that, now queued up.

greg k-h
