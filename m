Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A8F3140E3C
	for <patches@lists.linux.dev>; Fri,  7 Mar 2025 03:04:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741316649; cv=none; b=Hjtmeb/glNHx45WxQ0PifxltFr2TGB1Vj2moAXvdOKQ4dyCfShLe8KcQ6kqs4aHuvvNA636qw3daftlvzacQIf8yuRqWXK4hsS4tJr9B7bzmPZK75Ull3RnwXE42tSvHG42qlNSI5kKH6C00mOQEdU1Sv60bcXuWR4Dpp55t/iI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741316649; c=relaxed/simple;
	bh=RrGIqDKJpweFekER5cwId0zxUbU+xJB2sSI2/oZpsic=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=apN/UEDpJc7SmBt7yNWy2GcijoqcXFGrYxmJenbkG4flQc2aSwPturL6vahZTKru5F7y2ayY+FdawVB6w8AERicxyekYtA0FJe8TZWN6bInAeR9qP2a3jo/6tLMDVIKQULeS2nk+idLO1NzNsI+pvS00Jq0Pft72T/iJExCVEUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=gd5UawfV; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="gd5UawfV"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-43bcf9612f4so11304035e9.3
        for <patches@lists.linux.dev>; Thu, 06 Mar 2025 19:04:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1741316645; x=1741921445; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=c2YeDBLZhycUkLIElBwE/LDiA0l9Sd6Qk1PyFyKMMLc=;
        b=gd5UawfV/WPDUXUZai4GHLwROL7TQGPy5ETWrc/rx89x5DXimA38kapGzwcNTTm9UB
         vQ2lklgIrjgUrm9+GvDGROUI5Nr5v7jDVhDdLBPMwucHWifx3G1yXUquxq+5GE4Vu3Pv
         FuTKB1qsRNuOZ0NqtW8KNfV1HD/vI/i4rR8Vxo7w6/cKpuPQ5FsY+BGeTanGyZ09ca8G
         WRJ8XC95LifWtBOLKKUuvDJWeNw9naM50zlK0nRIBVn0qJTi2ApRVn0NJOeX6IUELV/+
         UgJQZOCQEYnQtKyZ6qhtLCxYTNUrrFmQ59DFEvC7OB0iVSv8lqH+QChO+Ah2v9oWnMRD
         qz7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741316645; x=1741921445;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=c2YeDBLZhycUkLIElBwE/LDiA0l9Sd6Qk1PyFyKMMLc=;
        b=KSZhFfkqoQ+RUZCZRlCducrGsG7N47W4I3ySHNKASkOAkVkMgouPOg61t2zVt3qKUj
         nzbbA4T1IAW/cJOQwOD3tpXcQQA0nJnIvLx3MPA/rC3fwhVCrwnVIVZ7DzcdcZPeZa0w
         qIMYKNMJ0kKPQa7vgl+yP8dxiLxvI7Az+Ejyov5v4sUKhbNG63iia8NK8djLa81wqxFa
         ClKGrrq3CSjK6IoMrxdm63BZUeECBv3lVBF+4QlqiDvZy8B+gW4dQLw+yQN26Ie/lNTQ
         eD/zRWIDQACwK8rD1A4K5dBt9Z8TzLGqjPi1/WGP2N72gZpaMjL/N5P4joZBXW3z0EWW
         VDLA==
X-Gm-Message-State: AOJu0YwkDlRYd9RLINcU1NHPLpxRq4Tw46BfXanqbC/W5bz7LN/qApqk
	OmJmCVDkepREtxx/Sk7YlNWwto0RH2hXpT2IbKZf3a3K3gTOjzg=
X-Gm-Gg: ASbGncvQIpdzpzU6jw0K4fSdwOLtKHAR+pEiwodKwH4VJmSmWRJUmiyDeSIXpyFlClk
	T1HPB3U6bD+gKLM6MysnyK8qNEvVHedQ/PIaBquD6RCXDwLT/Zo3P6SgmwJN3C4fgACCKLT1b+i
	h8sPRq/4KwlJs7eN0SSUeYqTUQnUyW/2zB2B/tSgFMqZK9+uKjehlrCx0mDbZc9qQXgkZ5mJzG4
	INFzgiDJHxN1JG+OdJXImbTIpqMPSbfV+RQqXy/XXrlDkX17lTuARtN82x5n6Yb8d2fabUfXT6d
	kHJH7/t6bTNG/DS/3peTFt6x/9GNIB7K3DqNWKpC1AvF3TkQLueOJR0QLFnfcp7/KOpWzvMdOaK
	nWgynKbRCBRE+3iLuGaxP
X-Google-Smtp-Source: AGHT+IFnoTfPxZauB89u+A0kCbx1VpCBXD0PQOH83mMRjFQyAk6aF0yuRjJc++LTonJwBCpdrSasMg==
X-Received: by 2002:a05:600c:1c92:b0:43b:c284:5bc2 with SMTP id 5b1f17b1804b1-43c54a13899mr13483225e9.0.1741316645312;
        Thu, 06 Mar 2025 19:04:05 -0800 (PST)
Received: from [192.168.1.3] (p5b2b4f54.dip0.t-ipconnect.de. [91.43.79.84])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43bdd93ca93sm36616155e9.32.2025.03.06.19.04.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Mar 2025 19:04:04 -0800 (PST)
Message-ID: <902f139c-d821-4ef2-ba38-cdca7c53d521@googlemail.com>
Date: Fri, 7 Mar 2025 04:04:03 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.12 000/148] 6.12.18-rc2 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250306151415.047855127@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250306151415.047855127@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 06.03.2025 um 16:20 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.12.18 release.
> There are 148 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Just like rc1, rc2 builds, boots and works fine on my 2-socket Ivy Bridge Xeon E5-2697 v2 
server. No dmesg oddities or regressions found.

Tested-by: Peter Schneider <pschneider1968@googlemail.com>


Beste Grüße,
Peter Schneider

-- 
Climb the mountain not to plant your flag, but to embrace the challenge,
enjoy the air and behold the view. Climb it so you can see the world,
not so the world can see you.                    -- David McCullough Jr.

OpenPGP:  0xA3828BD796CCE11A8CADE8866E3A92C92C3FF244
Download: https://www.peters-netzplatz.de/download/pschneider1968_pub.asc
https://keys.mailvelope.com/pks/lookup?op=get&search=pschneider1968@googlemail.com
https://keys.mailvelope.com/pks/lookup?op=get&search=pschneider1968@gmail.com
