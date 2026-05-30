Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DA6522A80D
	for <patches@lists.linux.dev>; Sat, 30 May 2026 20:18:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780172315; cv=none; b=JOav9/J7AllEBDOcG8UqTQKl0XQ9ONx6afAmxQPV+6zVqCd42E3Wr5AVVPd6b2ttzbJrKIKe+XK5O3jarytZYb++RhijRlg/YtWd/i1E3Sr/Gc0HAKuZLQ7C9+vFHoqGkACSnfM3PlSY26tYCXcfixTCKJhRFr7cMb+/X7b75dU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780172315; c=relaxed/simple;
	bh=c4MdMrJlz0LtBQTvMhi7ix08vuegWMJPyFsqkFVkb0Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hT7iTb8y4qi5Iup+j6UR05aGB6QoAiXoxc15JTVK83csE7dNL6zpwjJ023ucEY1l/hZOBSWE/fiGMPsFgrY+S9HXX3CJgiP/h+z9NfkF6EUIlXwAxl4w7IfoMVmgO2eK25yZsFGD4iUmy93vmF9MANSYkCKx0lBFSgbP+PNMa48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=b81I1DZ6; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="b81I1DZ6"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4905529b933so65762805e9.0
        for <patches@lists.linux.dev>; Sat, 30 May 2026 13:18:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1780172313; x=1780777113; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=EjF7rZtP24/FVY8gGbj0C3I59Z8/71JmY+tNyNbwV3s=;
        b=b81I1DZ68FRLvUCc8PHrFGHtVBm79cP4JWPMMj3Oyvj/UW5x2UH2b4DMdyR2Fr4K0E
         qMPNE2U9utQNSWzjX57Vs927zT/8oQ65lSaDwKhmMMlJKPuWGMR4gah6lvFnnLyQxD97
         wJNRjATeV0etEwq5lc+LMBg7dmZ+/n9tAYm1w7/1dSKhPHcf9ee9tYfxSfqd9RHRoddW
         NaJYClvOAbPWAIjCo43E0PxDpKQbUWJo/JwX6JBlpSPM9MT0JAAT//Yz+MHm8X8mCUlL
         AWH9VNPTokhhIm0J7oP8q7aojErVwKPwDj7yFrsMBoL+Agsfyi/JgMg116bC6jW2rPFT
         nhEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780172313; x=1780777113;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EjF7rZtP24/FVY8gGbj0C3I59Z8/71JmY+tNyNbwV3s=;
        b=B0TOgUgGiqjwLf4WqLspZTYEZ66FwbCJgy9hA/B79XkU/RBotvvnVTpJEgIHCg7Sm6
         rX2DojwrA0kggZfOjoSySVh9vvhXQZoUrGHXjMWjV8OYZ39kuB4GCBPqCQ0Mg8cEf0tN
         RqRfVApPZZ3Nc6/lLrZTD433PLxOoKpS6fd6EFimbn5ZzMVCRKIitPWA+UlWnQyAc4nS
         b/ZrKYKqLQAN6Rnbz9Ttk4+23lSDCqp3gfnVhD9xAVb9dFL1S/Q4zluFPDGkTb9dd0po
         Dc7uPKgFfpscK/hncuiSmnqwQId8ukGsRzElaqSMmSg2vv54r5/SFT7EiMZy0bJwcUaI
         YpbQ==
X-Gm-Message-State: AOJu0YyDlSyanUiwm66d5EFUx6kNwdn614frXbXKbb/R+LbV5BSUIqMA
	0gwGPZcwd90AthjzKQ7QNigXNBSul/NqZoYCjsxokpF5SPRTfwGtdRY=
X-Gm-Gg: Acq92OHo/A1O1OGFBqdv1YiglSpcKBgKsWhGw2knkgLNOqnvn+IhyfVB+LdUjZi4voA
	9kf8gPnH2b4WV5LoUhSQ+4O5hp3H0cFdgKi5mWl+xN1Trs6FzQ1Mjaym8d6uET2U6n+Tl4dmGwK
	NHGuCAZjouxN+6hMZoZwqJoludLRK2+IiiEGoJ351VhiFF4gbWPMCMNgWAD4xMO5+RiGyOyeMrK
	hRwwPTVI5/p/WqpVUP35rhlmjMfXd/zFzXOOxYnzI1zSvUMTPt77LGfHwm5arrk3ocT0npCwvZJ
	X658dcCU1G1goC2LRHfsjinVDLPaVwotg7OjJzIPXjrziBs/Uh5BkL3HVI22FUn2F6CpKZTlnJ3
	lmPJBCi5bbOOeSJe9GKxHq70lewlKBkL/3jr76oaEr6SVi1SKMhZViDounfL8rII5at6KDktZO3
	lZyG4/x6ohZC7LMkyklgGwNAjoKB8xufCRCnR9rWF5ntWZ7vy8aO72wkroX9iAJWrzBSFneXw89
	xKsni94J5kn
X-Received: by 2002:a05:600d:644e:20b0:48a:53ea:140b with SMTP id 5b1f17b1804b1-490a296b260mr64789555e9.28.1780172312557;
        Sat, 30 May 2026 13:18:32 -0700 (PDT)
Received: from [192.168.1.3] (p5b057a22.dip0.t-ipconnect.de. [91.5.122.34])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4909ca65f54sm126842335e9.5.2026.05.30.13.18.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 30 May 2026 13:18:32 -0700 (PDT)
Message-ID: <3ff645dc-92a2-4b25-be85-88c733d004be@googlemail.com>
Date: Sat, 30 May 2026 22:18:30 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.1 000/969] 6.1.175-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260530160300.485627683@linuxfoundation.org>
Content-Language: de-DE
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 30.05.2026 um 17:52 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.1.175 release.
> There are 969 patches in this series, all will be posted as a response
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
