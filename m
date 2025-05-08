Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1B78216399
	for <patches@lists.linux.dev>; Thu,  8 May 2025 07:19:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746688785; cv=none; b=I/M+1RtHb9GwrD7WNQmboe6jY2GW9cF3Jt0VIGL5e+/Tq4HwjqqIVm9NrIjfTlvwVQ6XG4OVgb16iuj2ugrhf2IRBq2EMySxp/VJL8qsN6uS+nZ9YcSWaVnyvwIXKEp7nx8H6LpufZlP0QqqGhqAcgmdgCyUCXYW3nNOCyhqQr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746688785; c=relaxed/simple;
	bh=BrTBqTQ4skDQ6aNK2ZI2MNhc0S3rgKXJqiHbA5vd2gs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FydmtkcsgTLQb1WigCEwicNkK3yUbxvZOuTHeDGOSR8Fsun1DQN+wDj5qwxKiPZHQO4sd/ZuIeWXTWFPiTlWeLM4ciqXiAtm+vQ1dW4cm8mYKr/mAcpTt1RB1QKZM+s9zKDXzr8PslhPaMEm2o2o2YFCLPASx4a2pBnIcDvzo8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=HVe/nzTA; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=v2K+P+yw; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="HVe/nzTA";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="v2K+P+yw"
Date: Thu, 8 May 2025 09:19:35 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1746688780;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=oI+FgH3pM5hfM7XcDXkLmZ7RgCjllwPG3dPyWuW66Vg=;
	b=HVe/nzTAJh7rxqpJtN65nbTuRu+gBC9TqLeUwGKngC/MYGkzHuxWWhfSF2o6Ds7ZRVugYq
	9GDfS7YNKQ5qo/Zfx2YhZmPnyxnRZW6dt7rygOPG7wXUutVpuK6b6lnjogQmYZyZ5meUln
	332CO8JVrwplgyNqwzyYcM+hk8R0l02jpmQtZ+/Wcnhm8+v24irZhDCBm/byz78j/FzVc7
	WWU4QYEXORz3j7raCRBbdqifI2ynNBSZ0XvTdlhvdFSrd8pzfA0Gum7p/op5VyLC7nLHtu
	M3EjWRvTctVytfZdm0zIgKv3Cg6V+3EoAxJl7fBJLsCqXrqbaD+cKIMcivfLGw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1746688780;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=oI+FgH3pM5hfM7XcDXkLmZ7RgCjllwPG3dPyWuW66Vg=;
	b=v2K+P+ywH6yzTkyelmYM6XSBz8StSeqNFqX4DuU1RECMOBxKF0nqVkPSXd14talZSLDH3Q
	xofBXAV4MZSzABAg==
From: Nam Cao <namcao@linutronix.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 6.6 000/129] 6.6.90-rc1 review
Message-ID: <20250508071935.tUNud-Hj@linutronix.de>
References: <20250507183813.500572371@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250507183813.500572371@linuxfoundation.org>

On Wed, May 07, 2025 at 08:38:56PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.90 release.
> There are 129 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Nam Cao <namcao@linutronix.de>
