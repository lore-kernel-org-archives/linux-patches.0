Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72C3F304BA2
	for <patches@lists.linux.dev>; Mon,  8 Sep 2025 12:55:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757336119; cv=none; b=HORRj/LEacfIesZY967FSSrYNjkmbiRr8oq+fKDe5iKgJS2tNlpU630GVPMDXMbg5wZLHxuhcGzdGcyVTKafecM/IwKLwH0OuxQsqiNx5hkR0o26gLH8j+H5wsqf+EPd0zNfLLqtm0ZiokQ8L99nTha0jhb1U+yt/2uIJLc11iI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757336119; c=relaxed/simple;
	bh=MAcek040G/5x9LOSDJ+31zeQSYRjenT45JicrjCIKWo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fNE6vZ60gJzbSP0OOxJMINPWPvyRWcAGcuGz63BQ1EhsRFroprz2H5/BVuQ3el3z7L7pJXqaakP/KIjj+KeMdN3QWcjKOVO+kxhunlfru2T0u3tju/m2+7BIkKuLAmfP54uh+c2fBdGOJK57hbJc+ga2cSswOsTEC9/bJyihMlc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=lEafQJgH; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="lEafQJgH"
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-3d1bf79d7acso2601075f8f.0
        for <patches@lists.linux.dev>; Mon, 08 Sep 2025 05:55:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1757336115; x=1757940915; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LyW+2yoEnntkZHje1Z8lDdANIZzachCy6cNhZUPnZvw=;
        b=lEafQJgHc+UmQ9GKz9oNHeyhHsaOdKY2bug5abBVAlv4btzvrilSfe2tgpMa7UZbvU
         mJ8gGuwTf6dkCsCvTViwy7+Mw1m8Wm5QhYG1wEYQFWeHisVXQnKEJn12WMhe3a1ALrDk
         K+V6ZSBJ9ZdDDqrObcSpnIwlB4j0vpw02Xx4L1dTdkq3WIrMOnXVMQWgk3geu1VyxIHI
         I+VcI2/41Bd/PjFtIKUnN7FmynQYxqlvKvsNNdsZ0LSopLeeKzWfU6WHRx4cNbTxbBgK
         mt3mK80zw/DFYcpeCTH7y2HZ3hJ6cwiERgKxwFq/94lNn9pS/A2X0skxrqKdl9FlD1Ft
         P0zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757336115; x=1757940915;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LyW+2yoEnntkZHje1Z8lDdANIZzachCy6cNhZUPnZvw=;
        b=OGhFlFXhYrm1xr8p24PNizpd7l27KA92djM89mspsOYvuqw07SWQCwNu4AQeog/QKU
         9BoMjbbhd2jDAC9TciRuUQshA39J1YuR0ylUnePwU8F5az/4Vy1A2pE53wjHkAIfuSR4
         YJ8xt/aFcSYS/f6n8LANmFNzJvxRLwe9g5shWwVaBk/sCry52gO2KINpH8umTt7q3JXG
         t1JpfRZ3FVo7BrDSQtQVM4BDO7pDgLp39+pD/6p8T9NvYIukkzRCAY3AQ1ij7h7YMUJl
         PqH+uKzYRH0GWDCDYhh89C+pINuSG0BVtQifzPu6I1H0wUD5FSA3l+yXEERGXhSpE6IO
         PboA==
X-Gm-Message-State: AOJu0YxwXhEglXzotpsdFRPnMI5MolD0drI1Vn7jkL7WE17RJQoU+iGa
	DESut3jiz9k0wsA22yYAZffBvTHcE+igZLsCEr116YtqfUFwpyCYHyM=
X-Gm-Gg: ASbGncsJdaxTO2DwJvHV42pKF3jbGxRMlKkIIortqpFHffA5m15vDTXAx/9LViTI9qd
	malLTR6B1xM8LttDcE6cCgU2RxjGVRq8NV23K13TFxvPmsQ4bysdAxWhlUnnMMakMzSHwPQI+aq
	1jQn06exXLCC92RvogeH3tsYWsnIKm3dtb3eezi4mmZD7XsrIEajzSqo4osbYs4igmbAuIU6H0j
	SuQ3UqtiMQr2AdXfLPVctE6ktArMKSjenU4+SucT+Ryk1n0pom2S6YNqfFS5rMgKzO8CBKBqEtR
	QwPo9TCGHRnS6XE4OuLZGKbK08kPlw3TZ9ZgEzx6iFZiXGRcT/TdDu6fIAIZnn0qj1BfndW8gDr
	avE9ERyH+su7308JXmidnKh0r0HRzM/9Ilx3BBmYyWfJi4ZjvE8Lpm0Y1fNYb68C4PvwvxZP6tw
	MQsxz/rwidyA==
X-Google-Smtp-Source: AGHT+IHw612VntHLG6+SHw45Tkejmg5TARGhZc01Yst5I4D1XaNFWSX+I377HjdCB5+HUQsWwtquHg==
X-Received: by 2002:adf:8b9b:0:b0:3e6:fc80:edec with SMTP id ffacd0b85a97d-3e6fc80f155mr4033188f8f.6.1757336114388;
        Mon, 08 Sep 2025 05:55:14 -0700 (PDT)
Received: from [192.168.1.3] (p5b2ac262.dip0.t-ipconnect.de. [91.42.194.98])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3e2f6af9791sm13622647f8f.26.2025.09.08.05.55.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Sep 2025 05:55:12 -0700 (PDT)
Message-ID: <a3f6afd6-c9ad-4f0a-b18d-99a4ed3c6f57@googlemail.com>
Date: Mon, 8 Sep 2025 14:55:11 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.12 000/175] 6.12.46-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org
References: <20250907195614.892725141@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250907195614.892725141@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 07.09.2025 um 21:56 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.12.46 release.
> There are 175 patches in this series, all will be posted as a response
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
