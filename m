Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9317C2FAE
	for <patches@lists.linux.dev>; Tue, 27 Sep 2022 15:19:46 +0000 (UTC)
Received: by mail-pf1-f179.google.com with SMTP id l65so9959544pfl.8
        for <patches@lists.linux.dev>; Tue, 27 Sep 2022 08:19:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date;
        bh=ozwz/kr75NpC96tOUqziv2FbYDcS1Xg/Xc9JrcnYDIw=;
        b=aD4rrECu2ausOVlLE4gUsa1xeFXbzCDqhUSEM6rCLHK5rgBwyb5IlVpaAwSzAj9rFc
         8ss/JFQrnzUDOWJOgToiGQz3DbeSTLrRlmlivZobo7sNCVAPyZFjQXP4xDr73rtevCI5
         12CxpLpirpMPby3pdyIUMhC7x3a/7EJIzGNLg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date;
        bh=ozwz/kr75NpC96tOUqziv2FbYDcS1Xg/Xc9JrcnYDIw=;
        b=bGxFsRt3vWYnLCPaDRv+j5ORVwMRfei4eoMknB44mZqBBTQMtceaCMd7EG99QwMcb4
         0oHUNQYk9s9jO1sf6fM15aZi7qu38Ki5jdh8B/EY53FcEZc+3fZAq0Oh/LC1YVqmXy9B
         fUj1eX11Jw4C0B01vWCI4/cwtbmHRsgL9ThNNj6naRBMDBDA599uvPCg/fj30gYODmkh
         An/LU+aGhSe/r5V7wrZWUSGD78O0lbJ7JNakN8Rf7jdzmkD3cG+A7hsAea+01OTITJ03
         +v8Qff7Ja9+5Avm3ipwe2rgJoiX74P01HJMP8nX1yoCv6Bxz8xzCZIjQ0yWvq2JkN/GY
         SdoQ==
X-Gm-Message-State: ACrzQf0qEUGmL+CtcCJ3bjEEfSlFmJJtHl3UAh9f1vOhOZSZO2b5eqRb
	uVX/nlvO9Z2bEJ0ujcrqfuR+sOnWGMlW3g==
X-Google-Smtp-Source: AMsMyM6u3m9PcqcUS16zstLBXfgnAsEawKfJRgbn2Z1VogzvRHBpOu67PA1zUb8r5rtEtpXZP+Nddw==
X-Received: by 2002:a63:8942:0:b0:43b:e87e:3fc0 with SMTP id v63-20020a638942000000b0043be87e3fc0mr25309584pgd.531.1664291986021;
        Tue, 27 Sep 2022 08:19:46 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id i14-20020a636d0e000000b0043954df3162sm1653393pgc.10.2022.09.27.08.19.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Sep 2022 08:19:45 -0700 (PDT)
Date: Tue, 27 Sep 2022 08:19:44 -0700
From: Kees Cook <keescook@chromium.org>
To: Wedson Almeida Filho <wedsonaf@gmail.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Geert Stappers <stappers@stappers.nl>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, patches@lists.linux.dev,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Alex Gaynor <alex.gaynor@gmail.com>
Subject: Re: [PATCH v10 27/27] MAINTAINERS: Rust
Message-ID: <202209270818.5BA5AA62@keescook>
References: <20220927131518.30000-1-ojeda@kernel.org>
 <20220927131518.30000-28-ojeda@kernel.org>
 <20220927141137.iovhhjufqdqcs6qn@gpm.stappers.nl>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220927141137.iovhhjufqdqcs6qn@gpm.stappers.nl>

On Tue, Sep 27, 2022 at 04:11:38PM +0200, Geert Stappers wrote:
> On Tue, Sep 27, 2022 at 03:14:58PM +0200, Miguel Ojeda wrote:
> > Miguel, Alex and Wedson will be maintaining the Rust support.
> >
> > Boqun, Gary and Björn will be reviewers.
> >
> > Reviewed-by: Kees Cook <keescook@chromium.org>
> > Co-developed-by: Alex Gaynor <alex.gaynor@gmail.com>
> > Signed-off-by: Alex Gaynor <alex.gaynor@gmail.com>
> > Co-developed-by: Wedson Almeida Filho <wedsonaf@google.com>
> > Signed-off-by: Wedson Almeida Filho <wedsonaf@google.com>
> > Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
> > ---
> >  MAINTAINERS | 18 ++++++++++++++++++
> >  1 file changed, 18 insertions(+)
> >
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index f5ca4aefd184..944dc265b64d 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -17758,6 +17758,24 @@ F:	include/rv/
> >  F:	kernel/trace/rv/
> >  F:	tools/verification/
> >
> > +RUST
> > +M:	Miguel Ojeda <ojeda@kernel.org>
> > +M:	Alex Gaynor <alex.gaynor@gmail.com>
> > +M:	Wedson Almeida Filho <wedsonaf@google.com>
> <screenshot from="response of a reply-to-all that I just did">
>   ** Address not found **
> 
>   Your message wasn't delivered to wedsonaf@google.com because the
>   address couldn't be found, or is unable to receive mail.
> 
>   Learn more here: https://support.google.com/mail/answer/6596
> 
>   The response was:
> 
>     The email account that you tried to reach does not exist. Please try
>     double-checking the recipient's email address for typos or unnecessary
>     spaces. Learn more at https://support.google.com/mail/answer/6596
> </screenshot>

Wedson, can you send (or Ack) the following patch? :)

diff --git a/.mailmap b/.mailmap
index d175777af078..3a7fe4ee56fb 100644
--- a/.mailmap
+++ b/.mailmap
@@ -433,6 +433,7 @@ Vlad Dogaru <ddvlad@gmail.com> <vlad.dogaru@intel.com>
 Vladimir Davydov <vdavydov.dev@gmail.com> <vdavydov@parallels.com>
 Vladimir Davydov <vdavydov.dev@gmail.com> <vdavydov@virtuozzo.com>
 WeiXiong Liao <gmpy.liaowx@gmail.com> <liaoweixiong@allwinnertech.com>
+Wedson Almeida Filho <wedsonaf@gmail.com> <wedsonaf@google.com>
 Will Deacon <will@kernel.org> <will.deacon@arm.com>
 Wolfram Sang <wsa@kernel.org> <w.sang@pengutronix.de>
 Wolfram Sang <wsa@kernel.org> <wsa@the-dreams.de>

-- 
Kees Cook
