Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BC467083C;
	Tue, 14 Oct 2025 18:01:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760464901; cv=none; b=DASH823ke35xnjBaCuPQ9hCEEWWn5Ed38fQEGDJB/liLyynVpn6bIjoV6R8m9iGF5yzzVAaCjcEtaeiqHMrervZyJ5aCxIMzw9mbG5VwDItV/LZKXJQuLgFNyl9Tba7B4gKNJXJVp4m3vcC6r/a0AiOHmUm/dgoUyqZlEfa2VOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760464901; c=relaxed/simple;
	bh=AvJLZDZaY0rfQVfIis8c4hE9jyru0WLiHbAIEELMy4c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a3MQWBykNZwx9IY8yDJDsnhLVv10f1GJnwtwPandCvQJEcNYTdud232U6mQtr3cgexEvvkVaodPs0UbwhZQcscD+I+4jqPQpHC4Fn9LurhJW2l5ohZZzr25kE7lMAx6MkLqSrSWAju0YrNzb6F7KaGmPglHdes9P0+kT32aBJb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TAfvjc9g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TAfvjc9g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86F9DC4CEE7;
	Tue, 14 Oct 2025 18:01:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760464901;
	bh=AvJLZDZaY0rfQVfIis8c4hE9jyru0WLiHbAIEELMy4c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TAfvjc9gU9+8hUR9nHfIoR1noYm/hLZrWnsAzbrv2KTAPHNmHA+4jCJRofHyEYqjG
	 NnSbeb9iQbpviqCT8Dizz9oBN+i/N7cEq5WR2CailULAi27StHQJ32tO+WcMIusZYD
	 A3lMJcg9GK0ABBMwWK7XB4GusTkJSQzEla/8pNLjVDJ0K7fhUGUv3JPzxqk3kh5/GC
	 deO64sP6gVica4HWdnjn8aTkCt0uKtijTeatTX/3ZL70LweCFjm/he1fh+DIw4JrFG
	 Q2wv4ObhfgDpGOxFghjzeM1uCR+XRJcL5eeP2r4BQIPecyAif6pK7eibuasUGmiUT4
	 tbZqCq83m0RSg==
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
	stable@vger.kernel.org,
	sudipm.mukherjee@gmail.com,
	torvalds@linux-foundation.org,
	Miguel Ojeda <ojeda@kernel.org>
Subject: Re: [PATCH 6.1 000/196] 6.1.156-rc1 review
Date: Tue, 14 Oct 2025 20:01:28 +0200
Message-ID: <20251014180128.1256260-1-ojeda@kernel.org>
In-Reply-To: <20251013144314.549284796@linuxfoundation.org>
References: <20251013144314.549284796@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Mon, 13 Oct 2025 16:42:53 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.156 release.
> There are 196 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 15 Oct 2025 14:42:41 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
