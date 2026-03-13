Received: from mail-dl1-f46.google.com (mail-dl1-f46.google.com [74.125.82.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADB5B399023
	for <patches@lists.linux.dev>; Fri, 13 Mar 2026 13:35:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773408959; cv=pass; b=Iv/62zfM5D4MCeT6QBzPEcm+4N9NLLarDV5xnx9qolMTrmLhqR204iO6y70A2l7p5IqKrPB6foIRcPeiOxv479BJjd1TjPh3Kj+bNKGdR/W2gwR/mqXuBkslFWFDvCPsXhmICqrP/UzqsG4MHp9psS8ELxHcbaf6EXJX6VXFekE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773408959; c=relaxed/simple;
	bh=Vew5/pNVzaHeCl6MkP4hTQXVcpyhFe4CeyXNr9m8cEA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=h+4LOft5bpHFYms8lzJ1fRcCmj6rsqG0dGPyE6tmmISVIyxcR5IJI64ok8IR/AB12x3Qe2Z88t+yt0Dri4B0nCjiFgzLWA5jtOjsN7HZ/yPRIopSomq/HjfBExeNeoQD6LnGYXwLiNu2mmmzX6o7iyOR3HQXAz2+3MDIcPua7kI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=k3UCo/zZ; arc=pass smtp.client-ip=74.125.82.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="k3UCo/zZ"
Received: by mail-dl1-f46.google.com with SMTP id a92af1059eb24-12734af2cdcso101454c88.0
        for <patches@lists.linux.dev>; Fri, 13 Mar 2026 06:35:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773408957; cv=none;
        d=google.com; s=arc-20240605;
        b=CFSeyXV54PR5I9TAd36fvu7tNt9KRVXv96b9U+y4Tz+0TyRVWf4SJWv4q1lzngAwj9
         nmw0Y2Bs/16d4l5qFHe8TcO5L51rpx2hgGLKcZSeHSa5nvJZlEZ26wcv1l8lmIZPIWPt
         9SoKkRQRgRwYPNE7kpD1Kp0Kt91+sg/YcewuOveWCrqL1m0FPhuEzDNy+TiRthFGEiYQ
         WvoHV/IWkkgd/x3ook6f8GDYUh/o3n6CthRzMNBzZXENVVXkhLKX8zu19Jqe1vxbYqSi
         xbzcTgz3nls813ofQCJyeHimfw7y4YrrHV65/054IuM0TYtVEGt2OWUHYMaoYZQtUKzL
         2GRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=QhMxT5t81umetHP7OJdIfPfi7qUU4Lkh+7YuNP7wTXU=;
        fh=Br8GPaM78hkca22JwRpEzBYNgczj3Kf8nN3WXrcVtng=;
        b=KaPy+RRtgwsrBiANbgwmI1cmFi1QXkvi8MwHEl+vSSnLIxQeoKbcKzg8cBVNCSn5lN
         hx6ERNbtNzbxBTZgAxErHk7EOKfpPD88Mhn0OiB60rQCr89KrHb4JYqWBWl5ONKCbwWv
         TKW7Qs15OAANVm4BNrADjgmUUkR8cclPSLKbQykSugI7xezDKcwxLs32Ps3k/4U1M19G
         M+Eb98O5awd5kkcl8zbrNs/Hc80eSK+3QkfIpSnVPlzhaBzjtfOqp90+Q/UHyzBfp90J
         XYtoy1vt1iHmRo02VwvJtd9sYU4yPjTdgOD3p6WxpgaT0MeW1cLDzP5lhx08y7Ry8R2l
         2Kgg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773408957; x=1774013757; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QhMxT5t81umetHP7OJdIfPfi7qUU4Lkh+7YuNP7wTXU=;
        b=k3UCo/zZKqfjdyWR/JW8dnDqkTAbrLQUfNzQxEjT8FNFsqKVKoObhXgbGsso2WbQOr
         7bjQkylvkGbpmjNesPtISuqCJv/bf4QLACX7I8rSrg6lGhZw7Xe1HPf2ks/lnIWvGfrI
         WeXEtEJZTIv1YDUfjnG0TCMhIT7xq8J5WqKjFicYdKxfUX3lP8AXZc4vwHR06ZjooumU
         lcIio+mZClEKmOK69ka+uCHaZvNxxeWZeCgiTP0k0Q6FXxK17abH1JNptXoxRPTy/CVh
         GJO3xdjaPT1UkgVt778o8X9NzBz/LCzmcomQYLKw46X4EffX1j7Cv12BvJXd80bd7v/X
         yWsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773408957; x=1774013757;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=QhMxT5t81umetHP7OJdIfPfi7qUU4Lkh+7YuNP7wTXU=;
        b=su5m2xLVvIyaJ0+lG1LaQ8xOhmYJFyXTewP02XGLbardc4jY9eMMGoFZbDYWJcu96n
         t43epzQyoYVuu5v8rC4Kdtd3INdjOaWt7AgvK1XW9vZPsNXJQpG6PVRLi3C8pC8yzEMq
         bb+ooFTau9+FMdULQSPPIqCdx2raYLOJmOH7QbH+7LNiSxt4HnyoRclWuYNShGpuXhwj
         ue9XNIPG4vKvJ3D8P9eiFFFAh7ve1QxahZoIa/YatMNkss8lO3ThLzjqowwZPm2u8nC1
         ZETjucl3aTlkeI/eWQ7cAeSIitfDxnFRY2rXICAcDppju4LybHu+rw+FEJ8rJfp7KbKJ
         qLYQ==
X-Forwarded-Encrypted: i=1; AJvYcCU2Zv7zcIkbaRxZ2jnb4xSeaRVfU0ffV7jeh6UCIoT6v/gcMx+ouQhm2NrOiymMz8DOedbaC0nr@lists.linux.dev
X-Gm-Message-State: AOJu0YwRa5R7qn07zunc5nUq/cKM+//pTGG+hUn2+QdGnpmXxOckucb/
	Q23NAaw2yq7NEFZjaYIzuq1Zw6mekpRGDfEu2t/BNMSNqHpbqOmbNM52sSXHCnDXTzyV+NEwgis
	60Y2DDzYaI2bp/JwgLRYLwvAtpKfV+EI=
X-Gm-Gg: ATEYQzzxxa0gKxJArdMki2yIwGfK2UlKn5rlnp2CBYZujCsigvUXZQ25MUd77YueYKV
	pQKKGI9EtzMdJYDdsrGu7R1Gt8AxrqgQKts5gpEI1WeVw3iTDqkl94GfKtD7yS4spbXqmO9o61Y
	u9bvyVPbySMMD570AhKYxi7gY69SMLn6dXfhW7eo3FjkMqtJ18O72nnB9wVK5CRa+cZycM2sRLO
	qyEPbkrENtFJr8gYbkMPT3wExsDy6R+v8O/+YfR3ec8Cz2nVzHJTFK+UGVLZJrj7FLsKlhHow0J
	IafaZ/Qv+MqGX01UVTb6Y1HCD3HYQzkB6YGHKG6Yz/ijQUllHY5mjSsT6lS8iaCrpwOPGA==
X-Received: by 2002:a05:7022:2391:b0:128:d4d5:93b9 with SMTP id
 a92af1059eb24-128f3ddb7e9mr736853c88.7.1773408956533; Fri, 13 Mar 2026
 06:35:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260312-amdgpu-fix-clang-c23-extensions-v1-1-59883120a451@kernel.org>
In-Reply-To: <20260312-amdgpu-fix-clang-c23-extensions-v1-1-59883120a451@kernel.org>
From: Alex Deucher <alexdeucher@gmail.com>
Date: Fri, 13 Mar 2026 09:35:45 -0400
X-Gm-Features: AaiRm52K3lFtnPCDTCHQ46AGp4JF3gz3oOt-LlB3C1NBMH_-HZtICTmqKkOb1PM
Message-ID: <CADnq5_MbW=jfGJE=jJi4EXacQs37P1d9KV4a8HjNDLwicwZV7A@mail.gmail.com>
Subject: Re: [PATCH] drm/amdgpu/discovery: Add braces to case statements in amdgpu_discovery_table_check()
To: Nathan Chancellor <nathan@kernel.org>
Cc: Alex Deucher <alexander.deucher@amd.com>, 
	=?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
	Likun Gao <Likun.Gao@amd.com>, Hawking Zhang <Hawking.Zhang@amd.com>, amd-gfx@lists.freedesktop.org, 
	dri-devel@lists.freedesktop.org, llvm@lists.linux.dev, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 12, 2026 at 5:54=E2=80=AFPM Nathan Chancellor <nathan@kernel.or=
g> wrote:
>
> When building with a version of clang that supports the narrower
> '-fms-anonymous-structs' (as opposed to the wider '-fms-extensions')
> along with the associated kernel support (such as in next-20260312 [1]),
> there are warnings (or errors with CONFIG_WERROR=3Dy / W=3De) from the
> switch statement added by commit 47ab777c16c7 ("drm/amdgpu/discovery:
> use common function to check discovery table").
>
>   drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c:560:3: error: label follo=
wed by a declaration is a C23 extension [-Werror,-Wc23-extensions]
>     560 |                 struct ip_discovery_header *ihdr =3D
>         |                 ^
>   drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c:568:3: error: label follo=
wed by a declaration is a C23 extension [-Werror,-Wc23-extensions]
>     568 |                 struct gpu_info_header *ghdr =3D
>         |                 ^
>   drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c:576:3: error: label follo=
wed by a declaration is a C23 extension [-Werror,-Wc23-extensions]
>     576 |                 struct harvest_info_header *hhdr =3D
>         |                 ^
>   drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c:584:3: error: label follo=
wed by a declaration is a C23 extension [-Werror,-Wc23-extensions]
>     584 |                 struct vcn_info_header *vhdr =3D
>         |                 ^
>   drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c:592:3: error: label follo=
wed by a declaration is a C23 extension [-Werror,-Wc23-extensions]
>     592 |                 struct mall_info_header *mhdr =3D
>         |                 ^
>
> If '-fms-extensions' were not present, this would be a hard error in
> older clang versions.
>
> Add braces to the case statements that declare variables to clear up the
> warnings.
>
> Fixes: 47ab777c16c7 ("drm/amdgpu/discovery: use common function to check =
discovery table")
> Link: https://git.kernel.org/next/linux-next/c/0d3fccf68d9873a3c824fb70be=
0dbb2c4642aa90 [1]
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>

Applied.  Thanks!

Alex

> ---
>  drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c | 15 ++++++++++-----
>  1 file changed, 10 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c b/drivers/gpu/=
drm/amd/amdgpu/amdgpu_discovery.c
> index f9f785c5d8ac..4209945af66f 100644
> --- a/drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c
> +++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c
> @@ -556,7 +556,7 @@ static int amdgpu_discovery_table_check(struct amdgpu=
_device *adev,
>         checksum =3D le16_to_cpu(info->checksum);
>
>         switch (table_id) {
> -       case IP_DISCOVERY:
> +       case IP_DISCOVERY: {
>                 struct ip_discovery_header *ihdr =3D
>                         (struct ip_discovery_header *)(discovery_bin + of=
fset);
>                 act_val =3D le32_to_cpu(ihdr->signature);
> @@ -564,7 +564,8 @@ static int amdgpu_discovery_table_check(struct amdgpu=
_device *adev,
>                 table_size =3D le16_to_cpu(ihdr->size);
>                 table_name =3D "data table";
>                 break;
> -       case GC:
> +       }
> +       case GC: {
>                 struct gpu_info_header *ghdr =3D
>                         (struct gpu_info_header *)(discovery_bin + offset=
);
>                 act_val =3D le32_to_cpu(ghdr->table_id);
> @@ -572,7 +573,8 @@ static int amdgpu_discovery_table_check(struct amdgpu=
_device *adev,
>                 table_size =3D le16_to_cpu(ghdr->size);
>                 table_name =3D "gc table";
>                 break;
> -       case HARVEST_INFO:
> +       }
> +       case HARVEST_INFO: {
>                 struct harvest_info_header *hhdr =3D
>                         (struct harvest_info_header *)(discovery_bin + of=
fset);
>                 act_val =3D le32_to_cpu(hhdr->signature);
> @@ -580,7 +582,8 @@ static int amdgpu_discovery_table_check(struct amdgpu=
_device *adev,
>                 table_size =3D sizeof(struct harvest_table);
>                 table_name =3D "harvest table";
>                 break;
> -       case VCN_INFO:
> +       }
> +       case VCN_INFO: {
>                 struct vcn_info_header *vhdr =3D
>                         (struct vcn_info_header *)(discovery_bin + offset=
);
>                 act_val =3D le32_to_cpu(vhdr->table_id);
> @@ -588,7 +591,8 @@ static int amdgpu_discovery_table_check(struct amdgpu=
_device *adev,
>                 table_size =3D le32_to_cpu(vhdr->size_bytes);
>                 table_name =3D "vcn table";
>                 break;
> -       case MALL_INFO:
> +       }
> +       case MALL_INFO: {
>                 struct mall_info_header *mhdr =3D
>                         (struct mall_info_header *)(discovery_bin + offse=
t);
>                 act_val =3D le32_to_cpu(mhdr->table_id);
> @@ -597,6 +601,7 @@ static int amdgpu_discovery_table_check(struct amdgpu=
_device *adev,
>                 table_name =3D "mall table";
>                 check_table =3D false;
>                 break;
> +       }
>         default:
>                 dev_err(adev->dev, "invalid ip discovery table id %d spec=
ified\n", table_id);
>                 check_table =3D false;
>
> ---
> base-commit: 7a9419ab42699fd3d4c857ef81ae097d8d8d5899
> change-id: 20260312-amdgpu-fix-clang-c23-extensions-1fb28eee64c2
>
> Best regards,
> --
> Nathan Chancellor <nathan@kernel.org>
>
