Received: from mout.web.de (mout.web.de [217.72.192.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D51E61DF736
	for <patches@lists.linux.dev>; Wed, 22 Jul 2026 17:25:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.72.192.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784741140; cv=none; b=sIvxz5z3XCGqsQaWXblORZ8gBFy/6wzp1OWdZ9N2Z1+88MzkpUmx1V7fh4oSfZMfPbtWAcpcr0yMp/lVlc8hB7UzY6XZ9WHdydcq8ew3HCfF4lWDCIipWNqxR9DYBHbMQ/N7n/otMDzz1JC4i4IGtTfuG8ZweKCNnxTnYxMjnMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784741140; c=relaxed/simple;
	bh=JJ1IYNLAmh8CA7hmQA9Z4AoqXofw1vYEhr5DDXeM4/s=;
	h=Content-Type:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To; b=PcshnapQnQ5mp8VbIheEPn6qm1cDhmlG1fQVOo2QY7B0VYj1wxjKL8f2YZaL+ovGG5EcOr8X+Nr/SxS+RVumc02T+HZZO4WbwTVjzfL9vMozqiwELFKuI23GPXVs3/gHfpSPNVvFbFII6p2P6cROtF+xfau4jeR/h+oN3MkkVSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=frank.scheiner@web.de header.b=fV7ZsGeV; arc=none smtp.client-ip=217.72.192.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=frank.scheiner@web.de header.b="fV7ZsGeV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1784741128; x=1785345928; i=frank.scheiner@web.de;
	bh=J/SZ18iHPV/P6dxPELmma50Oj6SNqI/gnjDyPs6Nolo=;
	h=X-UI-Sender-Class:Content-Type:Message-ID:Date:MIME-Version:
	 Subject:To:Cc:References:From:In-Reply-To:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=fV7ZsGeVgoQeUAwE3U9PFC2lHPeu22GdQeTC0hwhbcbVQtW68DzOhZyj6OIGztZn
	 PLoslW2DY4ZduEf1XIQQKFTgKRZESR8OHlpeiVRXhKbMhShiDZBCciB6DXivkCNmt
	 9X42mudFwI+ctafMKCJyZboTm5+dkLJPaPu6ykSvjc6KD3JtdzMLsSv5NtKn7m4l4
	 +JhTvUwKtDE9DfwNQZQVNtt4J6G+ZLh0Hh93f6GgtzEF2soVJMB5B8i0AbbCUM+oO
	 u+s2HDLWOprmob9tp8M7N3aA/Inl/g5/lU53fHNLKZDsHVSDJRFrJLOSHoNav5v40
	 mclztvDKYiBJLyHvHw==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from client.hidden.invalid by smtp.web.de (mrweb105
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1MkVsa-1xGenO1HtW-00aba4; Wed, 22
 Jul 2026 19:25:28 +0200
Content-Type: multipart/mixed; boundary="------------2Bd3SN7pVtRTUD80YGo5IgN2"
Message-ID: <88255dcb-acac-4a74-a086-b686aaf15eca@web.de>
Date: Wed, 22 Jul 2026 19:25:26 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 0000/1226] 6.6.145-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com, cc@epic-linux.org
References: <20260722143258.264584003@linuxfoundation.org>
Content-Language: en-US
From: Frank Scheiner <frank.scheiner@web.de>
In-Reply-To: <20260722143258.264584003@linuxfoundation.org>
X-Provags-ID: V03:K1:FX83oiLpvUFPWtv3yCiVgREH442afwQST1uWrsDmba/FpaWRxkM
 PTdxQtkiXGRBFYbm3ZnwzuGHjgApYhpfaR3UqXJAl7RkwI0Nil90Yje53g3x4mL64/AQ2Gl
 pOxTSqPp5v/Kjt+DoXnc02zvJprC9IKd4Vxq8F/qBID6DQpu3ksfOYEpTKUZU+lSKIjMAII
 skLYNxDPrEy7G4umllQMw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:T8puQJ0zh+c=;WZ4Rr/pbNJGxUANpWBNmfZGcw17
 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
 PB68BFNYS8R9

This is a multi-part message in MIME format.
--------------2Bd3SN7pVtRTUD80YGo5IgN2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 22.07.26 16:33, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.145 release.
> There are 1226 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Fri, 24 Jul 2026 14:31:21 +0000.
> Anything received after that time might be too late.
>=20
> [...]

Our autobuilds for ia64 fail for 6.6.145-rc2 (actually already for
-rc1 but -rc2 was released before I could respond):

```
drivers/cpufreq/ia64-acpi-cpufreq.c:329:27: error: initialization of 'void=
 (*)(struct cpufreq_policy *)' from incompatible pointer type 'int (*)(str=
uct cpufreq_policy *)' [-Wincompatible-pointer-types]
  329 |         .exit           =3D acpi_cpufreq_cpu_exit,
      |                           ^~~~~~~~~~~~~~~~~~~~~
drivers/cpufreq/ia64-acpi-cpufreq.c:329:27: note: (near initialization for=
 'acpi_cpufreq_driver.exit')
```

See [1].

[1]: https://github.com/linux-ia64/linux-stable-rc/actions/runs/2993223243=
7/job/88968683064#step:8:3100

This is due to the addition of an upstream change to=20
drivers/cpufreq/[...]` ([2]). As this change was introduced after=20
v6.6, it didn't change the ia64 specific driver that is still present
for linux-6.6.y.

[2]: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/co=
mmit/?id=3Db4b1ddc9dfe997a5f492fa3a36487f8e7a5de30d

In our fork of Linux post v6.6 we carry a replay of b4b1ddc that makes
the corresponding changes also for ia64. This is available on [3] (and
also attached to this message) and fixes the build for me.

[3]: https://github.com/linux-ia64/linux-ia64/commit/a4085ca68e49f49f962dd=
ff46a901ff3468574b8.patch

Can this be included for linux-6.6.y, so it continues to build for
ia64 as is?

Cheers,
Frank

--------------2Bd3SN7pVtRTUD80YGo5IgN2
Content-Type: text/x-patch; charset=UTF-8;
 name="a4085ca68e49f49f962ddff46a901ff3468574b8.patch"
Content-Disposition: attachment;
 filename="a4085ca68e49f49f962ddff46a901ff3468574b8.patch"
Content-Transfer-Encoding: base64

RnJvbSBhNDA4NWNhNjhlNDlmNDlmOTYyZGRmZjQ2YTkwMWZmMzQ2ODU3NGI4IE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBSZW5lIFJlYmUgPHJlbmVAZXhhY3Rjb2RlLmRlPgpE
YXRlOiBTdW4sIDEgRGVjIDIwMjQgMTk6Mjc6MDcgKzAxMDAKU3ViamVjdDogW1BBVENIXSBp
YTY0OiBNYWtlIGFjcGlfY3B1ZnJlcV9jcHVfZXhpdCByZXR1cm4gdm9pZAoKQ29tbWl0IGI0
YjFkZGM5ZGZlOSAoImNwdWZyZXE6IE1ha2UgY3B1ZnJlcV9kcml2ZXItPmV4aXQoKSByZXR1
cm4Kdm9pZCIpIGNoYW5nZWQgdGhlIHR5cGUgb2YgdGhlIGNwdWZyZXFfZHJpdmVyLT5leGl0
KCkgaW50ZXJmYWNlIHRvCnZvaWQuCgpSZXBsYXkgdGhpcyBjaGFuZ2UgZm9yIHRoZSBpYTY0
IGNwdWZyZXEgaW1wbGVtZW50YXRpb24uCgpTaWduZWQtb2ZmLWJ5OiBSZW5lIFJlYmUgPHJl
bmVAZXhhY3Rjb2RlLmRlPgpTaWduZWQtb2ZmLWJ5OiBUb21hcyBHbG96YXIgPHRnbG96YXJA
Z21haWwuY29tPgotLS0KIGRyaXZlcnMvY3B1ZnJlcS9pYTY0LWFjcGktY3B1ZnJlcS5jIHwg
NCArLS0tCiAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDMgZGVsZXRpb25zKC0p
CgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9jcHVmcmVxL2lhNjQtYWNwaS1jcHVmcmVxLmMgYi9k
cml2ZXJzL2NwdWZyZXEvaWE2NC1hY3BpLWNwdWZyZXEuYwppbmRleCBjNmJkYzQ1NTUxN2Y4
NS4uZjY5MjcyOTA2OGY1ZGQgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvY3B1ZnJlcS9pYTY0LWFj
cGktY3B1ZnJlcS5jCisrKyBiL2RyaXZlcnMvY3B1ZnJlcS9pYTY0LWFjcGktY3B1ZnJlcS5j
CkBAIC0zMDIsNyArMzAyLDcgQEAgYWNwaV9jcHVmcmVxX2NwdV9pbml0ICgKIH0KIAogCi1z
dGF0aWMgaW50CitzdGF0aWMgdm9pZAogYWNwaV9jcHVmcmVxX2NwdV9leGl0ICgKIAlzdHJ1
Y3QgY3B1ZnJlcV9wb2xpY3kgICAqcG9saWN5KQogewpAQCAtMzE2LDggKzMxNiw2IEBAIGFj
cGlfY3B1ZnJlcV9jcHVfZXhpdCAoCiAJCWtmcmVlKHBvbGljeS0+ZnJlcV90YWJsZSk7CiAJ
CWtmcmVlKGRhdGEpOwogCX0KLQotCXJldHVybiAoMCk7CiB9CiAKIAo=

--------------2Bd3SN7pVtRTUD80YGo5IgN2--
