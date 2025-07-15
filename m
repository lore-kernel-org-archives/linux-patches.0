Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AB252C032E;
	Tue, 15 Jul 2025 21:00:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752613227; cv=none; b=F8m0QcvzrgvDQr0QnSEOtf8pHPxLOzajRCnt/UqXNvMSCZbyW/JEr3Aq3K2OyYC4pJjGWNexhFmQC7otBJLn3Ir4njvI1fWbXrIj7PLnHJlLUjxeRuMwhqPqTxEAftjabsyZrIJE9jJPJQEL/MUrehJ7/jfcieE7XvjDr907sqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752613227; c=relaxed/simple;
	bh=87sp7F8srN+ARA5AKtiXb82VrTR+PmTvxzlwy3EOgVA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AIavdLDwhm7+g3W1TRNCtm3OpzU79Dlkk2RibLB5KG/vLleQzOguIhkKLeQsf9ZZSLPXga70+GS0z8rIkCaI0O5qevE/cBtU5PjQtDCe6A35+Ml2qki/lTC5WFqvkkwQT9w8xeuKk/Lw7bhZ5wdM5dhT+qQ70e807nZtckcQyb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XFxJJ7gS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XFxJJ7gS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 810CCC4CEE3;
	Tue, 15 Jul 2025 21:00:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752613226;
	bh=87sp7F8srN+ARA5AKtiXb82VrTR+PmTvxzlwy3EOgVA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XFxJJ7gSOQkR+ujOBFfaE14yasajtOzoU55s4Y61OYadqK5+AUSMNAuVIvyZfhyOG
	 1LMr+B4jF5LVq6UAyK9Zx8cChbxcuXe3T7caXZ0PaaiueQwXU/AiRkiY1d+hi2yT26
	 8NdUHq/y6XOl7l2ZFPX1XXjHA9xx424AkyzipBf3syR45PxZrtym5SoYeV/yWUyr1f
	 uNlHnELHmrR4SlrGXAad0GBFH/eo4qIeABI8XP9K++GOBp1QkpEyFYUtt2RSo5ljrr
	 pfh8oA1GifirifS14jAsf8+tjvKJZtoaknToYohHqqObNbSfIUvdipmSuSvJHCzEsR
	 fgB+azv55hIyg==
From: Miguel Ojeda <ojeda@kernel.org>
To: gregkh@linuxfoundation.org
Cc: akpm@linux-foundation.org,
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
Subject: Re: [PATCH 6.1 00/89] 6.1.146-rc2 review
Date: Tue, 15 Jul 2025 23:00:12 +0200
Message-ID: <20250715210012.2325841-1-ojeda@kernel.org>
In-Reply-To: <20250715163541.635746149@linuxfoundation.org>
References: <20250715163541.635746149@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Tue, 15 Jul 2025 18:37:01 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.146 release.
> There are 89 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 17 Jul 2025 16:35:20 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
