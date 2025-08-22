Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 500D22D47F5
	for <patches@lists.linux.dev>; Fri, 22 Aug 2025 23:27:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755905279; cv=none; b=iWOXB9QKVpki/N2uykeBIyXlIcYH0pK3gM+xdehbmUS3zrbbU5i3rF4epH/Aw7UUxZREXAOCNF0KN/OBCBPx+x5yfCx3JPWDAJBAf2Pp1ujfMc84PaAUOdEiGhs5UMrBP3yYe1DTysEhRpkAT/UL0UvBBYPwdUXbmrDsGSH1BK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755905279; c=relaxed/simple;
	bh=Dtbshtfd59+ACburoBjaQs73/LoWpyMIikfBId5SyFA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VGW4mvs/gMJoepFwqUDaZgtgRqoW5+5FSkLH9JdpJbNxh2MCjwDdF6I5bEdiOMKGXcmHdjtukgDljsPSrpGZbSVNWMZP/npLqQjvZ0XXdzclLmjgOUfG4ghWiwvtq/VsuXkPNv2lopSpcpa9Uiecd81MoVV/MLLwqBn81DSNprQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=gxagZkdf; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="gxagZkdf"
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-3c4e9efb88aso1383417f8f.2
        for <patches@lists.linux.dev>; Fri, 22 Aug 2025 16:27:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1755905275; x=1756510075; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=k1gpNFvn5HCFRwIuldpjghpNbvpOxRC8cn9/8F0Qqgs=;
        b=gxagZkdflVNgJ8VkymBKvFa6JlxJOdTojqEssUGdpjfzcJYKXDh62yJ5RYov7tLIlC
         DTZJfke7h2r4EZiZPrDS9JZUKT0JSkJwlnFQoGa7kKFbGISjJz8UmK7ge+3ipemOXAO8
         kJchPOu7PmL0K2AF/flpMjrLaLXA+IR5w8eUkyNYj6WtE4wuthgOPiQmYUL+st/fHCmE
         PzDnj/A0r+DGdGX3Bhgd4U0eYS7igPrfG9c2NxPQ94FMhmNt0qLJ4dnC612lmrvv1M7N
         WP+hkEQYgdRvNftZ6wEHzbPyO66DZzjaoQr0o9o6p7vVhtJ+RojRIbqvu4bWVw09nUp+
         yQtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755905275; x=1756510075;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=k1gpNFvn5HCFRwIuldpjghpNbvpOxRC8cn9/8F0Qqgs=;
        b=ezr16FevUuvDjIASdxQbkqnxSf3hrRN3j8/innXXM6hQfZGffP5ciMySNjxTUPVpac
         Fa53qzGxxU/ayXlAtPBI1vWQ2Kwpu9b4TYqW9FFt+GrlXEJ7cLayw+qXeyRGm/GMccio
         sN9GPZG29al0nQUg81fr9fPoGdJr2fQfeILRTlW+YYWWxT+2SE4Recdd7nhYnM4BYKCE
         NTN8vz86YaWXqHDihl0JlPPAraoDi917UV1vF9BeJCVvWo1PlNcjFkhyTu+B6b+3fUuM
         r8ijjg842hYVnhsNV6JGXIulG+7DNIiQQKlPDWdyAgo+xmOmLzPVMTFgW9j6YTJUSnh+
         PvCA==
X-Gm-Message-State: AOJu0Yy3nIYi+r2n9eglFfnH+1CzvXLLkLCUAdZ7OMPL/dkEJZnJernr
	saaq782aui8dYc8JQcAY+tYWJ5V8tYLJnfh5/BQhkBGRCjZFN5VZBAE=
X-Gm-Gg: ASbGnctxCP4KftUjiOV8Z88by39XhmVUT0azUswYqTUCU3KbqUFmBRmp2ZLKM3kK4gn
	7P18uHm65Pj3GQWARmHsMHEadLGiyxsU9SCos6cejYktCjgZM185PNPgETwSnrBrXLiuiqXqzJh
	xeK6fFsUhktTXt0zn3QOAPqpghqb6/+sRNvaeXmOLEbfWqk/3BKqRaFD1+dDTx7hZetBodN48QX
	0Ty89GG5638muvdQJoh/48DPsY/dponqy8619Ux9Dsx1874HpTKesvzem11yZHPhgL8z8yN0RjH
	qTW7MhKLIpezXo21z0BeUY9C2AG4suW/ofIxAk8zkp1dPRLk1CcXebj/ybD+ucPUkuCGqaxmKVX
	kKN04WcRgG+fU/os+xeQpKSBA1OtV0ljuxbtSkc8CH0HJQkODE1vliQE8WjDnAE5qU9z0V1nagk
	vw06iBOtRP
X-Google-Smtp-Source: AGHT+IForz6W8J+AT6PAiCEWl7L36/ArwT8KQw87Xw+3heLnbXHk0yiBNL84FscOsiQA1vM902L9tQ==
X-Received: by 2002:a05:6000:4387:b0:3bb:bd05:7bef with SMTP id ffacd0b85a97d-3c5dbf69bfbmr3843292f8f.24.1755905275241;
        Fri, 22 Aug 2025 16:27:55 -0700 (PDT)
Received: from [192.168.1.3] (p5b057523.dip0.t-ipconnect.de. [91.5.117.35])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3c711211cbcsm1171217f8f.31.2025.08.22.16.27.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Aug 2025 16:27:54 -0700 (PDT)
Message-ID: <9f68aadd-b0dc-403e-90d8-eedc018267bd@googlemail.com>
Date: Sat, 23 Aug 2025 01:27:53 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.16 0/9] 6.16.3-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org
References: <20250822123516.780248736@linuxfoundation.org>
Content-Language: de-DE
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250822123516.780248736@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 22.08.2025 um 14:37 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.16.3 release.
> There are 9 patches in this series, all will be posted as a response
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
