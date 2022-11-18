Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 811B78F7A
	for <patches@lists.linux.dev>; Fri, 18 Nov 2022 17:40:17 +0000 (UTC)
Received: by mail-pg1-f179.google.com with SMTP id 6so5582628pgm.6
        for <patches@lists.linux.dev>; Fri, 18 Nov 2022 09:40:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=B57T8uZs4kSEK7BZka3aDp/YZY01b3mwy/c7O4ofLxM=;
        b=iS1EU+k/Ez8kCgR9jL46V+OCbHucz4zMezoWTCKlYrd8FXkX+Pjv3zNnz6phAqfuMN
         u9EdWMAO+0aGG+7wXvNtWvEn7aCxk3mBjoG5maDdYcWQGsT82es6CTa6OQ8LNSHMMD8Y
         ke+dhjLZwJ4iG+x/bMJa2INjB3Obart5TQmUw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=B57T8uZs4kSEK7BZka3aDp/YZY01b3mwy/c7O4ofLxM=;
        b=uVdt+XOaQ+hE9ubtxAzHXFREqhwGupDNRI5j2PJiuc3wSKlC6GcoQOmLVQCwXHZTOg
         ibfor57v7C8XudOvslajaN9WrJp18C8A+mTiexBv50jyRiqs8XRqnhGFdmPcBbtmK11i
         wAT0N/WsB5+QOFLvbMt4dE7k7jzCDbmxqFk3DsB7Or/QwMOru2L89K7JXcqcGhBVY197
         7nZVcODRg7+iQhhnd6PawjGPuUENySJ/B5fW0bc1G26RwmL4mJNydPricVc+DDU4kNLH
         LhLo7zb9/dzFccMT4a0GcGmRa23Ae9ZGTikiPxf2e5vFVWAUFyJgPwC66sZn/sPeBh5u
         NjmA==
X-Gm-Message-State: ANoB5pkdCRDeLaGlmhqXQ6lt02/w6uSdt0ZOoZuQiYMtbxco3R6A3dee
	WXa25u2i2+mPgxpglLX88sx+Ig==
X-Google-Smtp-Source: AA0mqf4X1RIiE+117/z5tT4zIbvkcA//TYvYG/AUDdQvRWDbDhLF366Jq7IVJU5l9njz8oo6JGboiA==
X-Received: by 2002:a63:1760:0:b0:470:580a:c8a with SMTP id 32-20020a631760000000b00470580a0c8amr7093994pgx.505.1668793216867;
        Fri, 18 Nov 2022 09:40:16 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id w11-20020aa79a0b000000b0056bad6ff1b8sm3416073pfj.101.2022.11.18.09.40.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Nov 2022 09:40:16 -0800 (PST)
From: Kees Cook <keescook@chromium.org>
To: nathan@kernel.org,
	alison.wang@nxp.com,
	stefan@agner.ch
Cc: Kees Cook <keescook@chromium.org>,
	llvm@lists.linux.dev,
	trix@redhat.com,
	samitolvanen@google.com,
	patches@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	ndesaulniers@google.com
Subject: Re: [PATCH] drm/fsl-dcu: Fix return type of fsl_dcu_drm_connector_mode_valid()
Date: Fri, 18 Nov 2022 09:40:01 -0800
Message-Id: <166879319846.2080862.8296193513373990861.b4-ty@chromium.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221102154215.78059-1-nathan@kernel.org>
References: <20221102154215.78059-1-nathan@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Wed, 2 Nov 2022 08:42:15 -0700, Nathan Chancellor wrote:
> With clang's kernel control flow integrity (kCFI, CONFIG_CFI_CLANG),
> indirect call targets are validated against the expected function
> pointer prototype to make sure the call target is valid to help mitigate
> ROP attacks. If they are not identical, there is a failure at run time,
> which manifests as either a kernel panic or thread getting killed. A
> proposed warning in clang aims to catch these at compile time, which
> reveals:
> 
> [...]

Applied to for-next/hardening, thanks!

[1/1] drm/fsl-dcu: Fix return type of fsl_dcu_drm_connector_mode_valid()
      https://git.kernel.org/kees/c/96d845a67b7e

-- 
Kees Cook

