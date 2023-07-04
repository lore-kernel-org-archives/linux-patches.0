Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77D331368
	for <patches@lists.linux.dev>; Tue,  4 Jul 2023 07:17:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.de;
 s=s31663417; t=1688454998; x=1689059798; i=deller@gmx.de;
 bh=Fd35mdewvm82K5ewc5PyOoq3D2RKdeSWq63lTN9u92E=;
 h=X-UI-Sender-Class:Date:Subject:To:Cc:References:From:In-Reply-To;
 b=Ro8UU0r1uVyvqJNwTL9BzHGDLbyYud1QZr1lsB5leZoeoAJrGvzIcl9LzaIKjbijWGjP1Fi
 bksvxD+T6zqTJZjOEZT9M1sUvUqMP84yjv4nUcwkOBvRBErrrF89dj4W3tHnKjAgARGLCnhx1
 4h/WiST6mng7K9t0uv1zKkqGmgJUYCYl7o97EYZxWZqe0tTGuyYphZJvqim/bq+XYHkOCHnKv
 z+MbQlJO9igEt9IZw1OwQfSDPOMHYt/+17cJXgMlDJWeuS9SxTg6vR85vkLTi9RS9U7kYf05r
 Zxyi1GOVd3C3N+IWSfiCKdroA3S3ddzj7Ca7yz2+rHWgKyjoy/iw==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.20.60] ([94.134.147.238]) by mail.gmx.net (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1N2V0B-1psUSP1RR1-013wqV; Tue, 04
 Jul 2023 09:16:38 +0200
Message-ID: <d25d0195-b40e-2a03-de75-1bdc1aaf404c@gmx.de>
Date: Tue, 4 Jul 2023 09:16:36 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH 5.15 00/15] 5.15.120-rc1 review
Content-Language: en-US
To: Naresh Kamboju <naresh.kamboju@linaro.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 linux-parisc <linux-parisc@vger.kernel.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
 linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
 akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
 patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
 jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
 srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
 Vishal Bhoj <vishal.bhoj@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
 =?UTF-8?Q?Daniel_D=c3=adaz?= <daniel.diaz@linaro.org>
References: <20230703184518.896751186@linuxfoundation.org>
 <CA+G9fYueycAbx7DDR3S57d43UX49SOGnW6igQUZ0voEcapxdYw@mail.gmail.com>
From: Helge Deller <deller@gmx.de>
In-Reply-To: <CA+G9fYueycAbx7DDR3S57d43UX49SOGnW6igQUZ0voEcapxdYw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:gwk/9c6c39JOp9JwhH+wtMbvKGnNdJJEywma54f6FCuUiPtq0i+
 C+NlDrAFQtlN9PFW2qEcA7k3nmsvbCUPcxcYmG66/kTdqmj+lxWUm8DT/uJLn9W+XeJZrrv
 +tAT7hS7qFTy39dMEYCki+ct7RWZs9jiq7J5neJcGZm6McmNS6pU6Yog4P3d2739099dTiY
 +kyqEcw4wvHl0v4mxbZWQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:tJOMGFgiwU8=;I1Kt3M8ATKMjxuAjF1o0VfEHK4S
 oQrZuGJErW2OHMbp7lDLcGt9IFG6OBjc49gxwuZrgmjLPN7rGyRY8iH9o1TzpdVD1gYWdTDow
 1JEG2+EBMiSyELSQiO4ZSRYYVuzzeYaFYteyjwyrLsh2llaqEzHcSF0J0zenBv1f8V3UGzjo7
 DCgqPx5BHLcl8jZCE59QHC7Ucp1Ltgj1mE1axOlvFYVRB069U1DFIJ6s3pfD1haq2+tggLsuY
 xxkksz1vf/+zHHNKd7Pq/Zkp8psCu9GBkJX0Em3yDoKX+EvbYzAsBDhlK3cgSAT4fRB/07N8y
 ZXkcz2T1TLuVtbDolkWGOF3Gux0YAoEXZLCuvY74lb+ny6jRKIKo7Doj+b2+U95KkBhyGaekU
 Z+VpVnPM8+eVaWHuZcZ1Hvozpm6PQBgMokxqMvvWYvwVm8fI6R8dtBWNIJ/zlrgqe5yZIgUfk
 9L1bYn7xqmBuwRhIdTKSvmrlNm/d4IuZI7j0RmvJrYpNEtnnYkEBr/ntYc/V93We0EXo8WzN0
 ftRLaNPZoapmvpEgxtmyFMM/d9V58dbiXh1zS5g5HBJ24Y9QLtT+0Mnb8Xyltm8WWe15rC/fu
 UU/5sMQazc8CTgAuVZgAX+4sdOwaspUSSEbLCXfZTD/N5w7a4bWWroMESwmXQVFjMVbKlzC71
 3tepTxrzwjOLyX3x/LgcYV30jOVwZI1vaaNnSi+Sxub7ypzR+6/Hp596/W0/GE2IWhgVWX/iA
 udd5MomGxyBXf6X5NqrSf/x0m95bdEHlBrgd15c9LmOTGfadeuNVkbPZGA2UCRgNZj+C98PWN
 hdpusWJD8UT+AM4R2j4klMn08mHlbw7lBzdi7HeIsHTy287JT6UIVD+G9rmKYOUO5fAWMnZhE
 eN36vt9d3HHubKzgYF3gqOKCDXT6pNbz9pThS98NaDyd7yYe887BubiGgfKwVSds8yz3FK09X
 UcvoTGXM43EEibje4u7alB+C34s=

On 7/4/23 09:00, Naresh Kamboju wrote:
> On Tue, 4 Jul 2023 at 00:27, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
>>
>> This is the start of the stable review cycle for the 5.15.120 release.
>> There are 15 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Wed, 05 Jul 2023 18:45:08 +0000.
>> Anything received after that time might be too late.
>>
>> The whole patch series can be found in one patch at:
>>          https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/pat=
ch-5.15.120-rc1.gz
>> or in the git tree and branch at:
>>          git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-sta=
ble-rc.git linux-5.15.y
>> and the diffstat can be found below.
>>
>> thanks,
>>
>> greg k-h
>
> Following build regressions noticed on stable-rc 5.15.
> This build failure started happening from v5.15.119 from date June 28, 2=
023.
>
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
>
> Regressions found on parisc:
>
>    - build/gcc-11-allnoconfig
>    - build/gcc-11-defconfig
>    - build/gcc-11-tinyconfig
>
> Build errors:
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> arch/parisc/include/asm/assembly.h: Assembler messages:
> arch/parisc/include/asm/assembly.h:75: Error: symbol `sp' is already def=
ined
> arch/parisc/include/asm/assembly.h:77: Error: symbol `ipsw' is already d=
efined
> make[3]: *** [scripts/Makefile.build:391: arch/parisc/kernel/head.o] Err=
or 1
> arch/parisc/include/asm/assembly.h: Assembler messages:

Greg, could you please pull in the following upstream commit?
It was backported to kernels > 6.0, but with newer binutils it's probably
needed for kernels < 6.0 as well:

commit b5b2a02bcaac7c287694aa0db4837a07bf178626
Author: Ben Hutchings <benh@debian.org>
Date:   Thu Jun 15 00:00:02 2023 +0200

     parisc: Delete redundant register definitions in <asm/assembly.h>

     We define sp and ipsw in <asm/asmregs.h> using ".reg", and when using
     current binutils (snapshot 2.40.50.20230611) the definitions in
     <asm/assembly.h> using "=3D" conflict with those:

     arch/parisc/include/asm/assembly.h: Assembler messages:
     arch/parisc/include/asm/assembly.h:93: Error: symbol `sp' is already =
defined
     arch/parisc/include/asm/assembly.h:95: Error: symbol `ipsw' is alread=
y defined

     Delete the duplicate definitions in <asm/assembly.h>.

     Also delete the definition of gp, which isn't used anywhere.

     Signed-off-by: Ben Hutchings <benh@debian.org>
     Cc: stable@vger.kernel.org # v6.0+
     Signed-off-by: Helge Deller <deller@gmx.de>

Thanks,
Helge
