Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793285129;
	b=GNWyc4ak+S7jd4uKRaFMXa4D8Cl+a4qrjEmkiiG0oku2vg1N0M23X188tHo67jiCqJQI
	 kWOm6BW/zZJhK19qhM3jcekdSqO1jqmczvJuNZ+3/kABwB3GivsEJl++0WF0jqpVdflV+
	 pwkIdH9Vw19mBSJt+Jwl714QjQ5WgQQbW5ydbPVYHau/2jWYqJ6Im/UrVOI9yGBfgHk10
	 JuZ3xBU8BY4rRfw7lrbZTXKTLvRlqwJdu8Pyu69BbzU9U9oZW/cozg841C0nxfbpOxGG2
	 EFwQoGpuen8GCv4F88bk/rbr19XSjt8dtGvoclXuCTi9CK8ipUBVIfvdXD1hnc6zXpw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793285129;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=hj33H5cixDs80rOIsQBOmpmSaxJjyB5hAd7hAmO37v8=;
	b=He0/zsXHWjQ9Ekrzsq03EyRaT8+ntW1oLFRMohkRc/3/hfxWdSE/glh7cw6iv+iQHl3Q
	 kAX5/55hfeyFX7Nj9i4QHiD6T4nK/ggCT4GJslcHA2MsR4G3nAXGiCMF23PkQ3WwnLfHr
	 3wWdna2EKnh1ng6W2GQmk9k3zAlDPjNQhvy1HJ0rhsixPWudXaCseTBQbo5N0aQbQ33of
	 YNCRxJTEmlz1NCqcBJbG7N5eRksNEfQ5nISpXZmPgpO2ERqM0QJ0msfjP6SCtQ+aA1uLO
	 IG8svZOizlWuORUwEXNm7N5y/PbWNNGRed86xKV4bGnNJVhC3k+QO3J8TKyJw2YcYwQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=a0wRLaok;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A1D9606A31C;
	Thu, 29 Oct 2026 14:45:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=a0wRLaok
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 306501F01825;
	Thu, 29 Oct 2026 14:45:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793285128;
	bh=hj33H5cixDs80rOIsQBOmpmSaxJjyB5hAd7hAmO37v8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a0wRLaokzs5Jv8M7LUWxTzbOyvNvotiMOTQ28FLvqvDcD2J/Igo8S6x8O4ipm7+H9
	 b7OUgixy56jb+O40SUJjddADWQuevGwZ0ZNbtW7dh60oEoKCulE+1mJ5zbB3tEUiYe
	 vdJkdBOuJrvW6FiyDOd09tHRGEu85MDNgQ1Y2vQ7WykX+8Moh1gu9NXlZVI+ACrZQ6
	 xAsNSB1cAs9lRQz32V1VDv1X4AnEHuBZKq25ZUSdwE2ciNtsVGcFd0dbOFNXBmhB4v
	 TxOwj3LfjePAJuT5sD8UZLilGqz4CQClMSrFtfjw7cgNx8nxqDcnXbKx4in7Y4M800
	 cEO5Noc8Qa0Ww==
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
Subject: Re: [PATCH 6.12 000/247] 6.12.115-rc1 review
Date: Thu, 29 Oct 2026 07:45:20 -0700
Message-ID: <20261029144521.150074-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261028165947.349197979@linuxfoundation.org>
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

On Wed, 28 Oct 2026 17:56:43 +0100 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> This is the start of the stable review cycle for the 6.12.115 release.
> There are 247 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 30 Oct 2026 16:59:22 +0000.
> Anything received after that time might be too late.

This rc kernel passes DAMON functionality test [1] on my test machine.

Tested-by: SJ Park <sj@kernel.org>

[1] https://github.com/damonitor/damon-tests/tree/next/corr


Thanks,
SJ

[...]
