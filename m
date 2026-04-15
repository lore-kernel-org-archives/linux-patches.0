Received: from fhigh-a4-smtp.messagingengine.com (fhigh-a4-smtp.messagingengine.com [103.168.172.155])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D787C313E03
	for <patches@lists.linux.dev>; Wed, 15 Apr 2026 03:01:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.155
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776222117; cv=none; b=GvOh183NP4kRgOg+8iNP+j7KGx3triU4aUA4wVsi1Z1YeR/PXZDrrrpl4Y8fJRiqCMQXH+xOaX/vJxs/jwExKkSw/Rhu9n6gH5IptlVszMQuD7EzGttUhOqFLzbcpYnl6gue/vSy42EglDKl9WvXja0waROahUw/FvOo+2G4Ez4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776222117; c=relaxed/simple;
	bh=W/jUTGUj+n30/wzQ4L0pWC4NbyR5tp4hDb2ScG6NO58=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Jy4sFIKJ0iTddLqEylUMcSrIZsYitc+B+0l04np0BX8P8BfG6rccK883IoiAe1Llj2i7I4p5Tw0+INvGU5OTOTB8Mj1qHhhvwlPiaE92wcg6ivqVGjWw1BDu03sC0OePqetckJT6BiXU1UOGetGQb+z56Izj41LT9CKi/mBjjo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com; spf=pass smtp.mailfrom=pobox.com; dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b=MeBGDzCp; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=B1OtOjVw; arc=none smtp.client-ip=103.168.172.155
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pobox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b="MeBGDzCp";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="B1OtOjVw"
Received: from phl-compute-07.internal (phl-compute-07.internal [10.202.2.47])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 144181400112;
	Tue, 14 Apr 2026 23:01:54 -0400 (EDT)
Received: from phl-frontend-01 ([10.202.2.160])
  by phl-compute-07.internal (MEProxy); Tue, 14 Apr 2026 23:01:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pobox.com; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1776222114;
	 x=1776308514; bh=X3tBxvSzTizskPq8QDhlPpCMkzL6YpeRfY33RE4VTb8=; b=
	MeBGDzCpZosYXj7BtVmR5a/bd/m9i1HqKsaPlC76BZdK43CdQIp+C2WVnXG6aMIj
	G3tTpnS/KER8++ZLE6HHOEr71k8Lr0nUMEAFvDTTYIiDjMW8lflITm6C4kPsc22k
	JpHeA+Q0byQ88Nl5SdO+MslNsnIh2purn5YU/JySrzFqVTJU9c/wLEmQixQsVwGR
	m+TzGS/chWxsE5W6o9uj0j7GlBinC+KQqMoxL6broTIwSfSCWJnjY11UHTQWma3W
	PHWEtCz3IvN5yTRJu1KZF21B0WNaZ3prDMDkrUoVQZzpr2Ua4eqEZ/lutUoXWApj
	JG9QCEsS4eGtMGNIslQAeQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1776222114; x=
	1776308514; bh=X3tBxvSzTizskPq8QDhlPpCMkzL6YpeRfY33RE4VTb8=; b=B
	1OtOjVw18ogCwfebvKeUfDCM/rGxAVGgRKZ/RyWYvnYKdGstU566FL3NkqAn30cK
	joGwJZObSZLKYM78RFxZajrselxXAtz/q9QQEjIxF58G1Q7/W6Engh/9RlSJJoER
	F1dimu3Nm1zPhXxcggthB7ze8ce35th1rCvHyu/m3dWXL4Q2MHxUeEWPa8Feoo6o
	8SiXVG2PsJG40fLX8UZbefhGGh5MLTsQhj6TUPz0K1aLncEwU1so3aZwqYFOyNcK
	KJj/SuEP9dhRHbg7zkKwDaGfpoldME6x3hW0cuFlDzcUOccrjEOdqGg7fWv7+QKF
	cYHPEl7wrrUW3mgLFJDpQ==
X-ME-Sender: <xms:of_eafoxdLfHpGWOxokw3CRWWPi857XCWlJvnnUhiw1o16yYPZ_rNw>
    <xme:of_eaVgy2ztuGCpL7o69R2YqnAQV31fHlJdaAIYEmN2W6uNJzQwTgKg3aCaZfMeGi
    oULRYHrP9GnNI3cJvExwtXQoSYSx3vXLyq4j1U0UBgKqBMaNEPutNGa>
X-ME-Received: <xmr:of_eaXtmwy0fED1dxp7MMaxcQX8gBSAOaBQo9N2D-KnAhV6-A5VmsGz7Y_J9mkf_SLbRDn2LclyXwSMp1e0DaTGUCSvTsceO>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdegvdelgecutefuodetggdotefrod
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
X-ME-Proxy: <xmx:of_eaW0OHIFilJGbo2GyeuVZOTWbXVhZUE0HB7r4zqkDEVSnHEdXbw>
    <xmx:of_eaWzLz3vDumvk5FGGYNjoCRKRuIVbgBOUM2i-J3YcYXThAODWNQ>
    <xmx:of_eaZU7KFiiVE_forxmFsSADmyCtvPnMXrWoSE8y7gVoYBNPV6sgg>
    <xmx:of_eaQBez9vQIwS--33HytLlVK_yv_a8lIkX44xF-8IByqfeSLS8yA>
    <xmx:ov_eaQ-3wiAsHTMK2gBXMMcByC0GfOEQYY_bg54tFwY6k4mMDRxRy5Xq>
Feedback-ID: i6289494f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 14 Apr 2026 23:01:51 -0400 (EDT)
Message-ID: <b7ea27db-de73-4f06-9acd-bafcd0fb7a25@pobox.com>
Date: Tue, 14 Apr 2026 20:01:50 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.10 000/491] 5.10.253-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260413155819.042779211@linuxfoundation.org>
Content-Language: en-US
From: "Barry K. Nathan" <barryn@pobox.com>
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/13/26 08:54, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.253 release.
> There are 491 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 15 Apr 2026 15:57:08 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.253-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

I took the 5.10 stable-queue as of commit
586b5ceef9af2e2148a3811f0c4814688b38b85c
("drop 4 mmc patches from queue-5.10 based on RC review feedback"),
and applied it on top of 5.10.252. This is up to date with most of the
patch drops after 5.10.253-rc1. I then tested the resulting kernel on my
Lenovo ThinkPad T14 Gen 1. It works well and I have not observed any
regressions.

Tested-by: Barry K. Nathan <barryn@pobox.com>

(As of this writing, stable-queue is now up to commit
e84a934b1e8f2f35890b51c6521a7b8678ebdc8f
("drop 1 patch from queue-5.15 and queue-5.10 based on RC review feedback")
and a few more patches were dropped from cw1200 and omap-ocp2scp. However,
the config I used for testing does not build either of those drivers,
so I don't think it really changes anything compared to what I tested.)

-- 
-Barry K. Nathan  <barryn@pobox.com>
