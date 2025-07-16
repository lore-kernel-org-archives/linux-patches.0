Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60BBE1D5CFB
	for <patches@lists.linux.dev>; Wed, 16 Jul 2025 15:16:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752679018; cv=none; b=d+CWB1g+FeB381phnk2Roys7QR/Ex2y9627KFkLawWmJ0crZrKAosltVaI5m8Tpk91cOsNww2b12jAXqbg8N6zWCOgkMLlLMAtqOPIdvWWFPb2eu7ID1F+C2ZwHUuiDLtjvwFEvOTGNDvmShMAXzu/9zIypbc+N50VwjaXror9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752679018; c=relaxed/simple;
	bh=MAPCXd746dLBijiuAG9wc56q0nopYPabJGjrqlYl2NE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=usy9QA5PX/TWcrASphsDcPkaQ2Cwfhb6xW1uaJMtHDDnN0FqzMlFYIhupXFM8GnXH1TBD7O5ngMMZXHa8PkvfvUUp+t/mOftT39dX8CedE09fJqtRY1c8zy/iloMlllqLX9p7gy95gwlB4+wp7bSntgWXbJ81GtJ1VUBws+JRl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=LaAKxyL6; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="LaAKxyL6"
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-3b5e6bfb427so3549666f8f.2
        for <patches@lists.linux.dev>; Wed, 16 Jul 2025 08:16:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1752679015; x=1753283815; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=avBWJ25ynfi1WXdhKE1sihofZACgr0iOjzJgTGpVu4I=;
        b=LaAKxyL6/jyCtN6b2yIIRvCLnD1kQAH+3qH4AGP1YnzaEMh/0Ztmo+RnIhhRnI48pR
         YgR9pnycph0QkTUPXe35klmZLJAVwgsoQ0yO+3zdBc0/ZPaoRQg4Ce/Gdbm8hOUaLzPp
         axW2/mH5WNTNXt4j1pBn0sZYcXsYp9yj6WelZu0XjZCSWZHhLIPl5ESrdUp9VPD+2oBW
         1EktZ0510Sa+ix6xkQuMOZqJqiZ8/n614JbdIdKmf7sifL4iqXQ+bAsX9PuFYxEioCjj
         f8qTiHWe0Ixf8rvNM17iKViHnxvv/rSPLFfSBfxTjDv54EYME/kE29246CL4N3odIsqO
         n+Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752679015; x=1753283815;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=avBWJ25ynfi1WXdhKE1sihofZACgr0iOjzJgTGpVu4I=;
        b=V0rAPJizHaC60qVftOOYloCNQNCyA/b00ixTul+OH+rbdQV3foDGoGGsXaoUB5oc8E
         K9nJcele1OPkn9plTWRLPFevXmrWbX6Z4xtXa2YMWzPq8yCOB2DDeouMG7RxadKRWq6H
         bMonZOzvtWN9cilepCuVJNNumuRnQVcR8ZS502LKx1r96TWRqLdgOACnYmu3kwWxa9Dj
         6iU4TbWXjHlQmksuoc755MXNvCUOlAlEE39mMmdKfFD6R8qWXTIWOzKufsXNFUZr5tVp
         Tjd/SbhczUC8L5aFbvoC4hHvi3LK8laog19nHzRW1fzxGxOL2zDwgcE1pbthOLqvlCW9
         bZ6Q==
X-Gm-Message-State: AOJu0YzMIXSgQ+uQ5QEQLp/d1NXc0oPwCWTwTxs2Prq8W6IRleQy9B0t
	el1KjImXFNHlGc5wpZq6Gh7tiKrwszCOi36SBTxED2Y00JaX+uTZwgs=
X-Gm-Gg: ASbGncuk45vLwLIrsj5VKo3iN9UOCTorehQTCAnEgC/+sL3+TvxV6Ujfxcv01UZWpxI
	WOSRJCCHVeeyb+8G60b5++GKp7o36as9Xsi4uwo9pDmlerM9jPqvgWFBF5ZBR+yn4uBHZZtXiM1
	MyFHgvx6lzG5rQMJotgV/OfUQ3Xc481BfULhTwSha/U2LXDVCyAcbh2M0vCWSUJXeazlo3NtyTc
	jm92VzTE/m1+sWHoPrPqAB7tGdclaZBi2W4kftls6RwiUNxlA9T/2BjUkyEoQai22DfRsuPON7g
	A6g0CgS0ppje9sEkdwtmEA1xtZhX2SAjuytdTcuAm1rNn87lFom1U+vtXo1ZXw8yF7HKnzSCWKi
	hRSFyV6d7R5+w3mgX7NhXV8kRhHuAFuKSidJ4cbUmFyzInp2QjsC8I9qtJJfMkSy5UXriK9kiQS
	U0
X-Google-Smtp-Source: AGHT+IEEwF9/Vt1NN9RTGjqLRAvAvAprCYcNaMdoOJjP5OOWxXTAo0qCZRqZKCsXUdsgjQgLX+bBVw==
X-Received: by 2002:a05:6000:4a06:b0:3a4:dc32:6cbc with SMTP id ffacd0b85a97d-3b60dd53fe5mr3490110f8f.20.1752679014473;
        Wed, 16 Jul 2025 08:16:54 -0700 (PDT)
Received: from [192.168.1.3] (p5b2ac571.dip0.t-ipconnect.de. [91.42.197.113])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b5e8e25e75sm18016432f8f.87.2025.07.16.08.16.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Jul 2025 08:16:53 -0700 (PDT)
Message-ID: <da83a1d7-3609-4fda-932e-0a4e41be890c@googlemail.com>
Date: Wed, 16 Jul 2025 17:16:52 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.6 000/111] 6.6.99-rc2 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 Jann Horn <jannh@google.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>
References: <20250715163542.059429276@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250715163542.059429276@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 15.07.2025 um 18:37 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.6.99 release.
> There are 111 patches in this series, all will be posted as a response
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
