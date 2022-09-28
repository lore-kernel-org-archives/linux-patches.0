Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A488A23BE
	for <patches@lists.linux.dev>; Wed, 28 Sep 2022 14:56:33 +0000 (UTC)
Received: by mail-wr1-f52.google.com with SMTP id s14so20304503wro.0
        for <patches@lists.linux.dev>; Wed, 28 Sep 2022 07:56:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date;
        bh=bARmEyRufSITUVxna55CaMh6exv5QYh2cquo7v7gbWQ=;
        b=uejUDv3baztEM+jxBQGSV492XNv+Fb5NHh9uleIKEUimiwYkVuUyBp0+JKd9cLgq3+
         9/JyyWbpnB54OM1t6ZM5224deMGxFKb4u2uAgrKpsQco2F+m6XhVga5A8/lTkryYMDag
         GP7MXnUHw/HezbonVV7eUUSsCerpB9IwDnztSBZxmzGKQxTvwPcRNfjDvaUJNTHQBy0N
         8rpxWxSBeMll6snI7DCpYSZfWfmSSgFWAsUnAGZyQfh4mohGmCaqTrPsFFelbKn7YIoS
         cqy9HSA1wEL8bT7vZx8AGxxNO9HtUygsAgdT7pYugvTdt3UC6XE0VKEpCuO40O7kZk3/
         9srg==
X-Gm-Message-State: ACrzQf1kGLmKpHSq97bjqJNYaUfo408w754pE7yPDwLlnvdrNZNRgVoV
	1oW1A7T8tLJrhKbqk+ClI58=
X-Google-Smtp-Source: AMsMyM6G1PVBH4Fol3S2xXl1qdx7DG+MwA3jmufrru5yN8AHgBBS6/+sd4Er40venbVkI2KFTvaYeQ==
X-Received: by 2002:adf:b613:0:b0:22c:c9d9:a27d with SMTP id f19-20020adfb613000000b0022cc9d9a27dmr2159577wre.257.1664376991806;
        Wed, 28 Sep 2022 07:56:31 -0700 (PDT)
Received: from liuwe-devbox-debian-v2 ([51.145.34.42])
        by smtp.gmail.com with ESMTPSA id bx31-20020a5d5b1f000000b0022a2bacabbasm4554808wrb.31.2022.09.28.07.56.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Sep 2022 07:56:31 -0700 (PDT)
Date: Wed, 28 Sep 2022 14:56:29 +0000
From: Wei Liu <wei.liu@kernel.org>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, patches@lists.linux.dev,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Alex Gaynor <alex.gaynor@gmail.com>, Finn Behrens <me@kloenk.de>,
	Adam Bratschi-Kaye <ark.email@gmail.com>,
	Wedson Almeida Filho <wedsonaf@google.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sven Van Asbroeck <thesven73@gmail.com>,
	Gary Guo <gary@garyguo.net>, Boris-Chengbiao Zhou <bobo1239@web.de>,
	Boqun Feng <boqun.feng@gmail.com>, Douglas Su <d0u9.su@outlook.com>,
	Dariusz Sosnowski <dsosnowski@dsosnowski.pl>,
	Antonio Terceiro <antonio.terceiro@linaro.org>,
	Daniel Xu <dxu@dxuuu.xyz>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Martin Rodriguez Reboredo <yakoyoku@gmail.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Michal Marek <michal.lkml@markovi.net>,
	linux-kbuild@vger.kernel.org, Wei Liu <wei.liu@kernel.org>
Subject: Re: [PATCH v10 23/27] Kbuild: add Rust support
Message-ID: <YzRgnXFRaC4fd0u2@liuwe-devbox-debian-v2>
References: <20220927131518.30000-1-ojeda@kernel.org>
 <20220927131518.30000-24-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220927131518.30000-24-ojeda@kernel.org>

On Tue, Sep 27, 2022 at 03:14:54PM +0200, Miguel Ojeda wrote:
> Having most of the new files in place, we now enable Rust support
> in the build system, including `Kconfig` entries related to Rust,
> the Rust configuration printer and a few other bits.
> 
> Reviewed-by: Kees Cook <keescook@chromium.org>
> Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
> Tested-by: Nick Desaulniers <ndesaulniers@google.com>
> Co-developed-by: Alex Gaynor <alex.gaynor@gmail.com>
> Signed-off-by: Alex Gaynor <alex.gaynor@gmail.com>
> Co-developed-by: Finn Behrens <me@kloenk.de>
> Signed-off-by: Finn Behrens <me@kloenk.de>
> Co-developed-by: Adam Bratschi-Kaye <ark.email@gmail.com>
> Signed-off-by: Adam Bratschi-Kaye <ark.email@gmail.com>
> Co-developed-by: Wedson Almeida Filho <wedsonaf@google.com>
> Signed-off-by: Wedson Almeida Filho <wedsonaf@google.com>
> Co-developed-by: Michael Ellerman <mpe@ellerman.id.au>
> Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
> Co-developed-by: Sven Van Asbroeck <thesven73@gmail.com>
> Signed-off-by: Sven Van Asbroeck <thesven73@gmail.com>
> Co-developed-by: Gary Guo <gary@garyguo.net>
> Signed-off-by: Gary Guo <gary@garyguo.net>
> Co-developed-by: Boris-Chengbiao Zhou <bobo1239@web.de>
> Signed-off-by: Boris-Chengbiao Zhou <bobo1239@web.de>
> Co-developed-by: Boqun Feng <boqun.feng@gmail.com>
> Signed-off-by: Boqun Feng <boqun.feng@gmail.com>
> Co-developed-by: Douglas Su <d0u9.su@outlook.com>
> Signed-off-by: Douglas Su <d0u9.su@outlook.com>
> Co-developed-by: Dariusz Sosnowski <dsosnowski@dsosnowski.pl>
> Signed-off-by: Dariusz Sosnowski <dsosnowski@dsosnowski.pl>
> Co-developed-by: Antonio Terceiro <antonio.terceiro@linaro.org>
> Signed-off-by: Antonio Terceiro <antonio.terceiro@linaro.org>
> Co-developed-by: Daniel Xu <dxu@dxuuu.xyz>
> Signed-off-by: Daniel Xu <dxu@dxuuu.xyz>
> Co-developed-by: Björn Roy Baron <bjorn3_gh@protonmail.com>
> Signed-off-by: Björn Roy Baron <bjorn3_gh@protonmail.com>
> Co-developed-by: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
> Signed-off-by: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Reviewed-by: Wei Liu <wei.liu@kernel.org>
