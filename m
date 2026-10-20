Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792508206;
	b=ZPHV3IgWls7QXZRh8KvZmezlvOIZ+zrtoTMP/6k2S576JTcxOae9eE332oyWTUHJiCnx
	 mGZLublklNLv9U1QEBe1/5dz0o8e7S5xzy8bPKDalNGhOhhPWbHkYRt+wwwRaWbxsbGA7
	 /hbNwUG7LIVsGom5sswnjIIukXt6avtW55G82gqDcT0M25rvs2F+2Vx4CwozZ1kvMxSH+
	 TZwCrxI/BZRLAISsAhEnjZVkCM6V1iyBYGUp+5w7uUVrET943AUd1fGNl9vf2cWiAMYMY
	 xKiE3bi2xhtkostQC4bvDBAejwlObW8zQa5pO5ngUlj9RxMxhB8Q+uaPpYUEGzIp3dQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792508206;
	h=Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding;
	bh=WG1H7zilQUplVjHs8//MBUQIZ/J4ewY7rh53PcOwtfw=;
	b=DMI4PIDbNc5YO7+sZCtTRu9fJ91d0/6YvoNGeEFxR6diyfo3FRRIZFnAEPkZvT/rt2wW
	 OjEiK2eww6T3Bt+4mitG+nm7W26llQuEv66lAaaV3Nt0xBelSnGdsojFahDwCvmJqJZmm
	 IH1216q1D9X0oPNsStWEwuQCEMBC1iHO/ghelGiRSiRG1k8UQOOe20SwIdQNirJ0eGAjx
	 7fHB6KeV/v2vo+iGRuBC8InnSQR/CM4TT5ds9yiN6WdPMxW6Kzw1fkOf3wx0/VC+NFiND
	 Bku2Cb5MxUdkC0zbFsKKe+94O0BHb1l4E58D20kt8MGpZCKf7e0SEnLj2GcrSGaefMw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CBBA606A31D;
	Tue, 20 Oct 2026 14:56:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D6931F000C6;
	Tue, 20 Oct 2026 14:56:45 +0000 (UTC)
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
Subject: Re: [PATCH 6.6 0000/1651] 6.6.160-rc2 review
Date: Tue, 20 Oct 2026 07:56:29 -0700
Message-ID: <20261020145630.89623-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261020075535.084584701@linuxfoundation.org>
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

On Tue, 20 Oct 2026 09:57:46 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> This is the start of the stable review cycle for the 6.6.160 release.
> There are 1651 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

This rc kernel passes DAMON functionality test [1] on my test machine.

Tested-by: SJ Park <sj@kernel.org>

[1] https://github.com/damonitor/damon-tests/tree/next/corr


Thanks,
SJ

[...]
