Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793920557;
	b=zmPA00oMfIX0J5EaFUuIiPPU2PhT8gpC+GD++Fjxycc+95ij8RRyiwAE835IDtApn/Za
	 YErNcXDAjts82XRi+6+5UURRdHiN0CBixw+y0x+BqqPD/pu2AkO0v1kWRcT7oHNTFmGmX
	 ue4BeCX5M9PWQLkwvXJyFpNMfBf9OK/lbmNbLTRZGiQC8x8huYhDwOovLTudAJzbb5FN5
	 6cMXYfGGAMvkwoNIYtZcSMe1Gs4sLo3EeQ9cv4sq/bCcFH6HqO07XMvr+B8ENe4czwTKz
	 hmlDfMF2gAmcsGrar4tfo5X0STAYRdSU9RMKFDX/Y9PuPcx0wAbVOJgKdwgkXhgGN/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793920557;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=ZIBbko/XwwoPcFK6nltO836d/lcp1X0dnZPX4hmz20s=;
	b=QI6bFBDMsDzqPTYXrLVrMDNRx8DK4OqEfGX0MISB5RUwQI/5uaQz7Lsjy2iTCqtp3DHY
	 4nFR/3MBqeuVfyc7Zvhn4/CQJeeBGrA7HQb3cs2h2/8jkEYYL2M26EeELnKBCcfeml8Zn
	 x94SNakyb8UOMBW3IGafdpL4n7F5evUroSkbAQW3WCz88L6cOh8volhBu3yMrZA8sRWHl
	 S7V5mDjPmSLrkJBiXrWGuUq30EwWw2j+vPkhk+l6yt8y2bBcxnOb4DlyeDNE58PYGIib9
	 QxMOQEbxw3NfN7c6wwNnoPoLu1I/QIJOMmCdPVDL1toLG44RQw1RE5xKxHPmvuSKtBA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linuxfoundation.org;
	spf=pass smtp.mailfrom=linuxfoundation.org;
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=google header.b=QjGSGETz;
	arc=none smtp.remote-ip=209.85.210.50
Received: from mail-ot1-f50.google.com (mail-ot1-f50.google.com [209.85.210.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3547D606A31B
	for <patches@lists.linux.dev>; Thu,  5 Nov 2026 23:15:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3547D606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=google header.b=QjGSGETz
Received: by mail-ot1-f50.google.com with SMTP id 46e09a7af769-843cf077f10so169799a34.1
        for <patches@lists.linux.dev>; Thu, 05 Nov 2026 15:15:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1793920554; x=1794525354; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ZIBbko/XwwoPcFK6nltO836d/lcp1X0dnZPX4hmz20s=;
        b=QjGSGETzMtlue3mbl3DlwT49Wjoc0ZwVMNo2SL6Ci5QxVcb5v0vEnO34F1HMM2Az9L
         7dIrR0FTTuceQVMxu/xATGPlyrWvpQt7zOxLkOAh46ZUg0wEACqweGYbsd2YjzFb/RG5
         D15+u4wyQZfi4XkB4k7hgOVHOli7UKB3cdrGY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793920554; x=1794525354;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ZIBbko/XwwoPcFK6nltO836d/lcp1X0dnZPX4hmz20s=;
        b=1xZVwXAuxsnx6LoHtGXsAwB3zloOIwO/Xmaz3MeXNXXcQYX5QA5xUHPZ0xLpJ5qFWG
         cQVFnkLQB5m7wm0y4xVf51IlRLkJrTTGaNKLrK2kalqhQ9+22fcYMvMg+BUscaIeRMiv
         3EkV62O/phr4vu4at/FdsvjqlXJV5x49J2joAfeKVewvFiyL96NmAtB1CWin6Al8RcwJ
         qPgJcuQ9Hpsmg+TiDPdezQV7ZgWgj09jKhVXQ7tsWFtL3RS/VmfiOJceVL/eX08oeSDp
         /ebI+6WvMmSG9ycdi11VoNs6iHwzA2EJBmbCFdh/TIlMdWBEkAGyS9ov9iYsQDKFNBz3
         TY3Q==
X-Gm-Message-State: APuU4Z+5yxinxHmnUtJLwigMj7khqj/9xYf0wYXcWDPHpSB2zWXMFX22
	Q27WmaZUrIWxYblbrLGiP6yu8xtaGMeD/YbKfpKnpagEteErCywJ2dHgHYHSyr05yLo=
X-Gm-Gg: AYBFou2MBq+c6dp5S5HOf23LW6IqV1BHoajObt/zGGGPXo4Jpmvr2tWRUmz40Hfz0zy
	99tER3/5dwCpLDqhoWWDY0vNPkYgzPvknZ0SJXujXZvvaAUZj6i/L0rOpSTjQRy0simC3fGnLEk
	vpYztRk4uc+TYg68RJkYoASvJjl4aXrnYpf6NXDlDUiVOLNToHcqNq7Z0BrB/o03EVbzCDpazFz
	BQaCby/ynM3KrzH81FnXJJXE/OIe0mpCTdH3VL55Ml7Ui1WYrOWvUzgF7TjKqZQDREg7RHWZkdI
	jJsC1rMFUXLwQeCw5W1b0HmGHxQhHS6AQQXQYIdfmoA8foO9hM9YDLUPbks+cr3WIBBQKrG2I/l
	i8M2Fp0GtIvC2TSxWdmSlfKSe5jp8vQUQ8bb/Me/bJSSKJBF3DcGEw7w3rGQRpmwjy5UKMBUd/a
	BRnlWHmMZp6UcBIuEO12ty6E7dfMjaWgCOvKJYizwFlWuQSXBOq2IrjH3h3bv/eHjShoA2q8pCc
	bZowbtwkohCP6J85SZ9i8/xJFv1xYc634IVKGMQJH1WWP72/RrlahznaJN9SWJqUok4nFUkvwbE
	sNSzF9tt5UZIM0Phgapk204QNQq+MPpPSs+ubko=
X-Received: by 2002:a05:6830:4127:b0:822:b35a:a2c3 with SMTP id 46e09a7af769-85f1ce07346mr993561a34.3.1793920554194;
        Thu, 05 Nov 2026 15:15:54 -0800 (PST)
Received: from [192.168.1.128] ([38.15.57.99])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-85f1dd234edsm541102a34.16.2026.11.05.15.15.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Nov 2026 15:15:53 -0800 (PST)
Message-ID: <4c7e5229-04cc-4341-a495-0156dc3c39f5@linuxfoundation.org>
Date: Thu, 5 Nov 2026 16:15:51 -0700
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.3 000/547] 7.3.2-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/4/26 14:03, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.3.2 release.
> There are 547 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 06 Nov 2026 21:07:23 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.3.2-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.3.y
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
