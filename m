Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=80.241.56.152
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793015376;
	b=gHZJthcgXgMwrzJNvevS07ERb+g92+S180TO/owxgQbsIqZ9OXvY8N+0Gt9V4oHka0YN
	 ezWMZl7YeYk157wTKVqytrw1bryWC9Qmn03J+aYBDgXgZYjLmewatX8Wn+nOC+9bMWrZS
	 dCKx9gbzJ2ugfav55oBYhm6nqvZpU2cpjmZg/y2Tlh2b0PmNNyqAc7wJsx3z+QOdnzDxN
	 QSq7bdjIvnyGZrz7o0dB2iULcS7cUniIgPclLBAnOQghcW4vldBYdcsLD+DfqET1C566O
	 Xr4XYmAZrXB2qATwdQiNjkqKkKkZybLAIhSbDyy1aeqIJ4P+blI2PUE/eiYWuU72Sew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793015376;
	h=DMARC-Filter:Received:DKIM-Signature:Message-ID:Subject:From:To:Cc:
	 Date:In-Reply-To:References:Content-Type:Content-Transfer-Encoding:
	 User-Agent:MIME-Version:X-Rspamd-Queue-Id;
	bh=a7TLIJCL99c1ZhDV5heRe9CmViAfluiDcfto6qloZKw=;
	b=ziikwHK0yanFzW8Yrw3XLDY0xKZR4I95/dTyl2G0nQvf1CsLKwl3Y/O6lZbTa5bI0obL
	 /JLZxlsBe4ECsxszcfWOxGqQm/HFQsd6Q5r0vCMIei9rQS9bRYVpz0ZQKlWeqluX/Wab9
	 XVL+g5e3Aizs4sMl6FiLAStibXkkx6ap26kVZfsbM97aTb/DxYqQR6ALzgouJC3UTKZ4G
	 0fG8YJvqR2IRzSNLBwYcSPtKykuXexIwI59baR1QAwMLeuSEo9cVptUn9bg2RmdB5PyfC
	 dRLABg58oYtDwaytpnnZqOE0k5bEXQRytNGkoFH0B0GHhu5fpiHPWkO32vuMrbD9bmA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=steffen.cc;
	spf=pass smtp.mailfrom=steffen.cc;
	dkim=pass header.d=steffen.cc header.i=@steffen.cc header.a=rsa-sha256 header.s=MBO0001 header.b=sPB+SWil;
	arc=none smtp.remote-ip=80.241.56.152
Received: from mout-p-102.mailbox.org (mout-p-102.mailbox.org [80.241.56.152])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE3A1606A31B
	for <patches@lists.linux.dev>; Mon, 26 Oct 2026 11:49:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AE3A1606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=steffen.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=steffen.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=steffen.cc header.i=@steffen.cc header.a=rsa-sha256 header.s=MBO0001 header.b=sPB+SWil
Received: from smtp1.mailbox.org (smtp1.mailbox.org [IPv6:2001:67c:2050:b231:465::1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519MLKEM768 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-102.mailbox.org (Postfix) with ESMTPS id 4jCsNp5VjRzKp3J;
	Mon, 26 Oct 2026 12:49:30 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=steffen.cc; s=MBO0001;
	t=1793015370;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=a7TLIJCL99c1ZhDV5heRe9CmViAfluiDcfto6qloZKw=;
	b=sPB+SWilMEdhmAcVzOR1KldJWqSXEuGMTyhjj6SV3jokuL2993fgeDFfZRILv4RTlJsDFI
	0QmOFZKQdhBeBo/VejlPoGlFHp88ruaDgmEJgvoxZPcCV4QCAo7O57o5MMvnWGXmvRQV1U
	7x5gq2T7QUAioUpCe7nPiUw8TGHXWcoL3vLkkDnE8elIkh+5t7MDwZXf/n+EoTMMyhE5NU
	7xaptqxeDvgJMfKqJ3TfIlOzNrPioOIu9PHMVGrUPvtBCorJIZ0rI4bQVuRyeAn0UiIQ9X
	Iq06Q0sOS5g6UQqZuIreoKp24xyg5kS73E5B84QQjwWMv9wc58Zj2/Mqj3WH/A==
Authentication-Results: outgoing_mbo_mout;
	dkim=none;
	spf=pass (outgoing_mbo_mout: domain of lists@steffen.cc designates 2001:67c:2050:b231:465::1 as permitted sender) smtp.mailfrom=lists@steffen.cc
Message-ID: <547b16d9ad02fa189c068624bc0ccbb0d3924b30.camel@dirkwinkel.cc>
Subject: Re: [PATCH 7.2 000/231] 7.2.13-rc3 review
From: Steffen Dirkwinkel <lists@steffen.cc>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@nabladev.com, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 	achill@achill.org, sr@sladewatkins.com
Date: Mon, 26 Oct 2026 12:49:28 +0100
In-Reply-To: <20261025125805.309934791@linuxfoundation.org>
References: <20261025125805.309934791@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.62.1 
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-Rspamd-Queue-Id: 4jCsNp5VjRzKp3J

On Sun, 25 Oct 2026 13:58:45 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.2.13 release.
> There are 231 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Tue, 27 Oct 2026 12:57:40 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> =09https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.2.1=
3-rc3.gz
> or in the git tree and branch at:
> =09git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.g=
it linux-7.2.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Tested on 24 device types (arm64/amd64, booting, general system tests, rt).

Tested-by: Steffen Dirkwinkel <s.dirkwinkel@beckhoff.com>
