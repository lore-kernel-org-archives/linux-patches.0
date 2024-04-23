Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D233B142E9E
	for <patches@lists.linux.dev>; Tue, 23 Apr 2024 21:18:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713907104; cv=none; b=CUinYoeg7XE4363dHezxTo5vbzyn0aG+dIzmftahAl3SjCfA5DYXV0SdxlEmlkT19E1o7brCVBi40O/AJeiMRQ6JcCpuIPauY/KtsRsHMoOWl9E5HWqLB4mOCvqbEB5QtJQ5uocb9LJjpidfNznTCcNrocvHTxz46QGo0ZTY6Y8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713907104; c=relaxed/simple;
	bh=JwoURZBvHWy64Vuwrmw9D4a2Bdu35FYKiAqYHQlAE64=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CwC12DDPkC2IPzJK1BNOrSxwA/qd5Aluo12Dg2WIJeVkzO/Ok6zMYa0kVY2SfBm40lrF44KBZ8nYSagAQyerdcGshxEsL1kbayNlGemS0VCJgKu0ZiW72JJJNmBU74FOjzsZJcAY0Epl3Jkyl5asMDOf5XmzsA03jNvsLA6Pomc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=aU8bZwlF; arc=none smtp.client-ip=95.215.58.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="aU8bZwlF"
Date: Tue, 23 Apr 2024 17:18:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1713907100;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JwoURZBvHWy64Vuwrmw9D4a2Bdu35FYKiAqYHQlAE64=;
	b=aU8bZwlFl5IEDfbVFUUct9KXfMFMhpM+5/3KaSQv0tbuvSZhieCiT+x/tAaGHHWR9NocfS
	8OwsmXflCEYdXgxn4jooy6x/Px/F5QZ2uAMR5J++mTrKwrNlxkwhTSLrcVjSoJ6nqJkrdh
	9Pbf0po2i9a8ANibqQUtl+dWBPTUvaA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Nathan Chancellor <nathan@kernel.org>
Cc: bfoster@redhat.com, linux-bcachefs@vger.kernel.org, 
	patches@lists.linux.dev
Subject: Re: [PATCH] bcachefs: Fix format specifiers in
 bch2_btree_key_cache_to_text()
Message-ID: <vkagwwju2wrz6bpd43bgpz2uo4zejts24sdqez2ziicrciud6f@xsmc6g74lpud>
References: <20240423-bcachefs-fix-wformat-32-bit-pcpu-v1-1-a10549e5271d@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240423-bcachefs-fix-wformat-32-bit-pcpu-v1-1-a10549e5271d@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Tue, Apr 23, 2024 at 01:12:27PM -0700, Nathan Chancellor wrote:
> When building for a 32-bit target, for which 'size_t' is 'unsigned int',
> there are two warnings around mismatched format specifiers and argument
> types:

Thanks! Applied.
