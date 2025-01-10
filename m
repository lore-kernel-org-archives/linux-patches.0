Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com [209.85.208.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74C9320E022
	for <patches@lists.linux.dev>; Fri, 10 Jan 2025 13:38:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736516330; cv=none; b=HJ/nCyHA6zr2qRi1Uefo3UuIlrl6PRNlYXaNpTKjlx8VSDv5R6bq0AHJ9+u+gVAUCrDKFzp+1kpi6CfxgbfdUYiJv3g0G3JjmVvxaRpPTPdzK3Wl6Ld7pn3H6klGjot05D0eQGyX0t5xTiHxJofhR28/jAKo8y0r5d1BguK3jpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736516330; c=relaxed/simple;
	bh=kN+WuQ1KirTcQd2+CHFeW1/BZLYiEtMO99Yf7IHOlOE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=m+By4q5EadmjsXpDoPlyAcKX2mJ5KDg3HDZEnJSvRXx8M09FtAHRfpLNTxx3+thi/3cD8fSp6gDMiVqQSUCnR2x1RGrhAe3dNUYWyk2Bqg+2pnd5QpuddvPH1OV1C2XEstePmhpg2upomuDAgxinNpjqjLWkACUKK5WQVGQE4oQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=cXUDpjWp; arc=none smtp.client-ip=209.85.208.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="cXUDpjWp"
Received: by mail-lj1-f175.google.com with SMTP id 38308e7fff4ca-3047818ac17so15266381fa.3
        for <patches@lists.linux.dev>; Fri, 10 Jan 2025 05:38:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1736516326; x=1737121126; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=S5cXYftIzA3LR59j0OW9GtyfPyeBfGN77X8ReQ1YGEo=;
        b=cXUDpjWpFD6Q/XUGaF+ZKt19aazQvXUaEoXtJhIoqZnlFtJrwxxYGnlokuviBu2wtR
         mHaS5+A4fnlLykkunU0aCe9GuhX2vuqIYprnEUNfIpOYwoHB1eRnZWx+iswIrgfotuEp
         WN6xaevLBXs8weqsCjUVtFpIByVshVR1v+Skc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736516326; x=1737121126;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=S5cXYftIzA3LR59j0OW9GtyfPyeBfGN77X8ReQ1YGEo=;
        b=BId4QcC52L3akIWu4GadNAI2T11GBss8KIqwwbLFfjgfK5Qb0sgEmiQZyYuDi2oW2Q
         2dxS6rNeJDH9FABKohbOaeH0XtLXd7cMaw+8EizoRpweT4Je4vaW09bQVCq6RPMjMopq
         xp+4Rh8TKyHKp16bQ1PhT9jIwKT1jPihUqE0cWOsYCdUUps6CrncQ1A6d2tCxfZ6urK8
         125yRsJikIefb0e5xhn4WDafeggC7WiX39la+IJc2qc6Rfo9bBNcPLA+w4b3Mz91/CUg
         xLNUMDW85E3FuEYr5H2/0/KI7OOpV20AGnszkgnUwFCCtVtknuOy+stktdRUo0IQjmye
         cHQw==
X-Forwarded-Encrypted: i=1; AJvYcCU4319Cy3DGU/7pF8qFDhH4YOwvarOAfAofNXpLizaPOtBVlkyezDlxHD4n9+Sb/M2Llrqyh+Og@lists.linux.dev
X-Gm-Message-State: AOJu0YzYhhLZdH9JfIF0JtETxr3HaMoJDJ11cDmFkoib97Y1mYLCASst
	5Un/tMPYf8xkQOIIrFZf4/WHd9e/mwI45OXHek1RqqkY1gVlBT43LMkDg1CctKYssbDf+o/09yE
	F2hN+VPYHludveqL7UTlOFj9uvphLTFk6p8w=
X-Gm-Gg: ASbGncu5DzZYfAjR1hm3lQhYZD58GvKgGXdkoeogZDf4jOLDmzwB9xArfrpIYaTLXZD
	KpEkoMuBXFhF0o2vdcZVsGqEV7qnSxaaNHb0lhJhXRVzl0DBuSX03fAPGCDN31iJqnQ==
X-Google-Smtp-Source: AGHT+IFF38QmzS4pEVqCimgSIZIkXRq8eu/nT2W6LM2igiQVDj3QPJ5vo24IGYrg5bdav5BTck58zcB/CBoEqnqUAFk=
X-Received: by 2002:a05:651c:4cb:b0:2fb:8c9a:fe3f with SMTP id
 38308e7fff4ca-305f459ab0amr35286421fa.22.1736516326542; Fri, 10 Jan 2025
 05:38:46 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250109220655.1677506-1-swboyd@chromium.org>
In-Reply-To: <20250109220655.1677506-1-swboyd@chromium.org>
From: =?UTF-8?Q?=C5=81ukasz_Bartosik?= <ukaszb@chromium.org>
Date: Fri, 10 Jan 2025 14:38:35 +0100
X-Gm-Features: AbW1kvbiLLF3eaxCs4xeh2uP83vaTT3dtcz4ROlR3rUjheFEVYbLypYFKgr5nMk
Message-ID: <CALwA+NbCOEupuhqPqxQRjM7MChyzaDTMUcXSg-xcGiAZbGeecg@mail.gmail.com>
Subject: Re: [PATCH 0/2] usb: typec: cros-ec-ucsi: A couple small cleanups
To: Stephen Boyd <swboyd@chromium.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev, Benson Leung <bleung@chromium.org>, 
	chrome-platform@lists.linux.dev, linux-usb@vger.kernel.org, 
	Pavan Holla <pholla@chromium.org>, Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 9, 2025 at 11:06=E2=80=AFPM Stephen Boyd <swboyd@chromium.org> =
wrote:
>
> A couple small cleanups to the cros-ec-ucsi driver that was recently
> introduced. Patches on top of next-20250109.
>
> Stephen Boyd (2):
>   usb: typec: cros-ec-ucsi: Add newlines to printk messages
>   usb: typec: cros-ec-ucsi: Mark cros_ucsi_ops static/const
>
>  drivers/usb/typec/ucsi/cros_ec_ucsi.c | 30 ++++++++++++---------------
>  1 file changed, 13 insertions(+), 17 deletions(-)
>

Thank you Stephen for the updates.

Regards,
=C5=81ukasz

>
> base-commit: 6ecd20965bdc21b265a0671ccf36d9ad8043f5ab
> --
> https://chromeos.dev
>
