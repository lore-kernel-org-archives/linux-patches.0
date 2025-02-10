Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com [209.85.219.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A856A2586D6
	for <patches@lists.linux.dev>; Mon, 10 Feb 2025 22:50:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739227840; cv=none; b=kjxaJCYtAU9UHDWtH02SKfV2A4OkE63DZEERXn8xaxvSUNteIhIGtbmITA7ghefjQ07xPTkAT4vZ4hbB4p17zoUX9YZfXuLDtEKVSAUJuEHoahD7J3ddpQLtuNyxeNk9e6/PeejuD+wvpsLuEYjPUrJxuR0QBTsFZ8kQYgVM5rg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739227840; c=relaxed/simple;
	bh=5zbZ0mjlc5mJspBqAdHsl+XIcsIzXXEkeeddcLU17Ww=;
	h=MIME-Version:In-Reply-To:References:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XdjbpvnKGLpMe//7okCLkaXO1qT+fy8Nhp4Kxa4MmX2TW+n8WksdBJRzOJVf+COXV3YpIDk79jGx+e/VKndlvpg44+vxFAnKMwwYXl8b546TJt9QM1BjXVgk8RMXG8FT5bRynlURBX8Hm66r/k9yAfKNzPisRO4+7HKHc9kmgHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=E1qdMQUq; arc=none smtp.client-ip=209.85.219.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="E1qdMQUq"
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-6dcd4f1aaccso77538596d6.2
        for <patches@lists.linux.dev>; Mon, 10 Feb 2025 14:50:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1739227837; x=1739832637; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:user-agent:from:references
         :in-reply-to:mime-version:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5zbZ0mjlc5mJspBqAdHsl+XIcsIzXXEkeeddcLU17Ww=;
        b=E1qdMQUqp6Dith9ATmZPlZ2Uqh3ntG3DMWEib01Fw3L5CIrOpijSNrPTwAG5ygfd/C
         ZMZXyEL5IDbGt0SV0xFtk4FOG21hSGUSCmdFspo0fU+tjGubCbRXEIiPnenKhqjwOIzb
         5qSdghBExZ/2qI0mPOVTuuh9KBr/PrDTkaz0s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739227837; x=1739832637;
        h=cc:to:subject:message-id:date:user-agent:from:references
         :in-reply-to:mime-version:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5zbZ0mjlc5mJspBqAdHsl+XIcsIzXXEkeeddcLU17Ww=;
        b=vvJJrh5y43ztuLyxu/fW+EvrMi5F4We82gwvBBYU/CgadF+w2TJLo6pNsQJ7GuhmCR
         xpYw9jfMRykDKYPuZUxUjXi2yJh2/fLS7IKjgQnyNyJ2Yim9+Rq7dHf9IODa9Be8wxn9
         A6KKrvD2CyGsVMEd65ZseuUJFdJqXwS0eKhrGfzYBL2p7mbUKAdsk18ibtkPzk4pEaCl
         0Ht7TT05qgynw5QTb49RXYpP9thsFpXwNcYAXysdK2+KzveCpQuIm3VHN6raV/D64u/h
         zNo9p4j+dyRdYkCvg9bqdnrt4uduaBXF9eawBzDmv8VtyWZyOfDoGuhPHrYKLCmD5KBj
         2QXA==
X-Forwarded-Encrypted: i=1; AJvYcCXun1T7vFFkob9qR8Yu2U3sncKEgu2dMzz+mCSZfj1iUNNnxDxjZev0tGENDxuj2V5IsOMa1X1V@lists.linux.dev
X-Gm-Message-State: AOJu0YyOgN6jGnXt8rnJpIDWLUFPgoGP4M+ChAd7r2XPuKoZ8PxFVFPR
	hqqYPhzmI7V1iyzNQDjO5MlYAx5ooKQZ4PpDScWJNu/CGJacIFGdsOAGmG7Z4qBjfmGOvFD4tgw
	vwYuJQjT+6ocLogzWKaAcPW5dCDl3fQQC+djK
X-Gm-Gg: ASbGnctAaiCsqc9nMI9dZFRsol+nmrv3O9xfwL1l8v2oIBGfcvOswbe+Qd9EWwNkhH4
	EpHjc/kvZQ8IgNWEQQcZjvXYlhDsOhV67BmOIHoYekCru0jnfCUqrSyLmZd59jxHdlipfg8JH+U
	7faTdm1ELJ5CIAyKiJK231q3k4
X-Google-Smtp-Source: AGHT+IGL4SmQgIAC10xipCYbVaexIQbpQQDDIqhx2hGeOo7wq1KUJ/UwijMW6vgDIGzhCGOUFwEwrakNbbsm+km09q4=
X-Received: by 2002:a05:6214:240f:b0:6df:99f7:a616 with SMTP id
 6a1803df08f44-6e4455d2fdemr247845286d6.2.1739227837669; Mon, 10 Feb 2025
 14:50:37 -0800 (PST)
Received: from 753933720722 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 10 Feb 2025 16:50:37 -0600
Received: from 753933720722 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 10 Feb 2025 16:50:37 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <87895166-659e-475f-99bf-5791a6e1ac3b@oss.qualcomm.com>
References: <20250205233016.1600517-1-swboyd@chromium.org> <20250205233016.1600517-2-swboyd@chromium.org>
 <74527323-31ff-4ed0-b19f-e535f26abf2b@oss.qualcomm.com> <CAE-0n50DXcAXQMaLtsamvxHjUrkJVBz42G6gtgKgW9Rh=qd31Q@mail.gmail.com>
 <87895166-659e-475f-99bf-5791a6e1ac3b@oss.qualcomm.com>
From: Stephen Boyd <swboyd@chromium.org>
User-Agent: alot/0.12.dev1+gaa8c22fdeedb
Date: Mon, 10 Feb 2025 16:50:37 -0600
X-Gm-Features: AWEUYZmtYYT334_kTXnpfDawnzC3OarpU1PJNDWzV_jXYgahC0sPCiJwqwU3_-I
Message-ID: <CAE-0n51zc65GSm5J9TbHe_g4reos2h_iv-ozMU6CCrAuOt3Kww@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] dt-bindings: chrome: Add binding for ChromeOS Pogo
 pin connector
To: Bjorn Andersson <andersson@kernel.org>, Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>, 
	Konrad Dybcio <konradybcio@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
	patches@lists.linux.dev, cros-qcom-dts-watchers@chromium.org, 
	Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, 
	Benson Leung <bleung@chromium.org>, devicetree@vger.kernel.org, 
	chrome-platform@lists.linux.dev, Pin-yen Lin <treapking@chromium.org>
Content-Type: text/plain; charset="UTF-8"

Quoting Konrad Dybcio (2025-02-10 11:09:57)
> On 6.02.2025 9:43 PM, Stephen Boyd wrote:
> >
> > Do you have a device that could use such a generic binding? I can't
> > really design something in the abstract without two or more concrete use
> > cases. Coming up with something generic looks like a quagmire, because
> > as you say the signals going through the pins could be anything: i2c,
> > 1-wire, etc.
>
> Right, we can't be overly generic either. FWIW I'm not standing in the way
> of this patch getting merged.
>

Ok, got it. I've renamed this to google,usb-pogo-keyboard and made it
keyboard specific. I'll send v3 shortly.
