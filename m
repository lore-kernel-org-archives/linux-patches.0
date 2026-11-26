Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795736307;
	b=4fYww1oruQP+eTCCNxZSfuI8bTYQrS9KIpM9uWOFcHGp6ICLtcZzLiUkbs/6mDYOVJLx
	 FBXPtLMTPmJz28vsysMDSnh4889ZmXZvzGdivvMVs21+qzXzTZuw3s0mfvZk/gzrVmS+j
	 p+8txtg060E37bwaSmM2niW8LbPO+g8dDty9IHaxo9hmLEsEJujVstknELhiiAHPgD5Kt
	 xIa8TR2B+br1DXP3e7YPfq8h6bLak2boGstHoOYRiLO1sI5gV7J+Te8R/R3N6l9WBH7Sm
	 6vWRgD56hb+wQfKXNX2zC7XzTUdQwktiIWTYXseWhkIKd9pg9U2TyZa+82l8KKwXfAA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795736307;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=DKCzH87149x8vhPQlayMwamBagGLaAh0aCTM4gSp8FE=;
	b=NLe+Aw2dDsV2CiytTOlAmYcN2J4asQ/BiqgYd68MgGVvLXu0Rva1666kigP5iVREkSlE
	 rcvQsP9Lfb0dRGthvemEkgQslHo9MiWP3kN/4oDh3q19al59eOhyltvrIU7IhIO08yLhP
	 8U9TCEZbkqADtFZd5FktOt5rzoOzfMdiKLD2LOYP4+9XeDysdIO5AJoOPg5DcNulMhq7H
	 sEnLEfYDx0wDyO3mSwhRaLPVNi/Rq4R2xJC0ZU023W/xSj/NVel5JGTqljKgv6prjHhb2
	 cOv3APFBxlBYSNqinjmpb7wsljc/YHTZnrI6LG/wvrDsQvhGj/KSNLyGTnoF/FJnNiw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=i9xRMe0P;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F00C606A31C;
	Thu, 26 Nov 2026 23:38:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=i9xRMe0P
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03E181F00897;
	Thu, 26 Nov 2026 23:38:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795736306;
	bh=DKCzH87149x8vhPQlayMwamBagGLaAh0aCTM4gSp8FE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i9xRMe0PrEi9w2rDOwN0jYAmbsGz7K8m6UMVyBfh7RK1Ipll/yq/aDBqyCNjcA+An
	 X4u7fv/az/7mU9vJp7lpsKbF6pTkQiYkaz8atFUXXiLMV2sPg1Li8WL/DpdP1h0sv9
	 MdrII6baOsutWPgOuZ2Or9Uc3SlokfWFpGOX3wHfXzq4MNxsECajcjlqcBTcf6n01K
	 Ju7A2/tP0XnxCig3caYmctvhhq+YzsNdZkYbD8Sfw4DhHOioSXUhoY19CjA1WJWPWu
	 uh6mGh1dBRlt0f/83+jclVb2k9PUUWfpH4Tsh70IEEHjcRDf4I7R0vTcMj9s2sihy8
	 NflOCn7V8G6eg==
From: SJ Park <sj@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	patches@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org,
	akpm@linux-foundation.org,
	linux@roeck-us.net,
	shuah@kernel.org,
	patches@kernelci.org,
	lkft-triage@lists.linaro.org,
	pavel@nabladev.com,
	jonathanh@nvidia.com,
	f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com,
	rwarsow@gmx.de,
	conor@kernel.org,
	hargar@microsoft.com,
	broonie@kernel.org,
	achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 6.18 000/990] 6.18.66-rc2 review
Date: Thu, 26 Nov 2026 15:38:18 -0800
Message-ID: <20261126233819.102839-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261126105725.767748294@linuxfoundation.org>
References: 
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Thu, 26 Nov 2026 11:58:43 +0100 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> This is the start of the stable review cycle for the 6.18.66 release.
> There are 990 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

This rc kernel passes DAMON functionality test [1] on my test machine.

Tested-by: SJ Park <sj@kernel.org>

[1] https://github.com/damonitor/damon-tests/tree/next/corr


Thanks,
SJ

[...]
