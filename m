Received: from mail-dl1-f51.google.com (mail-dl1-f51.google.com [74.125.82.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0464148A2CD
	for <patches@lists.linux.dev>; Tue,  5 May 2026 15:57:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777996656; cv=pass; b=fbOZ6NY5SjWRCfzyjmHKIkqqWOYFCORF1eH17gcNoT62uRXWq/k5O+0xbZIF3gNBAVWxFWKywz3T8k16POby5ow6yREPww/UjflAaHSrkurthSBImF/IpDCALEV4+pM3GiBEjCz9BZj5/dOzvCN9rmT4IvsmUEQEsYnWJ7SE2JE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777996656; c=relaxed/simple;
	bh=LDNzA0ktaQOd9EO9z8tWH2U9AqQnquf4cSGKsb1TqKY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=msGpOHdHhH1o7RE9a+Cb4Ez0z5hPD9AD0OMs6/lcf6PKCy/dnPQVmSOFOtmtasKNn6VWQgZPIJTn4ssL2tmWGUDNQ5708BKONekJ+cjkyg9Y7LnA8gLTYJo7jufQCQccR3I7DIsKjHzcexjqW/QnE99AV/dta7XVP90FZtf38ys=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=m8b0Ztqf; arc=pass smtp.client-ip=74.125.82.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="m8b0Ztqf"
Received: by mail-dl1-f51.google.com with SMTP id a92af1059eb24-1305908ae11so2597403c88.1
        for <patches@lists.linux.dev>; Tue, 05 May 2026 08:57:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777996654; cv=none;
        d=google.com; s=arc-20240605;
        b=UtfnkuTr/Qma/pPkeIR6TfBB0R6dUr2Rny9ZjXzIgSL65gRSucML7HBJwNdivycPLj
         jGcOOXDJiOwYJFS589C80gjUaPmrsxewIlF8LQwytcM2pUiZqxUF3/iDVRmT6vsp6XlA
         limbJtCLJIIuIiUzpUqYiuKfDU0ZTfQuCfwwT9J/5BMxcPivXVPkij740Hi07d4glF71
         mYpvFuIqB2Z7dgwkpTyfhXq+zccmsg+PdREsIaZPZxaKECTXDL3HnnCFDgqpFXY2sgD+
         56fiORjhi217CBAYl5Q302TzmQ7YjR3q3ti/nwbtMTKRoyd62xI5S9uX2pML3DEz5Q6c
         a2gg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=LDNzA0ktaQOd9EO9z8tWH2U9AqQnquf4cSGKsb1TqKY=;
        fh=TZdUr0rHFcf8HBKpiChDHu66lGNG8PGE5FuJNIOQR0g=;
        b=JdEMQ6Gu1tQxTbEx9hZn1orNISw3VGN0EbyJZPc6YFitNbA5kIaJRM5RkATaGafUNC
         fDNmf7XkpE3iNqJ/IXLNhmpAYnd2kh2gGYoB3kRB6j/eI97jZOc3eOL4R49fFhmDAr/B
         8ZGv8l0tgGMm7MmpG1GiBMcb43hlgO9CwYrzYX9699Blpov14rMk9g5ywnL69BaIWFOg
         xFREhm5nFBFBH1eiHDZuWFbjagpdMiZFbPlMKq2jk2R94XGvp+xWGbtm9aFAOpd8GLVH
         CzdturT9RuQ12LODt7sVDRZsva0wgpvSiKIEJCp0Q7n6rkwOFwSXaz6yiG3OztLblVz+
         3SIA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777996654; x=1778601454; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LDNzA0ktaQOd9EO9z8tWH2U9AqQnquf4cSGKsb1TqKY=;
        b=m8b0ZtqfEiDYXjYmCGaGLOM4wbuXzbSlBKjjyg30OUtoYY5NLqtJSDiYvGtmfe//kA
         XLRsxA/+TKq0MXIkLhoceFLzdabQmYb1RCkjWHBKt/yQasqy2WgFdV8JyKOeHnSy9UTG
         8nmImZpYL/uQ7Gd4TNCqkNo3CW61lNeufaQXgZj9xG0KCUerNzkboNR77e81j+MjLSfD
         k3c1Q3zQI6BS9lHUPyCvwU+B8ZtTFRi6W1FO2/Ro/7fYGT+kYDv3d+2aytHbKv9b/G5G
         LF+it/0MAAT4D84cuLVO3TgtkvcbQAFUHE0Id7jBDLkAm++9O3oMSr28VpZNWLICSj4y
         H0Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777996654; x=1778601454;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=LDNzA0ktaQOd9EO9z8tWH2U9AqQnquf4cSGKsb1TqKY=;
        b=Wq0zq5UkGkVA2jxCkOatZzE14woLMYB01F/K8wK6ngaULZRU6+v07pD5N16EAGv2Sg
         urdR96ePa0/sVUzP1m9w9EeRtCy2yi8CD59iyGGOMHBbFw0R19WndXV1GlxRn4MuGONf
         NxLbpB0zJpphFfImA6xn8qUZRwNmohVCpY+Z46hVZSb6ii4b04XVyu1uYZqdkpiIWKum
         PUB2k8mvcPy6bWIEss2IHxbn9Mf6i15ZEqFX0dP17Nm7GLPC98Ow3MJvDAKX0OanPONU
         oFgfBB5rTzseh7UeujFJlvNPx8gfPpqEoN+n9byV4+kizVCGc8h/Ji1AWQscMpQQY65m
         4I2g==
X-Forwarded-Encrypted: i=1; AFNElJ9pjZdSlruZZ/2auBzfMDyUKRVxsrxDl9ngyq2UVTme3GT7uBvdKQxsqXEI6NNI5jzZkHelLNPJ@lists.linux.dev
X-Gm-Message-State: AOJu0Ywf47PbdxS0nzh8APs9QyP9US9DDAh/tDKic0E6xqk+2PfQKa7v
	JwJjtzSEiWXKQpWmomF1mBwDuu34qfXiF6kGJ792T3rh2xi+xBXxrk1dBbO9jzKeackZcCrJBHi
	n8nRQ/d5UwrWGDS6pWlcIPAQik5D0TnXMgf0/Ll2E
X-Gm-Gg: AeBDieumrnW4yMGbFd/WsxHrtmIb7RQG1lHZeXE36MVJEbV/T+XICOeOQJdnyrrhp5D
	lpw/ilRLTl0x3I9FkZV7vqbxNXkqs5ggkHnnGj3cldR2r1SCTJBJe4viALT3l/5laS04lD+fP1K
	/VOr3HaVkky0udsTwozTMOT6aGTIHLgZo+iu+jDW4Pd7LtnEVLNJlcPPDEkVJMAyIHc1HfvK54X
	yjp917vCdsMS4JKzd2V0MyB37ui5QqlgP/sEfIo5wKb9cwVJH9KXDPekjlwfJUPm1783m4d9Aqc
	AISSyxTan3so6MqngqiX09xxjTbcNA==
X-Received: by 2002:a05:7022:b8c:b0:128:d34a:320f with SMTP id
 a92af1059eb24-130b173badamr2261604c88.12.1777996653500; Tue, 05 May 2026
 08:57:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <0-v1-dc5fa250ca1d+3213-mlx5st_jgg@nvidia.com> <CALzav=ci8bi3=sY+F3HJTB5sOQ_pJ8Lm+kz0CDBBWVXry5P98w@mail.gmail.com>
 <20260501164314.GA1381708@nvidia.com> <afkjkBq8B-4KjhS_@google.com> <afoR1izCEe9y0MZA@nvidia.com>
In-Reply-To: <afoR1izCEe9y0MZA@nvidia.com>
From: David Matlack <dmatlack@google.com>
Date: Tue, 5 May 2026 08:57:06 -0700
X-Gm-Features: AVHnY4JrW8dKYzLI7vKq9aNciL3ihCmWQQqvYeVf-qNxqF1RpyWt82ID73cuiLw
Message-ID: <CALzav=d7a-55mg01MEfaonsU-+4QxbRE3QXpZLskteF28tdaUg@mail.gmail.com>
Subject: Re: [PATCH 00/11] mlx5 support for VFIO self test
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Alex Williamson <alex@shazbot.org>, kvm@vger.kernel.org, 
	Leon Romanovsky <leon@kernel.org>, linux-kselftest@vger.kernel.org, 
	linux-rdma@vger.kernel.org, Mark Bloch <mbloch@nvidia.com>, netdev@vger.kernel.org, 
	Saeed Mahameed <saeedm@nvidia.com>, Shuah Khan <shuah@kernel.org>, Tariq Toukan <tariqt@nvidia.com>, 
	patches@lists.linux.dev, Josh Hilke <jrhilke@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, May 5, 2026 at 8:50=E2=80=AFAM Jason Gunthorpe <jgg@nvidia.com> wro=
te:
>
> On Mon, May 04, 2026 at 10:54:08PM +0000, David Matlack wrote:
> > > The PF support flow requires a bunch more complicated stuff.
> >
> > Do you think it's worth supporting PFs? If anyone with a CX NIC can
> > enable SR-IOV and run selftests on a VF then we can keep the driver
> > somewhat simpler.
>
> It turns out my test system cannot enable SR-IOV due to iommu_group
> problems so I rather prefer to have this :) I had to hack a kernel up
> to do the initial testing and it was very annoying.

Ok sounds good.
