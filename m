Received: from mail-yb1-f171.google.com (mail-yb1-f171.google.com [209.85.219.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0330F38DC7
	for <patches@lists.linux.dev>; Thu, 15 Aug 2024 20:55:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723755319; cv=none; b=fuuH6Y7DOS6y0Tj9Vt/yH1BbzcdgSpzpHWAq17i3BFBDDlLfhc1lpgU4XHpJewdCB9nlqHCV4cIfunAdxUB5bGOho7UujQB6DUVQAZvSHLK/Yiv5u03PkpveuDFMEFDY0eekcZu9r3pbK7XJw/G4YDuVZxw5/JbqQYvco5XCJb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723755319; c=relaxed/simple;
	bh=0moN1tPFvqCGBgZIbg82318xYYl0/TVwueRuoMVIwvA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZUWGbF7hkwmDTr/Bzq+3R58CYf+TpBIbxmmrCz9Y68V1XgmP1GAzanmn+SUyeg4CCm4w4O2nKsiKDXLh1J+IOG1hw7fjKDuu7xACn6DLMyZgC0IXRyDpYFpyhUEHvCadz/0uxCSpt80cNJgQHT7bhfOzalykX3AD3PZX8dP4XNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XT+1crDC; arc=none smtp.client-ip=209.85.219.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XT+1crDC"
Received: by mail-yb1-f171.google.com with SMTP id 3f1490d57ef6-e0bf9b821e8so1410663276.3
        for <patches@lists.linux.dev>; Thu, 15 Aug 2024 13:55:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723755317; x=1724360117; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8TdgbOJ3tNh3Wtc7PoiW9Xdlmt6LlXWIUz7LAP11/qk=;
        b=XT+1crDCXqaEvCOI8sWTj5E05LlKuTqUlOuN724eslGhZoBUKtyShtq+e6+yINK8ff
         cQYu9DCk207uApGPSob7huGCgYHOtbsZEr01uYB9UabHWYuS/GqA3rFDy0YIK6yBy2+3
         OL9QNR8a1Z1kzxra+ijDgG43R2CTZoirc7tI7JnPgYNOI9kx8ChReMiCbOnKmQJOS/Sj
         f5rUzhySgN02Xc5ZfUpzHdEcyrrIxNnDoIbqewoVdSB1bi15IHP5zrMV3VNkm/F/dcNk
         ej6DgIEOsoHBAiRdVfE++5/mKITtxG64CAFukT0U0z7nzpaft/V6QrSWkP+vsxfln724
         3doQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723755317; x=1724360117;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8TdgbOJ3tNh3Wtc7PoiW9Xdlmt6LlXWIUz7LAP11/qk=;
        b=Bjds+Ml5WFVRCmesvKNWNxMvSTGH1TkXayOQ1rCgsZ7+tjVpdkAmLdn4A5lTUq1Qry
         nl6fGdPVk+EJUI8r4HmPAuAZ10T+AmrW4xFvh5mFRHQ891krG4xPx84B/YhwsIfpyAGH
         7mKG+/Gs3sylRCsVk+Vw0xuRo1Ndb8yLh1J5FKFsnEbh4uVSnm2Iey2SqXBpxCXgTYb/
         OthTSOdmEIMjjDDENQcsY0k+1Fwe6/0USzEuRE5PtwIRg/Oc7N9o500lwlVVlptkysFc
         z7iWimlYQB4v4gSDwMRs5lBlVVp0tA2Y7Pm9sVSeQFhLhW+7r2NACxP+ncY9DgR8D2Xe
         UC0A==
X-Gm-Message-State: AOJu0YyAMZDUmKoCr7WCZAUUIjqED+HXI72B8jcWNDx5m3D0hf3HYJ1O
	ngwUrMgVC+K7/2bL9zuzpwDdZAn6xndVOpsSEjsMKz8pXPuDtIVI
X-Google-Smtp-Source: AGHT+IHd4jF0LOmA2CXbpWINyM7i5PyACnA0Q6zj223/lMx9inDRqQo4i7JArkLMHxoDVuB4mtnTRg==
X-Received: by 2002:a05:6902:1547:b0:e0b:c822:49b3 with SMTP id 3f1490d57ef6-e1180eee6dbmr1147733276.26.1723755316924;
        Thu, 15 Aug 2024 13:55:16 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id d75a77b69052e-45369ff5460sm9368681cf.35.2024.08.15.13.55.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Aug 2024 13:55:16 -0700 (PDT)
Message-ID: <9cf8045e-7930-4e51-aed9-a02c8e009aad@gmail.com>
Date: Thu, 15 Aug 2024 13:55:12 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 000/484] 5.15.165-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240815131941.255804951@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/15/24 06:17, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.165 release.
> There are 484 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 17 Aug 2024 13:18:17 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.165-rc1.gz
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

