Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 090E980A
	for <patches@lists.linux.dev>; Sat, 14 Jan 2023 13:49:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D383C433EF;
	Sat, 14 Jan 2023 13:49:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673704152;
	bh=VpGAr1saq4lvsgHwII8KzmddfI2fagasI2f7bdd3tGY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ujvXV1ZNhlLeMltDkHAhOC+F0rK7BifLpACSOGp8aTEqVCXhVGG+UnJbHFU3FBRwN
	 K+xyAHLjzS0b1R8bc9CInxUcqJkTPYt2bvawTyAx4qNfgPRKQgLN10WkzKArYZsItJ
	 EluENQR2jRCRSPcZ/ieGJcJq8fLJJZYyT+teCtyg=
Date: Sat, 14 Jan 2023 14:49:09 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Stephen Boyd <swboyd@chromium.org>
Cc: stable@vger.kernel.org, Chun-Tse Shao <ctshao@google.com>,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev,
	Nick Desaulniers <ndesaulniers@google.com>,
	Masahiro Yamada <masahiroy@kernel.org>
Subject: Re: [PATCH 5.15.y] kbuild: Allow kernel installation packaging to
 override pkg-config
Message-ID: <Y8Ky1UgT2yxFB2EB@kroah.com>
References: <20230113002149.3984494-1-swboyd@chromium.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230113002149.3984494-1-swboyd@chromium.org>

On Thu, Jan 12, 2023 at 04:21:49PM -0800, Stephen Boyd wrote:
> From: Chun-Tse Shao <ctshao@google.com>
> 
> commit d5ea4fece4508bf8e72b659cd22fa4840d8d61e5 upstream.
> 
> Add HOSTPKG_CONFIG to allow tooling that builds the kernel to override
> what pkg-config and parameters are used.
> 
> Signed-off-by: Chun-Tse Shao <ctshao@google.com>
> Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
> Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
> [swboyd@chromium.org: Drop certs/Makefile hunk that doesn't
> apply because pkg-config isn't used there, add dtc/Makefile hunk to
> fix dtb builds]
> Signed-off-by: Stephen Boyd <swboyd@chromium.org>
> ---
> 
> I need this to properly compile 5.15.y stable kernels in the chromeos
> build system.

Is this a new issue?  A regression?  This feels odd to add a new build
feature to an old kernel when nothing changed to require it other than
an external tool suddenly requiring something new?

confused,

greg k-h
