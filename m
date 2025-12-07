Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81D1F25783A
	for <patches@lists.linux.dev>; Sun,  7 Dec 2025 07:12:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765091546; cv=none; b=RIhoi/cMTj7bdNcxcZrfBfA4Ac4D3vvxSHGns7Y7zIj5SvuGsyYOegzpn79Bku36lVFz2M3eKQ1s73nba2nR/WQmiYC5CDysSUel9W1RtrTXQbgKKasXjpxghznbbzfAE3FujSf3sNxGqa1Q8j+c5IIGscpF5D0ZrOiv8poC+GU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765091546; c=relaxed/simple;
	bh=K6FeuAm/mO+v9ibQ+qp/z1st3bgFBU83eGp0V676s0Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TiQ3h9G0BXfKetHzRsISrlbt8sOINE62JG55qNq/AfNhAQtw0ntauQzbQp21yB8iJp/qpVVa52LYzhxDhmbTWZcU22TgguEOv35aR5E1e8Ph4FYNfev7P3yH3+vvH+38rORxsNSTB+Iy+pl8X1Y3fIhopCiRo+v1uOg7zZQ7GXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ex4NWSYE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ex4NWSYE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A7FFC19424
	for <patches@lists.linux.dev>; Sun,  7 Dec 2025 07:12:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765091546;
	bh=K6FeuAm/mO+v9ibQ+qp/z1st3bgFBU83eGp0V676s0Y=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=ex4NWSYEnHhMsq6r8TidPeVwAPE0XKrkaYSrJGtp/tZZJDKgcEPzghYkczDR3BR/x
	 KnqXa7f1mAHiGZocfq7YQAGhzkjYTWi8wxh7O0Rq+jTaVhqSvdKNoHy6+UFa209OAs
	 7PKMhIYCF7uEw8Zh6gpbpmp6qFbvBIm7USXBpFWhH5ipMJjGisTKasLWZRyC3VAETJ
	 pBIzeMzVP2+62Kseo6/LICseqcAuuGUvs16QglOY++zqSjgWkPOGqgj/bWIm90duSP
	 gD5kys07tqIy9qNoCXLiZe/2ajE2kGx22RFH463FxwpCCAwPrpr2bMPXMvlapshjaI
	 ZHUSGNtpmScSA==
Received: by mail-lj1-f171.google.com with SMTP id 38308e7fff4ca-37b9728a353so47700171fa.0
        for <patches@lists.linux.dev>; Sat, 06 Dec 2025 23:12:26 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXFRt/U6xPqT19rbf9k3wer/kPYfZX4Q1BY622vYONNfkrUC5mp2oiqutheX+3VvehtD5VRXrYN@lists.linux.dev
X-Gm-Message-State: AOJu0Yzq9AawDbEU+Edv6xC/7Pw3fHMz9QhcCt8zuZE2L61uHOo+SFpa
	YtqP4sswI527GvvNktGCn3+he9jb6yJPt8yxue37GsKUa5SJ+wGIelyDYnQU1jxW9A/tvy/gctQ
	CDMfDa46v9oYmXTYSb4wXgHWMHSoW0gCO/sc0rVgBfA==
X-Google-Smtp-Source: AGHT+IHUttufN04TX+XB2v0nOmX+t22Dxwuaj+k3gvEz9+koC25RuVv5nOSo4819NIVrwVOSN2atPSMlelCVlQoOaAY=
X-Received: by 2002:a05:6512:3e0a:b0:595:9152:b90e with SMTP id
 2adb3069b0e04-598853ddf93mr1339182e87.44.1765091544827; Sat, 06 Dec 2025
 23:12:24 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251206180414.3183334-1-safinaskar@gmail.com>
 <20251206180414.3183334-2-safinaskar@gmail.com> <aTSlgoK0PcE937l1@smile.fi.intel.com>
In-Reply-To: <aTSlgoK0PcE937l1@smile.fi.intel.com>
From: Bartosz Golaszewski <brgl@kernel.org>
Date: Sun, 7 Dec 2025 08:12:13 +0100
X-Gmail-Original-Message-ID: <CAMRc=Mca8oi7JpEiNajP+CbHhBhSb9fS4NqFz-aojcX1qmEzcA@mail.gmail.com>
X-Gm-Features: AQt7F2qf48qgC5abnj9AO2dJG-JdHRcmEsnizopJoLSVxgbYQ23fiVmZ1lHXbrI
Message-ID: <CAMRc=Mca8oi7JpEiNajP+CbHhBhSb9fS4NqFz-aojcX1qmEzcA@mail.gmail.com>
Subject: Re: [PATCH v2 1/1] gpiolib: acpi: Add quirk for Dell Precision 7780
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Askar Safin <safinaskar@gmail.com>, Mika Westerberg <westeri@kernel.org>, 
	Linus Walleij <linus.walleij@linaro.org>, linux-gpio@vger.kernel.org, 
	linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	regressions@lists.linux.dev, Dell.Client.Kernel@dell.com, 
	Mario Limonciello <superm1@kernel.org>, patches@lists.linux.dev, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Dec 6, 2025 at 10:52=E2=80=AFPM Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
>
> On Sat, Dec 06, 2025 at 06:04:13PM +0000, Askar Safin wrote:
> > Dell Precision 7780 often wakes up on its own from suspend. Sometimes
> > wake up happens immediately (i. e. within 7 seconds), sometimes it happ=
ens
> > after, say, 30 minutes.
>
> Bart, up to you, if you want to take this. But I can do with a usual rout=
e via
> my tree.
>

I already have a bunch of fixes queued for next week so I guess it'll
be less hassle and the fastest option if I take it.

Bartosz
