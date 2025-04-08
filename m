Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.17.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A6E7268684
	for <patches@lists.linux.dev>; Tue,  8 Apr 2025 12:30:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115421; cv=none; b=RH9yt3V9CYAXllpBqYsMflFIZ5SMXIab6ax915MNibQiYwI9N01igXEVJHNdn5mjB3RQyT12qkKmOD1RE9h4Ll1e4H7XA8pwIsYICyuTlCDh6T4ObrS5Vqff/6GEG507hOdqpkfno6RiKFTAthXQmDEF9H/1lQAxjTXbQDxk3Ns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115421; c=relaxed/simple;
	bh=A6GH0730N9005FvryT+2f/BKLA9sdTWfH/OfPZwZa2A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cIps40Vjh0db7B539ptA34dTn/e6hdvv6zB1vCjBJnu0wNpV1WJwfgWF/QezoXyd0RZI321uNGJaMhzrtierMXKaxzkt+xgL6fHId677MKDqLZRAS2moVXCZjf/6HCiVYxwRQTdd5FRJhg/axCGTbJvSWzoo/tnadbr/Ii0o7zQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=heusel.eu; spf=pass smtp.mailfrom=heusel.eu; dkim=pass (2048-bit key) header.d=heusel.eu header.i=christian@heusel.eu header.b=zPT/MDja; arc=none smtp.client-ip=212.227.17.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=heusel.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=heusel.eu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=heusel.eu header.i=christian@heusel.eu header.b="zPT/MDja"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=heusel.eu;
	s=s1-ionos; t=1744115412; x=1744720212; i=christian@heusel.eu;
	bh=u+/mqDgKSZDwMA/1OefEMZrRqMdUu66MZ8QDf1kcPGk=;
	h=X-UI-Sender-Class:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:In-Reply-To:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=zPT/MDjaF0X9V4jQHb1LIrjvIAYJLwhL5w95sOvt74AxLQt5r1YWWeuFXkAoqxWg
	 dDrqlNBCj4+hjDmZY3f7SJOICIhJbfzvdOO6ZqzJFAEofI/vHfLj74VePpLju+OvO
	 YuCsCgFfNYT4ael1hdNz8OFDbPaaG5GwWw1+cF182ZpkBXF9A1N3dJYFACID2SV24
	 WFmaxys4NGP2iX37wPQzMTculMAWNEMNOl5s9ti/iY2WfR+XZLnvJQxp2JaPjK+21
	 KUoBY1L0zGLtzp44l0QZlaHR/M4RN9H8Uvgoa2myMFVDbcYfq0iYmRTUAD1XdAs1D
	 aVAoe4FTdI/mybWM2A==
X-UI-Sender-Class: 55c96926-9e95-11ee-ae09-1f7a4046a0f6
Received: from localhost ([89.244.90.49]) by mrelayeu.kundenserver.de
 (mreue108 [212.227.15.183]) with ESMTPSA (Nemesis) id
 1Mlf8e-1tKr632Xbu-00g04s; Tue, 08 Apr 2025 14:23:53 +0200
Date: Tue, 8 Apr 2025 14:23:51 +0200
From: Christian Heusel <christian@heusel.eu>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, 
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org, 
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, 
	hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 6.14 000/731] 6.14.2-rc1 review
Message-ID: <fc727793-7b2d-4cd8-aca4-78824cdf477d@heusel.eu>
References: <20250408104914.247897328@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="lygmlimbjvuadv2e"
Content-Disposition: inline
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
X-Provags-ID: V03:K1:xJLObfOIsGYs3G9tzv2KxMMPmxROXgzsfdd5jG9ok1TZhiuAdR8
 9BsmlSVv0FfEC93stkg8tdEDL1NEmeE4kLG1HoH6tG1f4FRRTvBxr4lQovuGOoGi/uTXWaN
 vkjbFl2dbS6czVvPg97OqYyP42+vA3HzfNIzpqTX3qh90h+gzBfU0YKxHFEEM7i0qGBAN+4
 96Ccy6FG110v68Lr2cDqA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:qmYPEFNcSZg=;4UanF72B11xaAS2i0XEyguF/YLk
 d+SglPUIE89fDgidXDfAdfviSnaVxJfcw8XZftcRmrcbt6LZESs25xPdIDYwFVE9CPguKvenK
 gcmvm3qTS0QhM+0QEaGKSX+3FYHUmEqjJoB3So/i0WJKxLvfXzhIErtRFDP9PPXH2OEd2W5/+
 MZxPngP+Fn79Edh0u2h+47aLhTLEo2tjGK/vsIcXXOu2q/WOd1rYOYf0Y6oIhUOKmSQmvFIJl
 rxP73Ctg4DHftwk9R/e0FcerahclZG0+0RBpKg9BjRk7xogJKO6UGXR4Od9LtPoG0kdQsUi9U
 lVNmIKlTHFEQAtB7N2LMB3IdKpJOI0Erdj7djT4bGW6NljTRnryzv9lw03hye6KeDyvadywUE
 SHEN04ZJqE8EJt0frVUoCs2WFaKu8vkzqDXEFMjn6GG0U0L7JHuEwHf5pdXq/jWtNeryaLBBp
 eEAwH3WQMwz8NLxfU5sZ+eJqxOZ91UiYubJcogDh4D8VjD8qP3wKELcmztlZxr6q/7bX35J76
 6zAOrlBH0aHCKDZKEx2TU9kGVli1TWh1gJvGZHuyBhoJmwlDHtpO5gBLCiJEe0c2P4H5x7SFw
 dn6dQZTQtiCFfX534TZfXn2vlHFfWDe7wEaMXNPlWsiE7PN9iLwCtsMxZN5HVSR6xuor44QL9
 Rwl5+LYoEncPYB2/eGdwO2gEuvDu2S66vQ2e9Xd0Juuk9vzuNuwG8rhwUpPFhE8jJPNpkRry5
 ACMsA/QY5WULQddsLMXtVAfqp6QTfrFolWZQsRM8fPgODaeB0wX0ckTe8Mc6lf6xCIhMD6+tY
 vI1rHOPoQgAYdolIkwarqGOaBz976lEdlZpqC2RcbIzUmeQpnEb4E2K3VQ40CP/lHqS1fDwM7
 42NY+dmjfPTbMrLfheBUNY41LrfsMAwkH8yvIvPpr/uQz8Z1ZYDm8k0V04FkoTQvUrwqYC3JN
 S+elC0eJQz+Q/r1LAmHC3WCwL2w9WyQhqCYf31b9KbgzQqZ7yDDCrzBdX/CpMVcdpnuGYq/u8
 Vw7RP4E6fnAIKMsheCQnlqPrv1kNLi7/fwfW7K2pa35hftGVqSXJnXMKMQ1UraiJc3wjX0yce
 ENHL5Wz9nl5x/RrbbDudZga4PewYXZnFJD1qmh9vmAlhL/ZpohGMoAcV25j6eb/r1tbDKgBSS
 KMfn3Av5/qc56xOYkMvch0Y8859FLUgp1OugdMx3znzCGMKlWK0BE3o8Zh4I2o7R8daL47AGJ
 29oDaGh66ET6MZBc5mLK3y7CN7k0oMmxOaNIe2BNdLvxgLtT2S7/dG26UEWEBCJ8NjinFnJNU
 BTvPpFE3k8CvhkwSF4DfG1mx2XsZ6sXhOYk7dQHjow+P7sJbPOtDbICRAOT0vQKJLLkVJhNrS
 ibIfDbde+lpfUX5R2u2rQSmZtD8RQeFgxTlFk=


--lygmlimbjvuadv2e
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Subject: Re: [PATCH 6.14 000/731] 6.14.2-rc1 review
MIME-Version: 1.0

On 25/04/08 12:38PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.14.2 release.
> There are 731 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 10 Apr 2025 10:47:53 +0000.
> Anything received after that time might be too late.

Tested-by: Christian Heusel <christian@heusel.eu>

Tested on a ThinkPad E14 Gen 3 with a AMD Ryzen 5 5500U CPU and on the
Steam Deck (LCD variant) aswell as a Framework Desktop.

--lygmlimbjvuadv2e
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEb3ea3iR6a4oPcswTwEfU8yi1JYUFAmf1FVcACgkQwEfU8yi1
JYVj0Q/+JQVAUATBuO7W53RKR8zORwFzOoxqEgviNSJtEnpew2jG+G4ZmVZvO+fW
9tF2nc/WpxAXUZzZ1wLAi0jZzvoVWM5ays5d9a5Jj3D6n4kPDNMPfwowt81xOo9P
drgrB/Vl0jGc1kkCE04YOtYB+fCuZIpP1K+WS/uBvaqh4J6+CaOyZOXjEUYzfE2T
HsoucAsHxkuPN/NRJjKQJysUdNTDYY7NDOBKDDdIGhXjDj3Myhr8dYLHGBND2Fmg
EqH7sRiEvEjAH6pK3JJ9xV0K4yASct7vBK/I0KnnrCvnNltKRjC5XYqkeuSi78Nc
3RYstQu2mCaWCVuT/X5XwLCkGt+x/V7v/QJ6SOIlKiIX5RlDaBqxXfuSF6pVvcL3
w04fJKP/XKY01clO5tjFwJGFgKKPjNmHyrpL4r2rtTuMeQ/qjnW1in4VHVqEVPEq
1S6elZ2U+JM1QiC7mTJa/+LzD4C/9KxvurmhhdODyQDo6ElY8KdDX2cGd0VUs/Kn
RE+Eqrimctxh1wgQopppsuc797ApdhlB4q6oP6SdhIBhx3n5gfqtboYnggNr0bqE
agtXY8qN7rJ8Di9TLPkqjaxPHsaERs7+lkUg6YrDrh8W2o5HVVN8nZX6uLoPCFJO
Vml/77goY40D7GXJ3iinV20KKLABQGLkmQjnXrlt8C0P8BEY9pw=
=EA18
-----END PGP SIGNATURE-----

--lygmlimbjvuadv2e--
