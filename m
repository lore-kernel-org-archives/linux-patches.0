Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABB1E38BF67
	for <patches@lists.linux.dev>; Thu, 20 Aug 2026 18:01:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787248900; cv=none; b=moPxX0nDj5d0cvWIclRmVLa7WTDpzrMU/6oocEWY/qtvf8LbydwM60kAJ0DHWHD/Ml+E2aOX4GEBS8+SxRpI/EbOkF+mv1I+cQRFhWeyf1c/1o5rxbwZ8Opk+qIwGwVRF5Yejes1cI1pgjb52ggvIxWFcB0P7qa40r9MKa2xTUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787248900; c=relaxed/simple;
	bh=KxTpZF2RsrhJWGZKvLp6hljlhcEuDals4RgmZO58QVY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oPDz6U3FWD734lSm5d7QxrjZHTOd2lHKqYyK90nhQYEJvM+iyH7CwQ2tebk8VGtuyCbhTtt1qVwp/N2uO4L4L2xY1Aj211Ke18JId2o174igYS3dm/WHb/IeMjcM2pwLQUSBgwWYcIQncrRQ9WP9KP6Ov3RtPq6IPNXjWKYh/NA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=c2eo7uau; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="c2eo7uau"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2cacf197759so2285215ad.2
        for <patches@lists.linux.dev>; Thu, 20 Aug 2026 11:01:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787248899; x=1787853699; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hlqcwbHmyeOGRtWViVrwh5tgOZkhPcaz2pk+ge5vkPk=;
        b=c2eo7uauZAaIn/RcwH7Cf5QmLsAbyz/asqBFvnFv6KQNYNCXaR9HfQSrZUca4nMwIZ
         XJktmKdkdiGLs1p3ZnrCvNuyDKeV8eO2M4EZ3++1smHpLvdkzKNSQsmdCzmr+40iDIfP
         wvHDeUR6hNh3nbgdSOU17RhOiZT8f/hGEeUh6sEzMrrg4XtvTOdbOMSJOLHRuxgPZ1XL
         LVmnkyO3xjrd2qc1CxHeFIZqVxRvdQSKS9DxafKkWllFEIlHgYcLPx59XuZEeB2/o0Uw
         QK07/fF1yPgQVe0jR2Rm19rFyVWV7K9eXGUFJ1VXYo+scKC8GhePTbH1Ts8QcegQHdsB
         AN1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787248899; x=1787853699;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hlqcwbHmyeOGRtWViVrwh5tgOZkhPcaz2pk+ge5vkPk=;
        b=RGAY4fdLNps+Vcy1zVXN6qKViIF8ZJUeClMUHkliQeJ6ztPU8Z3a9wUUiiQOUVKjMg
         qZzdjv2okd/9d6QxJpPpOGY2lyavKz8l294gAUwbQvgRgTPs0/RO+hk46A/xUaO3sKbz
         lMfzdusyWotUl2lXf373sGvjdm9stFNNd7q5G2DXvStaO/ugtTQxHzVDzNSWAIdJcbwr
         Ksx9pSjRPfr76ejZ7h9C2cHsHrGzXqRmdXhGmhk998raleDGbxcfm9+FNB6H7Xfi/IdZ
         WrPCld4p/i3XiR9L38mqEEVEwHlQcyE4CIX9QIxNmsrZLtb5yXBgGVvKnehuOLbqtP0U
         tlMQ==
X-Gm-Message-State: AFuF++ne4llexUkzY2kVfYtxrkeG/F28hBK28Nl4JkHbnT/CISEibcv4
	NmVCkXlBWvA+tHCwW24NENLtNSonWwBdDRfLcp1AppkcEJ1vv57uJccf/P5E8Q==
X-Gm-Gg: AR+sD10bl+lEAR5kBnju/l5BWutBGgyo+BtWc/aSK38jFHV74rmR5OsmpVJbDBqIEgj
	WVMW4+WPb3Phbn3JCdmLnre+XUMfU05qgnR/R3Tz/sua/sb2enrghNrf6ZaQkfhFWpBBqeQRzhE
	N1EaLVOA97/jX4gExCzv3fg5nAbwV2svPFruBkgjXSst7V5yf4SIp7/lC/fnesbCpuujtmTCINQ
	A+db/w1ZauZIURMMuIFXt2Ey1kHV75G7iUp8VhS6oqNBgc59YN42nztQB9DSh1P5HkjJPhyqLdq
	TDHs9VG4Vwr/fPKUDXrO0C4FRb+yrcdtFzV5Jc7Ib2fCfZtyJdKFCIt3VAFEuvBX5F3Lkfah83s
	B5K+U42tod3UoIvxgMDRh8O4zaCR8bleJpSYyI5pwnBRpcU0miI+CCFGUGxeic7PcP9VR+H00y6
	U5UtlJ82ciE67fmjvomVoNEk++LST2FrMYuniRJRz4l0Eb7R3suB5pY5mWNLGAKyEQqY1uhflaf
	uKhsRuL9KXoCMQ=
X-Received: by 2002:a17:90b:3c84:b0:390:b41a:b92b with SMTP id 98e67ed59e1d1-395c3542369mr616048a91.4.1787248898010;
        Thu, 20 Aug 2026 11:01:38 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-395a9e16aa1sm1217463a91.1.2026.08.20.11.01.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Aug 2026 11:01:37 -0700 (PDT)
Message-ID: <52b90ab8-2503-4cf1-a6aa-767b3c2981d3@gmail.com>
Date: Thu, 20 Aug 2026 11:01:35 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 000/272] 5.15.217-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260820145231.229664293@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260820145231.229664293@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/20/26 07:53, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.217 release.
> There are 272 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 22 Aug 2026 14:51:11 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.217-rc1.gz
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
