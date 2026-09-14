Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E3A749BD6F
	for <patches@lists.linux.dev>; Mon, 14 Sep 2026 18:02:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789408964; cv=none; b=ZRBJcYXH/3xd9h02Ybds1uAf1MWF76p/3tWVG5nM7jUbUPMKScGjD1ERKSWqRSN2S0aYurmx5fkC3U+CljjOTHOjynw6u7CYZ+1RlCFABnfBObuFzljuCnuGYd7MhRooZQXpw60UrJm5LAkvVDopWWXQW7sz+9g26Fe7phT9n6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789408964; c=relaxed/simple;
	bh=9ZswKmHYV3hQPdJPCFwuJCVbZNz9gP0vODDqdoni8oE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OIqNubP7Fkvoibyelwb2Z7iUFMLqYq7LmbB2H/C80qMW+pP/465hGMJh1s9qdHpLbum7gX0Yv2L0LfY3a1sLtboJNdBb9rl3Y7GBYtf9yR6zs0HgMhlGQ8O04C1+nAC0J+8Wn/Ejo4eXHn5VtDYrNLYrVHu4jCHHbifWS1E14lk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mC9PxH0w; arc=none smtp.client-ip=209.85.215.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mC9PxH0w"
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-cc149372c14so2322202a12.1
        for <patches@lists.linux.dev>; Mon, 14 Sep 2026 11:02:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789408962; x=1790013762; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=KMesPQp0VJUensHvMGRs3/WPWJMCG93L+QYn2rj5VFk=;
        b=mC9PxH0wDrQXQ+GWuTYn6i2AFeldl5nyLWA5KkOAjsUnZV6o8eYQiEx0L36cNvrTyM
         ooHCsRTBTrWU9y5LiCDy+yeUbeXTaXjbHGbSudIvINr/ZC4QG0OifUUsVKukLcMh+iBS
         1Qjvg090FwCrCpiFgPXcHQ3/TWDYF/hrhISiorthye07iRhFweLh0bAua568YIqX9PzS
         Xy61QV2rV+7VFaKV25ChHcQZzV7VhdulBg7RCNBEOdERs1E2NuB/2F404QZknSiSC0KW
         EbJk6Db66UGrSoWtugoTCYWhqrgste6QVyCm1ddQhGGiVUO4/rmO7AFg2R07Axz+As/c
         ry4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789408962; x=1790013762;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KMesPQp0VJUensHvMGRs3/WPWJMCG93L+QYn2rj5VFk=;
        b=ZOBQobvNgHHg7GiD7xtNUGA4PlJvqK9JJo9Y6f2Vy88tbk50wcaGEjxOYE9z5w/uOd
         zX7Y46cjVcUQMJlSTOftv5vMJAUF/8PfzodUej+qs6ovxr5vs9BuLdJbYQJlworTZ8RW
         iP16C9T3dpEu7ZsN9/ItmCSkuUYbji3VgujQ6exxxDEsIH4XtEviixQS4Dkg/5nZ4CEz
         uFEL4JWlY9XKfchKmzQ3F71qhhGN7EyI8dCzmpW3FMdkMi1glY9mQxNPK4d5biWrzn9U
         BPClhKiwMLsFlKAQPB1LHOFDLT+ryrQ1vB5C3s3HG/ppkdqAuV0PI4FEMcfKrTC1tahm
         zkZg==
X-Gm-Message-State: AFuF++nk8U/1SGdWJHrGuJjuhORUi6C8kpPP72BbMXcR5Dhsdbft4cWh
	dqo6ekzw2b1pSQOpquVnevomqgEqU0bJZ6S8iTNj4gBc9ZhIYUJwQbPRi58KLw==
X-Gm-Gg: AYBFou22+WM86uY4S8h9oOsVaQrjHg6gFJCJPx8BaFqXjGZAj0li0mBR5kawTWKhRLU
	CtrHziMI6JyTNa1xQNam9ZbhJ2yl/Cqo81zs8Sa9uu35VZrVhz2AGvNMVJTSapVw9Cy2CI77hk/
	4E6Fujow3ws2B6gCn1ziEIhtNGgv+e25d8dzVxqi8IZhppkVSFSxQ5q8qENbF+KG5eXyAZAPdxa
	S9yPpvLubnmL0uS7hLH9VFZxXpdl9ZaW0067MmqZQrXeEZmj3wXyV6Xo62XyMKsmX60w4Gxdici
	vh34HqXh3N94vZBijxOP4FAo2rO7MIPPZj/XQ1UCVdm9s+CzYtxsUZCXFG7b0u3ygglQSxcTIO3
	iiJv9a+hX2tSh5ZSWlUJQgdkeSv0fp9ypm4nkJJFU5x+vp8TdHB9Ka9sUOdyNM3hLbtFuypYuUU
	91/2ohfl9lAk1h3yd5PQb4rCGaf9KkwFUQg1nqp+4og81qZxuPEvSUPs+VlTGjEVLx64fQ5QZV7
	+yopysRH0HofjCFdFuH6UWaplSfpwGEhUdx
X-Received: by 2002:a05:6214:4993:b0:912:122d:174 with SMTP id 6a1803df08f44-9122e691c88mr56601806d6.34.1789408874114;
        Mon, 14 Sep 2026 11:01:14 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-9120f47a6ebsm100587596d6.22.2026.09.14.11.01.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Sep 2026 11:01:13 -0700 (PDT)
Message-ID: <c293d5c7-ee3b-4fe4-af58-f232c8b9efbc@gmail.com>
Date: Mon, 14 Sep 2026 11:01:10 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 0000/1376] 6.12.110-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260912065607.535295758@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/11/26 23:40, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.110 release.
> There are 1376 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon, 14 Sep 2026 06:54:17 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.110-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

perf fails to build on arm/arm64/mips:

   CC 
/local/users/fainelli/buildroot/output/arm/build/linux-custom/tools/perf/util/symbol.o
In file included from ../include/linux/build_bug.h:5,
                  from ../include/linux/bits.h:22,
                  from ../include/linux/bitops.h:14,
                  from util/hisi-ptt-decoder/hisi-ptt-pkt-decoder.c:12:
util/hisi-ptt-decoder/hisi-ptt-pkt-decoder.c: In function 
'hisi_ptt_4dw_print_dw0':
util/hisi-ptt-decoder/hisi-ptt-pkt-decoder.h:28:41: warning: implicit 
declaration of function 'GENMASK_U32'; did you mean 'GENMASK_ULL'? 
[-Wimplicit-function-declaration]
    28 | #define HISI_PTT_HEAD0_4DW_FORMAT       GENMASK_U32(31, 30)
       |                                         ^~~~~~~~~~~
../include/linux/compiler.h:17:23: note: in definition of macro 
'__compiletime_assert'
    17 |                 if (!(condition)) 
         \
       |                       ^~~~~~~~~
../include/linux/compiler.h:37:9: note: in expansion of macro 
'_compiletime_assert'
    37 |         _compiletime_assert(condition, msg, 
__compiletime_assert_, __COUNTER__)
       |         ^~~~~~~~~~~~~~~~~~~

-- 
Florian
