Received: from mail-ua1-f52.google.com (mail-ua1-f52.google.com [209.85.222.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64FD71FA1
	for <patches@lists.linux.dev>; Fri,  3 Mar 2023 07:57:07 +0000 (UTC)
Received: by mail-ua1-f52.google.com with SMTP id p2so1092618uap.1
        for <patches@lists.linux.dev>; Thu, 02 Mar 2023 23:57:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677830226;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZAR2N87vP4MjUgtQ2gw4JnK3iq+Hn4L+wybsd58CSxY=;
        b=Y4S1bVqvNP8bXmXeMWBfAOjkESbvS9wEgywI6nHPj3NYHmzr/H2cXtpfoCORuFywSC
         ZCKozdoQiKR4vx9MgrQYnvCG04i+ShY5hNS2V6OmlNgZxbspoMWXRjCzj60MNOjR/ccv
         BHCxj3t9ggLMvxFDne1wqy1V7qdlbWdaG5SAn2fJLpes2+Aph7BmfHacrc5KEysjrXXk
         U9G5gWtZzOkzk/R2Xi9oHJ0lPCWJJ35jxFLJ4acIBs7D+CuieTQ40eQ7CrUIpvZ91ZC+
         +/w22WHbdcRMgluq5V+SCnmd9JaOJ66Zv+XfHxnMHu2tdnf5IFlT50uI4UFvOa5HCGir
         u5PA==
X-Gm-Message-State: AO0yUKUP/hpz8wS1sCvmZmj6Z1YeaWdYbO9AbUAlQ+6lSMMnRpH+w67R
	yXv3ewdqGtfBqyvX3uPzqb4f9026tb1pl+Lo
X-Google-Smtp-Source: AK7set81p8OjUvOBT5bXbq/GT1Oms4hghzZQRn8xK/tQTNbCA57g+CNNGu3IUrx4JJt04bFU0l1D6g==
X-Received: by 2002:a1f:250c:0:b0:40f:f3e1:53c with SMTP id l12-20020a1f250c000000b0040ff3e1053cmr458895vkl.1.1677830226171;
        Thu, 02 Mar 2023 23:57:06 -0800 (PST)
Received: from mail-vs1-f48.google.com (mail-vs1-f48.google.com. [209.85.217.48])
        by smtp.gmail.com with ESMTPSA id p84-20020a1fa657000000b004104eb2a731sm228443vke.17.2023.03.02.23.57.05
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Mar 2023 23:57:06 -0800 (PST)
Received: by mail-vs1-f48.google.com with SMTP id o2so1624459vss.8
        for <patches@lists.linux.dev>; Thu, 02 Mar 2023 23:57:05 -0800 (PST)
X-Received: by 2002:a81:f105:0:b0:538:49a4:b1e0 with SMTP id
 h5-20020a81f105000000b0053849a4b1e0mr3042397ywm.2.1677829755610; Thu, 02 Mar
 2023 23:49:15 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230302013822.1808711-1-sboyd@kernel.org> <20230302013822.1808711-2-sboyd@kernel.org>
 <CABVgOSkxOxpaHVtq1YpvNEshTZ3nic1p7NjV5DPdz066=tiS-A@mail.gmail.com>
In-Reply-To: <CABVgOSkxOxpaHVtq1YpvNEshTZ3nic1p7NjV5DPdz066=tiS-A@mail.gmail.com>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Fri, 3 Mar 2023 08:49:04 +0100
X-Gmail-Original-Message-ID: <CAMuHMdVN=s-ytn03Kze5okA6rhzdWJ0cWxXV0vrtYXDvLoFMQw@mail.gmail.com>
Message-ID: <CAMuHMdVN=s-ytn03Kze5okA6rhzdWJ0cWxXV0vrtYXDvLoFMQw@mail.gmail.com>
Subject: Re: [PATCH 1/8] dt-bindings: Add linux,kunit binding
To: David Gow <davidgow@google.com>
Cc: Stephen Boyd <sboyd@kernel.org>, Michael Turquette <mturquette@baylibre.com>, 
	linux-kernel@vger.kernel.org, linux-clk@vger.kernel.org, 
	patches@lists.linux.dev, Brendan Higgins <brendan.higgins@linux.dev>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J . Wysocki" <rafael@kernel.org>, 
	Richard Weinberger <richard@nod.at>, Anton Ivanov <anton.ivanov@cambridgegreys.com>, 
	Johannes Berg <johannes@sipsolutions.net>, 
	Vincent Whitchurch <vincent.whitchurch@axis.com>, Rob Herring <robh+dt@kernel.org>, 
	Frank Rowand <frowand.list@gmail.com>, Christian Marangi <ansuelsmth@gmail.com>, 
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>, devicetree@vger.kernel.org, 
	linux-um@lists.infradead.org, linux-kselftest@vger.kernel.org, 
	kunit-dev@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi David,

On Fri, Mar 3, 2023 at 8:16=E2=80=AFAM David Gow <davidgow@google.com> wrot=
e:
> On Thu, 2 Mar 2023 at 09:38, Stephen Boyd <sboyd@kernel.org> wrote:
> > Document the linux,kunit board compatible string. This board is loaded
> > into the Linux kernel when KUnit is testing devicetree dependent code.
>
> As with the series as a whole, this might need to change a little bit
> if we want to either use devicetree overlays and/or other
> architectures.
>
> That being said, I'm okay with having this until then: the only real
> topic for bikeshedding is the name.
> - Is KUnit best as a board name, or part of the vendor name?
> - Do we want to include the architecture in the name?
> Should it be "linux,kunit", "linux-kunit,uml", "linux,kunit-uml", etc?

I would not include an architecture (or virtualization method), as
this is independent of the architecture or virtualization method.

Gr{oetje,eeting}s,

                        Geert

--=20
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k=
.org

In personal conversations with technical people, I call myself a hacker. Bu=
t
when I'm talking to journalists I just say "programmer" or something like t=
hat.
                                -- Linus Torvalds
