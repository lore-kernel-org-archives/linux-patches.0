Received: from mail-il1-f181.google.com (mail-il1-f181.google.com [209.85.166.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E87C25E45B
	for <patches@lists.linux.dev>; Wed, 30 Apr 2025 15:57:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746028672; cv=none; b=I82LyfyHedEimaeXrqtrDf95Y6hc2z1NnN2uTMKIS+tA8Q92SgpD8ZyD58/sfayrvE508IEFHee63CdKcr5ceekebbAJRGEZd54WMFcjsQz/0iTot5K9toBiVY++aAdBLu+8mdH7L128vz8qcvcag9cn2md+lIi0vYGt/gh7LCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746028672; c=relaxed/simple;
	bh=icooOvG1MON2fuybzZe5mX+3Hn69WjdTbAsnDAWzhG8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=G1n9QopUqc/fhdpe+6qNiWUwborFzCMLF50vp+DN2OeGSu2yS4/Vjp/Dt7/IHRgN62Lo6FYW071+iooowvp0IUvKUYHbfouRfTnGpNlaZNzoLAM+hLnhn2lofGCV7n9NixaZfsnc8cfv2D8/3VHwS9LrQcd5r6xVUM0zq8x7KKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A3aDxsCi; arc=none smtp.client-ip=209.85.166.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A3aDxsCi"
Received: by mail-il1-f181.google.com with SMTP id e9e14a558f8ab-3d4436ba324so69956085ab.2
        for <patches@lists.linux.dev>; Wed, 30 Apr 2025 08:57:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1746028669; x=1746633469; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=in+6deFjqSfAc1zu7tlNRMCOyeC3LE1Gyw7rsr3duwk=;
        b=A3aDxsCiDxBrJEruwzfJVqZTS3SG1BeP7NPS2RN+U3jeSLz7FOEEG6OEzWtGywnDnW
         /DQEtJoRNlYzDEAIy82HggcVd0sZcx9LXNFJnWDcTL3jKNEc96/dzHW5CacgnThZm5U0
         T7Br9yrxmLrm3pA/MSGM17TPiGMT1Ovj7uInk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746028669; x=1746633469;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=in+6deFjqSfAc1zu7tlNRMCOyeC3LE1Gyw7rsr3duwk=;
        b=Q5fddCRFxjBIsK7thmXwvY1MNu4WlBWwytp32DyO2McEgB/f4tdPPOECWdFsiLAj6d
         USgNorNTNO2Lp4kPk3lxSVCZ+4Sv+tdmF5VQmeQvqu9YOZytglS5xNj78P4DotYXdiSn
         DmqOb/ob/3fDe25xjuGHcBxEDPs9NrzCdpxDAbAjVpi5h6f5chySwgrBJpURDQjhkb4u
         57dLpGdNYxtF2KPu1Uw8UzRJ5woU0t2z4LW/dbWP7Jmsvh3linLQokDk2xX9aCQduHK0
         gC/ezxrFrmSlOmxF4GpJwP8uZOS4sLziYJBEv1zyfCFnoP1F0k83KxWKWui46r77yg5c
         FBYg==
X-Gm-Message-State: AOJu0Yw7GRQz54/rPOhMPH/C4x159IpCrnavg7ZTndhFSBgj+h95FBYw
	GBJe5qa1Ey2/8/45fmhlH7En8GVFwfRO8/UcJrLGUlltgqAmSTYWNFgBve2ZTFY=
X-Gm-Gg: ASbGnctX1EUHYzZmiXHRz8KAAauni+Pj84UyKTKEDvJjl40ptE8sX92Jtw1Roykz00E
	8M44/AE8OCIceHRzE7Fq1vq7rL4b+jCvwgrkctjTFwi/ircIQHRzoVMYbvpV3i1QVL7r5cWI0Tl
	ct25axbAKYWFzRzFW4fnmmeXipJM5t3eH3eUAZ5Eslm+v68KFlgAzwlhMwxLkAyKICZ3T2Sd+vF
	DZtKvT8kLLe81uSBIWKyWHufi7tfZkpc0TLbxGdEaLLOPjCCFxF1JK2JhSfNNBItnThKeuGlMt5
	YoSvOJPiLXfb4L2ZjbnruLEcazp9LmULuSC+YINrOKWAMSRI82U=
X-Google-Smtp-Source: AGHT+IGYNWe6JaNQWYYAzHPd9GJwHWYQBcIrp/Fmzu3Vd7QqTXMxBqlXe2nDlYYI8grBym/KiaLjMg==
X-Received: by 2002:a92:c267:0:b0:3d6:cbad:235c with SMTP id e9e14a558f8ab-3d967fafbf1mr31807335ab.6.1746028669266;
        Wed, 30 Apr 2025 08:57:49 -0700 (PDT)
Received: from [192.168.1.14] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f862e0eee0sm809734173.25.2025.04.30.08.57.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Apr 2025 08:57:48 -0700 (PDT)
Message-ID: <b40593ee-e527-48db-8e53-6973b3b94858@linuxfoundation.org>
Date: Wed, 30 Apr 2025 09:57:47 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.14 000/311] 6.14.5-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20250429161121.011111832@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/29/25 10:37, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.14.5 release.
> There are 311 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 01 May 2025 16:10:15 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.14.5-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.14.y
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
