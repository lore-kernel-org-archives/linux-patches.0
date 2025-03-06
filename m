Received: from mout.gmx.net (mout.gmx.net [212.227.15.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 188121EA7C5
	for <patches@lists.linux.dev>; Thu,  6 Mar 2025 15:34:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741275273; cv=none; b=Xd1T4ujFHSpDfviL3JIIwpe0vt0h2hOs8i5VKf5w8x3YUEZBBRNfXptxZ1yTGitH6baWyBHXWNrQ0CPzfGj2euWF3/NPn74ptD2xuvc3ezKbaLHRK2WwKztaYwI4QxJoISRcMYpRmecA4Pr6rrkvr0VAJ7L+DUTSrsxphL+an2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741275273; c=relaxed/simple;
	bh=HtuFhXI63urBA3dRKYyXQ6GHreCYVeNttV6YM+zDLlM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=t290xQlRBUq+zASjlzQIoyGqCkZz+pNTULrahQ9HiKNq+5DeST+4Ti83nto/TkQj2HtuucXSeFAftMxzbcFsDTb+y01Jp9J2tB4aNaGLzUDll7US061C7F2sIcE9F/P5XArX8ziMvFde5g34hRLd2bGEmKFWiuElmZfEAhPRibA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b=WtDdFsmn; arc=none smtp.client-ip=212.227.15.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b="WtDdFsmn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1741275248; x=1741880048; i=rwarsow@gmx.de;
	bh=HtuFhXI63urBA3dRKYyXQ6GHreCYVeNttV6YM+zDLlM=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=WtDdFsmnhh7GnkOrzKIbErAbZZR2GLADL+VcGHPExpncvANzKoJHACxiwyX6dpYl
	 IRAN203UJA0B0dEuLqN2k28nxpfZWt0dGpa7qbOqiRkLqW/5EemY0BZGadOLBbLNK
	 pNr6b9I2iZUslFqLdErhlsAewMVTVA+Qh67cUpxJwEFNjEojEFgUnk+SL+4LUvFMC
	 uIpbqVMswtiHTLKSE+kyN3cLw02HKrWvOTgMDTuq/5frmJapkdl+RNnjLPFhXSMVg
	 i2ejhLmLrjzhZMIp1ANPf8GnGtbWS7DsNi87s+kRUVdxrRmkp0n3iY3QW2KugHJkg
	 eZZGwZf15lmby1NNQw==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.200.20] ([46.142.33.164]) by mail.gmx.net (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1N17Ye-1t6P8c2ENm-014GHC; Thu, 06
 Mar 2025 16:34:08 +0100
Message-ID: <192dd152-e3b7-44dc-b8ab-e0056d363363@gmx.de>
Date: Thu, 6 Mar 2025 16:34:06 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.13 000/154] 6.13.6-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250306151416.469067667@linuxfoundation.org>
From: Ronald Warsow <rwarsow@gmx.de>
Content-Language: de-DE, en-US
In-Reply-To: <20250306151416.469067667@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:4iJkSd0nuQmCooOW4YY2NAW4YDlCYDy8IlnC+01CKwpGZdr9Nk6
 ULfEt/82n450JESf8jo2061DK08qMuSD8c4eLe3uHSDizIztXohhmojOnLmP5IsZ4TGRerM
 71bhQMjJOrJf48InqJPH8fPedPnADetXLhuOkl7QiR5G6PLGk3A/hZfXDvBRUJdqEOcNAAx
 Sp0vVj6NIjc1vM3LoI7IA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:oXqHSHZAZQU=;euxmgvriMn5gA1uZ2fVNGEeupDd
 OlWTw+BkNo593O8dyCohqXztfurkZpUje1jndeOf15fQIwI1THbQ2abdB76yf78jRRmDBsJEA
 qFZj22kivVilvhZeBlJFeR3QOCK0seIcRY+OuImExNn561VSTQQiieyqKTCXsoBRuZdD9l5Fj
 iTVqYFtB1dPpyBlUsMfEDgi5xYdzsZgGCew6pWD1L96lKXih97pGvQCuYTBldqobnFEzLixnj
 EZ9f3wpFrSopIl5e+sOHjv7XmlWyTLAzpsc0ZrzkGIswIZ7gIcVLH9WsCFJhwL9KMqQOwrWLw
 LytbV62v5ZEBOBiyOeX1DSCuWr4lrAV79cd9C0Ki4gL7skwsA1ThVqelZ1mUoLt6KWjvmzcs5
 EnaZflEAbJe5AjMm1PpoP7kylK4p+l7bv44bY6vtQm3rYA/bPKZaKnErgQyW/w4kH4oe5Lkn7
 +4iGv33tamjONStXSNw0xVQMmCGhQA7fI5t4vCXsLa1C8H4IJDPXSn/g+H0CvCFUXm+MggIEz
 3vpHrhYVJhOYsMdJiPdi+FPGGzL1z7Fm2rzvNEEx8stQjPWl0ONk3nmeZaqdHvP0Wu3vV3IgT
 jtDqV5cHlWmgFykwxQeT/IydkBlr/YdyPihh5FydmrEoJ4kemtFyaw2RB0p8JM5JDX6qnzCfl
 OkQE5PeBuAB7EDAE9SMtMiDAO8/8Nkg6u8ILIoO5X7jfBiyQrElMx3ZZHvSICRrX6UmgcZfdN
 VGqKduu6bHdmY+qfm4Sw4p8/MZu58hP8z+ZuiBV0hfkC/KkOawqcT+HtgNaRsrb2gI+A4mKJD
 KQFFJYUGfHh+9yC5I1NjpMQFmg+avMohYkHOiptqIrvFM3X9vCwpBfb89948AHRJ8uHLelNTP
 f3OSdPn9eYW2C0OleMUL96+eVSkcG72GfDKUULZk5RQJBEp+WQAgQuruirXhMaHp6AHfHlBgA
 uH9j+bUkVL++9uzYB41y8T6M13iOFmS0Fr8US2GUx/tIhUg7qw+cOO30nEYHxQsS/X//L8dUT
 mM4juvenzt3TXAx+cwoAAePCC9VJ1edBMacsaD72b5V3E+6/oOvy8BVUHbtv1vKVrfecxtjtW
 g/u21v9FpFFx3OC7rO9NV+USUuUizLN9/iukRGnhs7g2b72giFqFRLRQ6eUtmT69tR2b6zuaJ
 C2e/wBn9Ye03+HNi+C2V0i1NapJajgVbK3qeQ4Jk83Q6BK+aU4QloWoRvkbIq8lOsyuY+Xrzs
 XuUVEAlYX6RUASaHcSAeWc6dGdRGRsaZj4XL0MaTLLEgvHwaMx7zBtF7nKZFrkcKqq8O0s2xY
 OYmKPqKYkJJRDdVYMTJyWhCyRXODkQOHla+xGzCmB9aPNWUlpuRAY2fZEeRY+8iCmp/l0hT1/
 ZdBRdzSWf6APJmaN6RIQxcKxOfWcfoAIuNH3anF5T0r/73iODQGins8MZf

Hi Greg

no regressions here on x86_64 (RKL, Intel 11th Gen. CPU)

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>
