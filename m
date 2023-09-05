Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6A38101DF
	for <patches@lists.linux.dev>; Tue,  5 Sep 2023 22:56:17 +0000 (UTC)
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-500760b296aso434995e87.0
        for <patches@lists.linux.dev>; Tue, 05 Sep 2023 15:56:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1693954575; x=1694559375; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:user-agent:from:references
         :in-reply-to:mime-version:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4NGXeEczgA9LphP4UdxC38RekZBY8qrCBSM7+Stq+6I=;
        b=Ld6UA4K/9hIKO6qekl+rj67w6/m9Vmg5M7APX831ExDXZ4GHMNO/3B37u0tyJ9Z2/j
         LZMxByrbr1YsXg0LrXotrWU+wZrztZ2Elg2w6FaKUUmSKC+QrK5+6gA+ga8krUJ4zid4
         igImZCqqAjOVFaPzYURqZEbH3qM6lj0zsqZok=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693954575; x=1694559375;
        h=cc:to:subject:message-id:date:user-agent:from:references
         :in-reply-to:mime-version:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4NGXeEczgA9LphP4UdxC38RekZBY8qrCBSM7+Stq+6I=;
        b=SaSwJXorH3R6oQHAnW6Z18SvO2Q1xk3vtJ9kcRnR7VSCLbAoScBX+ALdVXoDRZ0f7V
         DKNW4ge1rW33ldYwduemD4uug20zseO9nl7bKsuXdKc+3gEs3z7pXwZ26vw1VsjoW4iU
         9xvHtnUBAgR6q/pFXFRpBM6cuZv114o7kGlsXM3xsXp/ONa1VFojfoZ9/E/GQlizUYz4
         IUQvVlqd6WjOeLw1vfNcDRnV7z3ts9a0M0mFs6zejrOHOR7sqocMbpmwQ4kgGBjAXcRg
         DYMetNPHkqfdFYVbU+yJayohF0eLjOptOo8tGAgWal5UhytJEijjGqIdA91nRBrq6PKD
         pShg==
X-Gm-Message-State: AOJu0YxfkCZuq7iXcqJdW3D8UmozMzwiAPmUavemwZeak++XvGWgeSrX
	0I0hDm0n2pq4l7Kw95AjSa9hGq959o7T9p44I3ObMg==
X-Google-Smtp-Source: AGHT+IHYUtjBkMfDU9GXRAamcogYrs+yiDDeqP/qm65g/NIerCdBZ0EqaUtXVDrQlBvmo3WeXpe55hJMABEEFT3h5sI=
X-Received: by 2002:a05:6512:2256:b0:4fe:13c9:2071 with SMTP id
 i22-20020a056512225600b004fe13c92071mr395748lfu.2.1693954575649; Tue, 05 Sep
 2023 15:56:15 -0700 (PDT)
Received: from 753933720722 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 5 Sep 2023 17:56:15 -0500
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <321578a9-91fb-4733-b4c7-82dcc0ec8f8f@linux.intel.com>
References: <20230831011405.3246849-1-swboyd@chromium.org> <20230831011405.3246849-3-swboyd@chromium.org>
 <321578a9-91fb-4733-b4c7-82dcc0ec8f8f@linux.intel.com>
From: Stephen Boyd <swboyd@chromium.org>
User-Agent: alot/0.10
Date: Tue, 5 Sep 2023 17:56:15 -0500
Message-ID: <CAE-0n514jMG3ckYF58koSamHDYiuoxry7cyuoNMGjygwQOCb9g@mail.gmail.com>
Subject: Re: [PATCH 2/3] platform/x86: intel_scu_ipc: Check status upon
 timeout in ipc_wait_for_interrupt()
To: Hans de Goede <hdegoede@redhat.com>, 
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>, 
	Mark Gross <markgross@kernel.org>, Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@lists.linux.dev, 
	platform-driver-x86@vger.kernel.org, 
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Prashant Malani <pmalani@chromium.org>
Content-Type: text/plain; charset="UTF-8"

Quoting Kuppuswamy Sathyanarayanan (2023-08-31 07:27:35)
>
>
> Since you are not using the return value, I would not use time_left. I think the
> following version is easy to read. But it is up to you.
>
> wait_for_completion_timeout(&scu->cmd_complete, IPC_TIMEOUT)
>
> status = ipc_read_status(scu);
>
> if (status & IPC_STATUS_BUSY)
>    return -ETIMEDOUT;
>
> if (status & IPC_STATUS_ERR)
>    return -EIO;
>
> return 0;
>
> With above fixed, you can add

Thanks! That's a lot better.
