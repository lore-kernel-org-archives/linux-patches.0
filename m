Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1EEA38656B
	for <patches@lists.linux.dev>; Tue, 14 Apr 2026 21:39:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776202763; cv=none; b=KGvlMvqr/d77dgXzcbDsVNDLr9A2Yqaskx2u2NLhMIOIBqLPx8qAzwe/9tiMmNUpeY8L3H1088AcVhDUB0rvbz03Fo1OKZjVIPavZZJJ0HMgeZJjkIfvfdAiw2tX584Z61r4qfOLJl3PevOmI0bcu/bvBOaPjrIwvpePUoqEYGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776202763; c=relaxed/simple;
	bh=4DmhPHk1STnR3Zxdsne2/8cUaFJP8gPptbtYBh2R7ww=;
	h=Date:From:To:CC:Subject:In-Reply-To:Message-ID:MIME-Version:
	 Content-Type; b=GdBTrrJTEX1F6X0fPJFrBirgSOxUQEeUNwfU2XLHz6zDQtxgqMooCueVVM7GFq1InwxaYbFn1oPsI4NWVr1uwVTrke+4dhFcodjsdEhYAy2L9sAzSRrU3Nox28ksuk/UmjAa8nXP0Ab8fIXr5Z7IfE+EMXVXNZa+tEuhVZU0Mhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=e6zBLE7O; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="e6zBLE7O"
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-43cfd832155so4181408f8f.1
        for <patches@lists.linux.dev>; Tue, 14 Apr 2026 14:39:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776202760; x=1776807560; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:in-reply-to
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=4DmhPHk1STnR3Zxdsne2/8cUaFJP8gPptbtYBh2R7ww=;
        b=e6zBLE7OdcVXy6GTFyJeaM1SS7NvgT+2Fqv36vowkLuC/RBv/YNCD+S0wuoShczykD
         uacki8fbd+8ykETGeUqbshBpPUN1674KyB42cP5Fn78KMGjoN+45CustGn/IHKMmP/vu
         pOdRR+9DVL2HjoqjqRhyXYr8gt8FEUjqDj7a1faTRFJODiF5I5mczuIN9//xhyKuT97I
         bx4YOeqv05rPNXo+nJC1NX/9O3yJqBQCPJWQb6hCGihZoR9HODrF/EhNN3RiuX5+s8Km
         qR/ywgQgKl1WmB7jVmnfFIqZSqzMPp5o+JNAgibli3isNrCgLQ5We2gNwOLeFlS7MXEt
         si3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776202760; x=1776807560;
        h=content-transfer-encoding:mime-version:message-id:in-reply-to
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4DmhPHk1STnR3Zxdsne2/8cUaFJP8gPptbtYBh2R7ww=;
        b=TvfY31cJTjQLK+3Gmnp8QqNxTfaVHbz0h7CO+/laE7XW/EN9zD6x1lpcgvGLCfZZxV
         QOQXWWEZqm9zH4osiYBvwHwm8Ku6kJ1Cpow1LgFIM9iPeR/c94iZPSPMJqvD8L6QrL9N
         XFNw3TQn3pvbNWIMA1sYa3LQchLF9qh5Y6/rjV8xus4cOpV0Lu1N5HL+U6JpMUeah0sy
         pxageV6dZXXQyXwVVnjhlO2rmyW1W4EMr7QwHW+x8V6CisuPJEfmEQqPtZQKDX3QQfx2
         kuxdnnlnH6tE6lWqrSSX60/SjP4BfptkEHcePTHVJzFGsI8nM+j5c7qP+SDsY7ywfA0/
         ZVTg==
X-Forwarded-Encrypted: i=1; AFNElJ/dOrMcwIgrUHznHYCIybeZx26CqojsX92+pAJfadb4fqm5b5EX0O5CLk0SmOX4soIkCB92eu+u@lists.linux.dev
X-Gm-Message-State: AOJu0YwvVR2vkGdS+skC14g5jRiz467Wi40pMHoQlSTOquCl0kIRd0mH
	McjkTxS6Z83iHEnPZ2xK4+2rXoKCg63Yu6UGmABuXHbNmwqoCBUIrxuL
X-Gm-Gg: AeBDietfgJs4bx2nt4wYGOtn4Kvb3ZkxOo/XUPx0ooHnlPXUlY0S6ozEbObAAwuW2Oy
	m3X5x/W13weeTqHZOccqV4z5IBSLMpIpI+FiAgWjFxS70At2YemofdcGG2GW02U5AyXzicztEsD
	YN84BrlFsDtpysYtzYY+jUfV1fsjfFpCLhPKXQ5s1YRCYEfLdryK6QBJ/ui2CnBabAwbBsofvFD
	B0Jn8DDr21FYag+mFFlXpZUM76497aDEQXTw9MV4tpfhek+iZcrRWQ7WZ16chTJ3UYCPuL+7wDQ
	39SQQOwQcswmiEz4jP+IZ6iELtXjRNv285W1rHZIJ71dTmBAmg0lnC37oOMe+FbB4CpPaqNWcTM
	E3Hi/7xpq2BA6uC9Z0gu7h3GE5f5xASV6kJAkIylQizHOfuzLgOugMqWAurEoIXh7ICmPtTfpw3
	3cZWsf0+NI6xZeTSvjvhtPoigm2CN62mEuvFHBjOTe
X-Received: by 2002:a05:6000:605:b0:43d:7c4e:1ff6 with SMTP id ffacd0b85a97d-43d7c4e20b8mr11296567f8f.1.1776202760086;
        Tue, 14 Apr 2026 14:39:20 -0700 (PDT)
Received: from ehlo.thunderbird.net ([86.1.69.5])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43d63de2a53sm42970687f8f.5.2026.04.14.14.39.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Apr 2026 14:39:19 -0700 (PDT)
Date: Tue, 14 Apr 2026 22:39:20 +0100
From: Josh Law <joshlaw48@gmail.com>
To: broonie@kernel.org
CC: achill@achill.org, akpm@linux-foundation.org, conor@kernel.org,
 f.fainelli@gmail.com, gregkh@linuxfoundation.org, hargar@microsoft.com,
 jonathanh@nvidia.com, linux-kernel@vger.kernel.org, linux@roeck-us.net,
 lkft-triage@lists.linaro.org, patches@kernelci.org, patches@lists.linux.dev,
 pavel@nabladev.com, rwarsow@gmx.de, shuah@kernel.org, sr@sladewatkins.com,
 stable@vger.kernel.org, sudipm.mukherjee@gmail.com,
 torvalds@linux-foundation.org
Subject: Re: [PATCH 5.10 000/491] 5.10.253-rc1 review
In-Reply-To: <9564f562-df5e-42e9-a9e0-f0e605a6e441@sirena.org.uk>
Message-ID: <5278F4C4-45D7-457B-98BF-16ABFD334B9D@gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8bit

(Compiled and tested on my qemu arm and my qemu x86 machines, no dmesg
oddities or issues that should be acknowledged)

Take my

Tested-by: Josh Law <joshlaw48@gmail.com>
