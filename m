Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AFED3A544D;
	Fri, 29 May 2026 06:15:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780035353; cv=none; b=AFS1K7N7Bzj8GevGUl9gui31AlRv5PdJ8qNdHKnU/iJrI/W5jhEWNwAjhMVYjRO9GSlt3vdnW/E3z91UviHQJ9eXr2Sk3inx2wNqMnBhsp8T6MQvMWB/x+1sg8fhjniAgKInQyz8ypVCKBSgWTifPdZwrz9oifda6CVxOl7fJDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780035353; c=relaxed/simple;
	bh=SrbiEjhO0zepqJz1+G3B0OYm9XiJVlKUsTOpTdYcOig=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ptw9jiqjlBpniiYZQn+areLsDNr/v93ucZGDHsoFfs5MG/Wuoz4PGtK6cOTPPHUZjjlvANyZ17ob5N8QXd491GTesNbaUTV3OTiEbeLu6wk/pvpYh9QiQ4JERPbPVzwXPPL80yP7Zpy+VXsdJrD8puywI/+o0Yb0wBpAkVEntfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Re8hK3Zb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Re8hK3Zb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 292901F00898;
	Fri, 29 May 2026 06:15:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780035351;
	bh=L5+K90p6+MefU31Q2H2dn+vwbCj9rwMLWcyRy+c81ps=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Re8hK3Zb3ZzIXYgfLgdUa5GveYOpk54WPmWFTiiyksmJFSEuqN9iYbuE2aGmp9akQ
	 sbU37kVSfSTCXUAkiUcA6OmR9bqteMQlKPQiqyU4fpLE5howvTTkuBOP7eCCnTKnUR
	 FJFoOg7x35JfhMSvjOj8fPtz8LzIFUoTlaWbO7g72kVQ2uKvPm5vh3UXd+VWAe3daS
	 FbifrF22dkQgQfpTjjEQt1OZx6xz4yiG6b1bPCOERRDi1UBX3tb+a0rib6TWBZFipt
	 QBgGdS1kGWypFU5sDZ8vEU/c6/JMHb5fR0JhbVjMaNMZeN5gNxkq+LuEwBbJgkhyxg
	 v0LR/+phZk4mg==
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
	pavel@nabladev.com,
	rwarsow@gmx.de,
	shuah@kernel.org,
	sr@sladewatkins.com,
	stable@vger.kernel.org,
	sudipm.mukherjee@gmail.com,
	torvalds@linux-foundation.org,
	Miguel Ojeda <ojeda@kernel.org>
Subject: Re: [PATCH 6.6 000/186] 6.6.142-rc1 review
Date: Fri, 29 May 2026 08:15:42 +0200
Message-ID: <20260529061542.124058-1-ojeda@kernel.org>
In-Reply-To: <20260528194928.941004471@linuxfoundation.org>
References: <20260528194928.941004471@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Thu, 28 May 2026 21:48:00 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.142 release.
> There are 186 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 30 May 2026 19:48:57 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
