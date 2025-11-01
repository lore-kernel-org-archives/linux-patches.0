Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AC5B184;
	Sat,  1 Nov 2025 21:02:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762030974; cv=none; b=vA2mnZSoCfu8RC6AiBcqpTYCQwNZCCDY0pfFNXExWXer40IOUug/kgkveOxzNmzRORF3toTM72pmcv2FAvuoq7Hr98qozgxLbSrXVkuCtLqr4a1VIFZdbyebOWRaeQI9GLEtsN/Jy88trjWEG9LzqclY7sazX3MS+yT3NzH7vJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762030974; c=relaxed/simple;
	bh=/8AFb3xhP0cWX+ycwDkEFahsyY6kYXCfh6PMg+Dzct4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K1sBVT6MRFLGsVIiyndTxy1Duynb2ycC51x32c9x1ToRd91hma989pwa2KuWU3LzCoui9fYNGh8tgoTHNcdPZuNfl+ogwdtdWY5OPLlpGUCpIwMhgwY2VOkp8a1nZPh91h3IheBwmhoiU2VqZXD3xw292hxa1xtfHySb7elgRoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=N0Qyi0Y2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N0Qyi0Y2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEB66C4CEF1;
	Sat,  1 Nov 2025 21:02:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762030973;
	bh=/8AFb3xhP0cWX+ycwDkEFahsyY6kYXCfh6PMg+Dzct4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N0Qyi0Y2SD5nRA898fwsrMR6okxxEQzjinEKjYTw24zJjzK8VKHighSjB776ZRx9W
	 zpoGTS59OZe7nMYdZkc2d8lHtuH29SATGwg1ghjQ68e6KxTw4BP3XvXLlxrB1nElUD
	 ueybwpJtGZBo48IM1Uu3fEqYiRoPnwhNzlze24Y+RzJaJYA/BOwHwjFCDePViJfwmC
	 L/ta6/l+pu2fe75ghyjLholoziUWIVz18G/ZpLnQe1eULgwRmjgzBtllGyfSpa6J+R
	 nlOhp03uyCBMdfdbj/uThNo3JqPv0o8EMrNg1VJMpd/tIjTnfRM+8MqUY7XIBbuFJ8
	 Qr6VQAmrwCtug==
From: Miguel Ojeda <ojeda@kernel.org>
To: gregkh@linuxfoundation.org
Cc: achill@achill.org,
	akpm@linux-foundation.org,
	broonie@kernel.org,
	conor@kernel.org,
	f.fainelli@gmail.com,
	hargar@microsoft.com,
	jonathanh@nvidia.com,
	linux-kernel@vger.kernel.org,
	linux@roeck-us.net,
	lkft-triage@lists.linaro.org,
	patches@kernelci.org,
	patches@lists.linux.dev,
	pavel@denx.de,
	rwarsow@gmx.de,
	shuah@kernel.org,
	sr@sladewatkins.com,
	stable@vger.kernel.org,
	sudipm.mukherjee@gmail.com,
	torvalds@linux-foundation.org,
	Miguel Ojeda <ojeda@kernel.org>
Subject: Re: [PATCH 6.6 00/32] 6.6.116-rc1 review
Date: Sat,  1 Nov 2025 22:02:33 +0100
Message-ID: <20251101210233.1120460-1-ojeda@kernel.org>
In-Reply-To: <20251031140042.387255981@linuxfoundation.org>
References: <20251031140042.387255981@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Fri, 31 Oct 2025 15:00:54 +0100 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.116 release.
> There are 32 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 02 Nov 2025 14:00:34 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
