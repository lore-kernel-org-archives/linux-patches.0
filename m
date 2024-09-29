Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 470994C62E
	for <patches@lists.linux.dev>; Sun, 29 Sep 2024 20:21:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727641264; cv=none; b=kcEcMyid5nqJTxZk0gmsinEgE5tsU0F3sLjK3+fypyfDFbEmfCjjzcm7khxyZIiYFeJZe+2EUPTLyM+0+aD30ILLaahs06262uJn6jpYavjIxZmW6DRTyUHOZh4cgRZ5F7NWmWptfIvJgG8dTLaEQCHjdD/PJ2yehjMthbY4HxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727641264; c=relaxed/simple;
	bh=NCMujOi7gIknHs127h5m38WVgd6G0xciBwWlyhI04G4=;
	h=From:To:CC:Date:Message-ID:In-Reply-To:References:Subject:
	 MIME-Version:Content-Type; b=r00MQ+cRbKgfXA1/Z5yVTsjxdUvPgWTCYtdQEXfGxO7XnM0tD1WNQZ3CGjHIJpkUWgFU50HrKR51nq+5vke0ggx1aedQZg8RTfeBGFIN7JFh/IYgbDZvR7PSNRRpDVYG/FKR32wcSZpYW/4QOduSOWJKhOsr86p20HjPWg/EBCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com; spf=pass smtp.mailfrom=paul-moore.com; dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b=AaUjqH+5; arc=none smtp.client-ip=209.85.222.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b="AaUjqH+5"
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-7acd7d9dbefso470674285a.3
        for <patches@lists.linux.dev>; Sun, 29 Sep 2024 13:21:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1727641262; x=1728246062; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:subject:user-agent
         :references:in-reply-to:message-id:date:cc:to:from:from:to:cc
         :subject:date:message-id:reply-to;
        bh=j730t5RgznBmQZu3lvSO1ELFYrR4fxxSXPbfDnOL7lc=;
        b=AaUjqH+5baq5UJgylxuHkIlPbyrj3ELWOP5KAdTfvbMCA5pwVUN2S8/cExLoJJmsbw
         dZt4cR2mP0ZqF3qGHyJi2d81lfe+fvTrzsMXEgV5ZVjSQjQ2t4Qp20KKtDyvfNUdnjmv
         kSHibU6EZF+d4I9udxFYQKQnsox5pNugsPbyZ0H0wztZXrFAkDbH6iQUQ579m6raW1ZC
         B1Pqo04RKyMUHoMcoHXcyeAvBP5Nwm4RUQCnQxAa+YcLqoBNet6mIHbEwoUEx57Wc1uS
         QeDRpNH+dnc4t9YtL+wrJ3tU5mKLhaRXPHtLUstMzLGbPWdBbWpWkXq2PuMIA2lQSAwo
         m3JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727641262; x=1728246062;
        h=content-transfer-encoding:mime-version:subject:user-agent
         :references:in-reply-to:message-id:date:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=j730t5RgznBmQZu3lvSO1ELFYrR4fxxSXPbfDnOL7lc=;
        b=GQfiq+rIef886+qNYcl6LC0CURUpRl8TLT+weFCdZ0otynQ8og9KON/gtw3U4iP40V
         t2uejPR0pyw55dUVyNqP2++s49hPVBeuiLndq1SfIuXPMC0aVLod2EJO44M0KoKL+Cr7
         O8f4dr5kUzn+KSaplqpepaMxH0j/oYf391jQKusUu2TbucjoYezVKM+9a5XxR2uYUOwd
         z4vOIxtEDvg0RS1hNXw8ZXrPgsMzKoUGjGmH96sb9rmFiVLq9/uL06HWaX5hI2YFMzNQ
         cNARXdKFrO5qFeIn0L8gwp1OLUqLNgqS8/KWp8VTPI6bYD9pbymd/+fGzdJtBdA4fxqN
         u5gQ==
X-Forwarded-Encrypted: i=1; AJvYcCVYnsV+zet2gKHVuBZ/Ph9E5zs5Xe0TiLIzJY1wFD8Ns0CQwiT5mwbgyOX0OND5aHk2tWE7YMID@lists.linux.dev
X-Gm-Message-State: AOJu0YyeLCKJaTSdr7Fk844XdDeDi2YRED/c+Hl7gWpMSSMONqEVCO5K
	xuQ0tm2LbouGmOubONb4zPU4WLbTeCxdDXPkCeQs7XEgAGT1Xed64XvJk88Rrg==
X-Google-Smtp-Source: AGHT+IE3rPnUiHlGZpJAiiSi2r8ITRz1wB3lhzsgmG3CaQpGo6aFcM3Rt59tO+884CFfrtoXeBewRA==
X-Received: by 2002:a05:620a:24d3:b0:7a9:b114:4704 with SMTP id af79cd13be357-7ae3783849dmr1387092785a.22.1727641262161;
        Sun, 29 Sep 2024 13:21:02 -0700 (PDT)
Received: from [192.168.22.104] ([62.156.169.180])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-45c9f33a4c9sm31021261cf.73.2024.09.29.13.21.00
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 29 Sep 2024 13:21:01 -0700 (PDT)
From: Paul Moore <paul@paul-moore.com>
To: Nathan Chancellor <nathan@kernel.org>, Kees Cook <kees@kernel.org>, "Gustavo A. R. Silva" <gustavoars@kernel.org>
CC: <linux-hardening@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
Date: Sun, 29 Sep 2024 22:20:59 +0200
Message-ID: <1923f716100.28a7.85c95baa4474aabc7814e68940a78392@paul-moore.com>
In-Reply-To: <20240928-maintainers-security-kconfig-hardening-v1-1-c8c64071cc02@kernel.org>
References: <20240928-maintainers-security-kconfig-hardening-v1-1-c8c64071cc02@kernel.org>
User-Agent: AquaMail/1.52.0 (build: 105200518)
Subject: Re: [PATCH] MAINTAINERS: Add security/Kconfig.hardening to hardening section
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed; charset="us-ascii"
Content-Transfer-Encoding: 8bit

On September 28, 2024 8:26:28 PM Nathan Chancellor <nathan@kernel.org> wrote:
> When running get_maintainer.pl on security/Kconfig.hardening, only the
> security subsystem folks show up, even though they have never taken
> patches to this file:
>
>  $ scripts/get_maintainer.pl security/Kconfig.hardening
>  Paul Moore <...> (supporter:SECURITY SUBSYSTEM)
>  James Morris <...> (supporter:SECURITY SUBSYSTEM)
>  "Serge E. Hallyn" <...> (supporter:SECURITY SUBSYSTEM)
>  linux-security-module@vger.kernel.org (open list:SECURITY SUBSYSTEM)
>  linux-kernel@vger.kernel.org (open list)
>
>  $ git log --format=%cn --no-merges security/Kconfig.hardening | sort | uniq -c
>        3 Andrew Morton
>        1 Greg Kroah-Hartman
>       18 Kees Cook
>        2 Linus Torvald
>
> Add it to the hardening section so that the KSPP folks are also shown,
> which matches reality over who should comment on and take said patches
> if necessary.
>
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
> MAINTAINERS | 1 +
> 1 file changed, 1 insertion(+)

For the sake of casual observers, the reason James, Serge, or I haven't 
merged anything in Kconfig.hardening isn't due to any malicious intent or 
lack of appreciation, rather it is out of respect for KSPP and not wanting 
to step on Kees' toes.  I've happily merged KSPP related patches to those 
subsystems which I'm tasked with looking after and I plan to continue to do so.

--
paul-moore.com



