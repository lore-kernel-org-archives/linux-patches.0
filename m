Received: from mail-io1-f49.google.com (mail-io1-f49.google.com [209.85.166.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27D385D494
	for <patches@lists.linux.dev>; Tue, 12 Dec 2023 16:13:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CdQPN4Ji"
Received: by mail-io1-f49.google.com with SMTP id ca18e2360f4ac-7b70c2422a8so38740839f.0
        for <patches@lists.linux.dev>; Tue, 12 Dec 2023 08:13:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1702397585; x=1703002385; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1oyzEVdmAliGsUngMkAe6aQzEr895fuMODSqQrJ+wJs=;
        b=CdQPN4Jiid+NCRdVGGr0RsmXFUb0lykNNdWU66wnGYjC4ng8xLdUqje3jmjSfffxsz
         GsK7xKbxVguAp6zdXjrrf1j5r4rLTF4Ilf3i3RMCIkSHhZLDtflXQPsmN87sSyVR/Z66
         apXkZatN1NzbOs5tLHzvRjSCBWJtFVax2PbdA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702397585; x=1703002385;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1oyzEVdmAliGsUngMkAe6aQzEr895fuMODSqQrJ+wJs=;
        b=lwibo/qDOnyQSRDTq2Eauhc5nAvuADA7CI3JqNonC2SwnH3yG1Y/CUE2SJ7IAzYcsq
         pQOLk+GETLlBGGqo8tBdQEPCIyO83Wx6jAd8mOOX35ovYvgZMW/p/cv4ZkLbak3EEAOq
         0XuV+MYvubkmFzA0ygSFr7yZ5VDuOg3YUCKwg3yLPMuI36jhaATWbOmmGatZAABKwN2J
         UskBVQK0TiQdZIF0U9wgE6kinRWkXV7jAwkBCMBqHcPE5BVXDzm6eoqf8+zPUK4S7V4L
         sAhgC0SGT2XNdRiq8IjUSp+8CZpRiPwuKpuPNNvCSQXxgy0YazsdiszA3WBHBDOH8QJ6
         YbeA==
X-Gm-Message-State: AOJu0YyjxxtWc8bZnyoKBw1yPp/4zRj+cXQwz/xmZGnNsDaD43D5/CuP
	XnERVj2bnXwZy2DU6hqj0KIZHg==
X-Google-Smtp-Source: AGHT+IFjRYP2mc0SFnikAhhPerZKmWl5K81RkC+VqPe7I6E24/T0KK8w6EA39VLWbZw9d5EE73Wiig==
X-Received: by 2002:a05:6602:257c:b0:7b4:2bdf:5a27 with SMTP id dj28-20020a056602257c00b007b42bdf5a27mr10661594iob.0.1702397585277;
        Tue, 12 Dec 2023 08:13:05 -0800 (PST)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id t1-20020a6b5f01000000b007a6816de789sm3012606iob.48.2023.12.12.08.13.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Dec 2023 08:13:04 -0800 (PST)
Message-ID: <1d900249-4160-46b0-aa66-00ff2a7733b2@linuxfoundation.org>
Date: Tue, 12 Dec 2023 09:13:04 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 000/141] 5.15.143-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20231211182026.503492284@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20231211182026.503492284@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/11/23 11:20, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.143 release.
> There are 141 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 13 Dec 2023 18:19:59 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.143-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

Tested-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
