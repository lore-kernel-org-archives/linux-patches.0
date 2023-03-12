Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [80.237.130.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70E481FC5
	for <patches@lists.linux.dev>; Sun, 12 Mar 2023 13:57:57 +0000 (UTC)
Received: from [2a02:8108:8980:2478:8cde:aa2c:f324:937e]; authenticated
	by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
	id 1pbMCw-00037O-LH; Sun, 12 Mar 2023 14:57:54 +0100
Message-ID: <1fb2d6bb-914e-275e-91cd-9c1096355eb9@leemhuis.info>
Date: Sun, 12 Mar 2023 14:57:53 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Reply-To: Linux regressions mailing list <regressions@lists.linux.dev>
Subject: Re: [PATCH 5.15 000/567] 5.15.99-rc1 review
Content-Language: en-US, de-DE
To: =?UTF-8?Q?Daniel_D=c3=adaz?= <daniel.diaz@linaro.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, peterz@infradead.org, jpoimboe@redhat.com, ray@n5lax.com
References: <20230307165905.838066027@linuxfoundation.org>
 <4ce8fe57-53eb-4a83-a468-ebfc98fed496@linaro.org>
From: "Linux regression tracking (Thorsten Leemhuis)"
 <regressions@leemhuis.info>
In-Reply-To: <4ce8fe57-53eb-4a83-a468-ebfc98fed496@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1678629477;45fa5e81;
X-HE-SMSGID: 1pbMCw-00037O-LH

On 08.03.23 07:24, Daniel Díaz wrote:
> 
> On 07/03/23 10:55, Greg Kroah-Hartman wrote:
>> This is the start of the stable review cycle for the 5.15.99 release.
>> There are 567 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Thu, 09 Mar 2023 16:57:34 +0000.
>> Anything received after that time might be too late.
>>
>> The whole patch series can be found in one patch at:
>>     https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.99-rc1.gz
>> or in the git tree and branch at:
>>     git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
>> and the diffstat can be found below.
> 
> A new warning has been introduced on x86_64; we've seen it with GCC 8,
> 11, 12, and Clang 16.
> 
>   arch/x86/kernel/smp.o: warning: objtool: sysvec_reboot()+0x54:
> unreachable instruction
> 
> Bisection pointed towards "x86: Mark stop_this_cpu() __noreturn"
> (upstream commit f9cdf7ca57cada055f61ef6d0eb4db21c3f200db). Reverting
> this commit did remove the warning.
> 
> Reproducer:
> 
>   tuxmake \
>     --runtime podman \
>     --target-arch x86_64 \
>     --toolchain gcc-11 \
>     --kconfig
> https://storage.tuxsuite.com/public/linaro/lkft/builds/2MhGKYH63pYIllJIDAxH3FsvakK/config

FWIW, thee is another report about it here:
https://bugzilla.kernel.org/show_bug.cgi?id=217175
CCing the reporter

This is definitely not my area of expertise, so you might better want to
ignore the the following: I did some quick searching and now wonder if
backporting be0075951fde ("x86: Annotate call_on_stack()") might fix the
warning; it already was backported to 5.15 afaics:
https://lore.kernel.org/all/20220412062945.857488242@linuxfoundation.org/

Ciao, Thorsten
