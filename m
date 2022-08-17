Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 621567460
	for <patches@lists.linux.dev>; Wed, 17 Aug 2022 20:28:43 +0000 (UTC)
Received: by mail-pj1-f47.google.com with SMTP id x63-20020a17090a6c4500b001fabbf8debfso2115404pjj.4
        for <patches@lists.linux.dev>; Wed, 17 Aug 2022 13:28:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc;
        bh=3IdwoVVH/KyYebc3thCK0QbO3+GbhpIydetmBLF9D/I=;
        b=jSONM70T0iDAfNrUlJVTC0kSLGPrN42VzGrBfG+OQOHBUFYa/lexgC3zukZjRUN+RA
         Va4f3Cff4Myv7LFdueNazPDJm59DfkyitTRPdIqTg8fi8YS5oUyYMGFak9DEw7n0i+dV
         HBASyKpT4twWeav/khru+yHi/akhW25j65vzo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc;
        bh=3IdwoVVH/KyYebc3thCK0QbO3+GbhpIydetmBLF9D/I=;
        b=N6c5mlzn/jt0Wpy9Gs970llNZNKaBUBKua6mZiLQ2mCrdV3wPmjbQ7oRiCjea4Dl2R
         PdGN+ROM2Ft4sASdJs0rdTKG9Ht8ArxPrzO3LJ7J7lVlBrYBFnFK2CX4YQHcJDAupjEy
         yKEhMbhy2vbN2ICuRf1ge0Z4/RO/FSPhan27TWkoX3f5bLoBrv/hclu8E8vXTvpiff4U
         BhXElHUz/ofTWP9yZMZxTmD4oNwZV/WfG008H7zqGpBCeAH8uvIAz+t4iunCo33KnmAp
         hFnBjaWPf28tdbxmKShCa62x9T0/L67/8Fi4AdKXj49raLRMNZtolywhTn2dsGW1IThi
         9bgQ==
X-Gm-Message-State: ACgBeo2m8JjaiM1juRFD6FneihYdrcd4XI1ekE+jrwl0+anEsN9WRThr
	m8zmY2S2NmHj/Dmog6f4NXiq0g==
X-Google-Smtp-Source: AA6agR5Zika9lSedq4f7QwsRgecAXUOsKIBN3mGuVnYiMhmG7lPo2eB1oM4cCxRF+GeLrPsJUjEuKA==
X-Received: by 2002:a17:90b:190b:b0:1fa:a374:f563 with SMTP id mp11-20020a17090b190b00b001faa374f563mr5431439pjb.52.1660768122915;
        Wed, 17 Aug 2022 13:28:42 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id f4-20020a170902ce8400b0016ee3d7220esm358508plg.24.2022.08.17.13.28.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Aug 2022 13:28:42 -0700 (PDT)
Date: Wed, 17 Aug 2022 13:28:41 -0700
From: Kees Cook <keescook@chromium.org>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, patches@lists.linux.dev,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Wedson Almeida Filho <wedsonaf@google.com>
Subject: Re: [PATCH v9 27/27] MAINTAINERS: Rust
Message-ID: <202208171328.8C3541A@keescook>
References: <20220805154231.31257-1-ojeda@kernel.org>
 <20220805154231.31257-28-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220805154231.31257-28-ojeda@kernel.org>

On Fri, Aug 05, 2022 at 05:42:12PM +0200, Miguel Ojeda wrote:
> Miguel, Alex and Wedson will be maintaining the Rust support.
> 
> Boqun, Gary and Björn will be reviewers.
> 
> Co-developed-by: Alex Gaynor <alex.gaynor@gmail.com>
> Signed-off-by: Alex Gaynor <alex.gaynor@gmail.com>

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
