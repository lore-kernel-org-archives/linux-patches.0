Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA46F26D4C7
	for <patches@lists.linux.dev>; Tue, 11 Nov 2025 18:20:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762885224; cv=none; b=IE/HiyBKihPbZI5bRQFd7tbmPDreMcdfJjAo1D+AdZoDnZpGIXOIjggHJcBP/44pPfBGYhWK9IwoaLzwm/w74a0aaaqhaB6842JasfiPgbL6/FW/wCgP8VzYh6i8KN3zKlt7XclCGDNbt2M7MDcxDiocGZO3RkdXWPSnIvfrvN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762885224; c=relaxed/simple;
	bh=n95I+wM9yjtOPWAMaBFaxz6m9Ftg/IKT0PcTyfUSGlI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=D1uE2no9vFUwLPGKyAmPNkxogoaOiWDH6elBNB2uUHRgLo3UEV3B5OKHSJYwYseCNWk9HJljff6Zkeo8hrIMkzKdoOLKoelwzlBH8YEGY0J5bsCgdr4Ot/t2AmYC9sP/BQTqY1cv/9UN9dz37fOQ8sndrb6GwloF/F3me+G5m4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org; spf=pass smtp.mailfrom=linuxtx.org; dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b=JtCU6bv2; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxtx.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b="JtCU6bv2"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2957850c63bso372465ad.0
        for <patches@lists.linux.dev>; Tue, 11 Nov 2025 10:20:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1762885222; x=1763490022; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xH7fLeRJDduUwW8OBykePNE1qy/cPCbf7jTb60w/cyc=;
        b=JtCU6bv2tPO/zxDMNfRSex1IYWnzlKSAJsanF7SumQ/Rctp+h8aXAI8mcUJlxg5Bro
         S16bLIUSTRNZQi561EEk9JsWE9ytmuSF8L9mepT1dIiNbRGRYdP9FmXPp4sCLHncB6nT
         OXjKqsjA2Z8L2gI/M7Sa14Xl/09N5hWiOVjVU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762885222; x=1763490022;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=xH7fLeRJDduUwW8OBykePNE1qy/cPCbf7jTb60w/cyc=;
        b=xCHN2znjxRQ4UIKYWrfrb7+PLqfvj4EURdZJBajag3R/motz4oTI2Y2Yx7YenNk+QL
         k/E3h7waFQBGBpldJjdhhlcYKws9Tt5H8mmq7Z8SkNDDvRGTHtNzpX0NURB5y31qY1vR
         ujexjUMXu/L5CsHiWU1omteJC/R6F7i4UZI2Z/mg1NKr4+bCPfUS/uukrqfW7tOJKsmr
         kEXzzwbVsUDQjem6s54UgVfRpyrsN5NwAj5hgZvogjYZDla+yaTzYnBDwKR7vKmHj3Ru
         3AY/c3KONx5UXQNRo/vOrrcHTWzLoUv4pd/hhXDBUUKyox1dVu5JHH0XfFueoL/ZKN22
         9Puw==
X-Forwarded-Encrypted: i=1; AJvYcCW1nwjPo7opbh8pOO+abhZrNrbWwJmAHiaxuiQ5ct4N2Mi3zD1LC/E2EH4Bip9JwWoXjUQNzUBf@lists.linux.dev
X-Gm-Message-State: AOJu0Yygo+5vK8TiPj5dN1LHn4emKrtEfTFXzRBIxhaW4eZD7dhKcBLv
	SCC0B3sjq63f7V1+3mFocm3LL0DlG2dezc9swhbT8j2nes9UqNpgE0lW/6bvZVydiA==
X-Gm-Gg: ASbGncuA7cQE2a7pl1wYxXMW+A1PC7n3jR4PMRYjRLvhwVkHAxDOcVTv/I7cePgK8gq
	kbclp0xOB+LyUzlxJWg+L7WTo+lsp/gpwh1OTtGtQp5K2ot/ImG2uJJgWgyrwWnO8A8ANFx9y5E
	A3Oriskml3W8SzRBIwfRT6MREsSrDaHOXT3NYJP83wzy6HgAFh1qNSwswoQKGdSzG4kzLX7c4O6
	QoPrK50iEauc5dLgqK32qr9j7J532nefy0QVRBRZQYwePoPuhRQCp58YBi1r8tB1B6JvPUDsZqS
	PZrUMnbyk0WhYVA6yInsCOd57Bu3nnM+mP9v37RlzmBeT4meyuFnVCfqJ2NyMaPyflxNtr6m565
	YEN1Q/F7svkK12YPxbgCLC8ML1DOBcMyHRKLVDgB+X3/epxE7Uhcw8ksAl938O2gtMHpqQLkQMy
	wYhsnJjhj/jx7uCF0eJHKHyw==
X-Google-Smtp-Source: AGHT+IFISfayPR8Fe6WwyNlqhp69sJHz84+HZ2Bp8C2NA+i+9BczyVM/K1Yo6kiGYGLWOtzHIehM7g==
X-Received: by 2002:a17:903:18d:b0:297:df99:6bd4 with SMTP id d9443c01a7336-29840842cb3mr52741695ad.18.1762885222074;
        Tue, 11 Nov 2025 10:20:22 -0800 (PST)
Received: from fedora64.linuxtx.org ([216.147.123.202])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2984dceb2efsm3747495ad.110.2025.11.11.10.20.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Nov 2025 10:20:21 -0800 (PST)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Tue, 11 Nov 2025 11:20:19 -0700
From: Justin Forbes <jforbes@fedoraproject.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Yuan Chen <chenyuan@kylinos.cn>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Quentin Monnet <qmo@kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	Jiri Olsa <jolsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.17 145/849] bpftool: Add CET-aware symbol matching for
 x86_64 architectures
Message-ID: <aRN-Y5tjf6v5AtSf@fedora64.linuxtx.org>
References: <20251111004536.460310036@linuxfoundation.org>
 <20251111004539.911440769@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251111004539.911440769@linuxfoundation.org>

On Tue, Nov 11, 2025 at 09:35:15AM +0900, Greg Kroah-Hartman wrote:
> 6.17-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Yuan Chen <chenyuan@kylinos.cn>
> 
> [ Upstream commit 6417ca85305ecaffef13cf9063ac35da8fba8500 ]
> 
> Adjust symbol matching logic to account for Control-flow Enforcement
> Technology (CET) on x86_64 systems. CET prefixes functions with
> a 4-byte 'endbr' instruction, shifting the actual hook entry point to
> symbol + 4.
> 
> Signed-off-by: Yuan Chen <chenyuan@kylinos.cn>
> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> Acked-by: Quentin Monnet <qmo@kernel.org>
> Acked-by: Yonghong Song <yonghong.song@linux.dev>
> Acked-by: Jiri Olsa <jolsa@kernel.org>
> Link: https://lore.kernel.org/bpf/20250829061107.23905-3-chenyuan_fl@163.com
> Signed-off-by: Sasha Levin <sashal@kernel.org>

I am guessing this is missing the other patch that went with this
upstream 70f32a10ad423fd19e22e71d05d0968e61316278. Without it, this
patch breaks the build.

Justin
