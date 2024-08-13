Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com [209.85.167.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4AC01990C8
	for <patches@lists.linux.dev>; Tue, 13 Aug 2024 11:37:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723549065; cv=none; b=GA936mn2jss0ps9lcvIOjTt6MfB7TDgZyhMeShpbA8OtPH6rA5Vvs35kcvCuecvx3Nr67h5LnyFnD06XqGUZfItw8oDGzT9IrDFKiRKWGxR1IShXLcRxL9eDA0UmFbY0PAyX2H08oaAs+ao17C2ZLHtayUSNKuHzO+N3mV5X7cc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723549065; c=relaxed/simple;
	bh=RFkO9YN6R66d5+iDA3PywDeqKm3aITZe71Gy4WVoXzg=;
	h=MIME-Version:In-Reply-To:Message-ID:Date:Subject:From:To:Cc:
	 Content-Type; b=dtf5wYTsuh1DplNk+6dTscVlqVsOB0ZHTihDWWInPtTdcLZ8DVHuhm8nyToX+AjPuHshGv7ieYjorHnvFEbwAdj05ptIXO0+76X9cC9lCyYE8uHCu1KLHKDyFTSXbs1t4PSj47/4T6v3OeaYfqs/trbwivYYR3Aa+rN4YVvH75o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=cros-rc-feedback.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=e2uIzCcH; arc=none smtp.client-ip=209.85.167.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cros-rc-feedback.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="e2uIzCcH"
Received: by mail-lf1-f71.google.com with SMTP id 2adb3069b0e04-52efd58cc5dso6553043e87.1
        for <patches@lists.linux.dev>; Tue, 13 Aug 2024 04:37:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723549062; x=1724153862; darn=lists.linux.dev;
        h=cc:to:from:subject:date:message-id:in-reply-to:mime-version:from:to
         :cc:subject:date:message-id:reply-to;
        bh=RFkO9YN6R66d5+iDA3PywDeqKm3aITZe71Gy4WVoXzg=;
        b=e2uIzCcHQQjK3OqZFx4FwL+3ZEWanfOLN4MLomByLF3tiwgEAgLM62gIqhGGKuBDss
         lqC/eoW/X8aB+3gChFWzcZQJwMDPDrJ1osv/MKGtPTOOomHaq7ciG0ZUCxLIu6PHjDNN
         vtenH8T1VTtm1KayPnHgr0ucKnE5xQ2M1+XAemnTp052MeAsAKWr4pH0QY+k/9Dl6FRt
         o+EmuobZJQy1VLOTorhfPzWLoSn5SmZwm3XYyvobaetxOmIXT/amQyXuErTsyoU2np8S
         KT8xNzGMuWZWUT0dpA2H9BqLjEfTbtsfm/WfGFg8jmnbo33IDB9MVqIw0BqwAbLVYbXk
         LRnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723549062; x=1724153862;
        h=cc:to:from:subject:date:message-id:in-reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RFkO9YN6R66d5+iDA3PywDeqKm3aITZe71Gy4WVoXzg=;
        b=nrDbA+iUUt5fKEKtyDVwH1ZI+CIKZE0VAk7mvWQun+ZZlMdECQDSfh+uEVntCxnkkl
         ukw6HpQx/cfZmoRM00R8mm51TGq2boDXSACgXr7RX+c/MY7TZ9/g+jf5PysWw28+5XLG
         nHKxGL5VLfceOfAmB9uRM6BWcIOja8CKQ53YoBPLKJZtZpggf3Qa39pmzZ2Qg2C/Audr
         818MEaK3EYJpQbiDziva1KzevYYPORT6xtwPw+PenX8X0NGt5Rsy10UITMSo0aVoPoyi
         EZr1Kjaw1im3uBeQORSQOoVikwVCuo0+Snl5F9PrmhOoVE3mb2mW6DafysXAWctGhr35
         wvSw==
X-Forwarded-Encrypted: i=1; AJvYcCW7GGnLtY9fCGee8ZN4oaPu1iSc8Yzrss2cH6IhoGyLVv5Z59sWw/gBjNh9Z9n7CYOiBiJY6mNe8wVDiG8u5TzX/MoHd9GMog==
X-Gm-Message-State: AOJu0YyeokOiWlLhFusQoHAa3AhgxP+S0vlWydT5sgAm4nRhZOkJBIK0
	AUYwccbLDaWbViw3FJDLjCCDOLlT5Ej5i2uB5anbhK3Yo7SbsdtIQqEmh96e9gjSBv3UKZYPboV
	UwhYNt7iGDQYvWerwFhbhiKy5j+0VQVmwK4JSjdtY6bxlLSn2NhIsnp1CgZr+5SccPUZfoR7l+U
	lPmoAjJFsr3kbk7OpIxnZEiLcGhnyr
X-Google-Smtp-Source: AGHT+IESDKeJuvd9ozQ8U27FEoLn6cGLk50ZCbxJaBKb9NzZBU4rWxB8rxUromp5TEQJ3k2AWNC3KjxvCzkmDL0ThI1D6oyaAlvfwTZmDa8EJxvP4Q==
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6512:3b0d:b0:52f:c782:d9cd with SMTP id
 2adb3069b0e04-53213649fabmr4071e87.1.1723549061729; Tue, 13 Aug 2024 04:37:41
 -0700 (PDT)
In-Reply-To: <20240813061957.925312455@linuxfoundation.org>
Message-ID: <0000000000009420ba061f8f09cc@google.com>
Date: Tue, 13 Aug 2024 11:37:41 +0000
Subject: Re: [PATCH 6.1 000/149] 6.1.105-rc2 review
From: ChromeOS Kernel Stable Merge <mdb.chromeos-kernel-auto-merge+noreply@google.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, chromeos-kernel-stable-merge@google.com, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, 
	broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes

Hello,

This rc kernel passed ChromeOS CQ tests:
https://chromium-review.googlesource.com/c/chromiumos/third_party/kernel/+/5782314/2?tab=checks

Thanks,

Tested-by: ChromeOS CQ Test <chromeos-kernel-stable-merge@google.com>
