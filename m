Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4301E7C
	for <patches@lists.linux.dev>; Mon,  3 Apr 2023 04:04:16 +0000 (UTC)
Received: by mail-wm1-f41.google.com with SMTP id v20-20020a05600c471400b003ed8826253aso6371434wmo.0
        for <patches@lists.linux.dev>; Sun, 02 Apr 2023 21:04:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680494654;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dfpcCyJlBWrQogdsMi05FfYrfZ2wEfN0si9pF5mmMEo=;
        b=oN9vYChtrdLr6qfCCWuW5oLYxj0PGkE2qXn3Y35L0hH2MHGG2Vwe/tbq1lpBe/Xy6k
         TaaAdfp0xNENIfGPcTRpM7OVjbx2oHh/yFgBGdf+9rOQTzFCNT+YhAGOUy7J7MWRkgk+
         kcCZP/Du3jWWGykZfag67wmizfbzOq9XN/ZpuV9KoObb2BJiQANwBuhKrb4h/aNTYz0G
         y546vvfl59yhr/dnGewZxUk8+NWpTIajQfV2/cD9fT0Zg30Pv4TfSbXHNDWshzsqFnkN
         0p06vdRAu/MJR4ZNUfBK/QsMw4Fb4SA/RqL+jW1nFDPqA2aAHDrRAQoiiBu5ibYu/mpc
         zAhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680494654;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dfpcCyJlBWrQogdsMi05FfYrfZ2wEfN0si9pF5mmMEo=;
        b=qDmnIPAjWuQiDkzLucq3o1zRk5QrZM97PftXkD0QbejMcBlZ8vYH8nF7474NMCNtGX
         R674KSBUY1ltaxrIcahs+OBvOYMsvk+PNBBi8deIqNUfUvUkCRwJ50ICw8FYrk/GCyEA
         yuFT5EdVot4oh5VtBKiOaIDyCmhKh4TagwVA4s+AWW5wnZi84js9+y5rX459rz0PUwoz
         8cpMJFS+UrQQlTJGWuu3NrUAqA3hQx27s+pD0LkFtJ/9SSP4LjIFJPftldYTpiwFVe3m
         hmKVlb9enzXqb25+RL+SD/NSTa5LCbXg2my+s+5nk+LGF7zSs7czqt4ME1JX1OB2QVlb
         Rpzg==
X-Gm-Message-State: AO0yUKX3xror3VDEcgC2dRAQgjeQ4Le6AabH6t+5xvj+PGKVnvEDTAUX
	QsJQpOUZz9tfFvcfxUTjFlpRf1cWfPo=
X-Google-Smtp-Source: AK7set/nuMZskSO45lzGuF2YA589VfMcTt3xCFkljUrgjlBp1p0kQt63kTk+o+vX/k1vreZicE6aig==
X-Received: by 2002:a7b:ce0a:0:b0:3ed:237f:3da with SMTP id m10-20020a7bce0a000000b003ed237f03damr27017095wmc.22.1680494654247;
        Sun, 02 Apr 2023 21:04:14 -0700 (PDT)
Received: from suse.localnet (a-pi8-84.tin.it. [212.216.222.51])
        by smtp.gmail.com with ESMTPSA id u25-20020a7bc059000000b003ede06f3178sm10696915wmc.31.2023.04.02.21.04.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Apr 2023 21:04:13 -0700 (PDT)
From: "Fabio M. De Francesco" <fmdefrancesco@gmail.com>
To: Matthew Wilcox <willy@infradead.org>
Cc: =?utf-8?B?6YOt6L6J?= <guohui@uniontech.com>,
 Vlastimil Babka <vbabka@suse.cz>, Linux-MM <linux-mm@kvack.org>,
 LKML <linux-kernel@vger.kernel.org>, patches@lists.linux.dev
Subject: Re: [PATCH] mm: remove all the slab allocators
Date: Mon, 03 Apr 2023 06:04:12 +0200
Message-ID: <3566797.hdfAi7Kttb@suse>
In-Reply-To:
 <CAPj211unsM2zM8Y-7iZ09jmKF135xZ6pSPzyzN2dkFvN=wUZFA@mail.gmail.com>
References:
 <20230401094658.11146-1-vbabka@suse.cz>
 <ZClhKouKa5e6/jha@casper.infradead.org>
 <CAPj211unsM2zM8Y-7iZ09jmKF135xZ6pSPzyzN2dkFvN=wUZFA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

On luned=C3=AC 3 aprile 2023 05:51:42 CEST Fabio M. De Francesco wrote:
> On Sun, 2 Apr 2023, 13:04 Matthew Wilcox, <willy@infradead.org> wrote:
> > On Sun, Apr 02, 2023 at 05:09:14PM +0800, =E9=83=AD=E8=BE=89 wrote:
> > > On 4/1/23 5:46 PM, Vlastimil Babka wrote:
> > > > As the SLOB removal is on track and the SLAB removal is planned, I=
=20
have
> > > > realized - why should we stop there and not remove also SLUB? What'=
s a
> > > > slab allocator good for in 2023? The RAM sizes are getting larger a=
nd
> > > > the modules cheaper [1]. The object constructor trick was perhaps
> > > > interesting in 1994, but not with contemporary CPUs. So all the slab
> > > > allocator does today is just adding an unnecessary layer of complex=
ity
> > > > over the page allocator.
> > >=20
> > > The slab allocator is very core and very important to the Linux kerne=
l.
> > > After the patch is merged into the mainline, it will have a very=20
profound
> > > impact on the development of the Linux kernel.
> >=20
> > https://en.wikipedia.org/wiki/April_Fools%27_Day
>=20
> Wow!
>=20
> The most interesting implication of this "patch" is that you noticed that
> some people may actually need the link above to be able to distinguish
> between foolishness and reality...
>=20
> Thanks :-)
>=20
> Fabio

Ah, I was so shocked that didn't realize was responding with the GMail app=
=20
from the tablet... :-)

=46abio



