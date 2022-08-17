Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45BEF7460
	for <patches@lists.linux.dev>; Wed, 17 Aug 2022 20:13:36 +0000 (UTC)
Received: by mail-pg1-f174.google.com with SMTP id q16so12878998pgq.6
        for <patches@lists.linux.dev>; Wed, 17 Aug 2022 13:13:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=ecAK1b0BGR4BXz6e6ttRl4yIb91x7Nb5bR2E/kWSLHw=;
        b=jXVV9RG6RKNfj/aJYfUw5290cjSO+bHeeC49GRUXd9iZsYbzUGSM73ZRlDDNkuJZKe
         M4B8e3fSbz5QPTo91nEi4iTwXcctrjQRgcdvksNueL7yMayrNdbkM3QwZ8MnQz5Lw5w7
         c0ORLsabFe3Gm+9qrBL3vWG3OG51cAMRGiFfY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=ecAK1b0BGR4BXz6e6ttRl4yIb91x7Nb5bR2E/kWSLHw=;
        b=3VKCC3kBuQ4t6f3ZjFEuqGMaJ+eo792yLcRcD4cRVyga+u7ZV8A+Hn2qaw9K3z4PDE
         oS0NywTvalue+zJoon/WpV8gl/q1d17a974nq1NqSLROH8V7YUP3d2tTqMN6nWfDk9aP
         Quy2dxK5SWGDf0QOQAfLtaIq4OjPJu/jyFOjQe3lzan1HJ+j9AYBSyiTf5uLCCqlGNby
         5+VbjExzMdbcY215krelfZBjqv6FxX1fbJlpYQRdRl6jXTER56XvM9lUpoW+S2142tuN
         Uz/X7ScGJoI1M27Spm/eSw8ODubHZQFNjUUUaFmQNQMVYnyWsvEXCvXZXDKaPEvNx1/T
         hcjw==
X-Gm-Message-State: ACgBeo2x1NwK5CYedWFIjrS/FB82S3fMRpqfxF1EgbI9z8d/nlxc6TN+
	fuOPUOgHZeL3A3ciS83frimmwQ==
X-Google-Smtp-Source: AA6agR5R6i7GTzzHrmLNyQaH3JQ2CAz656dADZPSQA9APProw72NMYDNMlfcDbQNYdKhk7GwcgQ/hg==
X-Received: by 2002:a63:8442:0:b0:429:85db:b351 with SMTP id k63-20020a638442000000b0042985dbb351mr10410526pgd.430.1660767215661;
        Wed, 17 Aug 2022 13:13:35 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id k29-20020aa79d1d000000b0052bf6789f02sm11235013pfp.178.2022.08.17.13.13.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Aug 2022 13:13:34 -0700 (PDT)
Date: Wed, 17 Aug 2022 13:13:34 -0700
From: Kees Cook <keescook@chromium.org>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, patches@lists.linux.dev,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Alex Gaynor <alex.gaynor@gmail.com>, Finn Behrens <me@kloenk.de>,
	Wedson Almeida Filho <wedsonaf@google.com>,
	Gary Guo <gary@garyguo.net>, Boris-Chengbiao Zhou <bobo1239@web.de>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Boqun Feng <boqun.feng@gmail.com>
Subject: Re: [PATCH v9 18/27] scripts: add `generate_rust_analyzer.py`
Message-ID: <202208171313.093606A6B8@keescook>
References: <20220805154231.31257-1-ojeda@kernel.org>
 <20220805154231.31257-19-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220805154231.31257-19-ojeda@kernel.org>

On Fri, Aug 05, 2022 at 05:42:03PM +0200, Miguel Ojeda wrote:
> The `generate_rust_analyzer.py` script generates the configuration
> file (`rust-project.json`) for rust-analyzer.
> 
> rust-analyzer is a modular compiler frontend for the Rust language.
> It provides an LSP server which can be used in editors such as
> VS Code, Emacs or Vim.
> 
> Co-developed-by: Alex Gaynor <alex.gaynor@gmail.com>
> Signed-off-by: Alex Gaynor <alex.gaynor@gmail.com>

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
