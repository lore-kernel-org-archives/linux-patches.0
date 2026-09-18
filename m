Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A53A1511191;
	Fri, 18 Sep 2026 15:54:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789746866; cv=none; b=kV/oHTIN217d5SBTlIfBrFdxBTfzIS4KnxueUXOOmPhBqxvWVCoXa5xc/tzlyiYIfnnapg7xkCPqu+m7gXq2yxOIH8FfD+4cLg7io/KVYT0q0IsEQR3oyR4sx0sZsiRB0F2qJgkN+6Gn4bXoGSNWPDbkHMiFnud1dK7FnY3KA+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789746866; c=relaxed/simple;
	bh=peulqKYmVPW0msB4c0GTfd51rxsopByUZTSKNltenqc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jWtGSP4VZYl5YJltdk3embprEQVLHq/YPikiN1k0al89H2aw/Kc/2pEmWaTGJqYU1lUxlMHRs6vDyINcAq3FivLZCQIotBba+MPt+PNpLdUNfGv/YB7Gqy8Kx7R9DN/QZvkzvL8SjWBY9QFyOc6sK7xXcd9Rq1HXxBXnEp6zBG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RYeOJOdp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RYeOJOdp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 659A31F0089A;
	Fri, 18 Sep 2026 15:54:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789746865;
	bh=SMflwobboO00hd2qWckgVats2PLXIerCxVxrM8bbJnc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RYeOJOdpS3WV6iRpeYEANqSPNDvWCn2zoDWhciW3Duls22h4wBDa2aTfD+gO+ggXr
	 7f1xeIxewj5fjdnGqWyHFAixS8sdV6RhXBkQsp4TJlmlhqlmvQiveLLhbWGLd9ekJ9
	 ROEtpODUe8pxUJxYogqGvcbVhaZOi2CT10idJ3irNKel3hc0on0Bmvynm3KDvJo8/R
	 hHlm+8z9CY6OMzK8a55fQEkVIdHGY1o7PiKXyfMTF7J7qaQ68QSN7sIfcWajillcTz
	 w8qBI2vOhzLBir/BcAJ9BbCe+VNfxI+ZgNTq7Ll6EIik1zzwXqGxAq4f5/G0zc0kvL
	 1TI1AEr9jFkUw==
From: Sasha Levin <sashal@kernel.org>
To: Pavel Machek <pavel@nabladev.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sasha Levin <sashal@kernel.org>,
	stable@vger.kernel.org,
	patches@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org,
	akpm@linux-foundation.org,
	linux@roeck-us.net,
	shuah@kernel.org,
	patches@kernelci.org,
	lkft-triage@lists.linaro.org,
	f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com,
	rwarsow@gmx.de,
	conor@kernel.org,
	hargar@microsoft.com,
	broonie@kernel.org,
	achill@achill.org,
	sr@sladewatkins.com,
	Jon Hunter <jonathanh@nvidia.com>
Subject: Re: [PATCH 6.12 0000/1102] 6.12.111-rc1 review
Date: Fri, 18 Sep 2026 11:54:08 -0400
Message-ID: <20260918151141.2101477306-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <8cc48d19-ccb9-46f0-92c9-b26916a349da@nvidia.com>
References: <20260917151539.408551884@linuxfoundation.org> <aqxLGIyiWCdsQoyR@duo.ucw.cz> <8cc48d19-ccb9-46f0-92c9-b26916a349da@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Fri, Sep 18, 2026 at 12:27:18PM +0100, Jon Hunter wrote:
> FWIW, I am seeing the same build error for ARM.

Thanks for the confirmation. Dropped from the 6.12 and 6.6 queues:

  0b8c878d1173 ("net: cpsw: Execute ndo_set_rx_mode callback in a work
                 queue")

The patch only touches drivers/net/ethernet/ti/cpsw.c, but the 'struct
work_struct rx_mode_work' member it dereferences is added to cpsw_priv.h by a
separate commit, c0b5dc73a38f ("net: cpsw_new: Execute ndo_set_rx_mode callback
in a work queue"), which is not queued anywhere.  6.6 also lacks
disable_work_sync(), so it had a second reason to fail there.

-- 
Thanks,
Sasha
