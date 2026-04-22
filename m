Received: from fout-a3-smtp.messagingengine.com (fout-a3-smtp.messagingengine.com [103.168.172.146])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3BD229D26E
	for <patches@lists.linux.dev>; Wed, 22 Apr 2026 06:12:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.146
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776838334; cv=none; b=hRHteb+WvxyC9bJRVtBw6LxB7iO7VXwnbBWrRm1CtMc0yaJHxgPLHRfWiElRsIw52bYPOVs749hvCYTRPOGouaKFoiJ8dO0dA8sBRQr9rFhXEaMEUzXcRoMJakr9mWSTlcbpzYP1zQZirTrK3G7o7to/drJF0i/17kwZqxqMT+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776838334; c=relaxed/simple;
	bh=r2TttHa/vISVoHfzpQpcn6y/vaY2bVfneMj2BmPb7cY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZxLqIB6tg9i3HBM4yNWyvisFhgdfGZ1cgssVpcWIY7l+A5ddC9C6yZb84QiXQlxBJW3jbOFOJ3XbjKtpO8pzW0rnBGXj5WeuTygWAmzYXauCeAKHrhlHFuJ9rFBZoxS71cje+aQuaxneCo6hMbwZALNnbKEFChgFsQTCl8+fgw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com; spf=pass smtp.mailfrom=pobox.com; dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b=Gkex6D+1; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=t5huA2K0; arc=none smtp.client-ip=103.168.172.146
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pobox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b="Gkex6D+1";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="t5huA2K0"
Received: from phl-compute-11.internal (phl-compute-11.internal [10.202.2.51])
	by mailfout.phl.internal (Postfix) with ESMTP id 24791EC00C5;
	Wed, 22 Apr 2026 02:12:12 -0400 (EDT)
Received: from phl-frontend-02 ([10.202.2.161])
  by phl-compute-11.internal (MEProxy); Wed, 22 Apr 2026 02:12:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pobox.com; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1776838332;
	 x=1776924732; bh=dKN91OZq0hHnIny0oiHWCqw9IUVu6LE2eBKBnWbpGjU=; b=
	Gkex6D+1JnNXQHvOs7iTwyG/J77jxuCRQa3pY9k8v6lsnLyVKx7V+qN8jqvqRu1A
	b3O4PUxAE+Ia6Bo+WBFYmzWAd+WU5wKNFDnLzzeiqsjfqGLPxvHqr8T1rdofWRl3
	HkdjIx39GT1oAWGJs1/9VTECkDqugHJXyIdS61digoEiuQBk9TRV+j6IZphfyiTL
	vKB/2rVAqeGIV2PTv0zxEUq5+31sJcX0z2RAp2F+Qms3TZtNeiNQFGp6B4zi3d4E
	cl0aX19q8JZ4xYtL6mxfG4vUtF8Wcykx8dTD8hdM+EpqL89ln93xWEm/EGLf3Qu7
	53f5skhCMOIJUBnN1oq1bw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1776838332; x=
	1776924732; bh=dKN91OZq0hHnIny0oiHWCqw9IUVu6LE2eBKBnWbpGjU=; b=t
	5huA2K0f5lvz5R06U82cIH1bKehST2TLGn3qtAlk/vv5OqRRvf3bCG/8KXh9J3W4
	rUNYUUPMfq5opSI+Z7KlYPqtUZNJPk1clcMiJtsnvGkrg+rpVKVfH1dR3W0Lz2wY
	/HhaWvDF/B+ZqA9PSi0XVI23VbGGVXqQWW+iSu7phjY4pgM23sKQKAmJhst830J2
	H+dNjnbpA6jrQOtJgrO7isr2Nd2HleWLAn/bgs+GYP+2dAk9bUGiyUX73tb1gRkB
	gtVm9/6hMMyfbNCA3B2u59YWoUUXPrzrMH59aTHngH+xnNI0NApjr/22olBQmpJ3
	9aja2Y94jYwlzJRZ+7B0A==
X-ME-Sender: <xms:u2boaVY5nVJKgTEM17N3LiJhYRpH_iko0ycgCBDydCDzcMwp-O3-0g>
    <xme:u2boaYT8v7n3B_rfTlh2A_Je2Ep8SXevPMIsFpuKMRNT0rRrWYJMoTVXZzWX3Z0xE
    wP9CDRE64m_yJfJpZ3BNQ-gf6mtQqDZ8TQcJrwn3YReF8_sDG5TvuWK>
X-ME-Received: <xmr:u2boaTcDYd7ZYDRKEpH3NM-__GBXWuQIYmQ-AA5Fg3iQJkiCKB1-mEu7Y5sLxlPJyl-TxNsAhhZYEYbvDjj92S-6VOfCLBxQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdeifeehvdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpefkffggfgfuvfevfhfhjggtgfesthejredttddvjeenucfhrhhomhepfdeurghrrhih
    ucfmrdcupfgrthhhrghnfdcuoegsrghrrhihnhesphhosghogidrtghomheqnecuggftrf
    grthhtvghrnhepfeelheekheelkeejlefffefhvdeljeetheeltdeiudffveetffelteeg
    gfefhfejnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiii
    gvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegsrghrrhihnhesphhosghogidrtgho
    mhdpnhgspghrtghpthhtohepvddtpdhmohguvgepshhmthhpohhuthdprhgtphhtthhope
    hgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhrghdprhgtphhtthhopehs
    thgrsghlvgesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehprghttghhvg
    hssehlihhsthhsrdhlihhnuhigrdguvghvpdhrtghpthhtoheplhhinhhugidqkhgvrhhn
    vghlsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtohepthhorhhvrghlughsse
    hlihhnuhigqdhfohhunhgurghtihhonhdrohhrghdprhgtphhtthhopegrkhhpmheslhhi
    nhhugidqfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpthhtoheplhhinhhugiesrhhovg
    gtkhdquhhsrdhnvghtpdhrtghpthhtohepshhhuhgrhheskhgvrhhnvghlrdhorhhgpdhr
    tghpthhtohepphgrthgthhgvsheskhgvrhhnvghltghirdhorhhg
X-ME-Proxy: <xmx:u2boaXmyWNTNC7NyiK_rFV1BT9-VCKaeJpykpwr9gGrdMz2zr4IzKg>
    <xmx:u2boaYhsFAuDJaFe9cGsOGocImoL5qPOmu1WY-FpySqRxaqwnesO9Q>
    <xmx:u2boaYH8787poLZZ-k-zWn81UjNP5If95GbU7nvZ2A6ealGVA_TyxA>
    <xmx:u2boaXyKwGew5YVpnReVCP1ITYSiUSxvlHBAdoFEaJ1ZoHGOZgmggQ>
    <xmx:vGboaSuKzYmgCgBjW7UAThZPQGrwpcU5v-I66Uw_5QNbg9v72tI53f9O>
Feedback-ID: i6289494f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 22 Apr 2026 02:12:09 -0400 (EDT)
Message-ID: <ecffaa3c-ed9d-4962-aa24-73e20363edbb@pobox.com>
Date: Tue, 21 Apr 2026 23:12:08 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.0 00/76] 7.0.1-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260420153910.810034134@linuxfoundation.org>
Content-Language: en-US
From: "Barry K. Nathan" <barryn@pobox.com>
In-Reply-To: <20260420153910.810034134@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/20/26 08:41, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.0.1 release.
> There are 76 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Apr 2026 15:38:50 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.0.1-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.0.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

I tested 7.0.1-rc1 plus clockevents-prevent-timer-interrupt-starvation.patch
(since that patch has been added to the 7.0.y stable-queue) on 2 different
amd64 laptops. Working well, no regressions observed.

Tested-by: Barry K. Nathan <barryn@pobox.com>

-- 
-Barry K. Nathan  <barryn@pobox.com>
