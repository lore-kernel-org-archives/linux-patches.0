Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793233548;
	b=cVawBDGwYMnqjyHfHMMMc5yavyfKf1FjTZASbX4/a3yDGR4lUBvUhxWRzDIFSjDNan5E
	 IsyrpnZ6fYW9NuSwIj+v/PgeWhS8YA7bOLLIzVfeQn/RShcVNxQDo7L/c61kNFzkR0PZj
	 HPBjJm54OZxj+K/EbM3jhAqSkYjcad6ZvMKTPJxa+NsnOVE2fiTTiSvz4WrSKJfIyA9I6
	 jMva4N5hKUFvU/8Kw9CRMATf7kGdQckussYZjhvQrtFSYIyCMBpxYMP0KsGmjwvBdcynS
	 GlaIluy2DvYhgibQfRY8vdCDC1u7qbjgW2r9u/AuqU1PirgDDVEqSIukATqsAfcox0w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793233548;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:Content-Language:To:
	 Cc:References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=/jZ0or5mPuMmlK3Yd/rWF09QUTFe+FBPEVbKQ0lAhZk=;
	b=KVLPOYnvq7t7wDgBr8sOOuki0wCk59jhJ6Ol9z9L3z8lptSUFpws7VBRSmJEVPZ2lXOk
	 typ3Svw+xj41N/okHya4m/0vsWt2yGgDjx1UVqeJ1pEbcZANNTHYOUry0OmmdExugeaS3
	 JoQAschBcyyJhmbODdRwa5BZyDMrECgU6do6XorpHqOUehKZADbUlVd4CRSjNUDM4EFXU
	 Kk1SiPdevAlWpgJYT3GjwBifKf+cms5A4J1QLdybKqDcfLFAtDO3/cndyZqelxocppCSJ
	 CSNYrJmu8mp9WD0L7QqhutaMMktfSxkA2FRVP1SiXe+GX/cOi9SGQuKv0ig0wj6z1Aw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=googlemail.com;
	spf=pass smtp.mailfrom=googlemail.com;
	dkim=pass header.d=googlemail.com header.i=@googlemail.com header.a=rsa-sha256 header.s=20260707 header.b=q0cUvpe0;
	arc=none smtp.remote-ip=209.85.128.46
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 853A8606A326
	for <patches@lists.linux.dev>; Thu, 29 Oct 2026 00:25:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 853A8606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=googlemail.com header.i=@googlemail.com header.a=rsa-sha256 header.s=20260707 header.b=q0cUvpe0
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4a20a37703bso12782385e9.1
        for <patches@lists.linux.dev>; Wed, 28 Oct 2026 17:25:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20260707; t=1793233547; x=1793838347; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=/jZ0or5mPuMmlK3Yd/rWF09QUTFe+FBPEVbKQ0lAhZk=;
        b=q0cUvpe0Ct0HBpiIkqGmm0d9LrZ8sLvZOFStQJla5azKOKNUOXto8XE8tRrj9Yyg3I
         KrZRZZmeX/zjtyFqO2lmISadXaPThTXeRs1HkqUxHL62GUbRsJF9q2DMumEkVstJy6oM
         bjhx/d0sqPUEP4zryjWbLZzUaTnyxREpLpVHghouAbBEDA0qtPwoKn6GlVnLjSYW1vK/
         jlUv6PuEeu+cGInVEY0t514PkX7lkRWjoaMGsXNnwx6tEqZRSzUuf0VSFyV2Yl0noE9Y
         MvHVhty/QnqO7fMKyckAMIt3UYstkdhD2ru4i+YwmKq0uIw+iC3/R57Axscf7mT4v8/n
         42Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793233547; x=1793838347;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/jZ0or5mPuMmlK3Yd/rWF09QUTFe+FBPEVbKQ0lAhZk=;
        b=1okcHnHpsXbsBYZNzroDQiDu0V20VtgzLLDwhkErhEXEvNso2E0Jx4bQvUTNX/mV9A
         2ItyuivLVQcUK18GHkYwt0JVFTI7b2j4JEzCBGxMjlC7Aaj+/n1GBq96xbRbMJCmWbe6
         nt5HFZRdC4L8csP/y+0H7RcjwBLOjS3zb7p/5fDn4KNx8QGo2bDdfJ8iFuoJKrkOQavI
         Gq/pm3SJ83AncBOjAipGXpdTkcMgkCcxQOxd8VSMxmXdkHJKsILsMTrvb78Fe59nchTG
         j36IIJtmnLDI86nhA+YPMCf0/ydHbzAGo7KJpq6XBEoOVBAjUE5y8XCa5tj93K0k6K1z
         LerQ==
X-Forwarded-Encrypted: i=1; AKwUvBykentIa4qy5iVIUfIpC/kq6EuuPsxllvmK10rHWWo5butel5Un22rxVm+a8LzoZSLhPze/FbqN@lists.linux.dev
X-Gm-Message-State: AFq9FYKO9GTSofcDlYt9CXwvGUSW9MuHpH/HtpOxXauRUk61C2p+tD+Q
	JXoVzld969Db9VQrBOjKN7IxgdaQyIadd7iQyQ4KmrKDTIXrYCTWTxk=
X-Gm-Gg: AYBFou3Wl0bWSaWiOi2EXZrtvAAvpQB3WaWNk+VTofAthc/lyDaFkriO7OMzaRaW2R8
	EEc/qT/83/1y43tifxx6s8Dq7KM4HuaKfDQtUG2cBK7EI4D0fWR0148gmkr8hIji4OYzclSwRZd
	oKM+WY0LNzTAMkgONhihe95lK4jrA1o7vvSzXDzDyN6+VsA1FQoudriRBXlT9cgyfU6VYrgq7ve
	SLMjnk/GjaTy46Hoj8nXKGHI3n/Tn8iSaiCT5HN+pq46xGbdViDaV7ScOJChdRVmeCycPO/De9O
	GizuBMXV8Ypw8Vij/0CccF2DKcqFRq9FF1bIUHXKJaMAPbMidKzPvP5U9FI/0D4zuWytRjAj/+5
	Nf1myKw5MK1eB5ATajkm4/w3UYiWyJ5LtR6KMJvBcY+NhMxkNWGY4+HhCtru8yHRoIEB33AqXBK
	4Zg7eQV7Zvqx/JQMewmVUgelBkymfH3Vywgy7dksXLKKM8ONt0lQ6LLbbueYlcTXFKNdKXzypb3
	z9pDXyhxxgmtrzNBDmgl85IMaA0QhK+5rRtE4Tiz2rldViXtgr0/c+LIU2in4ba+JJewynVDw25
	yWYmUvo0dOX4y4DRoypZ+94xrVJjY2VRsDObxS0t4git0UFY8uyOEY/x83AUP5l1+FodtZmijVc
	RQf/ZRG4=
X-Received: by 2002:a05:600c:1987:b0:4a1:dfaf:f465 with SMTP id 5b1f17b1804b1-4a9656224e0mr93824485e9.4.1793233546791;
        Wed, 28 Oct 2026 17:25:46 -0700 (PDT)
Received: from [192.168.1.3] (p5b2acd9f.dip0.t-ipconnect.de. [91.42.205.159])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4aa7c1302f6sm29180125e9.0.2026.10.28.17.25.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Oct 2026 17:25:46 -0700 (PDT)
Message-ID: <3965e950-1e5c-4b52-82f0-9fe92806654f@googlemail.com>
Date: Thu, 29 Oct 2026 01:25:45 +0100
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.1 0000/1887] 6.1.191-rc1 review
Content-Language: de-DE
To: Brett A C Sheffield <bacs@librecast.net>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
 linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
 akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
 patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@nabladev.com,
 jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20261028170459.200466217@linuxfoundation.org>
 <auJTCcqMDEmAS7Q_@karahi.librecast.net>
 <auJem0IIOw9Ibiw-@karahi.librecast.net>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <auJem0IIOw9Ibiw-@karahi.librecast.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 28.10.2026 um 21:44 schrieb Brett A C Sheffield:
> On 2026-10-28 20:54, Brett A C Sheffield wrote:
>> On 2026-10-28 17:34, Greg Kroah-Hartman wrote:
>>> This is the start of the stable review cycle for the 6.1.191 release.
>>> There are 1887 patches in this series, all will be posted as a response
>>> to this one.  If anyone has any issues with these being applied, please
>>> let me know.
>>
>> Build failure on amd64 with amdgpu:
>>
>>    CC [M]  drivers/gpu/drm/amd/amdgpu/../display/dmub/src/dmub_dcn315.o
>>    CC [M]  drivers/gpu/drm/amd/amdgpu/../display/dmub/src/dmub_dcn316.o
>>    CC [M]  drivers/gpu/drm/amd/amdgpu/../display/dmub/src/dmub_dcn32.o
>>    LD [M]  drivers/gpu/drm/amd/amdgpu/amdgpu.o
>>    AR      drivers/gpu/built-in.a
>>    AR      drivers/built-in.a
>> make: *** [Makefile:2040: .] Error 2
>>
>> No time to bisect just now but will try to have a look tomorrow.
> 
> Fortunately it was a build failure, so I just left that running:
> 
> git bisect start
> # status: waiting for both 'good' and 'bad' commits
> # bad: [adc8e434cf08c73b0f02dab2c15319315f07172f] Linux 6.12.115-rc1
> git bisect bad adc8e434cf08c73b0f02dab2c15319315f07172f
> # status: waiting for 'good' commit(s), 'bad' commit known
> # good: [85d82e0d7c2dfd3e75d34f35b7ebbf41f45c9c4e] Linux 6.12.114
> git bisect good 85d82e0d7c2dfd3e75d34f35b7ebbf41f45c9c4e
> # good: [0e1dbd1409918dbd331cd9c382ce64736dcf3272] ksmbd: fill in FileSysIdentifier in FS_POSIX_INFORMATION
> git bisect good 0e1dbd1409918dbd331cd9c382ce64736dcf3272
> # good: [617f27c3fa85742e9d468a2145e3676af6b2498d] Bluetooth: L2CAP: refuse __l2cap_chan_add if chan already has conn
> git bisect good 617f27c3fa85742e9d468a2145e3676af6b2498d
> # good: [1476a3a7d286ad7763025337f20bb841b24c72ea] io_uring: don't pass restart error codes to userspace
> git bisect good 1476a3a7d286ad7763025337f20bb841b24c72ea
> # good: [be00113e49ff42c2c007993dd05cf4bdd1c2bfeb] keys: Protect the type name while describing a key
> git bisect good be00113e49ff42c2c007993dd05cf4bdd1c2bfeb
> # good: [6270098a65994bdf26b736b2ad6614e5b9078ad6] coredump: hold RCU while releasing parked threads
> git bisect good 6270098a65994bdf26b736b2ad6614e5b9078ad6
> # good: [41af0a793777ede3f1839bcd8abae92a5c901fe4] fork: release the files of a failed fork after sched_cancel_fork()
> git bisect good 41af0a793777ede3f1839bcd8abae92a5c901fe4
> # good: [6da107042aaa43b05f4c16bee65afc2e9b5f7561] signal: allow taks to temporarily block TIF_NOTIFY_SIGNAL
> git bisect good 6da107042aaa43b05f4c16bee65afc2e9b5f7561
> # good: [da1419eb5d34caf39c1f3abad5b95a601a35114f] fanotify: Fix crash in fanotify_init(2)
> git bisect good da1419eb5d34caf39c1f3abad5b95a601a35114f
> # first 'bad' commit: [adc8e434cf08c73b0f02dab2c15319315f07172f] Linux 6.12.115-rc1


Brett, you are reporting against 6.1.191-rc1. Are you on the wrong branch?

Beste Grüße,
Peter Schneider

-- 
Climb the mountain not to plant your flag, but to embrace the challenge,
enjoy the air and behold the view. Climb it so you can see the world,
not so the world can see you.                    -- David McCullough Jr.

OpenPGP:  0xA3828BD796CCE11A8CADE8866E3A92C92C3FF244
Download: https://www.peters-netzplatz.de/download/pschneider1968_pub.asc
https://keys.mailvelope.com/pks/lookup?op=get&search=pschneider1968@googlemail.com
https://keys.mailvelope.com/pks/lookup?op=get&search=pschneider1968@gmail.com
