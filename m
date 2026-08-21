Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DE6647127B;
	Fri, 21 Aug 2026 09:59:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787306362; cv=none; b=GITZbnLfRMD8qdqVNwwmNm9/q/9fjKs7vknHMl5p+d1nXlNGQAWd4E19+bapFvcMDzy5LwEVnz7T3tUhAQfskWnXOVSpSqZZONGonza24DH1Dwi0n+P+tICe1VLfRSXwgvkY6MFZj8gylSYOu2xeE66zaA0oXqJU7vXDwjuhwEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787306362; c=relaxed/simple;
	bh=Uc9/8UGHHO3uyfqMXVOTzU9teAk48LbxK64xUhJzcWE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ILFzrJh0xQLpQ9UQOi0OZ8Tn3jWBNudDTQEtq54DoHYAnUFXdXTQCi6mbIJyEavd5AahIi/6TjiGcV5kqOX+Cwwz9aAihwVNimrf0y+8zZauhE0LNYpUNX+GsNRqAIf5KTb/Di9F9KDU1w8DYLuMcIW7cWTOtPdY5EsFQZ6W16A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J3pG1v2k; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J3pG1v2k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC9E41F000E9;
	Fri, 21 Aug 2026 09:59:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787306350;
	bh=53i6eee5mUASy33IJuxCLF95xUYT1hrvGOxTh4tlAts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J3pG1v2kG+VF3qhY2iuLauYyyrqL8z95cX/4y8zy4pK3eY2vWMA6MHl+ZCisW0+li
	 A24MC9ua2ecWeZcz3lukpdCaLOr2by9+hfZwn/F9tdLiaJbXo6e7BxXDJBxSY+IA0N
	 HTh4FxcwPkfrsXP8z9BdXoR0sXhGi5y7Sfnh/aTPbN3RSw6CSNQfT3q1BWDB+Z+Z+w
	 dPjiWm3BDypDKOvkKAmlxM0BhVHxo6sCUOG0Y+7gF1R47zwAWrH0hFBjqtqcf0clA1
	 gfAM3BTsemNXvfV7jOCOTTCpq+543EDqSSe2ud3wtNMMw2LmSUc7GbcwCgV2cMnAuS
	 tLqwVOZ85WHYg==
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
Subject: Re: [PATCH 6.6 000/166] 6.6.153-rc1 review
Date: Fri, 21 Aug 2026 11:59:01 +0200
Message-ID: <20260821095901.131285-1-ojeda@kernel.org>
In-Reply-To: <20260820145211.194104353@linuxfoundation.org>
References: <20260820145211.194104353@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Thu, 20 Aug 2026 16:54:19 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.153 release.
> There are 166 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 22 Aug 2026 14:51:11 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

I don't see in my config the build issue reported by others.

Thanks!

Cheers,
Miguel
