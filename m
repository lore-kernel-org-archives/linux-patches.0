Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EE451E0DFE
	for <patches@lists.linux.dev>; Sat, 25 Oct 2025 15:15:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761405360; cv=none; b=u2m1eY8Id/GDtQLT8LaL+SDGc5aFWPFm2NEsu+4Otm5l9d9tBd5+z2+jqX1WG/aPvQ1Qty7/SW53EAU9yE30zrG1JVlY0VtGcANg1ZTl7gvdgZO+IHLcJ6sj/4tbo3p9wm0Nql3GcskCiuMZJqata1J9ho/GHhqy1cPyYZy5xGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761405360; c=relaxed/simple;
	bh=bi4GMT2iyyBr9MQrD3T6o1udwx+0fc5659kLbgfo8vg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=V2vQhX7HHe6orNEnFPXI5wKAQFilap13ZqTda4Lp+uNPUvl/WaJhprCpZcG4KKXQViTGZV5tck6GngVk+NnTklFagTTBRAa5dusXh1eRK/NQYcjYu2NgWAP+EJxgQJOLxBvtluS45d7F2fmJIF2vGqObCNgFLJ1RnZ95C6AurGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=soleen.com; spf=pass smtp.mailfrom=soleen.com; dkim=pass (2048-bit key) header.d=soleen.com header.i=@soleen.com header.b=DcIBqhO3; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=soleen.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=soleen.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=soleen.com header.i=@soleen.com header.b="DcIBqhO3"
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-63c09141cabso4851259a12.0
        for <patches@lists.linux.dev>; Sat, 25 Oct 2025 08:15:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1761405356; x=1762010156; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bi4GMT2iyyBr9MQrD3T6o1udwx+0fc5659kLbgfo8vg=;
        b=DcIBqhO3Sy811vmLYuKx6Gb3nsRFo/fk7RBB9zKPQZCY85FvDubFhACHXOxT+89AnE
         bSWe2l5fphjCoQF03PYZga5hIFDBwaX5M2MaGxNUF8kpRpy7ya2oxzP5EpG0SBSuejbN
         wxg6+CgpNFq3z9CmSTKXH0u5VZYtRyrw7WlAQpKfavUEQHpF5Wub09D+b6W8one6/IEN
         U/VUSOpiyyKk+nIgSZq0LIApyI3Xm9hDYjxU0SqmzO4Nr8geKbLGmVOCFpuE1s1lj8n5
         CS2QrFrLFlc+ELuAscRmheq6gCTAWQNRn1GDpjDJm/pF4eEdExIx2BXRGwYiTHvvbOsx
         yBKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761405356; x=1762010156;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bi4GMT2iyyBr9MQrD3T6o1udwx+0fc5659kLbgfo8vg=;
        b=X9mT5dvIT1/0DOAHBS54lZTpCFprYxkbe5XRA6kMG47SGTGdn9ZkHg/Pg5LsRD3qtN
         zq9auGaAJlwGWJQauGOI475ZbeaXz83T41TlYKRsZnUP7DnmBBIo1V+93rAaLNufQvxb
         Z+xQUd9oS1YQZ9dOGaFTHdQds7a5Zsh1CGutlI7xGwR+Y/93JKf0aRhYshB0hDfUks45
         +AXT8kOjlMwh5039+OrEgmHTbCKIYpXxgeqVg9g7/FmM1qUuWGPv2CedY1J1vrOOqYdh
         HDWwv4294aaODNLcYyNQ77XEomZ/e6bhA22Tw56GUHrZ0ojTqJiJ6z1YZo9M53ZyMqR6
         n9cA==
X-Forwarded-Encrypted: i=1; AJvYcCUzSt1mqGSRjw6R4+jvNc4CFK1SOcNBPdtWZ9DcEwVk2Y7ZNqVZ3gF6JdAP+GnRkSl5CbrsTX9h@lists.linux.dev
X-Gm-Message-State: AOJu0YxS2TMMAi/MQKQMVpFjsVc1sCMNQ4yvCXVAPzy9zMPBBqXEyF0D
	CIRuPc/VzN+7/wMGPrnIWANlezLXOgcwfV4HxMdfpQYwM9fWGA4T88wBSG9uKs5B4KoaoNCuIz6
	+J+Exomc5ZEKQvixvjOIsGZx+jQ3zPL3vvc9u3S/hIg==
X-Gm-Gg: ASbGncuq9FY7u0LvyCT2Nh0yVdOA3sRnw8FBtmSLbt0RqY6PhHubuWA0hMFxpbNiYZ4
	W5s8kwh8rwWwWXOVocCSLvjUHWsraFSK4sFoW7BIE7mhGgxkGd7jGYruPTjxg78hepzlK/Bjkh+
	dcvYpkuAWxdoEURYGhrGHVscE+L2leNMRNHmON/EeFPQxHxFcRYDIC4SX5PBvpIwKva4hVnN2/7
	/bwm8tKJ+5J3pvCYJMOZvJeMcMSpuMGGA8cvm+JrMtub1rlpPWKPfI117oXzbZs/VpgXTFx316A
	hDaYkwI/NDFnOrzd0w==
X-Google-Smtp-Source: AGHT+IFCiIAROvFB2yMO0UCR+4ZQEZ0s8jgRn6oQbNbO878Y9zbld799sNxrnedeLYq8Qy2EigSbEXq7Bo6P6npPVMM=
X-Received: by 2002:a17:907:5cb:b0:b3f:294c:2467 with SMTP id
 a640c23a62f3a-b647195b32emr3912611266b.10.1761405356545; Sat, 25 Oct 2025
 08:15:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <0-v7-ab019a8791e2+175b8-iommu_pt_jgg@nvidia.com> <2-v7-ab019a8791e2+175b8-iommu_pt_jgg@nvidia.com>
In-Reply-To: <2-v7-ab019a8791e2+175b8-iommu_pt_jgg@nvidia.com>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Sat, 25 Oct 2025 11:15:20 -0400
X-Gm-Features: AWmQ_bmbZ8u5CogyggVXgDbcACzApTnoI3lXdk_DKTEGWhLBxFj0guiH9QhsMTM
Message-ID: <CA+CK2bBpunzb9yaQE91NYfp64xSSuRaHW71MC=3bLVfWsHBDzA@mail.gmail.com>
Subject: Re: [PATCH v7 02/15] genpt: Add Documentation/ files
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Alexandre Ghiti <alex@ghiti.fr>, Anup Patel <anup@brainfault.org>, 
	Albert Ou <aou@eecs.berkeley.edu>, Jonathan Corbet <corbet@lwn.net>, iommu@lists.linux.dev, 
	Joerg Roedel <joro@8bytes.org>, Justin Stitt <justinstitt@google.com>, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-riscv@lists.infradead.org, 
	llvm@lists.linux.dev, Bill Wendling <morbo@google.com>, 
	Nathan Chancellor <nathan@kernel.org>, Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, 
	Miguel Ojeda <ojeda@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>, 
	Robin Murphy <robin.murphy@arm.com>, Shuah Khan <shuah@kernel.org>, 
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>, Will Deacon <will@kernel.org>, 
	Alexey Kardashevskiy <aik@amd.com>, Alejandro Jimenez <alejandro.j.jimenez@oracle.com>, 
	James Gowans <jgowans@amazon.com>, Kevin Tian <kevin.tian@intel.com>, 
	Michael Roth <michael.roth@amd.com>, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 23, 2025 at 2:21=E2=80=AFPM Jason Gunthorpe <jgg@nvidia.com> wr=
ote:
>
> Add some general description and pull in the kdoc comments from the sourc=
e
> file to index most of the useful functions.
>
> Tested-by: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
