Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 791B474059
	for <patches@lists.linux.dev>; Thu, 15 Aug 2024 19:35:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723750560; cv=none; b=KbWZ7nfqEZTnHJICpv1fa6q3WGfDkKw/SmWRprm3oKgfsV+SsY9zobrtppqUx7YdjvltDec2UcjWhFbzuwIRxKV7eHDwZo9qi0FcMjNAOznioGZ8hKfskQ1cW64N8lYLl2B2ojnHbXOpDdM2eUqdW9neaj580Y8X074W4PhNJe0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723750560; c=relaxed/simple;
	bh=EKsx3kPPXwzdhd+E8N+BmlJsiSEoAZoQpsBQKM9fd7U=;
	h=MIME-Version:In-Reply-To:Message-ID:Date:Subject:From:To:Cc:
	 Content-Type; b=YGPuEHjr65uciElI4GNVLa6NbB67XUHz7iIIwAkCTrFOBbm58NoNI0GcnAE7q2PKRK86h5sf0FVWjHuYBllZTKSFZcXQwkuC54FGQyY1t1iS0x76uMsdUSyPjUMApTGeI927SKEdl6Yje00/O0gvlcmcKs5ZGze/crSys7iMggo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=cros-rc-feedback.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wBlWmkY+; arc=none smtp.client-ip=209.85.216.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cros-rc-feedback.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wBlWmkY+"
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-2d3e42ef85eso125088a91.2
        for <patches@lists.linux.dev>; Thu, 15 Aug 2024 12:35:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723750559; x=1724355359; darn=lists.linux.dev;
        h=cc:to:from:subject:date:message-id:in-reply-to:mime-version:from:to
         :cc:subject:date:message-id:reply-to;
        bh=EKsx3kPPXwzdhd+E8N+BmlJsiSEoAZoQpsBQKM9fd7U=;
        b=wBlWmkY+mnYNpU5B5SAbD5KUGuBuoIUZZ/pokbED6zYsH9FJLmII8hae4IqkXu0loj
         QlfchT6lOckoe0iYLl3l35ULRIT0CvSd0kfKcmZSFJd/Cph2lfUpI8mdXoXThWD1A9vj
         9OYvo14Vqy0GUmspu3S+dSTfSSrc0cxC5dG4kWcU6zWxM3Ze+uMFyyoZwI8LHLVOz9SJ
         2axUs74rUs7uB6YemV8ubWK/IV7Yi9clcv7wNcCgJSKlr9e06X9tc54ohbCjyMkkEWXI
         EDPjuXTDegDYZnRtECOzNrj+PVgmm0XtXQWiUAXO54Bcbh8YDTPparhZTTDrXpjm/rQF
         PdQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723750559; x=1724355359;
        h=cc:to:from:subject:date:message-id:in-reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EKsx3kPPXwzdhd+E8N+BmlJsiSEoAZoQpsBQKM9fd7U=;
        b=r7G7z6SQ2DGJ2CCOPq2sUbLy78lRr6Kb5okAWsh//QsE+B/u/QoZZ6N54ey0Y32zSR
         aWt6bmd63qHfZxuMPBL6+Vthm4z/WemnWKPZRW2QNFlPbDLqZSzp8QcC98R8rqjrSkcT
         lN5pJZfJkPOUNBa+mgTzOpz7L7fQOxQQrAf/t/51LFWUY+gsx4/+r6AAVveOD2FLfzON
         NfRNrBbYDrXHiXJx/DqnXg6PDyJ5o1qArGU28g4WccjlojryLt0b5y8GcQo49PFphtWR
         JcYUo8f8eRPRAgXYYS05LnUD4ExFdQweyXg4xm5eerW7Famh3hKBFF+QOV8SjlZjs03p
         Iwxg==
X-Forwarded-Encrypted: i=1; AJvYcCWD+YKQGzsfHtvZBRZygRvPc/DfgGDg8LQLdg73Czwc2Pf656//9w/oK/smOU1zqipm26yWMz9YAjt+2n4DqyYRUqHPuv2ZLQ==
X-Gm-Message-State: AOJu0Yzss1x1eetiSE4sm99FU4y7VBI5aDxqTuAsxhIgeLS+njbHPGx1
	oWW34RKWbCSaKxSL5NNxZYGtqP8csKT+BA5wmH34sRTW3y5s87qDESOLGYsyP5El4qURRZ/lSkZ
	8v7I3omj7DvXmEb1o/Rv2p5NS97gO3H/eI7Fr57c5ZvKr6huGjOXUFV73jXHyx5zMXh52zLSU0X
	SZDzkuQsQyAizIdyr/pm1aakZyhmV2
X-Google-Smtp-Source: AGHT+IFJ8ECkDnS3k6jLL8zhyaYh5sBo9rZan0khf2zhxhubUiLbYf5E8Mdgyd3AX7JdK2Z99hTuFPWJxxCSsc1t0GftFzbA4HHOdCdosaLvHrR7Qg==
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a17:903:11d1:b0:1f7:b45:f2d4 with SMTP id
 d9443c01a7336-20203e5e808mr642225ad.4.1723750558750; Thu, 15 Aug 2024
 12:35:58 -0700 (PDT)
In-Reply-To: <20240815131838.311442229@linuxfoundation.org>
Message-ID: <000000000000bd15a9061fbdf348@google.com>
Date: Thu, 15 Aug 2024 19:35:58 +0000
Subject: Re: [PATCH 6.6 00/67] 6.6.47-rc1 review
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
https://chromium-review.googlesource.com/c/chromiumos/third_party/kernel/+/5791538/1?tab=checks

Thanks,

Tested-by: ChromeOS CQ Test <chromeos-kernel-stable-merge@google.com>
