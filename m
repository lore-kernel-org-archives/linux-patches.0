Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 059DC1BBBDD
	for <patches@lists.linux.dev>; Fri, 15 Nov 2024 12:43:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731674618; cv=none; b=O4x+/NKWqjumTlnBMUQOtYw/dKsenoIwh9dfzyEynQG6oUkqyggaeDXEd3ScGkWatJZUy5P3rbxpOFzpOqZqs6jRfE6nkWrnueVuWEQvrJmlZ/qolhTX/D0649XJM4t9TAg5Fvbhb5rjJLdIfjdiKnVHaZBG0U0p5A8O/fjMo/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731674618; c=relaxed/simple;
	bh=0PETfD8Gl8AoTwKr0t+EAaEZMLvWbcQI3PxMj1nls9g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EQZh1b/o2OBzkpdRahxVwVbTeEMbwUWdb5Ik/RsSH/xGsCmFfvFRv/skSIROVMjyqqjN6ZtzPioOP3CZSApNm8xZ159ngsxDV55RDTmaahPr4fW8IWLfdILBOyBGfMiEXiMQHlC0I7H4pv+ZWMCLFJyRnJKmEtvieuWx2ESn9uo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=XsZ1kvbM; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="XsZ1kvbM"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4316cce103dso18841065e9.3
        for <patches@lists.linux.dev>; Fri, 15 Nov 2024 04:43:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1731674615; x=1732279415; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lqMsKbA3dO+XdOuLGY0q9rDIGWmP/bu1+ik2oz85mMg=;
        b=XsZ1kvbMz+FfqIu89+pqeZMuHbzlKrFpJd4NPevGeYJarttbO/oMBUa2R4yq8xWx9e
         jp2FG53aJS1P7W5BtxXDvvTQcYjuqsFadE+90+EOYKs72zjmO4pbhomybjNTZOrhgdT3
         LX+w2A/eGoJnQ3NTPV4T/Y5wmIXOrJ5b/cA02bOONhxYw/G1/QO5yRnnYR2SqbcTlw2U
         aJiLd/OIOCl4Fwx5kgWhQ4XjbKKyVDL6WAboFo5005ETak6cZP11fdDW2gT+9aFk9gdT
         S2Lrlj1HNTDEq2N153ny2JHmG8mexE1Ue05Jn4YD/ClKiR+JzdIKwwbndO/i18BVJkIO
         7BgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731674615; x=1732279415;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lqMsKbA3dO+XdOuLGY0q9rDIGWmP/bu1+ik2oz85mMg=;
        b=bfAuTvTrtG6FcM3wNnLbxkEe/3t7nd8g6CKuZ9q+uRD5hpad5xtrKrlqluBPFMAGuq
         U9WFTMbffp0FMbXVKYTSsjWhKAYb1uMpMqPz+ccodI00V/oitjyZei+TvWHCnLpj4+Hr
         qNlrOK+uNmN+yvhEI0tULOK5SCg3bPT2wx964MmwJuqKt58+W73YRByqg3pNGdvtMIqn
         7HHn5wsrK56SjLPtm96xMq1wqjV+Rrl8ullkxBvvhH28fKzb7pAU0QjKt0Egxm5eYSpN
         IlixfWHWHTTwA1htNQL/6mGURqPaGiWDPFqFuRltCwunpwG4Gc6WitZJgUBA0nMVzsSX
         S4xw==
X-Gm-Message-State: AOJu0YywapqQxufZtWaVBcTSBlaAffDefjXQyn+gUFf8aDDWUHfKTopD
	1co/5qoOOtOOICWbyKw+v9LbLQw0hFbzWGfG48B8qGsIeqh4NbY=
X-Google-Smtp-Source: AGHT+IGjlp03I3khXnqVs9FPoaf2f8iNImWPpfJ7NhaswXhDzLo+Yga//Gzs/rvT23hsD3zoJemriA==
X-Received: by 2002:a05:600c:1387:b0:42c:b508:750e with SMTP id 5b1f17b1804b1-432df742662mr23592635e9.11.1731674615048;
        Fri, 15 Nov 2024 04:43:35 -0800 (PST)
Received: from [192.168.1.3] (p5b05792c.dip0.t-ipconnect.de. [91.5.121.44])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-432da27fe73sm56168855e9.20.2024.11.15.04.43.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Nov 2024 04:43:33 -0800 (PST)
Message-ID: <45105775-41e5-4600-8197-642a31ae8e17@googlemail.com>
Date: Fri, 15 Nov 2024 13:43:31 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.1 00/39] 6.1.118-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20241115063722.599985562@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20241115063722.599985562@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 15.11.2024 um 07:38 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.1.118 release.
> There are 39 patches in this series, all will be posted as a response
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
