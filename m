Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74DAA3BADBD
	for <patches@lists.linux.dev>; Thu, 16 Jul 2026 15:59:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.215.176
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784217571; cv=pass; b=EIWm82wV82glohRtNw+QhTypFh2BTbtPoL3VQuU40SaMGqMQsVANSrZDn1LzMCK9UMML3E1Md31mqB0ZQNGZpQWmniMQGg2b6bvMEqyAnutHJKNXhq5SZ0Ri28k8S6yzHVbFAsLeD2GbtbTHBO58l/bjcYtCLRztur69T8tDAUI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784217571; c=relaxed/simple;
	bh=zJu1dwF9TbUJeBdkxNZLeYjiqmyBnDs3aAO0ElbitLw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fsxlcLsvluNBHDjeq+mOlDE5SyDJwMXWrVa/mPDnKj9WAP8LtGF6PIBTVvcdIePTQ6F7c7R8+u+qpJfY7UqKI+OpqD2YBOgahdR+VFZsLlWGTXjVawa5j7NZFZLsV4RLPMF0m8DKK/nDh4YCPcVvPsyJs4NNrkrxhSOIAhKBE4E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=En9H+qRy; arc=pass smtp.client-ip=209.85.215.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="En9H+qRy"
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-ca6a6181273so544294a12.1
        for <patches@lists.linux.dev>; Thu, 16 Jul 2026 08:59:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784217570; cv=none;
        d=google.com; s=arc-20260327;
        b=NLMHzZjt7TO+4ibtwmslDDE081SdGefgLZJ6KOg2C0xvvfPT+y9WJp0HatF1xn6tGF
         L8ROaeR50SCHcnv/qjkzrygpcu3JGbVqN7qtdXTYkg+ys/qVlwL98LUEOKrWO/+uv2AC
         g1abTD3hdEtXo+FGq8lU7rVzWCXANJOIugKPmdSmIX8CjwWIOm0MkPiEUu8U/fNEnHOI
         6cbVr87gJ1SuOXfSQLJy7Av2ny6cdD48mynE/qHIIdFiiONTL0frgZyL/S3dV2EahwBQ
         uRW5jZhaoyUvr7Txh4RDGti0QYjhgi1p9yTLY4xQRRa8GIq1H1xZpAIOZ1TWeaWG+dMb
         b1Lw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=hlQZxDdSml0xDMs0XumFP9JBpvcKv+l/SOFfHugqC8I=;
        fh=bqpVLX6Le2gt4/teknt8LS86EIrbo4YCeL+Jx/yQEE0=;
        b=E6LnnHUrIUMwX6Ad7lehNfDVYGsz2KPrlC7LnVxUJEJY2mMGGaKQWn2zlg5+TxVmXn
         LmWfnUnouuYQb20CtdLnsx3xuM9lhQ0ZIDIUZuqv656UFiBalD9Rr5Dg18ppS08ex6Nr
         gtL7tij+WzPRCT6iGIQOFSp6us9cE1Y9j/ip7KYqS0QPrZRCqNctAzDZ3Ipo6Ir7P4HC
         mNGNcfZkh3MzuRLeypvSq8rMbpsICb7h6JqX8TOmmHtMrQiObdj2wWlaHJ0D6zzDPxug
         l2HBE2XzVYnplZc81bLpym6DvRNzXeWr94zIQJCqPgnNoIc0XdPxHRNiYh8kFRVY4awE
         lIGA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784217570; x=1784822370; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=hlQZxDdSml0xDMs0XumFP9JBpvcKv+l/SOFfHugqC8I=;
        b=En9H+qRyXefxNz4ZbKGZWjWrsdzcSxRU05kRg7GqUyMpi/dZ6qClWtH6gusGijzG1g
         tTxs9GUbsnm37X/t5D87x/BZRbwpgGSuQjg/esuusGhGii0juJ5JEWS86Bd76w3NraLA
         C1LohXYrv0wjLK0wodxT26P5VrS58PVMFRp7cf3sLEPOLDjmW+9d6M2JPIoBU8pBp2fB
         N8/bSdydowVnt5DyoMrmc70F+Ho4YKzNVdCPd5/FgX74rpt/4PpKjSo2A6M2e9CX52BX
         DpRi9gUku9aL26J43X32M555NdXmJbcP9ns10sBlfIrBtYFGYRxo7Yhw09MXn8nIpkxb
         Xf0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784217570; x=1784822370;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hlQZxDdSml0xDMs0XumFP9JBpvcKv+l/SOFfHugqC8I=;
        b=p7RFcB0IuZNgebQbcVAfW6B5rdiOuB3EyX3VAsVJzXMDGKVcMT2lwf/EODg1tw4s93
         niLSg4QmyJZjY2/G6Rtyxrq0dGDaXL8HreSwW0uhu8wxQbUE5bIiySzQdUXltQvpsDQu
         ROEznwlmNYC8db9y0yg139TmdRshTE0+s5KxJuG+eeZb96z5JEttiIuwptO+HK+zTfgi
         fpXMwOlZ761bjeinoi3YIVR5KakeJFTW5t/tVTt0ry8RgEjen/6lJHyCB078HwTcM43f
         LxEt9M9lofl2E13NYk7bN/Ii0uMTDJn+OnQzJFM67vfIIJ5meaEbwDWNXSiw+ZFlqdtH
         KMgA==
X-Forwarded-Encrypted: i=1; AHgh+RrYBdvDe/3V03uLFZi7NhBm4OxrYZh4di2NBJD05WAmpVnN8s54g9mJ54auEkAflpZPJFzoHP7D@lists.linux.dev
X-Gm-Message-State: AOJu0YymsBIIoL6hl937HUK1Emj/JCdKR6IH1HGeEeljHbIRpjAns8u0
	fABDbFqDp6FhO2GsRxJFg1lUzyYLD3ydPyLOSVzQvp9QjIk8JiluIIzp4VqRzRQFIiLFbWQfAWE
	yKBJeo7ASkSrV6XOpRXaEJXrO12w7xCE=
X-Gm-Gg: AfdE7ckGaY0bjHqd+5vJ0P1GStI1G2syGWVh32sqggD9xo/dUCdd53kOUzCxci/2JUd
	bbV5RcNC5ixYLrkADH4eC1gCN352LHNPLLOvWrmNzZbdkMZ4OjsgIv8dUVY1+OqH+NjQB7g+9Za
	G04fDs8mffqP4eHk3P/KuRP+tle7I9W0+Je5N+eHc+Zjh4olfmpVfzCDewywOejJz7VVqWKF8LE
	vO/6l5P5PpqJpsg0PbiiTcfJCdNHdFVAI67NPjZb/flnM40KEgupFLkB8KsXEOnzzWT40+TV+/7
	L772LVW5obfa2sPIXNw1PkofKGMqJ2W13HKZDVbUAJ/MMWpXrIK3XGdojREyQzOQehR1lt1K5pn
	h+hhz3Lpm9Gcm
X-Received: by 2002:a17:90a:d408:b0:381:2d9a:447b with SMTP id
 98e67ed59e1d1-38dc7b31c40mr16876897a91.4.1784217569550; Thu, 16 Jul 2026
 08:59:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260716133044.672218725@linuxfoundation.org> <20260716133045.571209187@linuxfoundation.org>
In-Reply-To: <20260716133045.571209187@linuxfoundation.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Thu, 16 Jul 2026 17:59:17 +0200
X-Gm-Features: AUfX_mxLnnJrZtnA5wfceOKKnG8J4B2XqBcU0ceGtgBPWuUPMBS8hEfS_Jd8uI0
Message-ID: <CANiq72m_6Xgc5WA-xwEjYf51FjEKH-cC20zv0iEHpbHB58kRmw@mail.gmail.com>
Subject: Re: [PATCH 6.18 040/480] rust: Kbuild: set frame-pointer llvm module
 flag for CONFIG_FRAME_POINTER
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	Alice Ryhl <aliceryhl@google.com>, Miguel Ojeda <ojeda@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 16, 2026 at 4:00=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> [ - Adjusted Cc: stable@ as discussed.
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>
>   - Added comment with link to the PR, similar to what we did in commit
>     ac35b5580ace ("rust: arm64: set uwtable llvm module flag for
>     CONFIG_UNWIND_TABLES").
>
>     - Miguel ]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Ditto.

Cheers,
Miguel
