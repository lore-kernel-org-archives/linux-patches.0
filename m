Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C88D37FF7A
	for <patches@lists.linux.dev>; Mon, 14 Sep 2026 18:28:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789410518; cv=none; b=EoA20uQNgbpr+kVLL4mmKfp1uzwU02EAX6sRtFv4qwoycuwkf0rzZxbihm3fuvJ7h5Ml6rCvxtp/RppmeDzx63Wrm3OVeRkUblN+k1SF+3QV0PRjx7hnUQig8UVLZn+gnuAfw820PpNuKviTJGTu9jODbpznV9UlatJ3gzys5RI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789410518; c=relaxed/simple;
	bh=Oc3nAJjpp0QjpjXeocnToBp2SCGQxGodC291S1yGpsQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=o344OnzH4Cfa20J4ni8VKbxEeSSekfGrdLdekli7vP7hbkt5AUV4JeWFHhNpz21T4/o9IfbzwBBC/iLytb1MbnbvaB7U7oAgdBGhwSx8DMH3x/b/kYrPXWfNdWsDEkUr8aTbeKuPVkyKPm89fmtzUY2SqcImW4/4QsVTk0ySz/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=i8mdvKlx; arc=none smtp.client-ip=209.85.219.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="i8mdvKlx"
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-910316a2fc9so51623356d6.2
        for <patches@lists.linux.dev>; Mon, 14 Sep 2026 11:28:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789410515; x=1790015315; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=uXGFxPZOAw9wmXg2dzwPQVLDwdqQiEsc4hGqI92R0HE=;
        b=i8mdvKlx+LUDz8Jn54lZvVJVnI+0bwP9AHucI0rA5zhydIdafwEyN5fOEh6fzf+F4k
         gL93s38sLt9ngqeHe5TmcKX/yb64EgKHpBi0Fu78l0dyN1JAhrVjvHET2nuQRvcR5bGa
         LrwTYwfnYcryhjNgz846JJ26YS6UcU6kS1gyUwGa5T1VgOBa31KmOoFqQ2g563v90wYG
         55Bn48CllVWvo65gow9cfDiAkgKFt/rgxdDMrDUBtWBstnaZowqxmMcllomW0yP/mUQd
         e9dEGI2frpQLlwmn0gJP71mZe+N3IThfpey6JWM1v2BN8L21sKlkV2OesIMeWI27XSJg
         TCKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789410515; x=1790015315;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=uXGFxPZOAw9wmXg2dzwPQVLDwdqQiEsc4hGqI92R0HE=;
        b=rQcfgm02zVSKS+NO19qdfG+GFNJachoHZpIvQA2lewCYrkJNfk3FdDlslH7/oRzT88
         3H6oe0qu/O2fgrAd0vH60Abu7pl1oLNPcz6K0co8NSa+XTI1Qfp1fgGMHwwbrv572q1/
         ngeX6XhxJ5C0RFTwxNKWWYPaqz4X73PwxTQAKDx0+xFVJVpmLiPJChSSkYxlOF6L+CiL
         lbhXeu6AFJ7HYxXYrDYAM8y4ZlkePDen/7qxl4sr6kExv6v+MBdkOtILC5v4QMmTnyPn
         creFKjnmZNBxxMjWKhxrGGbFk2+EYZ8uZcy2WLULXqLYtdKlLnXSAek58M85KPlyTd81
         XmHw==
X-Gm-Message-State: AFuF++mj0D1CoRVq2vssfvg0oEgpXMZO+ZQD6YQuncL3Z8fXvalDNgwA
	MPnSTl89y2TgXIKnIdNwdUTRml20ZF8+KjwIk6ohHdsjcDqAgVylA2kU
X-Gm-Gg: AYBFou2o/uF82QIfTxX5n6PKM+q0JCYUNr8rh1/BnqTc3R96cmZEPhmWrYbRD/roTan
	f59UBxtuCJb78SMR46CXz+Zt2fh4ooBuWZkFzXWOvoz+0VentvyvCdar5yZwobsyrv6A/q7CMsU
	ZNiAax1a5h5c/wWU1zGqDyeg3rUB+5rnMBYTGMYmIuBF/UotyS9VSuXjP/60COsXYu/+NSRQ9ee
	fZlEPrdpsSZ/n8YwJstGVJ0z56lhJoclAy1EFEfvesOslmygVHDUUkZWraMFcSSjjNrZUuTYsX0
	m/hmH54ourtyJdzfQIWVDc+ghqP1Fr+pG1ki+PQkS48Fzl8RsF5QwSzI6utQpNKw5fTo/n0ao1k
	Jy9OZK+usNHS5GFcuX1s3Ofn9i4kLmLcb6aBiUSTpiZzK0B74x7mfGXBlxvdcEwzzInaf0nBzhJ
	w20f1vFHOgBP2lgSoGphN4xm8d51/RBmX56Z+5NY7kiqw/MbT+hQwe95uyoAXQu3vXJn5ns3C5w
	1mPxc7Hm1j3ZWeCFqCpJrn6zw==
X-Received: by 2002:a05:620a:2549:b0:939:3571:bb90 with SMTP id af79cd13be357-93a2994242emr542974585a.24.1789410514974;
        Mon, 14 Sep 2026 11:28:34 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-939e811b572sm1070310985a.47.2026.09.14.11.28.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Sep 2026 11:28:34 -0700 (PDT)
Message-ID: <3d3c3a1e-8569-4798-9cac-68c58416064b@gmail.com>
Date: Mon, 14 Sep 2026 11:28:31 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 0000/1518] 6.18.52-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260912065623.398859879@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/11/26 23:36, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.52 release.
> There are 1518 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon, 14 Sep 2026 06:54:17 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.52-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

perf fails to build on arm/arm64/mips with:

   LINK 
/local/users/fainelli/buildroot/output/arm64/build/linux-custom/tools/perf/perf
/local/stbopt_p/toolchains_303/stbgcc-12.4-2.0/bin/../lib/gcc/aarch64-unknown-linux-gnu/12.4.0/../../../../aarch64-unknown-linux-gnu/bin/ld: 
/local/users/fainelli/buildroot/output/arm64/build/linux-custom/tools/perf/perf-in.o: 
in function `perf_c2c__report':
builtin-c2c.c:(.text+0x420dc): undefined reference to `perf_env__e_machine'
collect2: error: ld returned 1 exit status

that is coming from 629978bc30938bc4929ff6c8b0dbc6fb637ac8f3 ("perf c2c: 
Use perf_env e_machine rather than arch").
-- 
Florian
