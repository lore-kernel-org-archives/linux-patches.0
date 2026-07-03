Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED08D3B8920
	for <patches@lists.linux.dev>; Fri,  3 Jul 2026 14:03:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783087425; cv=none; b=M5xbSO5Cv5rGXU5R6S372mFLrb4qlNxLlEMY79+7lZE/X6krLX3yM61Lyx13Ajw/crWkS+EIVGjHrW7L17eiODW/buGQOR+26wfY/1RwND07uk43fDNLnSya+u1087R5+5KJdtRwD50N6Ogj3f+mb1KorVTLyleW6n0GAjw5MLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783087425; c=relaxed/simple;
	bh=xnzH+vuckVgYEMUW/aaupycIFd7DntCShzqjz5PWgvs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iq2rGVqnOgE2jn6mlcQEm8KuAKAtQhRCrU9KVYCIafpDDcVfKjZkObU4Hv9UKcb2SjvrL5pIwYBYamvnIJqit/fqcYMKcxlABraQeoocdhI8bzdAgrWpidWCPiaCTV95wL980uIq+mgs2cesLieagGvZ7lJChIfJOMlRqQXDDy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=oVjL8w3p; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="oVjL8w3p"
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-461edb387ddso692853f8f.3
        for <patches@lists.linux.dev>; Fri, 03 Jul 2026 07:03:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1783087422; x=1783692222; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=bCpo2PK0VLzQh0dhhWPe7XdS+pSwNhWFcM7edGtLuS8=;
        b=oVjL8w3pTf8jaPUE5gl0zxNVajpN3vK6APs82Svv1epi/2o48kUAOGTkZd35jDpkpn
         jBRtDpoaDAEArry8uGBDT3E5vb0Im1++YgjUbeYq1NOCIxL12lA46putmUnuy04eVuCj
         esh6KqvMKsHquo4HPZuwRyQbAk66th+IOi78Pvdeguj10iH+7hEq/ObKT9cxKTXXPqve
         Ljg1XtdZI7KDF1o1IvLa9s7nn/ccsJWejKJq+GfOjLXOFY3e7HvnEkKI05smBbwke1PH
         nfT+39Qz4WkQoG+Kl8R1eO5eXMebrb7eqa8PRzQcAFzKN+p54ha/J0XrMiMvMC5YDZWP
         Pozg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783087422; x=1783692222;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=bCpo2PK0VLzQh0dhhWPe7XdS+pSwNhWFcM7edGtLuS8=;
        b=CH/6JqqD9yos4JBoGkrjBGncMpGCrw2x76D1PnlAKQ7XUnnFQTofLk4OcVlun/m9a3
         Txjwp4fzO/WA/okD2JyOyUPdX66xcwHJDCgdPQNZKgowmf3yZh7nZFx01zEhKAnwO0HB
         aR+w6O+Sk/XmiudJRkLb1RSCiSFDW9p+jx0YdaT7xF128MI4XR12yRG24TJjMkLza+TH
         z6TJrNJUyCJpYbYjOkX4uUYEA5bKru2YiVblh5lWQz1mDZO//wCmvza4LCbaMk7rPJhi
         VF8ILSPaF85I8SkzJNvs5qYYoltJQDwyjVKkZYeaIs0sfUQLSkrljPTO6jIEjoK3sOtd
         fm1A==
X-Gm-Message-State: AOJu0Yyk44wH1/eXGCdTRiFtM3LegMVdOd+YvRe6LlefLN3ZVYyk99ff
	ZhlMvgw/rNcEsxZA7ot61k4JPZVs9wht/z40pIEWvJ0JYHZ7Ra68wTs=
X-Gm-Gg: AfdE7cke3CtGH24W7qgj5CJjVHWWrAj0UQnIQzY8uAwBJvSoH9iiLBbZyl2eBlj0zMs
	VtOkTUU5xhW71XKLghAV6ltqpvaft8KBW5X3sW1L+9IfkGpaYRxpRc671o2r2CQsMYFHTq/W+jB
	cJ9Aw9fuh9aPIJOVQvHkE03arEUdjltFmOutczJJt5zTN/k7E6lwVYRhr13iM3kniMHzKSHSOKe
	rUulEUyIwwEF7p3SEPdt8NB149YNepDr+3sZFNlyHOmeoAmJEO++AuEu6qkZbkPUiXZa8wMaZRj
	06+RMXS9cAXRGWf8xB1txo75Nh3PJEe01RBgt0DVQ9MGxr7DcB6mv8WBBbhIGEWidi2zDtBwlb4
	DjCun2y7dyV1pnhXfVug40Y5obbHcmH8bOGzQTQDSASdFBcEBv+4Q5YXluaS5LuwpS2ExVGcoMi
	sC9QZ+eB897P500Z3mr5R42vPZ0wuXemVdpmayRTgK+rDe0TMnRw5p7ewh7kq793Q=
X-Received: by 2002:a5d:448e:0:b0:473:f4c3:4d51 with SMTP id ffacd0b85a97d-477b16c934cmr11380382f8f.43.1783087422162;
        Fri, 03 Jul 2026 07:03:42 -0700 (PDT)
Received: from [192.168.1.3] (p5b2b474a.dip0.t-ipconnect.de. [91.43.71.74])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-477db8a4a15sm18054654f8f.14.2026.07.03.07.03.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Jul 2026 07:03:41 -0700 (PDT)
Message-ID: <fb64edaa-bd6d-42ea-83c0-61e0de7e90b4@googlemail.com>
Date: Fri, 3 Jul 2026 16:03:40 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 7.1 000/121] 7.1.3-rc2 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260703072822.817328079@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260703072822.817328079@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 03.07.2026 um 09:35 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 7.1.3 release.
> There are 121 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Just like rc1, rc2 builds, boots and works fine on my 2-socket Ivy Bridge Xeon E5-2697 v2 server. No dmesg oddities or 
regressions found.

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
