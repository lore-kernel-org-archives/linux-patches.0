Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AD3D29C33F
	for <patches@lists.linux.dev>; Fri, 10 Jul 2026 04:06:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.174
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783656392; cv=pass; b=qlemGoIcbn/xY85u/Ce+KNcOijy7GhQYYOqp/IpCm2boF56tTOi+XZ9dO4iKu0R6qWMLarRDaOnqzCvcfeg2MYPfNXNOjkpA7ShiPTRY3TI8WL9x4skTs7dXnnrLLruZ3LXR9wYjWGMaQpelJU07fyqWithobJZ1Hehtict/ZcU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783656392; c=relaxed/simple;
	bh=/f3DO0mVTKcQxWqrUcC1tFMCSzAJMDqBKHk9ZxmESxg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UF8zkBBI29jne+ixx8dY6nIYX3EnKfYPojZHfCL7aYLCn3DlZ69c7ZP8/BWWmSL6EWsANbJOUNR4ahSYt6+1Rss5iHE74cU7FKY5oMHA+CtAIfFT5LsqoLdR6SHY5gjxGz0e49WtT9ojLJvt7ZxkX2FiCsZPGgAWOiKIUNvoFDA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=n/VPSbNC; arc=pass smtp.client-ip=209.85.160.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="n/VPSbNC"
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-51c15a5b265so147931cf.0
        for <patches@lists.linux.dev>; Thu, 09 Jul 2026 21:06:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783656390; cv=none;
        d=google.com; s=arc-20260327;
        b=sk6iW+w6YbyPgie8ZDTsubyMdh2jxtnSF2buvQ8WjnM90EDXv/OUi9auQ37/iAARe1
         vje6N85rzc5vCm1U8S6fCdr2giQ6tTlEq+Xy3Y/xadrMLuTJRBTyaiF9bVEWpgV4fewR
         IQ5/Kk5A9GKAHbZk4c8BT8hHioDKzidiIXgyws0ibRWlg0aPU6lqW+SfxGjV8+aWjc72
         UWgcWipkMPeyortfZg43QY1KXeHEW1K3SQDyoJ7XFYiUFaMgdFXYndDyB5NiuNcnEjKA
         lph9USsZ267gTuBaIoCuEBJGWpDaJE2VCPLTBM/6rgCon1ztpyXkZ8VSEbjR3EiKC8s5
         dafg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Ne9mmmnso31HUDrewqJxkxCVMCk7imP2313orFRMFIk=;
        fh=5gpoO3BVXr9yLCoy0jijPEfoXeL9EDjJKobacSm+3EI=;
        b=MpJq7HaAMHs+9LLSKyLGhczIFAnQR2BjhYgBA9yAiGO0g9NHQowrKwhT2FKrcdVUcS
         Wj6aR8dTP6JWoRLA7j2NBr0/im97K+v9foKuQA2rgeXfebzAtx4fTZC4j2mesfmub2dy
         pJo9yZaQxIjzl8tHgBAutBYomUAhwFtXukFufjNlqv71/UsOD+75J23qJ2TWkWFFlnlh
         TPHPqn5mFJUuyi+AguPggJ6khkAEX62Pra1VEeBT97Xsy2oJaIT/hQQMXzoyB6HcT/fr
         6cBvEOC/F9Y2ISpQnwCUupH8TmQv9nLi8GuCmf6o5ac27iBeS3ktqzJ870g7hxLZia7D
         qvCg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783656390; x=1784261190; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Ne9mmmnso31HUDrewqJxkxCVMCk7imP2313orFRMFIk=;
        b=n/VPSbNCCU/XoiuMlr3NDf8B0Kf4klqRLUJYrepHqJL2WECgpImsPhp4uxpqkL7Hbr
         cv3SPeGyWUJHewlpO1MWyC2FhfAX/ZzmFUoxzkZfSqoKrX7l9Qe82710dgXf+xRCfi/X
         2ZMQmFfMens1mqFZxEW9iZL2y2FUp3ABsi8PXHFAcuPggxa/d3dZNPoNua06xXx/TpBu
         gLzdD6O2D/sWkZys8XOEZIUvEVNp79n7X0YHkorJrEGSIWIgamDBOS4P7ICJqKCB8wyz
         iJUnIgMBPzeYnsUrJpOkblpQvhD7iJKuBUH8it2bnwNlGumAFGvcF5N3stJlgKYf2O0l
         2pMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783656390; x=1784261190;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Ne9mmmnso31HUDrewqJxkxCVMCk7imP2313orFRMFIk=;
        b=LPB3B1IK7zpNVKL7f3C0sgoY4DIU/WMe+qADpFTRqKsPv0rYJDQApIYiI+bl4iEPMV
         o8g5kDzirUbH84uAQmQ9CQDesin7EwVSfKqm+ypBUSwpQGEly4hfB8FI9Du1rNj4R227
         uLwhurwx3ickPW11Qlq7CTk3OXcKOeDCJWg+wk0KGTM4q8mNDsB0N7ZPedCmBR8FHdIQ
         u+h4KWICv/+/8KFEPuPHxzD/AtiKRLcB17nBd05fY18QGjCUOi7VtwkaI/8Mt4la1as2
         xeTgDffGuXk2NfeRl535wObUOhabtIAzALXqFkoJHNU0f1iAeu0Qh7ycZpE30zYr5mb9
         kmDg==
X-Forwarded-Encrypted: i=1; AHgh+RqufAA8kuynJu0KjvPpLQ539QPUZ8cPH6Fd4yoX4ut9B1x/jsnp8PeNxQKIRBhQMI5yZ+R5syOp@lists.linux.dev
X-Gm-Message-State: AOJu0YzUB+ykc5FLI2jX6r7dfsbajoNHtUABmGIv1O/3M/OR1iarxo5R
	cwACn8loFRinGAgO0GOCNWQANBGNhB81drHGcXY/jcwmhd0BKIvf2+6Befmu6+ve0LwS7gT61Aa
	Kw0vflHTNK2vnwlMrA/mCy/ikoQ8//ALrT/Pxrk+NyaLlU4Qzbt7eWWE2M6o=
X-Gm-Gg: AfdE7claJ5v2Dz6xwKL4uai/aU+aiAq6T0eORkJSAZWj8lowGG9h04HbC7Qg/hW0twY
	pjvsDYrIMI7pbE5i545zLq8B09VwMUHzUAK+8dZNxYvLq9NyMWpqKyFz+AJ4Oq4FYxZa3ob4lMs
	W67LDWbHA2twXGu2CXwVJOQPISixXTYdIy6Yx6ESyz2gISAPy4bpXOEd7jUaFxG6ntOTrIqyiKY
	Ore8YWTI2t/q9/hKYJVRwoIrICKHD145Fyw5cF7kUlxIalbeYDxKgbr3lawJlrV6f2r2lVYSmnx
	pS9i
X-Received: by 2002:a05:622a:1e91:b0:516:ccc0:ee38 with SMTP id
 d75a77b69052e-51cac51dacemr3969541cf.9.1783656389860; Thu, 09 Jul 2026
 21:06:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <0-v2-43074a57a53a+fb95-smmu_tlbi_jgg@nvidia.com> <2-v2-43074a57a53a+fb95-smmu_tlbi_jgg@nvidia.com>
In-Reply-To: <2-v2-43074a57a53a+fb95-smmu_tlbi_jgg@nvidia.com>
From: Daniel Mentz <danielmentz@google.com>
Date: Thu, 9 Jul 2026 21:06:18 -0700
X-Gm-Features: AUfX_myK7XQF1CZJv4vRx8UhENoIWryYI2BA_R5s-T_CavtrIu_usQmLmDIBaUg
Message-ID: <CAE2F3rCh8U-gULjvS_8xsVo7YWN0=K2d8DC0eHwDOfgwB7bvCA@mail.gmail.com>
Subject: Re: [PATCH v2 2/8] iommu/arm-smmu-v3: Move pgsize out of arm_smmu_inv
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, "Joerg Roedel (AMD)" <joro@8bytes.org>, 
	Jean-Philippe Brucker <jpb@kernel.org>, linux-arm-kernel@lists.infradead.org, 
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>, 
	David Matlack <dmatlack@google.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, patches@lists.linux.dev, 
	Pranjal Shrivastava <praan@google.com>, Samiullah Khawaja <skhawaja@google.com>, 
	Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 6, 2026 at 9:29=E2=80=AFAM Jason Gunthorpe <jgg@nvidia.com> wro=
te:
>
> pgsize is a constant property of the domain, it is the base translation
> granule of the page table (4k, 16k, 64k) in log2.

> +       u8                              tgsz_lg2;

In struct pt_iommu_armv8_cfg, this is called granule_lg2sz. Should we
align on a common name?
