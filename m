Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68D2A20C005
	for <patches@lists.linux.dev>; Thu,  1 May 2025 17:59:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746122394; cv=none; b=XNz2UzmNUV0T84p8QwsumhDMMgsATbR5hyZqm+mSc/ctWD57UC3NnVrv48EwscaJ4FdP70Km1Ro01U9+uVTC1Z9NVWKyOJDun9S36QKzoEKDqX8YQquhvleUP8Obsa4zGTtMaw6WnQKZDftGaXQFYNemO3rB8nSE/YGb0FhOSX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746122394; c=relaxed/simple;
	bh=dIQUCShLwBXTXsE4l2kw65IKT1lNhQ1EI4HfKNwEE2w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ViuUMcLl55AEbQZDmBPmqxYpXe0Yn29pGlwGGZQZ+xxj0kithEsmnZRp83p7yP7YJIVNFmbieEWU4rhjkFQyXo7U5hKthGpJ9Yzdnmez2Js4us6an+DkqCxPbxvAi/DnWvx96BWqt7NUWESbbH5r6SGwCwoOGBXRhpe9zJnlNUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=iOGHY2oQ; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="iOGHY2oQ"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-43cfba466b2so9287595e9.3
        for <patches@lists.linux.dev>; Thu, 01 May 2025 10:59:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1746122391; x=1746727191; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=aHMG1aA2Sk1zdDZxkb/FxZQE43WXPupzxbeonOi1fI8=;
        b=iOGHY2oQvMsFDyGIs+xXr8AtY9hfHyd0H5LddBAp5oNOFODtNOPE8liV6TFr1ANXvg
         FtFwqnG5Tn8/YajzMV5aFLzinmgERjOFHRjSCxOIBNG6TJyhQ4Liq+Hu3WchTKBcRDuc
         JkKYqfXljPK2Dd8Q+71W5phRuwZJH9ahfQH2u2S5hv0aEQ1qnkE3998r8QxEer635ltz
         miI5BqXViwiV0rOoN8RJZH+zUQdx+Qf6TeYrQy0zAJKZgX/XxwMIl8dVnImG4hIsiFXN
         MPdwVP6IwpIJv29aZ8NBnq93GaHF+iWfpTDHtYoch7stxv/m8nQpaAaJLZr6it+mWKSK
         PAEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746122391; x=1746727191;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aHMG1aA2Sk1zdDZxkb/FxZQE43WXPupzxbeonOi1fI8=;
        b=wTlg7Z0cNkc/WwAciknLQ6niR0FuKD/wWwY3v4Wh4L4S1b8W8BZGdjtUOE6ixsSGi9
         BkAGDPxAmx7HWQtfR2cz+Dw7RHuAm6ddcfAXnEfJT2RriI5GuPd/FHB8t2mQktJfbpk0
         UuSzJcD+9BbHaxaoGy4dGMNf6q6eplaccHcMvHQT4jjmScGVFliB6maZu50jYrFPSlmW
         VZdtyxO0WQpfUXO2gTBQJzFf18xY6KWv5ugnH8pYtUO6GmU90fpv8jqjlfFs9k1CdD8M
         qc7iuB1NGkgwGWS4rq51J0OAfcAtCahtENwfdxjSx7VRxrLZfoa35SfRWdPNWmLlF3u7
         OoTQ==
X-Gm-Message-State: AOJu0Yw9NwJu2B2egHlfrG590iYSSuyjwzUoEumj87TaOz07gE4+LZTi
	MhfCkkNGwfLzt49aDB6UtniA7+jFnHigAzet84dy8h4obGfNorU=
X-Gm-Gg: ASbGnctMQE7w81OkAcrpGs2K8fIcnXqlPhwaRrJzt42mo9hF6hxRv7MoZ5+QzLGk4z2
	wdjd/PUKoU6iLMnzI8OXkKw846GK6GQaIu38IvNGXnaDfmJzMfuMpWbYYey7IPbiZqi+ZBTd3uq
	1eT7dlO1U4DNgmCgwygnVGADpOuMOAoRC4B9+sDq5Z8xFotkUQMrc044N7zjOfX60vE5bUeE1cF
	wbndEjkfTvRmkom1mETzSyu+cHWfMJP7vfg72Olf3d2u+MFOoovb7ARekqVOIh5O9qY8m3fSUx7
	hRoXtt7EfNG64YdXNTiDrINR1TCNCQeh/kxuk/sshGKMI9nK+6jycY73ut59ntpkgj3ge25Aqpt
	4G5T3HxgihCRCaTae2A==
X-Google-Smtp-Source: AGHT+IEQ7jXNXCkRAOOEYI68QrE+ebjWWr7a0UoGjImdQBADHX3NYO36ZjZwbQaapURvR9UApzsPJA==
X-Received: by 2002:a05:600c:c3c8:b0:43d:fa59:be39 with SMTP id 5b1f17b1804b1-441b2b61eefmr41419385e9.33.1746122390366;
        Thu, 01 May 2025 10:59:50 -0700 (PDT)
Received: from [192.168.1.3] (p5b2b4589.dip0.t-ipconnect.de. [91.43.69.137])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-441ae3f5949sm67754985e9.1.2025.05.01.10.59.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 May 2025 10:59:49 -0700 (PDT)
Message-ID: <a8cdbd62-c7bb-4f73-a411-fd3f05c9c569@googlemail.com>
Date: Thu, 1 May 2025 19:59:48 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.1 000/157] 6.1.136-rc2 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250501080849.930068482@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250501080849.930068482@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 01.05.2025 um 10:14 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.1.136 release.
> There are 157 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Just like rc1, rc2 builds, boots and works fine on my 2-socket Ivy Bridge Xeon E5-2697 v2 
server. No dmesg oddities or regressions found.

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
