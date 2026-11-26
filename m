Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795667287;
	b=v9N7wEppV+ANDqKyn0nGuMmmXIsoe3RtNDk/I+MeA3IgkznZxICg4gY3ykNSabVw+cI2
	 m+tgb7YGC2UCPnjvLl2nW7GBYgnS2MDl7P7rsDfR3TuV/EUFrZGnbiSiFluRsqsMaU1wg
	 41qPEvmtEDc81pamk/nR2GzdAOOdCEXc8HLKJWHCSZbOn8E3jsTLmHqiMemmzDKEcbbX/
	 3xI+8iJNDy2qBA3Eo9kiF494pLlV4S2GelNf45EIEMFG0zWaPm/XnvwwtWbUmO5XrGldU
	 vsgTNVrVO2Kd6wNEdL3Xqz2XUyo97ra7mFKrrtPO+Ihj2nxSMlgSF4o3MaEbgAPa7Uw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795667287;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=J0c7g32Vkst5ZTZD1D3dAok+IJ411KyHzBH0wWFTswU=;
	b=dIehDeuVRe+Mv8g0TcB426PyQWodzdd3/fBwbB1UlUppL7kSDkhnL8yjp5+hACOjw1JD
	 wSu/SQ/PogV64sZvyfx6dQS+niPuxP/Q3Sdsl/AhqBg2VENMH3h4TCKbxVmPPV6Y3/Alb
	 o0+OxwQJV5jahTEb/7w4XuogTa2T7iWh3HhLR1q4xbYnSZb4at6P8sFogXp1MJFVtWBZD
	 g6KUhcYxu+HD0GVM4VSJ5IpFcU6I5EvyyH6puRvW6CllLyfsyJbDpbsPtnO3Tff5oYRwJ
	 n7/lDt1DUI1LRFUfUCdVIpKwYYy7VX3m34KbdzZzOBv6KT+dik/kXfS5oDnjhyx7cfw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=boHS+5Fc;
	arc=none smtp.remote-ip=74.125.82.43
Received: from mail-dl1-f43.google.com (mail-dl1-f43.google.com [74.125.82.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D69D606A31C
	for <patches@lists.linux.dev>; Thu, 26 Nov 2026 04:28:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3D69D606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=boHS+5Fc
Received: by mail-dl1-f43.google.com with SMTP id a92af1059eb24-14394530ec6so9147629c88.1
        for <patches@lists.linux.dev>; Wed, 25 Nov 2026 20:28:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795667286; x=1796272086; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=J0c7g32Vkst5ZTZD1D3dAok+IJ411KyHzBH0wWFTswU=;
        b=boHS+5FcrGAx2HRHnle0/RBmS4+C5lSAO/1mXODeE/yqjbudl+nz0/c8f4Km3HcMZ0
         ky0brtttpbBxpqNqGd2KLz4IPDMIAXxP/GhhHtfWF1cwlSbL7v2C6XMlIODDNgVeIk4N
         FFuBB/y/VIJP+J7Tk8+JQnqA1c9fbUV3GpxxdqHdszry+hOW9H/HLS9ifvruIojOVqIU
         8txE1qHX+biS8lnytii6cMzVLqSO9ty4t3xEAVsQww0a3sBOY6scnZo1DSyjU2SPQ2Eg
         amBnvb1j9RO2+HAu6PkRmGcqMMh2w/U7CCwWkQUs8ErkI0S8saoGDcFoilzsRNd2j3Rp
         BHQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795667286; x=1796272086;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=J0c7g32Vkst5ZTZD1D3dAok+IJ411KyHzBH0wWFTswU=;
        b=MkMhxoxaftkhtDTsLhW7pcmBt6A49y9jfzL6ccW4+9SQHiSrMNuPH/nDATpuY2FwB3
         FyqlT68k7DxYXbJ/h/YAv3wVHbJfcvrsWc6747+/G/fvXsy8aTdZCTG7rmqe8cx7WD+i
         JtX4nT26aEZXMZzCL8N59OS7pvxvGx9DF3x/lCCuYK4nyAfo40aVcIrtjuSCPBF7Klfi
         vnTkEepb6rJNQtBhtn7ZvrtqjWVCDhRjl3HWnwLoMOQvKFaEoo8XNM2U7gLBQJQhTXE7
         8d5ULvxnjgYGgTTLWoOHUC4I9u8T5/secrdqqGAlFTplU8PEN9XQhoYWFK/GGimGWSTm
         aURw==
X-Gm-Message-State: APuU4Z/Su4OM8YONWJQjI/lUeDW0Vn1oMgtCXv/ZVUOT+AsqY/bNH9Ci
	T9UMLDtCDRMn0gLQCT/cHoi7dCaCxjVH0z6f2h07Npb6GjBTpsenS0DQ
X-Gm-Gg: AZFdTZe9WGa003Ei+OWUz6vtR/c/8rrjUCiyTjLcZyy2KbhrmS0FqAUt5U/Jha+EgVO
	YNZeWExf5/mPjbceDcZvj4k3R3+5M98ujfP+2RoFjhGEY83mzeSGoiMC+AcY67oVYkWHbRfXYAS
	tfPDWj+IOLPT1TRWWSctqMfZ4GUDhn0xRNoW1096Oct2qsRLOjw8OVCuN4ETitXTWjUQ9+YJ0+6
	4SNe/SOqSLurSHUbp/UWcb+AF1pX1tBNJT9EHtgTDvs6Ihh/pPccNbnCSwOzUxHxXOuDa/KOFJ3
	1Fw4NhDCbEj6VTKTpqfNalS19JIrDRHa12F7F+ONwz4qe5us0AqP3Z6w0Bywujnny7JHLUng7cU
	+bZ89Ygh9j6c33V1po3Jj9hCuateY3Ha7vSRkeGDImgO5FNbDsnW7NgDDifgCCLyWbm86yN+ZKM
	HVVO16cg/WZEVVuEoIlKJ7HYjN/vP61aluum5Uz3no7xMYz9MHzS85+g5lDsjEMWTxpahDaO++p
	QatIkPFaY4i1xbliyQMTI4GvEvweZ3+5D8arnErTl8cUabvEFr2sNOw2oVhWdMfe210vR5KEIak
	dUPdfK3aHPyBaxjWG5p1lNSE2echY3wHFpVyaJoxkkUrHaycp1NrajJYDFCaMY3B/jOv/r9SugQ
	ljMDukbAJXFBdIWoZL2UuZA==
X-Received: by 2002:a05:701a:cccb:10b0:179:a1d0:be39 with SMTP id a92af1059eb24-1b56b709cfbmr13685966c88.29.1795667286345;
        Wed, 25 Nov 2026 20:28:06 -0800 (PST)
Received: from [192.168.10.3] (ip70-187-214-22.oc.oc.cox.net. [70.187.214.22])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b556847fdasm51792405c88.13.2026.11.25.20.28.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Nov 2026 20:28:05 -0800 (PST)
Message-ID: <9e9f4aa1-7823-42dc-83b5-e9776096950e@gmail.com>
Date: Wed, 25 Nov 2026 20:28:06 -0800
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
Subject: Re: [PATCH 6.18 000/990] 6.18.66-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20261125143822.072087159@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 11/25/2026 6:22 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.66 release.
> There are 990 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 27 Nov 2026 14:36:57 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.66-rc1.gz
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

