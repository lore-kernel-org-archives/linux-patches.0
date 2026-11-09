Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.222.174
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794254263;
	b=z70Ei5SQwOTUvVKmkATNfxISmZ5ra76zuqy5xnnV/JhQZnJUXRuRE4/rTLbyF0UuM3xF
	 YJ5BkhYVUMxnxM+UI/ImDWrrp8FHewlFT8elCoJRM3snJvvrwaCZZZeNQdoJKPdFb19VG
	 lUjDvYD254yB/TaC4gPROLx/6EqCyUe0EgWjBIMDwHaRO6R0nkoo0K0QiYKqjk+fM2WMa
	 vpGtkJ6Lue19eQoYCrNAA+7tak+VMDDR3AIUUrJwue4H0DHRaokqxOCzPikctoudcG5P9
	 wuE4eZtXj7w7GwxxjOLI6m2KJRR9ju5PXgQ1msqCBovHjftwJAJO28Mxn4PdT/kJEdA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794254263;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=ryF0rmPWcCuMTxrcqtqsxigxvgIcsmr1UjpxNs2pfHE=;
	b=T5a6ppQaQSGiRhe3/K2uzSXtVa94ZDh3Q2fyWqdXDLMMJvGIyO0eoNgy7q/8oMrPjHKx
	 /Bo5yz95ncQY/rivvIt0I9B4U6tWAMXGy9IbW8yPZ2wbl33hRwkviEIm0oeZypGkLLPPo
	 rSz75C0G9zswdfO7z+cfgjxtcKnyc4WotJVcJpSWFe4pAlTNFGuFGqPMNpiyzBv0rAU3q
	 nuC9FHNJ9I7F5IsHSC3rjhxM1+9jnIu46OB9AzsuAe7fEtXQ+8mcZcTGDXhtUlGdVzrqc
	 s/2IZW8t+jkD/N7XHSgZ5k8Uiy6iJOIYdsYdYCATUrtyaCfHZcnOFiGplmAUBplA3aA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=eb2bRpDc;
	arc=none smtp.remote-ip=209.85.222.174
Received: from mail-qk1-f174.google.com (mail-qk1-f174.google.com [209.85.222.174])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C38BA606A331
	for <patches@lists.linux.dev>; Mon,  9 Nov 2026 19:57:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C38BA606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=eb2bRpDc
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-93e6eb77f0bso109217685a.3
        for <patches@lists.linux.dev>; Mon, 09 Nov 2026 11:57:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794254262; x=1794859062; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ryF0rmPWcCuMTxrcqtqsxigxvgIcsmr1UjpxNs2pfHE=;
        b=eb2bRpDczSKq+//tt8cRKwU5ZjvSdVfFZSc/4vdQXOYrVQjGoa35RPap0yfN9x9ckb
         7sg7V23vx3tLEqTrRSpepbb1XLg0B0EcBnMYYjzbnw34fR4dr3+LOGfmR3Fc2BZX3Ylk
         ZQa4o2JfG64jMf+G8PXckZZR25QmMR9qZX9bzvG5Tokx103TY0NbBiyl91gZ+AOsboBL
         PIZbItIWEFQ1Li6o74n1Q7szKnFVtbvU3l2bfFtjK7zNCADUwx/RUxpMkRtKRSzbSjUm
         sUjYSWG/ZzGiiD190SF3f0iXzxrUN6YOKoRwJ8J7WTyZGMSs6OiR2VoqpiZka261YwRc
         cpFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794254262; x=1794859062;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ryF0rmPWcCuMTxrcqtqsxigxvgIcsmr1UjpxNs2pfHE=;
        b=oG2Lo3qTn6oiAy27zBjIfoDFODmJHEEou7AS3IMR9fd9yOCcIJ2oIBE6LbPR4iNFTK
         DuyTUNHxnW/6Z4jvEaYd7GVBhhywuFWVMlrnzWBw9felU/EWI6u9bPg/0yDA1YbLiCx/
         HgQOoLU9TMRubpUMc1OH2sNeaRtKowlERmeYAxLQxXFruXRAiq0Z5pKRDgyLnZ2knsIg
         MUPbF+4XeaySB5VYVyDCJ2yabtvePSFVH5QJjL9B61R3hpZEtvo0T2K3QrXf9kPaIhhg
         iPW++UNFWIRC9aU38VJxhY6rEEt/PORr8YtFstvdq+j7UWgpG9NhaabA7s/vNbA910Tk
         BeGw==
X-Gm-Message-State: APuU4Z/T2I/VAh2qkVAmEW9FK2hHgicBE3YgNCLguRMUZNJWWlo5yt8D
	nMfNmPKyueLcFlez3XfDZlw7bE3nWrH5rhHd97ndU6ErUXxoL/32h+W1
X-Gm-Gg: AYBFou0ESpbAc9AA82Ln83blbtD9tXUQy7dBSamDqMFlqIGgPc9Rhyoz0H39GKvv+UL
	Ib0zaPzMhLD5PI2hvm8zrClyRJh5a6VonHxmBPZVCRFzxAz6a7aXOIeOT2jTfAWMdeSwVwgcYxh
	1jJpsfRqXO5/dGoIDBZON9TJGnYuGV0w+UkQ4GlSpZ1SH2tj+dr4mEy4RyF8IjoYdUCjSNJ1HnE
	kE7dxo/IvcAbCF7fQIAkJqUV9uUxdWEVOQX539aU7NkW/Eo1MYvQ0uUReun34+94/dmQWExh2F6
	lxVV12XZMVFjGHhz7VgPPwNph+s3yuyqVa3Ut/I+hE/SQ2I0kiD3GYppvt7D8BtpjkXg2lcAaJ/
	YnqCVCWAG+1lblV6wCtmfjDiRshcOknll7mAn7sPjDTxRi88+A/EQfjNA19zuZNSwf2kW+DgOGf
	eDZT8lAiqNpQouRQBrGKss9FlN9j960duxs8sKc/uvvog6ETR4gbclGAVroeudUy86V0o6XXXUE
	xowNuDXEjhLtabUs7HvnJMVahp9V3FCVj0L/HvjdbSAn16iQtiU8aUza2CfXKjS8grwz3qqAzbz
	PbpOU1kqn93AgrHNZ0Pj3dnggxkmklTD2oBlgue6pbDb3Ds/H9tulDE=
X-Received: by 2002:a05:620a:439e:b0:93f:1ed3:a9d7 with SMTP id af79cd13be357-9479f2f0ecbmr86867985a.27.1794254261502;
        Mon, 09 Nov 2026 11:57:41 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9479e61b8f8sm54770985a.1.2026.11.09.11.57.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Nov 2026 11:57:40 -0800 (PST)
Message-ID: <4bf059ba-3a8f-4378-9f4a-b2704034ac9c@gmail.com>
Date: Mon, 9 Nov 2026 11:57:37 -0800
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
Subject: Re: [PATCH 6.18 000/869] 6.18.63-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20261107134852.069646174@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/7/26 05:44, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.63 release.
> There are 869 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon, 09 Nov 2026 13:46:08 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.63-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested with 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
-- 
Florian
