Received: from mail-lj1-f170.google.com (mail-lj1-f170.google.com [209.85.208.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 705A220E320
	for <patches@lists.linux.dev>; Fri, 10 Jan 2025 13:47:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736516876; cv=none; b=QCOKCR8es2wviXILtN+4G6gF+VmrfjqVKyjSevaw5T8lpFFIfcQRmDGcLOp0SDrl0khxqfmdY5KYpWkIv5UYbCqPnMvZj3WP5ErRJGKS4lib0CwRBXnwWxEFMq7E1o0m0Qpxw8STKUqa1WlVi8elkG879ozDSTH0zNfr7/Dz1GU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736516876; c=relaxed/simple;
	bh=aDTw+7KqPH57qr+Z1WA9s91f21YqkgHFyt/CjUdJlX4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mOe7NxzvmKXQGV2bxM5rD5sjfzCJkA8tGBaw5Czx4hZG1yTk441asSXVHvOlyAotsSCQ9zdKY2ZTCSGJLyHoeo9XdBZ5lLyPBh4BpY3ugwGSbvP8msUHbWQmVLV2Uzi36k5i9ggUejH7gmeT+6L0n4zVAcJtCSsaUzaRU9DaM9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=DXGkOof3; arc=none smtp.client-ip=209.85.208.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="DXGkOof3"
Received: by mail-lj1-f170.google.com with SMTP id 38308e7fff4ca-304d9a1f198so16346381fa.0
        for <patches@lists.linux.dev>; Fri, 10 Jan 2025 05:47:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1736516871; x=1737121671; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gr2wfavfSfNnPmYAAFKmMn2ii0c2pxJsS7pMf0bJLM4=;
        b=DXGkOof3aOxzd9D7Cdp0fO/FAjv+5hLH5vGWa8Op/CKL0z5koCJ100HJcP5cSt8DCc
         8LFpygDBzcH6nkqpl1uRqIVwfWvRylhK+lvdG6n1Uy3yj440p9gVTrSnug1MSYW6LD47
         AK5SJbOJrhrJ23O6bmAmGPk18fJL3bITcdNWc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736516871; x=1737121671;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gr2wfavfSfNnPmYAAFKmMn2ii0c2pxJsS7pMf0bJLM4=;
        b=NH4YEDyWE3yc4cARvwqk7O7o8WqoyLgbIYgVJ9uskFQQgWk3ICZ+6N2xY+5ZA7OtMs
         SdmWfBsuFMd+xY0i1gYsFV3LxJhZ2VKl9TSPOewJ8nvdf3HEhZdy3k/bkiHx5lUDQa2v
         BGJMmWLfdnx5kwaXRtbbgRiYyujk5auW94YQ+jBlojkUXxuCW74rJrtV9OCbM8dhhWIu
         6HE7qllaSqPWWlMEHhFZBm0x8SAtd8nrw4n7Tc61ek4dGoogyGJRHgBR9zuywT8UqLc7
         9u9oJdDsXcRP1w1Vq6piq3370MTyU5nN5kF2Qo/BHXHoIMdskGyzwVCnCl1xAz5XR8rz
         pASg==
X-Forwarded-Encrypted: i=1; AJvYcCWsncBu02HJUY5grSq2W3HoNTfpHSrQIAm2P4TgQQeIeUwffwCx6wCafu2hkPbFBmfrwmKQozDM@lists.linux.dev
X-Gm-Message-State: AOJu0YyWxE1vBExcVczKAJQnp4nItLqhX1ewIrReaHCQxvnWRQxQT8xF
	rXytuk+uV4abDZXwF5uRS/edN40KrOn/uBM5QX+P2yoWxXehIwvt4ndEU54XmGt7FRNARrtNUDX
	OQpLU8IUxOOu1a4RlD+JIgxqfSdS0MNYHrBc=
X-Gm-Gg: ASbGncvf2PjW2rszoGwgu/7ZUUe+1+0w+ibjMJoCMn1yBs4+Ai9wGp3GzyNveqc4LK1
	a46w7Wi8TagGpeL2GopXmVI0pw5SSZ8oUnYjKE4yQiw5UKM9TCB/jOXRDvpWfvBF7Ug==
X-Google-Smtp-Source: AGHT+IF3H5SI1TKiLAmal+ispYzXyWV8+NPtp22j5q1S/ciVF9AwBNTgh6t4GFtuhi8cw28f+2A0Awxcjjra529Z1e8=
X-Received: by 2002:a2e:a98f:0:b0:304:4cac:d8ef with SMTP id
 38308e7fff4ca-305f455e963mr33126731fa.7.1736516871581; Fri, 10 Jan 2025
 05:47:51 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250109220655.1677506-1-swboyd@chromium.org> <20250109220655.1677506-3-swboyd@chromium.org>
In-Reply-To: <20250109220655.1677506-3-swboyd@chromium.org>
From: =?UTF-8?Q?=C5=81ukasz_Bartosik?= <ukaszb@chromium.org>
Date: Fri, 10 Jan 2025 14:47:39 +0100
X-Gm-Features: AbW1kvbx6mEflbFtCpHpxeCzWFCNH6Kt4EYxLetWYdg4-wwJH_evg1qw966XxCg
Message-ID: <CALwA+NYD_0JqAByT73j2_nW3jJfb1RdBdSnQ-xAQV8HYf=LGSg@mail.gmail.com>
Subject: Re: [PATCH 2/2] usb: typec: cros-ec-ucsi: Mark cros_ucsi_ops static/const
To: Stephen Boyd <swboyd@chromium.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev, Benson Leung <bleung@chromium.org>, 
	chrome-platform@lists.linux.dev, linux-usb@vger.kernel.org, 
	Pavan Holla <pholla@chromium.org>, Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 9, 2025 at 11:07=E2=80=AFPM Stephen Boyd <swboyd@chromium.org> =
wrote:
>
> This structure isn't used outside this file and can be marked const so
> that it gets moved to read-only memory.
>
> Cc: Pavan Holla <pholla@chromium.org>
> Cc: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
> Cc: =C5=81ukasz Bartosik <ukaszb@chromium.org>
> Signed-off-by: Stephen Boyd <swboyd@chromium.org>

Reviewed-by: =C5=81ukasz Bartosik <ukaszb@chromium.org>

> ---
>  drivers/usb/typec/ucsi/cros_ec_ucsi.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/usb/typec/ucsi/cros_ec_ucsi.c b/drivers/usb/typec/uc=
si/cros_ec_ucsi.c
> index 75646a8d55be..c605c8616726 100644
> --- a/drivers/usb/typec/ucsi/cros_ec_ucsi.c
> +++ b/drivers/usb/typec/ucsi/cros_ec_ucsi.c
> @@ -133,7 +133,7 @@ static int cros_ucsi_sync_control(struct ucsi *ucsi, =
u64 cmd)
>         return ret;
>  }
>
> -struct ucsi_operations cros_ucsi_ops =3D {
> +static const struct ucsi_operations cros_ucsi_ops =3D {
>         .read_version =3D cros_ucsi_read_version,
>         .read_cci =3D cros_ucsi_read_cci,
>         .read_message_in =3D cros_ucsi_read_message_in,
> --
> https://chromeos.dev
>
