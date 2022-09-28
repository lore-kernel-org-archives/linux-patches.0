Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DAE9ED5
	for <patches@lists.linux.dev>; Wed, 28 Sep 2022 13:30:38 +0000 (UTC)
Received: by mail-wm1-f52.google.com with SMTP id t4so8516582wmj.5
        for <patches@lists.linux.dev>; Wed, 28 Sep 2022 06:30:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=+sTNVvjAkH/cc42ksDDWX4JcTFewSmG92wxhIKzNCOw=;
        b=8KPIadtR17BfAjuapC+HMSOCc/sARIAMSLwgI6BWonfsOKYvJAg4DAf8UPLZwdVTH3
         R2thF0KU3VsxtoWcAOOIf4wMO5IqmAKb9M+nR351L1yQDFUjO9SaxQwYoqMuU0+JQ0aA
         /L6XlFPVy/67cGumVjo7Oc3xne02YDLaffx8UvF7Fwqwsut3OGaC4nEommz15FKeG3k7
         slQ38PdyzTcakd2m4HLlmIIyhZomDVmNBLmTUb8HUTowzHTgWCKhL6mNVLdLpIhYmnRe
         0+xGWSalo7gP5kzxceAHF6D/m15fnHElHTS/477mrGkQmzRe+SsW0BHLdaXBs47XMFKw
         h9wQ==
X-Gm-Message-State: ACrzQf2T4lqebIKNPHWMiv00ggAzSm0/HFE3iNIL7kvfB+2Y3q7Sd/fw
	0UBD5U8DS08W61ilA25vrGE=
X-Google-Smtp-Source: AMsMyM5sKVbrsBg9zQltOPbN1k4kA+TZOqFtvyPUIpHcZCJxYl/jIoQPVGq8bmzIoLwzqnN+bjzPHw==
X-Received: by 2002:a05:600c:458d:b0:3b5:6e85:7094 with SMTP id r13-20020a05600c458d00b003b56e857094mr509671wmo.38.1664371836877;
        Wed, 28 Sep 2022 06:30:36 -0700 (PDT)
Received: from liuwe-devbox-debian-v2 ([51.145.34.42])
        by smtp.gmail.com with ESMTPSA id q10-20020a1cf30a000000b003b47575d304sm2041755wmq.32.2022.09.28.06.30.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Sep 2022 06:30:36 -0700 (PDT)
Date: Wed, 28 Sep 2022 13:30:34 +0000
From: Wei Liu <wei.liu@kernel.org>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, patches@lists.linux.dev,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Wedson Almeida Filho <wedsonaf@google.com>,
	Wei Liu <wei.liu@kernel.org>
Subject: Re: [PATCH v10 22/27] rust: add `.rustfmt.toml`
Message-ID: <YzRMeuVzij17qcVn@liuwe-devbox-debian-v2>
References: <20220927131518.30000-1-ojeda@kernel.org>
 <20220927131518.30000-23-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220927131518.30000-23-ojeda@kernel.org>

On Tue, Sep 27, 2022 at 03:14:53PM +0200, Miguel Ojeda wrote:
> This is the configuration file for the `rustfmt` tool.
> 
> `rustfmt` is a tool for formatting Rust code according to style guidelines.
> It is very commonly used across Rust projects.
> 
> The default configuration options are used.
> 
> Reviewed-by: Kees Cook <keescook@chromium.org>
> Co-developed-by: Alex Gaynor <alex.gaynor@gmail.com>
> Signed-off-by: Alex Gaynor <alex.gaynor@gmail.com>
> Co-developed-by: Wedson Almeida Filho <wedsonaf@google.com>
> Signed-off-by: Wedson Almeida Filho <wedsonaf@google.com>
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Reviewed-by: Wei Liu <wei.liu@kernel.org>
