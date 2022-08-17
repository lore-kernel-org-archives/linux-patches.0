Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E86D7460
	for <patches@lists.linux.dev>; Wed, 17 Aug 2022 20:19:46 +0000 (UTC)
Received: by mail-pl1-f179.google.com with SMTP id d16so12904123pll.11
        for <patches@lists.linux.dev>; Wed, 17 Aug 2022 13:19:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=Z+/X/75bBL1X3xsZrV1lTZe7BZitkYfkSNopepMWJKw=;
        b=oKYN0loFeYxDm/+GmetyCtu1Ide2ixq91BmZy0oTuo45P4P+q3Abg106InTVGckOgg
         RCcY1a+ofoPtHc/7lKDqjCoeOrZvULlcVla/FR4bwd20lUWqz9ZxigaIhUlPVtwyrazL
         0PS3yq8YtCDvODS/mqEAnPbQgEXpOjP6z1F8k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=Z+/X/75bBL1X3xsZrV1lTZe7BZitkYfkSNopepMWJKw=;
        b=Ia6/+ngGd5bzQvjNntSLJU6E8DfGtyLlO10GKNvvoLJcpdCiDZIHzS7wBabvEf/abY
         /n9vbs9ihOSe93o6nrEu0r7ZKYhTCytIziNENxqDO+EJJdU+Wa0zru4oC6aeKLmoIMJX
         EMp4ccoP40UdBDevlGelquBR7TxbR8GU4NSM4yHYY9Hb3rv/lSUBfi4NScbK1TpRQjdU
         gVsrT80raRzxcxKzzEzPBMJHJ4dBNs3yrXea1w72yzj1T6ok4wIFWdVDTvjhmAV4rEb+
         T5gvNFa0M+Ztx2heZfNubBNA1kXBTTbTOtpxk8hbEj/ZkSAg6822zDshB7tHPTMX9WWm
         OPaQ==
X-Gm-Message-State: ACgBeo14D//OKsFgBnH7LMakmaSytCHb8iro3Fjuk3XXXq57OvrGuMfo
	iqhzW7C9VoKBDLEYoSf8ZtWTRw==
X-Google-Smtp-Source: AA6agR7t6b2bE50K3de+5K4xMjXCNNOZWLiR9tXvxHlFRyvai7VeC3fBB/IeTXm527t46GMvyFgktg==
X-Received: by 2002:a17:903:24f:b0:172:7d68:cf1 with SMTP id j15-20020a170903024f00b001727d680cf1mr8575172plh.55.1660767585612;
        Wed, 17 Aug 2022 13:19:45 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id r15-20020aa7988f000000b0052d51acf115sm10846638pfl.157.2022.08.17.13.19.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Aug 2022 13:19:44 -0700 (PDT)
Date: Wed, 17 Aug 2022 13:19:43 -0700
From: Kees Cook <keescook@chromium.org>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, patches@lists.linux.dev,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Wedson Almeida Filho <wedsonaf@google.com>
Subject: Re: [PATCH v9 22/27] rust: add `.rustfmt.toml`
Message-ID: <202208171319.24AA0B250@keescook>
References: <20220805154231.31257-1-ojeda@kernel.org>
 <20220805154231.31257-23-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220805154231.31257-23-ojeda@kernel.org>

On Fri, Aug 05, 2022 at 05:42:07PM +0200, Miguel Ojeda wrote:
> This is the configuration file for the `rustfmt` tool.
> 
> `rustfmt` is a tool for formatting Rust code according to style guidelines.
> It is very commonly used across Rust projects.
> 
> The default configuration options are used.
> 
> Co-developed-by: Alex Gaynor <alex.gaynor@gmail.com>
> Signed-off-by: Alex Gaynor <alex.gaynor@gmail.com>

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
