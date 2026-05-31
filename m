Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EEE026ACC
	for <patches@lists.linux.dev>; Sun, 31 May 2026 12:04:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780229097; cv=none; b=n18871YW/OZX+zXzbykA9KE882sjGdjzMXGudoaXMGluagf5ZJQeAfo3xudlD/1HV37FtzPbVLuSggFcmpA62s3ESBuZ4WsY5VoZQ6xEjApD8RPJvMo6UWWveh6G63/2E5DT20LXHrKp/gcQ0mD4QldN9IrtG+V+SyKS47/q/vk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780229097; c=relaxed/simple;
	bh=NONLKoto7eRwTUPCeYEECkrzXOAMDm5bu+8PZe/7nls=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=RTsvp3x8ZiKspU00vJmlmyUbrPLbuP9GHnOpbMFEsHcoTl5ez34p044mcIDxkMfIaUA8D5Uzclm98s3b4DtfGeVlwOdl0DzBw/9+neMqcshnBZVEgBqqWwkyNF5NqkRs9SYamAi+NbdSp6REaHb/Pe5aJ7qjSsr8tfmBqdS/NJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=F30AFzcI; arc=none smtp.client-ip=209.85.222.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="F30AFzcI"
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-914c5898245so673632385a.1
        for <patches@lists.linux.dev>; Sun, 31 May 2026 05:04:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780229095; x=1780833895; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:mime-version:user-agent:date
         :message-id:from:references:cc:to:subject:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QPje15x//JjtJNNtyyJtV4KyOBwO7VPG1InhgHR/odw=;
        b=F30AFzcIhjG5e59ozLvdcW6UjkdDWSfZXQYJUWaKlv3tL++cmsTw7Az4fmyP3Y3JgP
         GpnR+qEJJaezHFV/CYR+X9Jc/hx28FedPTQmN30906s2uWhuZtPB/gjTSlQ/K1Ir1iiD
         lMb2oJPNzpa7xNaxTbAUPdqArjuDzi5N5xQqZvTiYQ4U0juMM6HqOosiKDKn42G9JPD4
         4uCUPscydJYeX1AXx7kLk6ILSc6DPP6ui4je7fE49u3/rP2o2ST0cbwhUtI5ulsbKsJG
         WFX7XEeWdIDHRtv82YbUU6YksgPoE1UmwoJ+3tDk/N6ChP1dikZq51690zHkL+shf+fM
         tfMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780229095; x=1780833895;
        h=content-transfer-encoding:in-reply-to:mime-version:user-agent:date
         :message-id:from:references:cc:to:subject:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QPje15x//JjtJNNtyyJtV4KyOBwO7VPG1InhgHR/odw=;
        b=dj0+twomfnVYY/7EfSbzxA97IdtgFGC0wxFotKSbrjc4SHPjvGfQDpPEws3fC6nH1B
         brRpwsuZJIDMneHXh5LjY/eYWqfnpHBvviLSKH7nnAkY+78YteFexyR1XxnPXsOH6jjo
         tcMj6PWLF+jLgbglAjDAODG2uxmlbO4Z6YI70gTeVwXQ/m56RhddX7AnVzPkEPd5UMHR
         3zuVxSTop4Mk/ecbphXbL4QTsYn5ZQc2fm7NmqMoftGoGodMqOFGheZHlecu8n6Bhnzr
         p5DiaDpIIQEGbIktjmvjnxnTjLpPtWxB8+Q8fCeRXW2I4yOG3l4owq7yclLH56aQHM6q
         br4w==
X-Gm-Message-State: AOJu0Yw69F28zAOSvGI4t60nLUPeEC9QAByukksRngMouQ9FLjc/6FVX
	CjCa9exfuVDS774Ffa+YLc86fKCUu1NfgPP9t/DpjFsYV02xXWVaCIY=
X-Gm-Gg: Acq92OEiCNvBTEeM3EcW5Qkgh8lkeDqvMNebQT5yeCWyw4xJeH51U2BBlORovfcVj2G
	7DmA0R+CzBi6zoK3qvbHfIrXYHtLiv0GXhG52dJufjznZFWUC8vKDrV1M3q58Oq8rw8QCSD3CNa
	jCfbnzf17Ur4PvsY9esmjXqGi2UgNmJTel8pgyYKMxgVu5wC1XQcuprfjV/1+qb6ajV7YqQDCZi
	sWc9aMbVzKKbFJ9nmOhWJELuEHko5JOezwm9iiolMrqPxhhM32LgU1ZapZ9/joVjmae33z37WZw
	xMtXB2AAkSBdsnt2GeFNbdLwQ2iizYnXMsSbLntLlfCvhnJMoZ4GIncNqEenrOn09ONtw2gS7K4
	nlf9Mo/J9tSKyPJaT32jhqL9llhxrBKJD5x0efFKrD+JWXl6jYlvPbmQj+f9XXQb/nnvppBSFdw
	/fIzpXuKzfn8AY26DMOiz7P/NdRFcp3NR+cDUXJ0Dtotvl0igbuccdkBRAD0qOzRTIzWiNUYho
X-Received: by 2002:a05:620a:2990:b0:915:4685:f9b1 with SMTP id af79cd13be357-9154685fc7fmr729735985a.9.1780229094997;
        Sun, 31 May 2026 05:04:54 -0700 (PDT)
Received: from [120.7.1.23] (135-23-94-154.cpe.pppoe.ca. [135.23.94.154])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-915326016c2sm723500485a.25.2026.05.31.05.04.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 31 May 2026 05:04:54 -0700 (PDT)
Subject: Re: [PATCH 5.10 000/589] 5.10.258-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260530160224.570625122@linuxfoundation.org>
From: Woody Suwalski <terraluna977@gmail.com>
Message-ID: <4a908311-9cdb-e8c1-2e6c-bd846cf475a5@gmail.com>
Date: Sun, 31 May 2026 08:05:05 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:128.0) Gecko/20100101
 Firefox/128.0 SeaMonkey/2.53.23
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.258 release.
> There are 589 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
>
Built OK on i386, installed on a 32-bit device, no issues noticed

Tested-by: Woody Suwalski <terraluna977@gmail.com>

