Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07C40AD49
	for <patches@lists.linux.dev>; Fri, 26 Jul 2024 19:13:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722021197; cv=none; b=f9X94GnzsznA9B8ACk7M/C1FHarBl5pbQRJJq/Y1JIageDiCqP+cSowaA0rGqZjajPSiSfLUXDxzLg58TUsaem5GCheW7JmstIHPrQUo9vJXWtyHNPMdSC6Ae1opgV96HrVdSJfKah/GhzBJHLaJhabNiHXRT7S1jYiJnTqUXI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722021197; c=relaxed/simple;
	bh=Z5UlAtnTF9WSQAqLlLAvp2MEr23WG6FTbF75OVh6LZI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QvBeII/d3CRLaSH/mBH5KpdbyFpX0F1K6nbreNVuG+xhfENpv4QYZwLzwziyxJsj+g/4DYXxex03WgLv/HTI7+dUky+ViISIScE3iqThAIHdjImvwTUWKKijpbu2uLRizGJFDzRLCxD1YJDxjqLhYHLTXSYKIYdeMBxX3XL0hxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MC3ZAbg1; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MC3ZAbg1"
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-5a1b073d7cdso2920a12.0
        for <patches@lists.linux.dev>; Fri, 26 Jul 2024 12:13:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722021194; x=1722625994; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=01an1fmFYRDQJTBO7gd4IKDbgwU3h9H9PepxoxmslqI=;
        b=MC3ZAbg1ZS3GM5G67pfuL22n8k77bh7SbDgiAB0tL1ViihxwR+wNb0aiUs/DDQlU3r
         oUuUyQjeBtVDR8vRcZFfv4Gxz63vAlQaRVJmhavlacT37Ei7ee9gIvhx8ZkmK1iz2vuy
         EHttv8LR/fvMIzEZpHJPBD5+sQw8t54SdLWGz0CTQdRdl3seeMnf6l1eLiW+Z/wy9hhs
         QzrTSqY8culhRCYUpiV3FI5disUaGziMUuj5RI9WeoFYo5mMIL8LmriuLBabW8+dEH6f
         iezEJIBBO1zUHRyQM5sYn5CaSlKwqflxjNLgf8BQz55HqY22riubvTZeVYZHP7akyYlh
         7qnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722021194; x=1722625994;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=01an1fmFYRDQJTBO7gd4IKDbgwU3h9H9PepxoxmslqI=;
        b=r00hBSOPWz50z5yuITwSh/dVx552r7DdRT860wdy5Xgf1yAGfEs/4ClMWwnQZIEYqA
         qCkyNwKaFoGnkkj3SoPLUmjaxBpqu3Yz23iJJguU9+kyXPJFeGAAM8/fgS3TSOyVo18v
         PMrxoB1SVXQr9+UriqrgMWEFT1M1Bq9TGqwJwYPsvWozNg/Mi4KWLPnNtqEHJr8ryTPN
         4RRJ5tscTKNWinC1gjjDCqzNaRLaGXkjvTTKfgjduRUNQQdSyWT8njvUkaqRZFSl9SVH
         0WTQzuZqX3LKtOTbTJH9LRlyaXojbVEG0nvSk2fzkwZElWwOxJIyiAt0Q9N/TTr8Yw1a
         oF4w==
X-Forwarded-Encrypted: i=1; AJvYcCU8BdNNY2VYDYuLEIBUFphUG5IlMZ+xz2yO2+BLB8Y82cuSsXYSNuDqmHUp/lhAGevMVcJltjFuwRJV733lt/LgFFC0NESYjA==
X-Gm-Message-State: AOJu0YwUAvAV9k1asySQwPKnqlvMiajZTfywkregNCzgDYIVf9mgDrrT
	RNi1qklSAKqHXNfOsY229TnhOgdc6kB+1uk/UuJBS5TC6KTFLmKqporHn516fhTZGQ6WIp1z/jd
	iw4lWD43zVCj8OIUxIQQueecO+BWtq8Vwv5NM
X-Google-Smtp-Source: AGHT+IG6mMrOZ4gNjU9BtmgU/rGItqFM0VN7m3T+9TaefO+8m0IQ2eDFcUytlYr/Z0H9vDTWa2qrbVkQjzLAovseISo=
X-Received: by 2002:a05:6402:27c7:b0:57d:436b:68d6 with SMTP id
 4fb4d7f45d1cf-5b034352b98mr13791a12.7.1722021194118; Fri, 26 Jul 2024
 12:13:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240628215619.76401-1-tony.luck@intel.com> <20240628215619.76401-7-tony.luck@intel.com>
In-Reply-To: <20240628215619.76401-7-tony.luck@intel.com>
From: Peter Newman <peternewman@google.com>
Date: Fri, 26 Jul 2024 12:13:02 -0700
Message-ID: <CALPaoCihZZXJDYmjZJP8nXyiUh7CdLKkKDyaOwb1yRRXWxXrNQ@mail.gmail.com>
Subject: Re: [PATCH v23 06/19] x86/resctrl: Introduce snc_nodes_per_l3_cache
To: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>, Reinette Chatre <reinette.chatre@intel.com>, 
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>, James Morse <james.morse@arm.com>, 
	Babu Moger <babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, 
	Dave Martin <Dave.Martin@arm.com>, x86@kernel.org, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Tony,

On Fri, Jun 28, 2024 at 2:56=E2=80=AFPM Tony Luck <tony.luck@intel.com> wro=
te:
> @@ -1022,8 +1066,8 @@ int __init rdt_get_mon_l3_config(struct rdt_resourc=
e *r)
>         int ret;
>
>         resctrl_rmid_realloc_limit =3D boot_cpu_data.x86_cache_size * 102=
4;
> -       hw_res->mon_scale =3D boot_cpu_data.x86_cache_occ_scale;
> -       r->num_rmid =3D boot_cpu_data.x86_cache_max_rmid + 1;
> +       hw_res->mon_scale =3D boot_cpu_data.x86_cache_occ_scale / snc_nod=
es_per_l3_cache;
> +       r->num_rmid =3D (boot_cpu_data.x86_cache_max_rmid + 1) / snc_node=
s_per_l3_cache;

I noticed that resctrl_arch_system_num_rmid_idx() still returns a
value based on the original, undivided x86_cache_max_rmid. In my local
testing, this resulted in the alloc_rmid() returning values too large
for the arch_mbm_-arrays.

Please take a look at the patch I shared[1] to try to address this.

Thanks!
-Peter

[1] https://lore.kernel.org/lkml/20240722204611.3549213-1-peternewman@googl=
e.com/
