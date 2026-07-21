Received: from mail-yw1-f172.google.com (mail-yw1-f172.google.com [209.85.128.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7315439B4A2
	for <patches@lists.linux.dev>; Tue, 21 Jul 2026 17:39:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655575; cv=none; b=CGibxTn0LnedZWEpWbDSCbFuW+FJEWmIlixv94iLDP+cAfasWfxaapC11wMxd+Zfv0EyMneCl8L09SbGmj1L3FlX1CmQJE78swU/An7kg6RvJJ8LJ9gCIY8Nv8s/3J480oitCP8JWWfcdS/zYpKueyJgnfVkrJgX86vPP3xunZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655575; c=relaxed/simple;
	bh=567FUSF9RxKPwJn3OMgp3UXkfaatoI2Ifw9prZyPpg4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CpIZClmrWxU8OGqLQcsN2DHiWNxDSTZ6ofBXX4Vrg+Neg/Deo6HVPAVn1Tzh7sIFBab2/8wi4WlSCtK+kPn2fWXBYqN/eOPgxtmq324GHp02MSOEAdqZSwgd/xmWuLDKCxGb5hCWBu0pGkaxueIgngzEuueVLCeE803NFIJ+riw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=soTc/OTR; arc=none smtp.client-ip=209.85.128.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="soTc/OTR"
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-81ec29f1d07so97468037b3.1
        for <patches@lists.linux.dev>; Tue, 21 Jul 2026 10:39:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784655573; x=1785260373; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kgI0wIx/qxQMjezAbCjjgaXBjZwYeNpqJNQzjszKLEM=;
        b=soTc/OTRXG/T/eoc6oMWaDA97ywqQXVJMDKGpg0ke9T+d1apuLhunWZ4Xalrg1C98b
         DCqQDhKtzB68mfrfnz1jMZnUpGBR4Y/nmdTGGhi//jEnT1yzAd0f3HgpVTtmskkkgZLW
         kVJfNk5g25X4m35k5Di2WFAEHEwoVB594XAE0jQ27u538vDS5seorqy6gnj/cYECSRL2
         c1ylLL5j9o5iTjchftq0fWGTiPfUiaqvCLRHkcPSleChV891PzDLb31uVO1Z0pGi0wtx
         JAWK1vvnP+jRvsyqSH1nRPK4E885tq+RVilWINlAR/vliZICL7eVdPUt9VNBhGqGmR7G
         Z5rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784655573; x=1785260373;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=kgI0wIx/qxQMjezAbCjjgaXBjZwYeNpqJNQzjszKLEM=;
        b=ao25ZhsnoCYIpA1igJcdDnHVr8u5yog7kPyTLLs9bmIdgJD+Q3uOPCBjoTgDr4d1fR
         u9fV0AI6rP2D/lXJw1ccVyG1AT9cU49IsCLBkWd3qXllo23qybNS3zgDAvfLcKzsBJxh
         clJ/wA+kF2iK4OxB+OS2e3ldXD/QuGWWi0AFF1BYBwszXoaaw7K5dasZtEMRT5gXsbMb
         zy77agyWvaHPab6ZJ1fVkWdfbMJQz+EMQeKycbh5mBUtk4SyfK+IlSU6lShTjBgcelTW
         btYGP+4fYcfB6yt/ztk46FYiMC+rBwNn0g3hxMWx5mBzdHzcyC0Mdrcn+2CE4qlv3kcf
         ES+w==
X-Gm-Message-State: AOJu0Yzxf+omOupU15mZGQ1vjBQZqD00ZYMm4V6mxdcRKG3ylWksTnqS
	QnpJ4lSgxqDp+iD98pU8BUi/BNhdtsxTmDaMCrHPEBWlupWQEQe+yiQ8
X-Gm-Gg: AR+sD13SBElSpoN5O06byndcswSAjZctX9mBFETpTpPEgHuM+zDZ8ET/o27vb3e8QQr
	YGKZLMp5X3GZ3gCOaGDp5wej3WS/uWCFy7JJZHSnIy9D64z4xgXHSpU2FKXubNp2jfnir+xGflI
	TWF9dhOPYG/uAkzolq1U9xHGmjPf+iDW6Vl0giuH3Uvzr3O18XPzIJ2jx+7aHSgV9Xr31mIs5pp
	XCjvVsxIZrYKYGLxVfW1LNLNH//go2sRXwo6R4tFHs+8DuOc02HozigbBfmx4jDuAnDiBTcl7ar
	NFJMjeY+Q2uAUfZHXesxA6BsfgZHzcvKtiwWYZ4MFNXoG1aXB6mdwhO1jlsm5p6Dbg48kSRijia
	HlvgftOdxt3RAKiORd/RUAwEEnlG7AJ6vggrsAXb/81uD7/maeYK12R4eYFR671zsVphmAm/JVz
	SxcRuttINLIfEzToAJ+unl+CogCXVk
X-Received: by 2002:a05:690c:c1c:b0:81e:6bd6:39a5 with SMTP id 00721157ae682-81ef25a4655mr59727667b3.1.1784655573234;
        Tue, 21 Jul 2026 10:39:33 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-81f33ef0a40sm1429877b3.39.2026.07.21.10.39.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Jul 2026 10:39:32 -0700 (PDT)
Message-ID: <94ebc599-4310-46f1-8167-b356dfa2e555@gmail.com>
Date: Tue, 21 Jul 2026 10:39:29 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 0000/1276] 6.12.97-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260721152446.065700225@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/21/26 08:07, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.97 release.
> There are 1276 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 23 Jul 2026 15:23:00 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.97-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

perf fails to build with the following build error:

In file included from tests/vmlinux-kallsyms.c:8:
util/dso.h:664:6: warning: no previous prototype for 'dso__put' 
[-Wmissing-prototypes]
  void dso__put(struct dso *dso) LOCKS_EXCLUDED(_dso__data_open_lock);
       ^~~~~~~~
util/dso.h: In function 'dso__put':
util/dso.h:664:32: error: expected declaration specifiers before 
'LOCKS_EXCLUDED'
  void dso__put(struct dso *dso) LOCKS_EXCLUDED(_dso__data_open_lock);
                                 ^~~~~~~~~~~~~~

this is caused by commit 3e2cea6464884252284765fb48b00e56449ed63d ("perf 
dso: Use lock annotations to fix asan deadlock") we also need to 
backport c5ebf3a26601c833a3ea8c6035d4318445a7e3a5 ("perf mutex: Add 
annotations for LOCKS_EXCLUDED and LOCKS_RETURNED") here.
-- 
Florian
