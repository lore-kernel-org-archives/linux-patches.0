Received: from mail-yw1-f169.google.com (mail-yw1-f169.google.com [209.85.128.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 405A120FF
	for <patches@lists.linux.dev>; Wed, 11 Jan 2023 12:08:08 +0000 (UTC)
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-4a263c4ddbaso192720277b3.0
        for <patches@lists.linux.dev>; Wed, 11 Jan 2023 04:08:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=kmJ3yYULDZh/n/Ts/CIw+F5G8M6+xd7o3i732aR8bfU=;
        b=Huh5mGKh/5kG5fJLMYNPH7N0pSWybZghPelk0NUdJxECQjfmL+QRCFnkVZYZ4p+6iD
         U+QihvuYLnC/fu4YtVobiKMfwnj89zGyUkxMQNLkIvXiiPlansCrF7ZPHS4XRej3DbV6
         fdWAbhsdr/nCOV/rntZFIEmSK949BWpA3v5Sw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kmJ3yYULDZh/n/Ts/CIw+F5G8M6+xd7o3i732aR8bfU=;
        b=66NYliAdw5J4ZzGJQTYXmNIFxuReZBAn4qNLk1+CwLUWL2KmMgTwKD/6IHHbeE/7Tw
         KVrxyVzOVwBQRY4VKpUz/KxPge3EosShOgy9BVu9LwbZJEhPdLeX0tnoprHHNSf5CT9G
         /lybHn53pHQ3ECta8uP/NoDlaZFRwxf21mAH1C1F0M2Az2YlQYqRAIbsN3NQUgSttj/u
         jej+eorBqG4ki4tuk98WlRclb1Bteev/wsudNdgkJGpV1c/LW0eb7Bgocccp2KI55GNu
         l+2p+7+Zcc2IE971igOSY0BNDVSgj3GoMxFGsHCwBPqnVWaMb8no7/pV4Cui6/QeBll3
         fTIQ==
X-Gm-Message-State: AFqh2kpq9NiecAfjL2mj34IYpBWkHI1iqeqaUKrLMWnWdpKL+YTxglIY
	OGo2SaLy/XkB0pFCRCsKMTNeqQnskDJf3CHn2/I=
X-Google-Smtp-Source: AMrXdXuJfx8g0mmlPwFRWvHrqn4pBDV2i+6YRMwTccZxz2WGjFrc58U0094WZIZHrU3QBIS3Rg7p4A==
X-Received: by 2002:a0d:d841:0:b0:4c3:f16d:a751 with SMTP id a62-20020a0dd841000000b004c3f16da751mr16855341ywe.6.1673438887096;
        Wed, 11 Jan 2023 04:08:07 -0800 (PST)
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com. [209.85.160.176])
        by smtp.gmail.com with ESMTPSA id d136-20020ae9ef8e000000b006ef1a8f1b81sm8828360qkg.5.2023.01.11.04.08.06
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Jan 2023 04:08:07 -0800 (PST)
Received: by mail-qt1-f176.google.com with SMTP id z12so13499200qtv.5
        for <patches@lists.linux.dev>; Wed, 11 Jan 2023 04:08:06 -0800 (PST)
X-Received: by 2002:a05:622a:2598:b0:3ae:db1:185f with SMTP id
 cj24-20020a05622a259800b003ae0db1185fmr412604qtb.436.1673438886653; Wed, 11
 Jan 2023 04:08:06 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230101162910.710293-1-Jason@zx2c4.com> <20230101162910.710293-3-Jason@zx2c4.com>
 <Y7QIg/hAIk7eZE42@gmail.com> <CALCETrWdw5kxrtr4M7AkKYDOJEE1cU1wENWgmgOxn0rEJz4y3w@mail.gmail.com>
 <CAHk-=wg_6Uhkjy12Vq_hN6rQqGRP2nE15rkgiAo6Qay5aOeigg@mail.gmail.com>
 <Y7SDgtXayQCy6xT6@zx2c4.com> <CAHk-=whQdWFw+0eGttxsWBHZg1+uh=0MhxXYtvJGX4t9P1MgNw@mail.gmail.com>
 <874jt0kndq.fsf@oldenburg.str.redhat.com> <CAHk-=wg7vMC2VmSBdVw7EKV+7UDiftQEg3L+3Rc0rcjjfsvs5A@mail.gmail.com>
 <Y75k2KaDz2WdcXLk@sol.localdomain>
In-Reply-To: <Y75k2KaDz2WdcXLk@sol.localdomain>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 11 Jan 2023 06:07:50 -0600
X-Gmail-Original-Message-ID: <CAHk-=wga2A0T8a3L6KHPrxjShU5-m6t7t71RfHHLnFmA0__wtQ@mail.gmail.com>
Message-ID: <CAHk-=wga2A0T8a3L6KHPrxjShU5-m6t7t71RfHHLnFmA0__wtQ@mail.gmail.com>
Subject: Re: [PATCH v14 2/7] mm: add VM_DROPPABLE for designating always
 lazily freeable mappings
To: Eric Biggers <ebiggers@kernel.org>
Cc: Florian Weimer <fweimer@redhat.com>, "Jason A. Donenfeld" <Jason@zx2c4.com>, 
	Andy Lutomirski <luto@kernel.org>, Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev, tglx@linutronix.de, linux-crypto@vger.kernel.org, 
	linux-api@vger.kernel.org, x86@kernel.org, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Adhemerval Zanella Netto <adhemerval.zanella@linaro.org>, "Carlos O'Donell" <carlos@redhat.com>, 
	Arnd Bergmann <arnd@arndb.de>, Jann Horn <jannh@google.com>, Christian Brauner <brauner@kernel.org>, 
	linux-mm@kvack.org, mlichvar@redhat.com
Content-Type: text/plain; charset="UTF-8"

On Wed, Jan 11, 2023 at 1:27 AM Eric Biggers <ebiggers@kernel.org> wrote:
>
> How would userspace decide when to reseed its CRNGs, then?

.. and that is relevant to all the VM discussions exactly why?

                Linus
