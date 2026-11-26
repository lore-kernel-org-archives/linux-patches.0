Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795732765;
	b=5hu4twS76m4kZlReq2cJdoXS01kIH1Hh2RGW4Xws0qrNzYsNvtGEcMt8CHZu6TQuTekC
	 3Esr2h3P4GYCeXr1RNhCArQ0Cbmt3rClIDLPDcT9LjlTxVdCMVQJ/bPaexWNO1cxWd62r
	 hezQzqwCd8i6ioBA93Rh8Df1bIw8cP2R8nB84DyCcQOJuFGogAJNQFahvRfOOo/94bjl7
	 HxDZ5zHcYlb1dZHrTJcWuR6qXUFj4i+Ojl2uPnOJB5dGdpDrwWyLijCGy2L3n+Ove7F0j
	 ck04FDEO24BaDYh47OQSNGvB6jQVK44u77fmpvWAj+ZbbFXIJZE+sfcppdA2CK94KtQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795732765;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=Ls1Tao0tpzuKTHu6keuYzBn0SKo2kaYIKIQAuXYOuAA=;
	b=yx7t/b+r3MMBkPxUrBYyw6dMtBBHkr16yIJdaqYHDQ3WU40NmnWoxVtgR+W18qPMspqE
	 nPZTO9hF6Peeo+KArdvSjJxmJPBwt5FLne2zyZPacwb9yBE0wklmNtkRA4O2tHg2PIJze
	 BelzhaXT2QZn+wZW5j+WzfyGgrBkjTd7TO/rNmalGEnRr92hiVTP+J0PeCvZNQQWALRmu
	 GssEBBdhE8c2/FOPD0/5tdAT19Kv85H0cMk8icR0eD8nKxC8AhjUCCgzRKmCYGv+g9Xy8
	 GUD5zLvwpUdkxwMjkNKXcEskTCHo2EmcFmjeJDuzyANL0g9KNlMmL2pp2n0hjUSYCuQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oZuqwZ2L;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83A36606A337;
	Thu, 26 Nov 2026 22:39:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oZuqwZ2L
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC6AA1F0089C;
	Thu, 26 Nov 2026 22:39:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795732764;
	bh=Ls1Tao0tpzuKTHu6keuYzBn0SKo2kaYIKIQAuXYOuAA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oZuqwZ2L8F2Qv7wNXF4yrB8vHvHShYVQaAsjSkN4LYbSeWbkU5je5uRH+bonrPDPE
	 qkBLk2n6i8ALnASWxqUoiQs3Xm3I+PQdx+7gOX9IoaL9xgiqz96MCmTatH55CfJPxG
	 TF9jah3hBda20nGejnuTutBJ8bPPnlwXLbwWVyILaFItlIKwOlUaLp0zfmlAplwSt0
	 QuBwnwzDwOLhB47u2z/BeJ1uk5tIUU9MB7U1vw98MhWJOlrnxklZIIy+9htDLvSrSJ
	 0DeBcyGsgXW/8H+fR0CtTkzL8Kplf3OL0RTn74iygdOg020O3bPYd3WUF7mX87HxbT
	 kDM2YtTNO19gw==
From: Sasha Levin <sashal@kernel.org>
To: Brett A C Sheffield <bacs@librecast.net>
Cc: Sasha Levin <sashal@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
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
Subject: Re: [PATCH 5.10 000/265] 5.10.276-rc1 review
Date: Thu, 26 Nov 2026 17:39:16 -0500
Message-ID: <20261126223918.1165617-2-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <awhKVWQBs_Et1lYn@karahi.librecast.net>
References: <20261126143605.076581697@linuxfoundation.org> <awhKVWQBs_Et1lYn@karahi.librecast.net>
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

On Thu, Nov 26, 2026 at 04:03:49PM +0100, Brett A C Sheffield wrote:
> Build failure:
>
>   CC      init/do_mounts_rd.o

Same patch as on 5.15: I've dropped 807c1d7125a2 ("initrd: flush
deferred fput() before mounting root") from the 5.10 queue (and from
5.15 and 6.1). init_flush_fput() doesn't exist before v6.9.

-- 
Thanks,
Sasha
