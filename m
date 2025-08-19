Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F7E832BF27;
	Tue, 19 Aug 2025 11:35:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755603332; cv=none; b=nBDADhYiv47f7nTMvXUXWL4deUVubAWDXCErOtUmqbkkUTKREaENgOch1+6FzKfX3Yq2Sf+sgmLRB8dN8q+obYpDDgDGir7kAQkNecCBTMhaviQCIFHfSSj+fc/17gVZwzZ0v+zXLmpuLzRauJn1SCgmvxpSduUQK8LxhpjyIHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755603332; c=relaxed/simple;
	bh=w2jIOR1lpkDHoLj88fhmQi3DcBG4GO0JGHddxQqGBjE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tn64UqNE7qALNCnc5o7x8bfxIRdCT6J/fLur9MyYmzGViuD/QewyaOSuJePAuilBSGI89v9SFirERtWyAfjgxw3EuI6jT5AkNgGhcUUAfasBUon1lHHnleEFyPmywT1/H5dKGzlUXxirT5VTk0VXJrjL6jpjCqLxUCPbZxWRmFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qnHeHwfC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qnHeHwfC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92E62C4CEF1;
	Tue, 19 Aug 2025 11:35:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755603332;
	bh=w2jIOR1lpkDHoLj88fhmQi3DcBG4GO0JGHddxQqGBjE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qnHeHwfCL7dIpX00FXdlapFMe1o9fIymJbm0eNGknjVrOlwgmnUlBurcLv8B33XIO
	 SA474yTpPk1jC15kb8Rf7hVjllhBiKYG0PjxPsRTFbb96m/2Sg4FhZ8FACEbVLj2l2
	 +d4vPTt53k4hwNbpDqmauIJNOgmDuHhbtSRfi7LsdZ4LQpXeSqjdzNqr5pr+vFe1a3
	 3xBM3JKtoOkHr4Ml3QYAkosEc/sx++Uj1r+2chdU1uUQA2gE5cChvNvHxC3XPCRRp7
	 yVh+ukQ4XTwkU27RUY513SFainLW/1wnVxA2j5+Ig42urB4zXX4eOLfc2uJ4KCzRyv
	 EYAmbxond/15A==
Date: Tue, 19 Aug 2025 12:35:26 +0100
From: Will Deacon <will@kernel.org>
To: Nathan Chancellor <nathan@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Arnd Bergmann <arnd@arndb.de>, Kees Cook <kees@kernel.org>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>, linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev, patches@lists.linux.dev,
	Catalin Marinas <catalin.marinas@arm.com>,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 04/10] arm64: Remove tautological LLVM Kconfig conditions
Message-ID: <aKRhfmLHzjgi-HiJ@willie-the-truck>
References: <20250818-bump-min-llvm-ver-15-v1-0-c8b1d0f955e0@kernel.org>
 <20250818-bump-min-llvm-ver-15-v1-4-c8b1d0f955e0@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250818-bump-min-llvm-ver-15-v1-4-c8b1d0f955e0@kernel.org>

On Mon, Aug 18, 2025 at 11:57:20AM -0700, Nathan Chancellor wrote:
> Now that the minimum supported version of LLVM for building the kernel
> has been bumped to 15.0.0, two sets of always true conditions can be
> safely removed in the arm64 Kconfig file.
> 
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  arch/arm64/Kconfig | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)

Acked-by: Will Deacon <will@kernel.org>

Will
