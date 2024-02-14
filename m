Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1658F800
	for <patches@lists.linux.dev>; Wed, 14 Feb 2024 00:03:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707869014; cv=none; b=Z519gW4HYDjuD2QThH4MMMt0Ad7KQyjamKn0Me/ZOAxyooLrki6w1lbgdikxD5dFMINyxekROSQAR9Cxhutx4bJNO05Ouc/nP9HCd92FzlDVNZ8fm0qtIQV34DwEfKHr0MM9A0ukdAfnos3R9tDe5OTkByNsucfxIFTvj2hg270=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707869014; c=relaxed/simple;
	bh=LUHwCmgFvsLI2w7Qfq1pAeSWXQrKo7dao4Gqpb0bey4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=J6LdSkKqXqTKfwkwLYVeKXTuwbbbAXd9BqXbSpx4Kx89/sy7pWTs5VzZHi4VqTLLhHAZsJkccAljHADiYq09JEmxGztW2HSgzHvSpdAOBBWnCAlgCOzsgQ87bRJGyv1JFw8uTK5At234Wu0/vTht5quwXGweALnqnOu/csZzods=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=X7uM66UW; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="X7uM66UW"
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-5620f15c3e5so1065532a12.2
        for <patches@lists.linux.dev>; Tue, 13 Feb 2024 16:03:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1707869009; x=1708473809; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LUHwCmgFvsLI2w7Qfq1pAeSWXQrKo7dao4Gqpb0bey4=;
        b=X7uM66UWgHwZdVe7gJawEVdd+NgemqdBQMH6G8rSUrJJsOvuEPeVTgURaqIfKbVmcA
         IzpyMLwW8cpe/ypwagDPcWzJWrC0d+CVyNOciHEVUCAOiftHVzZrDwvfh2sEZRxhHxWb
         hBLWLMvVlvZ04rLDRP3WBotYf4zM8U82ZMXwc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707869009; x=1708473809;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LUHwCmgFvsLI2w7Qfq1pAeSWXQrKo7dao4Gqpb0bey4=;
        b=pqWWNejJs0vdEqe8ZovHKbIxRVUa5ttWQyf4/6hzK9XogG8hy2vdh8IXh3f+sOO3Sv
         q4uoIPKcKvsEMESfcEFqY73W1ynpn516J3n30cr+TQmxEfuAIpCxXeoqnwWQ0aE8TAbP
         UOKdCNf3fTEVu3SgyWdBvfwWWhXy2xGU1nJDnjSxQQIVev8gGQrHopo44pwCrOuQ4G20
         2PTtT7YeSwnIqMQIisX+jJZYurrH4ZsqDHIfxLpvENn9Bu41/aE8+2czVVGUbbmMD8Ds
         bYZQZkrdEgdUStP0TOAFnrPiHSkvKIKFFfXC4SFnRcX8uY7xTWArFOADEHMl6RSWAUCl
         hAKQ==
X-Forwarded-Encrypted: i=1; AJvYcCWdhX88jBKCYke8s63yH4VCcv1wXcD7JQd5j4APgjvB8ge0rXliEYfprjnUWOW8FOlNTCORogw11rNgleZ7N46y9J/yK3BtCQ==
X-Gm-Message-State: AOJu0YyjPCXTreyUo1T219jHdvvWy9hc9WKnxkzXqurw9u5kqaEpSNd+
	EJhGg69qcuck/fTe4zpZ/7IgCfCNkXZxhf6Qdj/hjAfAsM9sJ8pwQmlfug9k8YZn9QgO7dS0tTd
	v6A6s
X-Google-Smtp-Source: AGHT+IHG1nEegKiuqkGizzh2ojboOEHzMdjSyr9q5vzgyaJud0qBZIqgzw6PdMAexYvyXQS9fIkFwQ==
X-Received: by 2002:a05:6402:120c:b0:562:9e3:520b with SMTP id c12-20020a056402120c00b0056209e3520bmr754206edw.18.1707869009106;
        Tue, 13 Feb 2024 16:03:29 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWOpvTtrIOfKeqHFCtgoWCqXsrFmgpg397ph+iOkPBrBB7RST2sHxVnx+/RT4k9llKLRDNh2/7rPykBOEgUXDidN9YRrDpo8Q==
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com. [209.85.128.52])
        by smtp.gmail.com with ESMTPSA id et10-20020a056402378a00b005624d90a07fsm166780edb.15.2024.02.13.16.03.27
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Feb 2024 16:03:28 -0800 (PST)
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-410c9f17c9eso100825e9.0
        for <patches@lists.linux.dev>; Tue, 13 Feb 2024 16:03:27 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXFs5QxmF+rkEiiMQIVG6vkG5IhMO9aVQRFyiOoWHBGo7/RYwNU0w0ZGBzsGcUx7L6fGI6kUNI2GmD97gswhoigD+uesDDnuw==
X-Received: by 2002:a05:600c:519b:b0:411:e5c1:9b2a with SMTP id
 fa27-20020a05600c519b00b00411e5c19b2amr21434wmb.2.1707869006878; Tue, 13 Feb
 2024 16:03:26 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240210070934.2549994-1-swboyd@chromium.org> <20240210070934.2549994-5-swboyd@chromium.org>
In-Reply-To: <20240210070934.2549994-5-swboyd@chromium.org>
From: Doug Anderson <dianders@chromium.org>
Date: Tue, 13 Feb 2024 16:03:11 -0800
X-Gmail-Original-Message-ID: <CAD=FV=UuunNnXJ0kAzRPVy0DX7Wv2eQOa-fMJQ-aKtaGnyQaQA@mail.gmail.com>
Message-ID: <CAD=FV=UuunNnXJ0kAzRPVy0DX7Wv2eQOa-fMJQ-aKtaGnyQaQA@mail.gmail.com>
Subject: Re: [PATCH 04/22] usb: core: Set connect_type of ports based on DT node
To: Stephen Boyd <swboyd@chromium.org>
Cc: chrome-platform@lists.linux.dev, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
	Pin-yen Lin <treapking@chromium.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Matthias Kaehlcke <mka@chromium.org>, linux-usb@vger.kernel.org, 
	maciek swiech <drmasquatch@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Feb 9, 2024 at 11:09=E2=80=AFPM Stephen Boyd <swboyd@chromium.org> =
wrote:
>
> When a USB hub is described in DT, such as any device that matches the
> onboard-hub driver, the connect_type is set to "unknown" or
> USB_PORT_CONNECT_TYPE_UNKNOWN. This makes any device plugged into that
> USB port report their 'removable' device attribute as "unknown". Improve
> the connect_type attribute for ports, and in turn the removable
> attribute for USB devices, by looking for child devices with a reg
> property or an OF graph when the device is described in DT.
>
> If the graph exists, endpoints that are connected to a remote node must
> be something like a usb-{a,b,c}-connector compatible node, or an
> intermediate node like a redriver, and not a hardwired USB device on the
> board. Set the connect_type to USB_PORT_CONNECT_TYPE_HOT_PLUG in this
> case because the device is going to be plugged in. Set the connect_type
> to USB_PORT_CONNECT_TYPE_HARD_WIRED if there's a child node for the port
> like 'device@2' for port2. Set the connect_type to USB_PORT_NOT_USED if
> there isn't an endpoint or child node corresponding to the port number.

The above sounds good, but then I look at patch #18 ("dt-bindings:
chrome: Add binding for ChromeOS Pogo pin connector") and patch #22
("arm64: dts: qcom: sc7180-trogdor: Wire up USB and DP to
usb-c-connectors") and it makes my Spidey Sense tingle.

Specifically, I _think_ if a port is "hard wired" that can sometimes
tell the system that the port is a bit more trusted. In the case of
the "pogo" pins on detachables, though, I don't _think_ there's
anything that prevents someone from making a "pogo to USB A port"
adapter and then you could plug anything you wanted into the pogo
port. If there's any extra trust given to these "internal" ports a
nefarious attacker could presumably abuse that trust for the pogo
pins.

I have no idea if this is a realistic concern or not. I'm about 95%
sure that hardwired "PCIe" ports get extra trust and get "deferred
IOMMU flush" enabled and, in the case of PCIe, that actually is a real
security hole. For USB, though, I think the system is more isolated by
the USB host controller so I'm not sure that there is any extra trust
given to "hard wired" ports. ...so maybe the answer here is to just
ignore my rambling. ...or maybe the answer here is that everything is
fine but patches #18 and #22 should be modified not to cause the pogo
pins to be considered as "hard wired" since they really aren't...


-Doug
