Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 887C73D0DC
	for <patches@lists.linux.dev>; Tue, 28 Nov 2023 20:26:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="G3a+savF"
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-50bbef0e5d5so1205932e87.1
        for <patches@lists.linux.dev>; Tue, 28 Nov 2023 12:26:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1701203214; x=1701808014; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:user-agent:from:references
         :in-reply-to:mime-version:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5e/cA2xc7eDKmbypo6Z8SLywnOUPp9h8bqqyEEbG2Ow=;
        b=G3a+savF6btaDtJCFzie9v9amJToNFhIYcMeC42feFJHY0woEnJHUngF2xKEyS1JO+
         U2Ydcjnbj1s5iCPwTrpWXrRc1Zj/DOy9E6rFY1Jr/WVYDL6kerXwD7llZbf8w7dHtIow
         8yPeq8ZKbvos0e0EkU1AY6rR2ymuYPQx0/P7Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701203214; x=1701808014;
        h=cc:to:subject:message-id:date:user-agent:from:references
         :in-reply-to:mime-version:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5e/cA2xc7eDKmbypo6Z8SLywnOUPp9h8bqqyEEbG2Ow=;
        b=XCG5WzfwvxQMc7xarniW8mEucx4aDNSHk9kC5PXy+56TT8DBF0zk1ZOpYu9d5o2aQo
         xzvEdsEj2OwUIWkdRxmtIjzSj0MaFxVJlVQQVe3eZkSYrFvS3OucJfZ/pB1OrMmPCVLd
         1eNW5aRnYP38ACQBKe/uPV9YQ1CgvF6QSeEVqnOSORUwylLTvwn6+AhuGmlMpGI2Tmvp
         /GoVyInagU5oTgt3pxmjLjhEocKt6pIc1arKsu8NeJOeXaZen13y8yVXPPnAwSmGhgvQ
         Ad4pRjXEE1wG4qZshyOvkm2zXPWubPibfUOBZYqt/f3xwzNtN4Y10iGLZ1HiU1l06iux
         HQPg==
X-Gm-Message-State: AOJu0YzpOJSuuRhDmyd1FMsL7fG+qdRJq5GrkDJE+KL8ygQdmvjuRRGC
	BhoxNWJIREtiufdn3AQv/YPbm+RxrfBedH5J/Azsig==
X-Google-Smtp-Source: AGHT+IHPo1Uzv9EVtilCouzElyVLqdgaW4ild4G1hYIMDOJYzDiORoqPIa0lrdy3P4ThtYYFo/T7JY6HIy/vgT0G6QA=
X-Received: by 2002:a2e:b523:0:b0:2c9:8f6b:3d9a with SMTP id
 z3-20020a2eb523000000b002c98f6b3d9amr9371511ljm.16.1701203214015; Tue, 28 Nov
 2023 12:26:54 -0800 (PST)
Received: from 753933720722 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 28 Nov 2023 12:26:53 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <0ea669ad-9a33-40e0-b4df-aa2b2a1b92de@linaro.org>
References: <20231128002052.2520402-1-swboyd@chromium.org> <0ea669ad-9a33-40e0-b4df-aa2b2a1b92de@linaro.org>
From: Stephen Boyd <swboyd@chromium.org>
User-Agent: alot/0.10
Date: Tue, 28 Nov 2023 12:26:53 -0800
Message-ID: <CAE-0n50My=0FZ044b2beaB2cHpC6MxYtsEKsVou=80yO2iERYg@mail.gmail.com>
Subject: Re: [PATCH] dt-bindings: arm: qcom: Fix html link
To: Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>, 
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>, Rob Herring <robh+dt@kernel.org>
Cc: linux-kernel@vger.kernel.org, patches@lists.linux.dev, 
	devicetree@vger.kernel.org, Alexandre TORGUE <alexandre.torgue@foss.st.com>, 
	Yanteng Si <siyanteng@loongson.cn>, Jonathan Corbet <corbet@lwn.net>, 
	Bjorn Andersson <andersson@kernel.org>, Douglas Anderson <dianders@chromium.org>
Content-Type: text/plain; charset="UTF-8"

Quoting Krzysztof Kozlowski (2023-11-27 23:46:53)
> On 28/11/2023 01:20, Stephen Boyd wrote:
> > This link got broken by commit e790a4ce5290 ("arm: docs: Move Arm
> > documentation to Documentation/arch/") when the doc moved from arm/ to
> > arch/arm/. Fix the link so that it can continue to be followed.
> >
> > Fixes: e790a4ce5290 ("arm: docs: Move Arm documentation to Documentation/arch/")
> > Cc: Alexandre TORGUE <alexandre.torgue@foss.st.com>
> > Cc: Yanteng Si <siyanteng@loongson.cn>
> > Cc: Jonathan Corbet <corbet@lwn.net>
> > Cc: Bjorn Andersson <andersson@kernel.org>
> > Cc: Douglas Anderson <dianders@chromium.org>
> > Signed-off-by: Stephen Boyd <swboyd@chromium.org>
> > ---
> >  Documentation/devicetree/bindings/arm/qcom.yaml | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
>
>
> Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
>
> This should go via Qcom, but you did not Cc msm mailing list.
>

Ok. I was hoping to go through DT tree but am also fine sending it
through qcom.
