Received: from mout.web.de (mout.web.de [212.227.15.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BDE217DFEC;
	Mon,  2 Sep 2024 10:59:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725274743; cv=none; b=lPTvoETaLrod+UTDDXaHqrb/40Ph2PRCfrupkdRVRMhLPxMjk+CaL+18FiYojcFoSdyHlt5qGXoN/yMToyh99KFbDZyfJ+X7h2Kq7XPRjJJ4EX2LwNuYG/dSpRoa+ds7cUaTRc8pl6lJMDE+Yhd/+U2dsFdViBQKpIbCS3yQCm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725274743; c=relaxed/simple;
	bh=2B1xem6LeY7zU4pbdoP3bFeSSKwEtLb0XuH00Q4137Q=;
	h=Message-ID:Date:MIME-Version:To:Cc:References:Subject:From:
	 In-Reply-To:Content-Type; b=iTPGE9grjvH/h5iFEAGlBrg3/ddsL8MsTWaoHnQSyOClMU2qHEKDECnB4DAEvc+gt8XkQ7RxlHEVZOY8RUkuRSl3u6k7EgQG6dnLczmmGoBco0xp4Nx5i3jYuMs5521Q0kqNl85+cWITQAnGHsIoaggMvUrd1yItMbdLCb/cobo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=frank.scheiner@web.de header.b=l9Ebn/oD; arc=none smtp.client-ip=212.227.15.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=frank.scheiner@web.de header.b="l9Ebn/oD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1725274709; x=1725879509; i=frank.scheiner@web.de;
	bh=EVPNt6C8o2MY2YfJMjNDfVOjEycIKBzxO1tyINT6wZc=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:Cc:References:
	 Subject:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 cc:content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=l9Ebn/oDGr1sU7FPiVSZcnaNIyNQvej1xwpZ6dYamcc7ifU5+gxw3baH3+yoTF29
	 mOYFTIcfvTe4BAmonlDE2D9VGUm5nTtbUEkHPMWEDDTKxPAGiwFe1mGLmkN3oyNGC
	 VpEelQLof7XQ3XQX4XHBCNKITskEB8BGN4snzpJjKTPQJdEy+djxZFyE5SrnRdIGD
	 sL3h8nt2HbPeLjs4H+3kyye/1VyF/w0JL2RG3QiTqXAp9uGaSd3mGPl2KYYGm35FW
	 xbCoBnPJSO0dQ0qGyN9uw/JoIm2Tqy2banGIC5c1SOJwxwQr7KHnOzhvTwB0ZLG4n
	 zwzsV/kzZ/I7KC4PYw==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.30] ([84.152.250.180]) by smtp.web.de (mrweb006
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1MD5jp-1stdUC1kxd-007DOE; Mon, 02
 Sep 2024 12:58:29 +0200
Message-ID: <4b44c4c9-4082-4c08-b900-bb0350f33fd4@web.de>
Date: Mon, 2 Sep 2024 12:58:26 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: gregkh@linuxfoundation.org
Cc: akpm@linux-foundation.org, allen.lkml@gmail.com, broonie@kernel.org,
 conor@kernel.org, f.fainelli@gmail.com, jonathanh@nvidia.com,
 linux-kernel@vger.kernel.org, linux@roeck-us.net,
 lkft-triage@lists.linaro.org, patches@kernelci.org, patches@lists.linux.dev,
 pavel@denx.de, rwarsow@gmx.de, shuah@kernel.org, srw@sladewatkins.net,
 stable@vger.kernel.org, sudipm.mukherjee@gmail.com,
 torvalds@linux-foundation.org
References: <20240901160807.346406833@linuxfoundation.org>
Subject: Re: [PATCH 6.6 00/93] 6.6.49-rc1 review
Content-Language: en-US
From: Frank Scheiner <frank.scheiner@web.de>
In-Reply-To: <20240901160807.346406833@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:E4DF1fuWRaYAxu5olsHuPYDe14pv94hm8UljtHIloBUiWrLpcbO
 4dqRBj4/hsJYYYZQwrfFhdXcLpppURq3St2wLcIRlVY3Hf96rb+s/2DbJ+2f2mXJ5DYP4qy
 RsWCdE7tQ34VPSwl7zdHv+Eb6QmAz5jSSvovwWDR1Gvv7E+6cPYMh039Q6zvbSZwihFHtZh
 RiVVwFgZpY/ugsVRR+7hg==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:WNUEySXDfY4=;+n9SgWugvlofjxS44oiRLU1liWy
 aBETsF0U0YYMHgBp7jLimhha/d+TpSdzxFSQEk338jMzivUfRNEN0j/LRC13ILP+DTtmOQYCz
 FnTVlrpuWd6rrdocchXVLsUAwrTf/cen6unsPBkVdWOtTrno486TEl45rMl23l+CUqW4kU2S7
 JnJ45EFvNtWQ/iymNglXY26Su/pTBMkr8LZxUz/ABlELI6takXOWXcpkf2dyGgNgTN1nQmsME
 /E7nY4Rf9orHnbZY4qHBS/6cbAImyGCDzAvceJ0C6wGyQ4OQBkVsnZ4T/FmMttwGS0qc7HZmI
 OKiN46LQ1VNlZQ+GY6qfj7DuikRlLOM/knAG799dFncje9jQz+WCaM7eKJpFmVY7r7V/Pq4V5
 p9nguIcMLmH2rX3Rbc8VDfUwwnlZDXcLiB8ZCleGQKX5ebDZTK53Q/QmIpVD5LscxOrDMd9v4
 DzmXaC6ltX5906mtsuSgXaQNyYCDQDnDn8HmZBEX0carMac1wLg8P/mlcd4FbaGUbLxsbfOT+
 RqDoFOJArDa1UgXaxEwRnf2KOzsA2U1IgrGgR1aWRYkc27vfoFtoQnx6IgpSt6rzhQ6AXwa0z
 A/4L6YcTVyQPttlbSU9nHvd9f1voGgKys2gRTihgDyDcSald+G4gCNeQCo6pROwfeocj4l/eh
 Fe42fINXW24DnIipIvF3A8UZJCTluEdqvE2PD2glGojGbgoVKCKiTnpeRZv+3xPwykrDq/L+n
 4jia/Ce3dL9LXrBZeBKydp/lPKcIFLDbKvHfKvD5T3As414WrC4z1Nr9KZPiQLK42wXPHuZ/C
 WYzrTSQsov3GsuKMzfGerEUvF77ofAlqn3dzd4q5PYnf0=

> This is the start of the stable review cycle for the 6.6.49 release.
> There are 93 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Tue, 03 Sep 2024 16:07:34 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.49=
-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.gi=
t linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Cross-builds for ia64/hp-sim and runs fine in ski ([1]).

[1]:
https://github.com/linux-ia64/linux-stable-rc/actions/runs/10660100556#sum=
mary-29543888306

Tested-by: Frank Scheiner <frank.scheiner@web.de>

Cheers,
Frank
