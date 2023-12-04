Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6C7D2E620;
	Mon,  4 Dec 2023 16:38:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f0farfNv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE58CC433C7;
	Mon,  4 Dec 2023 16:38:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701707931;
	bh=JHtYmLNOxKHUHnIRpa1CjyWd1UkoeV3QLijEIKC2wyU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=f0farfNvQ6WrKcGdv0CyrIu1luDY9YiK58BzASh1vL+vh1JdKdQ2uN38g/DWY7Vtw
	 pHzPxbvZ4jA0mYbihIbbRBUDcG+4h0zUK62gsx8WpIUwKfFrrtQUifu5Wpw1MrjCP5
	 ZV/bqH18fRzw+M9lhW6vQExm64ZYzSumxn+c22GbRhBTjvhbOaIt3LQhMERUEWrV5C
	 CwNElaVU1BZIDXvkH6RVUhREodfn4Pfg1mD9pG1WMR2pQo46kExoaPTxAzKZj/ghg4
	 shyhH6rcPS3Gjy+23GVD5OqYOSMsBa/SHtZWrKD6/hmhzGa2H1hAmUz4EiIuvN1exv
	 ABRSWZI8iwgnA==
Date: Mon, 4 Dec 2023 09:38:49 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: akpm@linux-foundation.org, hca@linux.ibm.com, gor@linux.ibm.com,
	borntraeger@linux.ibm.com, svens@linux.ibm.com,
	linux-s390@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH 2/2] s390/traps: Only define is_valid_bugaddr() under
 CONFIG_GENERIC_BUG
Message-ID: <20231204163849.GA7186@dev-arch.thelio-3990X>
References: <20231130-s390-missing-prototypes-v1-0-799d3cf07fb7@kernel.org>
 <20231130-s390-missing-prototypes-v1-2-799d3cf07fb7@kernel.org>
 <ZW2Wo6xlXU47HrSF@li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZW2Wo6xlXU47HrSF@li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com>

On Mon, Dec 04, 2023 at 10:06:43AM +0100, Alexander Gordeev wrote:
> On Thu, Nov 30, 2023 at 05:22:33PM -0700, Nathan Chancellor wrote:
> 
> Hi Nathan,
> 
> > When building with -Wmissing-prototypes without CONFIG_GENERIC_BUG,
> > there is a warning about a missing prototype for is_valid_bugaddr():
> > 
> >   arch/s390/kernel/traps.c:46:5: warning: no previous prototype for 'is_valid_bugaddr' [-Wmissing-prototypes]
> >      46 | int is_valid_bugaddr(unsigned long addr)
> >         |     ^~~~~~~~~~~~~~~~
> > 
> > The prototype is only declared with CONFIG_GENERIC_BUG, so only define
> > the function under the same condition to clear up the warning, which
> > matches other architectures.
> 
> Thanks for the fix!
> The patch is fine, although I have not been able to reproduce the warning. 
> How did you trigger it?

Thanks for taking a look! I am able to trigger this on v6.7-rc4 with:

  # Flip off CONFIG_BUG in menuconfig
  $ make -skj"$(nproc)" ARCH=s390 CROSS_COMPILE=s390-linux- KCFLAGS=-Wmissing-prototypes defconfig menuconfig arch/s390/kernel/traps.o
  arch/s390/kernel/traps.c:46:5: warning: no previous prototype for 'is_valid_bugaddr' [-Wmissing-prototypes]
     46 | int is_valid_bugaddr(unsigned long addr)
        |     ^~~~~~~~~~~~~~~~

I initially found this by testing just the tinyconfig target.

> > Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> > ---
> >  arch/s390/kernel/traps.c | 2 ++
> >  1 file changed, 2 insertions(+)
> ...
> 
> Thanks!
