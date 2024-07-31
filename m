Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86A618BE0
	for <patches@lists.linux.dev>; Wed, 31 Jul 2024 19:04:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722452655; cv=none; b=m7UBy00XUs7CnD9sRHJIyveuxMCcNPL1NyG5pPTHO/PSBenPdCHdYp7iK/VdCNTekJvTjFePnySO3kWfHhz7SvrJzwVVj0+xyBPN8eguCEW3f5ovJ2aSbClT+RnRbUrQFVCnBnHrl99rxkB1t6IfIbMLFwGddbR5ODhHQSXsgGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722452655; c=relaxed/simple;
	bh=+MvyBo2H6Y8yiRyRHf0TiyAD5R2lLXljDQOJRl/ofIw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=s4SqPx5Ezx4/tn8hCaFKczUptkyUWMO7zsqPfqpoFXeOFNumBIp8LvGpolEOlFfH9eK0lXL83EEB/Gb3vh+etLedOGDl3lsPxBI26CzmsC671qsqkpmWUk2JQK+i9VH0MF917reX2uNUB3JZryJKc/TQ58IcCAY/MzBoNUxeSRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=Sq5i64fv; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="Sq5i64fv"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4266dc7591fso37615925e9.0
        for <patches@lists.linux.dev>; Wed, 31 Jul 2024 12:04:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1722452652; x=1723057452; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0FyhqBwngf/KZmQNhoC+ky+u7X/8DxKtgdDpV78vvEg=;
        b=Sq5i64fve7jnqe7tj45QDkpGn7txEPOyy181u7yUSgVXmpxvL7xmUbXHoWSE7va8t7
         uX6QEC0Fb4Lc7qCansFxQBiff57AAFlSIAGhaiyWj/ADcIcTIQo8ajQK/TOmzG136xpI
         4f0YM5RZ/nO3oHknj4A0CP4tNJzEbrshcabS2AWs5bm2XNZLlN0MUlIChcsKUrZADWg5
         AJm9oFM75vtcNS2sC0ROjkQS+BKoEtnwiaX2/oEozaoaPc0dF+YTNrQmazIYFuyEtDU/
         CjuDY8KwPGQgEjVoE2nJttnm0gEDoy/EMfWoNk+YN5xmYbFNfVVodQ4whRitLQ/XMI5r
         20GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722452652; x=1723057452;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0FyhqBwngf/KZmQNhoC+ky+u7X/8DxKtgdDpV78vvEg=;
        b=Tw565YI/XxfH/7RwX//oJDYfzmkXuVpLIhvlCmX3bUEZINEFb/K3qAlcJoJZjqbdJf
         MuxmDBtvLdiF+6njwwTqFGPQGH44HuhP88pvu1X2xjq/jaEnBYH7giva0k2u59ni2e0j
         VnUD1vxcse4DeF/To06Kbb6GAemLOWrNrTdNIUK1pjuGasQca6ZAaBv59RFg9iVzVjb7
         deGg1LDmYCdd9oj4e/1aJGTcfQqOGqfnBRr31GDMnOpIn7936VTY2YF5nR794zJsVq+S
         uy4y9xkuFRVT6aH4C41PE/iIh0jOgLUEjP9OGt5iNla1YJfjxQweik0gW8arjqPpXtTV
         I/mA==
X-Gm-Message-State: AOJu0YzjdjWPWcX7uxVW5xvmJFw6ysGq1cyOmnmI1BteYyxtjEeTZJB1
	CvgBiUpT4WHxmbNtiFxt+dI2B2KJyup3/nTu/Guq5Cpq3mnm2EE2FmifHh4=
X-Google-Smtp-Source: AGHT+IH6fw4jG0HDdoJ7Rn8PahT4zwlICFi5K/wz2JahioLHATpdd6agfaaWuGLu6cvYWPHseMgIsA==
X-Received: by 2002:adf:ffd0:0:b0:367:98e6:2a1b with SMTP id ffacd0b85a97d-36baacb623bmr144624f8f.4.1722452651449;
        Wed, 31 Jul 2024 12:04:11 -0700 (PDT)
Received: from [192.168.1.3] (p5b057724.dip0.t-ipconnect.de. [91.5.119.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-36b36857d66sm17658356f8f.83.2024.07.31.12.04.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 31 Jul 2024 12:04:11 -0700 (PDT)
Message-ID: <78db8b6e-cbd5-480c-b8af-5ffc3d771199@googlemail.com>
Date: Wed, 31 Jul 2024 21:04:09 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.10 000/809] 6.10.3-rc3 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240731095022.970699670@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20240731095022.970699670@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 31.07.2024 um 12:03 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.10.3 release.
> There are 809 patches in this series, all will be posted as a response
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
