Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com [209.85.160.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2C8C1AD3FE
	for <patches@lists.linux.dev>; Wed, 31 Jul 2024 13:35:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722432960; cv=none; b=VNSyPHVzIAh5XAQI3Ob/Sm1vhM0n/Voebiqo1BYb5MjRZ/pT6FLAmqvjBuws4DaACWbYoVGT8Q+qek01DBA1DxVYAnLTZD8cgeFVdCfMx2Q2amNav5yonOtLlMZvxh7JFlS4TjHVBMYI97xL78QW12hYj61/7UPFX9LXOr9G4UI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722432960; c=relaxed/simple;
	bh=qOCuUCjDa01qrpQPVsHZAJ8TDG9ZXCWuRb9wPqL63kw=;
	h=MIME-Version:In-Reply-To:Message-ID:Date:Subject:From:To:Cc:
	 Content-Type; b=GSQjwMtulPL0Me/P6RsWn8whPzMJQv5gcHvUtQuXghqmvvEr6ZuHl6kn6baQmD21QlhJ5OGVOTWNpsXw98/JIVM3qu8nsWPQzA6qllk7pCyPgvYnS5AUtHBneKj+YYOVMQLUVPERboqu3UhEXNsFg2A1GQaK5mgezwJE1cyMduM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=cros-rc-feedback.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RMt8m5BH; arc=none smtp.client-ip=209.85.160.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cros-rc-feedback.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RMt8m5BH"
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-44fdd39f503so77623471cf.1
        for <patches@lists.linux.dev>; Wed, 31 Jul 2024 06:35:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722432957; x=1723037757; darn=lists.linux.dev;
        h=cc:to:from:subject:date:message-id:in-reply-to:mime-version:from:to
         :cc:subject:date:message-id:reply-to;
        bh=qOCuUCjDa01qrpQPVsHZAJ8TDG9ZXCWuRb9wPqL63kw=;
        b=RMt8m5BHlQfsXq0XJqRedns9+0yyFkvsYCT5AFwCtGNApZ9IByfuanFKFwKYDo8wOd
         vu3/LzI/b+ICnUgxr6ykNYmPbbXKe8kKn17+taYYGSkexA+idfl3MeSfNpiHthqpA+qe
         aEQP45luILX9KIgiBXMSYDhl+NpTAL5U7VQhnQ7qHLFIYx+suIlvwphqbiTF3vDjVpxm
         MHVVIVbQe4ZciI0n0hmy+l5/aVTm6mEbTpdqJfotdmb9gFbAAiiYtOAl543zapD5hu4w
         oj2NmSOjnuVr4VOp2Ex8Bh6SSyzpBIJKKKyoNr5lNzSLRewuhXGCZ9uVM7OJYl3GCaK8
         SMpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722432957; x=1723037757;
        h=cc:to:from:subject:date:message-id:in-reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qOCuUCjDa01qrpQPVsHZAJ8TDG9ZXCWuRb9wPqL63kw=;
        b=bNCpoB+g2GG8b5Vg59ygQ0HelWysv/fw3oiao/amu80+qkPaARqobxHFmUk6OaQcdb
         lXe1muqcHqVWuzk9ocww2S64sim6IQ276TFcM2H8OnptDpXr2PhbOK8m3QlpfwuIrEvg
         FNu0Av7phnNdeQDUz2X2/9GxGljfrJ794YdQTo5PITIpHpEAhsSMszyhaUZn+XDhwObZ
         TMTxhmMtjE7PzyL4PMHGieWYMSVEVE/Jeqg2ATZoCM03akCD4lGyNi/nvOUQJVTP7Jlo
         NjdMy6A1IfcIpxL1AFzrS2kX4+QzuqKIsiuIoL8mcpei903lB8Usda1XNTQjWSnh7UJu
         bj7w==
X-Forwarded-Encrypted: i=1; AJvYcCXdYy9XGWtlRO2FyYoOBGe9MKjYrMHD0PUZQuWJ1eRfHgqdM/FDv140sI09p2TJ7wQfKrFFnjscyUTzxiHKsXc7fYlKGyie4w==
X-Gm-Message-State: AOJu0YztF943DE26NtdU9BC3EpkO/XOOOectzYMb8DDftsNc1pUp8PbR
	pgurWqrrimFRtsWvd160GKqxcMXymKl/5KQUgzpO49RbJ4EKkAEZaorz5SQLi27zjkz5d/CGdnD
	4fl6RdGhwqCoXxYJTC2XsPHF1REoqMscAwOFle9hiC65XifZcQlVWQ9yzdK621lJrIm9TK68PbW
	Te3NXAM7KySoYJfk0cnE1E1iG2cvM9
X-Google-Smtp-Source: AGHT+IGWQLOsj9e67I7wAnpY5tk0JctO1HFZsGc4PQ0UMNwYFPS3uswrfoupdMjYCde6RiUpYpqpQcV+PgeNkBDKlzAPKWXlbspOfjZSvUGPDKGYCw==
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:622a:8b:b0:447:dc5c:fc62 with SMTP id
 d75a77b69052e-45004d7886amr260521cf.3.1722432957505; Wed, 31 Jul 2024
 06:35:57 -0700 (PDT)
In-Reply-To: <20240731100057.990016666@linuxfoundation.org>
Message-ID: <0000000000009550b1061e8b2c60@google.com>
Date: Wed, 31 Jul 2024 13:35:57 +0000
Subject: Re: [PATCH 6.1 000/440] 6.1.103-rc3 review
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
https://chromium-review.googlesource.com/c/chromiumos/third_party/kernel/+/5750061/3?tab=checks

Thanks,

Tested-by: ChromeOS CQ Test <chromeos-kernel-stable-merge@google.com>
