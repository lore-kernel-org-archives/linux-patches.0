Received: from mail-oi1-f171.google.com (mail-oi1-f171.google.com [209.85.167.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93B9D1D278E
	for <patches@lists.linux.dev>; Tue, 27 Aug 2024 18:04:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724781845; cv=none; b=fDNYaahCUfR2wM91VJGcIcH8zg0+dOKjhRmeHBJs2u2i6iI2pUz2IpP702pbhMi9pn3/JCrBCi4NuGTleWnqruPe4xj+/0rdSdRMonS68z/cBnI2xBX05Pw4TyIsZClEU+tQcrXVDsCCSHOFhkN5Esy397PnWyaaEPCN357K6p8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724781845; c=relaxed/simple;
	bh=ljNQ7arYgd97/fkr6o6r79Qw0skRIiKXIc+DDFjF02k=;
	h=MIME-Version:In-Reply-To:References:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=r+fqbFm7oGbSus4tphnt2Xan1NGc5JUeBTpDz7RpApZGCvqVEK2smd8u6EivEVsmKq786TJX7pp50S8IDx4CMSgxM9tMz4zbQfAlnE/KdFAp696dz2n9vCYeswjxnB+7/2GUai7yXyy1+BVxbTN2r8+Va8i7V4AP2ZIjJfE010s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=PDG6bYgu; arc=none smtp.client-ip=209.85.167.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="PDG6bYgu"
Received: by mail-oi1-f171.google.com with SMTP id 5614622812f47-3db18102406so635287b6e.1
        for <patches@lists.linux.dev>; Tue, 27 Aug 2024 11:04:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1724781842; x=1725386642; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:user-agent:from:references
         :in-reply-to:mime-version:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ljNQ7arYgd97/fkr6o6r79Qw0skRIiKXIc+DDFjF02k=;
        b=PDG6bYgusyAaEnxV75rRBlz/RauGoi5RqSXihAP3JFVfARwPLEuhaxAvOWekrdVHYt
         aSAdKBtB+I0En6LoRtFI9ob+M4eLb7FWgDbayb4e5qXUaSqXxOy2Hgu1py2QBluDqHar
         UI10AUGZTyHmGUADkg/19M2MuBuaZTyGpFH/E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724781842; x=1725386642;
        h=cc:to:subject:message-id:date:user-agent:from:references
         :in-reply-to:mime-version:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ljNQ7arYgd97/fkr6o6r79Qw0skRIiKXIc+DDFjF02k=;
        b=OlBlJG6mnOjmdyK1bYb7rTCVHmQ/0FsG4zVzkUGBNnDKCJJy+1rzBmGM57PaLZ7dXc
         yFOfmOoIFIRFvqlQmF2/s+Y+GLR4ExT7Ml7iIrdhSZlW4appI4H1Z4jWl/LUQ9xv3MVG
         rmtFKPIrUx1TYcW3P/x92YRpvT4O9zS0iP9+fC0uqWbPBKGKlu7mE2U/a6nmkSISB4K9
         lRRXwhLDs7yJg6X+c/AwihjNoUHMAlCE0lI6NYz+t+ZLf4z9RJ0aLqDjt0Bw0mb0nWhV
         c3HP82dmby4aXRddj40c5d2Ph6JKiOgDaKEJcLzPtyizfzj4/hfpVqAe2TcXEwf1GvZO
         6Cmg==
X-Forwarded-Encrypted: i=1; AJvYcCXw8oe3HJavTJbE0YxbLy8rALS47TSlYCGdh7I6N6bivJrHv6RQNpQ1sL1uxMEtY10A/a956wah@lists.linux.dev
X-Gm-Message-State: AOJu0YzWThNSlOJoJ+Q650vZzI1/Ooj0LMhEFiMs7omfgGvjmCUOCWkW
	yLvC1eVWSKcOdrhkEjvf/fpT0ji34PJwL6s0+Q3m3lgH+oeMu+Fz1bcMKKUgQHJ+gkrZcRD3U71
	0YKRIRgcjgeDPJsHlPSgmK1cQrCcklZrzhQRQ
X-Google-Smtp-Source: AGHT+IGb5F/ggcI3jz1RUx44031WcBMTlky7xP6DWT8xj1loQKewOpYzcoFYeVm5Bcffm7Nj9lhcl1vtTTW4UO2x4wE=
X-Received: by 2002:a05:6870:970a:b0:268:2efa:2de0 with SMTP id
 586e51a60fabf-273e6469d6dmr16662999fac.13.1724781842495; Tue, 27 Aug 2024
 11:04:02 -0700 (PDT)
Received: from 753933720722 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 27 Aug 2024 13:04:01 -0500
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20240819233628.2074654-2-swboyd@chromium.org>
References: <20240819233628.2074654-1-swboyd@chromium.org> <20240819233628.2074654-2-swboyd@chromium.org>
From: Stephen Boyd <swboyd@chromium.org>
User-Agent: alot/0.10
Date: Tue, 27 Aug 2024 13:04:01 -0500
Message-ID: <CAE-0n51fjJ8QO2eAy5ZbQOwo9Urzrv1NnXw6KzB=mwHoVoJKzw@mail.gmail.com>
Subject: Re: [PATCH 1/2] clk: qcom: gcc-sm8550: Don't use parking clk_ops for QUPs
To: Bjorn Andersson <andersson@kernel.org>, Konrad Dybcio <konrad.dybcio@linaro.org>, 
	Stephen Boyd <sboyd@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
	patches@lists.linux.dev, linux-clk@vger.kernel.org, 
	Konrad Dybcio <konradybcio@kernel.org>, Taniya Das <quic_tdas@quicinc.com>, 
	Amit Pundir <amit.pundir@linaro.org>
Content-Type: text/plain; charset="UTF-8"

Quoting Stephen Boyd (2024-08-19 16:36:26)
> The QUPs aren't shared in a way that requires parking the RCG at an
> always on parent in case some other entity turns on the clk. The
> hardware is capable of setting a new frequency itself with the DFS mode,
> so parking is unnecessary. Furthermore, there aren't any GDSCs for these
> devices, so there isn't a possibility of the GDSC turning on the clks
> for housekeeping purposes.
>
> This wasn't a problem to mark these clks shared until we started parking
> shared RCGs at clk registration time in commit 01a0a6cc8cfd ("clk: qcom:
> Park shared RCGs upon registration"). Parking at init is actually
> harmful to the UART when earlycon is used. If the device is pumping out
> data while the frequency changes you'll see garbage on the serial
> console until the driver can probe and actually set a proper frequency.
>
> Revert the QUP part of commit 929c75d57566 ("clk: qcom: gcc-sm8550: Mark
> RCGs shared where applicable") so that the QUPs don't get parked during
> clk registration and break UART operations.
>
> Fixes: 01a0a6cc8cfd ("clk: qcom: Park shared RCGs upon registration")
> Fixes: 929c75d57566 ("clk: qcom: gcc-sm8550: Mark RCGs shared where applicable")
> Cc: Konrad Dybcio <konradybcio@kernel.org>
> Cc: Bjorn Andersson <andersson@kernel.org>
> Cc: Taniya Das <quic_tdas@quicinc.com>
> Reported-by: Amit Pundir <amit.pundir@linaro.org>
> Closes: https://lore.kernel.org/CAMi1Hd1KQBE4kKUdAn8E5FV+BiKzuv+8FoyWQrrTHPDoYTuhgA@mail.gmail.com
> Signed-off-by: Stephen Boyd <swboyd@chromium.org>
> ---

Applied to clk-fixes
