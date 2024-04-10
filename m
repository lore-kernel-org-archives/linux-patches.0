Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA6F81552E8
	for <patches@lists.linux.dev>; Wed, 10 Apr 2024 09:03:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712739836; cv=none; b=mUHEaY30A9CKWXlAUF4Rr9UE9FFPgeoaGzXciyPu8Sc++A0KzVpAfsViNAQCt/WhwPMeeoeo5ovnrmkFoC6b/RTqoHqWu4+G889/I4MGjfx9sB3GocRsXFhIpv4ghV8kg9VxV59EnLr+IK2GWiClzWFJXdSNjOFRvaImoa7LfxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712739836; c=relaxed/simple;
	bh=B9d2R4hoGbPp5idXYb2vgQvujKhcUYWUxg4lT/pfgN4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lBK7bDJ0K/xowY9u//HHtBkve55tEYNf5n5gu0jRVbL8auBWXRtmk3GRMeAPIl6I1+/DKLyeeKYZsqRbK1UsBvas8jDJkrza6MpZZrSAcA3FREJauVTXIWPgoRSmI5ckxEBEdPDH8UOHe5I569eEYuh1J2XTemb0Z9Z5o8MYmLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aT3AcTeg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aT3AcTeg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83550C433F1
	for <patches@lists.linux.dev>; Wed, 10 Apr 2024 09:03:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712739835;
	bh=B9d2R4hoGbPp5idXYb2vgQvujKhcUYWUxg4lT/pfgN4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=aT3AcTegTEOeIdqLGzV6VTGoN+98AUseowdO4Yi82EQIUoaJwYPpKZWGIBxauhDVV
	 w9I5WRfduo6xilyHjtFcF6rFRVmvE/i0Cb4q6125hwiaRzbM+jDPKsie9CUTVNXfHs
	 +vORnsowBWvBpNH49B7PGLJbUiPYJ3yZY5o3+dGB3oIm+8lqsWz9dFEZz/oozjTiSO
	 vVxQyCM/4q7/OziRtN/vDVb3r0+8WgjLVnPfIAlbo/PCVZX0EZwX5ddXJ66eXeH546
	 RoDN9uJIt20pM8T5m3ayP7BiBQfvfTWJTR5riEIMM/tNFM4TNjv0cWqbvusV89DKNs
	 c29TBtLV8bgkQ==
Received: by mail-lj1-f176.google.com with SMTP id 38308e7fff4ca-2d4515ec3aaso54928431fa.1
        for <patches@lists.linux.dev>; Wed, 10 Apr 2024 02:03:55 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWNzkL1iqWc7x8cSJPwVUt5rjKGzz0ZNW6SNe1j/mUW7XImjDhHcIDjH5+Za6jcRPL/77jaPQ54MlwjFEb2+p+6BOL9NES5vQ==
X-Gm-Message-State: AOJu0YyUhJfBS9qbfB/C/AdFSlJrsRTo9yLkKi7x321g2mobaOm6PKkb
	5EMQReO6d4xYgHgX3XuOnomzZ1FghdbSoYsaxOo5HyZ5kHFY11LhFkDKv0Hv+5sXhp40F1wfpY2
	6FmjOtrwP7XgPUaE1r0wKk6j1A8k=
X-Google-Smtp-Source: AGHT+IHRxWAhCJaiJ/uA2REHe8l/GAL9gvAOb61sUaG0m94sZKPHiTWIfXPhxohTY53jlgMwQHab2jxJmzzA66KC8DE=
X-Received: by 2002:a2e:b0f5:0:b0:2d8:79d6:454d with SMTP id
 h21-20020a2eb0f5000000b002d879d6454dmr671834ljl.23.1712739833915; Wed, 10 Apr
 2024 02:03:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240408125309.280181634@linuxfoundation.org> <20240408125317.917032769@linuxfoundation.org>
 <76489f58-6b60-4afd-9585-9f56960f7759@hardfalcon.net> <20240410053433.GAZhYk6Q8Ybk_DyGbi@fat_crate.local>
 <25704cce-2d6e-4904-a42d-47c96056459d@hardfalcon.net>
In-Reply-To: <25704cce-2d6e-4904-a42d-47c96056459d@hardfalcon.net>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Wed, 10 Apr 2024 11:03:42 +0200
X-Gmail-Original-Message-ID: <CAMj1kXH+xOB3cLHL5XHAxMHeN8oOXYaqdExx2+Tij6vwZwhkiQ@mail.gmail.com>
Message-ID: <CAMj1kXH+xOB3cLHL5XHAxMHeN8oOXYaqdExx2+Tij6vwZwhkiQ@mail.gmail.com>
Subject: Re: [PATCH 6.8 271/273] x86/sme: Move early SME kernel encryption
 handling into .head.text
To: Pascal Ernster <git@hardfalcon.net>
Cc: Borislav Petkov <bp@alien8.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, 
	patches@lists.linux.dev, Tom Lendacky <thomas.lendacky@amd.com>
Content-Type: text/plain; charset="UTF-8"

On Wed, 10 Apr 2024 at 09:00, Pascal Ernster <git@hardfalcon.net> wrote:
>
> [2024-04-10 07:34] Borislav Petkov:
> > On Tue, Apr 09, 2024 at 06:38:53PM +0200, Pascal Ernster wrote:
> >> Just to make sure this doesn't get lost: This patch causes the kernel to not
> >> boot on several x86_64 VMs of mine (I haven't tested it on a bare metal
> >> machine). For details and a kernel config to reproduce the issue, see https://lore.kernel.org/stable/fd186a2b-0c62-4942-bed3-a27d72930310@hardfalcon.net/
> >

is the issue reproducible when you use GNU ld or LLD instead of mold?
