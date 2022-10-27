Received: from mail-yb1-f176.google.com (mail-yb1-f176.google.com [209.85.219.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2232F10EA
	for <patches@lists.linux.dev>; Thu, 27 Oct 2022 01:41:19 +0000 (UTC)
Received: by mail-yb1-f176.google.com with SMTP id o70so53335yba.7
        for <patches@lists.linux.dev>; Wed, 26 Oct 2022 18:41:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ZN1sjqfDbSU4YpXqJaq2AYTuLBvoYcLhcoaOncV+3Pg=;
        b=TS9VMOtLr62Ldacr0MT1+3x/bXxS8WSBIyE9WYtbSr87RBhZolGVlKkHUJ20IFQ8oc
         Fw9HVqCj9JuQOynjeRjdzOE8VB3dCpft6g8BqFQOz2rreszC3ligfg1ngqvFdgcYxwe9
         N0XTVj7DaEWuaj7YzzrIDFdn/UBOrZQPibGwzSWbFxFdjG3IajfCZadjlGSTCH+8biul
         YB/+59JdIhcKwY4oluG4hTqycRZehe7P+Ki8pnA7eoYNoBNlP4toYUBlpT7p8lHrGUEc
         zCS2S+bwUUWhDWH73zzymVEpf0gfALoHUowGoy/Fkhj11k8bgQc5+RAW9KUXMvnY0qWw
         dMtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZN1sjqfDbSU4YpXqJaq2AYTuLBvoYcLhcoaOncV+3Pg=;
        b=xs3/DvslbOBeY2d6IM/GltUPPSXalg9rGuOcX7sV8POhMcY7HFakgY9EhN2AxU1bTV
         zkf7ZATlY5F+u549uJfC8mnvhpRK0QnuiW0nbq/NpAiC3ibvGPYY8p7Yrilal7PuSxmf
         m302rdryCvQT3gAvX3mcHouGbv8OW9FwT73PyVHOx78r1amTHSCL+DnA2+1OP17fe7tr
         vF9NGKoXNDOmUCwQFn/YI4krg2t+JdaW51wb0ZyM0miiozNqfE9oHVcTwDlyEAullZOs
         AeQcCGrHSf7l+7aBYFejhF6kS1kUzH1tbH1LRkosZP59JZM5k+J/twHO0UM1EapSvX1V
         E9BA==
X-Gm-Message-State: ACrzQf2RzBZv8y0fjD55fPFjzrXRrC+ANYmMKXg07rmibDg4Sy/km+M4
	jisJ+vT+MZ+kWsLKMcEiNRtew1G2/Q1BcXNns/FQPg==
X-Google-Smtp-Source: AMsMyM7I0yJr9L861lbPDjjg3ZzoqEZd0L5d3Z0hgztsEBJQjFGIIvy4Jree7ypQKxPOhu92d8FMuixurqwsZtO9028=
X-Received: by 2002:a25:7b42:0:b0:6ca:1d03:2254 with SMTP id
 w63-20020a257b42000000b006ca1d032254mr33497724ybc.584.1666834877962; Wed, 26
 Oct 2022 18:41:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221026204031.1699061-1-Jason@zx2c4.com> <CANpmjNMmHa04Fqf5Ub5-vz6HuqT_Gg8GmEfKD6rv8JeMfBZ32w@mail.gmail.com>
 <Y1nQJ9ZFizv0bzgI@zx2c4.com>
In-Reply-To: <Y1nQJ9ZFizv0bzgI@zx2c4.com>
From: Marco Elver <elver@google.com>
Date: Wed, 26 Oct 2022 18:40:41 -0700
Message-ID: <CANpmjNNWaRCOC1=3FE75VWQ8B49RBS6208+Cr9s7v2wBkW6pMQ@mail.gmail.com>
Subject: Re: [PATCH] kfence: buffer random bools in bitmask
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: kasan-dev@googlegroups.com, patches@lists.linux.dev, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Content-Type: text/plain; charset="UTF-8"

On Wed, 26 Oct 2022 at 17:26, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> Hi Marco,
>
> On Wed, Oct 26, 2022 at 05:04:27PM -0700, Marco Elver wrote:
> > Is it to avoid depleting the entropy pool?
>
> The entropy pool never depletes, so no.
>
> > kfence_guarded_alloc() is supposed to be a slow-path. And if it were a
>
> Ahh, my huge misunderstanding, then. For some reason, I was under the
> general assumption that this got called for every allocation. Given that
> this apparently isn't the case, let's indeed just forget I posted this.

No worries. Allocations via sl[au]b are "sampled", i.e. a fixed sample
interval decides if an allocation is redirected through KFENCE (the
lowest sample interval is 1ms, but that's generally not recommended
anyway - default is 100ms - so if the system is busy doing
allocations, every 100ms there's a call into kfence_guarded_alloc()).

> This then means, by the way, that there are in fact no fast-path
> users of random booleans, which means get_random_bool() is totally
> unnecessary. Before I thought this was the one case, hence open coding
> it, but luckily that even isn't necessary.
>
> Anyway, sorry for the noise.

Thanks for clarifying - and good we sorted it out. ;-)

Thanks,
-- Marco
