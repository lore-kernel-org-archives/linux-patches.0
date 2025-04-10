Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31A161E9B0B
	for <patches@lists.linux.dev>; Thu, 10 Apr 2025 02:46:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744253212; cv=none; b=NQZQ4iw4Dm29cbThHHLJrvlwTqwWzKypH3kPNcll+YKy9y4femjoPgM5SfZXx1q666Cer9gQaLu61Rvxt5ZqvT5+OMEFqi6mikaopjxIN9R+Dl1nnZ2QMdQuu7mkbMQ6KDK3nVjygw+9l5JogjIYZM3vVii/nBuAyF9UP3ClIIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744253212; c=relaxed/simple;
	bh=QOZQEHQyBXXxcPrT6oX3nR5O2Rhae5MEEUplAr+tytI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Pb+k8T82P0Sr+IskxZjsTmeY5zKfBJ/L2ZVA8HEs/UDJsZHMwrMoesjajkRdN5TwVt5Qbaarz4wBe/83FuIXVT91j0pbq39+4FFpmVbxDZpf1++wsKvUrr3d8SMKga3oHHUwGAILQOlI9TSRRqltGu4bPayiPDPeUQaLK9IRcd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=VtkVKAw6; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="VtkVKAw6"
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-39727fe912cso77688f8f.3
        for <patches@lists.linux.dev>; Wed, 09 Apr 2025 19:46:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1744253209; x=1744858009; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4Ph0sMnCNGa5VTSi5U0q7oZGDLT8fbaCzu7xWDmfDqw=;
        b=VtkVKAw66Bz+SThq2rit+60TAV5uVTHto7gQmOxQblNMk6gPi413ZZmt7c6+awhAEK
         lBtgItBX+1xcZyvqFyV6UQziVUC6NMmOUp/Mr9BXc3R2omgKIlRaHaFOR1ukDts2Aq2U
         1CkotTI5UyBABJ46tEkykgg8zIbWjKpOYuPwX6anbXzfAnxpSj4f+P2CpX1wUlzRyWru
         1Jgh9JkwIcysCG+oZLvkahllgqEOx51f7QlAiNYojQiY0Q53Pw+Ft8T1if2tePB7NNt4
         WOpLyWD4NMTtHCZDYxle2pQOdDw0zjGMFFXnCIFVehBHleQl9+MV85StkeO53EGv+ez7
         TzOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744253209; x=1744858009;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4Ph0sMnCNGa5VTSi5U0q7oZGDLT8fbaCzu7xWDmfDqw=;
        b=BFs6mHJ4EyPL53gbDnoumXWunp4Io/L+i+JVorTyv/nwS9Rtdh95dy0gszLfG0ZEF3
         w9rZnBWFF1S4tXsQ++8zpiTaOW4ib7SlmDO706m6RW3ZkrniEYcylxZnMM0kDE9xb+2P
         UOu5Y4VSbeQVNelStk2hfQeAJfzOb99C9ZJaY1tp+kuyQH3nrUOj1X/kGx6jy37V6EWr
         jFxFvS+oCLugxrNFXLMLtjoWcWMZ85Ei0I1+qYFWvdJPiONBslqSlsiVgkvaj2ycNPrC
         jgu6PAe/TU1tvV1ES7CXtRGO90MPGpetUK0NDcjoReUjnwSOztWG64BOAN7StF3JC7mp
         q/Bg==
X-Gm-Message-State: AOJu0YwHxtXlEhQun3mOd8oQt/NFbITEjRJvMZ27/JeD53as4evh9VrT
	hS1m6S0FeDCXEiWLyP3P/UVlGUJomIpxEhqnn9I0lb8yZwbHEcc=
X-Gm-Gg: ASbGnct63KclgmFTz1QS29A6jpijNuuii9T2QVARpx9Bt1SwjJge3OkbS8WT3JhqqWw
	osig//Iji/RhMDIQ3lSyc4Shpy/tz6VOEP3UnsBgasYLPdng7sSNinWbMXuGTezcOcn2IUEu2iy
	VjVyDTMnta1UbNoZNTcZJG8HHzhwm9KztsI6PenNn39DpCN/evjZ5LLo1OTPWJG99ZeNFcKq/x6
	ByGQZ2qpda4vFX7Pns/oiKj/N2cJeSecOTkdfR57xgqs1uugoGflNMJKb5k+Hrz3DZaWBrVqKCB
	XsPwDTjHVPYvECixwm2scrRldke9TTE1APbwBRkd/NJrPSWx0mtEvheJnxHqrX2D2tRqi5AxMkJ
	27UCpNa2oZksmD57F
X-Google-Smtp-Source: AGHT+IHOE7jiEy7hV+dNeZEvjMEJVqKsUfhz2BDR1aM/BcXoA5fDODP+FoIOTe8FppaftAyDPrucgA==
X-Received: by 2002:adf:b643:0:b0:391:3094:d696 with SMTP id ffacd0b85a97d-39d8f4fa19cmr511308f8f.54.1744253209347;
        Wed, 09 Apr 2025 19:46:49 -0700 (PDT)
Received: from [192.168.1.3] (p5b057414.dip0.t-ipconnect.de. [91.5.116.20])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-39d89377785sm3229950f8f.28.2025.04.09.19.46.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Apr 2025 19:46:48 -0700 (PDT)
Message-ID: <b0b3c83a-862c-488d-bb05-67b9d3a5019b@googlemail.com>
Date: Thu, 10 Apr 2025 04:46:46 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.1 000/205] 6.1.134-rc2 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250409115832.610030955@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250409115832.610030955@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 09.04.2025 um 14:02 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.1.134 release.
> There are 205 patches in this series, all will be posted as a response
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
