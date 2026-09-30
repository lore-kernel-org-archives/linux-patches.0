Received: from mail-qk2-f12.google.com (mail-qk2-f12.google.com [74.125.230.204])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89E494483A9
	for <patches@lists.linux.dev>; Wed, 30 Sep 2026 20:31:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.230.204
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790800320; cv=none; b=O2hTwGASafgMW8Wb9HAgTX7TQOBwced8JTPK0NAiZYYYrgWskvsqDJQhZWvzK1gbQF2cCE5OcF59ybU6Asz82PNJABM4yhjmSEvuVbx7QaS0go4oNk8O1BAEw2TvULgV3KVvwIRHjhYm5GSWAe+NY+Uosu2ATz4fAmm+PtuWRG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790800320; c=relaxed/simple;
	bh=EKlcz5CBEcnRCHzlR10r/eowVg5c846H0vKVV3ugVE4=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=HclTlNF7agcjMvoGJBGkwWyNc9NKM0SgsOCihEYp0u95IkX54W/ZkuW3M2g7VTFqIsVr3/HcKy5zykFoVV+9sw5xK96jan1nW0AKquUliB4CylsMlkQeWgUzQE2Cyt1j2vtQBeDZ0uvqI8uw3iS+zaRptzoUpZHAIPl4TwMtOzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=qP/O9/2h; arc=none smtp.client-ip=74.125.230.204
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qP/O9/2h"
Received: by mail-qk2-f12.google.com with SMTP id af79cd13be357-939109fafd7so458738185a.2
        for <patches@lists.linux.dev>; Wed, 30 Sep 2026 13:31:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790800317; x=1791405117; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=bzhRivw0MBLgjbe/iyV7ysat9gpf94TLhhGWQJh7iRM=;
        b=qP/O9/2h1dQ3bu04uY1jkr5SBKuxMgDLlWCyQu2fHBs3KMrroASLFGMNgSHDvW7k2u
         nZ5IXnnqmd+VLwOrNukc5rBb5lybPHWTkVu+gwEFdZK7GvAmF+dnPuqqO/L1cUC2njH4
         1yJlznBmusDmdfMeVIyCAcBqDElBCL10d2Hrrus+kBb6r8E5Asj2vgCCgcKpjP0dJbYE
         3UkaOOQ1myrtAJlOm7vsavTFbBZmzVv6riAn2i2r31/CesYwHxYj9FnRj5iuTZf5u9ii
         RYQzDye2Tni+62B1aUefAbW0VhD7wUNsVOBkTGk1549sFPMuaEKBeHtbfXkG1KqICH9F
         3yoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790800317; x=1791405117;
        h=content-transfer-encoding:content-type:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bzhRivw0MBLgjbe/iyV7ysat9gpf94TLhhGWQJh7iRM=;
        b=AWVYaQQH6l9fMK1KcHkmKMSHI+kck6MU2TI1K+cjRCift3zsBYjo1p/M3/cR5udkeo
         Rwvoiyk+UQwO0ppprF3Ptvdm6zmJlH0pqMkriScc5BL1it4kKgRMZ5DtOX1Lpc36u60B
         QdHKf6aZymP5CQR/XaRcOB/fPo2o7Vidzb3tNaArPBnT+vpA0DeM7ofxCcVkM8Exhiua
         SQUrokX3hbQNZK5mhUzV7yAsyh+Q9o86c9YaDhU+Jq0+z/0K+CL7zuVUAOUVj4/GR+jC
         hQWoiL8yYbfsL++ZBDWUOKXSSu26rIfVw+NhOkfGonLTIMbCH+5LpEcAOFGQ/dFttUlu
         mFjQ==
X-Gm-Message-State: AFuF++m8N5J/EllKefsgsDHDvJKZfeMrOkbsdMEdeDIjqPeWuv8/3e2i
	LTuyBpWnN2WZ4TgLrBs25lLVjuy8Bg60ukT7B9D0PDOW+18gCt0KuB4=
X-Gm-Gg: AYBFou3Jmb3yeBGC87XMA0ndCuuV1MiwVtm0LUnGgKiiHU3SEBku9q3GCUUqc+wuJ3C
	aKUR6WLdqVglUnHuIHRDm6I3pB4cejrbU0mL2PYyz2hwDcLddSE5joneYRoIyuUXZN7xpAMyjPV
	F6VA7oC/YtrhXNJKSp1KPm6GUCyfC/6zAACNT3Az+nqNRp2p/r71bTyG5MzdXXI0XpNVzL+a+DC
	o/SWgBV1SEWx5NAd3kNQ+jq8zQNVUsDH7IRdAGYTaCI26Rcc72uel6W/7vizvKHnWU/OmNQVo4V
	/6tFkzvheOQsv8NxrGNpDB5W/O2RVWN3sEYFBXVE5h6ZtWtSFW6URwZNSSjRrd6/56RMYLPahOP
	nBc6PMEQhn9NqeQ86RKXgErj4C8rqFFYhU/e3odcCMBeF4QUalWZ2phNbocdG1uCrSX62mg5xJI
	vadoHX2lGfm+m0k0rtMUDV/tV3kx+LDTVo8TWwpHO3+zBl0NWT8bPr8MXcozQNqdjeZ7qPyhhFF
	znFllBWb4TzJJREXoFovrZSIFc=
X-Received: by 2002:a05:620a:43a9:b0:93c:771e:b672 with SMTP id af79cd13be357-93ca9899d69mr494177385a.54.1790800317375;
        Wed, 30 Sep 2026 13:31:57 -0700 (PDT)
Received: from [120.7.1.23] (135-23-94-154.cpe.pppoe.ca. [135.23.94.154])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93cb8826b52sm16187185a.1.2026.09.30.13.31.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Sep 2026 13:31:57 -0700 (PDT)
Subject: Re: [PATCH 5.10 000/595] 5.10.271-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260930152347.700140858@linuxfoundation.org>
From: Woody Suwalski <terraluna977@gmail.com>
Message-ID: <6eaeba9d-7778-88ec-d5ad-5433bd18d507@gmail.com>
Date: Wed, 30 Sep 2026 16:31:54 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:140.0) Gecko/20100101
 Firefox/140.0 SeaMonkey/2.53.24
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.271 release.
> There are 595 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
>
Built a i386 kernel and installed on a 32-bit EeePC.
No new problems noticed.

Tested-by: Woody Suwalski <terraluna977@gmail.com>

