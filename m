Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com [209.85.222.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68BAB1A2844
	for <patches@lists.linux.dev>; Wed, 28 Aug 2024 17:03:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724864623; cv=none; b=KZp1FWS/E5RnR14Jki2jgA6trQWJhnqxZSnKPc4BbcPTmSkOD1LcC8hfqCiVRG8XY1xFn1CKEFMvglKJOB1i3lJ3p64W4JMyyBFfeYeVKfeznXtHGuQK25wvohmWVkodGIxLfRFUWQgstto1iGISun/jM6vwZtNP1TcRHnuS2vg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724864623; c=relaxed/simple;
	bh=QasJiYQ1cDw/pStQicO3S8JcebgaLLR56R+OjX3L02Q=;
	h=MIME-Version:In-Reply-To:References:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XTrRKY8quIm4sJMArdnTHIMlAyiUFTDLq9ffdQTR03UbEOKRvZitF5WPmLkx1sWi1wch84aFfR0EpRwBCGFrGiTcg/robHnbhR9+46k6PMm6iWfMUsNmPWtdf5fcJyB5DVwcocFP2Jvs11QmK1KtIexnccPf5ySch62qiACFn6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=CFl2W7dc; arc=none smtp.client-ip=209.85.222.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="CFl2W7dc"
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-7a7f86026a0so51961985a.3
        for <patches@lists.linux.dev>; Wed, 28 Aug 2024 10:03:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1724864621; x=1725469421; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:user-agent:from:references
         :in-reply-to:mime-version:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QasJiYQ1cDw/pStQicO3S8JcebgaLLR56R+OjX3L02Q=;
        b=CFl2W7dcKXqGaqjI/DAOcSTpnodA6bRNBezzFs1q7UXxkc+FrHi3hjBFcnXhzmXRg/
         x59nFX9K1HayGxi8IrPUOwSSDfZqu1OgyIeDTPnXmPWjGsH/qGXbWG081wvZriwNL8Lr
         V6nmXN9KUJApweGUnyGW9ahxakTQwv/iYQpxo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724864621; x=1725469421;
        h=cc:to:subject:message-id:date:user-agent:from:references
         :in-reply-to:mime-version:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QasJiYQ1cDw/pStQicO3S8JcebgaLLR56R+OjX3L02Q=;
        b=J1FQQvE5sfQmRZH6lEw7l6+pTmT3bjTYjGYm64evfjxBujTkrsP/hlKqsRM/eAr5QR
         /Gc3aSl3mebeZwIqlNe2sYQr4sAbK+ys05eINxZEQtv5On2IeZMAe/f+b50+f+KH0/ou
         gFCZMXC9Jl9JDeOVKZcEI5PDT/3S7P+dY7Hne96M/u3/S11z5wWm9jK1h2q8eOO283+F
         nqp4KYJS5mQMKg/UQWMuQhvb6ZXW3g/tX6TrbQIQfU2X5s++JFgMlFKfw4h5/AiKyZuD
         mnQvN4AJd9aoYsrtBi+eLOMq4XQToofp8lxQznNXWY5WCjCzN23a00ucDTcHDuEf6nPQ
         hONw==
X-Forwarded-Encrypted: i=1; AJvYcCWHHW84CsxX7XIT9zqDiWtiBDCRkGBYF1rl4BVYH4NVef/lptz0Xi1pymBgUHfyD2coJ+aqobve@lists.linux.dev
X-Gm-Message-State: AOJu0YwiFzszxZB/s7z6vkNxUibJcRnWL5uUnGugw7o56Agfj1kFZsZm
	gm8ZF70zIk5yATWFGLh0vP8IOID6aMzkNITbdxm+hUCuClX4jc4qMTXkGGwtw20OkeJMTyjDvWO
	mZmBius/SzvHWnlbn5uUcBdtVOO19ADHkN6dV
X-Google-Smtp-Source: AGHT+IEVO9KZmNWSFybfc7A1nURst7111SB2+UOWqLJ8aG+gb/58BS72acni8VLoQAEGgDW7MBt6MwGtixuxjlVQbiw=
X-Received: by 2002:a05:620a:2496:b0:7a4:f480:c315 with SMTP id
 af79cd13be357-7a804182b1fmr3651685a.3.1724864621186; Wed, 28 Aug 2024
 10:03:41 -0700 (PDT)
Received: from 753933720722 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 28 Aug 2024 13:03:40 -0400
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <8597375d-6c15-4d20-96fd-2598805c09d5@linaro.org>
References: <20240827231237.1014813-1-swboyd@chromium.org> <20240827231237.1014813-2-swboyd@chromium.org>
 <8597375d-6c15-4d20-96fd-2598805c09d5@linaro.org>
From: Stephen Boyd <swboyd@chromium.org>
User-Agent: alot/0.10
Date: Wed, 28 Aug 2024 13:03:40 -0400
Message-ID: <CAE-0n50_+ci9H4M74FC1xVF5szE7kULFifEEnE+-DxaivGG-Bw@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] clk: qcom: dispcc-sc7180: Only park display clks
 at init
To: Bjorn Andersson <andersson@kernel.org>, Konrad Dybcio <konradybcio@kernel.org>, 
	Neil Armstrong <neil.armstrong@linaro.org>, Stephen Boyd <sboyd@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
	patches@lists.linux.dev, linux-clk@vger.kernel.org, 
	Taniya Das <quic_tdas@quicinc.com>, Amit Pundir <amit.pundir@linaro.org>
Content-Type: text/plain; charset="UTF-8"

Quoting Neil Armstrong (2024-08-28 05:22:25)
> On 28/08/2024 01:12, Stephen Boyd wrote:
> > Amit Pundir reports that audio and USB-C host mode stops working on
> > sm8550 if the gcc_usb30_prim_master_clk_src clk is registered and
> > clk_rcg2_shared_init() parks it on XO.
>
> Why does it change the dispcc-sc7180 in this case ?
>

The patch that broke it affected all RCGs. Let me add that detail and
resend.
