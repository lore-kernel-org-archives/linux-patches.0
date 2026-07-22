Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC1A2372EF0
	for <patches@lists.linux.dev>; Wed, 22 Jul 2026 07:19:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.214.179
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784704749; cv=pass; b=lDGQEcFCNh3UzITZzvRZ985GcizZIVtWiFSvpuJ0VPQRF6GQE14pNwefvkzBag5N9wzxZaExzBrxX7rFhtZZpEVRoa5rSsHNZ3CEoUPo8F6mQLO65sgCM4w0rp94LZJjCXEvDKmIB5UVifZkGjJgd1NSgCwuMHWCFuOIUEk7VX4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784704749; c=relaxed/simple;
	bh=2EfXKAoAWHjt94nqC+jQqbpfKxdlJ24X2WPe3Q8+7yA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SpGLmnaQUdj/Ca5DjB0Y0yJcN+W8MlgNrYRIJtQSXEB0mK57AENs6b4YCi9jZAkOpASlF93xDAlDLD8vkb+rzABb6RSV2eXSsIdEi4A72KwKKpivvIoebDOhBGVs+fGcHmYZhAc5S9+Kgoyh+MSZn5kLGLGsmohrP8ntq3pL9Oc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FSE2B/zJ; arc=pass smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FSE2B/zJ"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2cad68425a7so17521905ad.1
        for <patches@lists.linux.dev>; Wed, 22 Jul 2026 00:19:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784704747; cv=none;
        d=google.com; s=arc-20260327;
        b=Y/UPX61vbmcHzdfynQR8dRBtBlAA617Tuxex16OmSLhNuVnUnwfwUKOi+MdtTTCCs0
         SA7+uoUl8R+ri8xc4T7r8FDyVxAH/oigiF9eONakWKTvtaFQ9uLa6O/CBN58MVVQHrwn
         yY77OD+RCPE1EtsjzoeFqHpgzTtxKwJHYvqJgIw+zqLDE31EBfE34mGpuDfN4E0qkfzS
         DC3Mu0yRGMyzzgLzsZrtFYh+Xfm1JuOSHJyhnfEOl6gAzmnVfMmimCCYgrw79OnyI2FW
         e/GgS1L6souJPpOeYtT+5rtSOrMxBviBSz+rsB+1sqRba2E9K2K6CRnU/7HQXWstQSjp
         O/4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ezUXcPip5zTfOmNvYGlmu7iDC5gPfyv/YbMiD7P1Bho=;
        fh=GyE42loVZRJoC71yzjPtlgcsE6U9la4IK+lOreqCZwg=;
        b=SNYlGBH9CqDQjt0R1WRLoLmLuhc9+6WdqlPwA8VAfU7wUQa0w1oDqxUhFBt1tTEqzm
         xSi/66k+czhCerTQ3brdsPUb2sFPjSqENJ3OIMltQFYo5pmK/jZZdbgiFt63520msXJ7
         lyQSKmVAl/5vh0Gx0ZbVkTXHgMA6u+NgfNSRbRgOXvbSBoRt1PvMPU9ElgfseWBj/p3L
         2UoONa+cAWH0hH9Ua4E5/GiyxECxNee6gA058YNLYxKAlXK55tFGcW08/AYecSUDhvu0
         znVIT71KiiKOPy3OvICLYRabfejtpE0oD4A0M8WwhgnootkCHifGqHAA5gyiUjLK/62/
         OCGg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784704747; x=1785309547; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ezUXcPip5zTfOmNvYGlmu7iDC5gPfyv/YbMiD7P1Bho=;
        b=FSE2B/zJK/GgjUlSlz8OKQ2Lfw9Us8PMPCTav1J+bzrzGfM1dSl+geGtVY1nFZyjPH
         Aqib47GtVD0CzUAOTkj6RfSjt+p1sFjeBpngylpjtxtQbIz8zWvcWh9h63KeV7cY1j1U
         sr5t4l2AbNO2Y4ck/zc0eZn6Wj4Qw3t39eottZw5TSMxVjF6QzrS4iFjdNOfpXftXZpK
         h1AqqS+LZ97p2nVNg/wDo9MUOY7PbQLN5Q40XxrfdVf9tkkvogzvy1B062MtIuaVYsFJ
         LhG20XrNe0CVQ28Izk+ouWdC2aADd/Ttog7m5AgKFT8tDDY0IIVh+2e777BXEsoC1bHz
         lrJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784704747; x=1785309547;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ezUXcPip5zTfOmNvYGlmu7iDC5gPfyv/YbMiD7P1Bho=;
        b=r7XVAXpj7xaOkUbRPoMDLNS+BsbP9S0ukrXWi5MlwTlKuQehluZmv3QYsX3L52kXdE
         5l3pZik23BUItszsKFh+HGbVScj8g95e3UMbSVAiS7/n2BEZWUdXvXp9zEvupOYqT6zs
         c3FVMcaBvvUT/4tr+aZSo5rVKUyLLMyU6BbJk4uEWTZa63OwUc1ez9LbmhN/o4trCAmY
         obfnO9QYp5gc9yhrJccycupE6alTLoRYaJvboKAWUFPFvnqtKU/o6hqZG71O1zoaZXa/
         2lhr8QK2Lbs5rPDZsYGQ0/E8i0ii/gDSe/kVLBCnXC2CN161WiWNk6REbbIyuqTv12V+
         em0g==
X-Forwarded-Encrypted: i=1; AHgh+Rpl5dGykyju7wM27kuN95hCjO9A9RGgEk0PpAjASw93r1WYzZsOnTHttOeR8nKsUWipZ/lAyBuH@lists.linux.dev
X-Gm-Message-State: AOJu0YwNBCe5G+lo5kK1/ulqZbMv2iO6HEXXDkZ5kU7JWLmPIT6dGEBo
	E+XYSSBqkbXnLTYOxR78k06fKqHFM5dYs0W1CeUWSJjMO/Asq4PDJecKEUNd74rzZjSia6Q0Qh8
	OUEf558GDXYKStKh7ptw64Zms7s9BOVo=
X-Gm-Gg: AR+sD11mrnitxWZmqCnYnQUe8wKCGAYOJkUeL6Pkgz0GXPzsm3pjp9dNFaaBC8Fa2Bo
	xU8V9wQkUJcavNX4XxibTPJ4tD0ubNEiNQjRJ1KHKuBlN+Pj+YArGdDbTpg+qP1N8oPrOdQTnP+
	GPoKzjauyHuOKbZxy6QKVsetxI07+x8EMXcQ2wSVM9MUXFr2e1+ZnjNtfApXO60uFSMoC+baZQB
	yJ/wR8w0y3ukWeyu5Eau1qZIUMQXCc3b5TvasT4HNTAb37W55UV2TcaSZ7loozfHkYw021uNeQM
	gPyc1IZ/R2JUZe28obB9zlrMtd3LZiMQ9Eiq9ktNC295DMJ6vtnnpvh+Sogh1mf10cWqQSKydL5
	jKA==
X-Received: by 2002:a17:903:1a6f:b0:2ca:e134:9e6d with SMTP id
 d9443c01a7336-2cf805e4983mr52954525ad.8.1784704747174; Wed, 22 Jul 2026
 00:19:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260721152424.521567757@linuxfoundation.org> <20260721152425.635542881@linuxfoundation.org>
 <CAH5fLgjeGuBf3DBSwRDXbWCCc1__ZmkZ4W+5F1iwhAFCc2A25A@mail.gmail.com>
In-Reply-To: <CAH5fLgjeGuBf3DBSwRDXbWCCc1__ZmkZ4W+5F1iwhAFCc2A25A@mail.gmail.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Wed, 22 Jul 2026 09:18:54 +0200
X-Gm-Features: AUfX_mwOEJ7jXwoYLWA57dkXxqZizmzBkkG5j42AwBq3_Bv9clL1PGHUCcjc1Nc
Message-ID: <CANiq72m5=5xL5tLMKJsxu_RS-606fA0TZUtX3urvdd_4ijBcxw@mail.gmail.com>
Subject: Re: [PATCH 6.1 0048/1067] rust: Kbuild: set frame-pointer llvm module
 flag for CONFIG_FRAME_POINTER
To: Alice Ryhl <aliceryhl@google.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, 
	patches@lists.linux.dev, Miguel Ojeda <ojeda@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 22, 2026 at 8:23=E2=80=AFAM Alice Ryhl <aliceryhl@google.com> w=
rote:
>
> We shouldn't backport this to 6.1 because -Zllvm_module_flag does not
> exist on the rustc version used by the 6.1 kernel.

Yeah -- please see the instruction above:

  # 6.12.y and later (flag not available in pinned Rust in older LTSs).

More details I wrote back then at:

  https://lore.kernel.org/all/CANiq72kek9NoFe2PCFnND1p6BRbuzgv6kT2o5jw09sWg=
+wau_Q@mail.gmail.com/

Cheers,
Miguel
