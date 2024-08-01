Received: from mout.web.de (mout.web.de [212.227.15.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11747184540;
	Thu,  1 Aug 2024 09:24:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722504254; cv=none; b=Nzhb7x16ri5ouARBzVrBsGulbo3/0YNfVF27dyXeKS4FpV0TEe8X/t0QDwACBRMqNLAV2p2siUXs0ocKBbsLMJKuIxTqZdNBymYz8uvbFx8iCrFZ/xGIL1vALdkT4VGfIS9eE3OWHSlu/QzUaXKFXJ6IHBCP3TSSr2b/7s6El7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722504254; c=relaxed/simple;
	bh=gy+1SJ7LKRchbuurwZ6K9qa1t2fPMXsZCG1sdumE7xM=;
	h=Message-ID:Date:MIME-Version:To:Cc:References:Subject:From:
	 In-Reply-To:Content-Type; b=pD1zoG9pTPq9Gf2NDbTktJeuBqB8t+o7VTxoKvKff0hKt72FEnsbh2HrRzSTchrWwfaLZo7D/el8Dwe2FJoqSECAncplQLWIHEYL1ZLDgIi+DkqaXiwHZaoRodTH3nTkmJ2y6Uj5S1MWKeW/CzIurTqn/F0Dlg2QNugIaN2VIZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=frank.scheiner@web.de header.b=sWclGiG+; arc=none smtp.client-ip=212.227.15.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=frank.scheiner@web.de header.b="sWclGiG+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1722504222; x=1723109022; i=frank.scheiner@web.de;
	bh=M/O8i2ZhmAtuCeZ0w9M2qWBIAu61DhuhrRUTTjUV/FI=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:Cc:References:
	 Subject:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 cc:content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=sWclGiG++gHXYGe7Td3KTkAYOOBDlgoPLlPygV6MP36eN5sYF2qxC5S2ICjYTaFK
	 M1w0H58lH7kC6UFzcabkgp0Y7RCfL7xCnb7sTAGQTsw4jOAtfK3uXm0A5xwV2pjmj
	 l5UDxW9qqGDiRC2xywLHjUpMsNjPtzfTncQgL5lzk0UHyk5Y4WoNkq5pDR9h6TaCv
	 hiX16SY++Ryz9QEpbSYQH074PTtpuVL6fxwgZfTpI8p0ldI9Pvwa2F/Axcg7rFopZ
	 vTLQHVNwxWio73N/4FiKwbzirxdSXYxMAD4PWamJLVdfYrauQsxntnc5zy/FFj54b
	 qBdusUtsK5Sf9r7FdA==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.30] ([79.200.215.229]) by smtp.web.de (mrweb006
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1N3oyy-1s99n40vnU-014Q5H; Thu, 01
 Aug 2024 11:23:42 +0200
Message-ID: <2269aca0-29dc-4968-8cb2-de798408a9ca@web.de>
Date: Thu, 1 Aug 2024 11:23:40 +0200
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
References: <20240731100057.990016666@linuxfoundation.org>
Subject: Re: [PATCH 6.1 000/440] 6.1.103-rc3 review
Content-Language: en-US
From: Frank Scheiner <frank.scheiner@web.de>
In-Reply-To: <20240731100057.990016666@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:ygsQwcEyzlFHO00Fj5Bj0BacckmXHPZuqY5WIR/uRBV3R5Py7sN
 MYczILA38ndDO+IdBlc8FTtPq1PH8XZtyA/RTFIMSTz3Wq7wLGMQL3lpgNvLCnEDQo0DW+i
 VlVX5u23A7DLmDfYSKKHia55H36TgXCPJobXIUl9NKbfNfwDspEUjX6hSc47RA+pTVGsbf6
 fCkkbx824OR4eLZKCaO5g==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:KchN4cz3j3c=;Az+3Q4LsEmwuoT4MTTUwCa6N2S5
 YnSBXPd6Z4tGXQTQoVzTVjo+EImYT5ApEb/oJ5ebJJSqUNERbYzfmVQbYG7U6h4ZgToyss/zZ
 9HfnnntZaQ99rmEUe12WDiQ4VpxqBxcYwYnYZ8aRf/GxP8YMy9pGVDd/Wwuesab+D6Rzm+vnZ
 XLFLa/MgUhDqd2zL5gh+9tPr5K9vOQ2ybVNlCSQaNMP51Dc2Wyvv7WIypE7mw1hsNR+dFO7rv
 DMId8/LES0uWDQO3zj341JV8gU5vyMzuimplOXCu4pRfPufsb7FlwMTTyQhQreo1aZsMwnJC+
 di+8v3iH23QDcVZ/UVPqUZWnNhx3xXATvS3kpXsUc/eEGMPcPyfZGQgCUblfZz0DhLRRE0r31
 3ysvUpZSwu1b8crTILBa6ASra3j2jQATUJBJ/opwjSNbIFWK7VsKOdPHdS16E68nJixGuj3v7
 ZkW1X3PpYmoX7AphdZKkjO+7Sg5DEjujtZB9WBQbcT+w/vS2Z/AVuic0uUVZEMrsaHFINWE8e
 oPhFBLwbMOo1QQRyEx8cTjBQIYOLcjPYI4Htm7mWmRxm2/hco4QHBlznLtPFkfntUKJJlETYF
 RoZ5cJ9Tn/ObYVOTG+DFKiM4LSORyLgIbrXMxzxBlVOf7GLB0m66jlFx47AVDLU4y4AmwLoVA
 1l7hPNk92MTCQhBDYwRLp97lXvj4n1Dmgz3uFY+ykcnIroYPviIwZAOmGCnn3mYRR9In5x6Li
 fc4EgpZyD9USKZqfUXYz26oC3xJ9M5wvpkwzcO8VIsuRtd18zr2jYrQuL1ZUW/MKnLLd//4hW
 pyBET5GCZHEMSyYeWp7VwsvA==

> This is the start of the stable review cycle for the 6.1.103 release.
> There are 440 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 02 Aug 2024 09:59:35 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.10=
3-rc3.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.gi=
t linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Cross-builds for ia64/hp-sim and runs fine in ski ([1]).

[1]:
https://github.com/linux-ia64/linux-stable-rc/actions/runs/10191315715#sum=
mary-28192715031

Tested-by: Frank Scheiner <frank.scheiner@web.de>

****

Thanks for fixing the issue with rc1.

Cheers,
Frank
