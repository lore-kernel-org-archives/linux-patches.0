Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C0118F72
	for <patches@lists.linux.dev>; Fri, 18 Nov 2022 17:40:17 +0000 (UTC)
Received: by mail-pl1-f170.google.com with SMTP id y10so3984714plp.3
        for <patches@lists.linux.dev>; Fri, 18 Nov 2022 09:40:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BI5MC5wPkQQeEE83qP7tE3SCFpQYK/xq9Ol93cnM3VY=;
        b=gFc4SfbZvgjlbAJ650Ar86zoxHOUfORQSyStvBp17HLK7lxP5lrqFPd3H7gr+4Ayt6
         Ud/yj2PxnUbWSfETvS7Ohq73hj+K2B1RLD25ZA1swwLA8JwR13Oz7bR/zKNnRBV69dr8
         1vERiIK/GLorWogYSmx2pdLuuNxPbKoaI/V+8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BI5MC5wPkQQeEE83qP7tE3SCFpQYK/xq9Ol93cnM3VY=;
        b=BSOWFDSspquAtwxTiWPMgtbzM23WJTJA4ocgBGNsW+QA1aAzhmyHDYy/Y5wp3pYM3b
         09jFKF75KcPN4e5J9/W+8C/P9g4t0oXHOOfrd3KVDG782NrbCRAvVBKCykQ13bpat/n5
         RptCB6fjmG+klnzedMe7GIBj0k/Tr6ngDYilGL/3T8HnGWS30zXOX+ndSKuukwGFYj0m
         by33CPkaAsxw2eDKkbxyvcgImgfKGCoSqwFSu3THJY7AjH1Rz7tppPJZDMqpjoTYOaIv
         Tlazb8an8awbQx/kkdirEIwPx4vb9UPiOM4ProMx+GtLEA4SUYcWdRV09J0eUpEpNIPf
         5+/g==
X-Gm-Message-State: ANoB5pkvc4HSfRYAfG0REeY61pu1Vp1X5saIeWC6F8LKvuDHwMvTOVMk
	HopW6X1RINl9F1+tuZO1qAy+Pw==
X-Google-Smtp-Source: AA0mqf7FFavVCClOULx9pEedXB/2PA+q16XqUjZI2216vnXrk6B4HMcy7q6rcPKHBlGCFkt/8m95FQ==
X-Received: by 2002:a17:90a:7885:b0:20a:d81d:a8 with SMTP id x5-20020a17090a788500b0020ad81d00a8mr14555998pjk.177.1668793216603;
        Fri, 18 Nov 2022 09:40:16 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id ij27-20020a170902ab5b00b001885d15e3c1sm3992123plb.26.2022.11.18.09.40.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Nov 2022 09:40:16 -0800 (PST)
From: Kees Cook <keescook@chromium.org>
To: nathan@kernel.org,
	alain.volmat@foss.st.com
Cc: Kees Cook <keescook@chromium.org>,
	llvm@lists.linux.dev,
	trix@redhat.com,
	samitolvanen@google.com,
	patches@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	ndesaulniers@google.com
Subject: Re: [PATCH] drm/sti: Fix return type of sti_{dvo,hda,hdmi}_connector_mode_valid()
Date: Fri, 18 Nov 2022 09:40:02 -0800
Message-Id: <166879319847.2080862.11821072640113889089.b4-ty@chromium.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221102155623.3042869-1-nathan@kernel.org>
References: <20221102155623.3042869-1-nathan@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Wed, 2 Nov 2022 08:56:23 -0700, Nathan Chancellor wrote:
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

[1/1] drm/sti: Fix return type of sti_{dvo,hda,hdmi}_connector_mode_valid()
      https://git.kernel.org/kees/c/0ad811cc08a9

-- 
Kees Cook

