Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=188.68.63.102
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029018;
	b=PoG6j5tp11FZVMQFT5xgRYciAbZWFzyRbjsKCVJoKWcGa3T1/06y8POl5WJ2An4wTnfN
	 hZtg24texmYL7lARg0DpG7DR9mEPWMA+R/AN3r6Mq1nx9Cim9LWY6WtX3YWYZkDtOfLZx
	 DxiULkCBHaqs5yMxvRrrtlUr3AbAmEJx7zqCu5ugrdnc3Q4S9Q7WEa+CvV9YA5QtkctfO
	 wfodyyrY6iiADje29BTnsAw+dMLrAriZw066uihWJsyNmVtl/B3pDjHUiVrwb04EcbtHI
	 OsGZ1NpsfyHj9jfYzKHeeG+hk8NcQClIbwFmx7jknD8WZYs5PaUVq7YxQ50pjCHwGqw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029018;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received-SPF:Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:
	 References:From:Content-Language:Autocrypt:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-PPP-Message-ID:X-NC-CID;
	bh=jApJlOTkuKeHJz3p62IcHr0IeJBDXHk0vWL/IDLkBn0=;
	b=bm++oFUwZWZeumJ48WVMgnbdXGChMk6JFgghso/FscZoV28ache3an4A4PKPW5tq2X2F
	 77A8XsxUDmMfdMOinYTzysYlSA+qgcIZZFd52tz1OjPIaKxwH6NEMESCPxNvtWw+nCCVh
	 eNzeuxFTiCOSANE+5GaY7B3/j8vdjOoEKK/JR/gbxB6+aO3w+8SkHAoJtBxAn6RP/3Gon
	 /5zfMY0r7TxXc4nT7NA1L7JSEpZ9sTNd5xDJYfRkxUx7CLnIZuPeJseBqZBAzPsxbcwy+
	 uKoR5YadgaLlJ9svtlYhxm+95TDjYjCJF63/gWGnpM/gq3j1TfqKaa7kA4KGnG0126g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=leemhuis.info;
	spf=pass smtp.mailfrom=leemhuis.info;
	dkim=pass header.d=leemhuis.info header.i=@leemhuis.info header.a=rsa-sha256 header.s=key2 header.b=UQvpLUzR;
	arc=none smtp.remote-ip=188.68.63.102
Received: from relay.yourmailgateway.de (relay.yourmailgateway.de [188.68.63.102])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B9E0606A333
	for <patches@lists.linux.dev>; Wed, 18 Nov 2026 19:10:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9B9E0606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=leemhuis.info
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=leemhuis.info
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=leemhuis.info header.i=@leemhuis.info header.a=rsa-sha256 header.s=key2 header.b=UQvpLUzR
Received: from mors-relay-2502.netcup.net (localhost [127.0.0.1])
	by mors-relay-2502.netcup.net (Postfix) with ESMTPS id 4jVB3V6wF3z6JMQ;
	Wed, 18 Nov 2026 20:09:10 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=leemhuis.info;
	s=key2; t=1795028951;
	bh=GrzZZYKpfkJx7R979hMX2CR+LPFVTbn1bMxjDHP1ITU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=UQvpLUzRYIW2/4HlygR06QuNz/Hy0DhxGy/INRunHX0fUlLw3Rm38FHfBGH94eIL6
	 IwP7mZY4rcgG6SAUXo8k/gNvik/wA+EhU6q4bWEMm4qR4iuPFxHZ4AWlz9ePOk2HpZ
	 kdP8H6HIB7eirP5NrhalrCTx1IPRmCcRG6NffNFzUlFtEpLBCFg4KZaf5v7wrHRqNj
	 hOCSGyPXdljxLv5ovbK/iwSYNDlOiCAPRr5ZDkBVDE7mtifFCt0Wn2gM4WotDqIG1g
	 XmY3kRb99xOfNM/8kVq3q7a1NfTlWfrpROcQp/y4ZcJF3Irt5R4Tm6k4/AwHkqzU0/
	 cKDQOUJJ6OZXw==
Received: from policy02-mors.netcup.net (unknown [46.38.225.35])
	by mors-relay-2502.netcup.net (Postfix) with ESMTPS id 4jVB2w5LLbz521W;
	Wed, 18 Nov 2026 20:08:40 +0100 (CET)
Received: from mxe9fb.netcup.net (unknown [10.243.12.53])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by policy02-mors.netcup.net (Postfix) with ESMTPS id 4jVB2t4rRyz8sb3;
	Wed, 18 Nov 2026 20:08:38 +0100 (CET)
Received: from [IPV6:2a02:8108:8984:1d00:a0cf:1912:4be:477f] (unknown [IPv6:2a02:8108:8984:1d00:a0cf:1912:4be:477f])
	by mxe9fb.netcup.net (Postfix) with ESMTPSA id B2F935F9E7;
	Wed, 18 Nov 2026 20:08:19 +0100 (CET)
Authentication-Results: mxe9fb;
        spf=pass (sender IP is 2a02:8108:8984:1d00:a0cf:1912:4be:477f) smtp.mailfrom=linux@leemhuis.info smtp.helo=[IPV6:2a02:8108:8984:1d00:a0cf:1912:4be:477f]
Received-SPF: pass (mxe9fb: connection is authenticated)
Message-ID: <f44f88e3-5d0c-4001-89d0-306d9d2aad04@leemhuis.info>
Date: Wed, 18 Nov 2026 20:08:19 +0100
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
From: Thorsten Leemhuis <linux@leemhuis.info>
Content-Language: de-DE, en-US
Autocrypt: addr=linux@leemhuis.info; keydata=
 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 MEK4
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-PPP-Message-ID: <179502890049.2814386.299617666781807517@mxe9fb.netcup.net>
X-NC-CID: 2Oo+gn2tGsdaLGlgtVObaWNaizbSu8muMQTAJevp1q2ohR3HVzk=

On 11/18/26 15:20, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.3.6 release.
> There are 2651 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 20 Nov 2026 14:55:47 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.3.6-rc1.gz> [...]

This failed to build for me on s390x while building tools/perf/:

> util/annotate-data.c: In function ‘global_var__collect’:
> util/annotate-data.c:785:30: error: implicit declaration of function ‘die_get_type_die’; did you mean ‘die_get_typename’? [-Wimplicit-function-declaration]
>   785 |                         if (!die_get_type_die(dwarf, pos->die_off, pos->die_tag,
>       |                              ^~~~~~~~~~~~~~~~
>       |                              die_get_typename
> util/annotate-data.c:785:71: error: ‘struct die_var_type’ has no member named ‘die_tag’
>   785 |                         if (!die_get_type_die(dwarf, pos->die_off, pos->die_tag,
>       |                                                                       ^~
> util/annotate-data.c:786:50: error: ‘struct die_var_type’ has no member named ‘from_alt’
>   786 |                                               pos->from_alt, &type_die))
>       |                                                  ^~
> util/annotate-data.c:792:44: error: ‘struct die_var_type’ has no member named ‘from_alt’
>   792 |                                         pos->from_alt);
>       |                                            ^~
> util/annotate-data.c: In function ‘get_global_var_type’:
> util/annotate-data.c:849:26: error: implicit declaration of function ‘die_same_file’ [-Wimplicit-function-declaration]
>   849 |                         !die_same_file(cu_die, type_die));
>       |                          ^~~~~~~~~~~~~
> util/annotate-data.c: In function ‘update_var_state’:
> util/annotate-data.c:905:42: error: ‘struct die_var_type’ has no member named ‘die_tag’
>   905 |                                       var->die_tag, var->from_alt, &mem_die))
>       |                                          ^~
> util/annotate-data.c:905:56: error: ‘struct die_var_type’ has no member named ‘from_alt’
>   905 |                                       var->die_tag, var->from_alt, &mem_die))
>       |                                                        ^~
> make[4]: *** [/builddir/build/BUILD/kernel-7.3.6-build/kernel-7.3.6-rc1/linux-7.3.6-0.rc1.400.vanilla.fc45.s390x/tools/build/Makefile.build:96: util/annotate-data.o] Error 1
> make[4]: *** Waiting for unfinished jobs....
> make[3]: *** [/builddir/build/BUILD/kernel-7.3.6-build/kernel-7.3.6-rc1/linux-7.3.6-0.rc1.400.vanilla.fc45.s390x/tools/build/Makefile.build:158: util] Error 2
> make[2]: *** [Makefile.perf:573: perf-util-in.o] Error 2
> make[1]: *** [Makefile.perf:283: sub-make] Error 2
> make: *** [Makefile:76: all] Error 2

Full log:
https://download.copr.fedorainfracloud.org/results/@kernel-vanilla/fedora-rc/fedora-45-s390x/11350094-stablerc-fedorarc-releases/builder-live.log.gz

Maybe other archs are affected as well, those builds failed earlier for
me due to the rust problem I reported a few minutes ago.

Have to run, so not time to look at where this is coming from right now,
sorry.

Ciao, Thorsten
