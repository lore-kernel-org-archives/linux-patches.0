Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.180
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793398002;
	b=DG2tqXIOVekrx16ZCEKpC0D7TqQdRKZygfPqNWmR591dyGCalVt7r+YrkdQG2iWlHu19
	 yYzMK+kAvvMzzNZZoPb/YccEsKsTLUwZOWFWpMHEHzG1Ks28PfF23V6usX/xpJliNaFN5
	 ecEDdXfV23OnTEx6bh8TfSUASV1VVoAzDNyMCE0Ot7gNOW5RcPhxl4xERbShguqbk1k2d
	 PQeSjeIA5YUXhJphtM+UX0AG0daVObI2LYniACRWLD+oJFlqquayAWtpsByW+kByit4ln
	 aznu0BovFpTPXZ8LoAj1DZ8UCFUi4kalyZQ1e3EUPsgHZfNXE2CS0kkQQYAPN/zzXDw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793398002;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=VallrhWYbAQ8j+mRUozNpVRyDn2TOg/EyzhjcGGEMLE=;
	b=mIvsSPByIPQqsuBhzPmISBMVLYK3SE/SZhOH3UtCH0/QpEJlg1VwJfuu+LKFTkdBiwEw
	 hWPQ//KRAf/7SsmNQkOFe8c5oAL9lcc7V6doGsmu8JxxFCbcTDj2LtXIR1D97eQeGmkoF
	 GVigC8+mafFDBIoEPLKq/+ypE1QAR1eYrW2Xq03mpZ7RFwKNfW2JzgC25/tyH+rfzVfBg
	 agiVsLsKCZanEXK033ttOBmduix7c68d4OozMQNo/Rmp9Zu/xLiwLRl+S65QNaUeLBYqR
	 jOsPmv8N3LPuifweiTO5URx4pgfww+df6FUdgu97AN2FT1JFdRWMvJr9dacsg66qRGg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=vQD91ogK;
	arc=none smtp.remote-ip=74.125.82.180
Received: from mail-dy1-f180.google.com (mail-dy1-f180.google.com [74.125.82.180])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9BB2606A31E
	for <patches@lists.linux.dev>; Fri, 30 Oct 2026 22:06:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D9BB2606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=vQD91ogK
Received: by mail-dy1-f180.google.com with SMTP id 5a478bee46e88-33fb4680717so310719eec.1
        for <patches@lists.linux.dev>; Fri, 30 Oct 2026 15:06:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793397996; x=1794002796; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=VallrhWYbAQ8j+mRUozNpVRyDn2TOg/EyzhjcGGEMLE=;
        b=vQD91ogKidtRNkCvTb8tJBX6/EfQ+Oa/IujW3UKyuFTe3+rQUayb+kEse8tY/iMMwk
         sYHjPfejhG2tH/QJi+f78kSrn0SEIE3uWnwAljVr1TLjsZWafH3oA7oxbhApHa2a2Fae
         NE2++hqPLeaLQ1V0c0k7j2PE0SlzW/XU3nfUvSuw4eeLCzaqUSKCRd+hTDPvoW61z801
         Ysdxd4z/yTP9+5seIUphorVDpghJbe+27OHsFK4KdhL66NgbizXQg9ARr8ia2YBaJeZb
         0UI+h1ImYII4nLRW3X5HRA/upMVSpCVvxuwPe+1tIJtBtWx2OjjyHQnuLOw1aUuAt4tQ
         rSvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793397996; x=1794002796;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=VallrhWYbAQ8j+mRUozNpVRyDn2TOg/EyzhjcGGEMLE=;
        b=i4TeuZ2GbHyEHKes9i8nANB1NU+hovfZThE0qat5FgQDCGBDOdRohuk2afWYbYQ7+j
         M9DLo1QIVcsbzSGgLBGvkesabLLUEjzOwmFr6hijkzvCLfYoEus9QO3QEkl06inMrtjt
         LBskhfMiFz7cnU0BgUtqJ7QOULBEA0uF6k1qhKWSQhcYHoAovghmZqw7j+H4bWNxxdbz
         TpaRVEwirhADWA97CJgr2oIb8ere4SzVaZQ6w/yH6E+6ALxfiEd2KL2KM5DxlWvGzXaX
         cbclfRsi6xmj6df0Z0IXu1Q3cp6mZcGN/9IT6RbEev8HQ0Isj3q/KkCljfu3rseP7Mj1
         luIw==
X-Gm-Message-State: AFq9FYLROCmNKG9OyMgKOeftQL7/bzoxmpjSNNKBmEufge3lqHl8DEpt
	4SmszrXDeZ3Kuv/fGtUg0OcTEOMyz+x31MpQcGbRhW30ITyXNejdaBU9
X-Gm-Gg: AYBFou0e7k+9xrN2HwOifG9ylLMDMgm+q0vSc4bRgDLWsN1MdKK/p5FwvRGyBpT1z3A
	O/GkScNGPjX4/68I4zmH27+J2HUi/oMOpkKMa+HX/YrKU14ivJHevVc/xhHAOwf1M6WEGnDsXim
	j8+4UIlg8BVn2X+WGvUbraIW5XjVuXoUMfN8Kz8Bh3puwSj6OGUUfFwz+S1WhrkoHfsduzNWn6E
	DahN00JtynBud9f8KfzQBk8bbcPZdv0oj5mBG3b5YMgx6rcbRDr2EEe7cBF98ODFHUc+h02jgeh
	btcvJIeDOabwv2rTfMaEs7XdAdaNe2ucoUk5n3ET16PaKZAlWCJuC2wkZU6wq+1csp6+0Uhvhgw
	SuaxwB5gOlbuB6RwjnwAdW8RXVVUAuMsXiYtc8ukqh6A1KEY+409iRSi9B+gWNPlA4YfeAVdpo8
	vH3VYgcqEwwM2Z2g/ZPXe5v9NSV+CWZNd6rOsgqNBwV6f90f49PFQgAA3rCT6ftjRq9oWdOT6h6
	Mm3C3N6BO+AG+32brY2yZyyE+W88IYnn1S9ySaOSxkJh2HQIdKquddPKbbacVf55X7XT87Eo1/w
	Z6ERgwXUkjqk5RW35sFni+uEwQEzhp4yk/DA4ecCB6iQGh4+/2DgJsdHVHQtuuKr4s1rF4G+um5
	Pqg==
X-Received: by 2002:a05:7300:8e:b0:36a:119d:a099 with SMTP id 5a478bee46e88-36a422062f9mr5616341eec.5.1793397995862;
        Fri, 30 Oct 2026 15:06:35 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36a429018casm8965957eec.14.2026.10.30.15.06.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 Oct 2026 15:06:34 -0700 (PDT)
Message-ID: <547303c0-478a-4ee4-9c9c-281e62ac4a69@gmail.com>
Date: Fri, 30 Oct 2026 15:06:32 -0700
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
Subject: Re: [PATCH 7.2 00/10] 7.2.15-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20261030121255.257615100@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20261030121255.257615100@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/30/26 05:15, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.2.15 release.
> There are 10 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 01 Nov 2026 12:12:50 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.2.15-rc1.gz
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
