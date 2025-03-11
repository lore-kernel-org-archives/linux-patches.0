Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D3A11C3BEB
	for <patches@lists.linux.dev>; Tue, 11 Mar 2025 15:15:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706131; cv=none; b=ro0PreFgyDmkKsYaJRm1yXvzjQDunSnKm95JwsINqrFSjqjG3FHi2oWdTdIM6F9F+3AVZ8OxpIm8L9zjfUNW6t609cIXV1VrUN/Kq9Uf2crEshLopeVz3NWaN+VLniadLVg4nmKg39Y7UQ/WlHc98JWfiauNE8QRuhOROsos48U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706131; c=relaxed/simple;
	bh=HtuFhXI63urBA3dRKYyXQ6GHreCYVeNttV6YM+zDLlM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eC+FPtp9BB8+SoKNKWqndiSkHvRqdrKJZj1n+Se7cp7B3Q0FNDwj7PQmbeOQfc7IWY187iNigxS9bxAJBskKNuqS363Sooko7OoTW1OQ7EHJLm1YCkf4vvohNhq++f+IMTSlJrhT7JE+CdFP2kjtGGeSGHGLoTZoGy3yRImFsI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b=fH4zVI3k; arc=none smtp.client-ip=212.227.17.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b="fH4zVI3k"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1741706126; x=1742310926; i=rwarsow@gmx.de;
	bh=HtuFhXI63urBA3dRKYyXQ6GHreCYVeNttV6YM+zDLlM=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=fH4zVI3kI6XIc19fwiwSeNsWGSB2gy1m8YYiPUnOn3sJv6Ew86o99x/zyiB7Hqv/
	 cdGocUAYYNIPULxbLrWlA7L3b/bwn9fsXZKdy2AaMsN5TYZJW0xGV9dLfetYRyztr
	 Ln+gcb1N0ZgINg0/6dsJ12Q5gj0Yc+758Ncg7bHXereZ+r88SMolvP2d9bwu5VVkx
	 MffGuNJrT1YEbdorKDQPe/8/3tjLSedtVS77EXwxugSHmSszcF5O81h0Fd+42X+C5
	 oGtGyfMjzbp6NtdmE7ELUvAVfi6Ux4Pm1g88QHKKJaQz34UnIVzM7dwnBtcX60toZ
	 okXUV+kb9yHd3srsUA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.200.20] ([46.142.32.160]) by mail.gmx.net (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MJVDM-1tcYsA1qAK-00RmpX; Tue, 11
 Mar 2025 16:15:26 +0100
Message-ID: <f2ea4017-5a57-4fa1-aa73-90b3bfb699f5@gmx.de>
Date: Tue, 11 Mar 2025 16:15:24 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.13 000/197] 6.13.7-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250311144241.070217339@linuxfoundation.org>
From: Ronald Warsow <rwarsow@gmx.de>
Content-Language: de-DE, en-US
In-Reply-To: <20250311144241.070217339@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:vTh0HqMWvP97ZqYVTQnETiTjR4dbW50Q3/iHpaWoQOc1nz7Jhs/
 pfwhYsRt0FiYmhy5pJGe2LkSAMPaVOv0lkcD69vVZyREpK7jqlFSdYV/ptUgafIXyLve1sH
 yUH5UhX5H/HLOfrA0SCo7cAusrYznslTvACBk9Ancz3ldcZEYV6QQIh9G273TRny97T7fU4
 lhBRqyOBZQ0qjQvDbA+OQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:YMPeiVQDR+Q=;KSuoMgpqlYg9R+ln+HdzfFom8PU
 P++JvP7awCR86BOe0QepLLFH/h74LohQkPC5GuPYOtTnUho2H5wxkHcBqa2hJ22HqV3RoU/Hl
 WSrgG62dl6c+ThpnrMCMsF6a726voxKJZQXUDS1gkHattw6LS/5kiaEqQ5VJbIfCgQGMUFbW6
 PbJhW7FyYSU7kmBG3na799G9KLECo239WiiVF2lLz4W+Fl+WEUDxhe7Zf9yh5tC4dztOvdqq3
 29HXzRjexs1OoVKtk4DMgT+tZ0JNbNb+KYYO6DcpM4Sx6onXfQLkTivSgoBRCGHfpPYothpKc
 tqah1scPQiHCKB9zf3Fs2qYduF7tCISE/BZ2PGFME1Ewb/p0SW6SCgd6BEBw6w24qhx59G0Qi
 412twVa5tvFNoAedS61m9XdHdJx9XVwHtpVdVP/5a2bFv+G2RUieLb+sgDLYbTTE2gVlZgbzd
 T1BmHKqoqpzgGdg2TwpGbaqFpBxHRDDoL7RUjZW8GhrhdQqoBue3hzPy8VmUOaehVlDMQAd7C
 QqhMzphoAlG63dv7kXCFIDigNscC4/jsPbGVFbYS/fFce4UP8rEjZI+mb/HOy3RknBYtSiyBR
 Ko7j6ORtSF0Qh+k56g4MER5785OWo49kye0sYvuEpmwcZbmyASeag7kseY3Ypq8Xb8iBSnUxR
 C91VoY2P03hbrOhWv7xBcLt2Sv5q6D2dMryLGExrmkOxigxODpxEzGiEv1iCQJdubV/h0ECUA
 5z7XNq/8HkOHsX5Kq2CnDy1XNykEpDcAHiA2+BW2m82nY4LtYhDOMMpSMWr5kztfUjUuVc6/a
 6zJiXxg1kn1ZEtqx4udSg5kN4JYbScM7gLtssBZ7jngytgSP5P7esWIRadpdnb012fdmMQ7iC
 J/wttx1uilIveU/D18Lk3eZjYQ0HwD4rY1mcIvxykn6GKbBOE1521uVcgb0WMz1Sh0go/h0Ny
 JAbdowYLL9U4Fi7AqBhgaHe1pCy/Qdt00Q+ZyMoaGWoJABs2ikRIAQ4m7UDLccD0rZYx6a5zQ
 1bkBaykvRHPx5SHdWkl7GPl91MQsrnBMeizzbEZTg9iF3QN3da7p6YJc7eTSHuzkQsNsU9sFE
 hIPkfl2GsC6Iw0IqkNFFGVZb6Bkbeseyr4tdx8jDmJxValXyFWxRf4decegYBh24teLKhIvC4
 YXpnnOXkaj/vPHeF8SG+Rv2nBmjdJ+u44JRbfDpq7lu+7WVc8Ux3Afhqe38CHQPJ+eT2sQZG7
 4idDPPRWsMr89fCGIB67kcyxAJWaaRg3BeFa9sPVC4l7wu1pLRbhPtaV1ETt3ZIVGMTv3eDaA
 emOk/SxhcgoP0l83bN7Sef0NuAtVUCxm2En+56DhGmMxk8uTWkK8cJeQ3TKdssjyStQ6ScS7U
 VRzFbUmkjGuDcM33YmgsFi5ob5SqmA/J5pHTk6KdeVXiFaJ8g09iWHcAzKR02ZUR2tNt0d8L5
 F++Ww2v+59G+W7anijCa28JaD8OA=

Hi Greg

no regressions here on x86_64 (RKL, Intel 11th Gen. CPU)

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>
