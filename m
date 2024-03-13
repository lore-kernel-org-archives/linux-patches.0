Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C971ED52B
	for <patches@lists.linux.dev>; Wed, 13 Mar 2024 03:54:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710302098; cv=none; b=c1J/wrVvTXOh5UfgLYOOeNwWtOjhqxECzt8LxqBz3cx/FmpqyH/+aV3PqfUhpXlwxiEh+suDfNCN5WLqFwYZrj+ufXXpWzHMdsqtIzG0nahCV26kMPA2zKy0iRePtUppvoQtB8UA0RuPo6ByniBOGZhv0lq65/LF8bI/4W/E8Vo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710302098; c=relaxed/simple;
	bh=A9WuMf5engSRfC+urYs6dIjYYEm9lck5mar7taMu7O4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lG4b5iFGPIbRopk4VQjhfxT25tmsUAJj5IDQpnrFCXOXM439qA+mgG5/E0rnBtigwWJArxNxsFWXL+aRhbEEikjE4QxvH4es4ewy3z3gjWxrAiXOiKSYJxGBcL8nsCxMmkni64AnWPisx5Sd/fkDvVIXQm3M6B6dztfE70N+CN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CPi1u4nX; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CPi1u4nX"
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-a465f635652so8188166b.3
        for <patches@lists.linux.dev>; Tue, 12 Mar 2024 20:54:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1710302095; x=1710906895; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=VKVNlwXsG3iAqCu1W8+GU0KcqpNheelf4M1fbJwAcjo=;
        b=CPi1u4nXu1tVOIFJvhfIqy/AjRaTWwh7NImK+bjV3KP7oP3u6TDsTND1boaaXQ2j8V
         7SzQBw3k7gyjgtYQ1O6Qt2nfmhcSZ/zYQPuzKx5i9kIGvRXJXG9eQNOs96GimdTOz8pP
         rFq7KtAVAZo9REzdXAWWx5knNwVo0qPjtHux8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710302095; x=1710906895;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VKVNlwXsG3iAqCu1W8+GU0KcqpNheelf4M1fbJwAcjo=;
        b=SfE0lJf8MbnxECgo0j1UlnOfz9t44h48dnfbed0DXSyNPt3WVWJGL1dUdd5kfjSgCR
         pZBh1y+LlLzT8GJOTQAMh7gUsHWZLhKbbXdFjc8U3Ukqi6xasf/L/KG+8xzS22Zhw/mT
         qZ6xfGSL8shRXRDlwRZ4/kJIIKWEgg5Td+lMjzZiIZsihabYPcRguL0MGQIkt/pGzvVl
         IOr3mGE2p7rFlZ9YgmniDpbItjC1tojY7In5skrvJDorzy1daIQ4+8ePv7jbQ1vxdeeh
         wodmQDoD1nQFgqy+qe7Ed7e7f0gCZtsAYN3v+ArwsiyD+Ofjiw+K3I+qBuoyjd+utGBk
         p2RA==
X-Forwarded-Encrypted: i=1; AJvYcCU1Tz/uMiBeWM0//EJhmQ0eBF4z1orXA1lxFUGydVe4XkaHvspPCSozSgFP9R7gotTy03jEhSbw/xfy55oB/WOwLxi4MfrIRg==
X-Gm-Message-State: AOJu0Yzbn9HK77n8vJ54lnbkG64E3YHeW7GfE795VgHOqc0TzSbGuP7U
	2Dmei67ZeUDU5kQNznHJxv3yUiYFKzegkKP9AhOw67VjzZ2qAo41NvnsR31OxCuXlY1pSTfY2FG
	ZL6ciSg==
X-Google-Smtp-Source: AGHT+IH1Tg9Khhd2BDNebQOLWakcQCHANKir1XDPHnOxAcqVUnzzgdvGGt4rdIDbFtqmm0swUMYCSg==
X-Received: by 2002:a17:907:168b:b0:a46:226a:fc8a with SMTP id cx11-20020a170907168b00b00a46226afc8amr5869446ejd.38.1710302094670;
        Tue, 12 Mar 2024 20:54:54 -0700 (PDT)
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com. [209.85.218.44])
        by smtp.gmail.com with ESMTPSA id ws7-20020a170907704700b00a42f6d17123sm4373344ejb.46.2024.03.12.20.54.53
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Mar 2024 20:54:53 -0700 (PDT)
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-a465f635652so8186666b.3
        for <patches@lists.linux.dev>; Tue, 12 Mar 2024 20:54:53 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWA9ZYXDBZUNsoFc1dzkCW06vn5h9oxqe/nYD7rEF7rNXUtJRH1uaBd4vkKX/jhbuI2auBoZ0xO7uRMRDmB/kLgugocg+jEYg==
X-Received: by 2002:a17:907:7b06:b0:a46:6073:8df8 with SMTP id
 mn6-20020a1709077b0600b00a4660738df8mr51030ejc.47.1710302093318; Tue, 12 Mar
 2024 20:54:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <c021631d-29e5-432f-bfcd-1d75ec28d065@suse.cz>
In-Reply-To: <c021631d-29e5-432f-bfcd-1d75ec28d065@suse.cz>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 12 Mar 2024 20:54:36 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiFUvms3x7BC1R_4-t80K3O_XTOW3BKp6nPL_FkFSPzzQ@mail.gmail.com>
Message-ID: <CAHk-=wiFUvms3x7BC1R_4-t80K3O_XTOW3BKp6nPL_FkFSPzzQ@mail.gmail.com>
Subject: Re: [GIT PULL] slab updates for 6.9
To: Vlastimil Babka <vbabka@suse.cz>
Cc: David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, 
	Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	LKML <linux-kernel@vger.kernel.org>, patches@lists.linux.dev, 
	Roman Gushchin <roman.gushchin@linux.dev>, Hyeonggon Yoo <42.hyeyoo@gmail.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Xiongwei Song <xiongwei.song@windriver.com>
Content-Type: text/plain; charset="UTF-8"

On Tue, 12 Mar 2024 at 02:55, Vlastimil Babka <vbabka@suse.cz> wrote:
>
>       Also deprecate SLAB_MEM_SPREAD which was only
>   used by SLAB, so it's a no-op since SLAB removal. Assign it an explicit zero
>   value.  The removals of the flag usage are handled independently in the
>   respective subsystems, with a final removal of any leftover usage planned
>   for the next release.

I already had the patch ready to go:

    https://lore.kernel.org/all/CAHk-=wji0u+OOtmAOD-5JV3SXcRJF___k_+8XNKmak0yd5vW1Q@mail.gmail.com/

so I just did a "git stash apply" and got rid of the final stragglers.
No need to have various random maintainers have to worry about a flag
that hasn't had any meaning since 6.7, and very little before that
either.

              Linus
