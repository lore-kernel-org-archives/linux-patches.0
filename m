Received: from manchmal.in-ulm.de (manchmal.in-ulm.de [217.10.9.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 816DA44213B
	for <patches@lists.linux.dev>; Tue, 15 Sep 2026 18:20:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.10.9.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789496420; cv=none; b=EgfVqnROs9CfcELPG0IZpzvLxfV2R140ekCb8VheazzglhoomZPysLrQ2POcfWShCaO5wLm5O5wUnD7F1JebGdzSH3zO8mXsGFWQ8JujAfhFqKV28GjcTBlLa2zq321HJMh25WYYhlQ9zKZZEvGlAR/Pj8Owp+CuDvm+X5QyQ6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789496420; c=relaxed/simple;
	bh=l6yaPuhMm1iA1Jf54xkhtuLc8sK5xHCoGn2r1RTIGBA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rsuENnMb7chi76gUI4jy/uYf7AbpB+9294QybK6xcLR/PyIM2MgCizGT5mnfwBC3h9hslz6cg30eRBfg6+CZ2YwbsA22Dt+A4JLg7MhGAGj6APazSKQP8I/qVvkJJedufGvo4WaePEr/YdK4US400Z/SBj5hDcK0wGAuEIBNnic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=manchmal.in-ulm.de; spf=pass smtp.mailfrom=manchmal.in-ulm.de; arc=none smtp.client-ip=217.10.9.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=manchmal.in-ulm.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manchmal.in-ulm.de
Date: Tue, 15 Sep 2026 20:14:05 +0200
From: Christoph Biedl <linux-kernel.bfrz@manchmal.in-ulm.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	"Gautham R. Shenoy" <gautham.shenoy@amd.com>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.18 0547/1518] cpufreq/amd-pstate: Add dynamic energy
 performance preference
Message-ID: <1789495960@msgid.manchmal.in-ulm.de>
References: <20260912065623.398859879@linuxfoundation.org>
 <20260912065635.815502340@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260912065635.815502340@linuxfoundation.org>

[ A bit late to the party, I know - speed in -stable is way too high
  to follow more timely, though. ]

Greg Kroah-Hartman wrote...

> 6.18-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Mario Limonciello (AMD) <superm1@kernel.org>
> 
> [ Upstream commit e30ca6dd5345c5b8ba05f346a8e81105352fe571 ]

This introduces X86_AMD_PSTATE_DYNAMIC_EPP for 6.18, while it was
already removed again upstream, in v7.1-rc2-7-ge4e9b7b38d5d
("cpufreq/amd-pstate: Drop Kconfig option for dynamic EPP").

This is a bit confusing. Mind to shed some light on this? Perhaps the
latter commit just didn't make it to 6.18 yet?

    Christoph
