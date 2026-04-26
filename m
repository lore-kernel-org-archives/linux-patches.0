Received: from fout-b1-smtp.messagingengine.com (fout-b1-smtp.messagingengine.com [202.12.124.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4C8026AC3
	for <patches@lists.linux.dev>; Sun, 26 Apr 2026 07:00:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.144
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777186816; cv=none; b=J8mSlHSvxv78yqRuqTdrI3REIGFEE3g/k7xVhryMjIJd/44vNkd/cH4PZtH8B+/GrkeiSjB2s8l+p3Ry6mZz/0T7y2Cx/lmWWHh7u6k6sU7c++yw21uIRWYacMmZkiwHZ9i1NhYBliduKD98RuKFqTyVLnt7PBgUVeW+gY8n7hA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777186816; c=relaxed/simple;
	bh=ciJlTJSp1D/DOlHAfgTGEEo1vkiQ38XrVnQwlT8IZa8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sj+HcxM8STTdJmhjH8abeDUs/1xOMeKw7Lz3Y9BdPEX+XlnKgN8Ea0KzxMFkyqC2Dpq/WrXrOXlxckjk/uWAq7nU0g9XcIKVSlti3qiR4zaNvJtzSyGzglSj1Xo2sSDA1lW7mAO5BKSB98sam6xNayqULHzEiioB15sLtHCE6qg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com; spf=pass smtp.mailfrom=pobox.com; dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b=NOXqfWnl; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=eMuPO8zZ; arc=none smtp.client-ip=202.12.124.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pobox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b="NOXqfWnl";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="eMuPO8zZ"
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfout.stl.internal (Postfix) with ESMTP id 19EB91D001A0;
	Sun, 26 Apr 2026 03:00:13 -0400 (EDT)
Received: from phl-frontend-01 ([10.202.2.160])
  by phl-compute-03.internal (MEProxy); Sun, 26 Apr 2026 03:00:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pobox.com; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1777186812;
	 x=1777273212; bh=SVS8sKaTiw9OZs21lQz6yXgRven66NdqxY21RTnQ2to=; b=
	NOXqfWnl0pmXGpcHRqNmleFLIOyjh1ccUJteFyI6BLkQxjp2zWWZ/bmXMhx/GcoB
	y0+yVj6InEAMXJ4QTD8p61YvM+xwOCu4mBhWcRvz0KjcXAVBhqTGLhXVtYjb+e91
	Z6//+YEme9IhvGiE+7fPA2g8BUc7QQ4hm8soG0bvE1xTrm9QIpFWOzE03hncEUlI
	vIbrHppsk6EsPcyxGc/rqaZ0WPuRS/3+9sddwlMujzSsNVPGMoUr1DUj1C+lG9BM
	LwI6MM+GzYuiXK4oUTjTuY+37U/I9AaLA+T0ag01i78lLwa/33qERg8TNmM6Wnfh
	dbjFmF1xMIAEjJ94+HTmbA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1777186812; x=
	1777273212; bh=SVS8sKaTiw9OZs21lQz6yXgRven66NdqxY21RTnQ2to=; b=e
	MuPO8zZM3CGDDiDaxgEtqTzoEkxevGv17qnRdZSV1wz4KuxQwd8CrEbNy3gW5eY0
	02G8nf9KqylTDxNDk+Um5k9An7uZOBfkz2JK5Y9D2A/QLZizOfcpimthSaEUYJTH
	yC1gEJ/E+A6z14MnRsaACe4Ix18T4a3Bjp4SifK3zIkAjo1bQCn80DlN33dy6AyZ
	yzTfyapAcZv/3wcyXV4supNSAcp/01afQwmJBrBTKuMzQIg9LH5eDIbl+tu0voU5
	IqnqjRO9pYO1bkruvwfT/ioeH8dUosfPnLUX/6dliBZtVATRJR1R2a96Ea54WDkH
	dQnO7J4Zvb9WwAFp/jlqQ==
X-ME-Sender: <xms:_LftacFQ5jwQ7tl3XFRFDLrDoV8moWSXLj4I2zv5EhbxbNs-kLkQIA>
    <xme:_LftaRMXjYYRMzNqbaU14gQVSFTNiEQ-2P_EniYisWxU4V20zUmOwTeyIlv4qgY0T
    AYfMw1joWV1MHHKVB2Zaq3oUYDeXA8dK6Qwr9THPGBm3fvizVDLs40>
X-ME-Received: <xmr:_LftaRrMZdWXYNcO21oICMgHcdUA8MXFrZM20SI0A8rfqgp-bGkD83KXlfIEVxcNSem98-etMk7nja1Urxn1Tecfqss8rec1>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdejhedufecutefuodetggdotefrod
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
X-ME-Proxy: <xmx:_LftaSAtIlkA3Qg57qYgHU5YEnte0ZybAmmwZQanfm1d3hrkCdgfFA>
    <xmx:_LftaaOvA30F1Y_1FRYkPTqtE4RmeDmdiNs121digxLvSeB7T922LA>
    <xmx:_LftaQDR_Y5izVCkpyafl6T9zAgn27PW1CX3EPrSQ3RFip5SOWND9g>
    <xmx:_LftaY8eoqGX7dlGF49u2MsZiT1rhtFDqaTMEK1N7Sn8F_IFT24J6Q>
    <xmx:_LftacYvfTqESAALcOb-8_zxyw9iOG4W93zPkq9J_NfxkrGeN3tPL-Rc>
Feedback-ID: i6289494f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 26 Apr 2026 03:00:10 -0400 (EDT)
Message-ID: <e06c1220-3d3d-4dc3-8778-a35a54e91391@pobox.com>
Date: Sun, 26 Apr 2026 00:00:09 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 00/55] 6.18.25-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260424132430.006424517@linuxfoundation.org>
Content-Language: en-US
From: "Barry K. Nathan" <barryn@pobox.com>
In-Reply-To: <20260424132430.006424517@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/24/26 06:30, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.25 release.
> There are 55 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 26 Apr 2026 13:23:22 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.25-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested on 2 amd64 laptops and 1 arm64 virtual machine. Working well, no
regressions observed.

Tested-by: Barry K. Nathan <barryn@pobox.com>

-- 
-Barry K. Nathan  <barryn@pobox.com>
