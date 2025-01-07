Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.17.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 388BA1DE4F1;
	Tue,  7 Jan 2025 10:30:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736245835; cv=none; b=krpk+2uslMvHyPhHOg63LmjLuHsbSdFttjLbxUF7Q3PdMnkfKfR0rsgBp/6hKJ1XENxziNtY081xjfQ48TbWs4CRLnrygfEABQzqaZcQ0EmWOr2s2UXVkjJAtfCi/GKOQbaLOsFKeEzj+b77SCzqrpMj3APvi1fmhC5Fg5jcCK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736245835; c=relaxed/simple;
	bh=2XgPbOnTQq06t8pLUvQn/Sa68Jw5XcKt8Gl+qefLhn8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XSW2rRgCAo8n/OSg2rytFVYnXY9ftY2Km9N2vVeB72mz0ejjk4gvDL26RwBysKzLnyH6jsJpLI6Z/fyPapF0c9sHx/BTbS8qBxrP1XtwShBXoIRD0enDXlGX4ww5nSXfgPjbVgr0hkgUjbVyutDOTLitF3R1gxi/qCGh7eY4+1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=heusel.eu; spf=pass smtp.mailfrom=heusel.eu; dkim=pass (2048-bit key) header.d=heusel.eu header.i=christian@heusel.eu header.b=mOfgP8zT; arc=none smtp.client-ip=212.227.17.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=heusel.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=heusel.eu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=heusel.eu header.i=christian@heusel.eu header.b="mOfgP8zT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=heusel.eu;
	s=s1-ionos; t=1736245795; x=1736850595; i=christian@heusel.eu;
	bh=Z8vr7W70GbfxUf5/Vci+71ulvRYTfJ4JAm+1PYrhaP4=;
	h=X-UI-Sender-Class:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:In-Reply-To:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=mOfgP8zTLzH1KF5NcALMjVMHyMUEtxYI0ZFiKR+3lBoyBBSEFXJORTkGz5ciPZEb
	 Isk0n11bFUHX9vUf9+oLf+Vox0V+ePXt+TT+oK87dcgjpsBUx3XPKBz45u3sgl+lq
	 PpnDezMSVKWs6Zhiuf+ZTJLlToKEOFYWEIqJ7WR1EhuQHVw3Xq7Vv4dM7cK/je/EY
	 O502RwxbGN8K5KtogF0pY4CyO5q7s9rFRgcLxUPwwJ9qhveyvi48yFoina9RsqDkb
	 20Ditu2mR/iem7SyEv+Y1sK9RsDI5BNwSSXwWzaaog5qoxIqGM+unGUv50zMvdd5o
	 4DFUbUO5oYNCM8N8bw==
X-UI-Sender-Class: 55c96926-9e95-11ee-ae09-1f7a4046a0f6
Received: from localhost ([129.206.221.31]) by mrelayeu.kundenserver.de
 (mreue107 [212.227.15.183]) with ESMTPSA (Nemesis) id
 1MTigN-1t1Fmg15xN-00Ksmo; Tue, 07 Jan 2025 11:29:55 +0100
Date: Tue, 7 Jan 2025 11:29:51 +0100
From: Christian Heusel <christian@heusel.eu>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, 
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org, 
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, 
	hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 6.12 000/156] 6.12.9-rc1 review
Message-ID: <92cb12c9-4c6e-4376-b053-6791ce147efa@heusel.eu>
References: <20250106151141.738050441@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="upiekvmb3x75q2xj"
Content-Disposition: inline
In-Reply-To: <20250106151141.738050441@linuxfoundation.org>
X-Provags-ID: V03:K1:55CIYtMPAbBaD889aOfT7rVzrzoLg/qGR7f0mqZsr4Za/d+8AwJ
 REzX2UQSq6Jxw/50jSicuqmjHPklIbnK0JfFLTFZFjs1aM2ckRUXQaMoVbGJ/arxs6ze+WP
 0l+iHnbvb3/mnm4Icd2ykvqJoKe+CEHf9re1TcMQHdwprpfI7pwq1AD9CgNLaIpyCe6UvJT
 n3cqV9pLu4EVP7NMpffsg==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:Hqq/drXZ/dM=;jabQrdfAfF9xs8HMnjF1b16Jfpi
 WYdHFrgz0akraSEqoa9T4ICH6+eRQfpPbXR1DEUNXH5Wfvn3tW0QbvewhPeLX5AHKAgXMhBqp
 q5tokFVX8GQbyPNTqby1EjnUKApgwQaS+iLoSfdFOOBN9IavbWZ7yOWcmWwSMgjloRW/3cpdG
 HRv7Jp8yblTJ4ZL7F5HMprPUPW3aO4NW4mvjfZDA08j+UFMT7X/XbXgGT3/p0uhoSl7ad0RqH
 DnPqIg77TWcJVhxyybAm7fWHVEcTUk1yxswvOmGqb4WxbsVvvB+ZkK2mIsWqgdqZJIn/PWsEh
 MuZe5Q27tp0UST8/zv45pcD2+TRM0mNOxzE2e47rlfC+zXLahRPBQq7J9G1rv7nrDQsV9b/Rw
 8MCl8FHPGWvKooIUZCrOrg1A9dTEIdUrrIZuW/A8BHd4I7t0gPFeW1I2SYgGgaPtcdqSSKzeg
 s5Z1LZn8K/MvRRqaPFDSLEu5vbrz/bTt36NDqm4+Mrb7GJ49S65YfW7DxVzRxgfIOQTrlDKc9
 pEHRxXYgTheo0wqQtxXABFrbedOZklh5+n5ZKRQmt3hZLWjuT6i0dC7/lb4PeI70G7Vk6uQj9
 qeuMjkFTLHwCaTYGSTj/61AcXqx5rFZcm4jdF26xW4p53nO1meFXdu+4OQqJ3pRniVguwBk1b
 0PL/kE+FqTk0R863nDRw5S4du/r7r70GD2nyJiDhOxr9DiSuYptOhLdywULKY8Jn+uFkqypBD
 sPxuSMQrEIvPTTDAq5YWrqHcCEJTjfPRAo4Z46Kl/jCWvYyQSmnwgQPJt7BhCTgiLdcuKW+3c
 YK0GYHXwFaAJbH6xHDW0KTJBYnYlD/5MTpnxnyULWv4NmaEnnOBTgtEWeaf0mSNzlFtGHebHo
 erx/D9XDfMupRmpXxCk1YnhiSdUeFywZpdZfPsFDHFOtpcRYiTMkwfyo15Rr6W+fndR4/fwOs
 ZD/Rbo3cIhxBOIiCYZ8q1AAh5skdJB3rl4ugKEQSYNwhiOg0UFy7u2Kpdr4JxrB0uEcpebORB
 X5fVmEseseqTvHrI5Y3HsUvL5uK2jad+iE10r+g


--upiekvmb3x75q2xj
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Subject: Re: [PATCH 6.12 000/156] 6.12.9-rc1 review
MIME-Version: 1.0

On 25/01/06 04:14PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.9 release.
> There are 156 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 08 Jan 2025 15:11:04 +0000.
> Anything received after that time might be too late.

Tested-by: Christian Heusel <christian@heusel.eu>

Tested on a ThinkPad E14 Gen 3 with a AMD Ryzen 5 5500U CPU and with my
Sony WH1000XM3 Headphones.

--upiekvmb3x75q2xj
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEb3ea3iR6a4oPcswTwEfU8yi1JYUFAmd9Ah8ACgkQwEfU8yi1
JYX/TQ/+ObBgY+Gn+xwXFj/DspDrUXyzfcLPFFYmg7TfrA9f5rZbbmtJFrQJ5TeX
iUSGGQK0yMVZ5mWfXp+8PUOcpb9Ft1i3iwBkm+hhpdmz9QnKAa5KuYWOh8a3rWHl
ZgUsz7+sSj3Q1czLS6QKc91CeKxwAbKqnw505BR7xku7+RqQgspNwxTs0AYr/H6h
mfbOsjPVr9mtWs/z92ERaRasHdatvSdmTa6LkIWsEdCn3LPbOCaEVkN72/y9iPD/
FMelGzxjvPtnOnUCUClgmMPPbWWnefPpptCKu1bIzetgTOzF9r5WBJxW5l333URd
Y5jHnwqVsM+EBQDmAA+5kFFaEmSDDb4VZ6eYcrbnrz03gsToKnG3dkI2MsYUHffD
EbSUNj+YDDCmHFxtMqxQUp89GjrVu4DrWtfO5ZfcSdAcS3J9WrSKRCvLzV2lMXsv
GRsDTimkCEesfh3GwqihO2I8VUd0uJu+knf/PYVqCRvitNVlSQrM0dKs4C0v8Rgq
bFwphDzQG7275RR1eM2swZln+LkdPsx++BLCO4wWszodws/6PbTU4mafgnbW0WHA
h4u/zxsIfyhV8IE4ufhI8K419cpdfXFIvQOhFy3eL1MZciFWEimm01MF38AtXILD
vahL3qRQ/YDfi0jKO5nknGoISb5MN+UG/uejrezTXKniBskStJg=
=wh1A
-----END PGP SIGNATURE-----

--upiekvmb3x75q2xj--
