Received: from mail-io1-f42.google.com (mail-io1-f42.google.com [209.85.166.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA91314B972
	for <patches@lists.linux.dev>; Wed,  2 Oct 2024 23:57:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727913425; cv=none; b=qC+EBRlb0vto/p+8HLwSGaNb0QV2tHgqtePPw9eTogjdlF97DSjy74uf7c2RhcC/AyYLv6qyx2GWQeNm4YVwVp9nu96WdxFWxv2qIHF4cWIQ5K4ky2E8w/EANonqXTSNCiA81snzMU8hc3JNQdWDthqZQCTV+5ud8eouFFQ2Qrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727913425; c=relaxed/simple;
	bh=YSX9f0KPIXq8iPsOQ9VblraJvhf1rUMHCzbKCRGyTjE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kEXyN/8K7KkpbEio1Uaga8QbqOw6zUlLjCNDUit8vK8FsUNRenTCRWYvr8xF8Bfoaw71kV0qLVgkr488fKav/sWgIs2k/tf4VQRg6aIJIScsmNapdIjgts4OrFEuoX89Wk3eaKBPTLMiIUtkouUaXFsmTIDMuWp++DJBkqeeQ8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WHmfoXUo; arc=none smtp.client-ip=209.85.166.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WHmfoXUo"
Received: by mail-io1-f42.google.com with SMTP id ca18e2360f4ac-82cf3286261so18780839f.0
        for <patches@lists.linux.dev>; Wed, 02 Oct 2024 16:57:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1727913423; x=1728518223; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=OSyZMGPQXKBkz4kZ0qmjNo27H4oSupPDSi35nl9XIMI=;
        b=WHmfoXUojMu4vumY4sOH3ww8H/6sEcIC5uGxvYuE9gi1xa+aPYpcelhjLFa+ixOS0B
         bo96thboIGXDWu+d9I+0eYynV2aNRB2q7gCrkCHWqWtMo2IQjXgAEoFUPmHzVRTVZsXA
         yJy6OVlO9ZRiqnpISNbqWDWLsQOTReN/HRMww=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727913423; x=1728518223;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OSyZMGPQXKBkz4kZ0qmjNo27H4oSupPDSi35nl9XIMI=;
        b=A2QtdjBvIt5QUxBxMF443486fUWJzsBBi4jKSNY+kH9m0KZ11v75iYuW84lhqH6upj
         q9M+vxvVcqDzhuPDBPIWhYMhZ+E+zX2eDRfQzfikYWhVRNmv0OiD65er2MQO0gCHkx8y
         jAx8lJVVfkmrXFRS1zIeOyKEdiH8/vjHf/FTn+oDG0IQWIU6yOBQjVFc3HecSi9nxK6w
         7DdTTegm338enXi15x6QeaCl0RaW6RcVpGuyJfilQ8CI7twvSPVJg4G81QAJVH0iXv7r
         wgvl0bAbRcITDu0JSG00ksZ5FGJhsIWfToGMII9guCOSnL7hJxas1MpEPlRcQJATx1Lh
         Br/A==
X-Gm-Message-State: AOJu0YwkdBrXXaLvpRVBz0k5raIC8KHvFQwgxaRU+Q7FKYppYOhqHajw
	M6AvVxOamzPkZdNbXLfZSVgrDbm70PAz0nys1fLexpd4l+KvpnxiPassCmVLz0E=
X-Google-Smtp-Source: AGHT+IHh9kR0yfoxmhoMxEgAl2XLNnn0nCCHbNVux1JmoYXp/yKiayDABF92tCcXiqy+TMLK3eBsiQ==
X-Received: by 2002:a05:6602:6c01:b0:82a:3588:994b with SMTP id ca18e2360f4ac-834d84d0b75mr559838439f.15.1727913422764;
        Wed, 02 Oct 2024 16:57:02 -0700 (PDT)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-834efe38883sm1197839f.52.2024.10.02.16.57.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Oct 2024 16:57:02 -0700 (PDT)
Message-ID: <e500ad8b-07d6-413e-8fc6-2a9afd5593de@linuxfoundation.org>
Date: Wed, 2 Oct 2024 17:57:01 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/538] 6.6.54-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 10/2/24 06:53, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.54 release.
> There are 538 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 04 Oct 2024 12:56:13 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.54-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compile failed on my system.

libbpf.c: In function ‘bpf_object__create_map’:
libbpf.c:5215:50: error: ‘BPF_F_VTYPE_BTF_OBJ_FD’ undeclared (first use in this function)
  5215 |                         create_attr.map_flags |= BPF_F_VTYPE_BTF_OBJ_FD;
       |                                                  ^~~~~~~~~~~~~~~~~~~~~~
libbpf.c:5215:50: note: each undeclared identifier is reported only once for each function it appears in

I think this is the commit. I am going to drop this and see
if it compiles.

> Martin KaFai Lau <martin.lau@kernel.org>
>      libbpf: Ensure undefined bpf_attr field stays 0
> 

thanks,
-- Shuah

