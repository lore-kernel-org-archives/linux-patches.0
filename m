Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B3F01F8EFF
	for <patches@lists.linux.dev>; Wed, 21 May 2025 15:07:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747840033; cv=none; b=HJTvaTn7ZJagh5hnos/oUjp4LLIXxpgMEX/P9yWUneUKCw1gm4tSfMrVJEONO6Xue3a+Zro9fZKXp9AYnmeEI5PASdSrT0EZcsU72pd1m2Wi1K2kZ3++XQZFq0G4B7n7ux4WTfGGX5KmioUNCBaZoh/Yhrku84gxmmgB67q1Wmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747840033; c=relaxed/simple;
	bh=Sjx9j827C3WnCbxCzyrv4hIEFQ7c0wVi4hBLajRNCAU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rhuQSj4Heleq16yTYFSg5XZo0llVmaCQHxvqXXzexlYkq+AjFmDhCOXgE72JWVcsAS34zwMO7ZhmjYjBYzkTkse1bjyTFg1ftwCphdqDyVGArVeddl2OfGBd3otWaxzNQ6os/RynkLPWxmX4URAdXI1G5p26UY5eWSzZQIlDjeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=X89qe938; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="X89qe938"
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-3a36748920cso4110250f8f.2
        for <patches@lists.linux.dev>; Wed, 21 May 2025 08:07:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1747840028; x=1748444828; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=J2f9J5MTYlnWEquYDQufb/Kk6K9vXfUxRcHQCizYOIA=;
        b=X89qe938ASoQC4QVXtkBv6phT1MYthYQQuH/pa+ZNwgoAttla0/c5aeyS2pU5fw0zx
         g84xtsTxVwZyCk+bQdbjqKol/AEtEMlyi6wQMaSw5WGV7cg0xuaXjZQ3UhZN+Bdgf8gy
         TJjmgqFuvhjEa1fgGj/aGhZrugY3wVesnR/413mk8xoEdvtwf6sDk87P0LU7NjaxZnU4
         XtcvS55yZ6JdgVDrFtmu3KUbdmM/xgEbFbCGqZsviuEytMY+93nu/EcGjXpRpjmQiHrZ
         Es1a3lKYvIUVClUsg9YTzUwx2Z0t/qiKGmKh2ZDr9mU/EjhKUmb6hUd+2P/MEwKmmU6P
         EqWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747840028; x=1748444828;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=J2f9J5MTYlnWEquYDQufb/Kk6K9vXfUxRcHQCizYOIA=;
        b=mzn3VGuALdDr9lVdWzLeO3buDsWTmLRS7yI1Ixh+JSZaGpsi2fw0zsQY1E+oqrPjGQ
         OIT1NRzmcOsiJgkpIscxE04C23ORkH81d5iYa1rOItqXo+VIKl0eCD4cr8UnvRAx5j0i
         C9bwIpalPI7hpHdd9bP1HvuH7yMABXw1QBKzlX0cwvI+snfR/gCTJCrgBdTQEMzl7uAH
         X8K01NIHyAhH3lLVfT9M2VNPfFBnrTA4xh9qOqx9uk8Cq4F8iVThjsxGrBCAKlVGbl3K
         VNvdQqMAUNIIw7nYN9F1so1WccjBwuoH+SoGTpfXOO7JtbrBfUkt1rGEwSEOWcNBm8A5
         H0Nw==
X-Gm-Message-State: AOJu0YyHwa5bArHTQpPLAAMB2mJqiNwDJ0NosJzdIKYNwJ6VkeMh2UAb
	mP/JZJeq4NEUIMKlFDUCjT0WNCrFEXZyp96cffq9NHPTqZO8bPPF9jA=
X-Gm-Gg: ASbGncvpHLfhgvOC8pbWVMYVEVBMYZzTxyuF8uryQ7js9xeGTrURbNW4qLnVmdBnHgy
	qAHSg4X/NSqxX5UZcHvrWuEnG2NSDnP3GkeJmzb+gsaJJolQnU0Jqd+QjnXauNuId2nLgaRJKNk
	dVfzygn+Ruwg9h9WfCHHFLeH1R91wTOwuABxt00Oer8P7IE5nnyqeG7LpN28f8zSwHo1SzF5lih
	qT3r+dAvdcLdd1F5nEzksVXHgFHl0aPQh9GWahKYusCqVK7gW29Eo10wHg08FPCs1KhClOMqGvh
	sTtkubl3sMCVe34wBvGY3J9F8sABZhT5N1r+0IXzcjNrznym6VxCZIuRg3XAryjp/mt2jOmOR1W
	E366X8PnCyBgRFdWlog/XN5vRX50=
X-Google-Smtp-Source: AGHT+IEBWhnKMwSfgeat/ks2OGtoSRGNEoFgB5yoq0NLi0i1cR4Wwg5KRIS9wU+w34NcaoONhtKa6A==
X-Received: by 2002:a05:6000:400f:b0:3a0:b4f1:8bd5 with SMTP id ffacd0b85a97d-3a35fe67aa7mr16678351f8f.18.1747840028138;
        Wed, 21 May 2025 08:07:08 -0700 (PDT)
Received: from [192.168.1.3] (p5b2ac604.dip0.t-ipconnect.de. [91.42.198.4])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a35ca5a892sm19630199f8f.24.2025.05.21.08.07.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 May 2025 08:07:07 -0700 (PDT)
Message-ID: <524b71e8-4f03-4f6c-94a1-c78f382db25a@googlemail.com>
Date: Wed, 21 May 2025 17:07:06 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.6 000/117] 6.6.92-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250520125803.981048184@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250520125803.981048184@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 20.05.2025 um 15:49 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.6.92 release.
> There are 117 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Builds, boots and works on my 2-socket Ivy Bridge Xeon E5-2697 v2 server. No dmesg 
oddities or regressions found.

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
