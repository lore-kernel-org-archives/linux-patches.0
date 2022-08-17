Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 171357460
	for <patches@lists.linux.dev>; Wed, 17 Aug 2022 20:27:38 +0000 (UTC)
Received: by mail-pl1-f172.google.com with SMTP id w14so12923818plp.9
        for <patches@lists.linux.dev>; Wed, 17 Aug 2022 13:27:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=e8AurnYaw5w6q42X379tvVxdUwxeEA/mYjtAY47a6po=;
        b=aLY/bwswAmyWGmv+4JEwglL+yZmZSkY5uTI10+jNpMXObxnDHYBy1/NFE6oNgiy8gm
         8M7QxAggsLjoXwN0tKrViIKk34FBRU2jjAG7OmyyvJlon3HbSz6RYHrCeWoKD7s7v+ey
         WBXTu2wjGczVnm7NC9ChqKPe87n8jYbCFqs3I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=e8AurnYaw5w6q42X379tvVxdUwxeEA/mYjtAY47a6po=;
        b=hWM8cZdESOd5RpA+CgNfgy3g9rZkNRh8Aw6l9P1OM/U6pKrxhHYtn8dvxZTdwWVnpC
         dhtcXyWaYUi7GwatbhEBoVAlNeg5q9q2v/LbTrLjjV+bUsdDQJRsvjrhHuSU/L/lp376
         FIB6J+C0xpegaayJswCPeQl3C4wnx30Xpb4ZkioiA3NrIAl1Jwi9V4RTRwuCFSy2k5Rh
         rLWmE7et5CcUHWcSQZZFMTjDcjhhoTEImbX82I6+I1ZxNaZsrZrVzfMPh/ms30CKV82L
         1UKzCTgRL82GMZ6fn0swx3F075ttzUDkJjirX2kENc99bkbgtT49CkfwYBbOYRAj7nlO
         d0ig==
X-Gm-Message-State: ACgBeo2CURBvd+qybbrAER9lvAnF+lU+0TVq1hzA+3LLfft/5BZOAlUm
	Ok2I6s8SQgoLHxcA9EgPcwN/XA==
X-Google-Smtp-Source: AA6agR5S9YLS9hTLBjiPpJ4Ms8k04xxDQPAV7b2x3cjD+0b+HLPqSTmwLa6D1Y6x82x152TjEZlwVw==
X-Received: by 2002:a17:902:cccb:b0:172:60b7:4590 with SMTP id z11-20020a170902cccb00b0017260b74590mr20507691ple.152.1660768058582;
        Wed, 17 Aug 2022 13:27:38 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id a8-20020a1709027e4800b0016efa52d428sm320362pln.218.2022.08.17.13.27.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Aug 2022 13:27:37 -0700 (PDT)
Date: Wed, 17 Aug 2022 13:27:36 -0700
From: Kees Cook <keescook@chromium.org>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, patches@lists.linux.dev,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Wedson Almeida Filho <wedsonaf@google.com>,
	David Gow <davidgow@google.com>, Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>, linux-doc@vger.kernel.org
Subject: Re: [PATCH v9 25/27] x86: enable initial Rust support
Message-ID: <202208171327.EFF61F0E@keescook>
References: <20220805154231.31257-1-ojeda@kernel.org>
 <20220805154231.31257-26-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220805154231.31257-26-ojeda@kernel.org>

On Fri, Aug 05, 2022 at 05:42:10PM +0200, Miguel Ojeda wrote:
> Note that only x86_64 is covered and not all features nor mitigations
> are handled, but it is enough as a starting point and showcases
> the basics needed to add Rust support for a new architecture.
> 
> Co-developed-by: Alex Gaynor <alex.gaynor@gmail.com>
> Signed-off-by: Alex Gaynor <alex.gaynor@gmail.com>

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
