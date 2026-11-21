Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.49
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795225893;
	b=iRcu6UnlKhyf1P6AbfSQOiMPgGg1NNv8vKb/2rGrSH0ZYiqShPGk8d/OgUx24GAhyDDz
	 jVcaOD/yVzmaM594lsZ08r22cbvc45eRho/ehyRCSgxCQuOU8DyoGCOa7XrjG7rrLqP39
	 ncfdPqJXKGGFz/TQfs7nJ/JOxFcAOpYGt+ct2MxB6r0GPID4cUNCdIKRP5zFu4WS8K94/
	 WFIBv1Lv0/Ya15QU/Q5gGAEiJ3S7AU9kiQxTBtsvEPCWu2YkvJT+jeD1VU8TPSnKv125o
	 heX4FN8B95K3ZpHj+rxnuCnk1nonf35O1B9kSC1YcUuTOuhX6EchmTjsbQ4Bjm8QLHw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795225893;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:Content-Language:To:Cc:References:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=ZhsI3lhwD+t6nMHv4Tk5Gvew3vT8WrKD/K7/YEVJPaw=;
	b=OKACAszR/5L9+7qJdJvPBGfPGDZAF0xbDEhYr0b47WjjqJC7PGhylkbTxOiCNBTEoiMp
	 NW60PJ6TS03E20CQpISgm0+KNNXCtEbKjMVqTPxnK4lq0qqwEpb3V5ekrdKgf3AAFltuq
	 BR8rh55jX0V/DTyDAnvMll5oPALNoFtw42uubnMUAo+Ps94OpCVaoAhM5xo1UzvwgzKMu
	 Wrg0uT7ePwlMTOURNagbLtrdr+SNW/n26cHI4vJmRBhnP5U6tMKJtUCFti6Zk2VdsdRpM
	 WB3GbIULq8kVSHLf8ayozb+KByBCDdnkXoxNlXGdNh5GRG01vRhpQe+WiGWpCuG2ScA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=googlemail.com;
	spf=pass smtp.mailfrom=googlemail.com;
	dkim=pass header.d=googlemail.com header.i=@googlemail.com header.a=rsa-sha256 header.s=20260707 header.b=ZAgqdXG0;
	arc=none smtp.remote-ip=209.85.128.49
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFA48606A681
	for <patches@lists.linux.dev>; Sat, 21 Nov 2026 01:51:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AFA48606A681
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.a=rsa-sha256 header.s=20260707 header.b=ZAgqdXG0
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4a3517554f7so15095785e9.2
        for <patches@lists.linux.dev>; Fri, 20 Nov 2026 17:51:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20260707; t=1795225891; x=1795830691; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=ZhsI3lhwD+t6nMHv4Tk5Gvew3vT8WrKD/K7/YEVJPaw=;
        b=ZAgqdXG0Po0lI9XA3GdevaXfbxkN+vwZoUmz+AMKtzBhsJAWatBNTYYx2Wbce6T8nW
         jzUosOc3TgfMB5kbSfjALu/9sVYuJh44UPq8nxwKCIXzNAdUAYJfumU76tB4Cr/BYQXL
         o8ca8qb/hT0cG34FkqRW2ITT9k0vGIyrG8bVjkUxFYjhyHwA/dN2z1EHXgMtHAVDV81Y
         FagupWd5F9W9fTQYgIQTtQcxyaIHzHah/u2GHANFhLkzFaeWKJqYjb993En5sBbZeTtB
         l8nMVStEmbeLGCmT01v2tas8PHHGCu9GBkrDv1Ngl2tDOJ277eO9fLASoIRR7ElR+1Fv
         8TVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795225891; x=1795830691;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ZhsI3lhwD+t6nMHv4Tk5Gvew3vT8WrKD/K7/YEVJPaw=;
        b=Lxsu9rVp1c8txvntkpy09TdLxoy0jdCQusmbw7Jyp1oOU07t7py4kwZ1z7EuS+R7PD
         GI7yUpDF7Md6RbmDxcu6LBxghcaCcI1wd6asJTzsAjHac6L6mQ1itqQ60vuQEF5NJIam
         VTCLuL08znJD16vXm4md6/6KFTtcyAiCbtBQUAUPyGENuXGen2eDa7Ov1JpNdpnost8C
         Nv4W8G49g/MsTnBxEl6gPcVefLT6+yiWy+15289AFc4KTrJMhvSzPMDDUOwkdPlVY2MS
         rAGHttfZFKHrKEX71df0BknmaZs63UDm7Ei5du684Hse49eDQUCqWSOma4jlkI+7SAwT
         P8Bw==
X-Gm-Message-State: APuU4Z9GaxgnFnF+aNhdbYGom/wv+3e5mYRM5S/3Nb49MstVtQrlSV+f
	+d/cngfY7aygrtTrybNWeso+gPbLka+mmDbrYF9gAwZRFlvt5uXSIVQ=
X-Gm-Gg: AYBFou22MNaihbA8HoTq+eTNZ4gWznLRLG287F0tYgTHPRgpRIgpHhwCwLtp5eDJIMV
	dGbQSDA8beSk3ShSdzKzFjIVE5VsPhMwRI61vXOpjGjqM8qE4I3wqzJUOpn34b55fxvkn1nUGJq
	ziZdm4zhlwDcy3Qbd31RQ6X9qyvxqB/YIjZ0EAZLkSTAq00Jkw+8bTQhxCCQZMJMCPhg9MZMZUy
	xvca2ObjToIghBIc+Vf2qHFAPhcMuH4t+ssXC8Ww/DyL4TZG/qsLyDu//tt/WfG5zC1nwIcqRiG
	wEWoaOtozuq2XsUiWnEwmB+8QkjNKRy+KfSsVJVutpCgxnnWyg3m76TkgCBuwUpxK9gwtWBC1qX
	MZKbv5z2le9kEB8ruu7Hhi5TEoP2NynPmeQRAls4mhH7xKvzC6jXayg0aomkMeZTvWdb+0yvDQl
	HWRp74DvlICPm1SKH3GMdxKTL2p4c+eANvKru9EcVG4infbQYMYThJOuTeTgNTYbSd9bKoe1CZx
	XW4oryWfcQcIp4w6vdxKAj46QZHGXBOY/BaljrKPIuilKth1hfh8R7vu/A+bXW7vGF3znQ2ToLt
	ql7upQAkW1DZf2afJo4FUk8uAWuusMo4zmON8+zrb8OlpmMM0Ewy6+BTJrCRP7+rQznoi0KqWGR
	YzB4=
X-Received: by 2002:a05:600c:a51:b0:4bb:5f43:23bb with SMTP id 5b1f17b1804b1-4bb88828173mr107576685e9.33.1795225890849;
        Fri, 20 Nov 2026 17:51:30 -0800 (PST)
Received: from [192.168.1.3] (p5b2b4923.dip0.t-ipconnect.de. [91.43.73.35])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb85399d52sm150309475e9.6.2026.11.20.17.51.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Nov 2026 17:51:30 -0800 (PST)
Message-ID: <4f3c5405-fde4-43af-9624-6a28041e673c@googlemail.com>
Date: Sat, 21 Nov 2026 02:51:29 +0100
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.1 0000/2812] 6.1.193-rc2 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20261120055200.707545519@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20261120055200.707545519@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 20.11.2026 um 06:57 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.1.193 release.
> There are 2812 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Builds, boots and works on my 2-socket Ivy Bridge Xeon E5-2697v2 server. No dmesg oddities or regressions found.

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
