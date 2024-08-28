Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D6CF1A2C16;
	Wed, 28 Aug 2024 16:02:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724860960; cv=none; b=Z5+GZTRndLi1qpFZTo2vOKfgKAkI6Igj4OZUXkITyexFag4v+3R8hMrBkWmpjziRZCa921PPUoMq6N1QONb7ayORRD9t3FydPfc7KY5q5tOyDttNUAHkumKp9wPxpeSRSuzgp1DOf6jeoMbd6FeRTKZ0RNTWwjzvg0Ul2MGBGsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724860960; c=relaxed/simple;
	bh=9zIk/ZQ6tOKx8kssIHZplpANzrtbgRAqdMbZWpStc+k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FpG1osc++Ix4LEGrESfKR4azN1ck5zUuRJDGizMPSMHdiAeI+brEkaaSklhpS8GmKp1801WIvGfMoo9Kk7fqxWM2Mk4d9+B9MgsDnETzUxavaJZq0qLTlUtgiNGS52sfTGW67sJWLDekamBjiPwpoUiawOOlSkCaAWDlTffGd34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ts1icKkt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ts1icKkt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 862A8C4CEC0;
	Wed, 28 Aug 2024 16:02:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724860960;
	bh=9zIk/ZQ6tOKx8kssIHZplpANzrtbgRAqdMbZWpStc+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ts1icKktqOpd4Yob2C5M7inVFJeCcLyHinAQfftflEG96p8U4trB4My8J+q8IuEtk
	 oEHdrgpOPZaH/EOxOE6TFb9ebhOaXNmoGHQ0e++9/VZYHyIbLrgSKbN4HMhlcxPVFc
	 3Yiow5h/HGiW1z+kJIjMPnzPh3QDIB7uQVoB+pTrrW4ABNIO2sP4zypDfaqwHFVhAQ
	 RZTORu2tzoV2RveBL3Wonkq5gA/eCPQwbnF1HGCxXpmHFaTZF9QWUFrard8B/dgoxz
	 VRe/Uj2zHFFI33+pLQzZqyrfm/skKpAjOw7gqR9rgeI5BeUXhDsl1fJrNsw8kAUA/n
	 rSLtEHmI7MEMQ==
From: Miguel Ojeda <ojeda@kernel.org>
To: gregkh@linuxfoundation.org
Cc: akpm@linux-foundation.org,
	allen.lkml@gmail.com,
	broonie@kernel.org,
	conor@kernel.org,
	f.fainelli@gmail.com,
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
Subject: Re: [PATCH 6.6 000/341] 6.6.48-rc1 review
Date: Wed, 28 Aug 2024 18:02:23 +0200
Message-ID: <20240828160223.139236-1-ojeda@kernel.org>
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Tue, 27 Aug 2024 16:33:51 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.48 release.
> There are 341 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 29 Aug 2024 14:37:36 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.48-rc1.gz
> or in the git tree and branch at:
> git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.

Boot-tested under QEMU for Rust x86_64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
