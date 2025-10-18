Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B1B323ABA7;
	Sat, 18 Oct 2025 16:09:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760803790; cv=none; b=HyHxkpadw1VEBqfuxzo9sdd0M9W3Jroj2VmYaml63wC/ict8LdcDU1h7tP0H41mtk5YEsmptw5thS4ZPJO2+lZAt4HQRT18BfAnK3oaglgmACbVKchkEfkrYj3EZQJNxjpxGKkqX7MF+dFkN2kS716YOPQJ1JkF9kuroPlZnCYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760803790; c=relaxed/simple;
	bh=6U84xiwaU3zZ6MRuASrKSRisryTFatJTjAlBfCXChQw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KGue7pwjDu5Q/OVkvGS/3s0t4/oZ5DGPBlcyDRXEaJUQ2Dl2hpwDPuhuD6X/aWuVxcMGm73i51IXXxddfduSXZqwAmqxa02A2S8SEXI69R8Vi4V305/y7aGVIkxrKiMSvJauStS30rWjKcHyvx7gAs8Z/6KUojZRrwkYLshnJzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T1Hb3jv5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T1Hb3jv5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF8F2C4CEF8;
	Sat, 18 Oct 2025 16:09:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760803789;
	bh=6U84xiwaU3zZ6MRuASrKSRisryTFatJTjAlBfCXChQw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T1Hb3jv5F3bPXl4O3ZHKK/wgktGszj1V8TPap6i8uUirBpYJKBS78h5PJa6ZDJCDu
	 8zSjbsPvqWcy2HlE6EqPGZa0jczCg1VjnxZc7hud8qDjQ6O95Dw1NYIVAreXDTHCvH
	 3VBUqlbWZbJd2YsXEB2qxmONkoaEC/6tL9E7D71+CMbxkQWsnjcYArRawb7ovQRYvO
	 d1LqP86giYL/yYGtq1fLYGeq8hT7WCrjHUCS6hxxvAkbIrI9k9NRTPiwlQffdeOyKs
	 hV4dioD/un2TLlsQXVTRuCv1lR1GhEEHZpS7PTmadfjJo1ZJvmljIIFdYEEdTstZdu
	 TZ6bMwnSFensw==
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
Subject: Re: [PATCH 6.6 000/201] 6.6.113-rc1 review
Date: Sat, 18 Oct 2025 18:09:39 +0200
Message-ID: <20251018160939.1549475-1-ojeda@kernel.org>
In-Reply-To: <20251017145134.710337454@linuxfoundation.org>
References: <20251017145134.710337454@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Fri, 17 Oct 2025 16:51:01 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.113 release.
> There are 201 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 19 Oct 2025 14:50:59 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
