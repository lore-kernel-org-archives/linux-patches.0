Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795299632;
	b=lCc+HZxepeiwUi3SZUkYWbl9v3PRV5bbdqceS0JL/oaRPHmBsSbMBFJqSFrBGwUX5EIJ
	 vLTtFHuuhDsHaIAWiXIRcCPhNhe+5DZmu1JU4Vhbqaeu8jfnzyOihwdWJstiOfcL2wJ3U
	 hemb2teW7EvHYYG78WjMI8KRC0ABqQrIcaNdlLB0S2OZoApCUzFTgYToc83bhLlu9wEDL
	 QP6l9/VKrN4H0FWSliLy0x2SEkvdBDEH6k+9QbggL8Z8AlMayd9XptsoqHY5IpJ63HobJ
	 C6n8uvHxCKle+xtV8JrWiKpboGLnheYHkIdoFrjfJ10JjRLWNimrDudHvSAdd2qL0ng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795299632;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=RgVG9YLrOs3jQiZ+H3IllZcbdIuxEMT3rQUJhfZZj/g=;
	b=TW8Io0e6OMqX6MrnbKZeSOCbeQuq+wDeQifqDte/+XCDD/hhKG2Mn32YW9UZGNZuYXIW
	 i/hudB82eKuqXKy11UF4jxc6sqqpRdRUQ+nrxF9IH5fajWB9pOEq5T+g4G1ZoGT3DcXZe
	 hDSKkixxNK62Lla/HQ7c3h++fkN61lmtpQdLMIfpdeLWGWxzrKEBw0b0XQGj4giGzvbdZ
	 rXpFT15O5JFZ2vUt+R6Ccw7dj+W/X9wG522hGUK/dUJlowQ7LrJaS69FCJbFM7Xa5ww4E
	 D6urya33fnvzchdpxIzj0gbIryRhXyaBLO2V3R6yKaWerz83xU2a76ziTvg8bDQI7Pg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="AN/pHgbU";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24F3D606A32A;
	Sat, 21 Nov 2026 22:20:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AN/pHgbU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CCEA1F000C6;
	Sat, 21 Nov 2026 22:20:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795299631;
	bh=RgVG9YLrOs3jQiZ+H3IllZcbdIuxEMT3rQUJhfZZj/g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AN/pHgbUNu3PQg4/8Pr3sZLH2r9FtEy9sgl4JZg1Szwa9mAZ5uwTr3t4dLLeJ9dAN
	 GnV4YmMdRi7kyyZXMbPfM6zqnc6eFj9VJp2AfecnGA+ZQYh7br+yzAR2YdlAzH/q8+
	 tBIkmil/QHuLf7aEokwBQ7uPRIkmyTCCyOH5Q25x6VkBRQs4is8k5SDLaTLYip0mr2
	 NElm3uuLpgFx6QKh/Ozp/3qYbTxGVvazZlspV3mBFDZaioZDE5NrYvYmVqls+hYboC
	 Aymfv7FVHN09a9u1PbQ5UwLSslN0OOm9i24HuFc8H3ReFAwCwXDfFFbZHhdaDYqt9P
	 tZ8ngHV1QgGLA==
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
Subject: Re: [PATCH 6.18 0000/2144] 6.18.65-rc2 review
Date: Sat, 21 Nov 2026 14:20:14 -0800
Message-ID: <20261121222015.135731-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261120055114.182757740@linuxfoundation.org>
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

On Fri, 20 Nov 2026 06:58:10 +0100 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> This is the start of the stable review cycle for the 6.18.65 release.
> There are 2144 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 22 Nov 2026 05:44:39 +0000.
> Anything received after that time might be too late.

This rc kernel passes DAMON functionality test [1] on my test machine.

Tested-by: SJ Park <sj@kernel.org>

[1] https://github.com/damonitor/damon-tests/tree/next/corr


Thanks,
SJ

[...]
