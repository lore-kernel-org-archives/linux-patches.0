Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EB4C1D54C2
	for <patches@lists.linux.dev>; Wed,  6 Nov 2024 08:20:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730881259; cv=none; b=jXNb8umt5ZvYhMCSPpBlZTgsW3+Vy4dA2E706/OWAYuJ9Wzrx2n4fCczhuOe/F11gOMTl6uPmAvdYBGCjO3scEJaUe3fDPnzjFdMsLI+NhC/HD67rGVLVmVWX7CoF4efov0QZrlG0ntt+3tvllAM4uh0b5H4fkWrJjzLx5yR6x0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730881259; c=relaxed/simple;
	bh=Zbaa3THwmyR0QbbitUy47QNMG6IMEwpDVlVishwvaeQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=D5G6SeNNh9ygeN05aYm/u4iJel9Hmtb0tGK1eFRATHNx1q5Bi3c1a4262Mab/ybsBgTRCCjjHNBGe8Ts7kVyFGO0NrHQIQ5O2Asv0ZHzkiUmiE+KVcnKVmq+KA9IrH/iBql5Vqv82vhXtCmXhsPeDPuPSTp/boH8U1Q9vZDbD8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IXb9lj8j; arc=none smtp.client-ip=209.85.160.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IXb9lj8j"
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-460a8d1a9b7so130411cf.1
        for <patches@lists.linux.dev>; Wed, 06 Nov 2024 00:20:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730881257; x=1731486057; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9zWEHY0OXQFhrxfXe2dL4RGu6ZaPdsnfdH9+QncDVfg=;
        b=IXb9lj8j91OStTWjisn6cYilbSn5sDB96d+UOyu13bvO/sr2z2yPJxDy22qfXFZq6A
         6yAYnmjsMgTDs2ufMYB/eUK0pPo3nkpgc0veIc7Scm3UE/8wLMHTdrWDisPgy6QbOnEV
         /vyDeUrdPgYWAdgw2+lAPs0NmEbSN6BGe4Lff3AyLZIf4SmWPSqjM5F5V33Vasnmt0Bv
         g9V1msXOTaSmYqYZHnfxnULVfxL/mtK/OZBb/liCRtmuIsGSDSyZODc2gDEsK83iJQSP
         3/iC2W1UfJJy+WO2kgBs2hvj0mV75NTxLm/JbpFxn7OJbEDKgZshah91WiNHA3IDSGME
         o/Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730881257; x=1731486057;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9zWEHY0OXQFhrxfXe2dL4RGu6ZaPdsnfdH9+QncDVfg=;
        b=J4tiCAMAE4OWOO44psij3E81lp4v7zlr3/sIGBZeTWF7zEpBnE0oCnn/1V07Aan3Cw
         yOmzDORlxHjmgfTJifHZK9StfmeFN1khHRfkwMDKr1LcANUJQJ64RCyPUj28Es1xAfxX
         KevCCtEKZsuONEufJj5Q+Y0VPc0F4qZf3hC3kdeMUk7V6LPD83D/sajgvVfFNemw/pvO
         DZYLvWaoEl/g8vjG4DJzav2MD9p+hpRv3jY/6TZXVh42FP5Iet4czsVqPdK2FcoOAYb0
         Q6tdq8Sz31LapOxoI2Koe+YAe+TkpYeEBll66MyGw3vzN0nLz0JVsL2WiA+g287CH8bY
         5Nhg==
X-Forwarded-Encrypted: i=1; AJvYcCXKNyGFDPmdJsFT4IY39pWHQeXIj6145M9jpT5z4cc6S/Ade4VSc9MR+VrmQyhUSGph0HDedsd6@lists.linux.dev
X-Gm-Message-State: AOJu0Yw8jLmQjD5UBmsczb8ThUk8EHhfDNi6oeqBEArIfeoMZEFWr26n
	7zLstCv4vbW0hPITO3T6GiB6vbLuScwVSoeRkwb+NaLt3JlLBi8ohMcv0SX1KasNWhehYACdPm7
	//fCNN4fEIBSASswshaJFORC0GUV8+BdN7b3o9W2KlCaEWrTXLw==
X-Gm-Gg: ASbGnctlfiX7wP7BR6Gbstph/8H/Sr1RR7b5ezpev7EqeeOt0twb5qN6XKXcXXByzUS
	Q2EgliXRT4Re1rlvdtK0Mn1vXvWTaLLE=
X-Google-Smtp-Source: AGHT+IHVRXb16/Eki75BEyW60A1+LleOmCRbbQLzOBFovvuid3gjU31QECFuGcSFQD7dc7heQpZVLYkLFMh9hgpf0Z8=
X-Received: by 2002:ac8:584b:0:b0:461:32e9:c5ee with SMTP id
 d75a77b69052e-462f0024a56mr2697281cf.0.1730881256767; Wed, 06 Nov 2024
 00:20:56 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241021171003.2907935-1-surenb@google.com> <2024110639-astute-smokiness-ea1d@gregkh>
In-Reply-To: <2024110639-astute-smokiness-ea1d@gregkh>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 6 Nov 2024 00:20:45 -0800
Message-ID: <CAJuCfpEAKAePqbB74j8iCQ1JXrvZQbELkAMzdT7dWtvdros-Eg@mail.gmail.com>
Subject: Re: [PATCH 6.11.y 1/2] rcu/kvfree: Add kvfree_rcu_barrier() API
To: Greg KH <gregkh@linuxfoundation.org>
Cc: akpm@linux-foundation.org, fw@strlen.de, urezki@gmail.com, vbabka@suse.cz, 
	greearb@candelatech.com, kent.overstreet@linux.dev, stable@vger.kernel.org, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 5, 2024 at 11:09=E2=80=AFPM Greg KH <gregkh@linuxfoundation.org=
> wrote:
>
> On Mon, Oct 21, 2024 at 10:10:02AM -0700, Suren Baghdasaryan wrote:
> > From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
> >
> > From: Uladzislau Rezki <urezki@gmail.com>
> >
> > commit 3c5d61ae919cc377c71118ccc76fa6e8518023f8 upstream.
> >
> > Add a kvfree_rcu_barrier() function. It waits until all
> > in-flight pointers are freed over RCU machinery. It does
> > not wait any GP completion and it is within its right to
> > return immediately if there are no outstanding pointers.
> >
> > This function is useful when there is a need to guarantee
> > that a memory is fully freed before destroying memory caches.
> > For example, during unloading a kernel module.
> >
> > Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
> > Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> > ---
> >  include/linux/rcutiny.h |   5 ++
> >  include/linux/rcutree.h |   1 +
> >  kernel/rcu/tree.c       | 109 +++++++++++++++++++++++++++++++++++++---
> >  3 files changed, 107 insertions(+), 8 deletions(-)
>
> We need a signed-off-by line from you, as you did the backport here,
> please fix that up and resend this series.

Doh! Ok, I'll resend it tomorrow morning. Thanks!

>
> thanks,
>
> greg k-h
