Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4421F4A07
	for <patches@lists.linux.dev>; Fri, 22 Mar 2024 03:37:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711078646; cv=none; b=Bq4RwWrPMqBUmMjxc61Wb3AyzBfcx32qaeEx6TDmEGK1e9GitWaHg1H8wpOilxVr6m9MxUcz3KMI01e4Cs35AfuTVk/beLhusqVlFyOtxJYIVvVuY/THE/c0qeOOYXjsy3mUN7aS8TZem+jhPFVSelfl3se5c5zsiSEvQcHdNZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711078646; c=relaxed/simple;
	bh=YLj8/fFB3iR2BgqCqbaPVZ2Al9MIRcsccJSes/QGmTc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YodQb4yPWzbGAzztqS+/kUTCFtC1f54bY476KA6GDv5XaCy7gDWa2iAO3gy2g/qyEnprmNCvEo0+yK+J9Ol431B0C7UMgdEMstlqHYC2MAtmso0fFqFqxMjaJqzmnfvnfJn8lDaY5QhG/2cN7YsNZ92g2P/uXuAX1/pHikfnKGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=ApiHmtlh; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="ApiHmtlh"
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-6e740fff1d8so1235788b3a.1
        for <patches@lists.linux.dev>; Thu, 21 Mar 2024 20:37:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1711078644; x=1711683444; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bvbUMoqrd/dJEgf6JJhj0Yfu88Qiuvr2XtDQQz6GOro=;
        b=ApiHmtlh3zgZz0Kyd4+iWKej6nQoefnLqF1IP9jtTrY18r/u1jAkyj1XMQsF/M4knF
         4zB+Iye7q8T07jhZQdw3a1inRaNR+alEZy14F9+WDT2mUx5hYwXEJIDp0bF/oRhBDCA2
         mC+RzctLhqq1YJJs3PAq4YNlVz9S8EiOdxx20=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711078644; x=1711683444;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bvbUMoqrd/dJEgf6JJhj0Yfu88Qiuvr2XtDQQz6GOro=;
        b=fFQ8HqkU+YmF2bQrdGN5MQt5elZTscclQmtPAxfEPCqRBs43gq2a4+V141wlC/CTs3
         tBxA1BXR9bbuCv59mlkUP+NgZ6lfW12wl4S8W5j/WV/BUzvlwcEzwejEFT24dGUdbmkf
         TFNWKspr12rRkeCADiZWvbReqyP2qUwdh60U8/dExdMkVK1ZfbKgDcDhlVHpT8lAk9US
         ogfqpQlRuNvp9alU1FxUfe7fDqeS2Y5byOtAjeiHNKHB+33M4U3xkAb59OjEMlFFNDnk
         YiR1dIpL0A0LqTRpY1w88/3xj6gRn8gLAOvvD27lwf9ZHOjz7Aie7tHNZRaD1ogzi8nH
         /mGg==
X-Forwarded-Encrypted: i=1; AJvYcCXDqbhqv6357vPX4Ju79gVZQ0VL7/n6mcA+K2l6EdgeUdhTr8UNdJDJxlQJkmnO+IbOhWmwdVw1BoVb7Bm9bmwpAbW0t7Xe1g==
X-Gm-Message-State: AOJu0YzEZrOG4x+swhGVw0ji4rZ6+E++y1qAPh4zTARNbf7eRc/nIe6q
	kKPaGaFHZqbsZAE/tcQHVgrpLAQzEXRYXg0fMaLPcNIe6POZJxSdOFPH9nqR1A==
X-Google-Smtp-Source: AGHT+IG41XfP3twX3J+wXXnzuFUXhIFR5UFLmItPjSV3U1CEAEfvhq2txMf23N39MxgUbU8aWibB5g==
X-Received: by 2002:a05:6a00:3cd3:b0:6e6:d018:4a91 with SMTP id ln19-20020a056a003cd300b006e6d0184a91mr1487397pfb.29.1711078644420;
        Thu, 21 Mar 2024 20:37:24 -0700 (PDT)
Received: from www.outflux.net ([198.0.35.241])
        by smtp.gmail.com with ESMTPSA id fn1-20020a056a002fc100b006e64ddfa71asm632078pfb.170.2024.03.21.20.37.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Mar 2024 20:37:23 -0700 (PDT)
From: Kees Cook <keescook@chromium.org>
To: Nathan Chancellor <nathan@kernel.org>
Cc: Kees Cook <keescook@chromium.org>,
	gustavoars@kernel.org,
	linux-hardening@vger.kernel.org,
	patches@lists.linux.dev
Subject: Re: [PATCH] lkdtm/bugs: Improve warning message for compilers without counted_by support
Date: Thu, 21 Mar 2024 20:37:19 -0700
Message-Id: <171107863807.467843.12325988326531946471.b4-ty@chromium.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240321-lkdtm-improve-lack-of-counted_by-msg-v1-1-0fbf7481a29c@kernel.org>
References: <20240321-lkdtm-improve-lack-of-counted_by-msg-v1-1-0fbf7481a29c@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Thu, 21 Mar 2024 13:18:17 -0700, Nathan Chancellor wrote:
> The current message for telling the user that their compiler does not
> support the counted_by attribute in the FAM_BOUNDS test does not make
> much sense either grammatically or semantically. Fix it to make it
> correct in both aspects.
> 
> 

Applied to for-next/hardening, thanks!

[1/1] lkdtm/bugs: Improve warning message for compilers without counted_by support
      https://git.kernel.org/kees/c/8b93450af173

Take care,

-- 
Kees Cook

