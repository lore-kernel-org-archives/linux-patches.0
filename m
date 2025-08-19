Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A6BF32A3E2
	for <patches@lists.linux.dev>; Tue, 19 Aug 2025 11:30:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755603061; cv=none; b=WayDvSiVSXcDTHS6m5w6KFXMQL+UNgYcdbPCssOF3cArwbfU4QrJX+oFWIAfC2fx40t673VZTRdABd07wqmDGbawKZIJmrlDshoucuoeOko+U30s5L9m9byO4QDtzrQLkq4GFdwN+mbofPTQSNho1nXRYzeHEGqiht9fo3Of66o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755603061; c=relaxed/simple;
	bh=RS+DDBsenDMGRVRuo5OpJ0by6/pE8abc8eGvwv3Szfk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XAlUoC8gOMqOkQwwmg/u0mdMvFMNi5sAzyWYd/MK5vkxPWOBROwoWhsZI5CURKgp9ux/NlABav+HrNfj4r4qXSjzLfE43XjQNex0iAurUMLdiv0NL1k03cdxH5tIXh4N+V1TtFxGAtwJMSg0hHGKLIzLhGL1/hmdoqY2tm5TUNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=amTs0Onv; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="amTs0Onv"
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-afcb78ead12so730338466b.1
        for <patches@lists.linux.dev>; Tue, 19 Aug 2025 04:30:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1755603057; x=1756207857; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=MlZSqNXnF5cFT3EKTsD5C3uA+ixCm4MLZap6H11YwJU=;
        b=amTs0OnvWhv8P48GcJnDMLHRxjohCfAx+cbUHHk03J37PUlw2bD0XWRnHRuFSyBou4
         ruu8zxmKLUAXi+SfpQFisTpUj0fQSFm0e2URGBDitoveS5jLiV32xmKrSKz4wcBIM/Qa
         fJ0vLvpjV7Xbs4muMTDJdVjBUb1f0rVNLL7iCceegcHNS5ChhEBiezbJnsvJezs1hc4o
         DTT23hNHiFBLZRaVcYn6LWoa953EBwUV4GVHaDz899R4pDHQhnEB0XmjpQUlkpYg88cG
         m/1I6pq3ssQEagfJojfDC4FbkUfp29Usv/6+3p1J7Y5ZwDFblPDksl+InFSap97539Cd
         XwmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755603057; x=1756207857;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MlZSqNXnF5cFT3EKTsD5C3uA+ixCm4MLZap6H11YwJU=;
        b=rdM3K1wjIVdC6nsY+Jis8YdtuXr1V+t0D9IvrrK5z1bzvb9fod6pdW6BQFdK8dE1jA
         pFO0D0tJQn3ezkZ43yoULpCLqeYPZgmV+dQLpyS+cCldEWQvElQ2NRzZQJSRVD3zgvpI
         YdqBX/AHtP1+aBx14dWjYG+8RxPvCc1LD2wqL+9KESaQP04I0ULY3TdHHHM0Uq9hWS5z
         rnxoZw3SilEdvlDMNRzx0Qpiy0EKhmQjOrTtFt4g2xhT9V6tYSxNiRqCENDMN8Wey9e9
         tt+tCc723+8gukWEDtYkrp6bqI/dQgx9xtD4T5p+3hszTu1ka4sJeuaMi7SPXPF26y+f
         pRyQ==
X-Forwarded-Encrypted: i=1; AJvYcCWcmA9ZwruRVwJC2dRP3RFzcBo6C6KixQV70ZWrKN2u3xkY9u3iUGC2JtA2yKYFVtmbbx2JiHcy@lists.linux.dev
X-Gm-Message-State: AOJu0YxljrmBxxbo6amm3O+4aPRjen21pyRgybAKZ7Q7ie0Q3vktfSeG
	0osvJuJpr215ji/HgbCV1sNde+6Eod2DAJy/OYnAUWaHmEVPftSTrvFLpIrAau2EMgoCnQDodRU
	wTWBz4jFQnUWnfG/BesO9/dYZa/V1kWyW/OWYlorLEA==
X-Gm-Gg: ASbGnctn7Ov5ZD4rWxvGCJaQIzcgR+HgwWIO5Kmf/tRrPATevsntWS+Qj6B4i6IsmY/
	nNlKXYAG25ji7aGySMQnwI0c+olaCMPz1I6/2dukF0wBg27xrs9WjzzU6yKeTwSeImdo62GU0+u
	OYm8zZb8dSepgCviZJ5wLkzPCC9MIICM9g8hC2BHSCPeokvLIb2URa8lFgVzgm36TTcBVmNUueD
	2nE
X-Google-Smtp-Source: AGHT+IFc1qeOeB8SEpfLr5OOLAFUUqEj6GU45bLARYtHghlfX/crq9PpWhn+VH6PLkjxDEuyGteYvZKpflusqa5M/Ig=
X-Received: by 2002:a17:906:c115:b0:af9:57ae:dbb3 with SMTP id
 a640c23a62f3a-afddcb81908mr192322866b.22.1755603057341; Tue, 19 Aug 2025
 04:30:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250818124458.334548733@linuxfoundation.org> <CA+G9fYt5sknJ3jbebYZrqMRhbcLZKLCvTDHfg5feNnOpj-j9Wg@mail.gmail.com>
 <CA+G9fYt6SAsPo6TvfgtnDWHPHO2q7xfppGbCaW0JxpL50zqWew@mail.gmail.com>
In-Reply-To: <CA+G9fYt6SAsPo6TvfgtnDWHPHO2q7xfppGbCaW0JxpL50zqWew@mail.gmail.com>
From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Date: Tue, 19 Aug 2025 13:30:46 +0200
X-Gm-Features: Ac12FXyaJepFNIeos9w4tdtDWEq_utvLUQ4wMo0fo8sqlMNsdeJO5hMNv6oFTrY
Message-ID: <CACMJSeu_DTVK=XtvaSD3Fj3aTXBJ5d-MpQMuysJYEFBNwznDqQ@mail.gmail.com>
Subject: Re: [PATCH 6.15 000/515] 6.15.11-rc1 review
To: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, 
	patches@lists.linux.dev, linux-kernel@vger.kernel.org, 
	torvalds@linux-foundation.org, akpm@linux-foundation.org, linux@roeck-us.net, 
	shuah@kernel.org, patches@kernelci.org, lkft-triage@lists.linaro.org, 
	pavel@denx.de, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de, 
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, achill@achill.org, 
	Ben Copeland <benjamin.copeland@linaro.org>, Anders Roxell <anders.roxell@linaro.org>, 
	Dan Carpenter <dan.carpenter@linaro.org>, Arnd Bergmann <arnd@arndb.de>, 
	Bjorn Andersson <andersson@kernel.org>, linux-arm-msm <linux-arm-msm@vger.kernel.org>, 
	Linux ARM <linux-arm-kernel@lists.infradead.org>, srinivas.kandagatla@oss.qualcomm.com
Content-Type: text/plain; charset="UTF-8"

On Tue, 19 Aug 2025 at 12:02, Naresh Kamboju <naresh.kamboju@linaro.org> wrote:
>
> On Tue, 19 Aug 2025 at 00:18, Naresh Kamboju <naresh.kamboju@linaro.org> wrote:
> >
> >
> > Boot regression: stable-rc 6.15.11-rc1 arm64 Qualcomm Dragonboard 410c
> > Unable to handle kernel NULL pointer dereference
> > qcom_scm_shm_bridge_enable
>
> I have reverted the following patch and the regression got fixed.
>
> firmware: qcom: scm: initialize tzmem before marking SCM as available
>     [ Upstream commit 87be3e7a2d0030cda6314d2ec96b37991f636ccd ]
>

Hi! I'm on vacation, I will look into this next week. I expect there
to be a fix on top of this commit.

Bart
