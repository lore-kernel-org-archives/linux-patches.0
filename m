Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46993389445
	for <patches@lists.linux.dev>; Thu,  5 Feb 2026 09:14:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770282841; cv=pass; b=jHKDQ1fm9xO7QW9o42TGD7mNLhicPQ3wKODiBQK2a+0RI5XOwsiGGC2lngSamQxBKX0gm9KlnRIKGXEdAiNmeP+egTb27G97qp22goGUX+IUOQw4rCC6lt+TkgGcKrNTgFT9MZPXHxw9/WP5i1YKkxwMhTTGrdgVw07XiF53h+o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770282841; c=relaxed/simple;
	bh=kZy9He49zevIscQI8TKi266PdhFwv75woDxw06ZBjks=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oU01d53bvlXu6u3n7MUSUKmzRuiOxiKBtsIAE020JssDTzJ9B26bcCe7eHnxKnYs0Wz//mJoRAcsm20aZxPF8C/7YDZy19MNrLdjIrP2LnJArW8IFs/qz827LgzkZ715/TOI+GoAb4jGyxx9txBWxmVYNix4FxdguilQKBvWuII=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CmHUmI+Z; arc=pass smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CmHUmI+Z"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4806fbc6bf3so7535365e9.2
        for <patches@lists.linux.dev>; Thu, 05 Feb 2026 01:14:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770282840; cv=none;
        d=google.com; s=arc-20240605;
        b=cw0/sX5stdg/cFQ8mhk4h2lFVayARJdQW4P2PmPwiSa69TUwuIzVvKtfVBiTT1vscv
         d6tzD1ZbXydeuq4zYpqeYcLCzCXC/rUT12uTLFBiiNBLba2yKe+GeXQ8q2Wci8z6KQy3
         Vcrt8uieJzR5B+ObQnq3QoA1mHu3b5nAqaiJ4V2E344DIVyD3of85iODXPglWFZDAbhH
         7lD999ptWDu82qE9DsrltkdfJ1m/IddgM8I4BDuLtvOz1HJTqYnTFClxg9hcyaps8U3U
         iz2/83agy54+/QWiJjY/BvKj+NAIxDl1MQF3zRLbCLmmeFfg8Sl8YYzrOuEfP2H2Ixg4
         QWcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=kZy9He49zevIscQI8TKi266PdhFwv75woDxw06ZBjks=;
        fh=K7xJ8Y3AKtQ/hnvyMj/Hmj9bp9WEc95M19yUVnPYz+Y=;
        b=VvOx6mCnzbnGH8srKq8Qpu1hr0WHGi+/qBGCyQXvUnn27y+UjwoRp31aFVp7Ir1A6J
         68ew6yi5LDwN9uTTSk+n8VOgkZzTueaPBrOGA/7NgwA+W1kZrYp3VgZduGMe/QsmtRdb
         sMCjj9xoMU4wVm4LalgyPHFLROPsfiEwSWCjMpK+6584DB3JvC+kpAgq1KweXgKgAJF0
         G377dHoUXMQfGhxjbnJp+AQ+M/JF5CFdzAKTJF/bdqsjyu8U9D8k9QW0V27LDqiBjuDd
         W63f5rhcI6yaT5cI14SGVsZ9aAq1TCIGfJQ83Vpzo/F/8U/wiUfox4HPtcdA9shyziD3
         HyCA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770282840; x=1770887640; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kZy9He49zevIscQI8TKi266PdhFwv75woDxw06ZBjks=;
        b=CmHUmI+ZadSvocyml0T/iHi8zVukREMGqINESGBBxTBOpvf1yAyQ2PvIe9bkCtoWUU
         q0JNMcyuBkZNeRo7H8VtghG8Edt3BDX29KtsnTpz+1tEaClWKyGOHqXLEhALTlFZAx7m
         FDCO7Oo1s1HgMYxjGqgJtnuYuABYcbswUfpvbYD7Ns/wTV/2GjUM/IQDh5dA2cpohxUJ
         /IhTCtCsh1gZFOcdpDllAZuEe3RzMmklVf8OvCIvPfOVGOwFeVKjHnnn+ZpS0xCYdYsV
         2mAZh91/itGUzdIgge176eVgECQPrZYIBH1XbIOJAASfFuLnQ9avukfrUpwau0KUH0tt
         Or7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770282840; x=1770887640;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=kZy9He49zevIscQI8TKi266PdhFwv75woDxw06ZBjks=;
        b=XJV/mUL8sseF7ohpYhL1WZzFxi335j/Yw3Oyj8kVbUbLBASJ2KZbpfHC3smTgfJNAm
         71bL3l9IfRBNeeOithuGAPBOZLkZdd+Lua/ae6GCS+X9xirMqD7NOUqBqyplRzv/WKnE
         3M4uvrCvJHV9T4ZNo+LPZX6Gg+6KMCvSXRXhYTmULSoDBzzb4AJNvrBO0BUBdDBiKPDF
         mK+wFM7k0iW113fSC7tvAf4RzFYLXALS2v3WRrQCmrDiWQRyeSon9Wek7KZ6ylRpP2v6
         PfBiPGYKUI+j0UNARpXzqvvfELhRDdeBbnLz9NiBHW3Rht7zCF96KdOtReDm9Jy4lcjn
         mMIA==
X-Forwarded-Encrypted: i=1; AJvYcCVmrtvW1u4fYo61XBapvkufVc9j4n4jfsyyRbj42XFE6nSPVPab5WB4KhCC1ad2Y/CccERDdyqq@lists.linux.dev
X-Gm-Message-State: AOJu0YzG9xt5WTGSRjc5+Zb4gUZksViRVdV6LrELgwv1YfXBfUqbVKie
	9Et/pQx85X7iZ5n7DhKuL8QBWtX85xZRVp5MyXLIAFc1NUb8DI3gXyWLNpSFcPQr9JxkGZo8kAe
	EFJEHSlm0+bOtsuJ+s4fj9NB5rzN91nWiLutOK+YN
X-Gm-Gg: AZuq6aL2JIRC27DUQm0HRSG7PkEzXqUAGLnWqmauwDk4XbB82RHuvHILoh7/LJandsd
	nnBANCEmNHXQTAbvMH726cJwtJtBanJY0yhjun+0VvwQ6pmo+SB7JSS8GEtf1NPgDTlmIx3viE4
	efjn6SiwogC/EQal+qX0GO4BOV+1G5Re0uCzaNW/HuN7265+xvZPUwAIdCzL4U+omykea3nWZQ9
	HY6cWxXUqqa3fvMz/dQxdFkA+O30VtW+Q0ntAHPdfSzgZMZgsxv10rQcuydiXWkJZJb5AalMykT
	P3L/OPpzspYfpYtyDC72HC9c3A==
X-Received: by 2002:a05:600c:1d04:b0:47e:e946:3a72 with SMTP id
 5b1f17b1804b1-4830e979529mr86636545e9.27.1770282839548; Thu, 05 Feb 2026
 01:13:59 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260204143858.193781818@linuxfoundation.org> <20260204143905.245830999@linuxfoundation.org>
 <20260204184810.GA2715873@ax162>
In-Reply-To: <20260204184810.GA2715873@ax162>
From: Pimyn Girgis <pimyn@google.com>
Date: Thu, 5 Feb 2026 10:13:48 +0100
X-Gm-Features: AZwV_QjqlCzx2sZYGhkrTvRiOprnY_rvYth7AxrlqHjxRYRPxTSZ_CfZuKQ-TKo
Message-ID: <CAJWNTGz0Yd4W3piDT5RFzmmKPhcUaNu0pSEgMOF3U0FmfsyzVA@mail.gmail.com>
Subject: Re: [PATCH 5.15 195/206] mm/kfence: randomize the freelist on initialization
To: Nathan Chancellor <nathan@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, 
	patches@lists.linux.dev, Alexander Potapenko <glider@google.com>, 
	Dmitry Vyukov <dvyukov@google.com>, Marco Elver <elver@google.com>, 
	Ernesto Martnez Garca <ernesto.martinezgarcia@tugraz.at>, Kees Cook <kees@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 4, 2026 at 7:48=E2=80=AFPM Nathan Chancellor <nathan@kernel.org=
> wrote:
> This introduces a new instance of -Wsometimes-uninitialized, as pointed
> out by this KernelCI report:
>
> https://lore.kernel.org/177022794292.7001.3716577555750776270@22d5995788c=
3/

Thanks! I'll be sending a V2 shortly.
