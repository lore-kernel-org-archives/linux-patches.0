Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB6DF3ECBE3
	for <patches@lists.linux.dev>; Thu, 28 May 2026 12:56:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779972985; cv=none; b=kJFBa+7e8SqbTN4qI6oRwM940MIRGHehknxlwKfAdRN3RBuprKxI8hk2HTHXO6JvcQdBLbF5VgwOMuxpBPgBKzKmX5lEXoWMOV++aFGFaBSmrvaKOIiy6Dlnv0D0LA1uLLN4x6dolrehHYQK7et19m8qrPsnh9OFFEZj4w5/wEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779972985; c=relaxed/simple;
	bh=YfZssVGDne01dMYMgGTcgNvcudPc2T+XxFJkjcazgS0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jUUO29+kNepZcB/A5jt68WJLVzRAYI13MRtRDd9/SZnOqny28FkJ4Ar3rJXx9x6ktTV4r8ZoY45awgg/dHSSCBAdi2dFv22nMdPnDlH88oFE8M6heULRInZ3kuOu3PgHLK0Zxu1aDm/tiIk6HVSCBP9k/qeNBj9vKWAfAOKGUtU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Gc4Tzj9n; arc=none smtp.client-ip=209.85.222.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Gc4Tzj9n"
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-914db83362aso472127985a.1
        for <patches@lists.linux.dev>; Thu, 28 May 2026 05:56:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779972983; x=1780577783; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BlTiMO+AqzsfMF73zg1sUXIUWFi0uPkexNI2Y+w2IWA=;
        b=Gc4Tzj9nazPgxpfLqN+oFpnfwjcXH0wj+ZdHOTL0pi1rXwj1HOwsS1dHYqaujPDJ6v
         bcBDFLwb8BzN6ekysLXCEjFtiHyr2Necr4i2GcC/uQfCpgK+O1cZBRa4Ml9XnbO3tyN2
         Dqc596CpxXU2O2U0iHJSPwuX/s4iIwJPwsRJSQ33hCSRg5ERrvtDWqY0G4k0XHkEaliR
         v0+JTCNGnrq+tcK5kdhw3/htPzYLlTwLDVAk5APWsMiDZYH+E0ZrXTgxI7F5+AQji9DD
         wxz2r1zStK3U32qj9CIeqmGyoEWxns6qye0ceuEQpe6ZJGZN8Vsvdm4alJYVBfnIfYaT
         MEuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779972983; x=1780577783;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=BlTiMO+AqzsfMF73zg1sUXIUWFi0uPkexNI2Y+w2IWA=;
        b=SOPDo+vKmZpnMCgM4Hn7v2iUPHCMQIfmdJDlvbHQ3GGvCKkz0nqBMCaBzSRHaaNeaC
         0vpbZdFs5PAHZloAcBED8CRVZmGkSnjIP51J9X2ncjQIGTW+tHxxgJ1HLVduk0t4ZxXo
         T8k1ktcMKOZqPFMQIWbrDwO4znGPX7wHu18X5O2tBEfhf0td+etwlE5WsYtKpIU99khg
         QUVeSKT37//1SzaN+CqSFcD3zvGrDGe8Z+oGPKuKONAbS+lfTJI9IvZsF21TTonnTz/c
         bkQ+WM8qldvJDU5+OIntqmwM+Hmv8ds6dlMzVDFuhSQ0Ij7XvmMdy9fXHA+MwwrP/hPi
         C6eg==
X-Forwarded-Encrypted: i=1; AFNElJ904IPPhSNzjYaosm6QfAQpU+xQtNuvA2c7/HgIYTG7A/WskD1s9Q1S22DKjtxKlNaB7NrF5eQp@lists.linux.dev
X-Gm-Message-State: AOJu0YziG1NAGxH0X2DLU1c1T5S3ju/ZON6to7Gp3hQmuyhRNwDIqXJ3
	nWy7j/igMmr/WumuKSVrQXxbT6pPxPxP+FEPa8GrEvdrfl7fNGl5A/cp
X-Gm-Gg: Acq92OEp77qTGxfkJQnImVuXpvOdYgdqz5PC/7kGkQNFUJ98MKRNnAwcK1HTslo6AxZ
	rANwyoPo1KTGQr9RRKiNojyDxUli6PQ7FL/wE8duOggIBThJLYbeqLbBCOwbqM1qvgeyX5b+PeL
	pJglJCprnxH+xqc/qdbwf1sM2OfxmmnAQifKmP0vFlTswqOZW6vxcdusm43gy7bqaWgOEJJ0LYi
	pxF+b2A6EknhFEldelGEDvnRtz603jRxoFqNCFC4r7HORyUJFvFndUuXsCHvBYeIgEB4+xSq52h
	PFQvxBNJlrFPlfXk2LkD/mmHMRPaqQ3oUb7c8YZiABAUZ9ZYSCc9yPlH5YCM8CIdrcB2mrxedlQ
	HNfJQAT6usDsXxXNSfwESbMbd637+0Xd/AI2LLRI5rLtawXuadHQ7GYG7DOkEgyRKxlqMuFdeAh
	UoGa34sO4/r4JJksjix1fdndixZsQXuSoK9Fhb47ias9mVUvBHy91akVDcDEWOCjV4v8WxiUn1Q
	/kkCFC0BB4S2/F44md0FLb4MuGQ/A==
X-Received: by 2002:a05:620a:1b8a:b0:8cd:d688:7aef with SMTP id af79cd13be357-91521722eaamr138903585a.19.1779972982782;
        Thu, 28 May 2026 05:56:22 -0700 (PDT)
Received: from leonardoc-nb ([67.159.246.222])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-914f86e9b34sm813683585a.5.2026.05.28.05.56.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 May 2026 05:56:22 -0700 (PDT)
From: Leonardo Costa <leoreis.costa@gmail.com>
To: kwilczynski@kernel.org
Cc: leonardo.costa@toradex.com,
	achill@achill.org,
	akpm@linux-foundation.org,
	bhelgaas@google.com,
	broonie@kernel.org,
	conor@kernel.org,
	f.fainelli@gmail.com,
	francesco@dolcini.it,
	gregkh@linuxfoundation.org,
	hargar@microsoft.com,
	hongxing.zhu@nxp.com,
	jonathanh@nvidia.com,
	leoreis.costa@gmail.com,
	linux-imx@nxp.com,
	linux-kernel@vger.kernel.org,
	linux-pci@vger.kernel.org,
	linux@roeck-us.net,
	lkft-triage@lists.linaro.org,
	patches@kernelci.org,
	patches@lists.linux.dev,
	pavel@nabladev.com,
	rwarsow@gmx.de,
	ryanmatthews@fastmail.com,
	shuah@kernel.org,
	sr@sladewatkins.com,
	stable@vger.kernel.org,
	sudipm.mukherjee@gmail.com,
	torvalds@linux-foundation.org
Subject: Re: [PATCH 6.6 000/508] 6.6.141-rc1 review
Date: Thu, 28 May 2026 09:56:05 -0300
Message-ID: <20260528125605.255471-1-leoreis.costa@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260526183025.GA1285841@rocinante>
References: <20260526183025.GA1285841@rocinante>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hello Krzysztof,

> > When you have a moment, consider changes from the following series:
> > 
> >   https://git.kernel.org/pub/scm/linux/kernel/git/pci/pci.git/log/?h=sysfs
> > 
> > Test, and let us know if this fixes the problem for you.
> > 
> > I would appreciate if you could test this for us.
> 
> I realise that 6.6 is a bit of a far cry from changes against the upcoming
> 7.2 release, so you might have to massage the series/patches into sensible
> state, so to speak.
> 
> Let me know if testing is too involved, given the need to potentially
> backport a lot.  I will think of something.

I tried backporting the patches to do a test, but it turned out giving too many
errors due to the different context. Since it's not really breaking anything,
we'll leave it as it currently is.

Either way thanks a lot for clarifying this! It's good knowing the patches
where this issue was addressed.

Leonardo
