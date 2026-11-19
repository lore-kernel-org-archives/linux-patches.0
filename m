Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=188.68.63.162
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795071813;
	b=tkcuIJ5BvXTK3IWn/AEj/ZrpU+DF7ncyV/D+LztJXE1A5mEsHoTW3CGimHDnRumRE54H
	 dnpK5Y6gPpBaSLNLrIaEF+4f1CzbabXzm5NNQdVWW5ZPP4jMs13XQnx4NJK/TJfdieuHZ
	 E8LfH4JB8b8LyFsQspbwcx5zQLdepO/mXropnU8WaaS930yZckjzIHrERujVB3ARKFDIE
	 CZfkZSb5hyBVyp0Kjgb+XTXBmhUKb4dqmVomPI21mN2hk7FJV4Y1IHygv1OdOlgGxSiYG
	 fC1Te665L/lJQvcGXca2FscJdjpy9fhBgNa0hzVhdp5u1r8HaQdLX47pwTJnibaGrSw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795071813;
	h=DMARC-Filter:Received:DKIM-Signature:Received:X-Virus-Scanned:
	 X-Spam-Flag:X-Spam-Score:X-Spam-Level:X-Spam-Status:Received:Received:
	 Received-SPF:Message-ID:Date:MIME-Version:User-Agent:Subject:From:To:
	 Cc:References:Content-Language:Autocrypt:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-PPP-Message-ID:X-Rspamd-Server:
	 X-Rspamd-Queue-Id:X-NC-CID;
	bh=kUwurNAWFBNw7Xos/aAL3DjIWxFA2aWQQWml2aVzjkA=;
	b=S19s+r9aKd1SzYIkDQJDOQcAmPfV5PxHOW8mt1eFt9xzW2N9CcdAbS7wa+8H2mb8CsVr
	 xiwWfTRR3pYtXJsc2RuGxjkyflSHlm6c2vS2S1pkfM9K6gUUV1hhaAVSayvGZ3NU3P6hs
	 y91vyWQA5LQi4g5Pk/ebXFIOMEUPzKOHp2D4ahH4TkzCuyYv9DRtDwzURHEjnhRzAbP3c
	 qUiwZc85a5zamIdfc2JF5LCiYH60NCwJZgKPieGHXRBK7cIYYseisD3b/L9l9L+7bV5w1
	 +AmC6M93Re7eN7sUVXNSoAVJDKnJOLVAy/B1tPFd0aePF/0EiVPsEsKdV+60Z388C8w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=leemhuis.info;
	spf=pass smtp.mailfrom=leemhuis.info;
	dkim=pass header.d=leemhuis.info header.i=@leemhuis.info header.a=rsa-sha256 header.s=key2 header.b=KoeGT5Gj;
	arc=none smtp.remote-ip=188.68.63.162
Received: from relay.yourmailgateway.de (relay.yourmailgateway.de [188.68.63.162])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FF31606A325
	for <patches@lists.linux.dev>; Thu, 19 Nov 2026 07:03:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9FF31606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=leemhuis.info
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=leemhuis.info
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=leemhuis.info header.i=@leemhuis.info header.a=rsa-sha256 header.s=key2 header.b=KoeGT5Gj
Received: from mors-relay-8201.netcup.net (localhost [127.0.0.1])
	by mors-relay-8201.netcup.net (Postfix) with ESMTPS id 4jVTvj0YnCz4H0G;
	Thu, 19 Nov 2026 08:03:29 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=leemhuis.info;
	s=key2; t=1795071809;
	bh=eIgwLa5G9KYM99HgC9/TCyaTQawJENUhIM35E8ds0Bs=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
	b=KoeGT5GjvEEf8Vp8oVZX6IiyTtkNQYpWonUGwF9mI82AWwdMGNEnAL0l7QAHHzeXa
	 /31ZqKuAEGfdPtYsRKlBi+Jgs3rBrM1BswnCwqVKaxHRu4Xf5DcoS145aeUmbyfThn
	 L4eXVuiHFEM3REfSHnalDIJ3vmvorW3vxRGdcy6lEPwKqowCuoDv05TsNSYAFJf8SE
	 RdT3a3Dbk0fmeH/ZyMitsyOyRecrzflgMMiS4U99iale1QCJcNjQO+MlQMfQBTqQno
	 uapaCHJuOF6xtNC1wRF2QqPSA+FnW9HDcuio+hJmq3QXJHPxiHjTBLX3tP/R55h9hg
	 cHYU4aRcIoqtw==
Received: from policy01-mors.netcup.net (unknown [46.38.225.35])
	by mors-relay-8201.netcup.net (Postfix) with ESMTPS id 4jVTvh6wjrz4GTZ;
	Thu, 19 Nov 2026 08:03:28 +0100 (CET)
X-Virus-Scanned: Debian amavisd-new at policy01-mors.netcup.net
X-Spam-Flag: NO
X-Spam-Score: -2.899
X-Spam-Level: 
Received: from mxe9fb.netcup.net (unknown [10.243.12.53])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by policy01-mors.netcup.net (Postfix) with ESMTPS id 4jVTvf2DYnz8v4p;
	Thu, 19 Nov 2026 08:03:26 +0100 (CET)
Received: from [IPV6:2a02:8108:8984:1d00:a0cf:1912:4be:477f] (unknown [IPv6:2a02:8108:8984:1d00:a0cf:1912:4be:477f])
	by mxe9fb.netcup.net (Postfix) with ESMTPSA id B89E15F9FD;
	Thu, 19 Nov 2026 08:03:15 +0100 (CET)
Authentication-Results: mxe9fb;
        spf=pass (sender IP is 2a02:8108:8984:1d00:a0cf:1912:4be:477f) smtp.mailfrom=linux@leemhuis.info smtp.helo=[IPV6:2a02:8108:8984:1d00:a0cf:1912:4be:477f]
Received-SPF: pass (mxe9fb: connection is authenticated)
Message-ID: <b1aecdb0-5076-4df1-82a0-e4f5dc755578@leemhuis.info>
Date: Thu, 19 Nov 2026 08:03:14 +0100
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.3 0000/2651] 7.3.6-rc1 review
From: Thorsten Leemhuis <linux@leemhuis.info>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>
References: <20261118150247.972732815@linuxfoundation.org>
 <f44f88e3-5d0c-4001-89d0-306d9d2aad04@leemhuis.info>
Content-Language: de-DE, en-US
Autocrypt: addr=linux@leemhuis.info; keydata=
 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 MEK4
In-Reply-To: <f44f88e3-5d0c-4001-89d0-306d9d2aad04@leemhuis.info>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-PPP-Message-ID: <179507179754.36959.2007122674934045783@mxe9fb.netcup.net>
X-Rspamd-Server: rspamd-worker-8404
X-Rspamd-Queue-Id: B89E15F9FD
X-NC-CID: aZRo+IUNk82ybbRoP9FDlkuk/n7Eg09i11HXeLntvkZsIMQsjT8=

On 11/18/26 20:08, Thorsten Leemhuis wrote:
> On 11/18/26 15:20, Greg Kroah-Hartman wrote:
>> This is the start of the stable review cycle for the 7.3.6 release.
>> There are 2651 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Fri, 20 Nov 2026 14:55:47 +0000.
>> Anything received after that time might be too late.
>>
>> The whole patch series can be found in one patch at:
>> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.3.6-rc1.gz> [...]
> 
> This failed to build for me on s390x while building tools/perf/:
> >> util/annotate-data.c: In function ‘global_var__collect’:
>> util/annotate-data.c:785:30: error: implicit declaration of function ‘die_get_type_die’; did you mean ‘die_get_typename’? [-Wimplicit-function-declaration]
>>   785 |                         if (!die_get_type_die(dwarf, pos->die_off, pos->die_tag,
>>       |                              ^~~~~~~~~~~~~~~~
>>       |                              die_get_typename
> [...]

By just following the hints in the error msg and a bit of searching on
lore I was able to fix this on 7.3.y-rc by cherry-picking 3dfdd195c7e45f
("perf dwarf-aux: Add die_same_file() and die_get_type_die()") [v7.4-rc1].

Then I ran into another error (see below), which I was able to fix by
cherry-picking fc076b5f4807a3 ("perf trace: Introduce kernel symbol
beautifier for virtual addresses") [v7.4-rc1]

Ciao, Thorsten

> builtin-trace.c: In function ‘trace__btf_scnprintf’:
> builtin-trace.c:1164:24: error: implicit declaration of function ‘syscall_arg__scnprintf_ksym’; did you mean ‘syscall_arg__scnprintf_buf’? [-Wimplicit-function-declaration]
>  1164 |                 return syscall_arg__scnprintf_ksym(bf, size, arg);
>       |                        ^~~~~~~~~~~~~~~~~~~~~~~~~~~
>       |                        syscall_arg__scnprintf_buf
> make -f /[...]tools/build/Makefile.build dir=./util/annotate-arch obj=perf-util
> make -f /[...]tools/build/Makefile.build dir=./util/perf-regs-arch obj=perf-util
> make -f /[...]tools/build/Makefile.build dir=./util/kvm-stat-arch obj=perf-util
> make -f /[...]tools/build/Makefile.build dir=./util/intel-pt-decoder obj=perf-util
> make -f /[...]tools/build/Makefile.build dir=./util/arm-spe-decoder obj=perf-util
> make -f /[...]tools/build/Makefile.build dir=./util/hisi-ptt-decoder obj=perf-util
> make -f /[...]tools/build/Makefile.build dir=./util/dwarf-regs-arch obj=perf-util
> make -f /[...]tools/build/Makefile.build dir=./util/scripting-engines obj=perf-util
> builtin-trace.c: In function ‘syscall__scnprintf_args’:
> builtin-trace.c:2597:82: error: ‘SCA_KSYM’ undeclared (first use in this function)
>  2597 |                             default_scnprintf == SCA_PTR || default_scnprintf == SCA_KSYM) {
>       |                                                                                  ^~~~~~~~
> builtin-trace.c:2597:82: note: each undeclared identifier is reported only once for each function it appears in
> make[3]: *** [/[...]tools/build/Makefile.build:96: /home/kbuilder/usr/tmp/out/builtin-trace.o] Error 1
> make[3]: *** Waiting for unfinished jobs....
> make[2]: *** [Makefile.perf:544: /home/kbuilder/usr/tmp/out/perf-in.o] Error 2
> make[2]: *** Waiting for unfinished jobs....
> make[1]: *** [Makefile.perf:283: sub-make] Error 2
> make: *** [Makefile:76: all] Error 2
> make: Leaving directory '/[...]tools/perf'



