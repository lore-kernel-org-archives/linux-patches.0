Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 706753D1CA5;
	Thu, 26 Feb 2026 21:47:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772142432; cv=none; b=Vv4EPhkAXIhNY0FYAWeXtkjrnOowMdwJUwgL9DnKf93QNfyjFONmV9rxy5LZCt0BN5cqwq4WU+Tlul8931mVN1wurZuU1pREj+ixslUn8M5l9HyLogV+H3XI+ycyEL0IEbI+ExTsRywQ0xH3rHe+3gQnckMYhYjAUwSsXrBOwdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772142432; c=relaxed/simple;
	bh=wvao/W1n8ixelWi/yHBw/ra73ktqsrn9Enzu3HauzIs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QHkriinOQLL5OdN3pH2Bden6kazDFvHhC7EvYol0HY6yMOCxLAip4bbE6lhzOdw2sHFkEpxMKsCtejPefsvNO4YDskGHCpiUXcyc1CKPGVRciEqBm9JWht9/K8g5SsCq4SEg9dflzinitoRUTKAAEaqkacvQIQ1CRQMrVwLca+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fq1AS2DC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fq1AS2DC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9E33C116C6;
	Thu, 26 Feb 2026 21:47:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772142431;
	bh=wvao/W1n8ixelWi/yHBw/ra73ktqsrn9Enzu3HauzIs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fq1AS2DCwz8P/rY5ZGgWg4vS6UbQ7mgI6oESy2iwEyrRL3ISkq0dZg1A13B6FpkgE
	 B791dknlD85cWFpfPbmdPPUkk/ZSFwoceTdjEDVcx9Ehlo+KuA8Q6a3rr2xYBKinrD
	 UNyL9e/s++nlJwUywb3sHo3fae3lsFk1oAzo+flw=
Date: Thu, 26 Feb 2026 13:47:03 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: achill@achill.org, akpm@linux-foundation.org, broonie@kernel.org,
	conor@kernel.org, f.fainelli@gmail.com, hargar@microsoft.com,
	jonathanh@nvidia.com, linux-kernel@vger.kernel.org,
	linux@roeck-us.net, lkft-triage@lists.linaro.org,
	patches@kernelci.org, patches@lists.linux.dev, pavel@nabladev.com,
	rwarsow@gmx.de, shuah@kernel.org, sr@sladewatkins.com,
	stable@vger.kernel.org, sudipm.mukherjee@gmail.com,
	torvalds@linux-foundation.org
Subject: Re: [PATCH 6.19 000/781] 6.19.4-rc2 review
Message-ID: <2026022640-ranked-resigned-83a9@gregkh>
References: <20260225155341.094945851@linuxfoundation.org>
 <20260226201056.28728-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260226201056.28728-1-ojeda@kernel.org>

On Thu, Feb 26, 2026 at 09:10:56PM +0100, Miguel Ojeda wrote:
> The drm/tyr build error (`COMMON_CLK`) is now fixed, from 6.19.1:
> 
>   https://lore.kernel.org/stable/20260215023627.56245-1-ojeda@kernel.org/
> 
> The fixes for the other build error (`COMPAT`) and the warning
> (`unwrap_or`) have not arrived yet.

So should this be backported?  If so, how far back?

thanks,

greg k-h
