Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FF831173F
	for <patches@lists.linux.dev>; Fri, 29 Sep 2023 14:33:29 +0000 (UTC)
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-1c6193d6bb4so191935ad.0
        for <patches@lists.linux.dev>; Fri, 29 Sep 2023 07:33:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695998009; x=1696602809; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Crbf+k0hTPm5Cd8YaXbLKN5kqKGElW+L9hMz0P1lr6A=;
        b=2TyGQ/+FyCp5HDsq71ckUfpJgqcLY+vJXd5Y/xaiy8r0wb7xd0iaO7xkx6BI62X+bW
         cZl+w42tAt93ZJSDuTmc8GwOvKB7id/Z+KHnft1r8UAk4kkaod2KK78vHZT3xxZVpTYS
         Kahbv2Qdvcqvacd2GjWIfFKRL1gPxpSmnJDBD+Qu0eBhFNG15ARK1Da113eTkDZAye0n
         bE4Gto2Ai5dAylK3bTKWlzIntxla+l3SyvZbakibU+cdjj4ZkSq5U8KxopgjihG9yY7p
         1/FjUebhHZ+DvO2i2s0uM/P+JEMNOv02O67lKbZr2UqBONiWAACusNGJTTEjYrmvBJ37
         a9cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695998009; x=1696602809;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Crbf+k0hTPm5Cd8YaXbLKN5kqKGElW+L9hMz0P1lr6A=;
        b=lJRTyAYi1VNHF0UUS4T2fyLgGHq2oU8+TZsEqFLpKSeaHq7gvzSSLBDXyhdyQapbzX
         /BRQPYjXSCUKxqV4VySt2qtmdQChzJgDjHOaKBIKIiunTS4M0Tri6cg8+oloHUKu6fea
         0lvN23oDTeHouXibyNFuRU047HyJ4x10FVWG8PXq3HCwWxfw73k0Du/5cQS3q2UI4aMw
         6n0iaXvuoleswplZ6hq6ooFvh79pRM7dMJ/2JnXlBbeREZjQp6FjDrHpTvXiAPQqqOg4
         8P1+8NCII6Zz5lUh8fZmzd8ZKaD+HwwFjQZG0L+Gbqc8l/047koEQtJdFtT2hxwoqqTx
         bxtA==
X-Gm-Message-State: AOJu0Yyu2eNQlntWrqnITLoEIKv3TIi4sphk6FMGS4GN/hjZvULakTO/
	2xn0irL5IADX9MsWTmxpamMfsl8DkVUGuHoSss1ODA==
X-Google-Smtp-Source: AGHT+IHK5XOUV9ZvRPOnrg1t3Tlxv5te4wCe9nvTwkQL4QGkdcFxDRQPTSRNERmG16ySaVP7JCn5kyb/vqlQyfZEcEw=
X-Received: by 2002:a17:902:da91:b0:1c3:5df4:a778 with SMTP id
 j17-20020a170902da9100b001c35df4a778mr923257plx.13.1695998008616; Fri, 29 Sep
 2023 07:33:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230829234426.64421-1-tony.luck@intel.com> <20230928191350.205703-1-tony.luck@intel.com>
In-Reply-To: <20230928191350.205703-1-tony.luck@intel.com>
From: Peter Newman <peternewman@google.com>
Date: Fri, 29 Sep 2023 16:33:17 +0200
Message-ID: <CALPaoCjxW70h=rTNNiShEc8bmgwEaHpFnAHRB-m=ch47WdQsig@mail.gmail.com>
Subject: Re: [PATCH v6 0/8] Add support for Sub-NUMA cluster (SNC) systems
To: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>, Reinette Chatre <reinette.chatre@intel.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, x86@kernel.org, 
	Shaopeng Tan <tan.shaopeng@fujitsu.com>, James Morse <james.morse@arm.com>, 
	Jamie Iles <quic_jiles@quicinc.com>, Babu Moger <babu.moger@amd.com>, 
	Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Tony,

On Thu, Sep 28, 2023 at 9:14=E2=80=AFPM Tony Luck <tony.luck@intel.com> wro=
te:
>
> The Sub-NUMA cluster feature on some Intel processors partitions
> the CPUs that share an L3 cache into two or more sets. This plays
> havoc with the Resource Director Technology (RDT) monitoring features.
> Prior to this patch Intel has advised that SNC and RDT are incompatible.
>
> Some of these CPU support an MSR that can partition the RMID
> counters in the same way. This allows for monitoring features
> to be used (with the caveat that memory accesses between different
> SNC NUMA nodes may still not be counted accuratlely.

Is an "SNC NUMA node" a "sub-NUMA node", or a NUMA node on which SNC
has been enabled?

Thanks!
-Peter
