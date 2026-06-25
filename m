Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B570347DD
	for <patches@lists.linux.dev>; Thu, 25 Jun 2026 17:12:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782407522; cv=none; b=BRbk/uIAPMI6R0X9Ny0OomXRZ+KaXpB9oH6KUDQ5Kjqbf7/uuhDDr6AFXeheBgwPgBSpofwTSoKAX3+8ec5e09cwHorcFDd7rIjIBuoaXQW3M4WGBZDr7efTVfa+U30fMh/9yKh8z1SsiEbFYXk/YGHU7Kj5L4xSghmXMmztmWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782407522; c=relaxed/simple;
	bh=GYQPxRYeOZe9xA3Z7jlOLVuS8C1pKrNXXpS5JJeJb0k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Mr95F4CaaQY2fe0KczP4+JQBLlEH0i/rFcBNrEV9sZ1N2GqpzhbmfV3H7AYl/4fzq6gzLNl9jE+nIZMrh4/v/wWvARJhe+4UWuF/mvxX9uDa45ibMuYtJUn7D2oXl5Jycx/upETmhA42pTtIrZfaCttq4wa1n8okm9Bdw2Q9hEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=ABRXfJB/; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="ABRXfJB/"
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-46e4764ca48so558317f8f.0
        for <patches@lists.linux.dev>; Thu, 25 Jun 2026 10:12:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1782407520; x=1783012320; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=U/nrtkiDBwccYRRPEcbTsqsJxJusPJzF4noA53Uf2LA=;
        b=ABRXfJB/vOnRyzIj4tqypronnkpM9ovH0X2OUsQ0t3xXvLWHJ0soQQfy2WKubqX5qy
         e4cpGI5dK04lzg/flGzcH99zNpXXlnuSouaUb0brXxIXgyv84PPC0493X/gftVzYQbwD
         lSnktSUQ5oifgv8CJMqifNYwJjq8t35oc58WcIW8ynNnTAOAEquHXf3BfZWvbfe4MxBk
         IZvISG7Sxj5csKCZYbmmvZn43zQwKH1gagqEhT6EvVPR3qQ24A+E7TzIky0aDilLVwDN
         g85oqXlZrnUrXdLTWdeA7r/0V4qN9Aj5DiQQ7frw4sijdLb6JmH2bLben+a5iEw6j4zv
         Q8CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782407520; x=1783012320;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=U/nrtkiDBwccYRRPEcbTsqsJxJusPJzF4noA53Uf2LA=;
        b=otudnjf7uOQ5M+EvEKPt5/bS69NnyDO9KEWsr2zo2cSkTVZzNjUpm24CwnrYIHbi3U
         L6rlFq0gTrl8UW/rcchw3PQw6ujvlMxPtDCjVDYGVPOAuohRdBC9npaD42S4atWReuC3
         p2Hnfs9uvbVVHWO0jwK6MUAeugh/fii1yBWCbeVYQhgnTqVO8t7SFk4yC1WOQl/vtnmb
         027VyXO22WnIaRmT8lsKufByplSclPkzvVWHYgKFYkIIW1arL8a+mVFTxp2ErLi64xVo
         15lgjRj0Mitv0schjGZ+MEgIsheIAPOyd5o9KIHiZrN+Hrtlna/hhRcc3y+N6pJZ8vH4
         V3OQ==
X-Gm-Message-State: AOJu0Yzt1d7OI8QBPiPs/fdCxXKx1YwaVPWFf377BKiInrl9fE9b3XbX
	hw8Yv8/WQnl4Zm6yCiKjfmD9CWdQ4IJfz/AYuHK9CpjSMPGOEdtfo5A=
X-Gm-Gg: AfdE7ckNNBcOpfvScZ6kW13EyjljlpA9p0hp2yQXEjnQAvfIxzl5xPZ0zFCii3QFGqU
	rTFQNfKBciRv9ZA2CEYY7JM4kmWHBJzzudq4e/NyCatRYF6Jv7UR3oNvBredRJXCnRTFTLVEYHF
	FdJmidW4ePoB5budzrTzGiF4l04O6bfzHz4M91NiPG2viotHEZGHVBLIEiQja1rXLMjyMr6mXHG
	WP/oPxwYh48r/PE4+soE5XmWn++4kC0yPsRsGlnwiLBstrRePNCfdUpF+QJ3h5GG0DUFAmAJ0v2
	SvYB4HnS/iKgm7lJZe/S8c24BnIpoLyZRLNdXB5wHUC06+OVWwU42ctSW3Dwi/0No16ZWXv40RR
	emPvKeVIz7mTMls9xGFX6E78HGmWyqZ4kwlBn/RGYggYqTJOKQcw46nNol3zoJyA2haYiH9sPvy
	AuMrP2ar0s0XaBhfwtnD4oIcGn4TifDpzUrI2NLWbkhREi+8KQBpr7Fd9R8ZZsuMAs
X-Received: by 2002:a5d:5e81:0:b0:468:4f81:5aa4 with SMTP id ffacd0b85a97d-46dc026de2bmr5435368f8f.10.1782407519694;
        Thu, 25 Jun 2026 10:11:59 -0700 (PDT)
Received: from [192.168.1.3] (p5b0572d8.dip0.t-ipconnect.de. [91.5.114.216])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-46c221d93eesm16930278f8f.20.2026.06.25.10.11.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Jun 2026 10:11:59 -0700 (PDT)
Message-ID: <5cd52e45-cd66-4cd1-8f32-22e36702c0e8@googlemail.com>
Date: Thu, 25 Jun 2026 19:11:56 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.18 00/60] 6.18.37-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260625125645.554579168@linuxfoundation.org>
Content-Language: de-DE
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260625125645.554579168@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 25.06.2026 um 15:02 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.18.37 release.
> There are 60 patches in this series, all will be posted as a response
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
