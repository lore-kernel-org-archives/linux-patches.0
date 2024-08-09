Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1273833CD1
	for <patches@lists.linux.dev>; Fri,  9 Aug 2024 06:35:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723185309; cv=none; b=uajJ02SXUgnohU7VhyUkvbb1zQ9Lbp0hDDSjcq2hx7O+FiRf/r3J9oiet5DeMWu0wTNwsiR409fDfsSlqc2C+HTLeDbDXoPPiMjFjOvuk2Yqkhgebljb8NCXV7Qq8AHlgQCUmJJVlixqyK7B2EZ216YkTew8FqZPFQeRNmehb9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723185309; c=relaxed/simple;
	bh=GKtr8nhc37ZChqd/sIw4sToKmVF2fcW2I+SqjRUqOLs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XeDOzwGAwFOanpbfNq59XhjH/kJghwSvlAmCZAdnYecYFffMaaFPxqJHsqUqHC1m5TASkSj8aMrctHAiak3QCAtTqlQu4oKbkmgoUNsawLkxMKiqAhCBTL1nV/ec1DSqygEyszKLRzXK0I8o1rIqcJse76yC0zLrsrlk8MYxFmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=d2rMRlvB; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="d2rMRlvB"
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-a7a8553db90so214771566b.2
        for <patches@lists.linux.dev>; Thu, 08 Aug 2024 23:35:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1723185306; x=1723790106; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CVnfAEiRYm+yWiEHeMZb+Y8q5Y3EB4cYQYvJxe5LXZs=;
        b=d2rMRlvBIRR/ElzIeS27wI7myBFYQFKHBcX+jXHyV6fw8Leo/SuXo3NSTHsxYfcC1N
         8JzAdVl+U5x0i+RyDJfvX96+rnkbXBbkX/IkPZSyjB72CkFiC/xftTwSUfdQ4CPaAUrH
         hOYjK09ytCh2SgSGiaE6sHWx7WmE9+Rd4g3ox4v9PyqHWeX1qKKTPCHxHt9zkZ667LY3
         4HagLcyRxBWrhLox4FKv3PGO0CDVT6ArF1vcLrE4yTKN0Xir663kLLPtRJCj3/pFPNH6
         fiveeoP0RS+dWnW7CtM/1VHicV/qGEwWmoc4vFR6jv9BupLPllj9RGijiPstBftOFZ4w
         4TNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723185306; x=1723790106;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CVnfAEiRYm+yWiEHeMZb+Y8q5Y3EB4cYQYvJxe5LXZs=;
        b=svDpgHbqy2MrHpOR62I7NSSs0IxNjiubvii9lWU0dgBz7+xOPnDUI3ceSGPOjUT7Lq
         gXAcd3nvfbltH9aBBhwHy6isYPmrqupR/BzSC1uqPIIDC5PBHAAXW8tNc1nKpc45NWlh
         jF0kVVG8bBqnxc9PAe16jHIokr4yLBwqt5yTOYSOR7uUdEFDdh7cEjGi/TlbBaKq+l3C
         B52izIGSaIvn4QqD5HvRYRzKBQGQbjwD6R7VpGumc979997MmIeKsnoecA+lfWQpoi+6
         3i2qLr6kMnl2rZPLI/5RQ45QT7gxMjGvx6VwNLNCnmO6DNa4SJh/FMy763xvRWZ3cFws
         MCng==
X-Gm-Message-State: AOJu0YzJTQom/ZW/BdbBHClsWdpupiKabW+G7YiyEVC2G9CmXhYbl5WV
	l5M5/QqoU3FnnDJXz4K3Hy9OflH2H35+aG+kLv030mwRLyDJVng=
X-Google-Smtp-Source: AGHT+IHKSd1693e92TOlqx4CfQaMdz0+zR4H5NztzJSB5vHvlFvXKft6DsSez5D7cfNGjAELfeWMrA==
X-Received: by 2002:a17:906:d246:b0:a6f:4f2c:1936 with SMTP id a640c23a62f3a-a80aa660067mr42935766b.44.1723185305842;
        Thu, 08 Aug 2024 23:35:05 -0700 (PDT)
Received: from [192.168.1.3] (p5b05740f.dip0.t-ipconnect.de. [91.5.116.15])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a7dc9c6627esm814672766b.95.2024.08.08.23.35.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Aug 2024 23:35:05 -0700 (PDT)
Message-ID: <0735761c-d172-4db6-a211-6f02bf1be342@googlemail.com>
Date: Fri, 9 Aug 2024 08:35:03 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.6 000/121] 6.6.45-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240807150019.412911622@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20240807150019.412911622@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 07.08.2024 um 16:58 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.6.45 release.
> There are 121 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Builds, boots and works on my 2-socket Ivy Bridge Xeon E5-2697 v2 server. No dmesg 
oddities or regressions found.

Tested-by: Peter Schneider <pschneider1968@googlemail.com>

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
