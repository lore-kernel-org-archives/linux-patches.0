Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=89.58.18.167
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792953228;
	b=uJbgm49+uvV9myNKR+c/ksf5qT0zU2g0qaQGmiUkCDqZGlYwc1hyl/Z6NLLv6AsElY7a
	 xIKCS7tpuWkrrG0snomlK4r3ppuU/5lo/5geNHD3kHY6y5tiRSYEjFkjfReudmCxQn7Pf
	 tvLNsZQZYa68M7P6NBr4liTUa7twsV2qfesg5TIEE9LwHVVmkzdxAe/3Vwgbng+GSp5vw
	 9zAbRGJYfpk7b6FEtqJHxv074pvosn6diDp2Nc/R+AMwk2m0ey9ET7Aklhy1DOneb8Kq8
	 KZpmt5waBEVWYMWmh0Ay/gHnzkZXQoVRLQSd7p0fdWjhu8lMS5Zvia1l9O0gpnENIVA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792953228;
	h=DMARC-Filter:Received:DKIM-Signature:Mime-Version:
	 Content-Transfer-Encoding:Date:Message-Id:Cc:Subject:From:To:
	 X-Greeting:X-Mailer:References:In-Reply-To:Content-Type;
	bh=Ueuv7cPaecuyLqONQlbjgiSDlUSKnsZNNKqCbxGlagU=;
	b=0SvvyKhsxlY+cwjlh0824L3eIGiHXOK5Ejo7qWP3hjmLJzN3vhdMVEZOkdLw0tZfjeKq
	 YuNG8E9lGLghCJhWG27Zo74xN2ZQCAPTvWaotugUCtfkSFp4p0nk67dXeLmIrL9kWukNb
	 p4IzHJVPk9+3IgCmxyufZMlEwAOVxJ3rO9Ak/JCyH0gdfz0F9z7brWPoTstmEYGNAKpel
	 3nwwe8ZiTxC8K2M4rnPbfH/JBd7gNez3ykJIvRfiGd2Fu53VPsqT63DDn3ClnzkwqEUHH
	 jiAExJZ8yHEMbX3sJh55Sz0Bs9sZd93HMV6DMMsYNQo/YDcQSZo0iM7wfOvc7CIRO4w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=achill.org;
	spf=pass smtp.mailfrom=achill.org;
	dkim=pass header.d=achill.org header.i=@achill.org header.a=rsa-sha256 header.s=mail header.b="rpPyIj/v";
	arc=none smtp.remote-ip=89.58.18.167
Received: from mailout02.platinum-mail.de (mx02.platinum-mail.de [89.58.18.167])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B3E8606A31A
	for <patches@lists.linux.dev>; Sun, 25 Oct 2026 18:33:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5B3E8606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=achill.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=achill.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=achill.org header.i=@achill.org header.a=rsa-sha256 header.s=mail header.b=rpPyIj/v
Received: from [127.0.0.1] (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mailout02.platinum-mail.de (Mail Service) with ESMTPS id 646EA9A28FA
	for <patches@lists.linux.dev>; Sun, 25 Oct 2026 18:33:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; d=achill.org; s=mail; c=relaxed/simple;
	t=1792953216; h=date:message-id:subject:from:to;
	bh=9wB0E5yDXm3uCEDhnZZND2lq2G++pGSalRP/LdEsX/w=;
	b=rpPyIj/vuAqG+9WjIK2Bntrx/SPM2ZcjwhbgWGCzkMroSF54iPxbRvQPwgBv14lgWbbGHEDM4BB
	EAC9hebHDEVvp+7rZxQoBi3ONSygGcY5WaH9KJGgTKr5ncU7Ma8IPLD+c5LjbgmmVyHcpaX8SgwHs
	3u0tisAChHTz8YoqUFokBgaDh8SpYhBLBdAFga2bsvy81arwNIRVMUcIeojvqBTy3kkyLMvg4qOM1
	IC9z6s4cLifVzcLl2DCBCNyZ+SHOD+ameisqfFZWGZfAY+4fpJVNzfTJn5KwUtvLVNgmEo9Z1NxS+
	S1lFymKxz03UGguNUqYs4LAt/r+IAjzAFVOQ==
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Date: Sun, 25 Oct 2026 19:33:35 +0100
Message-Id: <DME4VC8RNX49.3SSLD48HTOB76@achill.org>
Cc: <patches@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
 <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
 <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
 <lkft-triage@lists.linaro.org>, <pavel@nabladev.com>,
 <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
 <sudipm.mukherjee@gmail.com>, <rwarsow@gmx.de>, <conor@kernel.org>,
 <hargar@microsoft.com>, <broonie@kernel.org>, <achill@achill.org>,
 <sr@sladewatkins.com>
Subject: Re: [PATCH 7.2 000/231] 7.2.13-rc3 review
From: "Achill Gilgenast" <achill@achill.org>
To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
 <stable@vger.kernel.org>
X-Greeting: Hi mom! Look, I'm in somebodys mail client!
X-Mailer: aerc 0.22.0
References: <20261025125805.309934791@linuxfoundation.org>
In-Reply-To: <20261025125805.309934791@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8

On Sun Oct 25, 2026 at 1:58 PM CET, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.2.13 release.
> There are 231 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Tue, 27 Oct 2026 12:57:40 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.2.13-=
rc3.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git=
 linux-7.2.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built on all of Alpine's architectures, thanks!

Tested-by: Achill Gilgenast <achill@achill.org>=
