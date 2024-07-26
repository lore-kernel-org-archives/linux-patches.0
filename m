Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com [209.85.218.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA004812
	for <patches@lists.linux.dev>; Fri, 26 Jul 2024 17:37:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722015479; cv=none; b=QwjrxOL1AzVoRJCyQuP5v/5cKbDVsRNesO/ypTtvbN/8T0vFDNMG8704Yj8Hr8P5T2zjNN6nXfzsHjmr6FrO3dfa/8zoZ5HVMCaEq4lMJBds/tyvc9pGCEh4ARz2BzNeShliyll+ZdYBwROIZZQjgPfZkNic8UPEW65xIG/tVFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722015479; c=relaxed/simple;
	bh=exyr2urXJ6n3knu8k0x1oCIysPMMdHmOl7GXDG3TDD0=;
	h=MIME-Version:In-Reply-To:Message-ID:Date:Subject:From:To:Cc:
	 Content-Type; b=nBIdd1MK6MPrGHG8rpuojcXM8mbgH549YZCDfp+g0f2CW9b+Y6t5vx79OrTw+C9dlvaMkgrPpL0Ch8kIPgLir+RlF4Y7uLj21/BkHvS6bDj/hzTwSyPFJDGAwfloElw6IZdnf+Bk1Y25HhwIcsUfO2po1ETD7vjo+U9SNGy0H/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=cros-rc-feedback.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0ANp5f5W; arc=none smtp.client-ip=209.85.218.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cros-rc-feedback.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0ANp5f5W"
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-a6f571c3eefso113790966b.2
        for <patches@lists.linux.dev>; Fri, 26 Jul 2024 10:37:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722015476; x=1722620276; darn=lists.linux.dev;
        h=cc:to:from:subject:date:message-id:in-reply-to:mime-version:from:to
         :cc:subject:date:message-id:reply-to;
        bh=exyr2urXJ6n3knu8k0x1oCIysPMMdHmOl7GXDG3TDD0=;
        b=0ANp5f5WlSOSo8TCrtMey3tHQcjmLl5JDnyoBbdOSii0TOetOOMcf3xzoWmYxOQeAM
         vQgbOlIF9bbD8W978YYTuk1kaNJEdS6ZGexfm6x5IfPIUByIIh/0yJFBp4IFe3hf5p2R
         i5ZcuqoFPjmqphn1I//9Dp4zpRZ+/h2+CCImBhJu1CxORkVo8TdZiv76s/ExXqYSFcIO
         eEYmWpvesxv+hQDqANE+usdrKft1JH9vckRU/fb0wDZgBcn96x9V2fOZEE3eFv4AJw47
         gKxD3IobLpTnAyhwAyCtk11ye20C62rYWm59tNXCGbVBbe3ARKjCECz2FbPW3Y9349mq
         6hPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722015476; x=1722620276;
        h=cc:to:from:subject:date:message-id:in-reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=exyr2urXJ6n3knu8k0x1oCIysPMMdHmOl7GXDG3TDD0=;
        b=vEoECcFf+BkpRiNx9n7pDC+BZShIQvryqV5nDYgW5IVR7A/YOZg9FdShiPP5s7F+LN
         3XP+4J/RIk3JeB2GoRZX0zRby7KNratiDFUvNZ9Rl27XVDoY/3m10TedaRF8J/ZUEMoj
         C8fidzCa8PSW51EDX1qJoUzar65SpPbtn+5RL+1j9fo55Qk4K3ifkbDrUQtFRYoJrNGH
         sq2DZhjfLf+yBBtwgpLjF5WeQQaeAZMz9fOLr04WsGbsNl0gbbRVkrIAfDlWb/sORF4x
         8bXpkS6GAeuJsjsUjik2zCHHp+ryXHnj6RbahHzAtMFF0+xHIy9G9CwIVuQjdC3ZIJxJ
         Ko+w==
X-Forwarded-Encrypted: i=1; AJvYcCUCMS7NtgHD499SAVNUrPlXiZjC516KS1QAhkvTuYZfLTOEcT8Tqx8Sof6POy+DgM5RPZ5vq+MgDbAibKo0ALyNrn9E4DPv/Q==
X-Gm-Message-State: AOJu0Yw3wpUrdQbMKhNCrxdgxjkb7zbbWQfgaai5AIXadSGIr4QqBWUj
	ta2CyHMZ6iVriDPAPOmDYWCliyX2RNO0Ce7BHsAiit8afHKTHZy/h0O6VhxH6B9uSixGJj/qLTT
	ZuancDL78v3EjkevIcYr+7q4dt4ZqDdKb9LBSODH4hw/38rJyf73eHYrzAPzdMp2QqVakCp4/+K
	ZLp9qM8INvlkyennrYj0SInlf6aOk1
X-Google-Smtp-Source: AGHT+IE9uzvnGRXdyio4CndbvknOEHpu9E6kH265i5hAfJKMOQgkPbIDZAgCzsAUGbOpV2L4CEUpKcY5Vc9HN3bO01nLGsr1DvQZmob8lKydOuHejA==
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a17:906:f28e:b0:a7a:8378:6265 with SMTP id
 a640c23a62f3a-a7d401d73e3mr9266b.8.1722015475784; Fri, 26 Jul 2024 10:37:55
 -0700 (PDT)
In-Reply-To: <20240725142728.029052310@linuxfoundation.org>
Message-ID: <000000000000bbce5e061e29f861@google.com>
Date: Fri, 26 Jul 2024 17:37:55 +0000
Subject: Re: [PATCH 6.1 00/13] 6.1.102-rc1 review
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
https://chromium-review.googlesource.com/c/chromiumos/third_party/kernel/+/5741928/1?tab=checks

Thanks,

Tested-by: ChromeOS CQ Test <chromeos-kernel-stable-merge@google.com>
