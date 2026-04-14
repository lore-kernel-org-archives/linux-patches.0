Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0F793090C6;
	Tue, 14 Apr 2026 17:48:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776188939; cv=none; b=jaY08pjzWiawcUsAiwqKt3mI8ryqJm1Qzv9XubzjBFSCvHCGotAE9cSYU/jRTXopb7gzN0tuEr29D68MJnTfSxhzgYK+kiccvYpXSoVUaYzzhXEDfvILO3prJfmQhNeU2fjruzV95z378zF35TpzYIfKe5RVUgItmmwSESiYPt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776188939; c=relaxed/simple;
	bh=REsJ5lfD1dTxD2sZaUAMGYsmwibNIIZyhBja5nzaUf8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JX3L6Dhf0T91ogEqeE3OJ+lv2LY8JY2XNGrDGsNJvosGDKBqpTB40+oH7Jq+y0IelW8Ei1vFMlwQN/Ob77xrtaIuVK9otEZkGGXXdU4PD6FIIi+R6z17zQ0EA9lX2JMKaVupxrOV2i8/uQfPNkaULpOKl7bKpGDn5gS3NSZ/dDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TdrhLLXz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TdrhLLXz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7389C19425;
	Tue, 14 Apr 2026 17:48:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776188938;
	bh=REsJ5lfD1dTxD2sZaUAMGYsmwibNIIZyhBja5nzaUf8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TdrhLLXz9fL58WLfEC0dsuwF+o7iq5S8QD3lfzcbGHsnZ2WUNBaM77ztpOYCBCcr3
	 BmdukUsSE4am7RDRyNUJXRfmuQIxUkQ0GJgKiaTxqKVA3y07dEBsTOEkgB4tNsq1Cd
	 QYXLkdXyUgJ7J0g8FvN6jNB2YT5GAQlO1OOKrfgy3WD+fssZfhhnEWbt14/qQdtC1J
	 +SYA34ikFhzqN8XUCFRawDyeIecyLO4AKuP+0PJ/lxImCvyh/osjRwiaZtQna3Sns4
	 eyuDj1NkKOKssvFq42drcmluVkXkXCaj+Q+f03L+caGXyI0tnTryKbUg2teOeqBWOY
	 53Q0z9bR1bJeQ==
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
Subject: Re: [PATCH 6.6 00/50] 6.6.135-rc1 review
Date: Tue, 14 Apr 2026 19:48:46 +0200
Message-ID: <20260414174846.268775-1-ojeda@kernel.org>
In-Reply-To: <20260413155724.497323914@linuxfoundation.org>
References: <20260413155724.497323914@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Mon, 13 Apr 2026 18:00:27 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.135 release.
> There are 50 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 15 Apr 2026 15:57:08 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
