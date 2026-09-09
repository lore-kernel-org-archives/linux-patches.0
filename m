Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4B10136351
	for <patches@lists.linux.dev>; Wed,  9 Sep 2026 15:52:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788969136; cv=none; b=b7J0UVq2MN7Nep3AhClgAVo7BIMMGKvoG/dfWLtttI4TP+9JHEF21A204oEb1FwoVHgcoth9vUvxAOQboEDrld40EXyc9JqOfgwHCejsZdKkaL/EXWA+xUhZd2moGIpZaaJaSXq5juWX4E+XziiSlYNsuePu08tVQEfEFY1Lyoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788969136; c=relaxed/simple;
	bh=SSebE+ST6hsckt7BsoZWaCrfWED87E2Ve65oZGO3YSg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XT7thc3IqPPNQ5VEHmvJ2DWlx4kJgSnHmW45jpQfPT79prPnIXxTVRTCfKzfO00FgYGiijDmJjQG5qRsT2UTiuZJ7ujMEWOxcs9ZoM6xe6AuDLFoPK5oWvjgs4WPN4/fC2QunQCj5hQaSP1icsYGPM4iag31ZNV5XjKGPQNpSuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b=ZCJfA6QM; arc=none smtp.client-ip=212.227.17.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b="ZCJfA6QM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1788969120; x=1789573920; i=rwarsow@gmx.de;
	bh=SSebE+ST6hsckt7BsoZWaCrfWED87E2Ve65oZGO3YSg=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=ZCJfA6QMO/uxLPYoMc3J/jPyu/ecO007BVbArew0SxSP5g8Nxgta4Ac19lxMJ5Yt
	 V0u8HGdAiXyKBrdBzQ86S9i15RFJD4W1AvvETLtSiL/6/zyJGNnTHXojKM02/ykU+
	 97HPNwWdLiOWRnUFgr6uiMLnygLTHSJw3F9jFZUeXGVLH4fQkwyDng3pzQgPhKYpv
	 0D0+KXPXubMDEYQjuAJkQLSxMOp/SUYpkqtjEKvjpavU53IuA0q7W6Ri5dbyxXuBQ
	 oTURnQOIFrHAwecV3ztty85POO5z778FByl2B5EhtlxjjIbbTrRGbmN4psZr//kEO
	 XeVRoUV8nD/f+uJYbg==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MVeI8-1xEL2B2qm4-00Y3G8; Wed, 09
 Sep 2026 17:51:59 +0200
Message-ID: <510dc2b8-175a-4606-a36b-df46ae4fd6e4@gmx.de>
Date: Wed, 9 Sep 2026 17:51:57 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.2 000/556] 7.2.5-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260909134230.441546314@linuxfoundation.org>
From: Ronald Warsow <rwarsow@gmx.de>
Content-Language: de-DE, en-US
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:ubfoJgG5xRkXvMIXBAmulopwWI84MGSDrGxSdG6/y1GrvtpE/F0
 chcT6bLULSHlFQ8WezCsSjtY9Mb6SlyW1lNYqwYcqGIWdrVgVa0RVawxok7n0a8h+xKYhVz
 fnCsfApfq72eKFbX6InxBJXBGljMgQqpc1uixHB78QhUXc9NKriM56Z0YNkS59yiMzr8skf
 Zn82xeGnPSRJ2SMNQxfAA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:AUr6VetZ5FQ=;bWFfuvahG9lD4Jbh+088CsddyOW
 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
 LqAkYvnNzsWtGCR3EqY=

Hi

kernel build / boot test on x86_64 (Intel).

No regressions here.

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>
