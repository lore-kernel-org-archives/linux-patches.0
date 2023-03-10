Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABF36C951
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 07:55:23 +0000 (UTC)
Received: by mail-wr1-f50.google.com with SMTP id r18so4203535wrx.1
        for <patches@lists.linux.dev>; Thu, 09 Mar 2023 23:55:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678434922;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Hg8gm9UXcuofNWv7bFMURJvZUDWceYZ+g4VoqacHVTs=;
        b=XcSpm5S1c3LTIpRC/qSv/wD4Phhsa4jCsOLrRowE6+YdUtdlMT2Koo4r4ka6wFxa4s
         mtmwQTOSxubEKjDOJHdMhFnLsJGYGswUw+sr1KNk2NKS2T3JoyJ4tC2yQ7YMYIa1d3Mt
         rHkS/x1f4mBTfXxgRjQzy3tmceUijtRWfxMuKBwmqxZWRKc7Z53+obu/JywSWMi4tQEc
         vz5tAeb/V/iMQ9/rY/c15TPEilikvL592wkSLIgZUx2SfyPHnWmM/7/g3imS6vKW19yI
         ym6Zc3ZpQIlu8g5Hy7T8VPCgf5PMVTYE/XTZxI225FdRPvGAKhPftedSSGQ2tCGKfR3b
         I7dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678434922;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Hg8gm9UXcuofNWv7bFMURJvZUDWceYZ+g4VoqacHVTs=;
        b=zSz0o+pLG5pYyp6MAvx3WuJIWosg45Tjh6arObg/SxlDPFxWZVMFwfqi/1iMAl966F
         /dIiZ37r2CgWLPEmDfCPYSs8/E2fKPXncNXmlWnR1fklCac0OlicWFTIAoMh8TcYsvaW
         fc9ftSYew/wPbL4GQjKW0gtrlMmxjL4bchMTSy7rhF9tEOo6mJj9/IRGp9xrcK7ssaP2
         Hm0xd87Uu08Ab/otwH9Yw1hbmTdU8AALivKVX2uF+oD3QNmd+dbRYlUYmnAysjerD1Mz
         Xyuvbl2joA00idMV0zLjCBUE6yQVFjD+qdzErxiFiFM4lO67sxN4oCPwH72zkMe9sbXR
         o8UQ==
X-Gm-Message-State: AO0yUKXzaeHsWnH496bdwf5+5dfAb+Q1NUaJ0Rlxw19ygbqQwHvgASFA
	coFF43Gz1nfXFfOI1shaNfMFQgfpj/Xtga/GL1ftEQ==
X-Google-Smtp-Source: AK7set8YJqVZRqtut+bMEQTqwl6r469KIAYC+a6PXbytDy5dL9Ft02+G7BXUCv4WmitzpSAnNx588vSN5VKBNG4uKa8=
X-Received: by 2002:adf:fc0d:0:b0:2c5:8377:3eaf with SMTP id
 i13-20020adffc0d000000b002c583773eafmr4846173wrr.2.1678434921777; Thu, 09 Mar
 2023 23:55:21 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230302013822.1808711-1-sboyd@kernel.org> <20230302013822.1808711-2-sboyd@kernel.org>
 <CABVgOSkxOxpaHVtq1YpvNEshTZ3nic1p7NjV5DPdz066=tiS-A@mail.gmail.com> <377046f369227a11fbf9e67c3c122d79.sboyd@kernel.org>
In-Reply-To: <377046f369227a11fbf9e67c3c122d79.sboyd@kernel.org>
From: David Gow <davidgow@google.com>
Date: Fri, 10 Mar 2023 15:55:09 +0800
Message-ID: <CABVgOSm_yRjqKYegZeFkObkS9cgXaDfD2CTeoE1s7RRLo=RuEg@mail.gmail.com>
Subject: Re: [PATCH 1/8] dt-bindings: Add linux,kunit binding
To: Stephen Boyd <sboyd@kernel.org>
Cc: Michael Turquette <mturquette@baylibre.com>, linux-kernel@vger.kernel.org, 
	linux-clk@vger.kernel.org, patches@lists.linux.dev, 
	Brendan Higgins <brendan.higgins@linux.dev>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"Rafael J . Wysocki" <rafael@kernel.org>, Richard Weinberger <richard@nod.at>, 
	Anton Ivanov <anton.ivanov@cambridgegreys.com>, Johannes Berg <johannes@sipsolutions.net>, 
	Vincent Whitchurch <vincent.whitchurch@axis.com>, Rob Herring <robh+dt@kernel.org>, 
	Frank Rowand <frowand.list@gmail.com>, Christian Marangi <ansuelsmth@gmail.com>, 
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>, devicetree@vger.kernel.org, 
	linux-um@lists.infradead.org, linux-kselftest@vger.kernel.org, 
	kunit-dev@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

On Fri, 10 Mar 2023 at 07:12, Stephen Boyd <sboyd@kernel.org> wrote:
>
> Quoting David Gow (2023-03-02 23:14:55)
> > On Thu, 2 Mar 2023 at 09:38, Stephen Boyd <sboyd@kernel.org> wrote:
> > >
> > > Document the linux,kunit board compatible string. This board is loaded
> > > into the Linux kernel when KUnit is testing devicetree dependent code.
> >
> > As with the series as a whole, this might need to change a little bit
> > if we want to either use devicetree overlays and/or other
> > architectures.
> >
> > That being said, I'm okay with having this until then: the only real
> > topic for bikeshedding is the name.
> > - Is KUnit best as a board name, or part of the vendor name?
> > - Do we want to include the architecture in the name?
> > Should it be "linux,kunit", "linux-kunit,uml", "linux,kunit-uml", etc?
>
> I think I will drop this patch. I have overlays working. I hijacked
> of_core_init() to load the testcase data from drivers/of/unittest-data
> and made a container node for kunit overlays to apply to.

Makes sense to me, thanks!

Looking forward to seeing how the overlays work in practice!
