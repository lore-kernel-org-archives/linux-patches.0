Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com [209.85.208.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BC3E14292
	for <patches@lists.linux.dev>; Sun, 16 Jun 2024 22:37:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718577477; cv=none; b=G5PyJKFB8ck+JHPt+sV6ctpdaBoremiN9IpyRxxlPbsPBuaIOI+/EGnGf9CGgtmGStDpE5Bgn0tRvilk879O8steOzHKhhQkSCbNJQzDDqx27pKyv1K9YUH+dw9j+NI/JUt3H7w1Mm92xU1yp3i5hO4S84BmuRgVpAqsG2Zy2oY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718577477; c=relaxed/simple;
	bh=SQym0ka5edFkGH9GW0Q/RKr7Gzcy3p89cc6csKQ9GtI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NSet3iPE3Js4j15GtATgeM9dEb/7pUcRpSQidzrNfLxO8geKVVk0EOwRGhP3I6c/r5xugo8j5IFsG9W45YTzuPne+F3/1kHR2AFLFmQJLdHYQkFzDG9meRX4HIv/OaAKm90UwdA9+hQZCbdXWXwQrDhfqEzkTLOaPhNakZYDl8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=qIHmcCLH; arc=none smtp.client-ip=209.85.208.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="qIHmcCLH"
Received: by mail-lj1-f172.google.com with SMTP id 38308e7fff4ca-2eaae2a6dc1so69970961fa.0
        for <patches@lists.linux.dev>; Sun, 16 Jun 2024 15:37:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1718577473; x=1719182273; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GJmULIbWb285fO6OZ+xt9ZdoZq+h0NtQ/msZb57jBI0=;
        b=qIHmcCLHEra6IbGyCR7rErB4ATQfebGNAtUQ7U3ODENaWQRW7/pKMmP5DDpexFWiAI
         NcPjAosZDbs7HrW8BPLBFKZFv7ubneBCuZWSMyT1N60bRobZIPTtAHFWKoAHPBSVF/lx
         I45xN28wayD+nQCIvFf5ebpS6StffyWqb5n2/cGsqIXq7B6kWuXddIp6LZq+92vyE8BE
         YxJcqq11cyRCvjz8scGctsnBTcpOcd1CwUlOWpOY9bxzGnUKFLlwBuMpQKWqwlsfBWCY
         tuvRFufy4d38jMJdbeRaeM6BhA0zY7F3veYk51LZGVXukgTYuDXVHZzqz/OblekYsojx
         a0/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718577473; x=1719182273;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GJmULIbWb285fO6OZ+xt9ZdoZq+h0NtQ/msZb57jBI0=;
        b=groXu7A3NDHEkYL49/xQMfOXXy7atbhE73vxeyDAee2NUWh0WGzMZnXpoSvJcz1yUr
         L24qV4H2n5vE+xj7nC+Ay7sYwijSL6wng8qIeMpRm0EwMGChtVzLAWJI1p4bKdbSzgY4
         XKZPunFnfsI8fqIU0ShA9/+Kek/XkL3NT7+S1FW1sMWxxdeiQzGpWAu0iYfSxIzsoNLr
         V0uIhElfGl2tRzqm7nK0LllDyqgnttLaykMGnM+x6/M/l3KDhpBlRrRRsyMBYtH7ewvt
         Viys6FbleruPRBY4fea+i9ybpBgCH0nuoB5HEPJpG9hfaWyydBSsbfJvaiI56e+L0FE+
         dj7Q==
X-Forwarded-Encrypted: i=1; AJvYcCWV1b42RzkjJiHl2miM0d6+v68QSiTz7eOIrYOMdgDb1B7okAlQfbDW4o0ys6TLbtMeEwTZcHrEK3Ybgj7Ez7P7HaeN5d4Evw==
X-Gm-Message-State: AOJu0Yxw9wr1+0ggcwdckQmyOUSqKrj1vOxXUzmefk4bM1WtCHTx2c1u
	FNd5KOL/ROUCfwJrKba+Sljap77odxOq2tBtn5GkSvrP1IJWOkYA8XEd1F+WKSVQOikhTGqqHsf
	uF/RHP6/rogJUp1X6zYdE3OEVJtPNX17PlRFT1w==
X-Google-Smtp-Source: AGHT+IEBmjTYQaGafJ86WIDi2Cr5cBGdo70co+/vV8OZw5CTIbsccdUAgyRfLgyO7Zi+9wG5Gih6EPt0y2U5e8e7ak0=
X-Received: by 2002:a05:6512:34d9:b0:52c:993d:b462 with SMTP id
 2adb3069b0e04-52ca6e6e25amr5706964e87.29.1718577472498; Sun, 16 Jun 2024
 15:37:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240611-pinctrl-keembay-fix-func-conversion-v1-1-3197f2ded3f7@kernel.org>
In-Reply-To: <20240611-pinctrl-keembay-fix-func-conversion-v1-1-3197f2ded3f7@kernel.org>
From: Linus Walleij <linus.walleij@linaro.org>
Date: Mon, 17 Jun 2024 00:37:41 +0200
Message-ID: <CACRpkdbcCLSUjUaYoUi+mVMBOrcELRe_XExs-zB9417ttPaHVQ@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: keembay: Fix func conversion in keembay_build_functions()
To: Nathan Chancellor <nathan@kernel.org>
Cc: Lakshmi Sowjanya D <lakshmi.sowjanya.d@intel.com>, 
	Andy Shevchenko <andy.shevchenko@gmail.com>, linux-gpio@vger.kernel.org, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 11, 2024 at 8:13=E2=80=AFPM Nathan Chancellor <nathan@kernel.or=
g> wrote:

> A recent refactoring to use the func member in struct function_desc
> missed converting one uses of name in keembay_build_functions(),
> resulting in a build failure:
>
>   drivers/pinctrl/pinctrl-keembay.c: In function 'keembay_build_functions=
':
>   drivers/pinctrl/pinctrl-keembay.c:1630:35: error: 'struct function_desc=
' has no member named 'name'
>    1630 |                         if (!fdesc->name) {
>         |                                   ^~
>
> Perform the same conversion to resolve the build error.
>
> Fixes: 73ee52205e5a ("pinctrl: keembay: Convert to use func member")
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>

I had cooked my own version of this fix but this came first so I applied th=
is
instead.

Yours,
Linus Walleij
