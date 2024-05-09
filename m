Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EFE47F7EA
	for <patches@lists.linux.dev>; Thu,  9 May 2024 19:35:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715283321; cv=none; b=A2Jvt2kAcJypWdGHDN8WkPVYccyacBJj/VSMwctAsD1GscHUkGT+CMHGYFM0C55N6MnMAOix9MLoWJvVE5f8QI5Fdu60LH3aMhgGnmgPkQv0zmjkCpJ7APg1WqZ+SxQnlKiCiF4RHQGmNWtbzQNZAPPTzDGF2oA374rWfV+7dyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715283321; c=relaxed/simple;
	bh=EaYjQrX+/02VwYCtKZW3vScrvUW670G05eaMa5VkSl0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=prQQtJrXCNtEwLljxIFWHSpCysZeV269h8qdMbKbgHlJqMcmeIGFDDilq6B1nuOWL414VIFGhmGhMQF+TDCXstp4jETxn4YpzAtEKg5G0A3kXUF/9OAxW9/aAMHWnPqnA0cLvnwlt8TsN6oW7njleasrgUjzrcNekHgv65iSY78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=VPZ7JmbE; arc=none smtp.client-ip=209.85.222.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="VPZ7JmbE"
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-792b934de39so99281285a.3
        for <patches@lists.linux.dev>; Thu, 09 May 2024 12:35:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1715283317; x=1715888117; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Xw1OkgMZ/krnn9QK21TBDDqRd4Ysk40xlaOCf58rQec=;
        b=VPZ7JmbEviN32mc6EsQSvMviYgwfdcvYWK7a06dK7FpAhZJJuh3ocbjye0F4BL3JEe
         mr4v1uNgp9GEJ50zAVyuShaPkFIbymUyu1WZXjw7WjnHxcNpZJdg6muu/vQI0Sduiwhy
         4u70cPdktOsHo+jEXYJ+Gyv18aynUHSuMpEG4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715283317; x=1715888117;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Xw1OkgMZ/krnn9QK21TBDDqRd4Ysk40xlaOCf58rQec=;
        b=YBtzeuGhZZlffieX6ZKS17xSDuxcoTHunEo+3Nlym7E/6j/HLgYblkKy0oFLSkQFYI
         BWVZg7RGJr4U2zBbI/5EiERsJIFasNfsmz6ULk8lg7WNEUYpk+kClWTzyALyB3ScwuoQ
         aD8DrSGYgugH1ra6Zvy5HckjArUCKYZPstGIoHuTulo5j9Nkpn4AsXdVBwDRxuhdiFHi
         /3vKtVulbAlY2Txg9pZ2BY3+il0mQUAjk7ozxooHWxfy8KsZ3da0lxefSY4c9s5eI6Cb
         TEvhSLg46ZwTW49eYOZLpyeg84P01ce+mdA+euUNhDmr0FsD/28kO7mgkDvej42i2atx
         mXzQ==
X-Forwarded-Encrypted: i=1; AJvYcCX/MOrnpDWKHJurxz9CF+pXa2jfMulgZITa284/tYuQ7fgA/hGfdZDfr8C1rTmcvfiCd/bU5zYKlu7txsg+S1uD/aZcXjUiSQ==
X-Gm-Message-State: AOJu0YwKTT+B7Iqb3WFvQIlr66HeP5qOY/lhAKySwwwoFPHMxsWUHE5B
	f2WWkDw1yp7j7CfK3CgoqoKngMRNe5kFHlAPujQ6vsy2RpPx6PuAAotRxxU+6lHWxDgqAiZgf5t
	zYg5M
X-Google-Smtp-Source: AGHT+IFXz3CLbtbNw5KDG41wTekLrW1LEi3vilk0TfujVW+gKlUEwomiY79B8z+SEk2y5UokteFfqA==
X-Received: by 2002:a05:620a:562b:b0:792:91bb:9ca3 with SMTP id af79cd13be357-792c75abfaemr52532885a.37.1715283317427;
        Thu, 09 May 2024 12:35:17 -0700 (PDT)
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com. [209.85.160.178])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-792bf2fc609sm98865285a.94.2024.05.09.12.35.16
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 May 2024 12:35:16 -0700 (PDT)
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-43df9ac3ebcso62001cf.0
        for <patches@lists.linux.dev>; Thu, 09 May 2024 12:35:16 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWiL66wrLbEJyn+dPCDmjF3GVhq2vcRAnHwhjxmtUDjCOA/l7uT22+f+fsszt/dpKsu3EN9QA9gm/gZ4nTCW1ep+4fGFJtp+Q==
X-Received: by 2002:a05:622a:429b:b0:43a:b977:d611 with SMTP id
 d75a77b69052e-43dfdcde1cfmr333451cf.24.1715283315822; Thu, 09 May 2024
 12:35:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240509184129.3924422-1-swboyd@chromium.org>
In-Reply-To: <20240509184129.3924422-1-swboyd@chromium.org>
From: Doug Anderson <dianders@chromium.org>
Date: Thu, 9 May 2024 12:34:59 -0700
X-Gmail-Original-Message-ID: <CAD=FV=VP+DDQbdb-pD2JJKrZ+MrkgcuyzBj4H-4oTDVvBpTOtQ@mail.gmail.com>
Message-ID: <CAD=FV=VP+DDQbdb-pD2JJKrZ+MrkgcuyzBj4H-4oTDVvBpTOtQ@mail.gmail.com>
Subject: Re: [PATCH] soc: qcom: rpmh-rsc: Ensure irqs aren't disabled by
 rpmh_rsc_send_data() callers
To: Stephen Boyd <swboyd@chromium.org>
Cc: Konrad Dybcio <konrad.dybcio@linaro.org>, Bjorn Andersson <andersson@kernel.org>, 
	linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
	patches@lists.linux.dev, Dan Carpenter <dan.carpenter@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, May 9, 2024 at 11:41=E2=80=AFAM Stephen Boyd <swboyd@chromium.org> =
wrote:
>
> Dan pointed out that Smatch is concerned about this code because it uses
> spin_lock_irqsave() and then calls wait_event_lock_irq() which enables
> irqs before going to sleep. The comment above the function says it
> should be called with interrupts enabled, but we simply hope that's true
> without really confirming that. Let's add a might_sleep() here to
> confirm that interrupts and preemption aren't disabled. Once we do that,
> we can change the lock to be non-saving, spin_lock_irq(), to clarify
> that we don't expect irqs to be disabled. If irqs are disabled by
> callers they're going to be enabled anyway in the wait_event_lock_irq()
> call which would be bad.
>
> This should make Smatch happier and find bad callers faster with the
> might_sleep(). We can drop the WARN_ON() in the caller because we have
> the might_sleep() now, simplifying the code.
>
> Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
> Closes: https://lore.kernel.org/r/911181ed-c430-4592-ad26-4dc948834e08@mo=
roto.mountain
> Fixes: 2bc20f3c8487 ("soc: qcom: rpmh-rsc: Sleep waiting for tcs slots to=
 be free")
> Cc: Douglas Anderson <dianders@chromium.org>
> Signed-off-by: Stephen Boyd <swboyd@chromium.org>
> ---
>  drivers/soc/qcom/rpmh-rsc.c | 7 ++++---
>  drivers/soc/qcom/rpmh.c     | 1 -
>  2 files changed, 4 insertions(+), 4 deletions(-)

Reviewed-by: Douglas Anderson <dianders@chromium.org>
