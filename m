Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21C4826ACB
	for <patches@lists.linux.dev>; Wed,  9 Apr 2025 23:13:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744240416; cv=none; b=jHnnoIG2OXswcfe61GAvpMwZ/jGn/e1LTS570nSaK1eHmsQo+ipVNtfLItY1CPLhNbVkDmwo9InxXU269eNX2VxVSvT3l0MkkWvc9jNcEt1dGaTVZv8is09PGdMAzU2QiZJnwN/yjceXq+SNkFU464fnAGzORxzs8prhxtg8H/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744240416; c=relaxed/simple;
	bh=gwk9OrycqkKVdhpm87tobsijpdGkykWCrAcP3S79gRU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kHUKDfv4TBkDrdOlnousKMteizWNTeBY77pCnbRg482JGVxmHyIEfYpwW2RF7RkIpHAOjfwac451DpDT0yCbtgH3wZ3M4FAJ19qdhqwUqQNKwSt5/gTz14i/SpzSDUkAu3XLFw/GGmUCtwHMXK0AFg+jF+0uOQymEgkzaAxgPnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=J5PsbWWS; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="J5PsbWWS"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-43cf58eea0fso1161205e9.0
        for <patches@lists.linux.dev>; Wed, 09 Apr 2025 16:13:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1744240413; x=1744845213; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JW74z6cHpNu60kU9OE2aazhTFE9YDkFOWDJkNNru92Q=;
        b=J5PsbWWSUvTtkxCpvqc8BmV1wzzgJtN1AX2a9wQiTY/HdZSRcCKLDXFqOhPfw+Wavx
         6iYgxJ+T6bdbGWckMOYsto8JrAry+1UNdXunY5yKlzMVyJ1tCOLUrmOLuax2SS6Yz6+m
         CjXX+rH+yEUqaFrJHrzqR+rYdbVymA6xrVAsMGDv0Fe2eXvy/NmSJVFD1VEoao0QcE3X
         HKN/iEecvENbULelaSQUjEaPTHEMkvxSHwKrNFJT2BlyfBxGGZyvd07lU8Mjto79egl6
         gSVejWfcyftYF1oRTXQOAOrKFy4xU4zI04WawmCaF5/3DQTq4KcqCPlP/IBTZ1iyO/L+
         JuSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744240413; x=1744845213;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JW74z6cHpNu60kU9OE2aazhTFE9YDkFOWDJkNNru92Q=;
        b=tUy/rXyg6GSawlZfC7sNPGpD9b7iIRy7t+Aj418GB3KMCelruouRYcr+zCedsF7fPq
         StgdXIFQaCqkvIZKjww8E5emw0cvNpB1jHEDaLCPLOzsXPI9rdMIbSPw2LQ3WAbFITE1
         6mKZj/4gBMJ36KnGeHk0iXDXXlaxXmP0ryWYg2Lkiv/GbVvl8iq/z2s28djkx9U/rfAB
         r66HH8GGU81sTPRKHmd2ylLI00968GRW7VvP2UecNa3y+Gt1+QQhgdcZ4pqUljnOcT+x
         QPJDHnFnq+0vZC5WLA09TDxB8NOQeSCZciIQl9NR8gquNBrPvaNCMa4RGCGAr/kNhB9Y
         5k6g==
X-Gm-Message-State: AOJu0YwZHanaGIR5lGs0o8/TKcLkrArGQZEMtYkSFkdClBEKPaoshuRT
	zbUBvNKLjdm/0DOajmvavFcLIUPEUxfrMXqnTxzaieh50bP02FQ=
X-Gm-Gg: ASbGncvlG7OuMwZCIZpob5Dh3fCePjdbFjPu8kl2WUSQttxASXOuZX6Vm9H1w4d4tSs
	1dmnruVEQqFybEg503u0oeyftiNVeanEBm28JYdSa5IGvHGiRfIp18fyQHm7a7II8YG6plOo/wU
	06WIsdkQ3lKYxwqPfAry4xmA1+3YcrXW6YQeSWHM9Ncy+jWhJPK31qwWgTrXYnBvj9ONCAMCe79
	M6fTaRlq5VW8cPGF4Sppj1iVZEkKkhUdGIHW/Br7ycipUeGBPC9Pv04HaijV6ZD8oTFD50btM16
	cHgW/fxuhRxuIThDVukGIYOVY6Wq0d507vYs+3qn0pyO9bdUbSaAkap9ouv8AMEt5V3kaG7tT9C
	CThTpXe1F/PpwXJi9S67ol8MTc5E=
X-Google-Smtp-Source: AGHT+IECp8SZn0v3pCPADW9jULXwJGPBFrCS/fIc9I+DpPyMRE88HI4kqXtXrTxOosCltUSPuXtrYQ==
X-Received: by 2002:a05:6000:2586:b0:391:39fb:59c8 with SMTP id ffacd0b85a97d-39d8f4744a3mr335672f8f.25.1744240413129;
        Wed, 09 Apr 2025 16:13:33 -0700 (PDT)
Received: from [192.168.1.3] (p5b057855.dip0.t-ipconnect.de. [91.5.120.85])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43f23572ce4sm31128885e9.30.2025.04.09.16.13.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Apr 2025 16:13:31 -0700 (PDT)
Message-ID: <5e8d7416-3666-4a2b-bdc9-8cbc2a761b8a@googlemail.com>
Date: Thu, 10 Apr 2025 01:13:30 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.14 000/726] 6.14.2-rc4 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250409115934.968141886@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250409115934.968141886@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 09.04.2025 um 14:03 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.14.2 release.
> There are 726 patches in this series, all will be posted as a response
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
