Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5826E35207F;
	Tue, 26 Aug 2025 14:30:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218656; cv=none; b=Ocmvt6xQuhvyrCKEgsGOMMNlHbep5E1771XTEO5a5wn8Y/sLT85DrQkz320HkxlWbcAQCJpLYEdLdhDTzXNYRQ55eMRz7qakPgtWHvML9Vmwq8aK/Film5dvH9gdRRqf0XX1pNZdYLVfvOTnIbyKoHzqMptgjHKeOhIULOQif2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218656; c=relaxed/simple;
	bh=+rmzZsG8xK7vteIdQuM27KggxzTNqYPJge+IHh1hNXc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Swlf2vOY2bZGyLyOKgPm6fAgSW3XlSlqqlJGumeEVJg8XB9LktQG0q1hUZzr6uTag0LOkomScXfnNfgWoDt1mtRYbfC9CrtI/URwwghmTOePOnQOTkdUlTMlQOnX2s+AuGJXigljffGhlMzTPf33B/50nGmroYfiTBf/I7YhKhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DjK7I457; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DjK7I457"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5455C116B1;
	Tue, 26 Aug 2025 14:30:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756218656;
	bh=+rmzZsG8xK7vteIdQuM27KggxzTNqYPJge+IHh1hNXc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DjK7I457i2u1IumoQ45fmH6vjRxvhI2a9IK3kixPvNvX9aRXE4FecdY9GbXaOEAm/
	 5Mfr7hhzhaQEVGy0NzQD6riKpfj5XvgSlLbnnlMRDBWzP5fU2x51L3AaKFq0oJjQDu
	 8AE7bdFDoYnV1K9DNDEC4ZNnFh8Yypvwf5PoQufa6iH4tzwn2nGNz1UdKk98Q+abcN
	 TPtFvKCuHPqh03hRL17LE02aagFmuqt7yNwc2HSevta3odB3CYndP+7976ChpCnC9I
	 0l6ROE+ABrqEcHYnqsG0XY9bG7ArqRRogaUj1DiXJVk5Rl4dHK/FgBKS3i4Q0feCsU
	 DpX/cen9gh3RA==
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
	srw@sladewatkins.net,
	stable@vger.kernel.org,
	sudipm.mukherjee@gmail.com,
	torvalds@linux-foundation.org,
	Miguel Ojeda <ojeda@kernel.org>
Subject: Re: [PATCH 6.6 000/587] 6.6.103-rc1 review
Date: Tue, 26 Aug 2025 16:30:43 +0200
Message-ID: <20250826143043.711658-1-ojeda@kernel.org>
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Tue, 26 Aug 2025 13:02:29 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.103 release.
> There are 587 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 28 Aug 2025 11:08:24 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
