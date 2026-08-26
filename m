Received: from fout-a2-smtp.messagingengine.com (fout-a2-smtp.messagingengine.com [103.168.172.145])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC3273B83E0
	for <patches@lists.linux.dev>; Wed, 26 Aug 2026 10:06:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.145
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787738768; cv=none; b=sv4r6ZxLJ2NKsWR7xCXedcPHYmTP1mxX8LhOQKHW1N8KSTA65zWD5gCfreFb/kvygAF22YfmdnpUEev7xozQe00rPHTAzUCeFc3v06E6oWPbNYr5qIrpeG9sUpUe9xr/NuqmmqZiZ2SdaMYZBrp9z+4A7n3mDmxKMt4U88QnLvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787738768; c=relaxed/simple;
	bh=le8OMlTOlsxaAIB65m7aJDrRyIC/2Kxw1/mA7tkT8F0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UcoXFeqXW1LgID1d+qcAoVmncQnDTU+vj4b7zOzW9akEHI4BSbV+ZJaaiBludW+Q12wL9nhysZpGml9IbtrAmCN/L79GsZaq2uQtDN5nYUsznw84mjb4aA5NMQIawf327Z6SDj5AJGJXlOQDCNVQJXG9FUSSRTxkTOnlMoojzyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com; spf=pass smtp.mailfrom=pobox.com; dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b=VyOtJj+W; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=RUypcvU0; arc=none smtp.client-ip=103.168.172.145
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pobox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b="VyOtJj+W";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="RUypcvU0"
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfout.phl.internal (Postfix) with ESMTP id C32B5EC00E7;
	Wed, 26 Aug 2026 06:06:04 -0400 (EDT)
Received: from phl-frontend-02 ([10.202.2.161])
  by phl-compute-03.internal (MEProxy); Wed, 26 Aug 2026 06:06:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pobox.com; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1787738764;
	 x=1787825164; bh=A/t1h9nEp7GIUkieJCgOemdJENah2+btWKbk5oZfpAI=; b=
	VyOtJj+W9c5+RuU0Ip2jOleaAB1b51ILtd13c3cQUYFqVdfyAeyURKYPefrXpUqV
	bnbLHo5PBNhf67UVFpI3P63/1IyyCol6f31N2OL9z+HMsDIej9Fbu5NWZqewZQmc
	hufwuz7G16T4KvLtyRjKdYyZKPh02V372f7gJpHsUlE9msB5jW+ufyYiC5SB2iB3
	mEECOuHPMvdUogHY3LLZtsYoF1zvRRFGUH9mjt+/9AoQu9k7Li2RLGLVWY/UqrUz
	J60I16LE27MB0ICx1SXWQpgSy0eNt5svE+afrLX45YjJzECWfZQOAr/9ZVOQg/rc
	/3PUxI94vrCbd8LbEGg1Og==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1787738764; x=
	1787825164; bh=A/t1h9nEp7GIUkieJCgOemdJENah2+btWKbk5oZfpAI=; b=R
	UypcvU0GwYDVHVJu56GdnDh8BEh2GeHknxTIe3AaDfRdc8V7Ay/GmiM5QMuI1kDb
	OVNhZGwA1/Dv8HQhcqgigSnQR0zDY5uFc/sIq6WqYiLaEfwPXpC/qc41cIY3tz/S
	lLVx6+CGQ492dVAduG8+cWOe9ZHGwPaAGe1QRJuFx4JcjVVzj66pdyPa1DXldSCd
	9h931Wer2/blw6yfM9Ryuq26FbIQJFZasdW1mvb3aCED29KUupabC9/QYWcYKW0P
	8ePL+xvDilmVVAi+dNUNnekZZ7W6vQa9O50tl+wb5i46oY/bcgFUcpadfEcd87el
	iic9mMoITuU7qI1eDj6qQ==
X-ME-Sender: <xms:jLqOaisNExAES1rEQcRgxUpkWFulosaUiBswlFI6n6ZabpDr57Oijw>
    <xme:jLqOajWMmD-ZC2Q1vUswmGdnRamhaktt8QmQfV8RZVScXi2S_JMe00v7Ppcz7L7Sh
    FLxKwXomtT-MjKw9QbQbwhJUFzs2GXTkCmtFig5V0ATgwPHNHUO6MC3>
X-ME-Received: <xmr:jLqOapQ322Fbryi9ikh5CXRBYgUyVgSPiJC454jgldhzsahTCMWZULKjth3ECKnc5HH9ZRWe8lH0N33QaWBqM4OTCsFn7PoJ>
X-ME-Proxy-Cause: dmFkZTGuzYL1BNN0QJqYzOk4WDsr7ywCNBSvbQ3C2NmgDEJwIaAPX8Mv5ou/8X8FumRP4F
    X05UJDj3n2W0RW8YUR4KR4sgDkRrSM2Fm/k4Khs91rNbVl5RxfMPYwYhFbAL4BSOL/FPmz
    pAWLJeYNziONAmfC5fotiu1i5MAKd+gle3GUZCKyeJflYMdRCzKVPUw3Z+Pbad3wRlcAb2
    u3zUF6dTWP+ANQF/TDbweRRmnqVUCu2g+0YzCZ9ynLsR11yHQ/U+5uaLf4axQIQ/pvwmcN
    Bc/KnmcMf6BSXgPz8el/pMNqGNmQ0p8lyZbs5yqN3KjZgVeHJAlcSw3VYPbr7FfZVwpknI
    mbVn+yjCjop9b5w4Cw5htzZji7zI+UDIGrj+Yl26KPCil9/6J1rewEco5iXZpmiJ8j+rz2
    +Ayr+0G3eMZiQMB/DqqWC1Xr4Zbx8dkhUNXOsOgY3hx7AJL7w5GXXKwPSCAPQPsWdvvedJ
    l1RJxvqGENOMaLLoQSv8G9gEW7kcV6fTWyGWIx7vd5Ls0FoJZmROkCbPOAfxzPW7jHMlAY
    lQ+hVlbkYem486wSiGKvdtHFuUhBowdjZrhoH5D58ClQ3WNl2h4t9g0W34MNMyPEtx1+Bs
    epXdZbUPpRoqduN8I6O/hsYFit8qLEnwlKkr3CX0ly8eM+sIDRgeQ/kAGwXg
X-ME-Proxy: <xmx:jLqOahKMKIYtW5Uj7tyo62WJeI231ShtNUNLQzsDH9G0vLOFlSCXRQ>
    <xmx:jLqOaq2IH8W8TH0UEGv-JOFjUZXOMJ2jud_MEuhkiThUXsb1-9agqg>
    <xmx:jLqOakI2EAnPkere37xuTnGdrgODW4BiCU9VmVsFCW45Hi-BoV8Kog>
    <xmx:jLqOaqmHSLfev-qr3qovNGJiVoCaJQsJUokVHOyca29DZlISZwCemQ>
    <xmx:jLqOaujkRIohUIo23UDIcVdNj6e9RLUPM4U4ZqfbJEvrl_fpFebN5t5V>
Feedback-ID: i6289494f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 26 Aug 2026 06:06:01 -0400 (EDT)
Message-ID: <dfc986ed-6e89-420f-b281-d0fb3e6dbe11@pobox.com>
Date: Wed, 26 Aug 2026 03:06:00 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 00/87] 6.6.154-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260825132541.813800447@linuxfoundation.org>
Content-Language: en-US
From: "Barry K. Nathan" <barryn@pobox.com>
In-Reply-To: <20260825132541.813800447@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/25/26 6:25 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.154 release.
> There are 87 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 27 Aug 2026 13:25:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.154-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested on an amd64 laptop (Lenovo ThinkPad T14 Gen 1). Working well,
no regressions observed.

Tested-by: Barry K. Nathan <barryn@pobox.com>

-- 
-Barry K. Nathan  <barryn@pobox.com>
