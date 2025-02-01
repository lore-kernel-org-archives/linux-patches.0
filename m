Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 248D81ADC9E
	for <patches@lists.linux.dev>; Sat,  1 Feb 2025 13:29:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738416575; cv=none; b=ZRMXDg3vNujNoZtfY5NVjrrU41mKxaTDhT7VSVxkwyWqt4sXnJKlrZ+VN7YBkkimpOQyvcJxjmiuOuYa9AP7NpCs/QEOWNYLAkq2mFEWIY61ocwoDi6r/qzigM2aTgssoFsFbTVNRaurDNdutxcU39yW2gXWu7hRWjU/NQTEMLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738416575; c=relaxed/simple;
	bh=YGh++SeYwAxijz5dR/paDwRNN4HBFL00uxMuc8Sx3sU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DcJr5tJHLDgdvR02/S+3n0bp1pxFuFe2RlyxZV7nORsYNag5eXwe9m4Xcl/WGN4SQ9KtCKiSw2Eoc9PXZmvWfkx9Zb+BHQecN2KaCo9CIQWbZqcE59Ue8bsst+v2C7+nMul8dg+pWKKVGkWGIEHlL335CDAbE3pNX/1kGIvE9XY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=d9RnDvBF; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="d9RnDvBF"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4361f796586so34034295e9.3
        for <patches@lists.linux.dev>; Sat, 01 Feb 2025 05:29:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1738416572; x=1739021372; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7cjr2yhoNxeoGoillh6jBU4BklgXKOyvt1t79LqLvCo=;
        b=d9RnDvBFKriTOBgQFAvu0RJ2jsJAq4ssM7kxk+5SqUIT2Y3iY9dj+1BnUDGlejMstO
         dHbWzCuGfrYgRdhEtkacI8naot+/ErHxCu0bDSkJKJMm+EkIsGwIg6LufFHCZsKnsRzI
         nUbPR7SrbQ0hqpPiAUuHWvyhcp+4DRmfmwXPQAM9zeZv954O5Z+r6V/HBPPVzuDZcazn
         MbU366xHxI/hiAbOX521htksogE3djOjS9pC+Xi2+KIAPvGosmGKCB7cuJQy0SpIbFZY
         iQYUu8vEE4PNQKM5LTOfgLLbOhbbsC2OcQYW/RA4Vyf6ST/qrVXAY684nQdE4crnwax1
         H1lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738416572; x=1739021372;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7cjr2yhoNxeoGoillh6jBU4BklgXKOyvt1t79LqLvCo=;
        b=u3NzWhNh5NmhKy00i987osm2zAtrS44df2Dh/JOM4qCCBNLZdFsZUZPhN68JWwNLi5
         qb18UOmAOZaqcah5Gf8XL5E1AdI1gJ7fKwsT7VjSlrqLQJpe4zjkWJ5rcdUo9qQ5K5Xr
         SE5uE+0hgvM7vUOW73eCJ4E/h0A3KTGAwj+Irk7Xt52ilhHJqJRPW45i/uZurtJj46o7
         R+RNp/+PO/IffOb6LCDgoLNf7bmH3K1s3TJI0qzrtbCb3CMOOHlCY7ab7x9FwcrelBdN
         NkE0pZ9DKTkd6LGwjKqllsak3Bia7IbvRUIud/lynJR4G4lZFzmww/XfVhna5PiM1CR3
         x2eQ==
X-Gm-Message-State: AOJu0YzH6K2J6Cr1etkH3xbEFJ+cO6BgGkvga2yGywMONjWb4J+il3mg
	xagv/a/6Gp6PUxHDdjtRSEc3F6XHVjBi4nfBxry+WFvPvBjOO9Q=
X-Gm-Gg: ASbGnctebue4ftGn3BV/jxJnkoE8ViDtfTGcprd1np5/wM+BI2oWTN6SnvyDj+ghjTh
	a5TeTvuRdfY+5xhDFBTElKo6dB65SSWLAZl+icugul20DoWU7RTFWodDMXFcBGId9A3nCkU0BOq
	//EQFRQeXzkIOXIwVSUsOS6KSpC5i59UTIxWxjsyeoOO+96Rsqv5Pi0lms8EkRMN7khe8wtwU9A
	cvnK3jB3hjYHnQZAsvBX4786NELR9XJa8HLHY/ZEtR7Rdd771CNZcbz+w9xQPCDjw2F4QDf3tQm
	/ALitpvL2Svnw0A27RmfDyprKWDStJexNjYIprDxCSuTXnJpxFFehLs4zj3bmioYqc5N
X-Google-Smtp-Source: AGHT+IGBwosdu4S+bCDxuv+85+odZHbCxNBF+xSwi9KPZ5qDqLC9L36cOWNUCbQoTZZpolAQIbUQOg==
X-Received: by 2002:a5d:5888:0:b0:386:605:77e with SMTP id ffacd0b85a97d-38c520a35e8mr15757255f8f.49.1738416572199;
        Sat, 01 Feb 2025 05:29:32 -0800 (PST)
Received: from [192.168.1.3] (p5b0573ac.dip0.t-ipconnect.de. [91.5.115.172])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38c5c1cee41sm7193429f8f.81.2025.02.01.05.29.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 01 Feb 2025 05:29:31 -0800 (PST)
Message-ID: <f30e70f4-b8aa-4edf-a272-e848c84418a1@googlemail.com>
Date: Sat, 1 Feb 2025 14:29:30 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.12 00/41] 6.12.12-rc2 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250130144136.126780286@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250130144136.126780286@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 30.01.2025 um 15:41 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.12.12 release.
> There are 41 patches in this series, all will be posted as a response
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
