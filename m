Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF2D0A23
	for <patches@lists.linux.dev>; Thu,  3 Nov 2022 08:41:42 +0000 (UTC)
Received: by mail-wr1-f44.google.com with SMTP id bs21so1560863wrb.4
        for <patches@lists.linux.dev>; Thu, 03 Nov 2022 01:41:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W9DytQ1lu/QgUtGO9mzgm9cxKNspCA3RpOmraCTiE/0=;
        b=ihPXTyZfARlzx3zOeMgnhgDEhAPFQtxt1dh/8v6xYYs43Ecge13lHiGYkcUjZQKcJS
         CDeRGSDlcKyd1uI4AgO4P9gq3fZ3SNRCBMA2TZEjJCqLXcDv3MEcWmJuVrulMa6b5HEX
         lLQREkxj4BSVnbxmqIM5YHhXNpnGBG4egcSsybFwYgGBRhk+DlrVgFNqvq5gFelw5SD9
         qSkT5x7/PLTP4wbL4yQeez8JMxmUKGGMYlwV5pVthv+ut4P9xGSsBH0w+iOW887dPP7U
         vNUeeAqjOO0oBRa0HY2IYYnyPbzoJrVrNA6CAb4/6oSszx5tjSuroRv8mOQwks2K5bt3
         8wLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=W9DytQ1lu/QgUtGO9mzgm9cxKNspCA3RpOmraCTiE/0=;
        b=LMrxBVpPDIaNXeVnJYp12CdJgnz6p2pazO11xsuAxGroGuMgxmUytqrHNCKDDzcNw3
         yqu/rXumPa0vfR0zwE5SB0WwsftYemEDB6ii58ZE+JXBXFc8WkJxoHTHs+3c9hXw+3Lg
         WQTtgFNriXw09KRwvrNy7sLC8c1/63g47mm27eLxNp4tMA76P9yeVGwxdnbLVu/EoMJn
         hhDLmupt54guacxl6x7RTCDlNYoqSWGijnOxE/IcmUkTAq16PAeA7a/5xaDvNFW7rfWh
         XFt2oQw3ysMXeHJNKgUEj463emZopIdx+3LENp+nOLEXeWYKYz4Ze/EtME12cVvu8JKd
         4MSg==
X-Gm-Message-State: ACrzQf2Le+gYbzxQ752Zxh+tayyay9O5JZmw3jZk+G30mgeS9JDy1Lhp
	KunCktTDrJPX1HmUvrlAtGWtz7Tf6ussay0P
X-Google-Smtp-Source: AMsMyM7hD2iS4TPUK2fXFcCk74ymN/Esmn+RsmRn2QjdiPKVFaUKmnE6zQeDBpcdQb0f/AtWUQ4wSA==
X-Received: by 2002:adf:eb51:0:b0:236:cfcc:76e4 with SMTP id u17-20020adfeb51000000b00236cfcc76e4mr12571984wrn.291.1667464901174;
        Thu, 03 Nov 2022 01:41:41 -0700 (PDT)
Received: from arrakeen.starnux.net ([2a01:e0a:982:cbb0:8261:5fff:fe11:bdda])
        by smtp.gmail.com with ESMTPSA id c19-20020a05600c0a5300b003c21ba7d7d6sm504178wmq.44.2022.11.03.01.41.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Nov 2022 01:41:40 -0700 (PDT)
From: Neil Armstrong <neil.armstrong@linaro.org>
To: Nathan Chancellor <nathan@kernel.org>
Cc: patches@lists.linux.dev, dri-devel@lists.freedesktop.org, Kees Cook <keescook@chromium.org>, llvm@lists.linux.dev,
 linux-amlogic@lists.infradead.org, linux-kernel@vger.kernel.org, Tom Rix <trix@redhat.com>,
 Sami Tolvanen <samitolvanen@google.com>, Nick Desaulniers <ndesaulniers@google.com>
In-Reply-To: <20221102155242.1927166-1-nathan@kernel.org>
References: <20221102155242.1927166-1-nathan@kernel.org>
Subject: Re: [PATCH] drm/meson: Fix return type of meson_encoder_cvbs_mode_valid()
Message-Id: <166746490033.1047451.8509801800691914580.b4-ty@linaro.org>
Date: Thu, 03 Nov 2022 09:41:40 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailer: b4 0.10.1

Hi,

On Wed, 2 Nov 2022 08:52:42 -0700, Nathan Chancellor wrote:
> With clang's kernel control flow integrity (kCFI, CONFIG_CFI_CLANG),
> indirect call targets are validated against the expected function
> pointer prototype to make sure the call target is valid to help mitigate
> ROP attacks. If they are not identical, there is a failure at run time,
> which manifests as either a kernel panic or thread getting killed. A
> proposed warning in clang aims to catch these at compile time, which
> reveals:
> 
> [...]

Thanks, Applied to https://anongit.freedesktop.org/git/drm/drm-misc.git (drm-misc-next)

[1/1] drm/meson: Fix return type of meson_encoder_cvbs_mode_valid()
      https://cgit.freedesktop.org/drm/drm-misc/commit/?id=6c4e4d35203301906afb53c6d1e1302d4c793c05

-- 
Neil
