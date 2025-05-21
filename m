Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E8B31EB5D8
	for <patches@lists.linux.dev>; Wed, 21 May 2025 16:48:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747846110; cv=none; b=dtpNqMwKCbv7E37KgN10NAPoE/coJRpH4S33EYjanZP90JdVgNtrfQ9PAFwygiwBDi9uV6lidZE8cTKmaoghRSbSx+RmE4YblwihmT+qQumZHK0Wu/0ECvGTpBZffTkGmT0aqhu/BVUUaiR1IiYi6d++WFneeqxX/UP/UXN8ug4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747846110; c=relaxed/simple;
	bh=b7xXyi+01O5AFpi8W80L9Y1cFNIs1LdnBBXdAsf/Ba4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eLhERwHdw0zvzsulle+/W7rc+fuxIrPR4HeP5YdQcDkEf0JCXakmDEXPMpaH6LKg3/LF+PhD7WU5sB3l+OT24FzOzApFie97MXzg5/ShOqPDOUpgayP53cIplZDK+vcH2H6B6KZy591oFRci8pRB9Vhnc+IdNKpeg43eb52lheo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=QmrbzLFn; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="QmrbzLFn"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-43cfe574976so51068535e9.1
        for <patches@lists.linux.dev>; Wed, 21 May 2025 09:48:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1747846107; x=1748450907; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=R21FvzuR5H03XLkhE7ZezmCTwEQzFxDVoCgSjcClEyI=;
        b=QmrbzLFnES/JiNYB/OPpl7AyKOYz3D/0aEzj69iapMoA7Rzy1k7Izz81Bklt6jp7jF
         8Xzvs7THtT65Gtq1EZxHIJAlG/cdcPS7k7rPdvdJu+XlGfLNCDkSHaI1UkP9jFRYzw77
         9NNXCB+0BMLrFku4Kj3NEivQmDYhM6j9WO+1BqG64Ly322QeUEtSt1dqZE5tn3/ERLIZ
         hQEhCxkSDG2qSsnih+dR0P0tcWxcAvRgUqLhHR3WLDgeS2GmuzcPPph756p1JCjOvTNU
         rYjHp8DNLYm5NDm4F6nc6uhXUtET4xJgSqUOeaUyMOS75+r8eztw3ppMtf8Z9XJBUZLA
         G1rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747846107; x=1748450907;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=R21FvzuR5H03XLkhE7ZezmCTwEQzFxDVoCgSjcClEyI=;
        b=tJklv1juBxijvazhIhH0nghB4vuVdS/MgTMGYoLxUtxnBg/LFeQThRy/npr+nnzNcd
         Y7b+BwHK7Q8Crr2R2iYpLgOTJKB6yNBVjl6cX2kBN/L0uTxKTEY+8yFQcypZJOo9Y+9K
         COU6sDUrxPRZ3L1E7KBxMq0HccWmS4l20T1InLYdDB13eHUDNKbHwj7hoHsY4utKfH8P
         oddI0l4BmTFsPOsiDfqqBb+ADO2LcUjjJD4hmp+Yr10uQpJu9S4JPxUqnlSvXfgs/2i/
         rwUfwsD5/F+wCfet92kN2QX/13lyMUpad/CdCjEP92y/nace/Dhgkbl9K1+uTXrVV86V
         pL+Q==
X-Gm-Message-State: AOJu0YysHWTfh87QrCrNaVz00nv0hnTvBLdJw/JVCm6hHW+ezq3fm+m5
	3r13oWbIU29YmsxfMNNJgff+Q9WdHo15b/OREmfd4cBpxK+eqdNixtw=
X-Gm-Gg: ASbGncsf9hK0u87zMVXnse6AF+gQbQ8/gt/8btb6KJUYcMpzJ3Z+lC2vP3zzcw5kj+P
	IZX3+PRCUu7lDpfJANtNsf9EOaz/L6Uv+h8tvcMT6DMElXzsULz9RU5oZyv3u1JbDnOQ73hOgwO
	XoPT5AANMUckyOBPwj8muXp7E6PCT0USH+fBjU3Pf8SrDKEhzS/ucz22HiUhjhpDquSPh/voyHG
	t54apczcLCn+eZyH/i54zfvYzloKW22M4a4cHpAviEDtQZb1YD9oZaldDTi1KdvrMCGtcYH/k1Q
	qYFcFpG5YKAUfbmd70rggZ/g5Luvjui6KfJaI9wZ6dism2oSnshRLY8WTsFa01q0Ja6LBMmHfZS
	iASrQFVb3VB54UxLI2+FQ7b5xRmM=
X-Google-Smtp-Source: AGHT+IGIu3gbuINcDndwdP4p4mOyqy+li64ELdayYdyjK95FwdHBw8FjbzsVCoxES8ZbmatD0+A9XA==
X-Received: by 2002:a05:600c:3c85:b0:43d:fa58:81d3 with SMTP id 5b1f17b1804b1-442fd6790f4mr190944295e9.32.1747846107250;
        Wed, 21 May 2025 09:48:27 -0700 (PDT)
Received: from [192.168.1.3] (p5b2ac604.dip0.t-ipconnect.de. [91.42.198.4])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-447f1825193sm80172405e9.5.2025.05.21.09.48.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 May 2025 09:48:26 -0700 (PDT)
Message-ID: <741506d2-6447-4580-adac-962d9e45842d@googlemail.com>
Date: Wed, 21 May 2025 18:48:25 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.12 000/143] 6.12.30-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250520125810.036375422@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250520125810.036375422@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 20.05.2025 um 15:49 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.12.30 release.
> There are 143 patches in this series, all will be posted as a response
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
