Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ECF4442FDF
	for <patches@lists.linux.dev>; Fri, 21 Aug 2026 10:49:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787309345; cv=none; b=LQ0iMLIruG3TDli7/AMC+E5kEWYQqW0Orz5VJHyvyAaeiOgPXVcA/Z3ct0Wfb5i7qFpAJtnZgNErnukkjE/A1AM8nYNVuxQdrbktQ0x0ms6/a5uXEGaIlCeLmlu66+dek4imR/TPKyADGc1PQWtEW+lGfAMROC6xG+9AI5wkpoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787309345; c=relaxed/simple;
	bh=Cj7o51EaSzEwu4JFr8d6SDAAvRps8jIHBICb6cVfjDQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=K2KBFO2LMwW8/HP5r72i/uOD+9pqJ51xMKBHXrd6Y12UhkiKm3FEDAacIGVv5e/Zeifhb3ssioMSCzxO8suyIj3z4Sl8sGSvVoJ5hI2UmMz5YbzylTDoUi9ecC/+Gd8jSX71O1XtJoXRWxUsO42ZxB6reVzzx3MSsA+4eS5bjRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=ku0afoPH; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="ku0afoPH"
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-c2074710751so156417566b.1
        for <patches@lists.linux.dev>; Fri, 21 Aug 2026 03:49:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1787309339; x=1787914139; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=iJo7o/2ldLGTY8iHsFqVt+7Uo/Z6Cmf/028aI3xQ6RI=;
        b=ku0afoPHYwgZySlX/mZYb4JU+gGTrF5zfPXuuY0whXdJhJmI29oRugYASTbSWaHZOE
         fDtreOfoxQObwLfB0izLR+0A8gvomAwr6WRq0wUtPVNKhiyLxKxgn6et0S2dvDZLLApJ
         nev93uS/ZA2h+RhWrevCUxHu0wgbOZM/ekC66zcqnhETCtqo9DsCfJDUYszgXUUGm+9V
         YLdmjT4LJgLa0ZQ1VW9JJ83VLLiaMEdTLH6sNtrqFedsf8f3AVYuNJsdq+GISnOGitYJ
         9sYU032ZTTzNqE24F2ct890Jkm9Tyc+A7npjgp61lN2M9CA6eJE2a5boaQSzaSNiEPro
         sctw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787309339; x=1787914139;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=iJo7o/2ldLGTY8iHsFqVt+7Uo/Z6Cmf/028aI3xQ6RI=;
        b=hMelwTmYY5DfM6/fMcE3WunGJv3vRS6tlYGGBxgxL+4muIl75KHen7pifvbvR3DFVI
         Kib/6b00Hu1zEcjXWrQjZNoAOAKkraP7eP9NRTrdmJ+mUx+oBeOwgFQEhpP8M2qoaMMe
         NJUXcRVTPLtT/KFILhhHTfqD5r6OUF7C4j1UdKdGFb/RLTSpsSrT0O6GoCByKhNA0Ou8
         8LUT0uyEkWROdRHwPN0yeoRQkricgyyk59wXLvietNS8z1E4lqgvsA+UzUp8djkEh2mF
         nF0KQfyCuJZm0xklyQtJEySQNU8tf5AzN+SCykY7nNDXd+LLdkCUeloTWyFggZLif9IN
         GPng==
X-Gm-Message-State: AFuF++k6934keXuqtgg+T33tZDQ2mVcxyT/nmUKD2R8ee2BxRQQAfOkP
	w6DXkcs/am3GqUdMvkBaykoiwbaPM2GhIVWGqGLoSHukove+oTwBc9I=
X-Gm-Gg: AR+sD10mrCnvQ4xvDlzpTSdyEOkx1h49mGe/gHdcP2CskgiTA0xdijTESFNC7Lr7CYV
	0JGLzFlrJMiVR4G/NfaSUkx2d4w5fbrOLzTefUZCqQtN6vDyin8M0NuYG0aOEiNsTypMCHDsqQa
	QdzxI0Ln59bB7TO9dJr3rlQnrphVTmClZp0nbFC8SaFTE65mjvnEeKiC38LSHq69JkLS+EV+KXR
	sHvD4bSozpxAAUcz4QaOA6weVTYEkVRR2k/cy5WkLJna4fOyt8AAcJbyo6FViHI6VlFXVCY3vRY
	5cahw5D+SdpIhspL3IL1Y5RAhBYjQMVHP+IRW2eDef6gc5BUnw/v09dANDxIFdCzRWrJR3z4AuD
	K3qNcbslc9pwTNKUJbSVEYbwPy8qE+wFmNZeOIi9d5vSJeBnr5ZB40+z5UXNhPClvmAqp+zYpNt
	g1z3uDnAgaSv2cMo0dlPhUsK7+gEPMl15+Iz4kn0nnybgR/lBqZkeFMFKV2It3QEutK5apRbnT+
	+WhkZcMfKXaEgEiq0aFJ/F9+6DUmWaw9hH4fnhG+Q==
X-Received: by 2002:a17:906:c146:b0:c16:66dc:3ab7 with SMTP id a640c23a62f3a-c246a6164fdmr568353966b.10.1787309338929;
        Fri, 21 Aug 2026 03:48:58 -0700 (PDT)
Received: from [192.168.1.3] (p5b2ac6d4.dip0.t-ipconnect.de. [91.42.198.212])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c2459198d59sm379213066b.35.2026.08.21.03.48.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Aug 2026 03:48:58 -0700 (PDT)
Message-ID: <48181d0c-bbb4-435b-b910-93f5d0b18cf4@googlemail.com>
Date: Fri, 21 Aug 2026 12:48:57 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.1 000/303] 6.1.184-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260820145253.200766705@linuxfoundation.org>
Content-Language: de-DE
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260820145253.200766705@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 20.08.2026 um 16:52 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.1.184 release.
> There are 303 patches in this series, all will be posted as a response
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
