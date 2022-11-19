Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 757D2362
	for <patches@lists.linux.dev>; Sat, 19 Nov 2022 00:20:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B422C433C1;
	Sat, 19 Nov 2022 00:20:10 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="OiCwvmLK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1668817207;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Zc5Gig4VbI4saQAOBF8fdoMv4wyPQ60/rO49VQYER9w=;
	b=OiCwvmLK9GFpbvFfKRHvzf0VLzzAq+B3elInHWpjexo2STNnnLPWojyXuNT9ff4TJgOoyY
	fq8CVZMhsZhng9PsdZfITNjcFDNBV5kH7l/axDo1hQeN6dzsPpz3GOGoVdzbhzegkxKcSK
	IOPZHTjp7WjcrLLJEBXrn92MfczltYM=
Received: 
	by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id ffce2f31 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
	Sat, 19 Nov 2022 00:20:07 +0000 (UTC)
Date: Sat, 19 Nov 2022 01:20:05 +0100
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
To: linux-kernel@vger.kernel.org, patches@lists.linux.dev
Cc: linux-crypto@vger.kernel.org, x86@kernel.org,
	Thomas Gleixner <tglx@linutronix.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Adhemerval Zanella Netto <adhemerval.zanella@linaro.org>,
	Carlos O'Donell <carlos@redhat.com>
Subject: Re: [PATCH v4 1/3] random: add vgetrandom_alloc() syscall
Message-ID: <Y3ghNUQ8WDROiVHh@zx2c4.com>
References: <20221118172839.2653829-1-Jason@zx2c4.com>
 <20221118172839.2653829-2-Jason@zx2c4.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20221118172839.2653829-2-Jason@zx2c4.com>

On Fri, Nov 18, 2022 at 06:28:37PM +0100, Jason A. Donenfeld wrote:
> diff --git a/arch/x86/entry/syscalls/syscall_32.tbl b/arch/x86/entry/syscalls/syscall_32.tbl
> index 320480a8db4f..ea0fbc2ded5e 100644
> --- a/arch/x86/entry/syscalls/syscall_32.tbl
> +++ b/arch/x86/entry/syscalls/syscall_32.tbl

This also needs to be wired into unistd.h, sys_ni.c, and
checksyscalls.sh, with its definition dependent on a new
__ARCH_WANT_VGETRANDOM_ALLOC macro symbol, like all the other new
syscalls that get added arch-by-arch. I'll do this for v+1.

Jason
