Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C09AD10E4
	for <patches@lists.linux.dev>; Thu, 15 Feb 2024 00:40:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707957608; cv=none; b=BCN+mdF5VBUZ9ZW8qp1Cz10YbaBgHm//6Ws6Fpl8SlvPxAJdS35gQTagocnXzdUt46ItPW5gysoS46F5nMuGeDW+P12ZynkNovgA/ATWJYLrePEnJ8FpzKrih3L03v+KGDEEvUvb6zNfZ01UrMphwcEoogNs7oV9/9UJYQxgSM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707957608; c=relaxed/simple;
	bh=kYh5k8MyiysiewusV+Glc1Kt41gt5l9m2Lg4dhbhPyw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PU3pffPtAcrEzi3x8eYl/+Ir7logEdU0wgzBzITCA/NMg1DnJxw1o3tnaUk7+2QydzmD2z8ovV5yeQRY/L5znXObHSXIVlKc2eJZrBnU3TEtob6p+Vy6wnZeko2lTp9LbukG2GlnHerFM3apRH1LVb9xkkP5mSog0VDv9f8e4U4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=j8B5NU+B; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="j8B5NU+B"
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-a3d01a9a9a2so26905666b.1
        for <patches@lists.linux.dev>; Wed, 14 Feb 2024 16:40:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1707957602; x=1708562402; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kYh5k8MyiysiewusV+Glc1Kt41gt5l9m2Lg4dhbhPyw=;
        b=j8B5NU+B/NEMUDck4l5pZmtKsizg2wgMAcQIlQajKH+AySUtOk9Pjev8StAJ0YThvW
         9Q/6D+o/NyzVaP63evjyZtZ8QJKoQ+vGjiMs89AFs6wfNBa7aLEPkxJ1Xn67g1OlDfnr
         bMd9FJy5nW0EKFa72W8BADOZnnD4QPMVvmGEM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707957602; x=1708562402;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kYh5k8MyiysiewusV+Glc1Kt41gt5l9m2Lg4dhbhPyw=;
        b=A5busWpS1nP2P/KE3DT8OyGYnHE7fUY4zSWbRmScHHvcOlATIqidvLdrsRQVpSJVyw
         GzydPt1BEQWh6hht/fp0c2UHY0Gni/zvDhZuxX2ZQu2YK2yehAl3Hg7ZHpBv66/IX5fL
         j9HGjFMIxaMOXOBawGguOLoSbV8cwAQDgajDyT4juS/96TAtQnlsULNRjQLH1mtMGlUd
         HoyXujDqVBM9Pq1qm9ULVZdTus6+DgY6bNL/dNnRz+xQOkUz/uJbvQKm8e3gw0BZvgac
         0JtytohWY5C8F7VjU6aaYXQC0+P4TWmuJBVodMnBnAU2N3yynkpiWDTnUSZOhAIYkpmV
         AFiw==
X-Forwarded-Encrypted: i=1; AJvYcCX/blqTmYqHXQzAY3TaJ7yKN/Qd2ZB9NVHdakWkcQcivN/THBXhU7yDcCzjLeo4u97BCeE2CgJi73TRtz0iDPOEyT4NMaam/A==
X-Gm-Message-State: AOJu0YxjalTiH0B/2HwQy3dDo1rw7RBdPi+het2OV6WapEKbenqEImvb
	zpRtv/VYQI0NqH+CcR+SniW85ye4qXOHZvh5QreIzoHkiNKyhefytbrq1W7JLJNe1NWiiEB8tvm
	uB/XZ
X-Google-Smtp-Source: AGHT+IEccLODXc+fqMZi3VOdkOR5QgtjTwXJZyp1fxsD6HSkLJBry7FO3Kb/yyJtmjTwaxL4wIQnzw==
X-Received: by 2002:a17:906:e4f:b0:a3d:63b:c43 with SMTP id q15-20020a1709060e4f00b00a3d063b0c43mr93987eji.17.1707957601901;
        Wed, 14 Feb 2024 16:40:01 -0800 (PST)
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com. [209.85.208.50])
        by smtp.gmail.com with ESMTPSA id ce17-20020a170906b25100b00a3c49c5aa85sm32392ejb.126.2024.02.14.16.40.00
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Feb 2024 16:40:01 -0800 (PST)
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-56101dee221so2268a12.1
        for <patches@lists.linux.dev>; Wed, 14 Feb 2024 16:40:00 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUaCKzthou0Xgf3ayOTQ85yQcl5KFJjiJrl7bclmMoe9UbsvyUGyj9An5+Tg1OnYaJXREtW3cNZjj13O4eX5KRYeBgffHKpOA==
X-Received: by 2002:a50:8d13:0:b0:55f:8851:d03b with SMTP id
 s19-20020a508d13000000b0055f8851d03bmr333252eds.5.1707957599932; Wed, 14 Feb
 2024 16:39:59 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240210070934.2549994-1-swboyd@chromium.org> <20240210070934.2549994-22-swboyd@chromium.org>
 <CAD=FV=WovmtKFiG0OMzpus9=z8UJ+Ev3TrwsVia8pSegvjwUiw@mail.gmail.com> <CAE-0n52qgKrasAw1AbZ97zMk1xz6P4KkxNLi4cBpNKy5wWu+1A@mail.gmail.com>
In-Reply-To: <CAE-0n52qgKrasAw1AbZ97zMk1xz6P4KkxNLi4cBpNKy5wWu+1A@mail.gmail.com>
From: Doug Anderson <dianders@chromium.org>
Date: Wed, 14 Feb 2024 16:39:45 -0800
X-Gmail-Original-Message-ID: <CAD=FV=XAcXs1hmJB_Rd42+Q3gQDuw=2L+igCyWnnnSYtqdifPA@mail.gmail.com>
Message-ID: <CAD=FV=XAcXs1hmJB_Rd42+Q3gQDuw=2L+igCyWnnnSYtqdifPA@mail.gmail.com>
Subject: Re: [PATCH 21/22] arm64: dts: qcom: sc7180-trogdor: Make
 clamshell/detachable fragments
To: Stephen Boyd <swboyd@chromium.org>
Cc: chrome-platform@lists.linux.dev, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
	Pin-yen Lin <treapking@chromium.org>, cros-qcom-dts-watchers@chromium.org, 
	Andy Gross <agross@kernel.org>, Bjorn Andersson <andersson@kernel.org>, 
	Konrad Dybcio <konrad.dybcio@linaro.org>, Rob Herring <robh+dt@kernel.org>, 
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>, Conor Dooley <conor+dt@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Feb 14, 2024 at 4:35=E2=80=AFPM Stephen Boyd <swboyd@chromium.org> =
wrote:
>
> > > -/* This file must be included after sc7180-trogdor.dtsi */
> > > -#include <arm/cros-ec-keyboard.dtsi>
> > > +#include "sc7180-trogdor-clamshell.dtsi"
> >
> > nit: Not that it was terribly consistent before, but in lazor you
> > remove the "This file must be included after sc7180-trogdor.dtsi"
> > because (I guess) it moved to the clamshell file. However, in other
> > dts files you don't remove it. pazquel has the exact same comment and
> > it's not removed. Pompom has a slight variant of the comment where it
> > explains the reason (to modify cros_ec) and it's not removed. Could
> > make it more consistent...
>
> Sure I can make it more consistent with the explanation. Which way to go
> though? Remove it from the boards and put it into the fragment files?

I don't care too much. I guess I'd lean toward just putting it in the
fragment files just to copy it fewer times.

-Doug
