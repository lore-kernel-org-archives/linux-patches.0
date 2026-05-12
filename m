Received: from mout.gmx.net (mout.gmx.net [212.227.15.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3764C355F54
	for <patches@lists.linux.dev>; Tue, 12 May 2026 19:53:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778615629; cv=none; b=cYhMLmc+eQf3d0cxY7+GD6nr5+Rx0a1buBX5GtIf17lZdH0zEj1+HKAKzZfZ865HcySMfjKhm1am40ZN37APKz0Qv2KN6rnHMJb2wRmceoe6+fwirOsmoO+j2L0cm42hwueTN98bxogVIm+LGjvyQ1YKLuKqlxtejOqp2K5qkas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778615629; c=relaxed/simple;
	bh=wnxqki7Lt6sblGVNFGncwg9M+lU6iNwwpGsXriCj8ks=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uWK3BFcs7UN+CxX+ElRgT2SOv7D/GkebTJqSVvOWNhmtVRVypzNY9H576Ua4qjxEqbu5N5WghliDQTs/amDVGYFyzVnkaSDInQjRnNa89wFF3N9JFxQplzHkdkhSjEWcOkywYO8pgLG9PV9upT0sO0+PqniOL5WcOXSoOexf74w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b=KZH1DUfD; arc=none smtp.client-ip=212.227.15.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b="KZH1DUfD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1778615595; x=1779220395; i=rwarsow@gmx.de;
	bh=OgVfsQ2cLYvVhlt2ixFcHhojQgamUmeFhWpNvrgueZM=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=KZH1DUfDa/BpznNqzZbT0fEy/EfUDh/WnLH5X4B+bZRIHBLRP+Tt/Xm7GV4wBAWj
	 AE8wR30fStXAZxaU8+kUfcOPvcRZU6HRceFzh/0C3QJsFZ0Xs+mUFq3MRxsuPslIF
	 y4jDdsbFzCA0Km4Xx/b8I5edqi0lOz9pfTQoWRwtRtDR1NFWrOGBIN3XSvfBLl/py
	 TYUFFb6K/h3ofTBfuUKBc6NJhIhIbvTWAg/UcBSgdz4O5iD/uB6l/OPtUvniRlvuU
	 7NBCrLDPpLdBL8a/+Y4Zxk0TUXAe0LP4d4TwAKMure3oYWumFsnuwQbaRdjJAyCDO
	 lNmU5+hLt6yfjvNpFA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MjS9I-1x6RZw3HEQ-00dN33; Tue, 12
 May 2026 21:53:14 +0200
Message-ID: <bc95e796-6523-4587-9c1b-5103d69e68d0@gmx.de>
Date: Tue, 12 May 2026 21:53:13 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.0 000/307] 7.0.7-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260512173940.117428952@linuxfoundation.org>
From: Ronald Warsow <rwarsow@gmx.de>
Content-Language: de-DE, en-US
In-Reply-To: <20260512173940.117428952@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:4vf5m9lG5yjrnadiGsJ2/Y+FWNl/1hAPCrgF4SoDBkO7VnuGq6t
 raKLfyXVDfP9dZg6cRctzSlnbZdwCoNAJfYJ1L2qcBU7k/ob3L0O1DuA3QS7dREy4w5JNLf
 JVVweR4v0r3W+QvEtTA4FJJjbSk6fM9ii4qeKtBMCMFsY7lRTJLx4qxiE9Z3ONxdlRpMwjy
 ST3tFdRN4JQXMVA9RdkOQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:Hp50n/cmhYI=;/LqsIuCwPS2FH8e69RLY5Ya64SE
 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

Hi

7.0.7-rc1 does not compile !

=3D=3D=3D=3D=3D=3D=3D

error:

In file included from kernel/sched/build_policy.c:62:
kernel/sched/ext.c: In function =E2=80=98bypass_lb_cpu=E2=80=99:
kernel/sched/ext.c:4019:35: error: =E2=80=98donor_rq=E2=80=99 undeclared (=
first use in=20
this function); did you mean =E2=80=98donee_rq=E2=80=99?
  4019 |                 if (task_rq(p) !=3D donor_rq)
       |                                   ^~~~~~~~
       |                                   donee_rq
kernel/sched/ext.c:4019:35: note: each undeclared identifier is reported=
=20
only once for each function it appears in
make[4]: *** [scripts/Makefile.build:289: kernel/sched/build_policy.o]=20
Error 1
make[3]: *** [scripts/Makefile.build:548: kernel/sched] Error 2
make[2]: *** [scripts/Makefile.build:548: kernel] Error 2
make[2]: *** Waiting for unfinished jobs....

=3D=3D=3D=3D=3D=3D=3D=3D

if I do

git revert eb5b997dadc51746b5db031be1e9e7c19646c317 --no-edit

(NOT bisected just reading through the patches !)

I find no regressions here on x86_64 (Intel 11th Gen. CPU)

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>
