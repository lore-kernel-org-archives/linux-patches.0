Received: from fout-b1-smtp.messagingengine.com (fout-b1-smtp.messagingengine.com [202.12.124.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 658772C21F1
	for <patches@lists.linux.dev>; Sun, 17 May 2026 15:03:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.144
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779030239; cv=none; b=ZvQVcyv8eEJoa+EqFtSqkcJWDDG5PKqIFt094v8aBFuw6L4OC+PrQf8zYCEluH0/lLcRkmkcst5Ziqe4wT8XrEri594Y2/rGiUc61v1BUEoAYmCyXVVBhAKr15SrfFTdWsYkOx1XnO83t9lC6HkDX0j9SIduCzgAHXs2sqxJGhQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779030239; c=relaxed/simple;
	bh=LWnaYu+moDKVGVFbOqLV7F5kZTdYVtQHeWavTvTfy2k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=n6kp/psE2u6NWIoC+j1731k49oneW2egQuiFPV/vrAauO6NeKdRRSem29WnKDg/KdMPebcDxDBpMcDllGiaJ2YbRIak0XLWFF6ikW2O1Wrem7kjmWh17IKVQyZzEU1cLb7FYV/Kmf+uWef1DQQi2wTc9GR7An4KhZnOHPFss9j8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com; spf=pass smtp.mailfrom=pobox.com; dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b=L9H9DFe9; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=ob7uqjKh; arc=none smtp.client-ip=202.12.124.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pobox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b="L9H9DFe9";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="ob7uqjKh"
Received: from phl-compute-09.internal (phl-compute-09.internal [10.202.2.49])
	by mailfout.stl.internal (Postfix) with ESMTP id D942A1D00087;
	Sun, 17 May 2026 11:03:56 -0400 (EDT)
Received: from phl-frontend-01 ([10.202.2.160])
  by phl-compute-09.internal (MEProxy); Sun, 17 May 2026 11:03:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pobox.com; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1779030236;
	 x=1779116636; bh=xaMXhyqz+SZNDhzmtIfosQ7fpeNzKwiThvo5+Ali8f0=; b=
	L9H9DFe9k5Kdw3KQPG7ufPcW4WQ9vhsWvkCW2qRThnADst/enYsLu0Q4+JKQVm5X
	hSvyn9jvHJlRFdtZze9HknZzRKgYKNkqYIrnHAXxNd2AXC6opw9zA9m5CoS4BfBk
	Wn5n+2U/n2qcsIfOsioPUxhaJhh74T7wLtjZUF0Fql4yicEHcVG7rPajI0bkSPUW
	H+uPE/j8Az7ueCxST2mPc0pnDCm5bM2KU5HWgGhK2Uf2PaYqpnCfxZtwpBRXTING
	ExLqZQf1oeA2Z0A6tVBhstTiHw2YZZStZ0MMZn+pmxCalmMTAkNp8XopOlgQzGfu
	nVFq8or3wUnyYz9/NWJ5YQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1779030236; x=
	1779116636; bh=xaMXhyqz+SZNDhzmtIfosQ7fpeNzKwiThvo5+Ali8f0=; b=o
	b7uqjKhRqzvmb5IdweXGnsU7y6Fnoq1ulTkhGsMEAg9twdYh+Mcwxs86uebvP6T3
	3BaF5zEPnn5U/WxSOdClW2QuGWI1oYKw4y7y62FO8WMxETIMwKaIhcDejBKNFlmX
	4L/9HII/qf/34Zntn+fiVzEgVbPloe1rHpuANSaEmfqcjgZLsfoG4SZU/CCYJFVa
	wr2ZA58HCgXtDWkf7WHuvWKbh4P/2kDlc5ts+VrjfFROeZoT80/oiiPipI/A+Rra
	zpRfi07XRAl3Lrmx/1loQNtduADYZX0fOSS4ulBcHRndp/BxG7pFOiIxE94dA2fG
	XUb0mf2rLwVrRuK/6Z92Q==
X-ME-Sender: <xms:3NgJaujFTNaB0weFIXwuL0Y4zrAUAVIA04tKKyxCYK8Uew5-bKncnw>
    <xme:3NgJasuacuM9Bw5ECuDBD7nbBuf3-yyXIcMEt52QQbN7TcTddW7N_jC62M6PtOWNb
    tO-UbmuqKPGG10ciTNCUVixVEkLnKsSy_qyOYIHGW_X2cQ6WLtpFHM>
X-ME-Received: <xmr:3NgJan00dd-lut5ZWg-tn7f4TSzZqigTb-BNcr5XbBJDU6p0lyPbZ0yPvncn3DIK1yRy2_BnPd5OwK52NY2DXk-ZoRIw1tmy>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgddufeeivdelucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepkfffgggfuffvvehfhfgjtgfgsehtjeertddtvdejnecuhfhrohhmpedfuegrrhhr
    hicumfdrucfprghthhgrnhdfuceosggrrhhrhihnsehpohgsohigrdgtohhmqeenucggtf
    frrghtthgvrhhnpeefleehkeehleekjeelffefhfdvleejteehledtieduffevteffleet
    gefgfefhjeenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuih
    iivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepsggrrhhrhihnsehpohgsohigrdgt
    ohhmpdhnsggprhgtphhtthhopedvtddpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtoh
    epghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpthhtohep
    shhtrggslhgvsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtohepphgrthgthh
    gvsheslhhishhtshdrlhhinhhugidruggvvhdprhgtphhtthhopehlihhnuhigqdhkvghr
    nhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehtohhrvhgrlhgush
    eslhhinhhugidqfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpthhtoheprghkphhmsehl
    ihhnuhigqdhfohhunhgurghtihhonhdrohhrghdprhgtphhtthhopehlihhnuhigsehroh
    gvtghkqdhushdrnhgvthdprhgtphhtthhopehshhhurghhsehkvghrnhgvlhdrohhrghdp
    rhgtphhtthhopehprghttghhvghssehkvghrnhgvlhgtihdrohhrgh
X-ME-Proxy: <xmx:3NgJajxgt7Zj_RaAN0ER5Sy5JJN67lUFpmrlBgAshmem38Z7bkL8Kg>
    <xmx:3NgJaiV4NQye06yCzeaJZWJHbB2jf2ld4HF_GhJMJ6-I6fGzBVnPsg>
    <xmx:3NgJalCHmx7oo-lNCaYSUhTnc8g-SV_Pzh_1fKEHid_d8V9221ftbQ>
    <xmx:3NgJaj4xmavfjXuIfKrd1GWOg1Z2UonvznHExwUT2oepx1T6p7m7ag>
    <xmx:3NgJat9gYvTAWOhYjWpQ2HS4aJcXSP5Bgt9zPED29y00F97H39VNOdCU>
Feedback-ID: i6289494f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 17 May 2026 11:03:54 -0400 (EDT)
Message-ID: <21ca47ff-a636-46b8-b58c-6f28ace4b4e7@pobox.com>
Date: Sun, 17 May 2026 08:03:53 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.0 000/201] 7.0.9-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260515154658.538039039@linuxfoundation.org>
Content-Language: en-US
From: "Barry K. Nathan" <barryn@pobox.com>
In-Reply-To: <20260515154658.538039039@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/15/26 8:46 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.0.9 release.
> There are 201 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 17 May 2026 15:46:37 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.0.9-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.0.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested on 2 different amd64 systems. Working well, no regressions
observed.

Tested-by: Barry K. Nathan <barryn@pobox.com>

-- 
-Barry K. Nathan  <barryn@pobox.com>
