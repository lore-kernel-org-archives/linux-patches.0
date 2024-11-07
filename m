Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85AFA212164
	for <patches@lists.linux.dev>; Thu,  7 Nov 2024 14:26:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730989602; cv=none; b=Rd/QHSzM0EvdKLwJ0NcUbrBtQ6WmLQk+9ybi4A4iGABobJtt0Ae8lviDuK60GztrPJXL+4BX+EfahcnzAGlA8u8LQpEGPkfAN0ApLVIfB0+KlxsZw05RpnSQr12dBqeiBRHK8ZX/jH1nnGk1aTf05czi+wIQuvb0n/hUT8gyPfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730989602; c=relaxed/simple;
	bh=IZ1L6Ihm8Joep60ZOkXArh7N57MsF6DTK72afzXGdrw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=L4o+QB2T9mghoBi2TUj5up+Zu/kRCYTyXWWq9/gXvWBRAmZGB5SIQGJnV+69RmijtuRkiwcU+0fR1mr9V2fHs4x4+rRqLeHjzll6ICMmaoDJnyG3WghfZXTp02j/c1tUUGIcykp7I3otZtPGgiKQ1pPpTNt8VUuXMj1yyj33bPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=OrZl8qf6; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="OrZl8qf6"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-43158625112so9118005e9.3
        for <patches@lists.linux.dev>; Thu, 07 Nov 2024 06:26:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1730989598; x=1731594398; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4lWe+8OTr1x391V84LUEUDWwUDsOdkE6GAj381Q8PLc=;
        b=OrZl8qf6HFaf6jR25aJk6OR9cQ1OXs9MMFtrm2JleakTgbnoBHpd8Wl/Zh4Ivuupp4
         61wwM4PN5fctuhKQXpQ/VhOLr17tzRGmceNEjwSFmaTqmiDwCnoyYMJa24StdP4nvBFh
         gvXjnRoiRgMPoew1xK2G6vVxNcJh9WCinAVrC34NyuQaA3LbdxgDo3Xl7FqXmmYFhZOh
         zX5k4Ke/trQAwuLzFGIjPLlN7jhk/ApPbZqmnNt/BEzYNLHJtubN1KVhTa7sCJZlxNy5
         4l2PQunb/adHSyUeH6LS7eCuzllzD+YF2fgKqg7ESqtyR7leh3BmpzV0RciQj/yOtoc3
         DdWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730989598; x=1731594398;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4lWe+8OTr1x391V84LUEUDWwUDsOdkE6GAj381Q8PLc=;
        b=X9kKlWqXmMmQyHXZ5Wge9ycgeSxWaOEtO4sg69dX0AClfVrYJBrL8MF7bHfGMhX53c
         sbDpENkKW1OszUhm+U5f/YtMc4JEWCrXzGC4fK6dFxBN68A+yaM9zOOV1oeILevfsf1O
         CTpXFmKhfq4v0JuD837SJ99ENVoEBYMnKBnGMTWu2PJuR1cV8cR+fk+TNYBx5MJdEU7q
         8zMyJ0XojgPd+GOsmcCvlcOy2beYvJvi+rVW3ELkZFftm114cUJEcKwTuVpejNsWL3YV
         n7Rruq8CwAuqEgdB8tMrT25ip/Qr+6ku7Kg5x0YyGUvVZ21zCuA5n6lK36lKv5wf0TB2
         IZDA==
X-Gm-Message-State: AOJu0YxEJwYyX7SZMiL6pA+ke6bRg3NdCI5d6f6wYEVq6NIL8cgcigL3
	N7ZgFJHTf+GnxMMPwIT0bfX2WmP2oUakHcBkzrMZtgEctdDIhZk=
X-Google-Smtp-Source: AGHT+IHL0wi7WKTvPc5hxP5ofUXYUbtQb+bUpSZkX57u5JK3fnO3kXSjXOKKaPT73hDp1BFuoTcl6w==
X-Received: by 2002:a05:600c:1d09:b0:431:5f3b:6ae4 with SMTP id 5b1f17b1804b1-43283255a5bmr214848015e9.17.1730989597555;
        Thu, 07 Nov 2024 06:26:37 -0800 (PST)
Received: from [192.168.1.3] (p5b2ac486.dip0.t-ipconnect.de. [91.42.196.134])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-432b05c2161sm26038635e9.31.2024.11.07.06.26.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Nov 2024 06:26:36 -0800 (PST)
Message-ID: <6f515d2c-80dd-4868-893f-194dd8e2963f@googlemail.com>
Date: Thu, 7 Nov 2024 15:26:35 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.11 000/249] 6.11.7-rc2 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hagar@microsoft.com, broonie@kernel.org
References: <20241107064547.006019150@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20241107064547.006019150@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 07.11.2024 um 07:47 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.11.7 release.
> There are 249 patches in this series, all will be posted as a response
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
