Received: from mail-dl1-f50.google.com (mail-dl1-f50.google.com [74.125.82.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90A5B21A459
	for <patches@lists.linux.dev>; Wed, 25 Mar 2026 01:36:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774402575; cv=pass; b=INPsuvATrkG1ecV4mde4FtrpMS12fp9VjN5f6hHmvjggpt6FKOTiZM+cQW/lVMPG9M32XSQ2czWdU9MwXuYzxXkD2Bp/Ago69MMRXEqCUI/GF5HdGnhiexmqLM0QrrFoHmhnl5VlSoHl3WG1SvM6dLogMXMFXh8wdaHenikQ1U8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774402575; c=relaxed/simple;
	bh=0okK9xoYyd+Y7Hl9zukJB+XkCExB+thImigrJn9O0Hc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Y7Y9+wjO1ZxysrK49hZeMz5UaOoYg78Q4IGhlMv8lO/2y6GxjSdIz7Ses84boUaDv0ROopTfheI4Yvtal4fxxZ8lFlNOBJriKrYq7lqRas4dC4pr4gYcXYwFJsr+yFA5wNM3T3h7siswDcjYzMOlS9awPp95f/rd3XoS3271GVc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DkGnuwyd; arc=pass smtp.client-ip=74.125.82.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DkGnuwyd"
Received: by mail-dl1-f50.google.com with SMTP id a92af1059eb24-12a70b4de9bso275279c88.3
        for <patches@lists.linux.dev>; Tue, 24 Mar 2026 18:36:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774402574; cv=none;
        d=google.com; s=arc-20240605;
        b=h1UFk76HAW3DOcIW80Rs2CaXyQtPLEYk74ICD+LNcn/mYf4at7oA4hYV2HDug8pOEk
         aNd6gH4Eq5FMEaQy9c3MvfaN0TuIpuybsd/vvQvolXkgxoYWyyNFg9APmzJr+wdaYwmV
         1dxKrYSjl3pJyzNjRmnWfo7Asn4DMM72frYdQ00692Nbi7D3otjmmATam/S/fQTxsW5v
         ury60dG6KhReE3EBPsKMNTBLUHAl6YDHOGolLp9Z/ohYOj+Dfl+/pnensd0tabE8XJnr
         sCtEQ+GXu8fjktCExAe0vGwhGAfGaZ0pxA5iAPDOXR5xNoGQKyY+tp86GMZtKnNcY674
         U+xA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=0okK9xoYyd+Y7Hl9zukJB+XkCExB+thImigrJn9O0Hc=;
        fh=whaLCtbt8vbEnFWw3ijTbT1GvgFWdyvka+0IlAp5rUQ=;
        b=AChZmyTf9PciXZege51exnNJP9UJo2kgJVNKmvjYQ3RxlMuLS/SzxtIvpPH3Tln2IE
         0WnvtvAUd7i9ihLksnl5UjFyrJe4dxJ4hHDOuAdk6w/BiJenHMdbXi/Aburwz9+8CYjM
         63xAV0xfx9tRoa1oj25GC5e6CnX97ZvqfEeuKjMEZV0FjJv5noBUO5fTFZvSoCmXbJAV
         Xb8HnMYlWjWlAlz74GoNpNIFPhE7FRXEUfEAGSXFwiwihwdjcxnzpwRfbBp+OTLYkY3O
         HR99N5uq1iBkdqOawROgsC+mO0fb/h2bURWtS6Iupiji/1VVPeEyBP+VhkERsdts59jZ
         i0iw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774402574; x=1775007374; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0okK9xoYyd+Y7Hl9zukJB+XkCExB+thImigrJn9O0Hc=;
        b=DkGnuwydHRirAXlYu5thvI7984Srsf7ZQgX5MTFzc3f7EUYNz+nzP2FJgTnr9DSEQh
         YXwJu3b7MKfJNU+OHqIzKF/AQLfXCYQViu+MiZWYQEMH1H6U1gz6m87MEurZpwfP+DEf
         36IVTh4CQ0Rs4zUvbuhu9Jl2WCoT4lZ/c/vbOorYzbCb3FxPrBMuKKd2igOgsz7wwGFK
         u8WU30IUrtTPfVXQY5we10RmZojP4ppqUGeT4gXi8X6IgZKhV6pVm0fvcvjH+0Djm25y
         Ln3e1Rq4NumVY42SshDlqx/PkYxgwawntPTi69ld2F5ErbPd+J5R0jHiKgoA9PGtT8vC
         sp1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774402574; x=1775007374;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=0okK9xoYyd+Y7Hl9zukJB+XkCExB+thImigrJn9O0Hc=;
        b=TbAvmQTpdh6lD/iWVGtZ+Io3YEitHm/OEkL6tG5s5+fdMGh/YN1JWarJu3EhcOHof0
         G07cNeWAJGIH6j2D9kaKhu+WyBEtlRZiY6MQbQ0zCM+QnduC5sAz78BD7OcVfYpnWQgJ
         Qf58j47TGs2+m42v4cTcsh6Lq+Hcz1dJTKMnLPfQDfGrBFoZ7DNGo8P+BShuOHCR/Yyj
         8WnCPgyoWy8rXk4M2UbGShowp48lGqvAwwV1ZSrbXBlXjE/9mlexWwB7PfkHsyCMNw1I
         V6qMgqEGc1pYzwL7x1CqrWm2arriovVrYZpWl80A1aml+2soFv7r95UcLVMg7jSKZEZL
         GrTQ==
X-Forwarded-Encrypted: i=1; AJvYcCV4qtYEqUlcKTxkNbTq98XOxSHrlIwA1tqciGvu/Gmjf72mymyEu9OS6yrqJ8rAHwhchKBZzcvk@lists.linux.dev
X-Gm-Message-State: AOJu0YwFgpZ8VqctFU6+z231NUr6V/BA6GuD3fGitRZDT15B2/04SBS1
	H2otJIXSWDN9SmDywG9qLLyiEmQ2rHhmtPZKv8TBHVjkTK2EECyk1li5wljz9v++K57KfKt2qRO
	i35lDURJHCKovDxxUdGA3fxvBwTkjjUg=
X-Gm-Gg: ATEYQzyTZuxffSBfJGAWsSemHyQK73D+M/p2a4fLmpyZ0d65jOSFBigRlw55H6/EaSC
	Vh3mZplUIVShUdruWat4owzN6VqUkemqjShh9FcL7gk2ZdikpAD1KZmrsNLjaWcT6CSt4x4EQay
	23Y0St72jWbtRnj0fDrKHy+f9GaZ0+uenawQvIyBLZ+HK0YK32Pqe81M3NrAwpI9XRzjpBOuJk7
	P4DcSqgOu4PPQVxKZXApW5didr6oDXPBerw0TZyeeiLabgRui2brmlru4/AwrvcEmMVr+i+dXK4
	ul90U6smNxZfvZA9tS56MnhylDIqF/0c/KWq9P+H2XukA/olqC6lA/713p0PGVLNBuzqj5wJeY5
	ikwSQnDaRmCNV4OjVI+veoZA=
X-Received: by 2002:a05:7301:4e0b:b0:2bd:db75:c28b with SMTP id
 5a478bee46e88-2c15d4125d7mr343033eec.7.1774402573473; Tue, 24 Mar 2026
 18:36:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260323134504.575022936@linuxfoundation.org> <20260325013447.66771-1-ojeda@kernel.org>
In-Reply-To: <20260325013447.66771-1-ojeda@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Wed, 25 Mar 2026 02:36:00 +0100
X-Gm-Features: AQROBzCWO5qPV_1hDuoqGflZm9Y9d8dfbSYWlGNb2lHRGldE_-fw23LWI6Wqy8o
Message-ID: <CANiq72kdozG-2_VBaJyg1SZ1W9s25-=3+ER_qkYAX72avDJ9rA@mail.gmail.com>
Subject: Re: [PATCH 6.19 000/220] 6.19.10-rc1 review
To: Miguel Ojeda <ojeda@kernel.org>
Cc: gregkh@linuxfoundation.org, achill@achill.org, akpm@linux-foundation.org, 
	broonie@kernel.org, conor@kernel.org, f.fainelli@gmail.com, 
	hargar@microsoft.com, jonathanh@nvidia.com, linux-kernel@vger.kernel.org, 
	linux@roeck-us.net, lkft-triage@lists.linaro.org, patches@kernelci.org, 
	patches@lists.linux.dev, pavel@nabladev.com, rwarsow@gmx.de, shuah@kernel.org, 
	sr@sladewatkins.com, stable@vger.kernel.org, sudipm.mukherjee@gmail.com, 
	torvalds@linux-foundation.org, Gary Guo <gary@garyguo.net>, 
	Tim Kovalenko <tim.kovalenko@proton.me>, Danilo Krummrich <dakr@kernel.org>, 
	Alexandre Courbot <acourbot@nvidia.com>, nouveau@lists.freedesktop.org, 
	Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>, loongarch@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 25, 2026 at 2:35=E2=80=AFAM Miguel Ojeda <ojeda@kernel.org> wro=
te:
>
> But 1) this is just for loongarch64, 2) Nova is still being developed
> and 3) it is just for 6.19.y, so that is probably there was no Cc:
> stable@. Anyway, Cc'ing here.

And 4) it would need backporting more bits or a custom backport.

Cheers,
Miguel
