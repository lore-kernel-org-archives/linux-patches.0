Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6692F1361
	for <patches@lists.linux.dev>; Fri, 29 Nov 2024 19:19:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732907946; cv=none; b=PdjoptJd4haWcAksF5STAIxNMEbyVI5TZH1BPGPdx9H8Od3TOnYO380jlhSHn09bNXnwvhcjzBu3rnsWWaKFDtGrB5ANJqd1x/yg3FtUMT6UVM93pCIzHMK+6Lrv0F1JJnDXwfw+BpEbREa8ixppQcaLCk9VIK365+9O/9DV14o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732907946; c=relaxed/simple;
	bh=mNS9FaMKCLppUduw748DyIhFvH81tqU2jublvdUmfik=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Si+qD7hChrLSIUUD6wtCLXSqPwKl/pXSOPbm4QygeLfzJHBjUgWRbmGw3/ENbWnWReqC8JWPGKg/nm9MrSuP+x284YraQITmk3iG0zYDnfCQxMgQUfTWig3r/k4WJif+BEW0HFQ5R4sVVYGne96JLKI9QFu/TSatmOT5v3AzVaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aYUSOtW+; arc=none smtp.client-ip=209.85.167.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aYUSOtW+"
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-53df6322ea7so4074159e87.0
        for <patches@lists.linux.dev>; Fri, 29 Nov 2024 11:19:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1732907942; x=1733512742; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=XI/yTJn2K7uR/0ULxeWbYdLFp4HJLuDCg3+eK/ajORI=;
        b=aYUSOtW+isYYiuW9QvJcSaQ7wbOnuvQXBYw60LdKll5dwTpWNXXdNdIWag9g18SQ6e
         jmUlYBFj9fpOEo0dXCySs/9N8foD/o/+cPoF5FWiC3hw6swhDwD6nzFmOTF7VSC1Yp+R
         c4FzdZHrwUxHj8uoHvm0Y54b8SOQnBSkJCkYc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732907942; x=1733512742;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XI/yTJn2K7uR/0ULxeWbYdLFp4HJLuDCg3+eK/ajORI=;
        b=j/4DtGR5mx4wtLlfSusJQScGHPGBXbgp+ijA7TCPKRjOwXs8x++rKNUVU8DCXR/Twa
         L4fCEOoITEQ/VihrFfU0MA/+Qwf1qT3xGdLHZ+0zk4bT94M6EtF5n72uzXg/ghRG9lZo
         edDR0F8xJeDaopFFstJFgJ0/urpDiKq1Gb6w6+nwOdnDqThcgWG4Rgm26gN4thaHXFfZ
         2J9wiPiyctTOMnnkTHPP1Tz7Mwassm+lGvEQIV9WUOr7KcsvbkkXwIPpaLPJn2/EIw5a
         ybzQlzlxDavHR5JoqZJule0PfkkQSHOLelJQPIOHgAgj7kgQM4m563hvwQueLAQ1JPRm
         IsBQ==
X-Forwarded-Encrypted: i=1; AJvYcCUraC396dC7DdreEeBuFiS+s9CfeWmBdsu0GUiTFOiVsCx3p+npGlwkiObI67AApXMCojITHFvX@lists.linux.dev
X-Gm-Message-State: AOJu0YwH9HwDpOnG8cJnV9speAksAzSzbZGqPZ17XYKw6mua9Kigaeo/
	ZcnJH/TtCf1NSAwlgOJT3Q04LYa2xpKrE96aA5rnvSAL3Jqfy8vYDhKGAVa8BbuObSycj2iXBsv
	ystuheQ==
X-Gm-Gg: ASbGncu5AK6l3E13dYK0dHSok3vAsQPRtdHmtYDI4Nw7yrqyguCfe53p9r2m+5Tshzs
	rQAaB1CizYGA/l2S262Dv7idCP0yndHqdsPtkh9hvuFlBFkHE+g229IxX6hgvdROC7BFkGhLXOo
	rfDS41vGbADpNaIzv3CTAf0WgUftXAgtzwdCXz2ONkTtStapPC3hSfztl6Vu0VknLfx2FCI+M1o
	4mYAaSWWgr+XpF39IM9xz2ZvWac7S5GumGyXSj5yfFlkJGpfyexQrkBUXu8K+VbyhA1E11zMhX/
	hqERlhc4v0W4DZc6RgrnhNy4
X-Google-Smtp-Source: AGHT+IEXxNCx/u7oDMu96Bu6d2pOcld5nUCW3n1BgZAPmySsFQ+s+YhtHDGNa8KVIv9bdWYBWiPWhg==
X-Received: by 2002:a05:6512:3c99:b0:53d:effe:591a with SMTP id 2adb3069b0e04-53df00a91e3mr13059735e87.3.1732907942227;
        Fri, 29 Nov 2024 11:19:02 -0800 (PST)
Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com. [209.85.167.46])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-53df646f1a7sm557867e87.165.2024.11.29.11.18.59
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Nov 2024 11:19:00 -0800 (PST)
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-53df67d6659so3681074e87.3
        for <patches@lists.linux.dev>; Fri, 29 Nov 2024 11:18:59 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWPS7HWOXh/wAuNOQHbzzCs33FgzQFDYbxqFxUKgTpTMKEdc8sc/2o04j3umjraS5bvwO3sGe0k@lists.linux.dev
X-Received: by 2002:a05:6512:3e23:b0:53d:e5fd:a453 with SMTP id
 2adb3069b0e04-53df010b140mr12908711e87.39.1732907939280; Fri, 29 Nov 2024
 11:18:59 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <Z0jEBLLRoUKoBVPk@bombadil.infradead.org>
In-Reply-To: <Z0jEBLLRoUKoBVPk@bombadil.infradead.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 29 Nov 2024 11:18:43 -0800
X-Gmail-Original-Message-ID: <CAHk-=wh6SLoXB4zAY51yScDMwyauo0a8FJ05TO_bb6UVNXcCNQ@mail.gmail.com>
Message-ID: <CAHk-=wh6SLoXB4zAY51yScDMwyauo0a8FJ05TO_bb6UVNXcCNQ@mail.gmail.com>
Subject: Re: [GIT PULL] Modules fixes for v6.13-rc1
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: samitolvanen@google.com, petr.pavlu@suse.com, da.gomez@samsung.com, 
	linux-modules@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, geert@linux-m68k.org, masahiroy@kernel.org, 
	mmaurer@google.com, arnd@arndb.de, deller@gmx.de, song@kernel.org
Content-Type: text/plain; charset="UTF-8"

On Thu, 28 Nov 2024 at 11:27, Luis Chamberlain <mcgrof@kernel.org> wrote:
>
> This consists of 3 fixes, the main one build that we build the kallsyms
> test modules all over again if we just run make twice.

Thanks, my empty builds went from 43s back to 23s where they belong.

(Obviously when some core header file changes and forces everything to
be re-built, that's all in the noise, but the small random pulls are
now much faster)

             Linus
