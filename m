Received: from fhigh-b6-smtp.messagingengine.com (fhigh-b6-smtp.messagingengine.com [202.12.124.157])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 106F83E6396
	for <patches@lists.linux.dev>; Tue, 14 Apr 2026 16:20:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.157
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776183640; cv=none; b=sqicl6AwR4ioPpINeRcNgFFItTlWg9GDuWYcKIuRkznHiQ+trkUrHvQ0nB7B6mbsFkUKc+D+OIUUw6kAKAdtfJLdXEWKwQb50cYznNk5wzJlGyaAaVUFG5UJhylH8CjD+5EjgxtswM2A+20O3pvUVtQzfLS+tr6a7xCJJRv4/Wo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776183640; c=relaxed/simple;
	bh=Uv0aP9gCVayIC0/H2A4hF8SRhOWQloeCyjee52GmJyw=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=R2e7OhwuXL6S+JTl1PPbzwIGf3yimCRWYW0PN3TRIzxAI0psGug6XdUh4bhxBGddMT27+EYH74z51sZJ4uYRCTHgARkO18eb3dKLG9e79oY85SvDQddn969yTiFI+DOLQ4Z7FZincaopOEy20iQkLJ1DL/FZtl74H6+OTyM+YA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com; spf=pass smtp.mailfrom=pobox.com; dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b=niREzWpP; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=jycQq3du; arc=none smtp.client-ip=202.12.124.157
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pobox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b="niREzWpP";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="jycQq3du"
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 91F3F7A011E;
	Tue, 14 Apr 2026 12:20:37 -0400 (EDT)
Received: from phl-frontend-01 ([10.202.2.160])
  by phl-compute-05.internal (MEProxy); Tue, 14 Apr 2026 12:20:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pobox.com; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1776183637;
	 x=1776270037; bh=qcYlcBKMocC1Ezo583l9MC3Jydp+KBfbQyv6M9e11O0=; b=
	niREzWpP5eXbveXz5bshzJZl4DWeuDw8BSgOdOGRkcjgZ8TrHM0C19B/r8EMWEzT
	zyZX2ocwIMz24o7DwC0FTqeSHChMaaSveRXE+tXip6FJu1Xt0VQyVH+IHhPC4gQj
	EriVdwRdCsNqksPXgP7qtP+mLKWITm7SALlSDxUJX3RNWbPPxvObmZhsPCzIYqTD
	RgRMUBZcn52B5zBSeYYJnG2IZ3YOUIrdmo5RT5V0tORmeSnpSVSTonZQRF8j3DmS
	1LYF7AA9euQMSR8khcHCvNqguqlbPdujGGhOUaVj2BnQmGPEfg6d/bVsNsrDOEpV
	9qmi3kvR1yDrhjv0cO3Vzg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1776183637; x=
	1776270037; bh=qcYlcBKMocC1Ezo583l9MC3Jydp+KBfbQyv6M9e11O0=; b=j
	ycQq3duG+NehVW5KV07cBdVUitkNy2h/Eh3pbTczdMr09HgGVyTGxhxtV3Ps7MIq
	rr/CNXXanwDdNENnIPgghKmNPoBpH3pJ8jDeqDhR0M3mS24slgJlCOeuQDc8wTBt
	SrK1PgmpI4F7NzXpe12GRlTzGLsXt/7aFOgDv4bYu97FYt6+7yAJWZH9IGbOQgsO
	rEJxK5T/kiAX6cNCeU1LWCmFo5ubEozRSQiwRw4OnoOAttbpFv1G3z1KppfFPnzG
	S85DfRe0DDg+Q2eaHnIFJkx9E4KjWH05VQs14pnYmJRcyU0b2ggjZoD1ZEsCy8en
	fyv2EUBgFFxlyvTMHWs5A==
X-ME-Sender: <xms:VGneaSxvF3p5-hUPrWBjdWD1BaP_h2p1Opmh6peaxoZmoEgH5-m6eA>
    <xme:VGneaaIsb4rgTwDlZOrSJWwKXh4zREMVGl5Vwbs-qOoVTwBj7kEI2VcDeZ_2NdxvA
    8yo9BnKqX8Yka_2Xt8bpDLjxL7GkyVDlMAWI6oMfQo7PvTUlp35ZA>
X-ME-Received: <xmr:VGneaf1z2306f7kLPdC5Qurvo331fuZlbGzM6wQ_b-xmOeN0EyBFAI5XiKixT7OIr5lZjznR6I-5__LThFCvvzSQTN79rBhk>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdegudeivdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpefkffggfgfuhffvvehfjggtgfesthejredttddvjeenucfhrhhomhepfdeurghrrhih
    ucfmrdcupfgrthhhrghnfdcuoegsrghrrhihnhesphhosghogidrtghomheqnecuggftrf
    grthhtvghrnhepuddukedvieeuvdduvdeglefhledtudfgtdfghfdvkeeuteegvdefjeet
    kedvueelnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomh
    epsggrrhhrhihnsehpohgsohigrdgtohhmpdhnsggprhgtphhtthhopedvtddpmhhouggv
    pehsmhhtphhouhhtpdhrtghpthhtohepghhrvghgkhhhsehlihhnuhigfhhouhhnuggrth
    hiohhnrdhorhhgpdhrtghpthhtohepshhtrggslhgvsehvghgvrhdrkhgvrhhnvghlrdho
    rhhgpdhrtghpthhtohepphgrthgthhgvsheslhhishhtshdrlhhinhhugidruggvvhdprh
    gtphhtthhopehlihhnuhigqdhkvghrnhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrghdp
    rhgtphhtthhopehtohhrvhgrlhgusheslhhinhhugidqfhhouhhnuggrthhiohhnrdhorh
    hgpdhrtghpthhtoheprghkphhmsehlihhnuhigqdhfohhunhgurghtihhonhdrohhrghdp
    rhgtphhtthhopehlihhnuhigsehrohgvtghkqdhushdrnhgvthdprhgtphhtthhopehshh
    hurghhsehkvghrnhgvlhdrohhrghdprhgtphhtthhopehprghttghhvghssehkvghrnhgv
    lhgtihdrohhrgh
X-ME-Proxy: <xmx:VGneaceaVGeaA0YLnxCN-ZAqaQYerrm_8_b4JG9PResZWnNZZTkF2g>
    <xmx:VGneab5p9L4hCtFbVcSgSGfZeCi8M53a4IOeEFDz2FY_HyDkMZ-I5A>
    <xmx:VGneaX9QleT-bGsXCws_lX3sVu_-FeVuuFRCFjITF-aXBzlh3YVcZw>
    <xmx:VGneaaKBw9oRZjybhz7G3MuEWLxXM4dhhVRHl4rOIgpkXixHhRL0WA>
    <xmx:VWneaTksJ3R6Z3l7_400CF0j7QdJGSarFW6SOu9aZFaw_3qJ_TbmUnD_>
Feedback-ID: i6289494f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 14 Apr 2026 12:20:34 -0400 (EDT)
Message-ID: <310172c6-91ab-4dfa-92ed-6be05ae78132@pobox.com>
Date: Tue, 14 Apr 2026 09:20:33 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Thanks for AppArmor fixes (was Re: [PATCH 6.1 000/312] 6.1.168-rc1
 review)
From: "Barry K. Nathan" <barryn@pobox.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260408175933.715315542@linuxfoundation.org>
 <be550d5f-a5bc-4cab-aa75-1c7481ba39c8@pobox.com>
Content-Language: en-US
In-Reply-To: <be550d5f-a5bc-4cab-aa75-1c7481ba39c8@pobox.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/10/26 01:29, Barry K. Nathan wrote:
> However, I'm curious about what's happening with 6.1.y and the "CrackArmor"
> AppArmor fixes. As far as I can tell, they're still not in 6.1.168-rc1
> (and presumably won't be in 6.1.168). Assuming it's not too early to talk
> about it in public yet, where does this stand? Is it just a matter of
> waiting a bit longer for stuff to happen behind the scenes (or for other
> bugs/patches to be dealt with first), or is there something else going on
> (such as a specific problem blocking it that needs to be resolved first)?

I see that these are now in 6.1.169-rc1 (also 5.15.203-rc1 and
5.10.253-rc1). Thanks!
-- 
-Barry K. Nathan  <barryn@pobox.com>

