Received: from fhigh7-smtp.messagingengine.com (fhigh7-smtp.messagingengine.com [103.168.172.158])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 557021DA313
	for <patches@lists.linux.dev>; Wed,  3 Jul 2024 18:35:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.158
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720031703; cv=none; b=SqjI3ecn7ZDeUVj+Bu4kVMPdzU3j51p32RDlD6bh45vpvph+LZxxdp7PM8DwT5seDQIOSEYW/cb5FgT0xW8ipqkuW6STBTLCWngorJSmZvdPjRV9f/WH9juc10KvS2Xo4paF3FIVuqGapPfYvE2wRCUd6OeFINnsR+w0QAXimxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720031703; c=relaxed/simple;
	bh=i+jRm2XNt/nOtiImd2nWAhMZWwOiZlZAQYviO67O+e0=;
	h=MIME-Version:Message-Id:In-Reply-To:References:Date:From:To:Cc:
	 Subject:Content-Type; b=Vj7UJfYSSK4Gv8z9rH/TCJdW2HFXeZTWwzMYNAFZWNFGusHTshEJ6Y3yQnUfkG5HKriOfb/YSl6uJleg27/9BhEq6rqFe1pe2LapcwZGt1D4deaJpx/ua0nFDY+eqfRhcdESUZuUKqoUhBX74VbSzEy8MmAnF0JpVWwU3LMX8EM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de; spf=pass smtp.mailfrom=arndb.de; dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b=Rdq7jBNi; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=GN8sl4++; arc=none smtp.client-ip=103.168.172.158
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arndb.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b="Rdq7jBNi";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="GN8sl4++"
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
	by mailfhigh.nyi.internal (Postfix) with ESMTP id 735F711401B8;
	Wed,  3 Jul 2024 14:35:00 -0400 (EDT)
Received: from imap51 ([10.202.2.101])
  by compute5.internal (MEProxy); Wed, 03 Jul 2024 14:35:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm1; t=1720031700; x=1720118100; bh=zVR+UXlWh3
	a8IJF25NtOCZOCNR0BcDT+mApZ1Nc8rYU=; b=Rdq7jBNiS9VB3CQyFzhPEMLhOv
	mWE1K8KS/0NNqC+3EWK2FbUi3/4T1udk1isTfKh7ja3Mfrzqz3mayByj4UObNlRj
	WBZtCrFiVSqbor+/bMNEM0T6zvayffy+45hcUxxFvhb8hB1Mp3FLLRh3hBGU/7GN
	nNF36VVhhpp/gL4t+bvFtGWTXIfS6PTTgUT1CGEAtKGRkQ0YVEsY1MnOZyXYiZRG
	FP1JKDgeTVJa4fXpnur+u8PVtbdMfcKIWL4dg2dr7lXuI76wQblpicCFpXBhwPeg
	s0wGcAiVkf4OdMhyzeWkR+1O8i0INvAXP4wzdGQP5Gyj9yITh2UUMVvilOYQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm2; t=1720031700; x=1720118100; bh=zVR+UXlWh3a8IJF25NtOCZOCNR0B
	cDT+mApZ1Nc8rYU=; b=GN8sl4++eKex9iLDz6JVsigVkb1GWiiUN8Fs6Jn68S1/
	pgDT5ZOgq0tlxTAwgh1Rmnd6KtRPhLyv3GCjz5CCpEWWp19RFo8j+KpbIZ5yAbJb
	mY1tMfw72+0YZ0BBLDjK5+Ehmc2qjnU7gNGOd7iISakoWMKuVo4DXv12PFZmhHGx
	pgfE9ARPyJLpqD8R0+CInADHiCsfEkYd+SwR27dGcTDKI9NfsnfNpXyqzkVt9/E9
	1aJ2S0sGB5MjPOl3Jar3v044AQ2zOF+o52si/sN61OBk58AGKT239ImoaK6Yo5KT
	3c5XrTXhP6vp8m/0+WdfuR8aK49oAtZv9CBdqNn+ZA==
X-ME-Sender: <xms:05mFZogN7rNVUk-2LnFvSw56FsY-9T3imXtgBSW7XS_Eesi13ug0oA>
    <xme:05mFZhAP2i2LVw-6-HQFYZdwuF-QJrtZjiXz2CzWrX3J7teHD93BXDajs2k_Y64DN
    CKwB5Lw2NFw1PWv-Ic>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeftddrudejgdduvdeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepofgfggfkjghffffhvfevufgtsehttdertderredtnecuhfhrohhmpedftehr
    nhguuceuvghrghhmrghnnhdfuceorghrnhgusegrrhhnuggsrdguvgeqnecuggftrfgrth
    htvghrnhepffehueegteeihfegtefhjefgtdeugfegjeelheejueethfefgeeghfektdek
    teffnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprg
    hrnhgusegrrhhnuggsrdguvg
X-ME-Proxy: <xmx:05mFZgEigSnbpgcXMfA16OGO7rftdydzZJ0l0C062sVvxcYH6vZacA>
    <xmx:05mFZpTMVyyiHF20nRE4vlkeXXNXR9oyW7bzaWBUvKZ_ZG20ySK_mA>
    <xmx:05mFZlzX4u901GkaLckrDekIz1F6B2RDj1N0Y2gxc80BF8xxg6muzA>
    <xmx:05mFZn72yMIMWLkdJfkf5Xkh_YiVT4fKvrN0yIoGeIYLGSBd4Dw0ZA>
    <xmx:1JmFZqgYjo0kGNViMI3VOeHp0IIXUCWwqf2R_dkzeewquZRzbKsBFGzn>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
	id 1C3C8B6008D; Wed,  3 Jul 2024 14:34:59 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.11.0-alpha0-566-g3812ddbbc-fm-20240627.001-g3812ddbb
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-Id: <72ddde27-e2e2-4a46-a2ab-4d20a7a9424f@app.fastmail.com>
In-Reply-To: 
 <CA+G9fYvAkELSdWF1EYyjS=d_jvCJD0O=aPnZFHUGnhYy6c1VCg@mail.gmail.com>
References: <20240703102841.492044697@linuxfoundation.org>
 <CA+G9fYvAkELSdWF1EYyjS=d_jvCJD0O=aPnZFHUGnhYy6c1VCg@mail.gmail.com>
Date: Wed, 03 Jul 2024 20:34:38 +0200
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Naresh Kamboju" <naresh.kamboju@linaro.org>,
 "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
 linux-kernel@vger.kernel.org,
 "Linus Torvalds" <torvalds@linux-foundation.org>,
 "Andrew Morton" <akpm@linux-foundation.org>,
 "Guenter Roeck" <linux@roeck-us.net>, shuah <shuah@kernel.org>,
 patches@kernelci.org, lkft-triage@lists.linaro.org,
 "Pavel Machek" <pavel@denx.de>, "Jon Hunter" <jonathanh@nvidia.com>,
 "Florian Fainelli" <f.fainelli@gmail.com>,
 "Sudip Mukherjee" <sudipm.mukherjee@gmail.com>, srw@sladewatkins.net,
 rwarsow@gmx.de, "Conor Dooley" <conor@kernel.org>,
 Allen <allen.lkml@gmail.com>, "Mark Brown" <broonie@kernel.org>,
 "Dan Carpenter" <dan.carpenter@linaro.org>,
 "Anders Roxell" <anders.roxell@linaro.org>,
 "Linux-sh list" <linux-sh@vger.kernel.org>, "Rich Felker" <dalias@libc.org>,
 "John Paul Adrian Glaubitz" <glaubitz@physik.fu-berlin.de>
Subject: Re: [PATCH 5.4 000/189] 5.4.279-rc1 review
Content-Type: text/plain

On Wed, Jul 3, 2024, at 19:45, Naresh Kamboju wrote:
> On Wed, 3 Jul 2024 at 16:20, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> arch/sh/kernel/sys_sh32.c:68:1: error: macro "__MAP3" requires 4
> arguments, but only 2 given
>    68 |                 SC_ARG64(nbytes), unsigned int, flags)
>       | ^
> In file included from arch/sh/kernel/sys_sh32.c:11:
> include/linux/syscalls.h:110: note: macro "__MAP3" defined here
>   110 | #define __MAP3(m,t,a,...) m(t,a), __MAP2(m,__VA_ARGS__)
>       |

This is caused by the backport of  my patch 30766f1105d6
("sh: rework sync_file_range ABI"), which uses the
SC_ARG64() that in turn was introduced in linux-5.12 commit
2ca408d9c749 ("fanotify: Fix sys_fanotify_mark() on native
x86-32").

We can't backport the entire fanotify patch to stable
kernels, but it would be fairly easy to just extract
the two macros from it, or to open-code them in the
backport of my patch.

For the moment, I'd suggest dropping my 30766f1105d6
patch from 5.10 and earlier LTS kernels to avoid the
build regression.

Rich and Adrian, let me know if you would submit a
tested backport stable@vger.kernel.org yourself, if you
want help backporting my patch, or if we should just
leave the existing state in the LTS kernels.

      Arnd
