Received: from mail-dy1-f180.google.com (mail-dy1-f180.google.com [74.125.82.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC4672C0F6D
	for <patches@lists.linux.dev>; Tue, 17 Feb 2026 22:51:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771368697; cv=none; b=N1KszEbuT3DVjV/nc4dwp6AQUkf/bxvvGRfJyQ0INWXxNO0uN37vj0MSMbQXmGsobVoREnVfG0Fr6m27gSaZ4prQEIMkbMmze2MwiswLi7+phjMIqqsmDbhWGzbf/UPer6kpx16G41Zr26LQR7ia+7Rdr/zFRvgZ5Xxbk68nSkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771368697; c=relaxed/simple;
	bh=U0nA+fK6yD5Rb7CeWzI44hA5+w3rV5gPvycC2EorD+8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=s/o1h0JbsXuvCGdAoClZu5lZ9d+c+6gVUdFuorciFLrkbRYnFLuIPZb8uzYUBfYdjR9ewQpmXo1/LwJfZZcnZbq94RTuE/DJ9tHeS3RYF+UD3b6b0SKOVUcQHAigB3ulTrhfCzY3fy5o+A1oGVDoPFwr4+FzIgKwiWUbbLTAItk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jdGXuy2G; arc=none smtp.client-ip=74.125.82.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jdGXuy2G"
Received: by mail-dy1-f180.google.com with SMTP id 5a478bee46e88-2ba6aa57d5fso4912913eec.1
        for <patches@lists.linux.dev>; Tue, 17 Feb 2026 14:51:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771368696; x=1771973496; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kR2zuUHrSIpExMYdfQJhQHRA53KANikLoyFuVoTFqJo=;
        b=jdGXuy2GYCrb8jP5CKb27dPYn3YfXRnnR+XvWo4eJUQ0ZsMqE+zUo4IEpU+ymwB35n
         cVa4vfOjXJQayCbf2jJC1sFOrX8UH3NSrnQCa6jFP5xmUT+pt0llKZegoVCDNHT6rTGq
         KMMdESTWDYpLfO1MJeINJj6hdl7geTQN9/i2xwJ7oYlKZKAW8WSGWTGuPaNsXB5qUiiW
         cZ7diHCAAhZUXGdDURefdTMRhO/utHtKiDOQFzVOrb4vuYAB01vGX7SuP7CqywBpx5ts
         gJcPhlGF3H6p2deQTppJdnlc2Qa8t7smq+QW5ftRQ8cpu6HVbqOoORcUjXMixPau+MN7
         epNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771368696; x=1771973496;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kR2zuUHrSIpExMYdfQJhQHRA53KANikLoyFuVoTFqJo=;
        b=ZViZCQNx9ia3xxRVQ6XW8mn1fQfquivl2fL8G4l/wI/GFf8CIJhWmXrpXfPOXFkkdx
         J//V3XCjA6Y0lxxsHLHkDVLT/fM9L+AJi1VFAgpXQ0ndK7Wcm6aXUvMlqzpBlGkj2jUZ
         mvp268UhAsd6Y1AsRh93KR2my7syEkJPzyyI9e3HLnUuZcMsxpaOAuF8L2ED6B8/rlnn
         SWxfNa0OyuPkPDjSi9O5v4My6V30hfADGac14ZDl4M6O4Ma7744EYxi1XdhiMJkHLnxn
         bA9d3TrW5iPnv0OrMeO51+7Ff9aUvfdXxMb2ekxYpDxl9wvQVRZWReZkRYB6zmbzS7K1
         mKpg==
X-Gm-Message-State: AOJu0YwJ2Hm06+XWuR56IHUtSxBXOYrSrZmOnr/KxG0E8R5UfL84IVlR
	7pFsxDWExGHdkYf9evyEwkWSMp5yBE8l0d+D/IRnkyG+bU6JXAFwa+/A
X-Gm-Gg: AZuq6aLVUA12kHXJNoEdwo0MsI3lAOno1AfOHJHf6U+q7hFv35lb7zAgqLZV0IEd1wJ
	/WFA2hgHCgLQWolclmoVx0w2PWLlplbibCv+hc162pICtxy15GaxBbYGahjpRpluVhHOYOZZoKH
	F6nEK+nT7KO+ZMBtd4FNqoBhUDHxY9uqC6/nMkqesaCxeVvGNCuCSd5/1GVnM3TFMlHfF3iLXv7
	upMLEDcPibvGz19ogtHwh2y2uSzhIrn7EmdPntlO+DrCECxLZ45/HhFlDVUDQZDxuuhk0YtGbk7
	GTx0/1o3VlvKmZN3w3aReghDdiNt3Sp1qwP9EQzmUJDFrrEbbDRzRytv2/CWLUlcJ8fhosQSGIp
	QDcHIrpTch7VCo2ObVWLMw55npwu+EdrkElLopu3fnf5cmsC6yNQNj+P2URxpE8d9zs7MUF+7z4
	3zOTDOYzk88xzDdiXHskyIKweRFZuOSOhe8217Ks9M++zfuTCtfA==
X-Received: by 2002:a05:7300:d517:b0:2b8:64ad:ad4c with SMTP id 5a478bee46e88-2bac97cab51mr4764746eec.31.1771368695946;
        Tue, 17 Feb 2026 14:51:35 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2bacb543d80sm18328440eec.1.2026.02.17.14.51.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Feb 2026 14:51:35 -0800 (PST)
Message-ID: <31869170-3919-499b-bf86-8a5ff4d0ec4d@gmail.com>
Date: Tue, 17 Feb 2026 14:51:33 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 00/42] 6.12.74-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260217200005.998240758@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260217200005.998240758@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/17/26 12:31, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.74 release.
> There are 42 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 19 Feb 2026 19:59:50 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.74-rc1.gz
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
