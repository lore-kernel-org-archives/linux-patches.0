Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70C2B3233F4
	for <patches@lists.linux.dev>; Mon, 16 Feb 2026 15:19:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771255164; cv=none; b=uTXmKpWyoHKvrrh9X3zI929m7d7qwJLHlrtHSvJjLEXSkUzqKGzDvAjzxClY5kW1qAG68UhjqvefZ9VKqjR3yfOt24QoRjAgWzVch1yeVJroH2beInnGmA/EA1U4NVdj1zZzGQ8ZICj2MXspubxUwucVTeyd/iLT721EBXpbou8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771255164; c=relaxed/simple;
	bh=lUf+rD+zK85EaecIl+MRfVINlsxw2aj22zOZLlA0ty8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=a1HMlfVGKojWmSw0scisy7SB2OW5No6ysH3sOLwnEB9fCvOxPbaVvBP9xHRlow77EcnDNBdyy7QwnReGzp3bXhZRvFIMe522+vFt81wNANTbIdzRru33hCj70s4tt8EAqWAHdTKiZuz+c6f2UPRuMLoj3kbPZ/WOfIznVtG+Uko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-81df6a302b1so3205212b3a.2
        for <patches@lists.linux.dev>; Mon, 16 Feb 2026 07:19:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771255163; x=1771859963;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=v+0W63J01pKV+NBFDfR20YFl2vlCDVBGClMHBExbTTc=;
        b=B8QRMzXd3eJBCNUpiOqyPQUWWIhF5xWmSppwk7Tzs3YtuqYhEBfmxG8sVxpKLEoUmb
         ZTWdHXKbgYVTzB2RoZ9o8H1Pn+NPzpoFWklwTCSw7cXrnJML/BShKTVt9+4Z9hbHZ0JY
         Hh/+NybTbnwSYbEzWq9pUlg2pkA4Yma/hN9+k1hHuEiFGpBo6A1njJ5wBAJj7UWuo4I8
         /jCT29HBBuwN8P+ega6zUQzlsoH4rKJ+3xKkasHe1x+ny4PnlSzMpPmfkcKHV2hJSS9s
         a4XGQT1fNkd0O9Cy5w4n0xeY1wFghNP9IujsamuH5ow3fEbMunxaxyieqrLoJbYP6moS
         QCFg==
X-Gm-Message-State: AOJu0YwoAxp+C6NivN99CEVC5Z4BZgE1QEtSOWRx3rTuaGenLFMyuoqL
	6alhbJ9aQbqGrG1cDD4AkRQfVYDzHbfCo3oPNL55lqesCbMyv+0P7nKIBSKSvFPy
X-Gm-Gg: AZuq6aKV+Dw4l8/ea/x9UNsIo3mJsBVLO90Jl/lDgGqBKLGhp32CP+3id6P2+b9Z6or
	FxYHa/qkQIAj97qIt4Z1jczBLQx4OIupsmpY6r4CJypopR5/+t4a/agqFrOmvxa6yWGpLWdoTXR
	iDgAjAOgz4wPZqtijomQHJ4tdZO1kY/OkGJDVJWkIWVTvU8OIeQ+s+jqENQUyiACR2mrds3CIwa
	Rslw6ZmmBlCibnAP3wCBJDSwzkZrvD7gCHWxwhjqMZ62p0PLe2MXidACFzyVKYT7JQC3qLE4j/E
	D/VhME2IVVLqpWF3NRCTINFVEdFR+zE+P9Xu+ytiid9GMKHZm9N2ajx0limyh2cp+Xd3cN5jb2r
	96Izln+tSh0F24z+Kw8YnBsu1bAF2ydz91LeYaQAvgvY4MxRZs5z7+LYHv5X0YegUPdHZq+PxZS
	xKxhs/Nh5BmTufvUPlu0d0wdEBykYMyA3wvYZIqbSZf17GJDAg5EAMinj/3K++pX4g
X-Received: by 2002:a05:6102:26c8:b0:5f7:24db:fdb8 with SMTP id ada2fe7eead31-5fe2af25121mr2140392137.25.1771248507161;
        Mon, 16 Feb 2026 05:28:27 -0800 (PST)
Received: from mail-vk1-f170.google.com (mail-vk1-f170.google.com. [209.85.221.170])
        by smtp.gmail.com with ESMTPSA id a1e0cc1a2514c-94afd3a99cdsm7195805241.13.2026.02.16.05.28.25
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Feb 2026 05:28:26 -0800 (PST)
Received: by mail-vk1-f170.google.com with SMTP id 71dfb90a1353d-5673891928cso1264999e0c.0
        for <patches@lists.linux.dev>; Mon, 16 Feb 2026 05:28:25 -0800 (PST)
X-Received: by 2002:a05:6122:4f83:b0:567:4722:66a3 with SMTP id
 71dfb90a1353d-56889ba5013mr1919672e0c.8.1771248505602; Mon, 16 Feb 2026
 05:28:25 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260214005825.3665084-1-sashal@kernel.org> <CAMuHMdVeGv=f-Oo1=GQLghn_hwpe2YN5OS79fQsy2uccwyVUZg@mail.gmail.com>
 <aZMXwfvJjG0YkuF5@laps>
In-Reply-To: <aZMXwfvJjG0YkuF5@laps>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Mon, 16 Feb 2026 14:28:14 +0100
X-Gmail-Original-Message-ID: <CAMuHMdX1Mdqp7+Oz9dqe3b2VqMzpp5L7AvBJxRZuUjb0vY6gCw@mail.gmail.com>
X-Gm-Features: AaiRm51__ksjmZ0Ow9FHNfsDCOhP3Z--ENwDCnxogABgCRny5CijpedZP6Vlq9U
Message-ID: <CAMuHMdX1Mdqp7+Oz9dqe3b2VqMzpp5L7AvBJxRZuUjb0vY6gCw@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 6.19-5.10] parisc: Prevent interrupts during reboot
To: Sasha Levin <sashal@kernel.org>
Cc: patches@lists.linux.dev, stable@vger.kernel.org, 
	Helge Deller <deller@gmx.de>, guoren@kernel.org, neil.armstrong@linaro.org, 
	brauner@kernel.org, yelangyan@huaqin.corp-partner.google.com, 
	schuster.simon@siemens-energy.com, linux-csky@vger.kernel.org, 
	Parisc List <linux-parisc@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Hi Sasha,

On Mon, 16 Feb 2026 at 14:12, Sasha Levin <sashal@kernel.org> wrote:
> On Mon, Feb 16, 2026 at 11:21:25AM +0100, Geert Uytterhoeven wrote:
> >Cc linux-parisc
> >
> >How did you (or the LLM?) came up with that CC list?!?
>
> Interesting...
>
> $ ~/linux/scripts/get_maintainer.pl --pattern-depth=1 --no-rolestats --nor --nos 0001-parisc-Prevent-interrupts-during-reboot.patch
> Neil Armstrong <neil.armstrong@linaro.org>
> "Guo Ren (Alibaba Damo Academy)" <guoren@kernel.org>
> Christian Brauner <brauner@kernel.org>
> Geert Uytterhoeven <geert@linux-m68k.org>
> Andreas Larsson <andreas@gaisler.com>
> Helge Deller <deller@gmx.de>
> Langyan Ye <yelangyan@huaqin.corp-partner.google.com>
> Simon Schuster <schuster.simon@siemens-energy.com>

Still doesn't explain linux-csky?

> I think that I'll fix it by replacing --pattern-depth with --nogit --nogit-fallback:
>
> $ ~/linux/scripts/get_maintainer.pl --no-git --nogit-fallback --no-rolestats --nor --nos 0001-parisc-Prevent-interrupts-during-reboot.patch
> "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
> Helge Deller <deller@gmx.de>
> linux-parisc@vger.kernel.org
> linux-kernel@vger.kernel.org

Much better!

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
