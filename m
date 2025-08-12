Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8A9B2FA0CD;
	Tue, 12 Aug 2025 18:14:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755022459; cv=none; b=BYbRlsSGx5u18WMrt8GAF9wGzAr1wbO2mtgEncbafVp+Vzm+q/s0zrqOC82EwB56VJcgrlaIxdIo6t2pmwej0NiJBtEKV81Alkww92z1VPtVotmQFdPXhj7PW7MeRFqzFZ1REYIGGK0hVUccTyNBogbAu7a9FPkjBYyM6SfVmVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755022459; c=relaxed/simple;
	bh=VmrpRKtM7N51IJRBtTBXWCOP0fTx0o1iwswVLNBzMg4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZRLTkxNSNoCVMWmCYBg/61ZD8+wdIGkPWdrDiAEKr65JegWhV/M2+SwMR6dWML8nSdY9zTMb7gMUK+kxz39/i1uhGcpdQVpoYOw0gUnpd5ftZ5I/RGDbPfVSz9/XdPq/fX3EKW72yx8aVW5QKvxrj9tDgn9c5ub4CKsjNWNxcA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=cwHg1Oz8; arc=none smtp.client-ip=95.215.58.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="cwHg1Oz8"
Date: Tue, 12 Aug 2025 14:14:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1755022453;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2EDsHuKgrcOXt7+lUYZ6ErBxx9VTMtT8I0yVMjcAQvs=;
	b=cwHg1Oz8dIuJfpUfpFtG2Jia47gBAYAtmi31aVFs+8+heQqJOYm+wIdvO+Bz1dlX6RYNQC
	1HG4lJ5HPGn0UEVPPpwRjNCVfADYgfXazLATFUEnxSI10lNGzg2QHBZDL25ogN+vm4h/Q/
	Uo/ob+Bur255ipelMhX6a3wBi9vLz28=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Nathan Chancellor <nathan@kernel.org>
Cc: Francis Rossi <francisdrossi@gmail.com>, 
	linux-bcachefs@vger.kernel.org, llvm@lists.linux.dev, patches@lists.linux.dev
Subject: Re: [PATCH] bcachefs: Add statement to switch in
 check_bch_counter_ids_unique()
Message-ID: <f3b2x67iskjvea7p2mxsoob25aumgdy3rbvbl7a5gqhrtjwbjo@cwwd75ghhhnb>
References: <20250812-bcachefs-fix-switch-check_bch_counter_ids_unique-v1-1-def262fd6574@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250812-bcachefs-fix-switch-check_bch_counter_ids_unique-v1-1-def262fd6574@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Tue, Aug 12, 2025 at 11:02:11AM -0700, Nathan Chancellor wrote:
> Clang warns (or errors with CONFIG_WERROR=y):
> 
>   fs/bcachefs/sb-counters_format.h:132:2: error: label at end of compound statement is a C23 extension [-Werror,-Wc23-extensions]
>     132 |         }
>         |         ^
> 
> In older versions of clang, this is an unconditional hard error:
> 
>   fs/bcachefs/sb-counters_format.h:130:34: error: label at end of compound statement: expected statement
>           BCH_PERSISTENT_COUNTERS()
>                                    ^
>                                     ;
> 
> Add an empty statement to resolve the error/warning.
> 
> Fixes: 38de86383436 ("bcachefs: Switch statement evaluate ids and confirm they are unique going forward")
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>

Thanks, applied.

> ---
>  fs/bcachefs/sb-counters_format.h | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/fs/bcachefs/sb-counters_format.h b/fs/bcachefs/sb-counters_format.h
> index bfeb713dd210..96ad64920810 100644
> --- a/fs/bcachefs/sb-counters_format.h
> +++ b/fs/bcachefs/sb-counters_format.h
> @@ -129,6 +129,7 @@ static inline void __maybe_unused check_bch_counter_ids_unique(void) {
>  #define x(t, n, ...) case (n):
>          BCH_PERSISTENT_COUNTERS()
>  #undef x
> +		;
>  	}
>  }
>  
> 
> ---
> base-commit: 65c604dba89a86d3dae0bd98b7b0b6c077ac930c
> change-id: 20250812-bcachefs-fix-switch-check_bch_counter_ids_unique-2888b136b877
> 
> Best regards,
> --  
> Nathan Chancellor <nathan@kernel.org>
> 
