Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CE6547DD64
	for <patches@lists.linux.dev>; Mon,  2 Mar 2026 20:16:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772482573; cv=none; b=DWGe26vMkjFTy0c4cjPjyj9qlSjjtw78sZC4M9SNnXBaC/cx0g23i6oO6rypvIDMf++EJ2TY9US1IKnwRHTOv5ztWSyXDcKjFpwxRX4s7q+7Ee174zMdqoaCVuTmhZGXmv1jl/hz6UkAFPK7/e/d45ff2T32FBfCElLnHWuD9Fo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772482573; c=relaxed/simple;
	bh=QiZHOnA2eEBQfIIRE3IPtM7IP7P35q0D22E9DVanSgg=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=ZPbhzqn6zYVyRNMTWttZabuyDGUdIEq3eNYsUM03+QFLIanpDsc4OtWYC2kPrd3ycDcBri4AGfBt4STKBE9anEjsl99ro2w5UT+8Gr6W0hXAmcbbIvfn1Y5RQLmTYjK40VCDIv6CTlfmfqHX/TynBJjR/yQIxjDRVcT5qGcLaag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NByTN8NO; arc=none smtp.client-ip=209.85.222.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NByTN8NO"
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-8c711959442so486351585a.0
        for <patches@lists.linux.dev>; Mon, 02 Mar 2026 12:16:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772482571; x=1773087371; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:mime-version:user-agent:date
         :message-id:from:references:cc:to:subject:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2rbwK3FD7LtGRl9qlEfWVEnZGUsD1TibT3/ibYFhrvs=;
        b=NByTN8NONQaLFIc8Qwsx/0edVbxhAf40r+6wywm7Vl6LDDYMbR8cXLptxpZ54avzlp
         ji2A1T/jx6lh0PcJFUMlGa3dxPnxjkNGxVjnsUJ/Sa+Jp2Naeq1UZ0Vq+4bYoM6sWNsO
         FzEIvrRfcJ1X9KtyJh7BU7mbnDKRBI/xuGdfbvUOKUCxCn6dB/JXiEGUscxFrbD1P8b6
         /H9Tlpgc08Se9j/qIHlO8cd8xMwTgcrvlCqEGn9h8qJebXb6DfaIAoLt9UG0mJDO7Gps
         8LJabaEzAMOY5zfWKx9CSSc4M/4XcphKzMZQXfPXwBTy/bvbioHl+SRMwdg75HzC9nt8
         Zxtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772482571; x=1773087371;
        h=content-transfer-encoding:in-reply-to:mime-version:user-agent:date
         :message-id:from:references:cc:to:subject:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2rbwK3FD7LtGRl9qlEfWVEnZGUsD1TibT3/ibYFhrvs=;
        b=Y3M6iQL3uwgIIBRiOv5XD53WbFHLCiB7Z53jHI8sYIvJ+/M89RUpP9iVcdvXhcNjLl
         iQu7AfbW5YXNrdoofvE3NSzremSX3yF8FjJb5/X8QURp5nWe9nobtpBHxGhJcWxoaHwk
         7qeDBZMrkYmE3rcMJqV1rR8DV22YWjZEDnrd5mG9O+yZy7lkXpEziWrw7dRs2amxhxwL
         3RXzm2S/nsbFf9UUiNZow3/ueugrHJ79dXx8i0fCxeAN0DCLx3vDDRyXhspRSur+K/wd
         kLg+qcsPBCGNc23YQIxc1jSFMrZqMe2FK11MLQUFMWCorZICkjzxZzjs4Efzf5J4ee37
         SEOA==
X-Forwarded-Encrypted: i=1; AJvYcCUAhXNOXMKLXt/Lk9/c70VExQibbDmViC+BwzuCwb/RPI4o6dnUuEVGFHncjTj8x4SMF1QvQSg0@lists.linux.dev
X-Gm-Message-State: AOJu0Yw5qn40D+7vsTl1mQUnaxQQKewayzOU3PHXAOuslkRYXLvbJzVf
	5lMlTYWsG9ShTK9qUxW2AtwDio+jWr4nT/PBSXS1mfOSeH6PqubDKC0=
X-Gm-Gg: ATEYQzxo3n9c3qR8KMUvnf9gJhUsX8H3lvMW4xqwYxm6Bhm4JVjhMdR9FJyXoUPl9Fw
	NotSB3DoRRhXUoXGaLXobfH4sctqyvr62LdDCtB+roF3YJ5eMDMWEuNgT1sXQiL/TgnDocDLEJA
	RJtDag8tSr/iELg5sTgpFKyfde+lSkTX4dFFGhIDL8U6NC4Gz7gJ1jJfPl6QEPY5Y8rNX+n6MbZ
	anquUuXVx1doZ/YjqWKSnaTcjSTMwznWchqurI+ICewpMUeU4vhpkl4OvuSgrS3eq4ZfWothlwr
	e7Cv3C5BK356Pr0vOgovhDN+U/kQDuqaBsr1nxV4Xs+NhRjKMFBJ54C2dGYnJzqQi9GR5Omlsrh
	WVxdZdZ1/ET0MU2Wmtxd8KeMZFEOIn4GHwQ/V4U9RtOPaH9TY7yqfW965ttYuamilvAQZMBcj81
	equXeQzClY39wnHrkAf5w9Tjhd7Sfdto6uXkxgJ4nveKXgzQF7uXw=
X-Received: by 2002:a05:6214:226c:b0:896:fe61:f79f with SMTP id 6a1803df08f44-899c6830c67mr237677626d6.33.1772482570992;
        Mon, 02 Mar 2026 12:16:10 -0800 (PST)
Received: from [120.7.1.23] (135-23-93-252.cpe.pppoe.ca. [135.23.93.252])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8cbbf658f70sm1212834385a.7.2026.03.02.12.16.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Mar 2026 12:16:10 -0800 (PST)
Subject: Re: [PATCH 5.10 000/334] 5.10.252-rc2 review
To: Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
Cc: gregkh@linuxfoundation.org, patches@lists.linux.dev,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260302161007.2523181-1-sashal@kernel.org>
From: Woody Suwalski <terraluna977@gmail.com>
Message-ID: <51684c7e-b6e7-698e-af2a-f36fca4a4a33@gmail.com>
Date: Mon, 2 Mar 2026 15:16:10 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:128.0) Gecko/20100101
 Firefox/128.0 SeaMonkey/2.53.23
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20260302161007.2523181-1-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Sasha Levin wrote:
> This is the start of the stable review cycle for the 5.10.252 release.
> There are 334 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed Mar  4 04:10:05 PM UTC 2026.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>          https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/patch/?id=linux-5.10.y&id2=v5.10.251
> or in the git tree and branch at:
>          git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
>
>
Built and booted OK and functional on an i386 machine
No problems noticed.

Tested-by: Woody Suwalski <terraluna977@gmail.com>

