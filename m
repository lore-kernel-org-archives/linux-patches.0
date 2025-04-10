Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E80D615624D
	for <patches@lists.linux.dev>; Thu, 10 Apr 2025 02:24:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744251882; cv=none; b=igde+3NSN7QboZQlm7J9tKFCyZbgOFyv0qOAbsPmPUazKLgvul8KnER61qEKd7PuWjqIdV3hxxM4USL5lNxgKxuP+dqbGrQw7VM52NaJtB3djRc8Gf47Dhsh8tPooZhMA5ASsmQSsLkMe0bRv3xhrPB6rZqn1pus7bgYkJKFMV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744251882; c=relaxed/simple;
	bh=Eo1gt9bKvrZ5+HJR/BHOywwDv1Yl4/abKqF64Ryk0ek=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TTTdm76/tkpM9Xw/xNJhzFA+vGNKBQFjEjOwiyBC0kwtPKIsax6oC4RRCpXA2R+bcE3ld8roJ7bMAKYo8iJmoO3rr7bRD8hv+HkMU2tLZ4xM7aZmQ5C3dqIcJlbVkoOjV5pgBzfLvYHEStOJ048l/SqCy33zgb8Ii9FtX/K6zmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=CDQ7p2ou; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="CDQ7p2ou"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-43cebe06e9eso2179975e9.3
        for <patches@lists.linux.dev>; Wed, 09 Apr 2025 19:24:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1744251879; x=1744856679; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=aLsoh2OIC00QijQVonaJXsKWz3fOoh+K0IKMEyFAzFw=;
        b=CDQ7p2ouvU2Mc2pVDTnlleiYtn8JH4i3kZnJ6fQon6JhIxzv0b0Nay162//F6Q4YKK
         Cjw+6/D4dWn+TOrHBueoqZl6ETsV38IteHZRQOyNXx+2nH3JCy7gAWYBCARCrN3mAHPJ
         cJIqW3EjoPTAJL3YeZ1YtONHn0bU62Rl8ZeqofzFTI6Mo9IGxnxV9rq9iqx0hO07kc6W
         /EflQcykg/gIHsItpAXs3aFhlS1dGriuQ2i056lR7Urw2x3rrdy01w/SEFLijfLGT4XG
         YlNsniNQSat8BBCi6CkuZWS25iFqh1hN5emku9RqFsbpOEb0oAxgqMMxQIGHSDSt6vbE
         J9BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744251879; x=1744856679;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aLsoh2OIC00QijQVonaJXsKWz3fOoh+K0IKMEyFAzFw=;
        b=itK6N2CvxfEJ42mdS2s3WKDd3TjPnDe7QsPX46bTHD07e50xDpwiLl6XlGbc+YYLEm
         iA7c7kcE61kBTp6F27t6XmetmOQ3HApztVAwVFyd304YPnd9AWEEjKhyiZ8kdOOP9Gc6
         RThW8w7cE31VDnPFx871utjh7uNH2pKQS0BFF7l7RL0et3HhYOFfON9ZfxLEbvobhOgI
         aGnbP8jfH7dpG3TVK0aN7Wj5n8CdgEltYOkhOmAyWDgQqQuTSY1aILJiW6/hzmqATv51
         FBToF61KDPQ67I3lhWRIRJXVqur0v6Q/CIBLPqHVZy9FrDjBJKchD0oMrr0PNG6K0E/w
         ulCg==
X-Gm-Message-State: AOJu0YwxQHLbARW/GoeMC1RXAu2P0oPVQwOmicxaizer3SFicVJqgn+3
	LZwAyogYfv+fVLN0Tj8hFUoq9fOvHni/9B5q59o3D1siql1ek+I=
X-Gm-Gg: ASbGnct1KeZA7fJ/YaE4u8I0cBj7yeon7A6XfKPGoeCi7v7bBS7YINz2O34s7TwgBy3
	XrzT5uRKEvRFl4g8E/4tJMLrWhQQGVOrvdsUChDmQZv4PPjOClxF0tFKlciUgJDcWJ4iYVzolN9
	v6hTPQBGr381g8rGiXlABq3/fcG5gL8+7tE3exewteWSK3819UoFRNKTfDRNw5OAQ2xcptONyFB
	eLAzwiILVqdsiFcY2m7rnW7ov51SHAwBkXMyj4ittyLnXa32x6avxJ9jYcFnS1ZBMI3AwQbFwG+
	Qiflm4mns2wJATg8i17G3AP3kk7XqZ0tFBCOA5ppK+qAG4aFIF3yvRAYptrY5SvUql2+WBIzgWI
	n4DydUtiMa3PC8sjf
X-Google-Smtp-Source: AGHT+IGWCWxesOK7jbekbPCv/x0NNcwUVBmp03gM9Ij6w0NKiLZ6YXEuDKJaUpEmxnowZDntDgDmPg==
X-Received: by 2002:a05:600c:1e1e:b0:43b:d0fe:b8ac with SMTP id 5b1f17b1804b1-43f2d98b7ddmr11478485e9.30.1744251879071;
        Wed, 09 Apr 2025 19:24:39 -0700 (PDT)
Received: from [192.168.1.3] (p5b057414.dip0.t-ipconnect.de. [91.5.116.20])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43f20a9f14csm24512175e9.1.2025.04.09.19.24.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Apr 2025 19:24:38 -0700 (PDT)
Message-ID: <cc67b805-4ed5-416b-ba5f-3b52877a96b6@googlemail.com>
Date: Thu, 10 Apr 2025 04:24:37 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.6 000/269] 6.6.87-rc2 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250409115840.028123334@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250409115840.028123334@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 09.04.2025 um 14:02 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.6.87 release.
> There are 269 patches in this series, all will be posted as a response
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
