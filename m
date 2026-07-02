Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2642371D10;
	Thu,  2 Jul 2026 23:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783036005; cv=none; b=po+DZDd/aJRRBFvg1gsz6PxEEa9dVIfyZgwx/YPHv9HtwLG8Nb7BneTxBlyVX6OhrRMd7AwY7LXrldhKrzc/Aw5L14tkhdKEYJoQVW21F+8M4iaUi47h6aIbeWu17zHBPkLkKTGOXx8mxWzAcmSu3PpRYKXHbw5CEFtYeSiqF0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783036005; c=relaxed/simple;
	bh=fRKxgc1ad1X9j/IKWP6RryM0pHpQiHK/xrBUFu/ZvIE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AY+EKHlDN+G5/QnhXqOWSgwaAwWgFivRauw/79SpdfxXGUiFRRkx9cIPBdjKcrHVBgOLmh4EfgWBcpH+jsU6/T+gb5q+B0hAF8In9La7Y5U+ZY5Q9Il4yJF9pHErmEo7p5aSZqtRvGy9GwECfYK7DuF1NlCGylMBnPhRQGMmszk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oLy9DsEx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oLy9DsEx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3AD21F000E9;
	Thu,  2 Jul 2026 23:46:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783036004;
	bh=O2OLEMAEJF3L4MicmIjif2YyLFL4iCNbYKPmcycJCWw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oLy9DsEx9IPTJwhz+MiflkYZC1psUD0Y4YJC7GJ3t88huqLsz9m6lOBaVRM5j62Qa
	 FGyIZIZ9l9gEErcJlNF0fOufLUOYEW8E3RfCXk4nlQeQ+kSk4co1aZ2O/wqDreramH
	 cH7utl744uHTpwK1PoELxtifrMnxAaJZXtHfn3/8kLsRf+lqRwrGa5oYSRYIjFIQAC
	 o6QWTHVOnO+DHyz4BijOven+jmE7IJuL9KXTGYZ7p/EHiHZCl2Tsg2W4zdrhJ3OMbT
	 /X4vcEolXVMSc8UBDNOQCl5+VNCxUg/4CfJIeDHivxKPm0+AAogQoevrOVHyTUFMZY
	 d94oYFRLBgz/A==
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
Subject: Re: [PATCH 6.1 000/129] 6.1.177-rc1 review
Date: Fri,  3 Jul 2026 01:46:28 +0200
Message-ID: <20260702234628.10598-1-ojeda@kernel.org>
In-Reply-To: <20260702155112.163984240@linuxfoundation.org>
References: <20260702155112.163984240@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Thu, 02 Jul 2026 18:18:39 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.177 release.
> There are 129 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 04 Jul 2026 15:50:58 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
