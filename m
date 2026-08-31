Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F0104AE12A
	for <patches@lists.linux.dev>; Mon, 31 Aug 2026 17:25:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788197116; cv=none; b=aYvMpMYIGmbT1KWrJaFAheL2CFzu3JldcLWBbZpEmh+iSntbcI5bddT15Wbgd1dKvH/TEoB4ysmha5Vktct1S8vdckT3glqGNsxc2ADZ+RHnTd8DDkUy1egAOU0Ky2P/+BIA6AjlaGBpXfVKeYDPePTHG/y3vNcOqypqHFzxdU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788197116; c=relaxed/simple;
	bh=AHbx0/i7Pgt9YZiuONnuRmcHvLJTE+va4kW7G4fKV+M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ya3cuTCEuI+/4Z3bdTCaNJA86lMTbsDen6UhJIYaokHn2sarXjj5AYroLygeR1yY8KXFMkTpCgthl/NNeuzqnXjSziXWw9SkzLTw4MRWApiFMDec4hIzizmzq0RQEgnrE6aBYTSJnBEVD14BoyhaoHSM6QvaHlagt0dnHIeqAfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WavqGQHv; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WavqGQHv"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2d712281f8bso42747825ad.1
        for <patches@lists.linux.dev>; Mon, 31 Aug 2026 10:25:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788197113; x=1788801913; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XK77W5HmajvK4RgjL9G18trFUO/IP7eMuuZI6UF8qGs=;
        b=WavqGQHvKv//fsPLf96rPvZpxEaLkodhrobBZGMWGovwu8mFsxSDWyQrB+Vol8Sumj
         s86ptSGhqIsHDms3kLroQjI2NlMpVTSpS3sKkNaahhlXU15fwICJ5I6WdQmfwmLLkZfN
         cUIMSw4fEU6Abgtx8WvdtnCAZ4U85eZOrSKrIt4wwC8hy23Hy3oeVAJeOWBlNxAEH//k
         lZ4dkHYXK3pcRuPxIgpz+bGbPLhxCwL3EGyPvkrzGstR1zMPddskQFxd2iy3m/liRTY8
         G2VXYUgRcumTj+FWp8KQ4jjtQkUGWKgL0eW3csPsr+c2ZT2yCAqugRCoYDDOwKFiQds0
         kq8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788197113; x=1788801913;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XK77W5HmajvK4RgjL9G18trFUO/IP7eMuuZI6UF8qGs=;
        b=d3DYvLo2oCEfnd5fqwnEzA2u4qB6YfJGvThEh6wKBGXd7HKbd9b1CgbAA4aDTZ7LRf
         gNeYoCLulglfaE5ACYfd5qad88dQFcFQHuvsEHiWCqJnpbldOTr/bqgGDrOPBmxfwgIz
         rBUar3hZzvLqf2re0EkL/PZtBSihbTMI+XDlbga8oA3fLZlK/wKRVolFIbzO4u48rPnc
         K/LUIncVXanHFlnA0uDEdVFRrzOyLVECLkYiJbV13G7JW3L7QWq0rmehQDM0WbU0iBlN
         Sw5CZNlDh/f/pKg5ULqzdjLHmXWmBLp43kaDlsGOPVF4UgDNHaqMkMmBX4CZ4fnNpaQ9
         ToTg==
X-Gm-Message-State: AFuF++meOcCOPIM/Ca3k7uyJc8liiNdmpieNidOelNOrPNxsMmd5us6h
	/7mbBsmIKts232JU7TiKiVTEFuIrT69vPzhvNAmVb00kKbRsJgkSnLvF
X-Gm-Gg: AYBFou20geOb+/FTHNu5mOK1D0T0KRaCUN/OE/wW8Oq22Lqs8lPVXl5rVFKAZV0ownw
	XZ/mQAtXrPxbr0bGlpModK4rqklAuZKMLtdAapnRFy84Rdi/paRYgpb+p36YmmWP6syc1RzcplP
	UiDcSAm+EaZs49xEe+XDb+FUOY35WVps2abx9CLnHoiCQxfwrm8WLKwGaLHfP898EzUjaDp99cD
	xDQ5m712ucdzfLwnB1OLgVesCBDqYzufvqQ/u4x32SXbdRd6tQDpfEz0I7fnNY/L1gMTdYFByvs
	QPzJHEknfe3rw56Nx5BnZr57HYq3C35DeTiisFqBtHDpx+V9or1Emw2DHllCYIECquiNj7VaN7d
	IpceA1u74l7fNIOj9lTRsfYMES6q5JK8I04/QuLb1FHfEvoyFRXv7RIRFg2S1o5wsBS9dNkpPpl
	Kp9pl2AkYI+9dge+h6L4qlGOAgy7q85lz3pkCZ4Pjnvfly0ZnN7Q7oqKAyWJwnZgylxA+bQuU5C
	iIciD85/JxqCu2JdHS3H50S3Gw9Fw==
X-Received: by 2002:a17:903:324e:b0:2c9:deec:f564 with SMTP id d9443c01a7336-2d94a8d59acmr32476955ad.13.1788197112756;
        Mon, 31 Aug 2026 10:25:12 -0700 (PDT)
Received: from [192.168.1.3] (ip68-4-215-93.oc.oc.cox.net. [68.4.215.93])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-32b28ab0571sm23256193eec.4.2026.08.31.10.25.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 31 Aug 2026 10:25:11 -0700 (PDT)
Message-ID: <5893399d-bef6-4888-acaa-3bb4ca3ffc01@gmail.com>
Date: Mon, 31 Aug 2026 10:25:19 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 00/69] 5.15.220-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260831133358.601894154@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260831133358.601894154@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 8/31/2026 6:34 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.220 release.
> There are 69 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 02 Sep 2026 13:32:19 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.220-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
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

