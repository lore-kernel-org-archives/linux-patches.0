Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39A3C26CE32
	for <patches@lists.linux.dev>; Wed, 18 Feb 2026 01:51:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771379482; cv=none; b=LtIvYIPkbNSbqzv/Ev7DoRkE+pk/OPKXme+Kl6xZUTmRbsJX1Cklp6QyxGLyetjbLLESj4wITBhiCSM4l21e+faauPU6LtNDZLTUDQqQEv8I5h72+3d8sFhsvhFu4ElrjpHNlG+uHEPO7NgFlxbLPvOSaxfnzKbpch5Cvczy2kQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771379482; c=relaxed/simple;
	bh=s53FtDi4yfrfGvaH9gABy/957FDT/Fvee6Ceokd4Yyk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=C2LDo/BpTYx5UPt5tkTzFXAZX28A4u57AFgMCCUC74+iYOqIBsKiQiTMXB7CvJvs34P3C0K1AVW4LMP5+g2Ct0n9Cgi3Uc1frm54t6ftXFE/cCCkSEbM+Dt4wgqXCm3sGwCwBe3v0Xy45xOxhJs6qlWomC0U6boY+rCM/bDtus4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=mpd+1epv; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="mpd+1epv"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-48371119eacso45179825e9.2
        for <patches@lists.linux.dev>; Tue, 17 Feb 2026 17:51:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1771379479; x=1771984279; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=76qt1H1of2fUIBeck0ZIskjBGEz7CrevFA9+VCD8yGA=;
        b=mpd+1epviCon/wsL/FEsj4NgzOBacxAgxYudrvlbkGaxdyRGhWlwZ9Zeg70Kau515C
         tYMvMQZbGYAtrM0tXfs8BlN+nhnU2mCEDAtkWI0AxP8L5UvaDSCWpVQ1R6sgUWJmWZQc
         tiTt7bHnul7pfary7cgX7sX1g+CbczFbWq0b49f+AO8Brukv7VT9CV/0b5sDvrmFyk+6
         PAc+xoODMrmIIfzmGpAOyaCfwXDJbnFnX5w7Wa1USQKG8n9KbF/5Kn+uZOlYp9uvJGL/
         RzIzqayhrTZENdQtUb6s0j64EMdgxiiNV6jN8UoZ3ohG1p1xsquSnZDm9TmJnv+/6LHy
         rKAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771379479; x=1771984279;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=76qt1H1of2fUIBeck0ZIskjBGEz7CrevFA9+VCD8yGA=;
        b=lvKJ89xoV+KQRKmOizaUbJmfHEu0sRBQze34U0sxc47G0Kieo2Y8MT26RWyMcGmQJP
         zlO5EQTt2PQivjfh2OLT2H47Dp8jppmFy+S1SIgOTT5xMFNr7GWRb6Tkzvw1IPnQw4zo
         GmYeFSg+QVQ2+mMAu3LSnjL9aDxfLT8OSJwjnarA/Z4W8gHCAT+bgXWOtbaFSVQiiNXa
         y99W5JAgWmchurXS0rxIgETEm96MXroPsxeRD59LuJ66/jEu5sfgJFXaPcWlXVgpULY/
         x7cp3WVWz6E8TA1D2kDdxGCo1GIVU/83Z4lxPdJrw83f5/E2OK00etbfdV1cp6MWr5xD
         lMHg==
X-Gm-Message-State: AOJu0YzdQTQWCi1jsPV4woHSUUmsbe+x8bYXy/rKEIpDny8zEPtk7/W5
	cyW0Pueq3pjTCApYcLoidBAtxt8ptx6sNsjfSILbz8FNsrDigEAXvvacijZb
X-Gm-Gg: AZuq6aLtoW++ksNSvpgHoz0ej+MD+UeqRZbXeoM0NrclJ/aTCkl9yH7unXBQe7UdQDW
	6i1wZxhyPq3e62o1QO/5wY3ufLLnjY+zj6pDgHotVG1EgRKtolFpQYLXJq1mtV0GWBm6Tng77vZ
	1SiWQwDN9OdY2v/DFwxec1usTYyqa3nzRzgGL0ky2g2+oGG9GC2uwXhq2aL9ATOHIY0kiY22eWe
	PaEFf1ypwMj8GM98UKAvwD2te3hoQcHshw+dBpo6CM3m3viYmGxgqlMyum2lJCVedJ5ONG4ZmS2
	cq4vU+VSer2TSO7qEqDf3eM9P/tCQqnG5Lmgn4W6y0dGhCOvTDfsBlr05THNQzMNkJx+eeaFjMR
	LfodHg5Y6fyqdpyUK9XtBfaoPRy8uY+jbtX5UaLJOfk80e8/Sh6DIqBryboJFfvCJDMmSge74SM
	e7VgHPzOWirDcBGniMIu/dMhDTkmQ6o8tPP1efo3dUyGff/q1YR8ML6SVTG8iQbAfMuEWbeZyja
	Cs=
X-Received: by 2002:a05:600c:3542:b0:477:7bca:8b34 with SMTP id 5b1f17b1804b1-48398a65ed8mr5894585e9.6.1771379479239;
        Tue, 17 Feb 2026 17:51:19 -0800 (PST)
Received: from [192.168.1.3] (p5b2b44be.dip0.t-ipconnect.de. [91.43.68.190])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4835d994670sm437860715e9.4.2026.02.17.17.51.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Feb 2026 17:51:18 -0800 (PST)
Message-ID: <95d75bcd-1238-4cee-b323-ada31ba2e6d1@googlemail.com>
Date: Wed, 18 Feb 2026 02:51:18 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.6 00/39] 6.6.127-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260217200004.221651386@linuxfoundation.org>
Content-Language: de-DE
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260217200004.221651386@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 17.02.2026 um 21:30 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.6.127 release.
> There are 39 patches in this series, all will be posted as a response
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
