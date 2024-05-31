Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FDFF15746F
	for <patches@lists.linux.dev>; Fri, 31 May 2024 10:49:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717152580; cv=none; b=Ffj2VQrE32SXL5/HnUMc0HQjZqP6wSYpWuYYUISgQfQ5gk48z1T/zay18xln2eQZfmVU6fNWoc/X3eEoX3aLLCXU1VSEbApipzMFa2IREUnHmqFwONImfRwmfzHiE96dIwGe3y8ziIQIOdZw+rx5SwW49y2rFg87sxXeXxJhcRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717152580; c=relaxed/simple;
	bh=rGZ05Wtl7/tFqqeKIfV5yhM9avsTsSpt/wX8DUBeUl8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UtB4a9FBWFdCygpQaYmhQzucf6IVCuDiuW380ytay2/bj6AMoPZW+50/NbCfht9D/QhVDViNsJWF7ObYGTB9Lfge7vnO4j4PZhEx7fkGprulu4u8ucLuAcriRrKC623CYgtuYgqPjI7jImKKXtIqO8BsZRdpHEgLqb9lfDQBsCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WmF4G5Vq; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WmF4G5Vq"
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-57a22af919cso8942a12.1
        for <patches@lists.linux.dev>; Fri, 31 May 2024 03:49:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717152577; x=1717757377; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8rRp80lBW4FzoN8ncda3wP8nvCP0z9lrK+Jc/IWYduo=;
        b=WmF4G5VqHpUQfT9SH2YbB8OTUWr38HkzAUFqhSYQeJ86+d8FNTgLuclBukVH1FZsY6
         vcszSG/uWLhX8zC3jH48IViEAsYLfGn2slvJ2qlcw5au7fYoInbkiRSn2zDTCPmv13TK
         vMQ/D5f2rFTEKwyFB32eIqzRhsUokdZuQC4oBPI1RPjUw3md6q3aSRal7BgL1RRSQvRM
         zAq1gUrUhvILIJofJmFmgfWRB51d5gAm1Wyd9zfHgnkimoQ9khB0nPB/V5dwg0wKbEVd
         Q2fnnTyRu3gBplKp3+S/UpMbm4PPkQE7WIkXmNR/WG/4UWsoSWOnqgJY2+ZL1FaTDLOf
         0CAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717152577; x=1717757377;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8rRp80lBW4FzoN8ncda3wP8nvCP0z9lrK+Jc/IWYduo=;
        b=kwrS1OkF0QurujmdAMeBaUfLAagrJTEthCCIOI+1krrpkP/LEXDFPr7J8kHWhXJlLn
         8oRhw2X87PoxUt5iAAoL3atTAsvtMy7l/4TGI0L88kiutmtaqDzWSWEBvew4zkuNgJ/g
         2jVk888HJo13jsgk6fzCd6/KIcuSO7UCVFqbIfM0H3rwx2zj5iAgROv9YsFY1liTbyep
         H/iBM2PB+vUFwCDazZt9270qPEaWeDZ6X2/HVY1J3hk/zcActorXnG8lLWIlc8PVZ+7Q
         UhWUl4uQEnQChwdOOMenyduKviOB2GA/3Bt1dxEtPV83oN1ZqEubTHG+08OMXdjxGQKw
         HYHw==
X-Forwarded-Encrypted: i=1; AJvYcCUgLrvzomhT6PQLxpuj/KbAFknnirhL0xKfF6Z4IbeE9N+qLH4v1LpUuWszseCJ0DQRM8cgdER/qfin87Hsd1F6q3PmkKy88g==
X-Gm-Message-State: AOJu0Yx7sLfj3GwvYZ1if+r67Hp1DBDCIdSbzM+On0k/edj9/d6GTjPA
	//kROjKPLgoSCjO5LmNGWzrLoyfJQiPsLkoVBWgudxiINmx5t+a/KSPDsQnNLZiIje949mKujTn
	8K+VSVOM3BVhoOEzFq7yIrUpXwvaFIHl2pIjx
X-Google-Smtp-Source: AGHT+IGNvupsb1UVYookhWaIP+aHUuOsnl1pdEMh3RFuflcTYqmKBlgYK4b83wq+i4WL/kDsRqslbWqCLr6DiBSSCT0=
X-Received: by 2002:a05:6402:148b:b0:572:988f:2f38 with SMTP id
 4fb4d7f45d1cf-57a33c6bab5mr160899a12.6.1717152576620; Fri, 31 May 2024
 03:49:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240528122352.2485958-1-Jason@zx2c4.com> <20240528122352.2485958-2-Jason@zx2c4.com>
In-Reply-To: <20240528122352.2485958-2-Jason@zx2c4.com>
From: Jann Horn <jannh@google.com>
Date: Fri, 31 May 2024 12:48:58 +0200
Message-ID: <CAG48ez0P3EDXC0uLLPjSjx3i6qB3fcdZbL2kYyuK6fZ_nJeN5w@mail.gmail.com>
Subject: Re: [PATCH v16 1/5] mm: add VM_DROPPABLE for designating always
 lazily freeable mappings
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: linux-kernel@vger.kernel.org, patches@lists.linux.dev, tglx@linutronix.de, 
	linux-crypto@vger.kernel.org, linux-api@vger.kernel.org, x86@kernel.org, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Adhemerval Zanella Netto <adhemerval.zanella@linaro.org>, "Carlos O'Donell" <carlos@redhat.com>, 
	Florian Weimer <fweimer@redhat.com>, Arnd Bergmann <arnd@arndb.de>, 
	Christian Brauner <brauner@kernel.org>, David Hildenbrand <dhildenb@redhat.com>, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, May 28, 2024 at 2:24=E2=80=AFPM Jason A. Donenfeld <Jason@zx2c4.com=
> wrote:
> c) If there's not enough memory to service a page fault, it's not fatal.
[...]
> @@ -5689,6 +5689,10 @@ vm_fault_t handle_mm_fault(struct vm_area_struct *=
vma, unsigned long address,
>
>         lru_gen_exit_fault();
>
> +       /* If the mapping is droppable, then errors due to OOM aren't fat=
al. */
> +       if (vma->vm_flags & VM_DROPPABLE)
> +               ret &=3D ~VM_FAULT_OOM;

Can you remind me how this is supposed to work? If we get an OOM
error, and the error is not fatal, does that mean we'll just keep
hitting the same fault handler over and over again (until we happen to
have memory available again I guess)?

Or is there something in this series that somehow redirects userspace
execution to getrandom() in that case?


> +
>         if (flags & FAULT_FLAG_USER) {
>                 mem_cgroup_exit_user_fault();
>                 /*
