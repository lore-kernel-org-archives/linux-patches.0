Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com [209.85.221.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FFA713B7AE
	for <patches@lists.linux.dev>; Fri, 26 Jul 2024 09:36:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721986571; cv=none; b=XchKoGIMjJtHj+rFocGmYEKMyKy8AvUFpk4ksmPHLHEsSjlkIQaRkAEWZDVlyRTQSBJfQYwZEk1Zedcwadu9er+AAoqKJ27++7nWwl8m4lI+cF/AvVJs21PvbencwyTwMW/WZ/2LTEi1S4zjOZRzdDIO7VGkuzfqU9ZdVnE1YKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721986571; c=relaxed/simple;
	bh=ZM4ZHJ+gLc4NGQEezhgfCtyM1nPFEMWwQ+B6avDdykk=;
	h=MIME-Version:In-Reply-To:Message-ID:Date:Subject:From:To:Cc:
	 Content-Type; b=LeoVw4m+w+EHT8UWbutHtvjq1tF5DFq8o+GfxRlVFJxe1vP/oOU4hfyu8ZpjkyjAJjokmDC19U6e5jSuT2GJOuU1RiE0Y+dc3Ur2iAJE0AuCLAkLBeTlV1tXO42BMySzEmlBVJy0IFWAh4hP9LJm4eTtjTZcB9NNvmdKsQ4R4qU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=cros-rc-feedback.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kGZmZGs7; arc=none smtp.client-ip=209.85.221.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cros-rc-feedback.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kGZmZGs7"
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-36875698d0dso1167406f8f.3
        for <patches@lists.linux.dev>; Fri, 26 Jul 2024 02:36:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1721986569; x=1722591369; darn=lists.linux.dev;
        h=cc:to:from:subject:date:message-id:in-reply-to:mime-version:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ZM4ZHJ+gLc4NGQEezhgfCtyM1nPFEMWwQ+B6avDdykk=;
        b=kGZmZGs7Qaa83uqm/Wactt64uLh5xcQkijIj1Y4NeF7fHv2T3nLCaovZNHB3Dh4Tpi
         VctieFqkuwC5gTw1gOSVZ+mnxacDcUo0Z+JdFNIFm354gpon+MbEar7Q7hPmVymyPlpU
         8PvwqLkjioI5fcJcRyRubSmevfTdDeA61sGlvWgrKby2b0v3okHB9n0WzrHbN9b7IvBZ
         nLFQnNWRsEGjTnCB6yLKBCP1dcselsGhpsxIG7TNErPsZsTiXqbIw9N7QVvJBgjioSb7
         Ofn02PemTP4RNqg06g9Grn0NfB9MqD7sr0OLJHJ+xb7qNpXPpKaCqkBCXUlu4VHBOf+E
         NoEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721986569; x=1722591369;
        h=cc:to:from:subject:date:message-id:in-reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZM4ZHJ+gLc4NGQEezhgfCtyM1nPFEMWwQ+B6avDdykk=;
        b=FRluG7JBVR/SvGvg6IJ6NmHOI9LYi8FPkNdsndMtMSqCKuzrboHgK0n0TkSt9nh1bT
         CuX5y0Wz8XTcM/6LLHsUDAut4V6BXHAeHIctKFqCwIEiZd2mQcbWUJ9S7Z0jpldaYqsG
         STvQehASW3bOYf8XlTQ9xCkKXvsQVQHS8em3sVdGA8gyk6YoMQQdXz+r7LSEgwHmafHY
         5u8zKUNMVRFgCjsT5rvKu+xDesfeyC0QEB/rMxQn9dStgpRrznl4kVglX+mY1r1fHwCj
         hNcv3sSStdU9kZEWXQ+dA5kernI0ye9pRNyqzMs1pcxItEhN+kwU8PWSPV8ZHItLhVaZ
         vdQg==
X-Forwarded-Encrypted: i=1; AJvYcCXRGuK6deoSvPDf7s41vdS38xguJ+TbAWa8hMKmVwvIfD+M+GbN1DObXWZtZfpdw/ueS91fTkqq8gvpVtB+lDgrqIJTnxva5Q==
X-Gm-Message-State: AOJu0YzQADbBb2UeTmjZ5RLCxbcKVl/vfAnkvZp4GGYRa0KMVTe685ex
	wUWHfROUhl8MMHi9SfLPrR6Mk0IcmNReH7ZKKus1VSCvhpf4inajMwfxWhET3XfcFTHkhr92nPJ
	XWmJw0eyT58UGqKWoUKdcbS/1yqb6QE3I9YMONlC/W/klrv7U8XDS5sAH7H0Sc8U8sWawe00b89
	X2WF/UnQL/ZZSa7ThwqpuI9d4e2lbn
X-Google-Smtp-Source: AGHT+IHeaC9wwCYLg75NtyF4Q156l0440NtvZq2b2MNU3GCWnyeOj5qYUftH/nDa8eRxbtxE/5yx6yU7o97CTYHZu9WeoXtBq1Ux+4+E+1B7jcpgeg==
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:adf:fc4e:0:b0:367:9450:5075 with SMTP id
 ffacd0b85a97d-36b31a01648mr7732f8f.2.1721986568547; Fri, 26 Jul 2024 02:36:08
 -0700 (PDT)
In-Reply-To: <20240726070548.312552217@linuxfoundation.org>
Message-ID: <000000000000ba629b061e233db2@google.com>
Date: Fri, 26 Jul 2024 09:36:08 +0000
Subject: Re: [PATCH 5.4 00/44] 5.4.281-rc2 review
From: ChromeOS Kernel Stable Merge <mdb.chromeos-kernel-auto-merge+noreply@google.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: chromeos-kernel-stable-merge@google.com, 
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
https://chromium-review.googlesource.com/c/chromiumos/third_party/kernel/+/5741618/2?tab=checks

Thanks,

Tested-by: ChromeOS CQ Test <chromeos-kernel-stable-merge@google.com>
