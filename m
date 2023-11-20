Received: from mail.itouring.de (mail.itouring.de [85.10.202.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8120232C9E
	for <patches@lists.linux.dev>; Mon, 20 Nov 2023 19:09:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=applied-asynchrony.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=applied-asynchrony.com
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from tux.applied-asynchrony.com (p5b07e88b.dip0.t-ipconnect.de [91.7.232.139])
	by mail.itouring.de (Postfix) with ESMTPSA id 94066CF27A5;
	Mon, 20 Nov 2023 20:01:02 +0100 (CET)
Received: from [192.168.100.221] (hho.applied-asynchrony.com [192.168.100.221])
	by tux.applied-asynchrony.com (Postfix) with ESMTP id 3AF53F01608;
	Mon, 20 Nov 2023 20:01:02 +0100 (CET)
Subject: Re: [PATCH 5.10 000/191] 5.10.201-rc1 review
To: Guenter Roeck <linux@roeck-us.net>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
 linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
 akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org
References: <20231115204644.490636297@linuxfoundation.org>
 <b5367845-8d70-4fcf-861a-ff9b8849c9c9@roeck-us.net>
 <2023112039-reverse-careless-e646@gregkh>
 <ffd98a9d-6db8-4d1e-b3ab-0c7159f91b6b@roeck-us.net>
From: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
Organization: Applied Asynchrony, Inc.
Message-ID: <b4ec1c4a-bf03-0a2c-52a3-04e11ffe6c66@applied-asynchrony.com>
Date: Mon, 20 Nov 2023 20:01:02 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <ffd98a9d-6db8-4d1e-b3ab-0c7159f91b6b@roeck-us.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit

On 2023-11-20 19:17, Guenter Roeck wrote:
> On 11/20/23 02:05, Greg Kroah-Hartman wrote:
>> On Thu, Nov 16, 2023 at 05:13:39PM -0800, Guenter Roeck wrote:
>>> On 11/15/23 12:44, Greg Kroah-Hartman wrote:
>>>> This is the start of the stable review cycle for the 5.10.201 release.
>>>> There are 191 patches in this series, all will be posted as a response
>>>> to this one.  If anyone has any issues with these being applied, please
>>>> let me know.
>>>>
>>>> Responses should be made by Fri, 17 Nov 2023 20:46:03 +0000.
>>>> Anything received after that time might be too late.
>>>>
>>>
>>> Build results:
>>>     total: 159 pass: 155 fail: 4
>>> Failed builds:
>>>     arm:allmodconfig
>>>     arm64:allmodconfig
>>>     i386:tools/perf
>>>     x86_64:tools/perf
>>> Qemu test results:
>>>     total: 495 pass: 495 fail: 0
>>>
>>> with:
>>>
>>> Building arm64:allmodconfig ... failed
>>> --------------
>>> Error log:
>>> drivers/interconnect/qcom/osm-l3.c:6:10: fatal error: linux/args.h: No such file or directory
>>>
>>> There is no linux/args.h in v5.10.y.
>>>
>>> Caused by "interconnect: qcom: osm-l3: Replace custom implementation of COUNT_ARGS()".
>>
>> Now dropped, thanks.
>>
> 
> v5.10.201 fails to build arm:allmodconfig and arm64:allmodconfig with
> 
> drivers/interconnect/qcom/sc7180.c:158:10: error: 'struct qcom_icc_bcm' has no member named 'enable_mask'
> 

Sam sent a note about that as well, probably got lost in the pile:
https://lore.kernel.org/stable/87fs10k1ee.fsf@gentoo.org/

Looks like it's missing a prerequisite patch.

-h
