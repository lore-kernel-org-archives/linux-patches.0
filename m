Received: from mail-oa1-f49.google.com (mail-oa1-f49.google.com [209.85.160.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E221A41C72
	for <patches@lists.linux.dev>; Wed, 26 Aug 2026 00:12:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787703161; cv=none; b=sIdAbPuhf2/fckebQkGZTVrbUgq93Y1uvEXGy23cqhvCvMbJrcJ1hp9ykz4WICCHe+8cS9TaNpgp+yXXYgpLxpMrAW4eMisTY2B+TbRx6TOYYu1WWlhIRTpKAwL0+gapHOlvPPp4ksa5mA9ieibh2qV8xT/Dx3IWBGI/YXjxHpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787703161; c=relaxed/simple;
	bh=AHg3ALect9MWamD34g2iatsGrEFzW54Ua2w+eP9s6ls=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PfCGukoXMw3lru90sI1J3arXLhxyMiOhXC3p/pFetI5H7pZedtUtCyyhr0du67qTgyWcw9PuZe/uUsodB2SWPiEuY1le9q0XNT5Jo+h9UHE4v68+af/vTklRUzfRBdU+iwHn/DCICgOu4QAlUPC7UCUy+UnnqM8fGkT2Wv5hd7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zs/lhRFO; arc=none smtp.client-ip=209.85.160.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zs/lhRFO"
Received: by mail-oa1-f49.google.com with SMTP id 586e51a60fabf-456395f4e7bso319367fac.0
        for <patches@lists.linux.dev>; Tue, 25 Aug 2026 17:12:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1787703157; x=1788307957; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=NwKsdY7lSw4NPr5IEq6eGfRhtrIkXovdxO3az9ib2qE=;
        b=Zs/lhRFOYKlkUmEzPfHSxJWPwlAxHz/mjZ0cuzDGJXcSN+xNP1HqEl1AFrJwLVuWj+
         qjEqrfFUJda5dI1Mkx8Xaemxktz2lSDeX5qABwsQHgOA21PiCCN+nn6thgRmCgzZM53j
         qe9zKXDZxkeyL1Z/ryl/Kf8PVxjwC8thtGiPA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787703157; x=1788307957;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NwKsdY7lSw4NPr5IEq6eGfRhtrIkXovdxO3az9ib2qE=;
        b=YlVcECjOV+IwXUaojmX27DVWtq5TDeTmm+g1gg6GmxQFBngT4uJEEOmnidKfmBq2NA
         bZKCNZF0gP8xdsp8+K1Dwv/2U3752DKI3SIDBOc5ibAa9VAt/PYqzk9TJEZ1K+6nhsl4
         1dDh2H/BJIn9GPsWZgHFmMvcPEvWb/ujWnPTvrOOHCP5GU3kI/oBqgCAyrvQZij7KT+Z
         z/v591JFQHh0THeQ3tKd15lcb0sqCKWfkVvu0PX2rLZs7N7SAbvH6mjmKK4+SDvla4ob
         sEl0gl+DvDJ+aF8Cn8w5VimPgLk9eMcHJ/BRUReH5O/M9/4qAFouP79UYatEUqAo591J
         iQdg==
X-Gm-Message-State: AFuF++nPQZ1Q/PSWDRqHa8HQlzddVSsLXODpJyNO3H44QyrNo+hLprx1
	rkFwXC8ymOD7j6iDKYnPpcqn2hn6YAG0vChRUoE+sUeFNVisuzlfxBqF0rcd3Q/fh34=
X-Gm-Gg: AR+sD10xtSajWZMI6RdnU0uxnrY/7Y35bZbM/lfm8dJyYvmzjKGdkdNbmOk0CYzl+oK
	W4Eh2bBSW2wgckDvu7Esl1isB/s1ehaSDYK1qWBXAGjhSmmAQpmjfctmWWsEcPY6CKM1BMBijdq
	mXRsdYs2Qm3Dv8K+RTJeGcSTUY+Yzm/XX9U2BSOL6TQ+2GJ9s/4SU4Mrdq2kF5nE6mulhJ46Kq7
	Ee/OmpIlKfeT9jpatHui9f0R99mk1051S8x4CoA2uBz4RVEWJO13g32NBA0eY5+WsbVoU7BpG+B
	+4jv5+lrhUS5caevjEuGmdcu3ZhFdBU+M4X2lKANn7XoeTQOItS0j2zgQQqDTjxpQaZubT/ymtW
	ql/i2J6Y4f9U0Ujuwu2OOcN0MIsA7meVCDbcuUymuDiuef2m29TFu/1FrPA31Eg2HKnUtfH50DX
	kZpUt2bE1ibVbFk1E0ncP/LrB/HQNwgV4ZEy+36qIQQOx3dmTMZu38Dy32QE3ZFcCvfGRDs8CMN
	tMWi7o=
X-Received: by 2002:a05:6820:2016:b0:6ac:9729:6710 with SMTP id 006d021491bc7-6b1a049e03bmr3104301eaf.18.1787703156730;
        Tue, 25 Aug 2026 17:12:36 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.57.99])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-6b1a268023asm346821eaf.13.2026.08.25.17.12.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Aug 2026 17:12:36 -0700 (PDT)
Message-ID: <bde7c5ce-16f1-4c9f-9e10-894a754db7b2@linuxfoundation.org>
Date: Tue, 25 Aug 2026 18:12:33 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 00/87] 6.6.154-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20260825132541.813800447@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20260825132541.813800447@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/25/26 07:25, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.154 release.
> There are 87 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 27 Aug 2026 13:25:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.154-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
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
