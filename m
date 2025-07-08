Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09AC02E5432;
	Tue,  8 Jul 2025 18:05:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751997935; cv=none; b=N/rcTII9EwZRhtb4DngEKhPxyOjp8L90QXvtucD47F98RgAMvyRJl2nTRuk8+bTvProLs2hVuVvOm0OZpo96xGQmzV2Hx1XPYZAnAw+ja+G/4E/COtefur9WUTEjppTWjbPY2L5FOrtQUCFRO6SREvUc/JwI5BJ+Ll5paXpLDM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751997935; c=relaxed/simple;
	bh=pAw/NX6D/9R3enbvMJkn6vPzRMh/4X/nC1/EiBmbzJc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bVANuyDqjA0jx66xOCV9euRSQOWobzfc3hQCpAzZWBfb8pSoNijBIEJXEc8r/g/6K+5Ztw+ulrPOzk2ruBxrTJnHLpetHRb3yIsqFtksNnWan7w+axllfSC5nVDxU/Z8LYAAlQ9nom7EEfKN588sHBy+I+awmCLBk6WJZUOBku4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nDqdpqgE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nDqdpqgE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1547BC4CEED;
	Tue,  8 Jul 2025 18:05:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751997934;
	bh=pAw/NX6D/9R3enbvMJkn6vPzRMh/4X/nC1/EiBmbzJc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nDqdpqgE4pAi0KjyPUcXTcBUOn9erqKWU49ZCTAZy7mJvDlFnCthWF1Y6zaC/0skw
	 JngHXt627MGMUpU1cJogoqF5sWA+z8RvxsHQNQfWFpZhWn3+Vpy2+1tJRuKobZQCG6
	 d23ikqhGQS+ZG1tmKq6BKXciTVNR8qlRy76yIsz4=
Date: Tue, 8 Jul 2025 20:05:29 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Florian Fainelli <f.fainelli@gmail.com>, stable@vger.kernel.org,
	Kim Phillips <kim.phillips@amd.com>,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 5.15 000/160] 5.15.187-rc1 review
Message-ID: <2025070823-mutt-challenge-fab8@gregkh>
References: <20250708162231.503362020@linuxfoundation.org>
 <2438aa80-091d-4668-90e0-fb75f3e0b699@gmail.com>
 <20250708172319.GEaG1UB5x3BffeL9VW@fat_crate.local>
 <12b05333-69c2-42b7-89ea-d414ea14eca0@gmail.com>
 <20250708174509.GGaG1ZJSHsChiURgHW@fat_crate.local>
 <20250708175101.GHaG1aha99JuQVYj73@fat_crate.local>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250708175101.GHaG1aha99JuQVYj73@fat_crate.local>

On Tue, Jul 08, 2025 at 07:51:01PM +0200, Borislav Petkov wrote:
> On Tue, Jul 08, 2025 at 07:45:09PM +0200, Borislav Petkov wrote:
> > Right, it needs the __weak functions - this is solved differently on newer
> > kernels. Lemme send updated patches.
> 
> Greg, here's an updated 5.15 patch:

Now updated, thanks.

greg k-h
