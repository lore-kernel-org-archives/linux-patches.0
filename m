Received: from mail-vk1-f173.google.com (mail-vk1-f173.google.com [209.85.221.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72DCA66B2D
	for <patches@lists.linux.dev>; Tue, 20 Feb 2024 11:48:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708429723; cv=none; b=L+4H5sQEV3A5QCK0/7CVCJkkZJfRa3t//5VKkgrduYmq5ZXWYgCbSF+E+m/u5yQGwoGi5q2Gx0/Dg6oqjP0iS9y+jnjyPsECqdz3zdcyZFVmzNkp+qjpowiXEXDgVXQGyxKEd9Zh1/Ves5Y6BOjGEuzdaO8aUdNY1w48ZLhTi0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708429723; c=relaxed/simple;
	bh=1paBppa9kXyF4t6jx2dx0KVwu75oULYWFXwh3w7uJhk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=agVRc5nBOmvd15vlAsw9bDD8GBbPqnTgHEJYtPvhFIfU1V/NvlfvYmqG/DxOmKxzkyqXsq4vx/UlqPGh5D5HuhlemAYSIKyIRhVfpDX4TXXnU/vM1Ao/V0LWkRlkX+ynoGMByATKv+kDL3XBeVPlKHfeLd2tBihWzqMl5AgicpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bgdev.pl; spf=none smtp.mailfrom=bgdev.pl; dkim=pass (2048-bit key) header.d=bgdev-pl.20230601.gappssmtp.com header.i=@bgdev-pl.20230601.gappssmtp.com header.b=V62S1Jz/; arc=none smtp.client-ip=209.85.221.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bgdev.pl
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bgdev.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bgdev-pl.20230601.gappssmtp.com header.i=@bgdev-pl.20230601.gappssmtp.com header.b="V62S1Jz/"
Received: by mail-vk1-f173.google.com with SMTP id 71dfb90a1353d-4c8979d847cso449942e0c.3
        for <patches@lists.linux.dev>; Tue, 20 Feb 2024 03:48:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20230601.gappssmtp.com; s=20230601; t=1708429720; x=1709034520; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1paBppa9kXyF4t6jx2dx0KVwu75oULYWFXwh3w7uJhk=;
        b=V62S1Jz/17tCFx8uetXi0oSDK+WXUoLB3Y0R2/lOMdq7S2MGsvA5bgokwJD4TJkVm0
         ZnpkMrziFyqWTkLhS6H6TK50/WEr8ELntiWVsBDpa7lNOwj4x1HB1y/ZGxipbgQin3rb
         DA0GY0gpFFVQu0NwEmh73VbxVLtDWE8TpeNX21b5cPtId5KiW8M5h2I13axsqPeiK+kG
         Lh6TqBrSWdDqIHQ6CBhXcWUQTBoFRd9GBJ/0uYymf2/DIrH+qXRdTqG2J38X2KGvRYvk
         hG8XlQ0XBxVDmxwixlb6ofRu2ObQpW/II+c2/KcTFgURD6Y2VjUy8lA01M39WPvNmHBr
         guBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708429720; x=1709034520;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1paBppa9kXyF4t6jx2dx0KVwu75oULYWFXwh3w7uJhk=;
        b=cVRhzOHkSUkbZiFRpnjbTMZbvvyMIksHTr3TO8zjVUmDiqhm+jRt8qoRp691y5qA5T
         b3RNOiUwIgfGX742supv87eG1Nj+qe+RcfnUWVDE/+7oOFm9MXrebkqvRMflFxce0tz3
         FFU3npuODCZMErv/5VyZTOEX8EvkUnspI3YtkcPwP1yDJ7SI7OlSXumlHxRxPtzQphV/
         QLx8bnBu1EVbNH1Nb/qSKKPBU6SJ8KiIm6lpSUxRhHFObvsdcbw4itI43LB0UJTSsJWi
         vI/jWBueU2MM8azxhzl1T5kJjiMXBge5V9vKAICwDj7BXO/3PW0FvZnueYfduVuUPxoy
         uYEA==
X-Forwarded-Encrypted: i=1; AJvYcCU2eIXwbh08MjtrR/8OEHGonMOaii0giIr/C78on82yNgc1WDFA4ABzix+n7XvOeMFk+jltVeJ9Y9UcDCfDhlFVGzwzagCILA==
X-Gm-Message-State: AOJu0YwlYxeGCh1+VyRHeS0Ei6qCwkv1VPGvEZZB9kx1vVxU9yi+5wV9
	0mQPlyE+kiqG0mRQNcMkCRoKl6IbBD15q6CbW/yavR68Kj1xGcNyAhROK5BHuKGsPnE8gSSGL8c
	7XXgFB8baZIJh3JTWUVUCQH22ZDvS+bjhk4mZtQ==
X-Google-Smtp-Source: AGHT+IGSt+7LYikhDFYx0cLtpCAuzEqPHpTuVYE+MOnTWdXCL9GlyvAMZDlwfESCgNKoolfZRtNBCXYNBKzP3Qf2Hvs=
X-Received: by 2002:a1f:c743:0:b0:4cd:510f:4137 with SMTP id
 x64-20020a1fc743000000b004cd510f4137mr3182381vkf.16.1708429720382; Tue, 20
 Feb 2024 03:48:40 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240220045230.2852640-1-swboyd@chromium.org>
In-Reply-To: <20240220045230.2852640-1-swboyd@chromium.org>
From: Bartosz Golaszewski <brgl@bgdev.pl>
Date: Tue, 20 Feb 2024 12:48:29 +0100
Message-ID: <CAMRc=MfqOxOO3DXhvQ4W2THGc0vzkTTGWeoyDrzG6JWZB3Ao7w@mail.gmail.com>
Subject: Re: [PATCH v2] gpio: Add ChromeOS EC GPIO driver
To: Stephen Boyd <swboyd@chromium.org>
Cc: Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev, devicetree@vger.kernel.org, 
	chrome-platform@lists.linux.dev, Douglas Anderson <dianders@chromium.org>, 
	Pin-yen Lin <treapking@chromium.org>, linux-gpio@vger.kernel.org, 
	Lee Jones <lee@kernel.org>, Benson Leung <bleung@chromium.org>, 
	Guenter Roeck <groeck@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 20, 2024 at 5:52=E2=80=AFAM Stephen Boyd <swboyd@chromium.org> =
wrote:
>
> The ChromeOS embedded controller (EC) supports setting the state of
> GPIOs when the system is unlocked, and getting the state of GPIOs in all
> cases. The GPIOs are on the EC itself, so the EC acts similar to a GPIO
> expander. Add a driver to get and set the GPIOs on the EC through the
> host command interface.
>
> Cc: Lee Jones <lee@kernel.org>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: Bartosz Golaszewski <brgl@bgdev.pl>
> Cc: Benson Leung <bleung@chromium.org>
> Cc: Guenter Roeck <groeck@chromium.org>
> Cc: <linux-gpio@vger.kernel.org>
> Cc: <chrome-platform@lists.linux.dev>
> Cc: Pin-yen Lin <treapking@chromium.org>
> Signed-off-by: Stephen Boyd <swboyd@chromium.org>
> ---
>

Applied, thanks!

Bart
