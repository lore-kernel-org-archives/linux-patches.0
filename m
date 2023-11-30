Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 223C15A101
	for <patches@lists.linux.dev>; Thu, 30 Nov 2023 22:05:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="nlzmm25V"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-1cfae5ca719so13706995ad.0
        for <patches@lists.linux.dev>; Thu, 30 Nov 2023 14:05:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1701381948; x=1701986748; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=E+z84/9szAuZC+Uij5uL4JYHHRg/gwkkJLqAhisbf48=;
        b=nlzmm25VvvSzmBUyxrMTQyaW7/1xF5BFcRp8XMsyubuCc9pGKXHCFC5S5/6z0OE5Cv
         WIcLsyf5VuuLH2pTRZQLbukhn16nav5QLzCHJUWoo8CRtjtWVd+En6IauHA70INprMRN
         Ke4pIq6FjU2I3dwrQBDq66Pab79CXGR5yAWI4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701381948; x=1701986748;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=E+z84/9szAuZC+Uij5uL4JYHHRg/gwkkJLqAhisbf48=;
        b=pmUlc3akKzX09nl42I41WBEpBejH0k2YKfSWk+uNPJUr3rlmz13fXTMQ7ydQhRad3S
         fCInzRgp5FmmBGLe5zlii3clsYqceJr/6nMCUOJmFNwa4nVKHeOvwNqkrkaWwpx+AOL1
         OqMDY+J1wGClEryrs4S420rPdOJ4x2842utHBSb7HfdbT07AdxtIka2RA9mlzUkhkykn
         59dQGaZiKW+x+jowZWnpUusrslCNQ1s7pEze8RwsNuE23WMsAdbUQuy6zvtTX5JG5m0q
         jcUtCP142cMLzmAsVVmGlC+Qez1zN0m0G5Pvjd/ygMAfV9XA+K1OLSMFkUTh2DGyRxOJ
         MWBQ==
X-Gm-Message-State: AOJu0YwAqeYAh5zNYUSdGyfKucIJykBXJViQGBFLk3oH9p47mS9PiEXG
	zwrlm4V8xzDPTK1o13wlaHIuWg==
X-Google-Smtp-Source: AGHT+IEjHZgHLIabxybJ+AkRENmwF9P4IgVmEVrP/H1KdcfCDs57RRkP3D5fO0kqDd00TZ7Ep+gIgw==
X-Received: by 2002:a17:903:2345:b0:1cf:d8c5:2288 with SMTP id c5-20020a170903234500b001cfd8c52288mr15051983plh.41.1701381948433;
        Thu, 30 Nov 2023 14:05:48 -0800 (PST)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id n7-20020a170902d2c700b001cf65d03cedsm1890895plc.32.2023.11.30.14.05.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Nov 2023 14:05:47 -0800 (PST)
From: Kees Cook <keescook@chromium.org>
To: Stephen Boyd <swboyd@chromium.org>
Cc: Kees Cook <keescook@chromium.org>,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Alexander Potapenko <glider@google.com>,
	Marco Elver <elver@google.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	kasan-dev@googlegroups.com
Subject: Re: [PATCH v2] lkdtm: Add kfence read after free crash type
Date: Thu, 30 Nov 2023 14:05:45 -0800
Message-Id: <170138194305.3650163.16392122923355361827.b4-ty@chromium.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231129214413.3156334-1-swboyd@chromium.org>
References: <20231129214413.3156334-1-swboyd@chromium.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Wed, 29 Nov 2023 13:44:04 -0800, Stephen Boyd wrote:
> Add the ability to allocate memory from kfence and trigger a read after
> free on that memory to validate that kfence is working properly. This is
> used by ChromeOS integration tests to validate that kfence errors can be
> collected on user devices and parsed properly.
> 
> 

Applied to for-next/hardening, thanks!

[1/1] lkdtm: Add kfence read after free crash type
      https://git.kernel.org/kees/c/0e689e666214

Take care,

-- 
Kees Cook

