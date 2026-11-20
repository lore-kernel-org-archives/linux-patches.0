Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.160.173
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795212221;
	b=4pdOTu3LAc6k4MGgxS0jZlg28KvUQGhtRb+GgvuBpDeKh997T10onSf4SalTVLkQx3SC
	 eREYw3LVouWsYOOBOPaobzGVcHmCV5IEBO42LwaDNoda3nhuM0+sFpMuXwg4qSePLu/5Z
	 mZHs6UffDNg6NMWou5xs0rUCmiiwQdof+cMLas5TM7+uS0Y1GdzFaJC3kQ6UnQ7y8VW0q
	 Jfwkdb4zLez4hNYhMXnCuonCDHvdHcruxdscw7rcDhF3jz0HzKMSMD1VqE2NtPwb+LNVO
	 J8bi2VYNGqyQq6qTXbdEdtx+YCsgjHAD0QH3ROrPx+OmhLrjX2rerNe4K1G/SziybpQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795212221;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=Q3/2lSAbQcvG4mJse5Si002aVPhuVugxPukuQMe/+Oc=;
	b=zno4Uv703AZ5EelT55xXAXEcIqAzXMZWuk5Jt2xvvWISpXEwDj3c0xWq0RPmlOK90+zq
	 Wyyv9ddcT8z0DsazA7nDK+42wjvC2H4tmKOQp0qDrlRYJa4aB9h6FI4fmdpZ2c1dzPW+6
	 hk5p7UCOBxmsUmO9VEdI5pSjI2bMpAs2NHGX7MGs8UOYMk141kquUiFMe2xwdObEgHfPP
	 BSob2rLoH7+HonrzrAjaD0dOX9qW0KYTlPghge/rBMehWDdUP4Oi6Gv/fM/NEdmkEAo7x
	 eYod5wnhDIViZBAxLuX9I1NKHL0cfCl7uwMdd+quT6V7w2nsswtneaSgmVYMVnDoGXA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=bBIniSi2;
	arc=none smtp.remote-ip=209.85.160.173
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82F25606A6AF
	for <patches@lists.linux.dev>; Fri, 20 Nov 2026 22:03:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 82F25606A6AF
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=bBIniSi2
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-537548b811aso11330361cf.3
        for <patches@lists.linux.dev>; Fri, 20 Nov 2026 14:03:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795212217; x=1795817017; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Q3/2lSAbQcvG4mJse5Si002aVPhuVugxPukuQMe/+Oc=;
        b=bBIniSi2aZtkuzZ4FQhNNQQB2Gy+OvpKUy+ZPr+QrIsQAdzGYwB7H1dSDjWzgmCvx8
         hlGNbTgbsMVb6rBnORc4Mobe82DoxMH5JynRSEZW6XBbUboyJ147idSvvTmgZHePydZQ
         D9KdPDdaGZVtVPxZXDT4XZKDKYnRmsRo03eZuqFfMVSyBvqta/PqcNLrG8ycvdSJCRFT
         rHNyXRxBg7ApJs6+08L714mtlC2nudx+y9+KqNIXQ3yEcgeMsh2NO+74p7S8t7lot57f
         SdC6bFPOgjA9tVwVlpcrmQpuEhVf2x3zPa8wxPyEPlO+WyfH2OPlj+5t4rT1LsVLIKEX
         uQQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795212217; x=1795817017;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Q3/2lSAbQcvG4mJse5Si002aVPhuVugxPukuQMe/+Oc=;
        b=k0nEXnM6ecmFxDqCBJ+cNZ2T0aJ0ulFBsI8fixclZrazqpU5Cq81ZzSqX84keQiM5Z
         JYPHLDRbmh+k3LREGC0SoyrUEZDAh4V+LkIn5J64XV/DnI69oMFusbqeC/aeGNdRswkK
         MTRSEnIbzj+0qdy5tHeu4LDHkFrsYBXzU7S5vWu8C2olB6tgI7mx1rftj0WIoCGYrEFp
         zaHgZVt3I3BJ0kMgkDav6GQsaKDmc1k54Fhm3PWMbTHQKS/1dwIYL5L2DLFB3v4gDvz7
         Pfv7Hko/oLmC2gQBtgjCXXi0c7vMr5YihuXOrjSJMsPtN488AWgER4WfTTGJ9SNYbLXX
         Oxmw==
X-Gm-Message-State: APuU4Z9JTEW4kOdTH7e7HdyjgyBbvFiuEpGPRGalxSq9OVLVJSrObUQk
	aUEaHg32EzDzF8lUtpJQUYoanEbJStJB2jg6QtVJFA6mLOdQ6OJDkhuOcRiRLQ==
X-Gm-Gg: AYBFou0Cx8nfH2y3QBrRpj5QQT6Ya2pv6B9ptkZmSmGkfKKtM1whpocrAYg/zZnaV3m
	4x4EvpkbuvF51Urcv1dbEj6iiBA3wXbyh+ViIKHdt+w3p25+m2wNXp61wFTaxYUPwr4P3laJDGY
	0KvkveLmG7U5rKHCDysDbLb1UQY38AfcnTwDpamxXgpl3Y2VhccRDPYezJekxeWSL3kEESExAAz
	5h/sEjDtVKr42PrKdfHktj4wWeTT+bFr+n73i4GKqfKJtEYhhjeYxgvLuXkBjtwjYX/6pGEsq+B
	vjdWG4Ft+ltPvt3pR7iomE8CN4gN6ShNiODFY3TiCbskbKwOXp+jvc7AhB5is0jZbvAV08JafV8
	gDJFjALmy6/vtXLGfM16BRDDdWrMl23GzgUb02xE5/6zFICKsbWqpwkZtwx6d5U9ZTKUxrz4eaW
	7hjM0X4oex/rFx46xf/P8zGABp3jDiutGCEMNqwQfuCwKj6N0YBuewSzB5pxHRg+4CF4XAFM9zh
	lFu79p0JBKHSYqE0Exc/LslBG2MhTMKMMjyCaPgD7aHActq1u3N4K/tDnGc9NkoWVZm4pb8kfts
	IwD+vE4MNUKQLCbFoswF6uSvbNWKLYAoIXrCNjCBI2BnLG/UBDLGExtDLbz4kR43zWjemCSSYGW
	J6A==
X-Received: by 2002:a05:622a:2447:b0:535:ed1:cdbb with SMTP id d75a77b69052e-55d7688e8cbmr78888001cf.1.1795212217393;
        Fri, 20 Nov 2026 14:03:37 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-55d7889ea4csm34049871cf.26.2026.11.20.14.03.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Nov 2026 14:03:36 -0800 (PST)
Message-ID: <785f0296-6603-4972-bb60-80a75ed9b869@gmail.com>
Date: Fri, 20 Nov 2026 14:03:34 -0800
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
Subject: Re: [PATCH 6.6 0000/3308] 6.6.163-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20261120055324.975889935@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20261120055324.975889935@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/19/26 21:57, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.163 release.
> There are 3308 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 22 Nov 2026 05:44:39 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.163-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
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
