Received: from mail-yw1-f182.google.com (mail-yw1-f182.google.com [209.85.128.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD0A01B87C0
	for <patches@lists.linux.dev>; Mon,  1 Dec 2025 19:28:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764617341; cv=none; b=Dik10dORpzLlUy4BeYN1hPEuczvWxm+xbRMbHiujj50adQE2O0W7iiCeXPutp1QBGpFCaM93Yn/igDh8gVOUJU51l4XFbWwAx0a5E7umRmdWNLYeF4b0H0UfS76dXxnwAEU4PnfD2PUD23joEJJGpkEzpywBhlUylW2RJXx+sBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764617341; c=relaxed/simple;
	bh=zfeMB2LmDcZWaYDjv7dMc5Q8/0QMwZt5kUiecWTGvyY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NZa6wnqZi2lEVLkBkypqnyHiGVqOa3prMlx243yYW6679PbKDBP6q/gJJDe5nucIw7HGTmqPqGaT9P4WidoZ2k9smFRPFJ4dwbJDJ4l5Nf5LQkz8ENMH642pKJxxRa8x98I1a3nKszkY0wrElHH5XKejlGW6KcYw+3viT0xgp+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=e5OfWLWY; arc=none smtp.client-ip=209.85.128.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="e5OfWLWY"
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-787df0d729dso44091157b3.3
        for <patches@lists.linux.dev>; Mon, 01 Dec 2025 11:28:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764617339; x=1765222139; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=APljFRXaMCw5fST76I/JdjoAg3NunNjrMcBFSHPBuyM=;
        b=e5OfWLWY4pkozz8V66McsrMvLIf6LACI34jTRTqEVBqn2EhEOJydNNH29JQ10KBVKC
         9xVEMp5mFkUG3AHbLDirP8w0aMRLHLbfzDFbvcZcBnrefKOFk208PA3Ydm8a7nLbKYi0
         pIbyvHuZljIPWm+rqmQnouZHQjNQigHpJjntycSo7ZUC7pa8orxZm6uJTjZVxNP2SN8L
         MYO4pDvEN9yFkLL69ZL/L+BSDyEtyOOJpVQ1ATqfvbuck+5437HZ3SWNYJxBvNnEvKyb
         +BSe0YOB4j85Q1ruLzXf0c8SyGcN1HNhx4nFEbGg6RmGZLvYzxswqHdRdYQV3sYkStY1
         ivjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764617339; x=1765222139;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=APljFRXaMCw5fST76I/JdjoAg3NunNjrMcBFSHPBuyM=;
        b=Eko0DBuxiCfP1ytGSbIpPxgi5TnLOi1BKyij2kToFhUni4r+0YBFdN55hYxHsiSjlU
         opqzErHgw1gIt4ibmeCfu/Td/BA5kO5L52HNm5kJBa6ufU1d1pue0DMFo7bpCnQkkhUi
         CX7im8sLGy5/5vYl6ixm+F55keg/PN3QyelPQjsY8IJZH5viLegOKP3e2H5LQGeYZnkN
         by6tUGzSNpkOOdCTdKnImlyNVLlysNIJ+6rlJuP0VBiuLPIt/Mz3c3Ltwq827iCJl3Lx
         C2aLrrywWTyhIgk7hErzBej4HhkpXwFgJlHBbn63efya5tNxiSsGRmUwxosnBsanXJF+
         x6Pg==
X-Forwarded-Encrypted: i=1; AJvYcCUQAhaH9qfCP1ZgNQ+O2v4AC06MAf1XOjWotDnbNgAgGb4xrmgZSgV87tpsEeINR8Uy8p4G8dnq@lists.linux.dev
X-Gm-Message-State: AOJu0YzPAyz+SdkmvoIkQxcTlEoYZ5L/jDcEF0hksQ20paYiqOQLWgKS
	wiQJrl/btjIKjbSP4VNT50xb6yrjsp8ae55776dgwmxI7EOI/zJFcOsQ
X-Gm-Gg: ASbGncuEOxpNmRuVk4g1ZQlROalfvYbrP/RdrK+xenf5DANRAHDQV8CECAerctHf5UL
	gwjYEAPtccrtx8n6mGvo9ejE2w4EuNh6CHC401wxjSTjMEqoJ3ZZTrbHCIiKQSarf5cVLLr7jCD
	+ZbKUpyYzWyaM1dudcJ3j5zaBr6N+9fKOzJNFBNwdVZmoOHfgLPifaI0qIkXydIaZ6WGL+GXLgh
	1hFRvM+VlzIDayTwCj00K/F6Umly+KcH2DmMAMZt3SLYML6TcZ9Eil1+Tmg5em8G7rj18zrtb6+
	5ylJ4LbxIJsH087zisP+EwQ3Py4FIBFmJG1jaUVueDvH/uQQLF+mQLKt5BXx5aVwdLj6wxGiCx+
	h3uHRyJOWviKG/sqLgHhPB6m2JIJjGYecI0HdkY+X8x+kHDE3+vSAy1jbH7i9kBlFiQCv0Y49QC
	7NNvHSvnc=
X-Google-Smtp-Source: AGHT+IEttKn+//7++pOLi55YpQ9X7GejnUD2spd1fxC6Tw+xPr7mkrw42iQi7Zwskp5SI1O4LeCa3g==
X-Received: by 2002:a05:690c:4483:b0:784:8647:4958 with SMTP id 00721157ae682-78a8b56803bmr355020387b3.67.1764617338630;
        Mon, 01 Dec 2025 11:28:58 -0800 (PST)
Received: from localhost ([2601:346:0:79bd:affb:cf6e:b908:f700])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-78ad102d25csm53088337b3.44.2025.12.01.11.28.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Dec 2025 11:28:58 -0800 (PST)
Date: Mon, 1 Dec 2025 14:28:57 -0500
From: Yury Norov <yury.norov@gmail.com>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alice Ryhl <aliceryhl@google.com>, Burak Emir <bqe@google.com>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH] rust: id_pool: fix example
Message-ID: <aS3seTNRum3ZXMom@yury>
References: <20251201000949.1626363-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251201000949.1626363-1-ojeda@kernel.org>

On Mon, Dec 01, 2025 at 01:09:49AM +0100, Miguel Ojeda wrote:
> When building with KUnit doctests enabled, `rustc` reports:
> 
>     error[E0599]: no method named `acquire_next_id` found for struct `IdPool` in the current scope
>         --> rust/doctests_kernel_generated.rs:6722:24
>          |
>     6722 |     assert_eq!(i, pool.acquire_next_id(i).ok_or(ENOSPC)?);
>          |                        ^^^^^^^^^^^^^^^ method not found in `IdPool`
> 
> Thus fix it.
> 
> Fixes: a5726454470c ("rust: id_pool: do not immediately acquire new ids")
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Thanks Miguel,

I applied this, but the fact that you've sent a second fix to
documentation that actually is a build fix, raises the questions.

Because Rust documentation bears compilable chunks of code, I think
we need to enable rustdoc tests target by default, so that developers
will not send broken tests.

Thanks,
Yury

> ---
> I saw this in -next.
> 
>  rust/kernel/id_pool.rs | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/rust/kernel/id_pool.rs b/rust/kernel/id_pool.rs
> index 73a952d7dd83..384753fe0e44 100644
> --- a/rust/kernel/id_pool.rs
> +++ b/rust/kernel/id_pool.rs
> @@ -28,7 +28,7 @@
>  ///
>  /// let mut pool = IdPool::with_capacity(64, GFP_KERNEL)?;
>  /// for i in 0..64 {
> -///     assert_eq!(i, pool.acquire_next_id(i).ok_or(ENOSPC)?);
> +///     assert_eq!(i, pool.find_unused_id(i).ok_or(ENOSPC)?.acquire());
>  /// }
>  ///
>  /// pool.release_id(23);
> 
> base-commit: 00c5ce039598e692e1dd4bf2b3ad5bc08bdf3270
> --
> 2.52.0
