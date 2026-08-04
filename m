Received: from mout.web.de (mout.web.de [212.227.15.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC2713EFD10
	for <patches@lists.linux.dev>; Tue,  4 Aug 2026 14:32:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785853936; cv=none; b=eJd0dPDo13UpZaB7dvazA4os5mH8GaHO2cyBb8NS015y8xMi5y2Dl5lpbUTvwX8k/bpF/MZFrbOA7sR70QXVm+RjdackAMVnAVULunYyFA6mk0W/0+094qjpcU4dz0bJEyOB63mjzDL6tJizTaT6J8NXfVJtZgSLwtuUen9zLVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785853936; c=relaxed/simple;
	bh=2DX4OKnrPnVzjghCo2HZChbMK1uWjzRuJ92rgd3NjDE=;
	h=Content-Type:Message-ID:Date:MIME-Version:From:Subject:To:Cc:
	 References:In-Reply-To; b=iEQHdNQnyFpb6Z5o2IUPbBls/TDJtQSaO1qAKXTPO9DF9ITZLaGqhmROPl3XaG7gvDsJO+Jtsd2Cvtw05hTZgKzYlQGqubQHrnX0NC7i3LPP0w0tMr1OPQcspatpDBvNwATrX5i6EnEgzb+eV2CQN+8Dne7Mjq+44BC1d25GbPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=frank.scheiner@web.de header.b=PGXglcFO; arc=none smtp.client-ip=212.227.15.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=frank.scheiner@web.de header.b="PGXglcFO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1785853913; x=1786458713; i=frank.scheiner@web.de;
	bh=aWpNZDbulEgmtERlHV+bqlLhmeaTGxBeZbAXFPg+2/I=;
	h=X-UI-Sender-Class:Content-Type:Message-ID:Date:MIME-Version:From:
	 Subject:To:Cc:References:In-Reply-To:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=PGXglcFOagySL0PhPk6ai4z2HUhHvGeOhNu1p1oI1ASnx9Qqkt5jGhg61+tCiuAb
	 x9bPP2KJBUCk4zMAITYtrTxT822iRcGAGGimKIGJ6ET2T12P2l9rD8nImVRHwDb8q
	 qagZw65Ow4Sh7u9YErUDIRBNCLLXImqyqcUyVhLOI5GApM49lGkOkxy3vhe2NLngq
	 j3jTXBgBF1sHiK9xCc+uXtYzhGaR+vT5vO9n77TpLAKuwori+0Q3QkuWzNFsQWUc2
	 V9AUucf6mkdLoTI1JIg49XzFdKkgVAs/qEiLnJge9mbbvRV9erVzpK6tXputVHeE8
	 6NhlkuXoSZqXJ7FNNg==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from client.hidden.invalid by smtp.web.de (mrweb006
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1Melaj-1xR8hR3KU9-00aBrB; Tue, 04
 Aug 2026 16:31:52 +0200
Content-Type: multipart/mixed; boundary="------------fMwjKfsybg0Z1na6aaC9I0k0"
Message-ID: <4da1cbe8-3ec2-4b20-8b0e-572ccbf73e29@web.de>
Date: Tue, 4 Aug 2026 16:31:50 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Frank Scheiner <frank.scheiner@web.de>
Subject: Re: [PATCH 6.6 000/484] 6.6.148-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
 linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
 akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
 patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@nabladev.com,
 jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com, cc@epic-linux.org
References: <20260730141423.392222816@linuxfoundation.org>
 <e2abbb8e-e222-49d5-bc58-6b5328490ac6@web.de>
 <2026080313-stony-spree-9b45@gregkh>
Content-Language: en-US
In-Reply-To: <2026080313-stony-spree-9b45@gregkh>
X-Provags-ID: V03:K1:xBb5l5KvvSUzW9f0RdTIFqbUpJZc60jjT5dGiObi4YYTSnHBoqu
 WKhzECJlFN5x26f5Gk9sHbzzlpzNv8+siV2GE3CwuQyxV5pNweh2EsLC+0ylLFe9q0Wzb3k
 OxlOdn1d9T7tQ1EiUevFpmRdmheBPfzrH9dYtwAuwyQ5moejSJGQaojvf2qjxjQwKPR0gEn
 Tez/EwcDmNuFYzzsJ2o3A==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:rCPMCNNSwPo=;gcY7NxH0W+u0016Q00lwJRxI3Oh
 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
 DQw3yye1fyK1OrVNjL7gUVEWMKTXQ0Q5t3r6w=

This is a multi-part message in MIME format.
--------------fMwjKfsybg0Z1na6aaC9I0k0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 03.08.26 10:14, Greg Kroah-Hartman wrote:
> [...]
> Ugh.  This is what happens when we are trying to deal with stable stuff
> that is not upstream, we almost always get it wrong.
>=20
> Can you send me a revert patch for this, so we can fix your build?

Locally I use [1] for now, also attached, based on linux-6.6.y at
aa0e49877a2e61e9f4ca10e039727a34f59e9964, tag: v6.6.148.

[1]: https://raw.githubusercontent.com/linux-ia64/linux-stable-rc/refs/hea=
ds/__mirror/patches/linux-6.6.y/0001-Revert-ia64-Make-acpi_cpufreq_cpu_exi=
t-return-void.patch

>  ANd
> going forward, I think we're just going to have to stick to the "it has
> to be usptream" stuff, and if you wish to keep this arch alive outside
> of upstream, the api/build/whatever fallout will have to be on you, as
> we just can't handle it here, sorry.

I kind of understand the issue here. But if it's impossible to maintain
all architectures in an LTS kernel that were present during its first
release, the LTS somewhat loses its meaning IMHO - unless this never
covered all architectures present in a release. But then I also don't
understand:

"The ia64 architecture gets its well-earned retirement as planned,
 now that there is one last (mostly) working release that will be
 maintained as an LTS kernel."

...from [2].

[2]: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/co=
mmit/?id=3D1e0c505e13162a2abe7c984309cfe2ae976b428d

But I also wonder: if a mainline patch that should go into a stable
kernel branch but won't work as is, it needs to be backported somewhow,
or?

Which is IMHO exactly the situation we have here: A mainline patch ([3])
from a Linux version (6.11) after an arch removal "failed" to modify all
relevant files in a stable Linux version (6.6) before that arch removal.
Hence that mainline patch requires modifications.

[3]: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/co=
mmit/?id=3Db4b1ddc9dfe997a5f492fa3a36487f8e7a5de30d

I assume there must have been already cases where a mainline patch was
desired, but didn't fit as is and so required modifications. If that
case is supported, it should also work for the few stable Linux branches
that still have support for ia64 included (linux-5.10.y, linux-5.15.y,
linux-6.1.y and linux-6.6.y)), no?

****

But if you can't handle that case, sure, we can do it on our own. Though
again I think there is not much of a difference to cases where a
mainline patch breaks some still supported arch, device driver, whatever
in a stable branch and people like to have both working: they cannot fix
it in mainline.

Cheers,
Frank

--------------fMwjKfsybg0Z1na6aaC9I0k0
Content-Type: text/x-patch; charset=UTF-8;
 name="0001-Revert-ia64-Make-acpi_cpufreq_cpu_exit-return-void.patch"
Content-Disposition: attachment;
 filename*0="0001-Revert-ia64-Make-acpi_cpufreq_cpu_exit-return-void.patc";
 filename*1="h"
Content-Transfer-Encoding: base64

RnJvbSA3ZDIxM2RkZTExNWI3N2VlNTc1OWZmZmZjZGNkNGE1MDI2NDY0ZDQ5IE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBGcmFuayBTY2hlaW5lciA8ZnJhbmsuc2NoZWluZXJA
d2ViLmRlPgpEYXRlOiBUdWUsIDQgQXVnIDIwMjYgMTU6NDg6MDggKzAyMDAKU3ViamVjdDog
W1BBVENIXSBSZXZlcnQgImlhNjQ6IE1ha2UgYWNwaV9jcHVmcmVxX2NwdV9leGl0IHJldHVy
biB2b2lkIgoKQ29tbWl0IGI0YjFkZGM5ZGZlOSAoImNwdWZyZXE6IE1ha2UgY3B1ZnJlcV9k
cml2ZXItPmV4aXQoKSByZXR1cm4Kdm9pZCIpIHdhcyBwYXJ0IG9mIHY2LjYuMTQ1LXJjMS4g
QnV0IGFzIGl0IHdhcyBkZXJpdmVkIGZyb20gYQpsYXRlciBMaW51eCB2ZXJzaW9uIHcvbyBz
dXBwb3J0IGZvciBpYTY0IGl0IGRpZG4ndCB0b3VjaCBhbGwKcmVsZXZhbnQgcGFydHMgaW4g
bGludXgtNi42LnkuIFdoaWNoIG5vdyByZXF1aXJlZCBhbiBleHRyYSBmaXggdG8KYnVpbGQg
Y29ycmVjdGx5IGZvciBpYTY0LiBCdXQgYjRiMWRkYzlkZmU5IHdhcyB0aGVuIG5vdCBwYXJ0
IG9mCnRoZSByZWxlYXNlIHY2LjYuMTQ1LiBTbyB0aGUgZXh0cmEgZml4IGNhbiBnbyBub3cs
IHRvby4KClRoaXMgcmV2ZXJ0cyBjb21taXQgYmI1MWI2MjZiNWE4ZWYzNDliMTE4NzY1NzI1
NDBmMTlhZDRkNTAzMC4KClNpZ25lZC1vZmYtYnk6IEZyYW5rIFNjaGVpbmVyIDxmcmFuay5z
Y2hlaW5lckB3ZWIuZGU+Ci0tLQogZHJpdmVycy9jcHVmcmVxL2lhNjQtYWNwaS1jcHVmcmVx
LmMgfCA0ICsrKy0KIDEgZmlsZSBjaGFuZ2VkLCAzIGluc2VydGlvbnMoKyksIDEgZGVsZXRp
b24oLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL2NwdWZyZXEvaWE2NC1hY3BpLWNwdWZyZXEu
YyBiL2RyaXZlcnMvY3B1ZnJlcS9pYTY0LWFjcGktY3B1ZnJlcS5jCmluZGV4IGY2OTI3Mjkw
NjhmNS4uYzZiZGM0NTU1MTdmIDEwMDY0NAotLS0gYS9kcml2ZXJzL2NwdWZyZXEvaWE2NC1h
Y3BpLWNwdWZyZXEuYworKysgYi9kcml2ZXJzL2NwdWZyZXEvaWE2NC1hY3BpLWNwdWZyZXEu
YwpAQCAtMzAyLDcgKzMwMiw3IEBAIGFjcGlfY3B1ZnJlcV9jcHVfaW5pdCAoCiB9CiAKIAot
c3RhdGljIHZvaWQKK3N0YXRpYyBpbnQKIGFjcGlfY3B1ZnJlcV9jcHVfZXhpdCAoCiAJc3Ry
dWN0IGNwdWZyZXFfcG9saWN5ICAgKnBvbGljeSkKIHsKQEAgLTMxNiw2ICszMTYsOCBAQCBh
Y3BpX2NwdWZyZXFfY3B1X2V4aXQgKAogCQlrZnJlZShwb2xpY3ktPmZyZXFfdGFibGUpOwog
CQlrZnJlZShkYXRhKTsKIAl9CisKKwlyZXR1cm4gKDApOwogfQogCiAKLS0gCjIuMjUuMQoK


--------------fMwjKfsybg0Z1na6aaC9I0k0--
