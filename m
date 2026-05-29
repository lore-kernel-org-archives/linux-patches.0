Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA7A55477E
	for <patches@lists.linux.dev>; Fri, 29 May 2026 11:44:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780055081; cv=none; b=uJIi+jPAGIMZ+SHZEAlCkpdnGRUs50/hAtpRv6TSlRPnWk/kDnGospRa4/czJOIWI5QZOC8NsebeC6K8wEcqOuVOrJWRIBmUgiMNI9Bk1Dg+LXtZiwj9RledJvehJ6yc9z46WgiuDR+6D1fKzIxWEW9vTOAJCShnYNj48SoOkB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780055081; c=relaxed/simple;
	bh=L6WJzOOd+SO3INSrnI66lsTAn255xrDW7+Mg/xlSO/Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Z2ZvrD2vFGup7zohiemjza9c2QyqKRjqFy7uPhrE066dsOFs0UzKQyd+odot+6nMNY7ujpVLv9ZUXRXRd1o6phDSUAFtsbhDGu3Ihy3S4SwQcN+RGYM3wYdckyhTEOWTWU97aVCSotcdhp0Uyc48Q1aI3VfBi38kzzUNfBtOwyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=aOSxlzLU; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="aOSxlzLU"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-48fde648a71so91903775e9.0
        for <patches@lists.linux.dev>; Fri, 29 May 2026 04:44:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1780055078; x=1780659878; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=g+W9+aXEUWxY1aJU6VduC3yrqFtqunb/fOMUbFnaV74=;
        b=aOSxlzLUHOb2zN3Mc0o2b5ugZ8SGxGlWzGyQd/MgiINGuWLUZhFD85EdofeDwfdGXX
         a++tcmJD9HCPf8dT0eQAE3vyvtdgNdK6ICBXWL0O8pjY03HnSDBhkI/oKlBXv8YeXI+L
         h04mlC3rm6i4sJ9o2cgDvOez7yPTrNtNb/YdcGMsKvSWzwNP8f4K7kHzIe0bmBufHFLF
         DNVe/LplggTkvgSDZYwgR0B5XsBooeBefPeZ5fR3DgMBqhuGRxMwbF17nqd7O8Jt2DxQ
         xK3ibZ1OHcM2h2Gysqb1FNWBKkm9jXOPdnHr74gG/rcdYSAex9C2/2HUDfprAqCvypdJ
         Sjhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780055078; x=1780659878;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=g+W9+aXEUWxY1aJU6VduC3yrqFtqunb/fOMUbFnaV74=;
        b=XOC42WkR+d3aIoVVY+ksZNEFJveHCZqcvK4AFCRgf5/ql4b3/puSZl3k+qVGN97AMe
         C2oD0px2cWcmzZLak76P6ULySP2/9GuPhL3eIEnLbjnn3u/ci4siLiwoh06fTA5bOJCb
         P/5P9c7qz7BXmLY180rOEsIVZKPymtJJiUpEuDCf6oWrHeeBjGvlayTyFchddQTDqRdk
         7OlYTZHivNZLD7yvLvkLY5L4TCwQ0zSpRImBjo4sHj82Pnv40kWOk2mIyTHggcwE9z/6
         NhpY7VEfLWcXhSS02LSAxNG/z2reuzKNI55dVicmRB/CDA/zrlEyZi+Hp8lIt8pQ5Au8
         dDAQ==
X-Gm-Message-State: AOJu0YzZfPnmKKVzAYgohsm9VyDB39Xw7bM2GMfHT+JlOzDD95I6kjaJ
	HH+cA/fUQEoFgkfwZvxV1KdldawavE+XTB5xcR0/j5scR17ni4mxpoA=
X-Gm-Gg: Acq92OED0n/nzOHEh+TiJQuxJ6KXVUdSG00qcnMNLvMjrjVbFy/NJMs+aGjowDO/Le+
	vz+/ILLf16b7QMMK9OYL2je7uKVU49HR43yRJ0xLjYvM1FXH6NjkPrleZap0jiG7Rbro6S38yQ7
	plEOsIu2ravDnb9qQALturYlAlRT64X3mIlSZuKHFlDwPCuULwCm5XYot3vvul+dO+Gjntqd/D4
	6he6HXkFRlRZuZa5lssSlGGcYuKVM4cg9cP+uKUtzRSM1R3oTN/61MA7+H3XCHrAPLlgRHzoVc0
	E8+QV7DpOhMOx0AHecOaAiKieuj+N2fONKH2glpUJvR9Ow0A7y95x9S9TfHkiz3WSFz7c2Ii9Aw
	bibdGk/iKaum+LocWwJXE2NYPjfklgMACxr2zMQcLYrhzdkDW+WNtnS+xo72qERBwdYJTutxh4/
	6JFDC1NFO5qfTs6N1V3ulhqI6rb5YvqQK+oESQYFUZ8hkyvcFCNQVr+JdfjVTf5RlrFCYJmpgRq
	ZeQJX/xg7iphg==
X-Received: by 2002:a05:600c:468a:b0:48a:79d8:a8d6 with SMTP id 5b1f17b1804b1-4909c6120e8mr37414255e9.7.1780055077942;
        Fri, 29 May 2026 04:44:37 -0700 (PDT)
Received: from [192.168.1.3] (p5b2b4ac5.dip0.t-ipconnect.de. [91.43.74.197])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4909cabfd6esm40885355e9.15.2026.05.29.04.44.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 May 2026 04:44:37 -0700 (PDT)
Message-ID: <67352312-d0e5-413d-86f2-b668058ca7b5@googlemail.com>
Date: Fri, 29 May 2026 13:44:36 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.18 000/377] 6.18.34-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260528194638.371537336@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 28.05.2026 um 21:43 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.18.34 release.
> There are 377 patches in this series, all will be posted as a response
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
