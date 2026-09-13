Received: from mout-p-101.mailbox.org (mout-p-101.mailbox.org [80.241.56.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 165273E49ED;
	Sun, 13 Sep 2026 12:54:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.241.56.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789304096; cv=none; b=q5fsw3Dh1+9eNDZrkI7qY8r/qduROqi6TTbOzg7dWJeWORvnW/820JzSHNMxbWPWLU27whrZpYol5a0Rp1yZQNEys/ttmBSbEO7X6DqRGqOQTXs7YxhkKbhjZ6HbW8ZsF+BP0AfBPa/jkQT829rFoN2qRpRF3SfYBH+oeQwupoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789304096; c=relaxed/simple;
	bh=wC65E8dd+IeMd273lx+z9CXI30/NYD7CVMw65WDd/6E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jvc8K7LNTkHJnj+xJcGJ8epiRmxAzDn7u0JP6wkNL3SBzfOgIcbE8qzHU4L0yuoGYX1WZUy5M2FxCntdRGJwGVj9L0A9CLqC1v176vlWRe3B/NiJ34fLR90ZF5trr0nUXWVzmjiBoAcEhNgxgB/GMizbcOqt+HHd3ctACmz1faI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mailbox.org; spf=pass smtp.mailfrom=mailbox.org; dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.b=DZI120Tn; arc=none smtp.client-ip=80.241.56.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mailbox.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mailbox.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.b="DZI120Tn"
Received: from smtp202.mailbox.org (smtp202.mailbox.org [10.196.197.202])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-101.mailbox.org (Postfix) with ESMTPS id 4hjSsy09rQz8thm;
	Sun, 13 Sep 2026 14:54:46 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
	t=1789304086;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2F1z9crfC0BI+4IFUtzMAidHdMiOyKDeHfWHnfRJ6KI=;
	b=DZI120TnC+YpfL7KNF0sE6jN14q+MYn1jouSBstsAEKxXW5NP4ynnd21cndANPsU1bCJgb
	tL5sfAwztUhzSORtRaQLaEYuNQr9WmcuDEF3reqE1HLY3icQzWSVKrcWQGcfNeh9B4qlZA
	i6BE8/s9P0xfuODK5tmQwZcsKUPUhupg0u6Z73jRyBktz1qBjjdj0x4gYwbvZICSKLFVim
	Kw9PF98tsVMUci+Pvst2AQxVkm4cMzJG6rm2wJtyJVy6qB/KcMIWgp4wR2Zvoz8fTkyb6s
	B09vQvkFRekyxA65gSHts5/O90YA+2Swt0LPbkvBYDwZvkXL0cq1jivsyakJfg==
Date: Sun, 13 Sep 2026 14:54:39 +0200
From: Benjamin Boortz <bennib@mailbox.org>
To: Thorsten Leemhuis <linux@leemhuis.info>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	stable@vger.kernel.org, patches@lists.linux.dev, linux-kernel@vger.kernel.org, 
	torvalds@linux-foundation.org, akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@nabladev.com, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de, 
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, achill@achill.org, 
	sr@sladewatkins.com, Linux kernel regressions list <regressions@lists.linux.dev>
Subject: Re: [PATCH 7.2 0000/1815] 7.2.6-rc1 review
Message-ID: <aqabqJHW_tHhQn3v@bb-82jq>
References: <20260912065648.999753832@linuxfoundation.org>
 <5babfab4-ebf7-42b8-88f2-ac2f5b6b2d7f@leemhuis.info>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5babfab4-ebf7-42b8-88f2-ac2f5b6b2d7f@leemhuis.info>
X-MBO-RS-META: 5efubqy6gemdyiir7bgxrquqtd1qrby5
X-MBO-RS-ID: 343d53b3bbcc94788df

On Sat, Sep 12, 2026 at 12:18:56PM +0200, Thorsten Leemhuis wrote:

>On 9/12/26 08:29, Greg Kroah-Hartman wrote:
>> This is the start of the stable review cycle for the 7.2.6 release.
>> There are 1815 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>> [...]
>
>My builds failed while compiling perf:
>
>>> ui/browsers/hists.c: In function ‘evsel__hists_browse’:
>>> ui/browsers/hists.c:3191:41: error: ‘hotkey_act’ undeclared (first use in this function)
>>>  3191 |                                 memset(&hotkey_act, 0, sizeof(hotkey_act));
>>>       |                                         ^~~~~~~~~~
>>> ui/browsers/hists.c:3191:41: note: each undeclared identifier is reported only once for each function it appears in
>Reverting "perf ui hists: In report UI ensure thread is set with
>reference counting" fixes this. Haven't tried, but maybe including
>bd86119c3ee6ed ("perf ui hists: Fix dso_filter reference leak and exit
>zoom cleanup") will fix this, too.
>
>That got me a little further, but then I ran into this:
>
>>> tools/perf/util/python.c: In function ‘pyrf_evsel__open’:
>>> tools/perf/util/python.c:1104:9: error: implicit declaration of function ‘CHECK_INITIALIZED’ [-Wimplicit-function-declaration]
>>>  1104 |         CHECK_INITIALIZED(evsel, "evsel");
>>>       |         ^~~~~~~~~~~~~~~~~
>>> tools/perf/util/python.c: In function ‘pyrf_evsel__set_tracking’:
>>> tools/perf/util/python.c:1295:9: error: implicit declaration of function ‘CHECK_INITIALIZED_INT’ [-Wimplicit-function-declaration]
>>>  1295 |         CHECK_INITIALIZED_INT(pevsel->evsel, "evsel");
>>>       |         ^~~~~~~~~~~~~~~~~~~~~
>
>Only looked briefly, but didn't spot a simple way to work around that
>through a simple revert or two (but it's quite likely I missed something).
>
>Ciao, Thorsten
>


build-tested and reproduced the 2 issues on x86_64 with:

   make -j$(nproc) -C ./tools/perf O=/tmp/perf-build

observed errors:

1) tools/perf/ui/browsers/hists.c:3191:41: error: 'hotkey_act' undeclared

2ec3b9858725 — "perf hists browser: Increase MAX_OPTIONS to prevent stack buffer overflow"
   prerequisite: bd86119c3ee6 expects MAX_OPTIONS=32; stable-rc still has 16
   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=2ec3b985872594031cc1000b830344de5c26633d
bd86119c3ee6 — declares hotkey_act, fixes dso_filter reference leak
   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=bd86119c3ee6ed7b8fc9be8298fe49f1a5355a46


2) tools/perf/util/python.c:1104:9: error: implicit declaration of function 'CHECK_INITIALIZED'

01fa2d416ace — defines CHECK_INITIALIZED
   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=01fa2d416aceab51f97ec2769e8da9971a605eeb


With the 3 patches applied, perf build successful.

Benni

