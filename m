Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EA5E15F335;
	Tue,  7 May 2024 14:33:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715092401; cv=none; b=iciMn6HyLAe9jfgwGk/HvfO6bkTgjLi4fCUfgKagyyfZlxZkO+p4Kw3AVK8Fs+WenineNuD+qci0qOWErjqEcSk4WOzCP7nGNCrXVw3kTQdzS2VHkJmTqZeVquecNIaXj3cYclK5dD8xxx+2ENXXwsW357Di/elKHbFLdkVRHU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715092401; c=relaxed/simple;
	bh=EBmRdpXpY3jTuvjE4yr75q9neMahEjgCbpk68GxzIw8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W/JxSj1O0kORijlMFErl0if3tywaUS824RWypzcKERh7Fk+xBKBX5IeRzW6LvnUFrcCrxX1BqwlQbUQKA33skabZKEU62g7dfq5bC37Kpo3sEDrONQgHb9oHCAwtq6tfgr9skyzAGAftmhL5DY/XvcTQQsiveNfXPVKpPJoS/pA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bmQBMUrP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bmQBMUrP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3302C2BBFC;
	Tue,  7 May 2024 14:33:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715092401;
	bh=EBmRdpXpY3jTuvjE4yr75q9neMahEjgCbpk68GxzIw8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bmQBMUrPQBcSMpETW16eR5aaMhhaSBxw394wOLqCfmVBeDzMrHvubtRvko4pnrvzy
	 l2H1avHk9dzyyW9H8mdYNYogNbfzASksMdijFC/n089+Ewcd5Mp2ahuT89sqtytxPD
	 /t6EIayh1+EnLfcmVBen0du/go+XD9RzlR+y6LdxxKGX8SL2uABaYqsuaXfhlHjYeP
	 J46wTWlorZUUctaDLxN2SLFjI65eIId4xShLp97lDE2QaY7kVgt6rnfbazkVH5+F3F
	 8e4SD2ouNP63z6zgQHxFeFsvcq1+cLobjWeOoZiZl8im/XeIHlu8IEnU2j4fGrMGhl
	 WJLefNTNqLPsA==
Date: Tue, 7 May 2024 07:33:18 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Heiko Carstens <hca@linux.ibm.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Thomas Huth <thuth@redhat.com>,
	Alexandra Winter <wintera@linux.ibm.com>,
	Thorsten Winkler <twinkler@linux.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jiri Slaby <jirislaby@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>, netdev@vger.kernel.org,
	llvm@lists.linux.dev, patches@lists.linux.dev,
	Sven Schnelle <svens@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>
Subject: Re: [PATCH 0/6] s390: Unify IUCV device allocation
Message-ID: <20240507143318.GC2746430@thelio-3990X>
References: <20240506194454.1160315-1-hca@linux.ibm.com>
 <20240507123220.7301-A-hca@linux.ibm.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240507123220.7301-A-hca@linux.ibm.com>

On Tue, May 07, 2024 at 02:32:20PM +0200, Heiko Carstens wrote:
> On Mon, May 06, 2024 at 09:44:48PM +0200, Heiko Carstens wrote:
> > Unify IUCV device allocation as suggested by Arnd Bergmann in order
> > to get rid of code duplication in various device drivers.
> > 
> > This also removes various warnings caused by
> > -Wcast-function-type-strict as reported by Nathan Lynch.
>                                              ^^^^^^^^^^^^
> 
> Ahem :)
> 
> This should have been Nathan Chancellor, of course. Sorry for this!

Heh, at least you got it right on the patches :)

Cheers,
Nathan
