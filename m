Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5162BD53B
	for <patches@lists.linux.dev>; Thu,  2 Mar 2023 22:56:07 +0000 (UTC)
Received: by mail-pl1-f176.google.com with SMTP id n6so881459plf.5
        for <patches@lists.linux.dev>; Thu, 02 Mar 2023 14:56:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1677797767;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=fDa++rPUZHG1cADT97wEka7i9XpBCSMw+BsUJit3tM8=;
        b=apW6CO+GriA5ax10w+Ltl21EZyiCuiEkrosyVJE39MbM7iiqBxUYPqTnJSZJrvIQ5m
         AyBgf/dBZT8ggeDyaszfb5BRhMl3PsNMujEvWYmubxg2OsoEQS9fDcbnxUg4wG8mHx8b
         JSd7FVNrEyw/RGhiZ1WY6WaWHYqk9swiQFrcM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677797767;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fDa++rPUZHG1cADT97wEka7i9XpBCSMw+BsUJit3tM8=;
        b=eTRGHN2i17BdGzAxMuIdYjT50YuEd6uXbDZjAJF+eKZ3fmxmHJyH25+WS9ltvZq6jp
         8dwnCrxuoEIAXy0jm5q5EOSupbzW5A0ZXQI4i2wNkvMPpsVmnxI3LXyAFjcZTELJ7yJw
         glz0/PGEbd1dPgmZ4inYBwW/bQLinTKVyOHuKRPa4MSJcG+exGOf7V8FjWyKlBKRAI5V
         Ygc/QIswWA+yHVFoyIUqnG0wVVjnQuw8wCR41AjBImbb9IRCiZ71Xynobg6BVGpd6A5q
         OuAl619Qc67UktRImWJREmFUbKYUgJ6CzdfwkZZquh+6OjYOVAInDhGsnhr6T3ycfgMk
         h0Gw==
X-Gm-Message-State: AO0yUKXyrY0KxNnXvMgnkjD6gEroztTyu2uI1D/9qEsTCfajf3HYAVfj
	Eksy1eWYtjVMlRbIo364Q7XVjw==
X-Google-Smtp-Source: AK7set+MEnLjHdrL/UF2pQiGl3CRsjFYnt0FAye8NGhtXVtdNjGBD457Drx+Q5YR8VVMf1FPUpgIMQ==
X-Received: by 2002:a17:90b:4a8c:b0:237:b702:49c0 with SMTP id lp12-20020a17090b4a8c00b00237b70249c0mr12768587pjb.45.1677797766720;
        Thu, 02 Mar 2023 14:56:06 -0800 (PST)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id x13-20020a17090a294d00b00234a2f6d9c0sm224637pjf.57.2023.03.02.14.56.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Mar 2023 14:56:06 -0800 (PST)
Message-ID: <64012986.170a0220.67312.124e@mx.google.com>
X-Google-Original-Message-ID: <202303021455.@keescook>
Date: Thu, 2 Mar 2023 14:56:05 -0800
From: Kees Cook <keescook@chromium.org>
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: ebiederm@xmission.com, yzaikin@google.com, john.johansen@canonical.com,
	paul@paul-moore.com, jmorris@namei.org, serge@hallyn.com,
	luto@amacapital.net, wad@chromium.org, dverkamp@chromium.org,
	paulmck@kernel.org, baihaowen@meizu.com, frederic@kernel.org,
	jeffxu@google.com, ebiggers@kernel.org, tytso@mit.edu,
	guoren@kernel.org, j.granados@samsung.com, zhangpeng362@huawei.com,
	tangmeng@uniontech.com, willy@infradead.org, nixiaoming@huawei.com,
	sujiaxun@uniontech.com, patches@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, apparmor@lists.ubuntu.com,
	linux-security-module@vger.kernel.org, linux-csky@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 05/11] loadpin: simplify sysctls use with
 register_sysctl()
References: <20230302202826.776286-1-mcgrof@kernel.org>
 <20230302202826.776286-6-mcgrof@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230302202826.776286-6-mcgrof@kernel.org>

On Thu, Mar 02, 2023 at 12:28:20PM -0800, Luis Chamberlain wrote:
> register_sysctl_paths() is not required, we can just use
> register_sysctl() with the required path specified.
> 
> Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>

Acked-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
