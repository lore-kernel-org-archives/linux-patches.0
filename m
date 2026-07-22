Received: from mail11.truemail.it (mail11.truemail.it [217.194.8.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4E1A403AEC
	for <patches@lists.linux.dev>; Wed, 22 Jul 2026 06:37:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.194.8.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784702257; cv=none; b=S6oeBvVCrW6LqtIB+LBqYPccQPtS8Rp7S0U8i31q5SeFRrdxEltWgZGsgVS59+1jwVJVpuxXW3QifGwqUTDi6AR5NzOAzUm16DjRSIFY9ggozG5Mbh/1vf/Pu4wC1gdmg8GzppVPUwXRrk/BM0DnjQQxajdMGhUxjMMm4WOrkKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784702257; c=relaxed/simple;
	bh=mGAepXNXclMJ9Z2J1FsOocFJ/s7MvEJ9C7mHq0wpRw8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Tljr4QNqeEWPdtlkWVh104MI+YCW+ZLzvMXS6MUc/w56WgKbg9F1mlTXX7o8rh7BYpwFy+hp9F3XMMHA4M077VS14cgq5pYdcWjUAxmtwnW3I9hUWBqrLmEhi94YYtH2mDhsbTEfCoD+fVZcxZYYpHMz+ISTA7wA0rokgVs2bQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it; spf=pass smtp.mailfrom=dolcini.it; dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b=j3GbrlDH; arc=none smtp.client-ip=217.194.8.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dolcini.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b="j3GbrlDH"
Received: from francesco-nb (xcpe-178-82-120-96.dyn.res.sunrise.net [178.82.120.96])
	by mail11.truemail.it (Postfix) with ESMTPA id D1A651FD24;
	Wed, 22 Jul 2026 08:37:32 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dolcini.it;
	s=default; t=1784702253;
	bh=3n0L9dOfWAd6n0psYH8PsfWfVM7aGzLh0Rt1BS6r6W8=; h=From:To:Subject;
	b=j3GbrlDHmFzo/WV+JFwrKEV7+9jBtE8Nw1O8myAivpRGxVOyb4sE0WEIeCE+H9Giw
	 sMVoz4qDwxzcbkczL8Nu0Si4cKfRenI3L2gjHxKxATQjDa7HH5hpCowJRe0paD8KyO
	 DSRZAQu9FbL7umuF23CILMkfB2rEvrUUcWqu37hdTy3RmSwfuHCCGxCCmF2dFsZWAh
	 iJ7l+24jGUV9K/PpYA7hXqOddRlvL/ICc4AwG1jKntSnxlvZzDP9bybAD9c5IDBTmk
	 5ONVKRMpCsXxaYRPMkcTrHRM9dp4zCrv6h9YxKA67Xi3CWLxXMR/2ubFDt13bo7tZU
	 uEtwLLdMjs5SA==
Date: Wed, 22 Jul 2026 08:37:29 +0200
From: Francesco Dolcini <francesco@dolcini.it>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 6.12 0000/1276] 6.12.97-rc1 review
Message-ID: <20260722063729.GA27550@francesco-nb>
References: <20260721152446.065700225@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>

On Tue, Jul 21, 2026 at 05:07:23PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.97 release.
> There are 1276 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Francesco Dolcini <francesco.dolcini@toradex.com>

Francesco

