Received: from mail-oa1-f45.google.com (mail-oa1-f45.google.com [209.85.160.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03AF679F9
	for <patches@lists.linux.dev>; Thu,  6 Apr 2023 14:35:16 +0000 (UTC)
Received: by mail-oa1-f45.google.com with SMTP id 586e51a60fabf-17aceccdcf6so42503533fac.9
        for <patches@lists.linux.dev>; Thu, 06 Apr 2023 07:35:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680791716;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aXDlqaghZBjXgA0NY19GPZNJThwtj3XENjKUz55y22o=;
        b=uHL28ixrMwO7UmqEfMgCIk6LpBlCyLWj5qMKZmVcRiLz77MgULiNZ9axnwFn6x+xuI
         kXvnJ3pXwGYQJQq2fQwQySg2ouKvn4LnYoIXH0GoDo0uYCeibRW+U+LQiPADFp6HA9UT
         d2HIT6Uei54nZNJV+Pi8mEcjJvCaQAnCnibgucqZ7t6H2StY+IgdlVZ9Wuz+2sGqC2Pr
         BHful4X4sV7T32PH62x/w8b/QApqDaNTrSXevLGDz0927XFd16CmRezfjWpGIvZI9pz6
         Gmxz/WwSPH6p22dKOmutrL9uXN2tK2PdM1T4BIDfZjsWhNgF6kivK+dKimB9ZJVW8DoW
         aV5A==
X-Gm-Message-State: AAQBX9fz2+naVG1NmVoAbOejBhZ74+d2AfTX3mzlwx7mT3rtJLU3y4xq
	wYxaxPAXIn90uUKPJRgPpg==
X-Google-Smtp-Source: AKy350ZCYG3gr3sW4VveqNyY6bipIYXv8tUa2i2axB2wuzwFS916oDDGB8n9GEfOAKcJhYwRJufQ2g==
X-Received: by 2002:a05:6870:d10b:b0:177:b62d:cc20 with SMTP id e11-20020a056870d10b00b00177b62dcc20mr5204205oac.25.1680791715952;
        Thu, 06 Apr 2023 07:35:15 -0700 (PDT)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id h17-20020a9d7991000000b0069dd3d98ec6sm750727otm.44.2023.04.06.07.35.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Apr 2023 07:35:15 -0700 (PDT)
Received: (nullmailer pid 3056260 invoked by uid 1000);
	Thu, 06 Apr 2023 14:35:14 -0000
Date: Thu, 6 Apr 2023 09:35:14 -0500
From: Rob Herring <robh@kernel.org>
To: Stephen Boyd <sboyd@kernel.org>
Cc: Michael Turquette <mturquette@baylibre.com>, linux-kernel@vger.kernel.org, linux-clk@vger.kernel.org, patches@lists.linux.dev, Brendan Higgins <brendan.higgins@linux.dev>, David Gow <davidgow@google.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J . Wysocki" <rafael@kernel.org>, Frank Rowand <frowand.list@gmail.com>, Christian Marangi <ansuelsmth@gmail.com>, Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>, devicetree@vger.kernel.org, linux-kselftest@vger.kernel.org, kunit-dev@googlegroups.com, Maxime Ripard <maxime@cerno.tech>
Subject: Re: [PATCH v3 02/11] of: Add test managed wrappers for
 of_overlay_apply()/of_node_put()
Message-ID: <20230406143514.GA3036886-robh@kernel.org>
References: <20230327222159.3509818-1-sboyd@kernel.org>
 <20230327222159.3509818-3-sboyd@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230327222159.3509818-3-sboyd@kernel.org>

On Mon, Mar 27, 2023 at 03:21:50PM -0700, Stephen Boyd wrote:
> Add test managed wrappers for of_overlay_apply() that automatically
> removes the overlay when the test is finished. This API is intended for
> use by KUnit tests that test code which relies on 'struct device_node's
> and of_*() APIs.
> 
> KUnit tests will call of_overlay_apply_kunit() to load an overlay that's
> been built into the kernel image. When the test is complete, the overlay
> will be removed.

What if one wants to test the removal part itself?

Rob
