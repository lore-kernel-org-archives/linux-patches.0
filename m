Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66DC11A76D0;
	Sat,  5 Jul 2025 14:34:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751726047; cv=none; b=E2nZS0GLG28RlP0u48egO412PhlQvY1Ng9ol/S4O590Ej22fVv1/VleHvzJBajl5GXRMpyBxxKiqbPwj8tUYw2+hg/NXYriBzOWk+uHg4m73CH6+twqtcZVOPQpp6VLyvYGwUDysgGwxIDjM1frDEmLv7wdCnk//f3r3bsn+DFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751726047; c=relaxed/simple;
	bh=lRZGacEf1U61/v/lSG1JH8NSvvCW1KtAwoa6CdbjUxc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uFw85ireNjxOjjZQxjb+v6ZFjicN8/pDM/Qm/Pel34i3fJ9uZpNIzqIpjNzHBJUFh/Fl96J8w659WQtR/99AuaOEeyU5kaLbO5qQKpeptNaFQaUOxCOy+qInYFWoMUCwKe07opKJOLBUgQOewmB4nYRObZy1qOf7qak5nmH69k8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nZ/YK8hO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nZ/YK8hO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CADA8C4CEE7;
	Sat,  5 Jul 2025 14:34:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751726047;
	bh=lRZGacEf1U61/v/lSG1JH8NSvvCW1KtAwoa6CdbjUxc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nZ/YK8hOX0Glh/aJvUVn1/BVUCTvMVNRmQK7cXrLuwlhf7tkU5dPc0fo+GTUnxvGZ
	 B0pKm6LlNJJ/J+p+maHNBGCJAg2ib1qzT0PpgyG4SoPoDHHkggYFmm2azZP9+vSHkA
	 3tBPpC6sviG9jmL2M3iA6cyNb5JLt1EPZfJQFENkSYjkbR/9QpV58A/Ntpo1ErEj9u
	 FKMPE+9wpuEbLabm7tFOl7+Ov7RwZStU4jtHPQztyqvRCZI6YaojVwVHZ4b4OXmzIY
	 kkZoYrFJNfOjyAaPCSy7NsfFd2KJpZ382PP59R+hV2P3LPJgf4i+csD1r5UjeU0aps
	 CXhb3M/cLus0Q==
Date: Sat, 5 Jul 2025 10:34:05 -0400
From: Sasha Levin <sashal@kernel.org>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: gregkh@linuxfoundation.org, chenhuacai@loongson.cn, maobibo@loongson.cn,
	patches@lists.linux.dev, stable@vger.kernel.org
Subject: Re: [PATCH 6.12 206/218] LoongArch: Set hugetlb mmap base address
 aligned with pmd size
Message-ID: <aGk33Qg5AlrWIg6d@lappy>
References: <20250703144004.457285463@linuxfoundation.org>
 <20250705114500.360382-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20250705114500.360382-1-ojeda@kernel.org>

On Sat, Jul 05, 2025 at 01:45:00PM +0200, Miguel Ojeda wrote:
>On Thu, 03 Jul 2025 16:42:34 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>>
>> Cc: stable@vger.kernel.org  # 6.13+
>
>This line makes sense -- it sounds like it was indeed not meant for v6.12:
>
>    https://lore.kernel.org/stable/20250704231046.332586-1-ojeda@kernel.org/

Yup, now dropped. Thanks!

-- 
Thanks,
Sasha
