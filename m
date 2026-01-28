Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 064D430F7FA;
	Wed, 28 Jan 2026 16:20:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769617222; cv=none; b=qAU5hzCRD7SuLQb1e9+hC8icdZmGE89gAMgpAjz7Dq2vigzfzhm1Sloi3vxr+tixdeiGo4G+S6eL+LyM2GOgvBtj8Yndd75hW6024Zh1ng4NtvUxDPoWo5jEIlbnbLSGdn0mbQCeYOU49F5AuQY6ewhPZ19sTiaC9unPOPf0ypA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769617222; c=relaxed/simple;
	bh=crfcBmOykSJDlVc1bA7m7RqiC568isPaU9MWduiqIww=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IGMkGCuiQ1nmoq2T6NzeqBh1DvdkXS/IZfGC1mKQbehSrzlj6mwu+ZMKsBe6sfRFQkoGVZey6IHyy6TCzLh6OvY3W3tdHTsgRRYeMUAJsk9qNC7deUBVprop3JnTbq0gKFzgQDteUu4muLSWhRPSPORT2LLWpXh0QNICPLR6C0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G01FQMlL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G01FQMlL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A15AC4CEF1;
	Wed, 28 Jan 2026 16:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769617221;
	bh=crfcBmOykSJDlVc1bA7m7RqiC568isPaU9MWduiqIww=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=G01FQMlLZ7YlS2b46ZJW4fjUacYce2EhsvwCf3Azy2HsB2YxEu/K84gQDKW2nOfRL
	 miLFDLgaj66VC676eHw+BedJukDwpxnXW37DjKtfA38cxofCCt/8bEI0LEBi98HrHi
	 tf7Xbns2YvbccbY7qAANZBJ7sVk3NdttEGJF6euRkjY9prX0jioy7nTZV4AkZMd0m0
	 td56MfIydqsvQ43EaMcft+zWwTlhItmjwxF6MkADqy9xupckKB1PdapR0jYb/g1MWp
	 xLTrnMr8QXl/lS8UVxJ0AJDMMhvwCsV5DYkB0YrpVjnAQujyaTm4z5pBep9b3oFynZ
	 udeurPUJb0gpg==
Date: Wed, 28 Jan 2026 13:20:18 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Leo Yan <leo.yan@arm.com>
Cc: Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>,
	gregkh@linuxfoundation.org, irogers@google.com,
	james.clark@linaro.org, namhyung@kernel.org,
	patches@lists.linux.dev, sashal@kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 6.6 176/737] perf arm-spe: Extend branch operations
Message-ID: <aXo3Qu41VYvoG0tU@x1>
References: <20260109112140.649989422@linuxfoundation.org>
 <20260127183832.458213-1-hamzamahfooz@linux.microsoft.com>
 <20260128090223.GD1339236@e132581.arm.com>
 <aXo1qx1b3HW_HQS3@x1>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aXo1qx1b3HW_HQS3@x1>

On Wed, Jan 28, 2026 at 01:13:35PM -0300, Arnaldo Carvalho de Melo wrote:
> On Wed, Jan 28, 2026 at 09:02:23AM +0000, Leo Yan wrote:
> > Hi,
>  
> > [ + Arnaldo ]
>  
> > On Tue, Jan 27, 2026 at 10:38:30AM -0800, Hamza Mahfooz wrote:
> > 
> > > It appears that this patch broke the build, see:
> > > 
> > > In file included from util/arm-spe-decoder/arm-spe-pkt-decoder.h:10,
> > >                  from util/arm-spe-decoder/arm-spe-pkt-decoder.c:14:
> > > linux/tools/include/linux/bitfield.h: In function ‘le16_encode_bits’:
> > > linux/tools/include/linux/bitfield.h:166:38: error: implicit declaration of function ‘cpu_to_le16’ [-Wimplicit-function-declaration]
> > >   166 |         ____MAKE_OP(le##size,u##size,cpu_to_le##size,le##size##_to_cpu) \
> > >       |                                      ^~~~~~~~~
> > > linux/tools/include/linux/bitfield.h:149:16: note: in definition of macro ‘____MAKE_OP’
> > >   149 |         return to((v & field_mask(field)) * field_multiplier(field));   \
> > >       |                ^~
> > > linux/tools/include/linux/bitfield.h:170:1: note: in expansion of macro ‘__MAKE_OP’
> > >   170 | __MAKE_OP(16)
> > >       | ^~~~~~~~~
>  
> > FYI, the fix has been sent out:
> > https://lore.kernel.org/linux-perf-users/20260123-perf_fix_bitfield-h-v2-1-cc8f8752607c@arm.com/
> 
> Thanks, applied to perf-tools-next, I also added a Reported-by: Hamza,

Humm, this applies cleanly to perf-tools-next and seems legit as
bitfield.h uses things defined in kernel.h, but then it drifts further
from what is in the tools kernel.h :-\

Anyway, I'll keep it there for now.

- Arnaldo
