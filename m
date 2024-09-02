Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 027C1154C1E;
	Mon,  2 Sep 2024 06:02:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725256973; cv=none; b=gaN0egnC4ot5H9JrlWZ+Z5jOMTTOB1cGOM9Qa+dlNl1IjkmvIR3Il3YqtHIdnn6bEAFxvqib0j8pvC0kfnuEvFvujz7ULfyL07EC8hN15d+l83A7i8GFj0AWV9hur/cuK7Dh2nIQ26jEjI4RftTzw96ZvTkdKEiwk3kKV3J8+Bs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725256973; c=relaxed/simple;
	bh=ovoMCORahu58BxE/Fjouv3G7V1TN4kRwK08WbvgGEI0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Bo5qLzrjmuT4UwSoU1S/yJdVDbEYx6BP7o1iEzGHFYl5SUdUdHDYjYBqXqVqtrodcsAPDlGxn7MuIcNLe1SskiN/vL9e8l9L1gSDD8smKcRbqc5gd832DcuTVQKH+HvAteQELMaQ0c/cYriKZ++21OWi5LGrFEigeFVZv8S8JJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xVflIsin; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xVflIsin"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DBD4C4CEC4;
	Mon,  2 Sep 2024 06:02:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725256972;
	bh=ovoMCORahu58BxE/Fjouv3G7V1TN4kRwK08WbvgGEI0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=xVflIsin0gAgLxHrrjzFnBIX2zTLRW1fiCenlG3X0jQbY223z9tGEIoyCWxGj3fM5
	 0FPBoTpFmqqKc1jp+phIyO8Fxc32qzTfAKcWpsLntMyNFcJVbUW6NPU6liXl27Rrx0
	 ULwkQfemazHW9vjLtKuBBe6S+P4chxVDkHaN32rI=
Date: Mon, 2 Sep 2024 08:02:48 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Kexy Biscuit <kexybiscuit@aosc.io>
Cc: jarkko@kernel.org, patches@lists.linux.dev, stable@vger.kernel.org,
	stefanb@linux.ibm.com, kernel test robot <lkp@intel.com>,
	Mingcong Bai <jeffbai@aosc.io>
Subject: Re: [PATCH] tpm: export tpm2_sessions_init() to fix ibmvtpm building
Message-ID: <2024090259-disfigure-situated-77f9@gregkh>
References: <20240901160817.780395041@linuxfoundation.org>
 <20240902015912.56377-2-kexybiscuit@aosc.io>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240902015912.56377-2-kexybiscuit@aosc.io>

On Mon, Sep 02, 2024 at 09:59:13AM +0800, Kexy Biscuit wrote:
> "tpm: ibmvtpm: Call tpm2_sessions_init() to initialize session support"
> breaks ibmvtpm to be built as a module, since tpm2_sessions_init isn't
> an exported symbol. Proposing the following patch to resolve the issue.
> 
> Also, please disregard for the previous incorrectly formatted email.
> ---
> 
> >From 3e43cfa3466178ec7f4309031647e93565bc70bf Mon Sep 17 00:00:00 2001
> From: Kexy Biscuit <kexybiscuit@aosc.io>
> Date: Mon, 2 Sep 2024 08:26:38 +0800
> Subject: [PATCH] tpm: export tpm2_sessions_init() to fix ibmvtpm building
> 
> Commit 08d08e2e9f0a ("tpm: ibmvtpm: Call tpm2_sessions_init() to
> initialize session support") adds call to tpm2_sessions_init() in ibmvtpm,
> which could be built as a module. However, tpm2_sessions_init() wasn't
> exported, causing libmvtpm to fail to build as a module:
> 
> ERROR: modpost: "tpm2_sessions_init" [drivers/char/tpm/tpm_ibmvtpm.ko] undefined!
> 
> Export tpm2_sessions_init() to resolve the issue.
> 
> Cc: stable@vger.kernel.org # v6.10+

Put the git commit id in a Fixes: tag please?

> Reported-by: kernel test robot <lkp@intel.com>
> Closes: https://lore.kernel.org/oe-kbuild-all/202408051735.ZJkAPQ3b-lkp@intel.com/
> Signed-off-by: Kexy Biscuit <kexybiscuit@aosc.io>
> Signed-off-by: Mingcong Bai <jeffbai@aosc.io>
> ---
>  drivers/char/tpm/tpm2-sessions.c | 1 +
>  1 file changed, 1 insertion(+)


For some reason this patch is attached, and that will not work.  Please
fix up and resend using 'git send-email' or some such tool so that it
can be applied properly.

thanks,

greg k-h
