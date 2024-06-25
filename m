Received: from fout2-smtp.messagingengine.com (fout2-smtp.messagingengine.com [103.168.172.145])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E3FD16FF5F
	for <patches@lists.linux.dev>; Tue, 25 Jun 2024 15:08:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.145
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719328124; cv=none; b=sg+XpctiG0WStsDdectRGoPy7/uxoih+ddKu0ffVggYLUzXEgEhmkUw+CJEuWOUC2acHGw0qtmUop2IuwYjp6e2SJWjLIAX4vt5wLOnPTfGBzpdP8lDv+/vMyZjhozssKkzBGFD7ixrfKo6mUynnNET/cWn21BFUp3h165Egu2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719328124; c=relaxed/simple;
	bh=HozYisQjhtfdJB4B++D/6hFpcYVZF0gmHIudZGTpsWI=;
	h=MIME-Version:Message-Id:In-Reply-To:References:Date:From:To:Cc:
	 Subject:Content-Type; b=i+BRSQwdT4wCB8k2jjc5oFfm/DaiIHoWkKoVP8p0ceWrlVcgIVOkMIiv4D63sM38rdc65NmGuhy5TljjeL5ZEh+F34u1gxdMrlzu4bJ0mUPZSX6ZstuB4RzBDjXoFHEEv18eisP6/R3G3nL/hzHGCPN6sAGvBTq558k0OwsQWSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de; spf=pass smtp.mailfrom=arndb.de; dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b=JolFni1I; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=gTjgrg+h; arc=none smtp.client-ip=103.168.172.145
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arndb.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b="JolFni1I";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="gTjgrg+h"
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
	by mailfout.nyi.internal (Postfix) with ESMTP id 4D95A13802AB;
	Tue, 25 Jun 2024 11:08:42 -0400 (EDT)
Received: from imap51 ([10.202.2.101])
  by compute5.internal (MEProxy); Tue, 25 Jun 2024 11:08:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm1; t=1719328122; x=1719414522; bh=9p19Ek6oDx
	qDX/g4Si9x6eIXxdsJ/T4Dmsg1S6ffYnY=; b=JolFni1IZuWiPuyf/xB0Ir/w89
	f97m388pAqgCPwvEHO2y/DCiVYqlHXrbdStM0hsS8+DM6bjLA847BZIrhQSizofI
	frzCpZ/r4hUUfMMcguBKJN0OOp/PsY8m/qSls6SR6dFhnCwnZAkiGu/lVAshTE3N
	HeNBPdDXOKdhGKPbdIqWMv/3JJsVUPSS2hcJNlL55iqTWjuiajunWXjZ34G9qwXX
	AEvQ1IAoHR88O+JuP7au1GxnPMCPmGHc9xv5QNK9le5urDcOxppZtfJQ8u8Sz7qW
	Z25zi58b2n1ZxjgaR2PeZ/WH8E0TFrJyCq0gBV++Jq/lyLPOvH5l//pkJmVw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm2; t=1719328122; x=1719414522; bh=9p19Ek6oDxqDX/g4Si9x6eIXxdsJ
	/T4Dmsg1S6ffYnY=; b=gTjgrg+hJl51ypQbW+X2Q4MvyS694fiY8V7Gw4UMxLcy
	vxzs8PRZ3jdOMEe85ryTbKWFYTI47VpA1zEo2EBfPbJSAe3Z3UygOevUS62slrfy
	vwFSBdAD80/1d4EKBfSB+CazDjbAqwh8FtAXEvs114DSN3+NyUxGJ/y4bZTHUB4B
	JqW6QyCjzZd2Kc6T5JjhCrS9MDZFltGt79Xx+Tuslswd12BPpFmyCA+V7f1FAtez
	azgH5RuKYPs5hkiFPL+gcPDlVGdmmTXwYYUmb2I6iEx85V7ictX7P40Z5b71i8Am
	S24K9H6m6DrT+HPGqBaE9Z+r789fuFfZKxYUd6fnIg==
X-ME-Sender: <xms:ed16Zi4Aq9lJ0g5Rz991pnqrWDw5a5sb7LfFodRXUCeodOIumLmKZQ>
    <xme:ed16Zr6DVqZVE-CCcAJfwWVcftD2kqdDQ43CLW1B7kveuDmWD1Q7xE-EDIWQBsAIt
    BeqolAG3HFFJvg8xic>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeftddrtddtgdehudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefofgggkfgjfhffhffvvefutgesthdtredtreertdenucfhrhhomhepfdetrhhn
    ugcuuegvrhhgmhgrnhhnfdcuoegrrhhnugesrghrnhgusgdruggvqeenucggtffrrghtth
    gvrhhnpeffheeugeetiefhgeethfejgfdtuefggeejleehjeeutefhfeeggefhkedtkeet
    ffenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegrrh
    hnugesrghrnhgusgdruggv
X-ME-Proxy: <xmx:ed16Zhcku7tD8XoeqWVX-1s5_SL3rvrNApt_c1TYfLEIzXVuRQZnaA>
    <xmx:ed16ZvJzMo0AKc57JPJyBPpKESzGF7ZOWkMZJMob7dRtgVs9qrUwMg>
    <xmx:ed16ZmKOAm68NmvywtAjQwbQyLrFs5simEjfPIWO_yLs4t1kcje-OA>
    <xmx:ed16ZgxIQeIlZA91Z7e0U3NzYjOtDtWTz3mVwjuwROJoT1bg3RjPFA>
    <xmx:et16ZjiHs89Mv18395Gf9O6GPO4pbsKzlauBFCRUi37TEv6KD6mh4iHz>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
	id 3FCCCB60092; Tue, 25 Jun 2024 11:08:41 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.11.0-alpha0-538-g1508afaa2-fm-20240616.001-g1508afaa
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-Id: <70d09795-5e70-4528-9811-d0bafe7ffe07@app.fastmail.com>
In-Reply-To: 
 <CA+G9fYsn8r7V=6K1_a-mYAM4icHKt-amiisFMwBbfPeSPyqz-g@mail.gmail.com>
References: <20240625085537.150087723@linuxfoundation.org>
 <CA+G9fYuWjzLJmBy+ty8uOCkJSdGEziXs-UYuEQSC-XFb5n938g@mail.gmail.com>
 <CA+G9fYsn8r7V=6K1_a-mYAM4icHKt-amiisFMwBbfPeSPyqz-g@mail.gmail.com>
Date: Tue, 25 Jun 2024 17:08:19 +0200
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
 "Anders Roxell" <anders.roxell@linaro.org>,
 "Dan Carpenter" <dan.carpenter@linaro.org>
Subject: Re: [PATCH 6.6 000/192] 6.6.36-rc1 review
Content-Type: text/plain

On Tue, Jun 25, 2024, at 16:43, Naresh Kamboju wrote:
> On Tue, 25 Jun 2024 at 16:39, Naresh Kamboju <naresh.kamboju@linaro.org> wrote:
>> On Tue, 25 Jun 2024 at 15:18, Greg Kroah-Hartman
>> <gregkh@linuxfoundation.org> wrote:
>> arm-linux-gnueabihf-ld: drivers/firmware/efi/efi-init.o: in function
>> `.LANCHOR1':
>> efi-init.c:(.data+0x0): multiple definition of `screen_info';
>> arch/arm/kernel/setup.o:setup.c:(.data+0x12c): first defined here
>> make[3]: *** [scripts/Makefile.vmlinux_o:62: vmlinux.o] Error 1
>
> git bisect is pointing to this commit,
> [13cfc04b25c30b9fea2c953b7ed1c61de4c56c1f] efi: move screen_info into
> efi init code

I think we should drop this patch: it's not a bugfix but was only
pulled in as a dependency for another patch. The series was rather
complicated to stage correctly, so keeping my screen_info patch
would require pulling in more stuff.

       Arnd
