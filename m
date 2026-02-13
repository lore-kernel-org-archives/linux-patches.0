Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDADC274B4D
	for <patches@lists.linux.dev>; Fri, 13 Feb 2026 19:10:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771009801; cv=none; b=rlzUV6UMlDLhg4dUwfPEnd21LZ7uHAw1I7fEnKevquOIxVhs+6s0YKuTus8eCN7SjNl3qzeFSzMn0ZJWIqpCIvtSwB9mEHZj2rahqxtAsBDKvb7crTgdjaEjx5svQwVsMS62OO0xsafwns6Pbn+Xw0m9moVQ/R6nn1/UDcbjdcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771009801; c=relaxed/simple;
	bh=YDYkHQ4dFTARQ400eOIS3YTDh5ioZkbo5w4royLGmpo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lQ6wNijGRvMKzSLXU1ivDhPD/9fAZlARVcDt6E/bGswcy4IRaAOVCguCL2BDjgTCtbLXzd75Uoyr7VxEreQ9+5txjRo7w9Cf8SBmbXQTZKALx9LQDd/wkuoR+KbhggD7aMW+VDmGbUabAna1TawEEFYcAGfSWV1OaWVDCvTdJG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Td8GITxe; arc=none smtp.client-ip=209.85.219.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Td8GITxe"
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-897002b7576so15345356d6.3
        for <patches@lists.linux.dev>; Fri, 13 Feb 2026 11:10:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771009800; x=1771614600; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WzfgVNyF9P3RMxwMGa2DwPmdN3uG/tWGvq951CJ+vsU=;
        b=Td8GITxeyDXsz6ZcJHN5bHHxAdPy689hsdKGiZEa+2gnRD7Y/fFbf/LjkGYm78abRZ
         1QIt8LrJAMUJi4ndQQjqcdqctsRoIF7g5KANhGy8kWtuznp66spe0Fn99IAdMWeaIsaB
         +cUvK1e+8A6xf6hhlbkX+BVvp/pdXzQenUkWtcsNKwlnOpgB1+AT8kd/Rr+op6p+nXKt
         5YDk/3TWoOyKmLYxwPIAL6vlW7591znrd+9IIZqG2pwwEorg+BL3JD9p+EXVbtHIsamD
         n1jeEJRKcotICZZso9czXu2mtnJLdX1lODP0qbg79cKA5ZBinqiWREwL2j1GiHlzqMhX
         0DzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771009800; x=1771614600;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WzfgVNyF9P3RMxwMGa2DwPmdN3uG/tWGvq951CJ+vsU=;
        b=HBmil5SidSYOEhqfxljPosnadekCdCLJENIN1OHIShvEGTgiZoYppfnOEZEs4ECQf0
         eYELDfT17lsIHyAokcJGQ5TPsssi1DAJjaS6ni1Alf7m2nqc4fILFBNxi1Hl0TfR8e27
         IXRpyvwy2p1zwBKofjc/TSmBZaWzVdOQNk94jtCIt+LoqqrOwu/SiPf/bTFgwxsDd1E0
         0i0CToMzpICGkyCWdlu2R3u3thy7eJVNo8GFtnux+FT0glsPYbj51+TjU29fW6gjnA5s
         kcdo4eHO+mMPHohu8PLX3/d3i1Uw9RFRiNGDvHc9UjZDL4M89MvnFLf9yMxxIdg1tQCd
         nudA==
X-Gm-Message-State: AOJu0YwTyUTXYsOdbkwvpiKeogAsD/y5XF27xRi18GEA+k3XA4mxoCdY
	Ksg03EBakaN/FLknnVfwyYhA6w1z0PTjSmUF1CIsalBP51vALXX0RgYN
X-Gm-Gg: AZuq6aIOUIcDAgbXDy6XknZONIDigpod+FpNldfZQE0qtopzMbhpJMp9GXUzA573KyT
	5kt+7eIS/F/PHY1vzHf5mrPgcubopDJw0iPQXAef4nW35dPTp/MJmeIv5McyrqDMYz9CPdq+dvS
	qBQ1fzwwKI89CcMZhrA5HYKCH+lM+xKQFfgibnHmTPDkMyCHmsEsuM2taKU+bNiMS6ZFsE02Ks6
	csJIURqF3Hcp8FVSnr8nnqynzY34+A/nDw5FI6ZIpz/mHKwZ1QAFaXJN183qoqkDze6wUuT6fS7
	Aakh4OAWVuJ+gxU5XgenlTXVposT7xEZOxCOVw+Z3bVklCnliSHDwDqA7AhmSRC9gFPq988MniG
	TAcZLG0nuFPaOBKjT75tKbTmXyc2AbzbkDObb75cccE+zkhjlieBKoY3okjYVVX+6qtZnQ0ZGr+
	/0ok1PDEF+NO4jr//nAF1e7YCsocnlba7+t/3lWkQig2yruFJTyCq25szUs4Yn
X-Received: by 2002:a05:6214:300e:b0:894:230d:bf5d with SMTP id 6a1803df08f44-89736234a0fmr39251006d6.40.1771009799647;
        Fri, 13 Feb 2026 11:09:59 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8cb2b1c8510sm673358085a.26.2026.02.13.11.09.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Feb 2026 11:09:58 -0800 (PST)
Message-ID: <07cc6fd5-0f07-4a80-a1ae-f9fb484981c9@gmail.com>
Date: Fri, 13 Feb 2026 11:09:55 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 00/24] 6.12.72-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260213134704.728003077@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260213134704.728003077@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/13/26 05:48, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.72 release.
> There are 24 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 15 Feb 2026 13:46:52 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.72-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
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
