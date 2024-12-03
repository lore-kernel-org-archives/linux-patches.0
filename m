Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8520C1FBEB4
	for <patches@lists.linux.dev>; Tue,  3 Dec 2024 21:32:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733261567; cv=none; b=uNzj/a/pd7bqCmUZdqcHZtIvH944ArkogT/FzljF3LDkNX+D0gH1eUMfSc+9pBbRJCDB0/30GiaQwAL9aw8GHiYfi9foiQzNPZ/o5JoKYFaBkFpJua73IofLT5YYa3DJlnyQVbuVvgdohyu+e/m1wusqMCQjYBt9KDAIsZGa03g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733261567; c=relaxed/simple;
	bh=Nc9f1r+bEZooQfYMJa/uD4hIz9ZoF0d6uqNQ2F4dT2o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DTfFjeMmYBE7ektoNAtc46cZbsz7ZZv4pZixvOqmeIK5sJZwZdyN/ZgYQeWWOEQwqyQrEsEgMm6UGeyltO3kEfs2I5HO0IKlxx9xE9tKoTQxdU7nkRYSUvtjaJI5/szM4fce5WD7bVFVDbtFSj3DcykQQho+euYzLsSAkdhdwIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=fc2YAYuc; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="fc2YAYuc"
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-385e27c75f4so2738759f8f.2
        for <patches@lists.linux.dev>; Tue, 03 Dec 2024 13:32:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1733261564; x=1733866364; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jm7bvgrydeqcnLfBFJx4m6yhpLKJYsdk3xGY1CQIBJc=;
        b=fc2YAYucbfvQCeR0L5Ge+6fyKeQLGd15UKdZPNpIQ0thppg+5RnY2LNPzFs8nQT6Mx
         GFw/1q26yzGza3Cy11g5eIccFuIE0pMtclDI9UT/5w6nzYrF3yHkM0cvvLn0CVyWkiKy
         mCQDUwbLOZfqOCZV04awy0Zfbv8E+YpLbk+eCToUx0HS+ab0brGxJX6w5fxghzPkbk3R
         1sIfsw7KsSB+m8zSRvAfeN3TgwknZR1vG7MpOG8pi0486wHDfOYxRAu3r0geVL2MOh9J
         pbyT1h2nsI+5FEQzK0ylshuTFur6RAb6f8pkVwJXwsdaoEXrpYqk4EpTEfUqH9O5FBVf
         Zy8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733261564; x=1733866364;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jm7bvgrydeqcnLfBFJx4m6yhpLKJYsdk3xGY1CQIBJc=;
        b=YK0CkzkVrBMu9/EzVtB6AQ/LzGN2wmC7kJUvYWfnHBG2qh/CZKWuIROkhoOi89SIjC
         7F3A+9IsHR1gBfsGrM7sPWBhCVBh4w4YiRw3Vq+3WgdOPUGRDoNJr5IF/DiCLNTBGdQ1
         dVGZ9LjwBwLxYi186ETrQSBUNoCabJekjXCBLhynq0jk9YNdFA/pOfShW+pqstsKcc6t
         1QZw9LIe+Kuc0rK290B0nMNOMgPGjJbTKp111bC1uvHV7ySq1YIW3Ft6TYxf9YdAu/hY
         FXQ97wXZ7gAekEbnWYSAXvC+qF0UnQ7IRbj1alhEQOsOQZ8UR2b7R3MOWfkNevSX1pa6
         a1Xw==
X-Gm-Message-State: AOJu0Yz1/2dPdbSvYBvU2FpyzxZeOBRbZbO/WGDh8xbcVqqwO+y4w2Zu
	bQmZGQLyprnEZdxD97iCAfLxoiW/ZmiG602YzaNLtnqa8ianhKA=
X-Gm-Gg: ASbGncs3tHjufjRhz5UK9azEnZvL2EDZK9GHw/Gx2j9ZDKH1mCkqrqBEhD84BRqbr7/
	tx/CC9vGVnLwo00kmM0ueO8C/CZNYRT7PEV1HY/FUdoZTpuFvLVQzn21iEG14i4FkrmRN1CSAEg
	0RiKAAh9ZwAZMDPcutUpM4pT51kR8PObWMb2+TY4NwPE6TXhU6AE/1VMZScuXTRyhWS99CeKA5a
	0v9CG17yO0aAOryxd+171n1wZDsRauyo4RrLiQWxuoN+6AyUuKRTRH8OwYuor8yYlEFliXcjKAB
	WS4wxY/5rgwG7eVILydlyMzbDug=
X-Google-Smtp-Source: AGHT+IH9EQzxJI6HWUpjFSXQvIsxXjZW+yNwguN4EuE1JwjYkgk9AwgKAPomo3Rx8TU9VwjiRH07Kg==
X-Received: by 2002:a05:6000:18a3:b0:385:fabf:13ca with SMTP id ffacd0b85a97d-385fd3edac8mr3127859f8f.32.1733261563603;
        Tue, 03 Dec 2024 13:32:43 -0800 (PST)
Received: from [192.168.1.3] (p5b2ac059.dip0.t-ipconnect.de. [91.42.192.89])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-385e49cd788sm10932960f8f.6.2024.12.03.13.32.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Dec 2024 13:32:42 -0800 (PST)
Message-ID: <1fc1301a-b148-4e95-a1da-862dbab38e8e@googlemail.com>
Date: Tue, 3 Dec 2024 22:32:41 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.12 000/826] 6.12.2-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20241203144743.428732212@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 03.12.2024 um 15:35 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.12.2 release.
> There are 826 patches in this series, all will be posted as a response
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
