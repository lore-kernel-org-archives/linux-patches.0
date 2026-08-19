Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE5AF4322F6
	for <patches@lists.linux.dev>; Wed, 19 Aug 2026 09:17:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787131081; cv=pass; b=RdlQQfgX1DkakDgugTCC5LwgCey7FcoLlc3SDIa3Xzu+O2p/osAazWh2Hv4at/8EnL2LVWMsSX5Blqu9sl2VbPwoWm/S7KfkakVN7R1Wxs35PtbMhP4FBlbZ6xBXssRLHdy/et1nptAKdSVTLkGGk0Ck3qQrlc97s9O50cCHz44=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787131081; c=relaxed/simple;
	bh=kVzk6H4/xbY+K1aXAI3iqSMLKy1QzYUGKLXPF6MwLSc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GrW0BI4aQHB1exYnqiSkAaElotXu0NMxWzMIOwCO3+ci97oJn7Pfqxdi90tTAWG2GxAggdpnBL62fgk6D57fK4CJZYN+aMfMBxNj0jPqbJ48KHvfU/p2nghlyTRvsv7HswnqmbN9woD0sMwqq33LdbCxX3xdKvDYaJRRs6d+Su4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rajagiritech.edu.in; spf=none smtp.mailfrom=rajagiritech.edu.in; dkim=pass (2048-bit key) header.d=rajagiritech-edu-in.20251104.gappssmtp.com header.i=@rajagiritech-edu-in.20251104.gappssmtp.com header.b=qmi8kOde; arc=pass smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rajagiritech.edu.in
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=rajagiritech.edu.in
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rajagiritech-edu-in.20251104.gappssmtp.com header.i=@rajagiritech-edu-in.20251104.gappssmtp.com header.b="qmi8kOde"
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-6a3efa2b38aso1328557a12.2
        for <patches@lists.linux.dev>; Wed, 19 Aug 2026 02:17:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787131064; cv=none;
        d=google.com; s=arc-20260327;
        b=n0sK/P72Nc1YGrp4ahim8f4y9dGJfu5zND1Eqqbt7Pz2zsupFIf/QOJqFR7eUMp/LI
         2LatYWX1O+FKSlAhZSE3aO/YL9Hpo6zs+rY1j1wPLThWBUSEu+mpxTOgX1N/vt98i8PB
         sgId3fK1IKfuh0hR+vGnbfAYng19ErezplUFNN8VSZ6xVUVml0cVReSxvoMvq5PXo8M0
         rGi+2eNuaAqYQmUoP/TbTU/lSaqPOxcv1HhpmTIOWef/pFrfYCedlReRGy5FP6MxvByo
         vb0eD2vsFkFcgLxWnN+YoKAOXnwjnYTiRs39QD+nkLJ1ywBsQbhRbX3ughSXfRx7XtuC
         VeIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=cbOII4SMA5lAflDDNgVaa5UMQMG1XG5eogBSO/8/gOU=;
        fh=PA422FzAkDo4FiwiVEPFznIqRkjVB8MhGW+/CDYk14M=;
        b=JaNi+e+rIc915XL4jG9i7MiXgkGuekWgBUjc3N0pvOwe/NKaVesf5ku4L20li7v6Gt
         7sIKLKgNzbmMVXryTxJ8BtoiKPAEA6QpQ7XfgTm7HGdNuMm+FotxP9092LpyZgcYzbVL
         GluaozJWOQ6iu0ix/awGvVnlHqtb8q1izJ02D/NfS/r+7MEo79NNNPGTeZ5p8Nadu0hb
         0YqQYcgl4QFocHUQ2DikHjxHN7AgOxW26pCABqoOavuNWGb0x5KAVOEx0rff7KaN63qI
         AnSwZ9ou/lf2LmbwqJuhppBf6M050XEe9LAtVcglOHaxhATspr1aYBFFtpqjIjxnW95O
         UQ+w==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rajagiritech-edu-in.20251104.gappssmtp.com; s=20251104; t=1787131064; x=1787735864; darn=lists.linux.dev;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cbOII4SMA5lAflDDNgVaa5UMQMG1XG5eogBSO/8/gOU=;
        b=qmi8kOdey3g2Pecj2GOUKg5phrtu5yKZHmaebUr16dKPqcSMf+6GbEmFGigsgSIbdc
         3TnYYtbPXnBg2SvtPbhHHSERNcTNCauseoeco2BcAN35nvmXIuDdY1SKrFIK+NKMAXd3
         8f2Y+4lqjM1u6gSJnwb56ROe3+k5gy46DDEVnyZaU/EKFGmJB+VQpYO5GaXyuFbtQZKa
         KLSQTPLT+7geW8TwmiD0LAb7mX8T3PQkdUtUli2U8EjjGrD3/8NuSNeF5jRthQe74vG+
         Tae8OSkFyMIdAE78ZHLd9NnFdLf3zUVOiKc3qAoHCWVhUL2frW0m0qqI/RUnlKfixB5r
         7Dhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787131064; x=1787735864;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=cbOII4SMA5lAflDDNgVaa5UMQMG1XG5eogBSO/8/gOU=;
        b=HriyboiMOh1LUewxO5daxtMtBXnj3kJxobuWv6oPfyhMWk3TSiPBuKgTYw5ee9J9rV
         r8OAfFMmOTH5w/tRqlxuusl6+TvlsYF4G81r+TIZGf9+u6HosvuAIDh5+TvBow3qQXuK
         meN1T1LAwt2/Zg7eb2EgZCv5exevQan0pomLcy4MXaHVpktdu+K0MnnZQzWupHGZtQBm
         KS6nbZQz5eTGmQhSNdkewebQ2E1BWmSedoB7Chvn8FmA51uHBSWrTkjgAIqZxIZAqq/3
         KVfpt7MyaHPKpbtS0ODEn5N33HWqFMqPC92Eh4vlyWwru8PtCsd8tWwiAw+dH+AdpHee
         axfQ==
X-Forwarded-Encrypted: i=1; AHgh+RoB7d2HFwl5o8ObERnnFVnGCtDTnJJ7JcTrD7IQ4bKDzh4RfiaDP+5bR8QyOZxfjey5KFqih9Ky@lists.linux.dev
X-Gm-Message-State: AOJu0YxKp/Fv0w0HV5YzeuP761Is3OpGFrYcu1m0d5LzN702wOTlLFcf
	tIApvXzN04m7VZezSbd5OQGQZ2RNFokz4U7FFrt61kO+VIOvnJxWt0fZFPJcQOGwGnhUDZ9C9z3
	7oDqZ+wg5ixXUbHu3hiSj8wa+g4imycQMNqPdQtCuAw==
X-Gm-Gg: AR+sD10BIHyP1oLj655c/q4RGVUko3hKdYsrb37GIFMkecsM43Zf6XID1Uyfw0ReE5y
	VPD+O92HI4sHEbZiHLOOE5GrpFr75EdDy4kqU2wQRkGoK0HXQKSTVOiNY12qoeihu2D0aC6isur
	PhZMQUsllR2jeB0z4SucqDSoOxuGWwqsVPnuS3RjqtJdJm6Mjm4n6fIpOZVVz1LfSg2b5FaLp73
	+bF61MshfW8P3X0KylKLbSx+TjAWV8N0Nh6HkJrb6odWNhkF3daJ6rN2rfSQQc7UCM44+ksmv/j
	bccuRHdrMFTNsMne8MxQODYsmmyaUB/bCdft1TPdsBwKRoa2kSIXK2pzeN7Ug6447ocTctuyfEe
	od+xfMih+y8LaDrsM2RfuWm7GeMSh9PF1BtSr3rkCwBMCVZLVeVpmiRB91oPOtQQABwjd/0qlpX
	EndFsr8j27EMIEfQ==
X-Received: by 2002:a17:906:6a0b:b0:c16:2dc0:e1ed with SMTP id
 a640c23a62f3a-c23f9317367mr180650566b.4.1787131064517; Wed, 19 Aug 2026
 02:17:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260817132536.752504388@linuxfoundation.org>
In-Reply-To: <20260817132536.752504388@linuxfoundation.org>
From: Jeffrin Thalakkottoor <jeffrin@rajagiritech.edu.in>
Date: Wed, 19 Aug 2026 14:47:06 +0530
X-Gm-Features: AcwNN1UiULEM3MbnwL4VuzhY4xiT3pEXAY6LKKTg1jmDWoLEzDqkTP8LLsJWmrE
Message-ID: <CAG=yYwmxBjeuho30BMmfscK_r0WRcMykfKcKqHXVdD1Oh8KNtw@mail.gmail.com>
Subject: Re: [PATCH 7.1 000/271] 7.1.9-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@nabladev.com, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
	achill@achill.org, sr@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"

  hello,

 Compiled and booted  7.1.9-rc1 (using qemu-system-x86_64)

No new typical dmesg regressions .

Tested-by: Jeffrin Jose T <jeffrin@rajagiritech.edu.in>


--
software engineer
rajagiri school of engineering and technology
