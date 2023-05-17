Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8348B33F6
	for <patches@lists.linux.dev>; Wed, 17 May 2023 21:48:22 +0000 (UTC)
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-253570deb8dso403579a91.1
        for <patches@lists.linux.dev>; Wed, 17 May 2023 14:48:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684360102; x=1686952102;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FStjf9C3WAEWXLqC6o0Who1T5bvYtIEGryJ/iVLlrM0=;
        b=AC9jzisVW8MFHxu7vJg4gBMsQyCMhJgz8aL2Y6dD29NXcqJfdot/KWUc41EBB9WCYy
         XxUz0HJOc4js3aTYnmwHr+z3xqHtpSp1lIHvD2kiq0xlRIlDDu1kH04RRqTtbV74ZHWQ
         YhLd2PT+w5huyT2CQu6thlNr5yox+ZIKGLw5wmQvxj++XeCIpup4RTfO2wIwTPAfZh1u
         gsKPVg9QSMnoKPKgKEfoHpCMTgRugvSusdvgs9Pq084gfGa9ntFKQG3PgjaL49GnKfMY
         NlLS16gxgTIQ4YsmRbu7yJynAJOnq8nlZaonCLymc6P099hu5XAJo2ZnRL7bffHsFrY8
         jajw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684360102; x=1686952102;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FStjf9C3WAEWXLqC6o0Who1T5bvYtIEGryJ/iVLlrM0=;
        b=jBkiwovr5cJqgqAGkGj0e7KwnQlZETq43ZQs3W6M9ezFg6FySMGogANbDVOgBwTi1B
         BMqyJAz9Dp7yOpacF+8pFaLAPahv1W2kGqzoxHnJWpbboz60AD4ctluzcg0o2WuCo0fD
         0+dsfpPf4OD5QRKb57GsGIMa8WkUugKxRNdgVPpIpfewN10UHF2D9Q8PcQIuct6Xbohu
         rhdtyKdhe9NMxP+nnbPoN60ac8T8XD4Mg+MUDps37M25GDebN3WBIT67MkSJEhxc28wg
         d1N2aCHWuj9JwG5RjfJhbI09A8PnOsQKR7tW6qEZYPvHfuhtvMIxx2XGbox302FzTrbz
         oF5w==
X-Gm-Message-State: AC+VfDx6J27NIJ0ikwcyjgsDCXLYFtNlU1K31A2WkV+bT0veQiHlg5T6
	lUt1K02I7fQcGC3srwJ/UH0=
X-Google-Smtp-Source: ACHHUZ6652DzpGfHOi7OAYBq+TgOZQNW0wXBYSOttt6rDSYXPr3C1VNh7PjvQlrvz/zDcwGJQ1spKQ==
X-Received: by 2002:a17:902:ee42:b0:1ac:753a:7933 with SMTP id 2-20020a170902ee4200b001ac753a7933mr205075plo.39.1684360101434;
        Wed, 17 May 2023 14:48:21 -0700 (PDT)
Received: from localhost (2603-800c-1a02-1bae-a7fa-157f-969a-4cde.res6.spectrum.com. [2603:800c:1a02:1bae:a7fa:157f:969a:4cde])
        by smtp.gmail.com with ESMTPSA id u16-20020a17090341d000b001a98f064a2asm18129670ple.48.2023.05.17.14.48.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 May 2023 14:48:21 -0700 (PDT)
Sender: Tejun Heo <htejun@gmail.com>
Date: Wed, 17 May 2023 11:48:19 -1000
From: Tejun Heo <tj@kernel.org>
To: Alice Ryhl <aliceryhl@google.com>
Cc: rust-for-linux@vger.kernel.org, Miguel Ojeda <ojeda@kernel.org>,
	Wedson Almeida Filho <wedsonaf@gmail.com>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <benno.lossin@proton.me>, linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: Re: [PATCH v1 0/7] Bindings for the workqueue
Message-ID: <ZGVLo1V4kjx_lep5@slm.duckdns.org>
References: <20230517203119.3160435-1-aliceryhl@google.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230517203119.3160435-1-aliceryhl@google.com>

Hello, Alice.

On Wed, May 17, 2023 at 08:31:12PM +0000, Alice Ryhl wrote:
> This patchset contains bindings for the kernel workqueue.
> 
> One of the primary goals behind the design used in this patch is that we
> must support embedding the `work_struct` as a field in user-provided
> types, because this allows you to submit things to the workqueue without
> having to allocate, making the submission infallible. If we didn't have
> to support this, then the patch would be much simpler. One of the main
> things that make it complicated is that we must ensure that the function
> pointer in the `work_struct` is compatible with the struct it is
> contained within.
> 
> This patch could be significantly simplified if we already had the field
> projection bindings. However, we have decided to upstream the current
> version that does not depend on field projection first - the PR that
> introduces field projections will then include a commit that simplifies
> the workqueue implementation. (In particular, it would simplify the 5th
> patch in this series.)
> 
> The first version of the workqueue bindings was written by Wedson, but
> I have rewritten much of it so that it uses the pin-init infrastructure
> and can be used with containers other than `Arc`.

I tried to read the patches but am too dumb to understand much. Any chance
you can provide some examples so that I can at least imagine how workqueue
would be used from rust side?

Thanks.

-- 
tejun
