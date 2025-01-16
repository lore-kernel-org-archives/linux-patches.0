Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEB4318DF6D
	for <patches@lists.linux.dev>; Thu, 16 Jan 2025 13:59:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737035995; cv=none; b=nyBeQk8YuYhb86W2b9Knop8JLKz7WlBvxynJh7IXIZ70slbQj8O0/Y6fGlMtkK6DO0RcgkDz0YS4spoQWESopnOrDoiP25ZxcwlNdnyg23B45z8bdQg3FbH6ZRdBi4cVdOHE46DmgNa8Dli5/dMYhfM0j6yC6j6Po8aAI1162YM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737035995; c=relaxed/simple;
	bh=px5Bdgtp2OTF52R0VT2ubJv0O73DimsN43ajQoFJNZ8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kHId8+kd+tzaLdlzAqVp2hGehr9qGO733KaHVV1rWg7Ll+USr3Lq/Z23EJbA48QV1BJd+H2ulWDB4jw1+kl+Lc5NbfCN4nvGqMsfL9UqN0nfsLKTpaX3qbzDm+z67KyHomhFT/mpFwBQvUdaTswY8SsWf8IJbofBFNO2X4LjvEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=e4xW+iOL; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="e4xW+iOL"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-436341f575fso9365425e9.1
        for <patches@lists.linux.dev>; Thu, 16 Jan 2025 05:59:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1737035992; x=1737640792; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jMlvmu7FV/MvmLeJnp4tivJfwp2wZsqjEEGDvDazn7M=;
        b=e4xW+iOL7LJEbtaoo5ZxvnBtaIsnDbEvX7n58+NlcxTG83QZ8BfX1nikUnU0QERuwd
         6+Nwp2m0jxh9N3+Q7DFDG4zMBtoaHpMkAoL0G+om/QKqlhLDdF/hCg46voOKX9vGzK85
         WJdej4HgUIM52sQAFuBwivuIJk2TZYqwG2YspYam6qPJWDW/gZQjbYpyomb2sZpXg1VP
         N1Fm8nYQekeBOfXVEJVhL/Mrm9yn9VxGXHVQNJ+S6DMOd8wk84kec6OggwH2XQbhDts1
         clGF7RAYWwtSUS8paJtvfGmEYlex/m5gk/9HR718la2Btgzt+8f8K67q1iu8U9fYXNIO
         a39Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737035992; x=1737640792;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jMlvmu7FV/MvmLeJnp4tivJfwp2wZsqjEEGDvDazn7M=;
        b=hjnD6uat2LSuRdqUXhR59EX3KBWesN84LzzirHo1HCtoKMRWHFtl11tRvMR+tRV18t
         BhweAsvU1U/y/A7a3/C8iCIAg6Uc3BAjiMlEnMy5hEG0zYEZQbeJPAzHMbAkDQfdH1Bo
         k74keSTlqR9khdwYE5laTc7F5xGy6H8TrHBJjwTcQm71kdrEmkwN8e313eL/PfvD3JaK
         Q/QXpAGfjwJDzioeocWPCMUt7PQRbBJp5FTXFRRUhAIcehSglpLQDAcBl7EjsRmaey4S
         x4wzeYuPi1Zx2HLfdDSLKpbkfwxLRlNFJj7OnjqhzActuLce/s4XrmhtUV81gnFG0ndh
         ww5Q==
X-Gm-Message-State: AOJu0YxT2GbWaSFMNDhI4pFUx1r4mxoUS0XA10a3CmOe+5l91nKMWBdY
	B7vckE7Gzx1PgJVwZoZMgQQrwsQXN4JryeedGOAljFMu6xROU84=
X-Gm-Gg: ASbGncuSpCXc0ayWp5hezAP2yFgvlD6cV/skLHLDPY+cSbF9FPnS0Re38cpUd9j/DwU
	DQucLkbQ1mP7xkCrBNJQ47fkj6HrY7u1QoizIhPS/OZRdZuTyMzcrqqrS+KaJjio824i1x8WXDB
	346kub2a00Gf63lGGWajY62xV+bUmddxq6HhlDrhwiWZEOB7MtcosrqZwqmOEr7P0YQgZVbCEIa
	yXNnj4IP7yEpMuFa+OeqjeuJPEG0EBQuv2L1yP3GRGldVSqdJ7cn8Gt7Gcnf9UjTR8YN1l5r/zu
	TMlfAkTUi4B44VO/6QstjiuwWOIqCQlM
X-Google-Smtp-Source: AGHT+IFQVa7sIfMZs7UU7EftapEtYR7s0peJFt5nInyxf/thFRizsBjQuiKWN2f60y1CfSPNwOsH9w==
X-Received: by 2002:a05:600c:3ca4:b0:434:a26c:8291 with SMTP id 5b1f17b1804b1-436e26e203emr282266185e9.24.1737035991790;
        Thu, 16 Jan 2025 05:59:51 -0800 (PST)
Received: from [192.168.1.3] (p5b2acf03.dip0.t-ipconnect.de. [91.42.207.3])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-437c7499942sm60089475e9.6.2025.01.16.05.59.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Jan 2025 05:59:51 -0800 (PST)
Message-ID: <2067ef97-98e9-4321-a5b3-aa5a61abacd9@googlemail.com>
Date: Thu, 16 Jan 2025 14:59:50 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.1 00/92] 6.1.125-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250115103547.522503305@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250115103547.522503305@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 15.01.2025 um 11:36 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.1.125 release.
> There are 92 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Builds, boots and works on my 2-socket Ivy Bridge Xeon E5-2697 v2 server. No dmesg 
oddities or regressions found.

I have CONFIG_PM=Y (and many more dependent config options) in my config, so I'm not 
seeing the build failure reported by others who don't have that set.

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
