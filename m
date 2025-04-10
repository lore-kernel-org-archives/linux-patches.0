Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00EE81DFDE;
	Thu, 10 Apr 2025 07:05:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744268724; cv=none; b=K9PuvyhPxsav6uOQggnGP4J4rQjYKur1tAgO7l0M5mu05maMdmONokhH3epHVy7aT7LfMpEN/Ex+GsIeCDh0bMJbcdK3ddnoF89dFCAzkU0GcwftPFMPAe7uw7IrfqAGCtoxdQc3zTP4S6q/pEow/4g0blCBJliDPIGCbx3/MXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744268724; c=relaxed/simple;
	bh=DhdU5pEhXy+/Uw0gNSI0cmnBvP3H6wKmdY/csmwJkz4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WN4uM6d0cW8nfJ5rrDvMTZaCqIi9XI9rpJa3PRBRJBcsNJkbmaObRpky/hIxU6UkQgu29AM7p4kOVQexOFufaX/K6fldLQ37VmhABeokM7njJmm2PV1QwrE/S8jhm+Ww+hVGYvupzz3rluJJbt16HNA0ZUMjO/vnpG9YwNbdjHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aQcFIxCO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aQcFIxCO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8C46C4CEE3;
	Thu, 10 Apr 2025 07:05:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744268723;
	bh=DhdU5pEhXy+/Uw0gNSI0cmnBvP3H6wKmdY/csmwJkz4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=aQcFIxCONv147uDkgoBs6/WZVfNprAI1p9piAL/l8R8orMUMOO32QZXawPx0R7BKx
	 VKUyIrAOeQ3CqjJbalNzbYlZY/k0SNoqIhOhkpVEg8dZgJiFzBGdHVyNtrKyb2jkax
	 0X3r4c+3Lkba8+4+4NVzDFCFqRXMSKym1BUZKTI4=
Date: Thu, 10 Apr 2025 09:03:48 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Jinjiang Tu <tujinjiang@huawei.com>
Cc: riel@surriel.com, mingo@kernel.org, dave.hansen@linux.intel.com,
	luto@kernel.org, mathieu.desnoyers@efficios.com,
	oliver.sang@intel.com, patches@lists.linux.dev,
	peterz@infradead.org, sashal@kernel.org, stable@vger.kernel.org,
	wangkefeng.wang@huawei.com
Subject: Re: [PATCH 6.6 046/152] x86/mm/tlb: Only trim the mm_cpumask once a
 second
Message-ID: <2025041010-scope-endorse-e1a9@gregkh>
References: <20250219082551.866842270@linuxfoundation.org>
 <20250410011329.2597888-1-tujinjiang@huawei.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250410011329.2597888-1-tujinjiang@huawei.com>

On Thu, Apr 10, 2025 at 09:13:29AM +0800, Jinjiang Tu wrote:
> Hi,
> 
> I noticed commit 6db2526c1d69 ("x86/mm/tlb: Only trim the mm_cpumask once a second")
> is aimed to fix performance regression introduced by commit 209954cbc7d0
> ("x86/mm/tlb: Update mm_cpumask lazily")
> 
> But commit 209954cbc7d0 isn't merged into stable 6.6, it seems merely
> merging commit 6db2526c1d69 into stable 6.6 is meaningless.

If you revert it, does everything still work properly?  If so, can you
submit a patch to revert it if you think it should be removed, from all
affected branches?

thanks,

greg k-h
