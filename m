Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com [209.85.208.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D5123CD8C9
	for <patches@lists.linux.dev>; Fri,  5 Jun 2026 16:09:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780675790; cv=none; b=AdJqhPT1ypfwyh06B07LJc669IgWstKnUIAMuFQlxZd+NYQ0wXVm9yrxKU++CK4CY7dH6qJRKwiWyfcFFpHSm5FJVtiGsqlGmMdJhNUWh1SG1ojEMf0vgfbTiRoqP3vE+S5hj7EzAnj29gqn+EyHGf7x4WZbTsgyILAXdWk6GUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780675790; c=relaxed/simple;
	bh=3Jk2TzG5gR2RH4+LwM3XSlFeV25EIj3RoPOfWA1O8Gs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DWrhAcf5Gj0I7w3ByGpbgFAiDug8RsLT7P4WLyOXTFfE3Dvkgu+LnNYu8dfIVstdqaK3/pwBf/8i65qoVtE9JumaX911hd+LVaXpfBDhkhBb+WRjMmLRY10HBc5/GbenLgxddV4h5nlgZU8U5YqQwIecVTDlFpK604n6QO365ZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HQpwUNdc; arc=none smtp.client-ip=209.85.208.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HQpwUNdc"
Received: by mail-lj1-f175.google.com with SMTP id 38308e7fff4ca-396775c26f9so20157491fa.3
        for <patches@lists.linux.dev>; Fri, 05 Jun 2026 09:09:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1780675786; x=1781280586; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=y6UQFMgxs4xPTWbEaYQXP4WreuO3V04h3DiBWisQT8s=;
        b=HQpwUNdcNOFaWXU+RCsAOvrx5PDy41peN2urD7MiCT7sW7B9bFUw8pIwba1ApKlPUH
         od29znbLr2T/JkmZivw0jvfQAoC2Kmx5Mx9/PwtdVg+2u2+ghegCO4jIKd8Sl63JN9IK
         igXjOKHiMg3lviTO1HUWi+kHH1HjOS/UWrPbA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780675786; x=1781280586;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=y6UQFMgxs4xPTWbEaYQXP4WreuO3V04h3DiBWisQT8s=;
        b=dUUvqJj6w1Cut7JlC0rpEj0NMBZ4qsQ1EfJyBJCGU43M82cuxDanxXH21aGVjEsTC2
         yTUpp/IpO4hcVFv7BtDqp5BQTsn5R+DfSIQb7saZP/wKmb9xRpP2PaohMsR5izdKgqTj
         0jtAdNMDpliSNMJ/SGvt1BRftwgrauoaj++kLMiLSpSrqeA3mwTCHWbY/A/p/PUYl7+Z
         IVUYXZw56zmDYD4Wc519McX6fyxZ0XIRzj7fL7VxIcQxlox+EqnzMGnEqDRms84qLrLq
         C81B+LIHEBb9o1xYZSWUAwEUXKkMt2lriA1oSU6O/RbJC3OmvsJf3gm5zOU1BwOw0WER
         11RA==
X-Forwarded-Encrypted: i=1; AFNElJ8QUtNlrJ6+crNjNdjy7k0910wNBX8lK1RVcis6yMbJJfqRmRP0ruYVaDvSAcw9GqbzzjUP8vTO@lists.linux.dev
X-Gm-Message-State: AOJu0Yxk7ky8BiA9X3CQaSDLpxaAX5hEZgwz4MIE+9qSui+r3h6+DG63
	aEqf6mon2mxS25bm8aP0WHhpoptBTWfgUzSSdZbgW3NxKqHkQnqzwylidNa7r4DyZunaGwN8JtN
	JdzVkS2MXQA==
X-Gm-Gg: Acq92OF/vrDRq4l/3TiSCJQjE64J0Atj22Wz5fwmlX041lALsfjxKjQF+br7Naz6qtY
	nvkAhkiDiMwLZ/Y9S+5j8HVM/k3ZIFBztzW0k7DMNYhi+VpV4f1l4rGNPBe/PikziXHgersCUpl
	eEhTXG7y5O2c9RK2M6O3p+QL1Q4LYGn1dqG0siD4X7c7rrXA4QQ/xjzkCuIBu+Ug7QavZRJNAMo
	keFfDZVsrHp6C+TpEEOrLpVH3Tqnw02h4ZvsZrCZhedehnIHvr69i4PIO7R3vjWHIrj+hVcTMgM
	3ofg2/ZEwaZ+oIIygq/JIfLHZo1Kgp9zK4LcOFUVnZBz+LXs1jnDP+xlO14qXn0ZsypcYt7YC0R
	l4uYCQpOsWsF8xsGLHP1XP6LSBaP0F45G4064bjmioaplVgX5DX/qr6d+cK4a5zC2pVLo9ro0y4
	qQtwdw0gOFjUEBkgDWp55HmUddHsdKr+wWQMkkCn1hNuDnWlYk3w3nDKDUzgJxvNWHY93VckTXU
	mEwJRaKOww=
X-Received: by 2002:a2e:a106:0:b0:394:3deb:f360 with SMTP id 38308e7fff4ca-396d091d40bmr11457661fa.20.1780675786126;
        Fri, 05 Jun 2026 09:09:46 -0700 (PDT)
Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com. [209.85.167.54])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-396abf66e37sm26455791fa.5.2026.06.05.09.09.45
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Jun 2026 09:09:45 -0700 (PDT)
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-5aa66893e9fso2412060e87.1
        for <patches@lists.linux.dev>; Fri, 05 Jun 2026 09:09:45 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ/W8gJaK6S2bTAzXUeHayyGAXoCsTpCevYyqV67HIZ88NtRmZe3IVFUG2fOFxTk0boTNFhmS9EP@lists.linux.dev
X-Received: by 2002:a17:907:9686:b0:bee:323d:1239 with SMTP id
 a640c23a62f3a-bf372e1e4fdmr260752266b.38.1780675389972; Fri, 05 Jun 2026
 09:03:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260531010107.1953702-1-safinaskar@gmail.com>
 <20260531010107.1953702-3-safinaskar@gmail.com> <d9806b34-fc73-4878-997a-95c5e8ae4b29@sirena.org.uk>
In-Reply-To: <d9806b34-fc73-4878-997a-95c5e8ae4b29@sirena.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 5 Jun 2026 09:02:52 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjBZAzPdZgEeHAtSiwJpomt8ZZgKbixuiHfRm09a4=PtA@mail.gmail.com>
X-Gm-Features: AVVi8CdZ5f-_r2ry70kDuq_xsye2rLgypwsymONxqFNfT92KlgrDUIUXs4-jBmo
Message-ID: <CAHk-=wjBZAzPdZgEeHAtSiwJpomt8ZZgKbixuiHfRm09a4=PtA@mail.gmail.com>
Subject: Re: [PATCH 2/3] vmsplice: make vmsplice a trivial wrapper for preadv2/pwritev2
To: Mark Brown <broonie@kernel.org>
Cc: Askar Safin <safinaskar@gmail.com>, linux-fsdevel@vger.kernel.org, 
	Christian Brauner <brauner@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-api@vger.kernel.org, 
	netdev@vger.kernel.org, Matthew Wilcox <willy@infradead.org>, Jens Axboe <axboe@kernel.dk>, 
	Christoph Hellwig <hch@infradead.org>, David Howells <dhowells@redhat.com>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Pedro Falcato <pfalcato@suse.de>, Aiswharya.TCV@arm.com, ltp@lists.linux.it, 
	Miklos Szeredi <miklos@szeredi.hu>, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

On Fri, 5 Jun 2026 at 04:02, Mark Brown <broonie@kernel.org> wrote:
>
> FWIW this is triggering a failure in the LTP vmsplice01 test case (which
> sends with a vmsplice() and then tries to read that with a splice()) in
> -next:
>
> | tst_tmpdir.c:316: TINFO: Using /tmp/LTP_vmsp3vEmQ as tmpdir (tmpfs filesystem)
> | L4471tst_test.c:2047: TINFO: LTP version: 20260130
> | L4472tst_test.c:2050: TINFO: Tested kernel: 7.1.0-rc6-next-20260604 #1 SMP @1780589917 armv7l
> | L4473tst_kconfig.c:71: TINFO: Couldn't locate kernel config!
> | L4474tst_test.c:1875: TINFO: Overall timeout per run is 0h 00m 30s

I htink this is the same thing that Christian already noted (he said
"reported by David", but I don't know which David ;), where the
vmsplice() writev() emulation was done as a blocking write, even
though vmsplice only blocked at the beginning (ie waiting only for
_initial_ space to write, not then blocking afterwards).

                 Linus
