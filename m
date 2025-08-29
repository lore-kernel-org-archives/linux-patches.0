Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 291358821;
	Fri, 29 Aug 2025 04:24:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756441487; cv=none; b=hCt8gxqaBcF1qnhQgLAbaOPhFMr3wVoyIXZfKEFX8x/M7GSSXGI9F0J6ui4NPkZ3errK6fXyh0uASApUtOeJ+NXDCowTgorqHDZwl804o3etBuFBTvTZbW3tAgk20ExhQZfEZSF2udVtQDffHH2FqK6DZR+kQAovnW1UF9tp3no=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756441487; c=relaxed/simple;
	bh=+Wvd72o7ZtE+ZqsSmtiGr2ia12B4kB1oquqZlbviQgI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t4luJJUhvCgIwyM3TUtG0dMFY4yujSgnGkoPVaRB9sW3Qo8Cyei3COibJgEhqkVCk8rt+NHKihSen7MHw1xg3NYZM0chfbeosQkVKyTpgcfcPoirMqeWybXaclf6BMlAg5d9ZEoCN2JCGzvkuldhpu6tIdDA6DkUZflRQtqjaN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WEDP+2uP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WEDP+2uP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DCC2C4CEF0;
	Fri, 29 Aug 2025 04:24:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756441486;
	bh=+Wvd72o7ZtE+ZqsSmtiGr2ia12B4kB1oquqZlbviQgI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WEDP+2uPVNaqwLhuHtO97c1FA3DCnC/u9P55etp2vKEoWJUI2G8BDacFL7TBMfeCW
	 9HAQt16e/ZKtlplRNGK0DfO791lHF3zk3pRdLn7iB+S4EZJKwMAxZGcOFemNOvK60l
	 +6Rvw0dIxNBRiQIEyxQxPfxvMb4zPn982EkAxPNw=
Date: Fri, 29 Aug 2025 06:24:42 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Sherry Yang <sherry.yang@oracle.com>
Cc: johannes.berg@intel.com, patches@lists.linux.dev, repk@triplefau.lt,
	sashal@kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 098/403] Reapply "wifi: mac80211: Update skbs control
 block key in ieee80211_tx_dequeue()"
Message-ID: <2025082931-repurpose-unfeeling-04fb@gregkh>
References: <20250826110909.381604948@linuxfoundation.org>
 <20250828225323.725505-1-sherry.yang@oracle.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250828225323.725505-1-sherry.yang@oracle.com>

On Thu, Aug 28, 2025 at 03:53:23PM -0700, Sherry Yang wrote:
> Hi Greg,
> 
> I noticed that only [PATCH 2/2] from the series
> 
> [PATCH wireless 0/2] Fix ieee80211_tx_h_select_key() for 802.11 encaps offloading [1]
> 
> was backported to 5.4-stable, while [PATCH 1/2] is missing.
> 
> It looks like the 1st patch is the prerequisite patch to apply the 2nd patch.
> 
> [1] https://lore.kernel.org/all/cover.1752765971.git.repk@triplefau.lta

What is the git id of the patch you feel is missing?

thanks,

greg k-h
