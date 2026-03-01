Received: from fout-b2-smtp.messagingengine.com (fout-b2-smtp.messagingengine.com [202.12.124.145])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7434F2773D3
	for <patches@lists.linux.dev>; Sun,  1 Mar 2026 16:43:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.145
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772383431; cv=none; b=JEZ0J5htopBoc0oiUMenCNC1wUBC//UmhdDHnYtf1srqu3fVUUidVfPHhKU1hdYjEC1KW2gvEe7X0BfENFhpJZhhH9kWCm8tun5LhEzRwgVU6crXYsSvmf61pNa+4N1QQXgeRmxmbO5/JTOv2yN8TwVk4ksZxW9+rYGHxHOQqJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772383431; c=relaxed/simple;
	bh=zKXWDPgm0KPVWYaLKYUuwFJ9zNLf8brpKTooPNimpxk=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=dq1fREj0Y0dyaZG1IXJaw1cHPBsSYL3VIuVdJnxfm3G34mACF/3XgSO+t5/+1PX4i7ULQnM5LxLOoWDhlL8aFj7bPHWFMIPcTF0K4av8y6COEOoQDJqwyBl5P+elqa34sdTKH3V7q78g0RBb9/XSwYjj87EQZ6JiHB+H7ZauDss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com; spf=pass smtp.mailfrom=pobox.com; dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b=IYTZQaa3; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=xkvo6VRN; arc=none smtp.client-ip=202.12.124.145
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pobox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b="IYTZQaa3";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="xkvo6VRN"
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfout.stl.internal (Postfix) with ESMTP id BBB411D000C4;
	Sun,  1 Mar 2026 11:43:47 -0500 (EST)
Received: from phl-frontend-02 ([10.202.2.161])
  by phl-compute-06.internal (MEProxy); Sun, 01 Mar 2026 11:43:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pobox.com; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1772383427;
	 x=1772469827; bh=3TyE9bze55O1rfqf9ChrdG6CnxVHihNnBi+Beiuiie4=; b=
	IYTZQaa3fMMjbLiH+irKDKu41evVvTM/WKmX5a0QgV/e7s6ygStd16FBcyxxypzw
	HLANtdfzc5ekm/SolR3Fdr75nnWreuGWgjd3zc1fLf5/jnWYvpCtKzxTBri/v044
	GDdGefQo5Y6KtHx0HYNCeKWvM26Nhngehw40aEtA5CcWN5l968UmlleAhf8mn7LK
	HHV+MUuXm/rOgqoHrRnEtNae/5HE57ppQJXQATYnYHfUBjX8Fochw1SEDY9TjAzu
	KtQFzB3joa41eCBIwpY3r4wGTbtHXmixGP77nEuuz1hece1UOcL5WAgCNjd7xViQ
	9DrZ5dddSx+1NFSV1fIoXA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1772383427; x=
	1772469827; bh=3TyE9bze55O1rfqf9ChrdG6CnxVHihNnBi+Beiuiie4=; b=x
	kvo6VRNFsJccy0MeIR1lzKWi2axNAtVxBJLevM7wKDhKDd8D1qBieEMcBBayPNyS
	YkcNf3k8wcyn5HPfeTC051c8SDSdakb754MkxhezuZc53DXWQX7CV/K31UeJDX6d
	OGVTQJ+dVxCu9BqjtPtuk3PGpE+ykQlJFeJ+GioJIJeiMqnM59QZK00ke+Bi+q/k
	SpO7ZRdxmcscgVV+aQVQ6+DxcLqq92hIju6Sf/WUtmPuJBLUBfbCNGt3M/tXb6Sd
	pHONVo5Rc1n4LOQU8L+r2IRUT//J8ph23wDugqjpumzIx79ieo9PnbYznDWHp4/8
	I9bqIGvMf5J34VSD1k9Kw==
X-ME-Sender: <xms:wmykac-44X-KVtAFjinpOI54o6eHYTJK4U5AQOiA0tttMfhH-Mj-eg>
    <xme:wmykaVFeCOqThKo2KxpLB1L1ibOLEeml-ppt9qNDtqyWf9NbYZwDeFVyLk4xRjZlh
    7Oh9pTBhKg9SOBLmsQ0eV5pMhd77s95cgPVaU91MR-rf1HPsAJhtC8>
X-ME-Received: <xmr:wmykaTL8stm6KUvifwxp38zVent8qXMC5qXU_yu_a1Jw1RrHvfK4Mlnw5R2Ohqiy74T1d59mqQtQF54GM42pTmuKgBifFA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvheehfedtucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepkfffgggfhffuvfevfhgjtgfgsehtjeertddtvdejnecuhfhrohhmpedfuegrrhhr
    hicumfdrucfprghthhgrnhdfuceosggrrhhrhihnsehpohgsohigrdgtohhmqeenucggtf
    frrghtthgvrhhnpeduvdeuheevffetfeegteeuieelvddvjedvteffhfeiffehhfehiedv
    gedukeekudenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhroh
    hmpegsrghrrhihnhesphhosghogidrtghomhdpnhgspghrtghpthhtohepvddupdhmohgu
    vgepshhmthhpohhuthdprhgtphhtthhopehsrghshhgrlheskhgvrhhnvghlrdhorhhgpd
    hrtghpthhtoheplhhinhhugidqkhgvrhhnvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhg
    pdhrtghpthhtohepshhtrggslhgvsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpth
    htohepghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpthht
    ohepphgrthgthhgvsheslhhishhtshdrlhhinhhugidruggvvhdprhgtphhtthhopehtoh
    hrvhgrlhgusheslhhinhhugidqfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpthhtohep
    rghkphhmsehlihhnuhigqdhfohhunhgurghtihhonhdrohhrghdprhgtphhtthhopehlih
    hnuhigsehrohgvtghkqdhushdrnhgvthdprhgtphhtthhopehshhhurghhsehkvghrnhgv
    lhdrohhrgh
X-ME-Proxy: <xmx:wmykaYf-s_dIrurNOZfZF6K0kEHqp1dhUK5ZSOoxtuK-UX7Dag2rPw>
    <xmx:wmykaQWu83_Y3yexve4DlA8JZQWpacTwzAT8U4M4logWTdh6Th449A>
    <xmx:wmykafE9cdYMc8BIvqditvCaVZz6QIDH3pzTcucfHhl203cEc3_Dqw>
    <xmx:wmykaRWDL2q7VPqH7rLr59xsIQRAo8ZvF_Ee6cemmokq5Dbwq6O50A>
    <xmx:w2ykaZID5eFvUQvS_y3nk-O1cWcJfUWO7r_5LFdo8PHHv1yKzylnrtje>
Feedback-ID: i6289494f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 1 Mar 2026 11:43:44 -0500 (EST)
Message-ID: <bf650251-9254-4d42-9224-0b8db08042c7@pobox.com>
Date: Sun, 1 Mar 2026 08:43:43 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: "Barry K. Nathan" <barryn@pobox.com>
Subject: Re: [PATCH 6.19 000/844] 6.19.6-rc1 review
To: Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
Cc: gregkh@linuxfoundation.org, patches@lists.linux.dev,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260228173244.1509663-1-sashal@kernel.org>
 <9623f4e6-41b4-4dc8-a6ff-cf0de3604dfb@pobox.com>
Content-Language: en-US
In-Reply-To: <9623f4e6-41b4-4dc8-a6ff-cf0de3604dfb@pobox.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/1/26 00:49, Barry K. Nathan wrote:
> Unfortunately, 6.19.6-rc1 won't even build for me:
> 
> Warning: drivers/gpu/drm/i915/intel_wakeref.h:156 expecting prototype for __intel_wakeref_put(). Prototype was for INTEL_WAKEREF_PUT_ASYNC() instead
> 1 warnings as errors
> make[9]: *** [drivers/gpu/drm/i915/Makefile:449: drivers/gpu/drm/i915/intel_wakeref.hdrtest] Error 3
> make[8]: *** [scripts/Makefile.build:546: drivers/gpu/drm/i915] Error 2
> make[8]: *** Waiting for unfinished jobs....
> 
> This only happens with 6.19.6-rc1, not any of this weekend's other
> stable rc's. (I'm still testing 6.12.75-rc1 and 6.18.16-rc1, but
> they're doing well so far. I have successfully built 5.15.202-rc1
> and 6.1.165-rc1 but I won't have a chance to do any further testing
> of them before they're released.)
> 
> As soon as I can (in the next hour or two) I'll minimize my config
> a little to shorten the compile time, then I'll start bisecting.

Result of bisecting:
first bad commit: [0ef5d235ab57bc90831ddf38eb1742ff68f345e1]
docs: kdoc: fix logic to handle unissued warnings

This commit breaks the i915 DRM build if (and only if)
CONFIG_DRM_I915_WERROR=y, whether CONFIG_WERROR is enabled or
disabled. However, the "bad" commit is definitely fixing a real
bug, and this build failure doesn't happen on current mainline
as of this writing (commit eb71ab2bf722), so I don't think
dropping the patch is the correct way forward.

Rather, adding commit 524696a19e34598c9173fdd5b32fb7e5d16a91d3
     drm/i915/wakeref: clean up INTEL_WAKEREF_PUT_* flag macros
(it applies cleanly) fixes the warning, thereby fixing the build.

The resulting kernel works fine in my testing, too. I'm using
6.19.6-rc1 + 524696a19e34598c9173fdd5b32fb7e5d16a91d3 to write
and send this email from my ThinkPad T14 Gen 1, which uses the
i915 DRM driver for its Intel integrated graphics. (I also
tested it on my 2017 MacBook Air, which also uses i915 DRM for
its Intel integrated graphics.)

-- 
-Barry K. Nathan  <barryn@pobox.com>

