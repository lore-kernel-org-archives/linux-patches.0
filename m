Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.180
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793293007;
	b=eFrrMp9NCkJROdRsXLCexlECSnqlAaH8fJ6bnMrqX4jeXgX5Q+VU/fds5huasdr8iZPP
	 TcsKrLDC9n25U4nSmlLgghqXB0r5V2WW2Ye48QCWfANptNDZW6JZCPssGOGVtIqZcdtYA
	 4WyI/6osBfSLn/onKgDOWb8kGZ8p7AtxywqPYy018TT3DauQBg3M7nLA/7ari7Yk+Vdq2
	 pcTa+is+dp/xlG65FoIwz8X0SZAzG6cqMmK58UNw1t0n0Jq/x5k/I7e93fCeKKNdxVX7E
	 Hjx6KB3gEtFNvfTLAj/l/Ovx09Jo2ihJLA25hfrdOkv15ea2Gp5lVoffYTGpWDvuXIQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793293007;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=WWvawn1VUbfsdNDOyAeUMwlpIb5qvBLu/P7NpzoOW3w=;
	b=GuDxQrEhHyIl2a8iRwz/eVV5DbzkjrxkvbqjElusteIYSH1RUAdXCTElK/3uHRj0d76M
	 RcS26g0BsVC1s6WSmkO9vPDhCOsMQJRr9qsqDJk0ubfbh3lK+fnKjlHpUMjzJAKW4+Hw4
	 zJ5e7Q9zMzsaX4eNeMEXTYrcsfJ0ce6wwarQCuEJHqw9txp/N6qo2lY0dUS9EDWq2S/vn
	 7j3wYlM5YLv7aOMopykwKcEz4z008eiZKVPt1KxyeouaEBnRzkcPcmMf8Ali9N0pF+8Mw
	 sEt4m2ZvZEI0oxltrg+2zdfsxZARp4eHD1DOhngcXv4k+F2vHHO5WHx+aVPiOSOwKog==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=eY0R9s5v;
	arc=none smtp.remote-ip=209.85.214.180
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5CD1606A320
	for <patches@lists.linux.dev>; Thu, 29 Oct 2026 16:56:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D5CD1606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=eY0R9s5v
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2e812e2b31bso14853975ad.3
        for <patches@lists.linux.dev>; Thu, 29 Oct 2026 09:56:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793293006; x=1793897806; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WWvawn1VUbfsdNDOyAeUMwlpIb5qvBLu/P7NpzoOW3w=;
        b=eY0R9s5vBbR+TS+RLTcxENmeg1EsH3DZSq3DkJT/lb04oLdQ09/UpTGaq0kVIOvHCB
         bCbMJOgA+53aka+JgFa4zxG/hovcOxYl0YzAvUHSQAz9QiuStfzyJ8AhtWSPfToWbJu7
         uUsfA6kWEJhzuyOu4UF2T9OftTRcMDx1mLSOoQBLKhBFZJtJzJWA+1BOp1fC24iB7sJQ
         uylamR7RwXhlfDSGVX084720oQ9bKNmrqrEUoc8cx+jdhdG9Hd437VNb8o602RMzbByt
         IAvkx55+V10Xyq8wPsak4irpcGIrnepdVNciEHKZc60VGRmnm923PMFxUiH7ZDI0hO6z
         E0Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793293006; x=1793897806;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=WWvawn1VUbfsdNDOyAeUMwlpIb5qvBLu/P7NpzoOW3w=;
        b=AkNWGEiCh4JsLvoCDhaJZ7IPEau77SrRj1qu0opAZ4OGZNqufT3deYf/7K2iCEV59h
         jdMnfOOcrVIndJaxTWyf+p2SVc12/dx89yPYP6MNUrvq8mUrKirJpBl7/R6RJzQkGyic
         cnagJUhNbFW4pylnBXlGNv4w9cz71GyteNPxlrXwcLgnBmIU7tulA7JczE09Fj1hsid0
         bck3oVaHJ2HoU4Tc/sHb64V2Ehn6I6uaJSjrxD3qrLCuS9U5qBzB2xaYa3hwffJz5Yhs
         BRTAMr6q238thG8/ldH4QLgHco7U87zxcqa0UspwbNqplQXz3t3VaASpGlt6T7J1jsZ5
         O4IQ==
X-Gm-Message-State: AFq9FYL/c+fcROtUdiQ8Gt13zNVJRdmbosPDP5+D1JYYZQX1qw591N6i
	YC0ONeFA3/3N91rlAGVfKbRX4gy4vqJEGTRF3wiedPQMhSBl2x9mzKsj
X-Gm-Gg: AYBFou3alSQj4rga4yh+hfVMosTXwWGS5PWAGecApYOTdpsnx+p9OsDvcDdCdcW2Vju
	hQ5rzhKh+PwQT4xjk5ugZggEYXCBSC7+0pqpkJi0YAhTEiC6jVaiu4ef+Bkj3HFdkigKQr+1JIQ
	aQuoiIfTI4+ERLZRDZyuhQTz/ZSkgzkYNJkKs17MZJLlpyPg/HMzMPIdMEXeRMVMOx+9fdSjudV
	UU5Tt+xaOz8jbB9CK/GxdNpP5xoloBIpRJeZCBqHijltUMSBi1brGwwgJf58qMk4R0ChxP0vBCw
	hN2bsBBw1IBmi3/osnNDS7iIlgUfmdledjxpaE6cub6nO28aHv85rf3lc+ztY6OxInxOO+L+FbM
	NJoDOqZ+poYpr2TTffptn8g8twr9Vn2tEAkxHC7TcFHABpvNvkq3A73sIN3hZL7WzaQFTZ4JRP8
	tM2dZ0En9zxgK4dh29bNMjKkUYByBPoTKE4elDaKtQJd01dzj4RXqGZcS+enCiTKxL2lxKeXaal
	P/Uz5gscQZ8SousTRjVQfdP2OoRE3+SslGOKA1pM0th7/2dIdiW1FvTEfkFUZXYq5kieCvmroPL
	uSFAYn1z/TuCN3R5fhr0YWyPezBD1iO5gf7MaNbmw/9E3QjTabZMcG6EWTC7pYRwia03gjynXpy
	lfA==
X-Received: by 2002:a17:902:f54a:b0:2ea:9c9f:b24c with SMTP id d9443c01a7336-2eb0036c512mr50551235ad.23.1793293006075;
        Thu, 29 Oct 2026 09:56:46 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2eb3630293esm91935ad.29.2026.10.29.09.56.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Oct 2026 09:56:45 -0700 (PDT)
Message-ID: <ed8f6758-7fa4-4d6c-918d-160bd97f86b3@gmail.com>
Date: Thu, 29 Oct 2026 09:56:39 -0700
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
Subject: Re: [PATCH 7.2 00/88] 7.2.14-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20261028165942.107695352@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20261028165942.107695352@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/28/26 09:59, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.2.14 release.
> There are 88 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 30 Oct 2026 16:59:22 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.2.14-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.2.y
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
