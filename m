Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A60814F119
	for <patches@lists.linux.dev>; Fri, 27 Sep 2024 15:17:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727450249; cv=none; b=k/mTqSez/l5h7PaTG16nhbfauydBIFroqHpm6ijWyOyukYWxUFaOufRYwUTxMkBlqAIkSOnUGfAWjyhtH/mThiBAi36piAc2Za24gOrH+McN9jWq21nh8OybFXrnegmWIePCMchET4PFtmJ33YdOWtGaon+EUJ0WaXOTyW5eKTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727450249; c=relaxed/simple;
	bh=qotPI54Wq5Po4F+d0vEMiGICRK9Y0VTfQlp7OOQ80A0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LoSkDQZJ2J1364tFVFtQUEjIfzZxP74Vm0yLBLzxeOHz7D1ttUmld/vJJfSxNFXom75d4A8SVac/6j95FvaVMKk0cM56gDvWQGFxybLtCp9ELqVXd9zIZe+RmpQC4ZeExOekncIk/ybR6T8xYsRGU95ISeJYWpXP8l13xFd6jcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=MuzdjDz6; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="MuzdjDz6"
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-37ccc597b96so1613353f8f.3
        for <patches@lists.linux.dev>; Fri, 27 Sep 2024 08:17:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1727450246; x=1728055046; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vhCTLLGVMcg5/d4nOELjFPANclSHCcn/4bUTIl748nE=;
        b=MuzdjDz64t9Kc2Awj18SXWOxv8NBQaFUgukh4jXfaM9JWi1jxWdzwBWvZzxUMKRsx4
         6sGbd9tTE5s9ODJhvX0Fa5/4A9jD0a7vgUcxNKJ77JkBSjAn6R4nkxGXdmubLPCME3BG
         r1bZB2tIW5YIT6XROu2X6L7KNcQC+snS8lnkBcDIu+cqYEXUZB0OI+7HBuTn5bX3X3M0
         TInm9a80odLJ3X0Xcr4V5pYrjo7tiZ6/t9fXY3M6+QHyZgYCBmHXKLXQKka5ndfZOwLm
         qiM+f/Gg+KDj7yB+EtNvfrNSw5l1bpjOKH5uV/VG0BmJzU/+p9hL2ojkMHuYuAW7XpHi
         wqpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727450246; x=1728055046;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vhCTLLGVMcg5/d4nOELjFPANclSHCcn/4bUTIl748nE=;
        b=tpptwUuU4NsesZOFP31EewdnrdrDRKHBLcF3K75KTpjf0lpNwbLQnbV/kUKFvh6kqq
         pFZlrg7pkpdArGXOqTz4oDi+6/lgUi/hGa2wuODcDQqHWJrYau+ZL8YV+mr43iwkE7cP
         Hx8xJKzhGDdUbLXXQZgn1Vgg+WqxcDN2lBXUE3n25G9EXRjf34vAQ/rUcY+LuF27VNuF
         dVZ8Zx9lDwgEFzgqaTAW+Be/ghLcflClCfR2h1XZXmxTglQHRVl/cmvB2Sip9iZz1hfL
         3ucVkFQYClB0+1ZI0xPoDA4CNuZbDxAn7ZRibEsw3qDZOw92bfLMPuyQqGZzN3nsE5yG
         MKYw==
X-Gm-Message-State: AOJu0YwcSoY7CNsxA+OqSWeUxkIFVuNvCQj8GBxKC5GaXbS6Zseabqqn
	IbOCQO0h+z9PxkYoVLLci14VaPJycEFJVST7HsFZ9UQLVAnpW0E=
X-Google-Smtp-Source: AGHT+IERcBTXM/JQeaH3Cd+55vt4oYSz+GuJRentSrjtcxuR5nQoUgBDrbncowFA4cYrh+zjfP/5gw==
X-Received: by 2002:adf:f385:0:b0:37c:d23a:1e4 with SMTP id ffacd0b85a97d-37cd5aa99d5mr2543951f8f.30.1727450246143;
        Fri, 27 Sep 2024 08:17:26 -0700 (PDT)
Received: from [192.168.1.3] (p5b2b4a79.dip0.t-ipconnect.de. [91.43.74.121])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-37cd5745696sm2750790f8f.106.2024.09.27.08.17.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Sep 2024 08:17:25 -0700 (PDT)
Message-ID: <cd70ba78-d32a-4ed1-a0f9-b6f3131fcfcb@googlemail.com>
Date: Fri, 27 Sep 2024 17:17:23 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.1 00/73] 6.1.112-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240927121719.897851549@linuxfoundation.org>
Content-Language: de-DE
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20240927121719.897851549@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 27.09.2024 um 14:23 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.1.112 release.
> There are 73 patches in this series, all will be posted as a response
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
