Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DEA71B043C
	for <patches@lists.linux.dev>; Sat, 11 Oct 2025 19:59:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760212789; cv=none; b=oAFHgSjJRJsoWdEomd7Bbd0IV+1IG3e8xP4HZ6Zf1GCoU3L+/4tV6qGH3x6Q5VdjDBou5al8VI7pBHH7u95qUoSQOXblo2nDq2XGelrWw7yyyWT+ypML6vRjCgWeBk7ci8mMOGvdkuxd74S6WwzUSGLpx1ar7Z7sFeb6ICzLIAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760212789; c=relaxed/simple;
	bh=2lHRYVWmcVWSysoBoWl9aOWZYULNsZ3wQbmkF5c/a1o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LABiUmzkCWeK/+j6za5FxEylQSfWwxH7LFwWCn/w2MH3FlRUYjhQKLnKplw8guGIctgZjfYr+U0oSCiHZxk1SJACpisE2pC+Z/o3njGUuMC/7yNnfn1+WSeL0UNAWWmdQF/RhDRl+Ld7OQm6ET94qlF0M2hxhRnJbDMRy6gVkhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=LNgMiTGq; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="LNgMiTGq"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-46e6a689bd0so21856025e9.1
        for <patches@lists.linux.dev>; Sat, 11 Oct 2025 12:59:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1760212786; x=1760817586; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=z2OqNKzJJPyV02v9bwdmUrRUvp/37eP/f4LyUk+OuKQ=;
        b=LNgMiTGqhGSBm6obrlXdMGWjBEwoaZZRHvBds8EfStSOQ4ASfoOpt+k1ezBIt7Y4IS
         M1xjlr8tcv24UspdGQoFZLSkkvGj5bDPdwmidiRnc9UTCPr+Op9vpFN47I1ow5VZkLep
         kvfzoDSnAlhD8lgYKskWesMVeWfnGOTYyEDM13HBgyxruP7zihC/pIbvD4vhAhSbZIUw
         kQVCDosw3/8KKUI09498PwxqcBmljDoUogwB9ZjdTaxPiOsXdN5HxALKl/NuJAcZs0tV
         pMTOg75rxKDAMk5RdBjThoZk5PAzzGOb1VY3/PiwDfnfl8H6vPtPZBhGbx4Dj3unXM7a
         RRfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760212786; x=1760817586;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=z2OqNKzJJPyV02v9bwdmUrRUvp/37eP/f4LyUk+OuKQ=;
        b=NSTEtk3dUzrmYs//v94IqSmaeFiBh8+haLZGAvooeAW/XUd5lfwwJAavXQb5uKUNTk
         W7Q1Bu14a5uwIr0Dd7bkbI0tZvFQqRhF1bWkJ8i35Bk0hEzYpzt3+GXnq0JijnDr5V7V
         FTDStzT2qWSxOM7z+bbf5AZw79049sm9c/3Sbzj1EAP4QZHbHWPrrW4EKJadBbCIwozi
         LfvEDwdVFR63LDV98qbtqX9nWCVVEcUB0KDTq99Jc8bk4u0AZW3J5Ee0BOnJZiJqcNAQ
         6CUlkt6opywGQjOwzdgxQnOBx8aEgXRCOZQslNNS6h4TJBqWoEXiWH356mQZqHS4CDPd
         5x4g==
X-Gm-Message-State: AOJu0YynA3t+jOWr/MQ7u/RoYyWHh6G5yQR0S+D7I5Bwrll4IJtM4Brb
	7MghRBky/Y0uTke+/3JhR1Ocx45MJvnmt69Zy1MYWCXarhAXwaocWRg=
X-Gm-Gg: ASbGnct4TGiaXhyeqADVq67Aw+x474KoWU+C4gOlr6RDMBZhbeNzjtES+hUKGFHOe2f
	ag2W66fkSnrOMuzEM5SxkFSQKu/OccaJBUUF9esMOenT4/2M6rfrB9Xu/F6q+kUndHHGMHRxMm8
	zRrtjWEHWxSpMIfsuwTioi3ynnuHA8cDtBRliJ1tNrPp6YS16dYOsBHtZck7XYTG4prFfnzhdxa
	8xiAamRVlXOwKNPTSY9U+jp6bdwUWnbiCRd/9awR6kZmK+PHqHrjmHKPobbXct254txYb9+5qdr
	JKzsltr/UjUVcMWqzfUngJWpRozHyrUtXRYQw+CY6pnUEmKINd8pql9pQ3FrTwnjuOuZddKPPb8
	9rbHnVktf9944j//1T8NsF9NQpm+YLsnj6hzvdCTb2gM8Eg5Ax85asZSD/6O3Ie/YMCEMWm/d7o
	EbZ6UeJpciCjc78qvXOQ==
X-Google-Smtp-Source: AGHT+IHATtuXnAGJzKPrto5w7FXLH1pjsg8T5P+0eV6cqbcItIaIBiVsfIoq+NMulMphpPCEyhbgdQ==
X-Received: by 2002:a05:600c:3e87:b0:46e:3d41:6001 with SMTP id 5b1f17b1804b1-46fa9b17df1mr119291375e9.34.1760212785726;
        Sat, 11 Oct 2025 12:59:45 -0700 (PDT)
Received: from [192.168.1.3] (p5b057b9b.dip0.t-ipconnect.de. [91.5.123.155])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-426ce5cf70fsm9843873f8f.27.2025.10.11.12.59.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 11 Oct 2025 12:59:45 -0700 (PDT)
Message-ID: <486e2f64-d522-4b63-a029-d72138207e93@googlemail.com>
Date: Sat, 11 Oct 2025 21:59:43 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.12 00/35] 6.12.52-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, achill@achill.org
References: <20251010131331.785281312@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20251010131331.785281312@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 10.10.2025 um 15:16 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.12.52 release.
> There are 35 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Builds, boots and works on my 2-socket Ivy Bridge Xeon E5-2697 v2 server. No dmesg oddities or regressions found.

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
