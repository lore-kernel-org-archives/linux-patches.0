Received: from mail-yw1-f178.google.com (mail-yw1-f178.google.com [209.85.128.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 902D25C908
	for <patches@lists.linux.dev>; Tue, 23 Jan 2024 09:57:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706003825; cv=none; b=rVs+qL+eSrS72sbmLnlcSD4mSUe0V2YsQvhNveyrhwqbyiGdDfdr/NnvHrp08hp/z0qu/n1h9TUniwAD740lCtgrEyHwAvXvaLv1rb5+F/8NgvWGaXtgNreyLzUS6+zNHMOXC0l14gG60QeLDdapJrqByqYgmtOa3LWuO8pOuAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706003825; c=relaxed/simple;
	bh=2a4zx/E4HXHMQCrFRTMcQxxbfLKxlGBDrsmWNtMNU34=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=X0rb1fDoKne9MJ3J/mbJ7HoXjp7dahG0Pc0JU6n3F2psmPXYMepfqCY9Q3xgNaSaJOFH/9f3l+OWjFdvu6HU+6Kp1jJaGJzI6V7RmqUx6eiy/QUAl9kWBdRJXmevD4sbNbJUZqiqcRn8oM2EJdrrarJ7Li75z24OsWnMEYao+PI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=ry3/h6ZE; arc=none smtp.client-ip=209.85.128.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ry3/h6ZE"
Received: by mail-yw1-f178.google.com with SMTP id 00721157ae682-6002317a427so11086317b3.2
        for <patches@lists.linux.dev>; Tue, 23 Jan 2024 01:57:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1706003821; x=1706608621; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Dx8VNoB5xNb50VoOTbN0kgG1Wr33n3CjaRFmMnrWwK8=;
        b=ry3/h6ZE7QUjhLDW1x3+kz9ImGCP0A+Hcb8A0eenEMbt7jjPoF4yjeFSAjpddpwMmX
         DdOda6ljEV5/DJoagTrIiL8as+sxaJhqUKFnzZPJiGpRxfMWfMc0hkwSQzrJ/39tEKD+
         4BKfWsBTW9z6XC+GWt/W7dQhxgnuA9jDa6uqybyBCaSV4Cz46WUWZ8oa+PqRIB/NMXC6
         IBDWr395aJUWrCW0kxfOe+0fFLd3iUAp8crJij/tfdr0FXot+7Hkf6lNte+R3HAYVI8t
         QczFS7khCuakW09EjGKijvU4OCmkcNmsSxpgC2tpUzVJcdnWtW703IQY66bWaVBG/F5b
         EzjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706003821; x=1706608621;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Dx8VNoB5xNb50VoOTbN0kgG1Wr33n3CjaRFmMnrWwK8=;
        b=W2d0GpUtAsZWjW99YqnLHfnvS/JgSGrHNVo3GJy5d0n6ukEfTBs9ePHFW9/ZTltEAQ
         ouH9NwLajo4XnrJSe4ojhomU/XVK9iauon/sehQX2OIOFSAhC3lfAQPfEEWl94QxjRkH
         HYjWbtGkr8HSQePAOdAAaRKCahdv/3SOEwwTn+E0l75APd6QMcs06ZY/dWwIIp/PchlV
         1GuK0IFVjML2GdSysJNFRVrOdyYtV6rhdptApGx4BN0DZyBybNVbiPlZnPkw+30+uOya
         Qcy/qL9xR8JFRFOpgDkjUPjegVy02YUO0AP/DijtKOK1i5yT0rvvf/YYRHSYfJehuSv9
         6W9w==
X-Gm-Message-State: AOJu0YwRRQhakjkjRR97LiYpGDzraXSVmmQVYEKYFiynCgaPR/uE3xi7
	gwfQE9LQeNqw3TAF86dn3NhC3yoewwAhRXhjJRHKyOPG8DJNSvBroPOqOTabPS6lvuMRaX1wfv2
	CbtVBDw7HT7kpOnW8YDY+BX4Un3+oyLbfjg//Ag==
X-Google-Smtp-Source: AGHT+IE+Y1hSMZGHVELT5QGI6zTMJ5w8f3ijh0TFj72VdyzH5fdSw5hkSKV2Fl3eI9tm1tzHr+S15Vy8GashmMFemPE=
X-Received: by 2002:a81:4809:0:b0:5ff:a40c:5fc1 with SMTP id
 v9-20020a814809000000b005ffa40c5fc1mr4105759ywa.54.1706003821481; Tue, 23 Jan
 2024 01:57:01 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240122235812.238724226@linuxfoundation.org> <20240122235822.085816226@linuxfoundation.org>
In-Reply-To: <20240122235822.085816226@linuxfoundation.org>
From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Date: Tue, 23 Jan 2024 10:56:50 +0100
Message-ID: <CACMJSevr71oSy-CjUKkyXa4ur=mQL3R+PBnJUWQB-Pw3yp+kgA@mail.gmail.com>
Subject: Re: [PATCH 6.6 328/583] gpiolib: provide gpio_device_find()
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	Linus Walleij <linus.walleij@linaro.org>, Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Tue, 23 Jan 2024 at 03:03, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> 6.6-stable review patch.  If anyone has any objections, please let me know.
>
> ------------------
>
> From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
>
> [ Upstream commit cfe102f63308c8c8e01199a682868a64b83f653e ]
>
> gpiochip_find() is wrong and its kernel doc is misleading as the
> function doesn't return a reference to the gpio_chip but just a raw
> pointer. The chip itself is not guaranteed to stay alive, in fact it can
> be deleted at any point. Also: other than GPIO drivers themselves,
> nobody else has any business accessing gpio_chip structs.
>
> Provide a new gpio_device_find() function that returns a real reference
> to the opaque gpio_device structure that is guaranteed to stay alive for
> as long as there are active users of it.
>
> Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
> Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
> Stable-dep-of: 48e1b4d369cf ("gpiolib: remove the GPIO device from the list when it's unregistered")
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---

Greg,

I think there's something not quite right with the system for picking
up patches into stable lately. This is the third email where I'm
stopping Sasha or you from picking up changes that are clearly new
features and not fixes suitable for backporting.

Providing a new, improved function to replace an old interface should
not be considered for stable branches IMO. Please drop it.

Bartosz
