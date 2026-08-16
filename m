Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C3AC3BB4A;
	Sun, 16 Aug 2026 10:04:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786874642; cv=none; b=NODyNCaJY054OGaQVVZquRIvECMyXUnO9S1BX5PK0NT3/rjvMDPZ+6nhAgLAXfiYdlXDbSlD215oH8i02T7tNI0sIPStOapk+Fi+VNdjIyHc1h4OfrkughGMst4V+6MHb77DGTrZsRUi6ErHbTLctLtsuj3CiGyc0ei+XWDFg6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786874642; c=relaxed/simple;
	bh=QCHuSXuI82+26HAyEPya2lRT3U2ES6mHe6Iw+/XTO4g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sSEV2WAlmOjad3GW9sHk03jp4YKwsIkiQWcGOpruY0DK2RJhJp1HInNAoDi66Hnd4jXgsLpV3i/0QPGICbw19NGK24HBxK0ix1/dxFQFDsBPGKuPGp7s7pS4FlTgGtsa04HQv/UkYg8V3ixargpr7SttElwYyhpKGQQtmTdRrJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T/Y+R4ot; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T/Y+R4ot"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 855501F000E9;
	Sun, 16 Aug 2026 10:04:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786874641;
	bh=96EAqzlE+l7iETtBQ/wW27Tvy5Yd49LHOVFLdK7D4GE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=T/Y+R4ot066PBcUYwhvBtT8WquE8RO0OuHRhiiQ1WQGlAmL8eomXk6Ru/71qDY82k
	 0D2Ttuau3/AWLzb2xxMtLliBhD6BrvcM8McZ4toXbbtTnnYNxKTwUbY/4n91BN+UL/
	 qWxRTRZCdJqIjiyBT3bYvMxwDueTRn1Gn0VG6GcNkZy/obHGu3jk4TYY+wvgKLnvjo
	 +ClMBNYGxwQazfjblA/7iCbiggpA0HOwBNOI7m62ddG5gebYUYmwGRUjFc93Za2cGJ
	 yN6jyzcoHEt0md1QFl1dbWZthy4TvQm+tT0wfmrHPTO6xKJVpSbgMttms2HtpIR9tv
	 9k82ibZgY1oWg==
Date: Sun, 16 Aug 2026 10:30:05 +0100
From: Harry Yoo <harry@kernel.org>
To: Sasha Levin <sashal@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Nathan Chancellor <nathan@kernel.org>, stable@vger.kernel.org, patches@lists.linux.dev, 
	Danielle Costantino <dcostantino@meta.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Suren Baghdasaryan <surenb@google.com>, "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, bot@kernelci.org, 
	kernelci-results@groups.io
Subject: Re: [PATCH 6.12 289/337] mm/slab: prevent unbounded recursion in
 free path with new kmalloc type
Message-ID: <aoGCsmkycnDCNNfZ@ubuntu-vm-arm64>
References: <20260807143418.516897842@linuxfoundation.org>
 <20260807143424.797445703@linuxfoundation.org>
 <20260807180245.GA4067747@ax162>
 <20260808030732.GA9608581@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260808030732.GA9608581@kernel.org>

On Sat, Aug 08, 2026 at 07:10:33AM -0400, Sasha Levin wrote:
> On Fri, Aug 07, 2026 at 11:02:45AM -0700, Nathan Chancellor wrote:
> >   linux/mm/slab.h:572:24: error: duplicate 'inline' declaration specifier [-Werror,-Wduplicate-decl-specifier]
> >     572 | static __always_inline inline bool need_kmalloc_no_objext(void)
> > 
> > The 'inline' should be dropped, as '__always_inline' includes 'inline'
> > already.

Ouch, thanks for catching.
It's silly that I didn't catch it while testing.

> Fixed in the queue - I dropped the redundant 'inline' and kept
> '__always_inline', so the 6.12 backport now reads:
> 
>   static __always_inline bool need_kmalloc_no_objext(void)

Looks good to me, thanks for fixing!
