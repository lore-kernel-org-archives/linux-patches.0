Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11D94372ECD
	for <patches@lists.linux.dev>; Tue, 21 Jul 2026 17:10:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784653859; cv=none; b=tnCsmgOVvCFRlVCmYkBsLmVcMhjQ5j69VHrpf1pxAgC3TGhB4oT1dBCX/7fMz+Vi4qvGNv3wXQmWnpTEZhNzkiTXXK23D4HxycTGjTpMNu4PLKD0lEyewUrhxEXkEFaV66cSuAZcQKgoQENuAMb4QSaPrVxvvSPP0yJ+pJPiC4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784653859; c=relaxed/simple;
	bh=6eidNqkwPlgy1eyK1ErXs4WrdbSONsBgimGthP2xbn0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NH5zrvpaG4qFPdMm4lXq/3Q89WRGdHHMe/05jaCy1G6SuzcVpj7XBEu8fNgTxZeqHy0Svtf4vFZTUm7c/HnU5i38jzcdqtCLA8E9uKJDKnqa+tph2sgSSyYHLcmatGZroKuL/mqLC9Hc0zK8Xy1LkwRVjiddF5W8hBgZKBEsAY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JtwuIhAI; arc=none smtp.client-ip=209.85.222.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JtwuIhAI"
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-92ed3993c1eso506951585a.1
        for <patches@lists.linux.dev>; Tue, 21 Jul 2026 10:10:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784653857; x=1785258657; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=G2zl8WdfYsburxD4Z1OSPDQaVBCCfCCyiW3l2jHNiTw=;
        b=JtwuIhAIuXnMJM+5i3tilkM4Q/N5ansnCL4IE63ia3htsFgLAnquXso58IeyM+xleQ
         CQpNRIcLwKmwp247VpopXcsHCkUkW3GCHlGmQJ69G+rwZaH11Qas8IrTkD59XPA7QXpJ
         RFbq2LKFcZ41Ul9HYLEuUJN62l1OCw/sBQZ0N9Vn6xGkXFdSdYolBCejYc49xe5MwFeL
         WTtGYThKoU4ZWnThUUoOCJijHah+M4kjLnIjGcrrIcRxaT7sNJao7zQfMzb6OS6vGtJT
         5smBZplACZt57Ndh1oqMYNO/d/yrh4Om3+yUaIKVBuUbBPPEa/bqKvHf5uBzGu2VRAuc
         voqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784653857; x=1785258657;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=G2zl8WdfYsburxD4Z1OSPDQaVBCCfCCyiW3l2jHNiTw=;
        b=bht8Tw2w0NZLKBIQBU2+1boZ2BXo+q3MjBcqf7fE26w4uGr/wTgJncdI7l9eI5s3iQ
         qHHMqrEkfPMl8JVhhJu21ShEnqoZ1ruELVwxPIuqIGT5ScQatAmvSWnLdwFQnDP4Ygun
         ur/k+FuS/Pbeap6ExdVqPSn0TI+nbhy3MVFi4KLg0tk1e3KcGmgLa/ZGSe3GuMXj6jWS
         ZB4qVCohBsOJ0E16nzs82lc/GHUYlNK5mceDmwUdpDWLrSPQdIHeVtFodt50BWHAQXJ5
         izglW64EiqxURAVC8EVw0dmP4RC6iOk7U0Exgnr+z6jusrCTIBR/x1J3B0Qa6Mp/mD/K
         NZvA==
X-Gm-Message-State: AOJu0Yyukm5KzuO432BUW0Hx3w8C0zDlLhJ6QiWGFZZEoovg00LAazul
	lavm9p0v1MtcjrcoxWosaHINX2rHzd16SjmsBUgKcBQznlUCe69HjS+W
X-Gm-Gg: AfdE7cne/hMBCenWlfcMX/ekSMOlT+h9KNXhy5eGoKGba6smX5LlVPxeu4w0FRBiyA7
	/QUOBDIsPKWZ8d0rm3wDiY8EEzWvWnZGdC3j96WhWV3NqTsI0mbml8HeeGgTDrVa6vavm1FPSO7
	EIIJCH95Qo4lCwpXxI8S4l52bfnETblsDnl2HlXxrNRSccoRtCrEzh/Gh3OKNgMMZs5m0dQlePl
	lEulssy9xYX7IWmtHsZQ4rPfspx13veFwFtl1+6zXLGq1+BtFKSVQvW6Kei/IGifv0FIJeokeu9
	VLmBU2nhKWkPtL+Cvl/zYm7VZk0e7tRBo/IY3RovhFIw9yfNI2W/pLOP3nEn2ieGQzr1otIwHyY
	DlujiUi0TQVQMNtkRB1vYIiuVc0Vd6ZBp+FdkrnBWe6L0U4PRXlsCNbmn4i50LxWs0JQtcVCbeV
	tGDDqXVRqrhtKt5rSl8dgmrFC94xDm
X-Received: by 2002:a05:620a:3708:b0:92e:e695:d622 with SMTP id af79cd13be357-930b3ea8f77mr1959767285a.28.1784653856795;
        Tue, 21 Jul 2026 10:10:56 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-930b542bcefsm1201589685a.28.2026.07.21.10.10.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Jul 2026 10:10:55 -0700 (PDT)
Message-ID: <e24d45a1-c83e-4905-9593-abed06251c14@gmail.com>
Date: Tue, 21 Jul 2026 10:10:53 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 0000/1266] 6.6.145-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260721152441.786066624@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/21/26 08:07, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.145 release.
> There are 1266 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 23 Jul 2026 15:23:00 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.145-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Same perf build error on 6.6.145-rc1 as reported for 6.1.178-rc1:

In file included from builtin-sched.c:27:
builtin-sched.c: In function 'latency_switch_event':
builtin-sched.c:1182:34: error: 'struct perf_sample' has no member named 
'file_offset'
  1182 |                            sample->file_offset, cpu);
       |                                  ^~
util/debug.h:24:44: note: in definition of macro 'pr_warning'
    24 |         eprintf(0, verbose, pr_fmt(fmt), ##__VA_ARGS__)
       |                                            ^~~~~~~~~~~
builtin-sched.c: In function 'latency_runtime_event':
builtin-sched.c:1260:34: error: 'struct perf_sample' has no member named 
'file_offset'
  1260 |                            sample->file_offset, cpu);
       |                                  ^~
util/debug.h:24:44: note: in definition of macro 'pr_warning'
    24 |         eprintf(0, verbose, pr_fmt(fmt), ##__VA_ARGS__)
       |                                            ^~~~~~~~~~~
builtin-sched.c: In function 'map_switch_event':
builtin-sched.c:1637:34: error: 'struct perf_sample' has no member named 
'file_offset'
  1637 |                            sample->file_offset, this_cpu.cpu);
       |                                  ^~
util/debug.h:24:44: note: in definition of macro 'pr_warning'
    24 |         eprintf(0, verbose, pr_fmt(fmt), ##__VA_ARGS__)
       |                                            ^~~~~~~~~~~
make[5]: *** 
[/local/users/fainelli/buildroot/output/arm64/build/linux-custom/tools/build/Makefile.build:97: 
/local/users/fainelli/buildroot/output/arm64/build/linux-custom/tools/perf/builtin-sched.o] 
Error 1

-- 
Florian
