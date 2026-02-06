Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF5D93451D6;
	Fri,  6 Feb 2026 09:25:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770369937; cv=none; b=ap1VhRCvkZZdmbS1EM0BbxQ+61KvVzwd31+OK5zx17J3yB7g9Sl5caLXsFhUBXp5Ozyx3K1pbSzv2YY0Xkt84k9L7NwCADvNy1yZ4ov86/6c8ZTuJm7phGB4n9r1KhsAPPlsMMAUbUQ3cYn1FDAcBMUxQb6P1Z2acCHhPKkAFL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770369937; c=relaxed/simple;
	bh=67OyxViVbqWaZ9u1J6mM1zos017CAbzXMNfe9CvI6sU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cOliY1WnCj7AgLJXqlIOfQRcBl8jRAm1OhiqoPRSRzyfc7MxsUaQOpC9Um4Hhw9LHR5WMh3TgfhUoJpbG6nllZQ+228AkuQI4MLAJCgAvj9GnBe6uT2MRWFpG+DmjKJTuX9cfp4BKDFuA9m8PUk1AEhhdihNM97anec3hpayk9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A0NuhpTq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A0NuhpTq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B4E7C116C6;
	Fri,  6 Feb 2026 09:25:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770369936;
	bh=67OyxViVbqWaZ9u1J6mM1zos017CAbzXMNfe9CvI6sU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A0NuhpTqbEk5NqdLLnmPLcYYlBqWHvFRnuDHBes85Bps01UDtc/ARVoJgMGAz99tW
	 CR6ggmJA+PtWSfa9iX4Iu1GDBc+dqVmSLDlGf4p3xgXx6erJumefExCM7E7OD9KhNs
	 AMAxgmYRfSa993oM8dw6ZwxUBIjbq5+D3QheYaOUf3jk0Ef87roEgI9FG5hBS+/JHE
	 X82qC9QIq2Ld5gRbA0Ezy8xA9u1CMPcHXMawSl6+nnBumAFY6NlTfTRA0WPsreVf+m
	 KagWlnoASP+dCXDCMGW9dVfu4QKfE41zBNMOeXQFS7lNXVTociUAMbRl3/09u/FpcS
	 GJA8eBzjY5APg==
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
Subject: Re: [PATCH 6.6 00/72] 6.6.123-rc1 review
Date: Fri,  6 Feb 2026 10:25:23 +0100
Message-ID: <20260206092523.87951-1-ojeda@kernel.org>
In-Reply-To: <20260204143845.603454952@linuxfoundation.org>
References: <20260204143845.603454952@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Wed, 04 Feb 2026 15:40:03 +0100 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.123 release.
> There are 72 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 06 Feb 2026 14:38:23 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
