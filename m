Received: from mout.gmx.net (mout.gmx.net [212.227.15.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1376915C8B
	for <patches@lists.linux.dev>; Mon,  5 Dec 2022 19:58:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.de; s=s31663417;
	t=1670270288; bh=2gFYzCTJIOULN9LJknChVckVSBJGN1eSRMJYrB2BzR0=;
	h=X-UI-Sender-Class:Date:Subject:To:Cc:References:From:In-Reply-To;
	b=tydd0lQsH8wCWtzK6uNrq9/RmlKi2uisIFf2aaqCpD3O4CxoAOSVnPHZ4cC1h6v0H
	 9SZI2NfeBbG41Dc1OwoxJzzbFkDzB7aw4apxzSVhm+xWceFpFZ4GIukK4VA7U1pJ48
	 HQ3Mivs+btbeSyZtjZu+/iavM2ZvZZBgfBHT3QkXVmkgiUMZglitXvrScJwHjpEHFi
	 nZHJ4mI/q/fd7sBi6IyT3EEkcApWFwJN8YP7uwnd0LyQZ7v00bRj1Itowoi7buSG1v
	 g9BEUdJnajJrBFfUZtHH9sxBgrvLSlLzwiLccgi3i8aPV5FSJVi+4+0J/hP3Fsr0bQ
	 WVJXiG9losy3Q==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.20.60] ([92.116.161.205]) by mail.gmx.net (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1M5wPh-1p4DXf0sDT-007Y7s; Mon, 05
 Dec 2022 20:58:08 +0100
Message-ID: <4676311f-1c08-a611-a3be-48e841093e45@gmx.de>
Date: Mon, 5 Dec 2022 20:58:06 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH 4.19 094/105] parisc: Increase size of gcc stack frame
 check
Content-Language: en-US
To: Arnd Bergmann <arnd@arndb.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>,
 Christoph Hellwig <hch@infradead.org>, Sasha Levin <sashal@kernel.org>,
 John David Anglin <dave.anglin@bell.net>
References: <20221205190803.124472741@linuxfoundation.org>
 <20221205190806.296201818@linuxfoundation.org>
 <dfa8305f-f52f-4322-a22e-9a1e90fcfad4@app.fastmail.com>
From: Helge Deller <deller@gmx.de>
In-Reply-To: <dfa8305f-f52f-4322-a22e-9a1e90fcfad4@app.fastmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:dOAkOnQa3QmOZPQkvX1e1bF9W53Gu4PO76EgjfY0+b7wcv1qfU9
 nHFnYcSjYimpBkA+yTlubQyUXvNRBjLl4sqOLWBZSCTDvMFjPDMRR3+yhuVuGLdSsrvVvqm
 G5vkJlnfcyUwUK2xAS6RPpOs8ntoXShrjVXRMZnq3r0Kaqg+A65mfnqiPkVdUPlQPcb/C1t
 JjO1AV+oqxnOrfxIL5syw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:WAJw04KI6j8=;vxI7oixbqXmY0RGjQ9Z+xd2aKdJ
 mxjU8SAWaTUDVhz4uNRODHbav/+XdQhfjNS9iaBPvmJP/Hv/MuAUS4sK4WNszzSSDLignfJMM
 JGkhSYbe+/NEuTR6VXS9owjnDWezyLbUTaLRORBiryhFsgtgQ5bf7K+KY31N6+5usfuat8XE5
 ZNwGNWyOON2xGfd4gwMa8Hj8BO6wQhptYT9VEZUU9YTF4q3qAkMQuU5IafazAEiER+ZLhjfsj
 xhTYZKzYRBEYF6DPW7Q06S1sX1O1A6pRQ8Yh6M0+ulo7bk3T9XU6Ig4bCN1isNyGummeVzmUy
 /ndrjwEyswlPml4FsZ1e1E5RR8f5Qh4RdwxAS3bwPd8L4byZxyVHzrNek0VKDuUZ/zKMhPO5a
 UN4JCvLXXYLbA+z1jj73dn3ZcgXJWMgEF+CXevco0E5GSzh+UWk7KvhBBQwtAbs9uPpOB99kK
 PhhRV/bjNLYO6z3DaOt3CjblAPOESmgfKQ9KKyyWUFiM6knxFBrjbqdK8DcMf7CgSyp20hfpg
 QiAlWxTXl3fAsfb4IlM3LCI5yzwwWsvXy7yeWVnXRz52sd1harfwsua/bUNPkR0tLkrvI3Lk2
 dH9WNoU3I0NMXF4aWdmM92rLKH1pMDNqqnh4MLCx7GF/YTatCmsW5fYCPSD+UJ6Kzoj6HGe2H
 PJ1B3cyNZQMVeW4u03lKc1URd8YfztgyJmFzHpt7XNaC0C74P27tnsH1FyBHyPNQtg2j5zWkY
 upEYf1POJlHngebLHILni/ZhZVezSRqLzcKDlACAIwaZJdadPgX/DJ2tWUVudVyW+eHtLx/8m
 CsgdP9ORqiYGbDCCcf09ZkxqCFcP2bNrQKr6bMwmX7O6y1RP07OZbnlEs5hTIekjkC7KC5//l
 s/9trVHH3uqBcxTWbwiGTOZSRHKr+/zFjsOtw/4oMRFYmr9hSmWRAOiFvb6441YirDcyNuSBX
 DX9/kg==

On 12/5/22 20:27, Arnd Bergmann wrote:
> On Mon, Dec 5, 2022, at 20:10, Greg Kroah-Hartman wrote:
>> From: Helge Deller <deller@gmx.de>
>>
>> [ Upstream commit 55b70eed81cba1331773d4aaf5cba2bb07475cd8 ]
>>
>> parisc uses much bigger frames than other architectures, so increase th=
e
>> stack frame check value to avoid compiler warnings.
>
> I had not seen this one originally, commenting on it now:

Hi Arnd,
Thanks for commenting!
By the way, those patches went in for 5.16 kernel, so I nearly forgot
about them in the meantime and wonder why they pop up now... (they weren't
tagged for stable, but I think it's ok to push them backwards).

>> index 9ded3c1f68eb..556aae95d69b 100644
>> --- a/lib/Kconfig.debug
>> +++ b/lib/Kconfig.debug
>> @@ -224,7 +224,7 @@ config FRAME_WARN
>>   	range 0 8192
>>   	default 3072 if KASAN_EXTRA
>>   	default 2048 if GCC_PLUGIN_LATENT_ENTROPY
>> -	default 1280 if (!64BIT && PARISC)
>> +	default 1536 if (!64BIT && PARISC)
>>   	default 1024 if (!64BIT && !PARISC)
>
> 1536 is a /lot/ when we're dealing with 32-bit platforms.

True.
It's actually 2048 bytes in the meantime, see commit
8d192bec534bd5b778135769a12e5f04580771f7

> My understanding of the parisc overhead was that this
> was just based on a few bytes per function call,

What exactly do you mean by a few bytes?
On parisc the frame size is a multiple of 64-bytes (on 32-bit)
and 128 bytes (on 64bit).
For function calls with more than 5 (need to check exact number)
parameters those will be put on the stack as well.

> not something that makes everything bigger. We have a few functions
> that get close to the normal 1024 byte limit, everything else should
> be no more than a few hundred bytes on any architecture.

Sadly not on parisc.
Again, see commit message of 8d192bec534b, which mentions
compile warnings from the kernel test robot for lib/xxhash.c.

> Could it be that this only happens when KASAN or some
> other feature is enabled?

No, it happens even without KASAN or such.

> If this happens for normal parisc builds without any
> special compilation options, that would indicate that the
> compiler is very broken.

No, it does a good job. It's the ABI which requires so big stacks.
I see problems with some userspace apps as well which configure too
small stacks.

By the way, since those patches are in I don't see any stack
overflows any longer. Those happened rarely in the past though.

Helge
