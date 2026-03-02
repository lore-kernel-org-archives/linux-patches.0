Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2583A359A67
	for <patches@lists.linux.dev>; Mon,  2 Mar 2026 23:55:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772495760; cv=none; b=THe8wEdjQa2IalyhpWAB4bz4HhgcOh+CEaXJGshnBbs3xBksv3LzMp+h6TR1jnzXZf+owalDjnsz1pXJAiwZM12ZqIjSlBcM73eJAdAF06WyLmPaxBCiMBEq5mtRIV9G05GsptJr4sYJ5lfQiehozFIfSWPtDtXoldMxdJ6uhE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772495760; c=relaxed/simple;
	bh=FCf7Dkpi8cnZTKK+jHl+AKVpHFnuufe5M9zYul4nTBc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nA8EduO5bOYb130QG9697uR/kk67rx5eoMdXpaDpSnLwTvDvh9M7oGEG0fpygv9ecED5v2y4Mq9CQ+vE1ghgXo28NViUYux8/4AcDyIHseqKrC+wbTUfQCfq41r7cjFcqf+51PYgdGopBGSlkl/k2Ju5rDtDwxxiTF6fDaGsBWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=c3qHm53M; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="c3qHm53M"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-48334ee0aeaso43200175e9.1
        for <patches@lists.linux.dev>; Mon, 02 Mar 2026 15:55:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1772495757; x=1773100557; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=++LctVCNk1Uw/H5oAQpRvLtdGEwkmdXKLvnmKGe4Ffg=;
        b=c3qHm53Mcc53jZRafo+bO/qyMg9Bcdgf/WSoA8dMM0bt8QJRgsVRpPi+m+6kcftOp3
         ltFTASL9Qzs4BzMSusXtzq7IIuvhqJ+j+Z6E/mqKeUAazhFS4Q/HTS4tqTdP22XrXoQW
         BTQ97fxH+UJehXYkiDD0zrTlvt335gHZO224K5GGjZpkbkkVvhkdtwMcM9eGU4Q6keLZ
         a0ZBqQOdruENBbbQzs/5QiPld2nFJTWgcKZZauB0n0OuC1hgvngmCfF9BB00JKVpAwSs
         SwWNnB59MxCBU9jssQibnCifk7JbaUDMowB3Hr/kkgblkXcnKW9NfxJpEPshgOpRvKK3
         B/8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772495757; x=1773100557;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=++LctVCNk1Uw/H5oAQpRvLtdGEwkmdXKLvnmKGe4Ffg=;
        b=HVGlwGpHsTkXuE9X761rqBk13/epljZ1SBW8HRYdAxhFlJsxF5xGRP1aXFNju2z71B
         x7tB23k7SDGyBppF9QWcd4Ee1FKBqNx2WIMCNu1xA+0k9VtICfA1kJYqTZKCopmczrEU
         tkMF8rwhpF0NJO9HJs2rjV6yy2aFhFXjb359uIR+UaCb0eTLQMr6qWlwmw8TVRqhseQd
         EpbjgyTYnhkdxFe2j4ng9+P98pCVLTQ0hjxQ8fXtt1BxslDFHc0i9F26upTapRnPznGi
         HXiZn/WIXGTYWI7qdjneiMz9T60AvihL2nTnsbs5GAnDg5fo9T1NK8VqbfKdK4Mefj/R
         tWsg==
X-Forwarded-Encrypted: i=1; AJvYcCXHUfMMIyqr21l8yhO0cqmrPVEu9LeJ6p5ghFY8xtrB/9xINJM2nwTN9CaMlBLlJdy+p+BKQyQt@lists.linux.dev
X-Gm-Message-State: AOJu0Yx33nTIbfIu+vLtWxjhB3uUu30VURvWcXiORWLtgyx7gXHKOjcn
	grkqsBSU0dWJnJPH1Grz4LsD+aF/DIbrtQwnlknfgtcwgBzn32W3aP4=
X-Gm-Gg: ATEYQzx9aCmPgBBQdyf03D5eqiSYQRjGY4D6wL50hZ36VFTJhQNW8IkHO8ANXXrL3aO
	C6OmgRqY+jvLJSQcvmBJn/gt+CrunqG94mSJECIkNt6zaWesgeqRmOyj9623O7bZeLR2iZPwvyT
	wHKDJUy2LK48XQ0quVQxwY0r6/LECjWJrfxX1nxBtSyomBsomol2/55idglO5K/cujBIPBlaeum
	6dvtrKEHkVuVmRqOVJ8ki5o5WIWQMqnb5zbR5xIedyzo4EXMK7dEkVB7hniZXbQXfgQjmhhAON6
	c1mEzNEdyk3QYUCuMmUtBa/Hem/1gVOqcdZipUhY+dnjgdWjy8x9vRU+/trFj7yeJaKU80Bdn9l
	Gnv7qJHnv1quYlnbcDuvOATbg1kNZ9LQLgitPQBmMhsIFdTXeN3il74cC7RckkljogUx7L6QkaQ
	YasRZRIvbZ7wwcjYpmIjgCh6I7YiblrgUxsGBU2/VCbKrwE91UVM9nb0OWA1p9UdQPYOJ31/hGT
	w==
X-Received: by 2002:a05:600c:4fc8:b0:47b:e2a9:2bd7 with SMTP id 5b1f17b1804b1-483c9beaca0mr294617855e9.19.1772495757381;
        Mon, 02 Mar 2026 15:55:57 -0800 (PST)
Received: from [192.168.1.3] (p5b2b433d.dip0.t-ipconnect.de. [91.43.67.61])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-483bd7507adsm470843425e9.9.2026.03.02.15.55.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Mar 2026 15:55:57 -0800 (PST)
Message-ID: <46b36e3a-5999-42a9-911d-3396f4b324a5@googlemail.com>
Date: Tue, 3 Mar 2026 00:55:56 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.18 000/757] 6.18.16-rc2 review
Content-Language: de-DE
To: Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
Cc: gregkh@linuxfoundation.org, patches@lists.linux.dev,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260302160853.2519610-1-sashal@kernel.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260302160853.2519610-1-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 02.03.2026 um 17:08 schrieb Sasha Levin:
> 
> This is the start of the stable review cycle for the 6.18.16 release.
> There are 757 patches in this series, all will be posted as a response
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
