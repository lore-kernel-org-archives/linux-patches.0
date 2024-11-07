Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E221F18660F
	for <patches@lists.linux.dev>; Thu,  7 Nov 2024 16:39:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730997584; cv=none; b=MdwQJkFSyL9wDvMwwBBeOScW+CGI2CRnUlE2kJv/R6/pPwl/OLzn/RTbB+OwhtO697XiVKy3ajWRo8Qmsa8e3L5TYa/cEsjYMVBTbK+z0yBTKbGCvFr7FJAwgt3C49Vk/uASfhe16mbPjAS7jRUdqiaV2Hp/itpiBSqJsyYq09E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730997584; c=relaxed/simple;
	bh=lJ93r7UQYNp+rlYKZUt1Can6uIRWWwjylI/k8nRrfqw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bSbvJ/Kyoj6l8a7DzcN1b3AqcH5AHuVIGQcDvRd+IHZ9btbx39b+7++05SxF90soLGGHJsMGH/8xkNpBXlBdtxdUhyDj3BwamCjk9isqvchTWb8Vx4hx6kA3qTn//bEeBTTZN3mbESh7J2cXmUQMkAuC1svY64/mk6SkUKoJZ1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fOlEr7TJ; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fOlEr7TJ"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2113da91b53so9152175ad.3
        for <patches@lists.linux.dev>; Thu, 07 Nov 2024 08:39:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730997582; x=1731602382; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hgXJATuyZwVkN70AZDZo/VSscc1RChOphjdktHVIOVk=;
        b=fOlEr7TJjUmomWjVPjjzeYeUnDDB7X6oZIAbd8odCb0m5JJ1PFnYPj5aYDQidv3dFX
         l6QSI0zdo4zRarLh5PEJ3I8Jb/U9jvaQAbcoiBZ0g/CltpCi9yqcuciIBPGJKOS36h53
         M1ZoO1yQqPo3U7PZpfwMcxP8L2U2KRNRyYQf3f37LYHFc51E+wRYhGJ3YFcvDzj6tyKq
         XzkhvNAUwF3OUXjGkNCzGbKuQsxpte5w58GG7jH8sKDd5whgC/1qd+t5RIN95zMIU0qG
         lN+nZ7VcvYilapDh0xeubWhXEet+5NSiDFhLoJy7qck3E8vhQl62YZ2LCIa/RY958y0Z
         VpLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730997582; x=1731602382;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hgXJATuyZwVkN70AZDZo/VSscc1RChOphjdktHVIOVk=;
        b=pedM7UVvHhwKsePE2nOOfX8nbDeeMCO2grYCoUvj15/51yOd6iQBIZ/r+K8o67prfE
         97wyLPnQGx0R7x4W5VhiAEKqdoooyhxe3CprabH4ywXATfh3merUzRwMEEKhKQPK0/0K
         Y/Smfob+mstSmLPYPTl8FTDVss0FJ6sKCEdixRBZPZUkdbNWgQS0SGrkXdpBEz0S0lml
         sgfgYJAytL0Q2d/WG5+EN3aWycG89HnF0QpZP4BAOC4nNFB1Bkdfy1coedr6C1d3x+Qc
         2Y/rET3Mcb6q7F3JHOmxdKiMibgv1OTWCf2e6Xe6PKd7JNzZN8II5NjtUmjvlBOKc3xo
         siiw==
X-Gm-Message-State: AOJu0YzqlfTHmfQHV6PRGayTxCDDcS0XoTyJ0FWX4MIHJW3oTmb6j7s2
	LftZhM9A42K3u5E1IMnkga7L8y+6f2UEacepPwdY+k+DL5bzdbDb
X-Google-Smtp-Source: AGHT+IFPIGSNoq7pKYDhMfYzlbbJCa5NYMEd+nCZ7spV5q2pirGrNOs8bvGt97VJ9ExX3vwlY/BLrA==
X-Received: by 2002:a17:902:c942:b0:20c:8839:c517 with SMTP id d9443c01a7336-211823b5347mr428465ad.53.1730997582019;
        Thu, 07 Nov 2024 08:39:42 -0800 (PST)
Received: from [192.168.1.3] (ip68-4-215-93.oc.oc.cox.net. [68.4.215.93])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21177e6a471sm14142415ad.233.2024.11.07.08.39.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Nov 2024 08:39:41 -0800 (PST)
Message-ID: <05671820-dee5-4b31-b585-5e1f034e65f6@gmail.com>
Date: Thu, 7 Nov 2024 08:39:39 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.4 000/461] 5.4.285-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hagar@microsoft.com, broonie@kernel.org
References: <20241107063341.146657755@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20241107063341.146657755@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 11/6/2024 10:47 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.285 release.
> There are 461 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 09 Nov 2024 06:32:59 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.285-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>

There are however new build warnings, on 32-bit:

In file included from ./include/linux/mm.h:29,
                  from ./include/linux/pagemap.h:8,
                  from ./include/linux/buffer_head.h:14,
                  from fs/udf/udfdecl.h:12,
                  from fs/udf/inode.c:32:
fs/udf/inode.c: In function 'udf_current_aext':
./include/linux/overflow.h:61:22: warning: comparison of distinct 
pointer types lacks a cast
    61 |         (void) (&__a == __d);                   \
       |                      ^~
fs/udf/inode.c:2202:21: note: in expansion of macro 'check_add_overflow'
  2202 |                 if (check_add_overflow(sizeof(struct allocExtDesc),
       |                     ^~~~~~~~~~~~~~~~~~


On 64-bit:

fs/udf/inode.c: In function 'udf_current_aext':
./include/linux/overflow.h:60:15: warning: comparison of distinct 
pointer types lacks a cast
   (void) (&__a == &__b);   \
                ^~
fs/udf/inode.c:2202:7: note: in expansion of macro 'check_add_overflow'
    if (check_add_overflow(sizeof(struct allocExtDesc),
        ^~~~~~~~~~~~~~~~~~
./include/linux/overflow.h:61:15: warning: comparison of distinct 
pointer types lacks a cast
   (void) (&__a == __d);   \
                ^~
fs/udf/inode.c:2202:7: note: in expansion of macro 'check_add_overflow'
    if (check_add_overflow(sizeof(struct allocExtDesc),
        ^~~~~~~~~~~~~~~~~~

In file included from ./include/linux/mm.h:29,
                  from ./include/linux/pagemap.h:8,
                  from ./include/linux/buffer_head.h:14,
                  from fs/udf/udfdecl.h:12,
                  from fs/udf/super.c:41:
fs/udf/super.c: In function 'udf_fill_partdesc_info':
./include/linux/overflow.h:60:15: warning: comparison of distinct 
pointer types lacks a cast
   (void) (&__a == &__b);   \
                ^~
fs/udf/super.c:1162:7: note: in expansion of macro 'check_add_overflow'
    if (check_add_overflow(map->s_partition_len,
        ^~~~~~~~~~~~~~~~~~

-- 
Florian

