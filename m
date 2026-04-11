Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 076A221ADCB
	for <patches@lists.linux.dev>; Sat, 11 Apr 2026 01:28:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775870910; cv=none; b=iPGM8bpOsZW9lexP+Xs8LaRf5EtFPpEwrA7xPIV5mD1d6Y72txgMrt4LWRGTd0QlqlFhTkr/Z979ayprsCnpIkjOBtUaewo+VAtBswAtoMefmFZQESCr4u5VqS7bYV6a29LM/1Kbqnvox5uYV0awSwYEWYHNcFZPQ+g4RUEAFVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775870910; c=relaxed/simple;
	bh=QBESViLoUMaOvRo3YjwM21rRh/6OI+lAc8gz6A9NrgY=;
	h=Date:From:To:CC:Subject:In-Reply-To:Message-ID:MIME-Version:
	 Content-Type; b=Wp7mGHtgRSMM4GbxzxJJk85W3/0kwnFhb2FuM/m5Rvf6ltpZlYCjU5GJgd+gqJ1sieE5ChB06yvuNW+vhRxS1neF+QyUBXVk6jUfEp9zxaCmq4/sUd0rWEc5H0EG5BG77siivyUC1PU+Ulf6OKsX59tYmmHisas0gPWXM4pwEp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=m2hHjnZs; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="m2hHjnZs"
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-43b8982c2f4so1562846f8f.2
        for <patches@lists.linux.dev>; Fri, 10 Apr 2026 18:28:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775870907; x=1776475707; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:in-reply-to
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=QBESViLoUMaOvRo3YjwM21rRh/6OI+lAc8gz6A9NrgY=;
        b=m2hHjnZspQaQRw+JjfKxzvlIssFpXZfzIFSGJs4gyfsTObZWrHPVwUYRMwofXxhXid
         s/NrEZu3niHKqimnkp/epl1g8Ydu2gS8luQv7pnXLnVtcqNOAWqD8eaYsyGTGJ7H3SLK
         4NnnAj/FYpxM/GLgaU/R7J+02GAfc/HzayZQQr48c0zoU6n4PY8ldp24aB2FYwBqk6XO
         6tBgrJefo2rIFiRQaqXoDQ6BmGQFAyIhtB4OflY32tkrlMWqhggcpCoVZesJEJJ8YF11
         5iqX8ea7a6laFcaYJjlvF4bf45XH9ZL21iq35u4VaueHOX54jWetHrECfR6SIXfO9mWN
         +QLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775870907; x=1776475707;
        h=content-transfer-encoding:mime-version:message-id:in-reply-to
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QBESViLoUMaOvRo3YjwM21rRh/6OI+lAc8gz6A9NrgY=;
        b=gXJUrpubYirYTbZ6UCKK9IXUx9e5SZ/LAcX2XuUTwlSBQkGAwHf2M/+7IrqIvhu/P5
         U8vFOrRQdShud/vtu6wB31BJ9FelGow5ovH7/FpKYbiViECTgcM29+P4Wr1BsscxzK3h
         iQ3J2gRSslmLTC4fWMdpYlIxOShD/Y3VHpb+Rr3YrSAc3krGTQwCO992SaCw3fVxT32O
         6a7JKaFrpo/eYuhcRGpSq03jQyXGd0OspF0fdNwUuKVyr+4Eqk/rrVn62mrWR3qZUDXX
         g8EIAeJHPkofxmOrqZj8P2KQRjEjHWOqsRpVQqaCPylzv5pmdnzeu3BFmhX/uiyAW4FV
         v5Hw==
X-Forwarded-Encrypted: i=1; AJvYcCVWUUdAOaKYW8Qnm8i/REk//GWCqsTKPLFxhgdPzearxYocEPKTvXIXv8JsKqZviQgu2n7rhzB8@lists.linux.dev
X-Gm-Message-State: AOJu0YwDHp4haSieCX+RfwOFaJp81sZgQvahPAxNiT98/sA85WV/Bbt6
	rR2ysZy6vLSDVHJtE7RRzqsBLAGGgh+5izx5v57kpSKZ/DkgxdDgM6zw
X-Gm-Gg: AeBDies5A1M1UUvg6qmRTSdfIADCqeb2pnWIw4aK1h2UA5xp9+JV6LjqeMdyHtLE3hY
	JTugKYKdJRL6/UtlU3j4JlwhUx+pokUEHxzGKMYv2bWTZV2WyeTjRpi6jxZMfVligiDobg6/rN0
	8D0jzR6hIb+S4P4jA08z7livuWfLImTYJZNuky/cFOgbFc20lHRoQSfYZNOWG8HAm9w6x7G6fei
	cdhDFItIjw5a8SrpEsjXYLkyDOD4jzMpJDbyGUlbi5EQPp4ODs1DIwzUpaFkXP/rupMbD2V9UA4
	S1vGV8YFSz8hSmq3sSZQWyqwNsw+vzIA27IR+dNddo9YWl9EryP5ebAEy/3UdMJlEUSS2Lp8+L0
	QlA+ZIKYh863DUpv2TVnR8+FVhkgczhQZ9+WRaQ3UIL+onOkxKcq2ssICySt8Z1XmEnn2gSsrBv
	YDgZocHu0h+WvnB9NZi9lCjMtRBhkHEPaK1FreaZUcMl95/P+4JHU=
X-Received: by 2002:a05:6000:2211:b0:43d:2fc7:4816 with SMTP id ffacd0b85a97d-43d641e7d3cmr7775174f8f.0.1775870907203;
        Fri, 10 Apr 2026 18:28:27 -0700 (PDT)
Received: from ehlo.thunderbird.net ([86.1.69.5])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43d63e468c5sm12268373f8f.20.2026.04.10.18.28.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Apr 2026 18:28:26 -0700 (PDT)
Date: Sat, 11 Apr 2026 02:28:26 +0100
From: Josh Law <joshlaw48@gmail.com>
To: barryn@pobox.com
CC: achill@achill.org, akpm@linux-foundation.org, broonie@kernel.org,
 conor@kernel.org, f.fainelli@gmail.com, gregkh@linuxfoundation.org,
 hargar@microsoft.com, jonathanh@nvidia.com, linux-kernel@vger.kernel.org,
 linux@roeck-us.net, lkft-triage@lists.linaro.org, patches@kernelci.org,
 patches@lists.linux.dev, pavel@nabladev.com, rwarsow@gmx.de,
 shuah@kernel.org, sr@sladewatkins.com, stable@vger.kernel.org,
 sudipm.mukherjee@gmail.com, torvalds@linux-foundation.org
Subject: Re: [PATCH 6.1 000/312] 6.1.168-rc1 review
In-Reply-To: <be550d5f-a5bc-4cab-aa75-1c7481ba39c8@pobox.com>
Message-ID: <6F70FC25-AE09-4A97-9798-D1CE49239B00@gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8bit

(Compiled and booted on Geobook 1E without any dmesg oddities)

Tested-by: Josh Law <joshlaw48@gmail.com>
