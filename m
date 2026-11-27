Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.70.43.23
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795809328;
	b=T0zZi2XR7bENBoG7r/GfNQFYl3tZaTF7BQFhYwq4VraEk4FXHwS/SeB1CgiI8z9dngXO
	 ShCg6M1FQFqFZmX9Vbk6jMAHH+aIZAbAI95IOcUQYzaQL2wU4PtJwIdKEjHXrnTw5IuPG
	 Zz61lBKNqe3Xq9tXEfjA3UQw9V9NWHJlMLrFix7Ohjs1+q240y4zH4hf7bCSFcYLkBKfB
	 Xdd6ExNFI6HSfvvhbvIOZhCy2insoNS+A63og1NEXcOLj80KiTXo6Kr9y2PAuHZUe+sMq
	 kYKrogPdaSbyam/Yu6wOdCTxulvwHUxdfO7lp6kXLoSnKwo3zXtrms6KjikztBSFywA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795809328;
	h=DMARC-Filter:DKIM-Signature:Date:To:From:Cc:Subject:Message-ID:
	 In-Reply-To:References:Feedback-ID:X-Pm-Message-ID:MIME-Version:
	 Content-Type:Content-Transfer-Encoding;
	bh=fkQY6VZ/0h/idxvC/1WqFbQT7o0AFUBBKssnmY8TGSc=;
	b=tfQTKWWuhT3RqUFZGE7GeV+OowPvJF/C6/nVaXeoJssKJ6SO4rFv2W+EvRErEotWcx+D
	 BS5CoK5HpA7y4ndlWyggdBeLZ8freIYLER8i3cOW6dh85XYJNbRTLyQbNFkmP8xaMidp2
	 ElwL9uOQi+TBhRByrfaMaBoexqHSAKuOB2+s+RQulGVjVWEa4p+5srz9U8TFkKGhZrLjA
	 8BJbJBlbXikJFPWeUOZTUGKb8AZ5dDvHN+MSxYJQtgk6bPF4dGXaJ14gOUu5Jq6WytMlC
	 jPLewtkGgsYi3m/tK83pV6L1x91iJyhYDchIToEvU7jjckqVEID7S4Sq33rb6yGUjoA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linuxtx.org;
	spf=pass smtp.mailfrom=linuxtx.org;
	dkim=pass header.d=linuxtx.org header.i=@linuxtx.org header.a=rsa-sha256 header.s=protonmail header.b=HJbWTEOZ;
	arc=none smtp.remote-ip=185.70.43.23
Received: from mail-4323.protonmail.ch (mail-4323.protonmail.ch [185.70.43.23])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40E7E606A31F
	for <patches@lists.linux.dev>; Fri, 27 Nov 2026 19:55:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 40E7E606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=linuxtx.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxtx.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=linuxtx.org header.i=@linuxtx.org header.a=rsa-sha256 header.s=protonmail header.b=HJbWTEOZ
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxtx.org;
	s=protonmail; t=1795809323; x=1796068523;
	bh=fkQY6VZ/0h/idxvC/1WqFbQT7o0AFUBBKssnmY8TGSc=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=HJbWTEOZRJTVoRGGfDy1HPjtdY6kzwYlvPhvX9BKHOQcrKlbT1dZlQaJHyYCDC1kI
	 NKTZMxnQ/B38GYzqb1g8jG6bXK17mPhAw6xIZdv3UvxRrt+ujM9LdRqPd4g0joN/li
	 /gJiPjmAIuTnsA2Tb7zYz202Q9AaU+vJ0Bas0rbVBafERDvHmrI7EADP1Gwe83F5rq
	 U8fLaNo2UJ0PCIfiW/Jcdv/W8dWHd3H6vfeGY81sB9EIUFAqqS7tKnY+YvFS6R9Ngw
	 kbXiiQCfr9RTF+67Fp289XTrFsUbi2zUtNFjS0it/VYNySadFjuFxvK5RL21klOMlg
	 Spsco77Yz8R0Q==
Date: Fri, 27 Nov 2026 19:55:16 +0000
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
From: Justin Forbes <jmforbes@linuxtx.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 7.3 0000/1002] 7.3.7-rc2 review
Message-ID: <awngG2KnDlCc8R4u@fedora64.linuxtx.org>
In-Reply-To: <20261126105729.110697432@linuxfoundation.org>
References: <20261126105729.110697432@linuxfoundation.org>
Feedback-ID: 225434474:user:proton
X-Pm-Message-ID: 93c12147b67152d10b0c16f1e4f843841e1bb3e5
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 26, 2026 at 11:58:20AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.3.7 release.
> There are 1002 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Sat, 28 Nov 2026 10:55:59 +0000.
> Anything received after that time might be too late.
>=20
> The whole patch series can be found in one patch at:
> =09https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.3.7=
-rc2.gz
> or in the git tree and branch at:
> =09git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.g=
it linux-7.3.y
> and the diffstat can be found below.
>=20
> thanks,
>=20
> greg k-h

Tested rc2 against the Fedora build system (aarch64, ppc64le, s390x,
x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>

