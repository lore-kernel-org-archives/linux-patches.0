Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795798949;
	b=PJDHFbyIsgBkoAswS96kjzIdXboC8bc0CQLmUr76xs/SGjAWA8EtPYc7A4xBBuDZnIco
	 W4xJFSjHn9vPbOj9EG94xzVklaGRNekpYLaKnxBMsla3/EtMeAH42D8FFHq6Ag5TOXlWs
	 ZGFO9X9wHkwHZ7znW8+DbzpUARkkdxXl5vQYbUeOhhnc++KTMs5TTJaK6jdxD+Wrg37so
	 AqLxkPn6j0frAOWavZ0yIJTJd9joaI0jg54Ie7+70QsUAMwtckEE+c6uLCHMFsiGW6dd1
	 E/4BZV2pb9GBGuJJnKdZWH4poXsqEpvnrfVl+3ErHWe2ZVacmGhPAwN3QZwbdWwTD0Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795798949;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=rqRHWMCPUPcUpt4oahsbrdE0iAX2lcuyg0b1LStYxo4=;
	b=ZdJ++XEEXLjDjQn1FgOWmpAkzvk0ClXVQLC7bP0FXknoyTIZeIEVAtS77pdfrxnxqf5/
	 3dCztZXNL06jsNI7qTQ0ORXyPqDCZr7K8wxXTY58BmQiLYsf4BA8tBfoAVUFbV+xtyNgo
	 Gpdgfz2uxUxwu9knQjuH5MfmEN2aimPaeO+p399sQmNelHfBb55JC4S7w81qFmVt2Vxj/
	 118iX89IScoUsNOKd0vuwbKWtG5NdcwhqehVDVKciCTIkrPa8lVrwONjyeV30v/ZKK4wS
	 gV+03XLbGIws4vYuSVrVkdipcuyNvBPk/9dKjnBqCNhkJ71tgeTievovSuCJISq+qEQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=I4tJGTrb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38D50606A32F;
	Fri, 27 Nov 2026 17:02:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=I4tJGTrb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AE451F0089A;
	Fri, 27 Nov 2026 17:02:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795798948;
	bh=rqRHWMCPUPcUpt4oahsbrdE0iAX2lcuyg0b1LStYxo4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I4tJGTrbij7SZpnflAgnC8LZimGW1koakXVWGJpxQOkXs6rJ2mBMchjPlmZqg7gNv
	 9MnCXFCdsH0gtnBEG8B7W/+9HI1/Be8FwhyXrX7W7fSwTlrINytHII6jo4UgCVwIhv
	 9XvDKP59IiL8/sa7Pr2xz6f/OCgd4xNBvyS3atTlW+7dKNTY6sLlDJ2cED8BqBNyma
	 7S4BeCK6oso33n9KiHpDV7jnZ3fheKpOH5NXkwDTGzis+i/wQPA185bR0xQZ3wWkyV
	 wHdI4rM/Shqgfar9qPklVR5Jw31aQ86mRax7AF9oZRR1GM2o5aNmfsrFvpGHuru6OS
	 RMM5ObjxOtaqQ==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sasha Levin <sashal@kernel.org>,
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
	sr@sladewatkins.com,
	Brett A C Sheffield <bacs@librecast.net>
Subject: Re: [PATCH 5.15 000/319] 5.15.227-rc1 review
Date: Fri, 27 Nov 2026 12:01:19 -0500
Message-ID: <2026-11-26-1-daily-reply-0031@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <awhOX69A7DAA_-UX@karahi.librecast.net>
References: <awhOX69A7DAA_-UX@karahi.librecast.net>
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

> # first 'bad' commit: [f1311182306c2b85f4724cb776467034a36baaa6] initrd: flush deferred fput() before mounting root

For 6.6, 386dc41cf54d ("init: flush async file closing") is now queued
there as well, so the queued initrd patch builds on that tree.

-- 
Thanks,
Sasha
