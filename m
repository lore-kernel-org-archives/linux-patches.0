Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26E6E29A0
	for <patches@lists.linux.dev>; Wed,  2 Nov 2022 20:01:28 +0000 (UTC)
Received: by mail-pj1-f53.google.com with SMTP id k5so9692900pjo.5
        for <patches@lists.linux.dev>; Wed, 02 Nov 2022 13:01:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=crDMk0R12pE4R+rJIlvy8EsGZM7TBfRAPYKWnpWAGHY=;
        b=UK9/AZo0Gy9FmiPW3MCdfsBkfo+eIrkJ8azyv3CjPHoN4MhEkiNCR8PNH7yhFsYAOV
         OcpJgIYxLNKdG/2WV1Ir7KHesKgC3PaVShkuvcivzT1/xw5yHoEnTL+CL4JhdOo7Cq6/
         kZ7Q7PuO5Kq6Dkv2HcO0D8R73xSRLPR7rqXcY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=crDMk0R12pE4R+rJIlvy8EsGZM7TBfRAPYKWnpWAGHY=;
        b=bignb4F2R9m8XtwwXtyyADpmkCLUXArcN+gty/u2rFCQuEdnUTmmrnEaJqfXUGt6zI
         jmMhFYhL00nMJ9MrsoWAR/bardvlAaXuUWkkY1azf9jaogdBUhukC7jJK6qehM2C2Fwr
         /ikvnl+th6aKDwXO/NNsFLQmoMxggka92/ugDtXwMeQXojgrl3EICD0etLTIwdGBt1aD
         aXEPy7iMePkRS7eo04XhllxQ0q6rq9872/LE+9fQJllzb/emEWSaGD6Cx2PbhsZhM9jQ
         jz+SBy51uAY/Fm6jqTFZk7QwFOZX85wAPO5mcpIJMw3WaAatWoBWZQ/1EhC+STHWEhGv
         6tiQ==
X-Gm-Message-State: ACrzQf3QRrZN2W8TLg7Izukcwqu38af05hO3yfseDfCKFD0Un5nvB90b
	srsTIGtJu4KVTRmRrdTAp9+B0g==
X-Google-Smtp-Source: AMsMyM6jJViHjLqCoTS++I8Qer6oLGbkwZ5YrvtcOzrUTmAZhCWRZ2VARz0FuIZVfUtOhdEVS0FtHA==
X-Received: by 2002:a17:903:41ca:b0:186:a68e:c06d with SMTP id u10-20020a17090341ca00b00186a68ec06dmr25774406ple.61.1667419287620;
        Wed, 02 Nov 2022 13:01:27 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id z184-20020a6233c1000000b0056c47a5c34dsm8825142pfz.122.2022.11.02.13.01.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Nov 2022 13:01:27 -0700 (PDT)
Date: Wed, 2 Nov 2022 13:01:26 -0700
From: Kees Cook <keescook@chromium.org>
To: Heiko Carstens <hca@linux.ibm.com>,
	Sami Tolvanen <samitolvanen@google.com>
Cc: Nathan Chancellor <nathan@kernel.org>,
	Alexandra Winter <wintera@linux.ibm.com>,
	Wenjia Zhang <wenjia@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>, linux-s390@vger.kernel.org,
	netdev@vger.kernel.org, Nick Desaulniers <ndesaulniers@google.com>,
	Tom Rix <trix@redhat.com>, llvm@lists.linux.dev,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH 1/3] s390/ctcm: Fix return type of ctc{mp,}m_tx()
Message-ID: <202211021259.9169F5CBE@keescook>
References: <20221102163252.49175-1-nathan@kernel.org>
 <Y2LJmr8gE2I7gOP5@osiris>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y2LJmr8gE2I7gOP5@osiris>

On Wed, Nov 02, 2022 at 08:48:42PM +0100, Heiko Carstens wrote:
> On Wed, Nov 02, 2022 at 09:32:50AM -0700, Nathan Chancellor wrote:
> > should s390 select ARCH_SUPPORTS_CFI_CLANG in the future.
> 
> Yes, s390 should select that :)
> 
> But, is there any switch or option I need to set when compiling clang,
> so it knows about the kcfi sanitizer?
> 
> I get:
> clang-16: error: unsupported option '-fsanitize=kcfi' for target 's390x-ibm-linux'
> 
> > clang --version
> clang version 16.0.0 (https://github.com/llvm/llvm-project.git e02110e2ab4dd71b276e887483f0e6e286d243ed)

You'll need the "generic arch support": https://reviews.llvm.org/D135411
which is _almost_ landed. Testing would be welcome, for sure!

Sami, do you have any notes on what common things were needed to get
arm64 and x86_64 booting under kCFI? My only oh-so-helpful notes are
"keep CFI away from early boot code". :P

-- 
Kees Cook
