Received: from mail-il1-f173.google.com (mail-il1-f173.google.com [209.85.166.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22068125DD
	for <patches@lists.linux.dev>; Thu,  5 Oct 2023 14:34:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="d0M7KwKj"
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-il1-f173.google.com with SMTP id e9e14a558f8ab-3529f5f5dadso111585ab.0
        for <patches@lists.linux.dev>; Thu, 05 Oct 2023 07:34:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696516481; x=1697121281; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kyGuZr+XMILOMkbkU/tMvucLHAoMRZjE0tey9bhv3AE=;
        b=d0M7KwKjNSvof+xtatdto3n8O9cjLlm1vrCPZAf85Sw57tHjjnHVulSq/pEqG3/D7z
         pcQMmijN7DXTpZrpMqSm2S89akW+6yg3SC4q6gUFbA2wEf0qc3pwn/KIqnbHa71TjKXa
         i1dNGs3fo3ryJ6xI2AvJ8WXUJVHllryOSwci3OxJNHsmdzPGpPzYpr3x1hPOiI7jQxtR
         gkpp4R17/voNpjZdjJYE5rS6zN6qyHdaUHyBAg31mzICOcY/PjbvVkXFYKhQRjss9EAm
         6SzlXbu29Ucg33snwZMn0Fd7YiGfRnQTzv2XwvyXkiG75vlkj5bIsyBK4gzt3bqkjOHs
         gKjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696516481; x=1697121281;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kyGuZr+XMILOMkbkU/tMvucLHAoMRZjE0tey9bhv3AE=;
        b=HqXImhXQfY3+A+lpavN6UtZMmGh9Ddbm6JMAOzm7ptwl/SYO+OP5pl9W5JRoiBS+dK
         IQPIEERpqNJfcId1bO2m/HAuDAtYUvmt995eVu3VrCk279fgvBRIW3O4RsPrbHZGxPtr
         tAwKKCgDVCdpUfjcPGcqBM+GhxKyQunmdF8E1JeOXn1+hBni6j/+MutdaBx7DCpOwsN+
         Zuasn1OAzSUuuVWTDhzJ0JK2WUsW+VFmNvDFJrFLHsieb+/qpF5wv93lAT068ymZSNpE
         2RhOE3rUmssagNEOs9OCQC9TW5vvlSpPQJFX/N5RJnQU8V2Dcgiocj8rEgXi6bv2dbKX
         /GxQ==
X-Gm-Message-State: AOJu0YyQ5V3Gr1XApSo466bzSKBv/bNHBeK9sHo+nI4/0vrBdYvw9/lK
	viOCOyFBoRUpjeFfkT2/EmuLgluqc/xCxEaZVd8m2A==
X-Google-Smtp-Source: AGHT+IFcM9Onb+vq61O/YJOB8R9NL+8SWegKIHbaxpX90rMNBEWxlMLlcq6yQiE6GpKR0Xetr9+Vi9htuQda5VldPOk=
X-Received: by 2002:a92:cd88:0:b0:351:4bf9:5b15 with SMTP id
 r8-20020a92cd88000000b003514bf95b15mr125550ilb.28.1696516481042; Thu, 05 Oct
 2023 07:34:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230928191350.205703-1-tony.luck@intel.com> <20231003213043.13565-1-tony.luck@intel.com>
 <20231003213043.13565-4-tony.luck@intel.com>
In-Reply-To: <20231003213043.13565-4-tony.luck@intel.com>
From: Peter Newman <peternewman@google.com>
Date: Thu, 5 Oct 2023 16:34:30 +0200
Message-ID: <CALPaoCgcqc-qq_yQokyzxBTuoxpCPRSuaZGmjOg91mdU3i=D=w@mail.gmail.com>
Subject: Re: [PATCH v8 3/8] x86/resctrl: Prepare for different scope for
 control/monitor operations
To: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>, Reinette Chatre <reinette.chatre@intel.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, x86@kernel.org, 
	Shaopeng Tan <tan.shaopeng@fujitsu.com>, James Morse <james.morse@arm.com>, 
	Jamie Iles <quic_jiles@quicinc.com>, Babu Moger <babu.moger@amd.com>, 
	Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 3, 2023 at 11:30=E2=80=AFPM Tony Luck <tony.luck@intel.com> wro=
te:
>
> Resctrl assumes that control and monitor operations on a resource are
> performed at the same scope.
>
> Prepare for systems that use different scope (specifically L3 scope for
> cache control and NODE scope for cache occupancy and memory bandwidth
> monitoring).
>
> Create separate domain lists for control and monitor operations.
>
> Note that errors during initialization of either control or monitor
> functions on a domain would previously result in that domain being
> excluded from both control and monitor operations. Now the domains are
> allocated independently it is no longer required to disable both control
> and monitor operations if either fail.
>
> Signed-off-by: Tony Luck <tony.luck@intel.com>
>
> ---
>
> Changes since last version:
>
> Initialize the "type" in rdt_domain_hdr when creating domains.
> Check type has expected value before using container_of() to
> get to the surrounding structure.
>
> Rename "hw_mondom" to "hw_dom" in domain_add_cpu_mon() and
> in domain_remove_cpu_mon().
>
> Add lockdep_assert_held(&rdtgroup_mutex) to resctrl_offline_mon_domain()

Thanks!

Reviewed-by: Peter Newman <peternewman@google.com>
