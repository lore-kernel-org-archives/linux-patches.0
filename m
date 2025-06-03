Received: from mail11.truemail.it (mail11.truemail.it [217.194.8.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E98215E5C2
	for <patches@lists.linux.dev>; Tue,  3 Jun 2025 20:34:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.194.8.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748982850; cv=none; b=qOX5ycMi1GTkvdzw2ZjjVvX7jg5OwQtM7SPYEFVRBAAUQv+kUbTLxrfRNuSzCXEelOMLCcCWwlQ7Px20KsTaC7zEeqHjM3ePAoK4eAwZ7gRILWECc3tOkzDWNvxKdSSbZTszhBdGjN8W0OtioAK2+lI3smxLfgl20uUhoJsNos8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748982850; c=relaxed/simple;
	bh=4ygbrJq3wOR1KcMor7zYFMw1GzTl+Xb1ncSGpKYVym8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZDJp95db6g6FpSl+CF+AoiLf9G64Ns5oDHknE7WVnDP5b0S703S+vKzDk0eaePmfsu6fbwO8yqx3MRWlR0SOuFFj6j1Sp9nwErTvZKaZA6E41+4UzTLQz9syr1R5pn1cR5kfVL0ksZFdIz254OYo04r85cUWRuD75pBskyvfTjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it; spf=pass smtp.mailfrom=dolcini.it; dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b=N/L2F1T1; arc=none smtp.client-ip=217.194.8.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dolcini.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b="N/L2F1T1"
Received: from francesco-nb (93-49-2-63.ip317.fastwebnet.it [93.49.2.63])
	by mail11.truemail.it (Postfix) with ESMTPA id 17F421F90C;
	Tue,  3 Jun 2025 22:33:58 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dolcini.it;
	s=default; t=1748982838;
	bh=aUm8NQzsFQSYbUhneDHpSy9shTurxXW3dmQDlMA4fFc=; h=From:To:Subject;
	b=N/L2F1T18xyk/rXHMaQk7fXb3SSu4b8jT42g+o2QtS6HHPWBsU1rH/HKDyOOYQud3
	 hl2Om3DsLgI75F3hFNQ2ZzvBuFqmPIyhfHhL439EZeLnI9vhQ195kGgqh1Bz3Ci2E3
	 tlRwM0WFWRJTX/q96A+pgqoQNKbwSO4LUO6A8CZ3Y1i2siYvE0vSRvhQAghxvK96Pq
	 9Z65PSo5RQaJbV1KWTzSXO9g3Rg88Sri4tP4ePbfW2a6m9dbOqSTz09uz76UCTgP3Y
	 DIO3nY7kXv8bFSrKMoNzhnCGZe84Hhc2Jdw2Jnapd0+5tUReDZQ0F7KqVZOwp2PI6Z
	 AGmCKEpeakjmA==
Date: Tue, 3 Jun 2025 22:33:54 +0200
From: Francesco Dolcini <francesco@dolcini.it>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Jeff Chen <jeff.chen_1@nxp.com>,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Vitor Soares <ivitro@gmail.com>
Subject: Re: [PATCH 6.12 130/626] wifi: mwifiex: Fix HT40 bandwidth issue.
Message-ID: <20250603203337.GA109929@francesco-nb>
References: <20250527162445.028718347@linuxfoundation.org>
 <20250527162450.311998747@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250527162450.311998747@linuxfoundation.org>

Hello Greg, Sasha

On Tue, May 27, 2025 at 06:20:23PM +0200, Greg Kroah-Hartman wrote:
> 6.12-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Jeff Chen <jeff.chen_1@nxp.com>
> 
> [ Upstream commit 4fcfcbe457349267fe048524078e8970807c1a5b ]
> 
> This patch addresses an issue where, despite the AP supporting 40MHz
> bandwidth, the connection was limited to 20MHz. Without this fix,
> even if the access point supports 40MHz, the bandwidth after
> connection remains at 20MHz. This issue is not a regression.
> 
> Signed-off-by: Jeff Chen <jeff.chen_1@nxp.com>
> Reviewed-by: Francesco Dolcini <francesco.dolcini@toradex.com>
> Link: https://patch.msgid.link/20250314094238.2097341-1-jeff.chen_1@nxp.com
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

Can you please drop this patch from any additional stable kernel update?
It seems that on 6.12.y it introduced a regression, we are currently
investigating it and we'll eventually send a revert for 6.12.y.

In the meantime it would be good to not spread the issue to any other
stable kernel.

Francesco

