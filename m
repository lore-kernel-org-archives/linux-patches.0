Received: from mail-dl1-f51.google.com (mail-dl1-f51.google.com [74.125.82.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83F783B8BA1
	for <patches@lists.linux.dev>; Thu,  9 Apr 2026 18:26:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775759199; cv=none; b=KHALL00BuBWRFAPXW+PkddxAAGionKUekonvT40oWy9tUuwtiD6pkQNgXB9JSjsVmr9OG6tFRvP2RXwFgp9rXpOj7+ts/Dc736zCneBqQi/23vGPoK0bKO1mqHK+Q2mLLak6+Qqyh9QhZg/UBHrgpPXNmDqIWmQeXFG4Ob2tzKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775759199; c=relaxed/simple;
	bh=CFe4r5rqzqt/Sp7WENq4hddAY2QStw41+2r+0OQ2yto=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BBh3t3hQXbDY+HwNTMHakWyt0jukiJNI319YThMnghW4S5EQrHLBJ07X+wECbceXk2e441yllti2urVPvh0tW2zOlWjmaYYw4YKdgg5J4oNtFv9PuZ4T3Ag5w9Ko2qL2fobpbvnKuKKQv5uiMBSLZDV8QlUTxttHz0fbTJ4t5vg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=q/i7EN7s; arc=none smtp.client-ip=74.125.82.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="q/i7EN7s"
Received: by mail-dl1-f51.google.com with SMTP id a92af1059eb24-12c25b90264so1150924c88.1
        for <patches@lists.linux.dev>; Thu, 09 Apr 2026 11:26:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775759198; x=1776363998; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VdKL7tHwSlpCH9ecELkoXd/ttoxemvIIYgeBw2frtN0=;
        b=q/i7EN7s8ap/N4oWdpVsTCoga0tGB0HseILpmbDvLV/fJO8MAjRbZNhhkrfCEr4pH1
         BoF+eQY3hx8X/808Bmh3HONeLnb4wgqon+cWa/ta2MjWvpnI7Q1+jlWfO+dS5jWt7E9T
         QJzcTeIMK9iO1LqtZimvdF9PaVxlwAdqrSrpsIFjdw3r+s60IqEtM3313YID/u2B9Cri
         qTIKqImXLchW0L5ztyu4pzoG0k+B3ZxstfJ1xIpVhbBVbBigkFR5FwOrMGQWb2dRsbXP
         Fep5nL8VWustVzkEnCJGY5NnMBaFNfEDGnhRE/jMTx4933GWKW0yeSW/MuTxdd078p16
         Z/jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775759198; x=1776363998;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VdKL7tHwSlpCH9ecELkoXd/ttoxemvIIYgeBw2frtN0=;
        b=gMB3QQITaIk2NHun12gshppA943YwEsuFyYZ6pl8GDQLMUdhx0wUVRHcRImrwhF0a9
         YaWyJZWGmPPPfPZjoR7o4KCOonHB1v0ZMJJS89PqKVEoGHWLGFH1ti1Gn5bJvC0boWpQ
         VGU4Ys8Z/I5Mcn+btPaL7eR8EDZrd+9EpIFNISPVws0MKvOMKDjmnQ7t/jbTNWC9iJ+R
         BE6azrUw8MtfhHkDPhgmURTTZbkfeBguyqJL9sRSV6LE4uQ29P8/SkLGgLQ4+bfFCUQk
         o/T4skKB+mEuTJ1WPt5GmN+4rYXR4eGds/W+Wf0R07MNmDnRXjga9dDQf7Y4xhV02Q5w
         pbQQ==
X-Gm-Message-State: AOJu0YxfnRX2XrMSHI8OhbKgGZx5cCpmH9Y96/xh/pWNkZy69rQI8WRU
	b/Kc8Hp9u3rEA1L8KgijoCAReW27x7Ae1M4y6AugOB3mxGHSuerpAldB
X-Gm-Gg: AeBDieuINhL/uYayOGeIRPyoiBQaf0DtuwXK6mG8G7ePbXmXHifp3CuQaFsJSsQnfwv
	MJNSZlh2Oy3sOpZkgbATTnZSqOmQ6V8fSWx+zuR9ne64smolBT/vtfh5kZqmQ9/T2TZ0CwYcfTL
	Wok/7bUqJSj9PcKEkdyVsvVYaMjLfM2vXpIoSEO+VLHXbQ5GYFe4Zy89tv4pcTtVz6sF7zZXdXG
	x+58Qby0Eg5GX+zvQAeaRCO3SNpLHAJVVg/g7ZOvsf7p4davKTBOlARszw+CqklGGo339f3mNNo
	smCTLY7ck0qIfc3GwcRpzFOUORqVEnEFIr++PLrbej7QIrOaNs3bQKRTFqYqcy3Amj7iqUOdzlP
	ACD9+JXitu2q6NeZmS5Tr7RDXsEMPKeu82VFxz9XHcsZfkptgnhg1VvxLqEKCefnOWdtANqEhPK
	UDycNOqaq+I4uQG5eKj636Dzc4TaTg0/kZAr2UIczYX6iOar9n9g==
X-Received: by 2002:a05:7022:670a:b0:12b:f881:d8fb with SMTP id a92af1059eb24-12c34e3979dmr94352c88.3.1775759197531;
        Thu, 09 Apr 2026 11:26:37 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2d55faa586bsm929906eec.11.2026.04.09.11.26.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Apr 2026 11:26:33 -0700 (PDT)
Message-ID: <88bf92ac-80fd-45e5-af96-c3454cd0b911@gmail.com>
Date: Thu, 9 Apr 2026 11:26:30 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 000/276] 6.18.22-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260409092720.599045151@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260409092720.599045151@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/9/26 02:27, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.22 release.
> There are 276 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 11 Apr 2026 09:26:30 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.22-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
-- 
Florian
