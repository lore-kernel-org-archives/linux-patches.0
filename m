Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42AF963C5
	for <patches@lists.linux.dev>; Mon, 24 Apr 2023 21:17:24 +0000 (UTC)
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-63b73203e0aso31025537b3a.1
        for <patches@lists.linux.dev>; Mon, 24 Apr 2023 14:17:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682371043; x=1684963043;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1IQmgFRWemEvXJC88T/rDku0y6B5K+c+6E1l1xk0hYI=;
        b=h8yqfVmnsIsaOgvfBMfP0TfIF8rf0Dt0iGWSoJ5hqw0IM/Nes78I2QLmPVreVrQ00b
         iXv+uSHM4guXlcbktd8ejSXbIVhL27z1tOKY2+jiI5kLCvr/LzFEASO+VDDR9oM8lvjm
         3pO3gfXvWCUMYtyOIG0SCXiNIv8mfz22kBS9z3bcOUZetecWnhB/UaCtYzVU5izrOOLf
         RTGTpDLEvq7OdOMY+HkCejVxtRZF3XnVnMadlmZ0YgpcykE4a/negmZAHhTWyDcrfYdv
         9vEykl+NyaYGSpXYpuFV0FH5y5U628FesWSTx3IFrbKl4FfE2z5TNwU6SYMoRl5kqGIx
         /2XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682371043; x=1684963043;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1IQmgFRWemEvXJC88T/rDku0y6B5K+c+6E1l1xk0hYI=;
        b=XlxlwWVarmCjSn8f/sKyncQYEjY37wCzD/iZwvvDWL606K2fEgRrHn8Rayxue79GLF
         gRnpiKH+JQo5ns4vP1usLH0idowTa+KUlLwepZ352wVRRfTG9u5qa2qixZkly6K1fcEC
         wH1zT8UmRZOy0fF/anlqIMP8pCqcRXrywR4qstodM3JmXT8eAhcXFn/uQA7TtvbGNr2D
         F2g5xmRK6MgQ0BUxR5nkdwKpeFamNQhIxCvJWvnWBLHlT/FpaL+/AukCWraU5El9jSXO
         0oY4dMIBfjvMbeVE4DXI/axAhsnX8xztnRlEzCWdPete5AwGPixFdkM63oIYCH0DSraY
         LXaQ==
X-Gm-Message-State: AAQBX9eq4dmEjR9xxvbabI3TT9UZnJP2wUfxUUJZJKiBc8r7+5IAWgZb
	ZbjPEpkFPbUezUZiUHsMbcne/JI6badmXcD4ecg=
X-Google-Smtp-Source: AKy350YdosoMK29+Sw0J+vSpOOdKm+Y6k32RQnY43Hcu+sK/jdkLswUFO7t02Rwt6i53F7WTakMbOvGEF6qngQP/Gdc=
X-Received: by 2002:a17:90b:1106:b0:247:5c00:10 with SMTP id
 gi6-20020a17090b110600b002475c000010mr21067746pjb.2.1682371043441; Mon, 24
 Apr 2023 14:17:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230421214400.2836131-1-mcgrof@kernel.org> <20230421214400.2836131-3-mcgrof@kernel.org>
 <ZEMRbcHSQqyek8Ov@casper.infradead.org> <ZENO4vZzmN8lJocK@bombadil.infradead.org>
In-Reply-To: <ZENO4vZzmN8lJocK@bombadil.infradead.org>
From: Yang Shi <shy828301@gmail.com>
Date: Mon, 24 Apr 2023 14:17:12 -0700
Message-ID: <CAHbLzkoEAJhz8GG91MSM9+wCYVqseSFzBQdVAP78W5WPq26GHQ@mail.gmail.com>
Subject: Re: [RFC 2/8] shmem: convert to use folio_test_hwpoison()
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>, hughd@google.com, akpm@linux-foundation.org, 
	brauner@kernel.org, djwong@kernel.org, p.raghav@samsung.com, 
	da.gomez@samsung.com, a.manzanares@samsung.com, dave@stgolabs.net, 
	yosryahmed@google.com, keescook@chromium.org, hare@suse.de, kbusch@kernel.org, 
	patches@lists.linux.dev, linux-block@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 21, 2023 at 8:05=E2=80=AFPM Luis Chamberlain <mcgrof@kernel.org=
> wrote:
>
> On Fri, Apr 21, 2023 at 11:42:53PM +0100, Matthew Wilcox wrote:
> > On Fri, Apr 21, 2023 at 02:43:54PM -0700, Luis Chamberlain wrote:
> > > The PageHWPoison() call can be converted over to the respective folio=
 call
> > > folio_test_hwpoison(). This introduces no functional changes.
> >
> > Um, no.  Nobody should use folio_test_hwpoison(), it's a nonsense.
> >
> > Individual pages are hwpoisoned.  You're only testing the head page
> > if you use folio_test_hwpoison().  There's folio_has_hwpoisoned() to
> > test if _any_ page in the folio is poisoned.  But blindly converting
> > PageHWPoison to folio_test_hwpoison() is wrong.
>
> Thanks! I don't see folio_has_hwpoisoned() though.

We do have PageHasHWPoisoned(), which indicates at least one subpage
is hwpoisoned in the huge page.

You may need to add a folio variant.

>
>   Luis
>
