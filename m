Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F3243358BE
	for <patches@lists.linux.dev>; Wed, 12 Nov 2025 13:08:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762952898; cv=none; b=u8B8NcAsSMGCYWsam/1dSaMxIIKsoBvIwaqk1/uDoLCB4E3ExPO0Nb8pLLlaYJImjtHMWTVJ8e2dCu5vwuLrwJSnQDcq4IdtDD/gTIHT98bJvFsjyxUJnjD9ZCeaumRTOw9Al6fiaywfsvjtJ9GDDPAYxXBZCLAW8z8blZPdFRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762952898; c=relaxed/simple;
	bh=5BUX+aPleMlR+0TV9/SdhpG8VKnucDfm0cN98ifo74I=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oWlx5RUJBHaELsBJ//fYDowgGoJrOhbjRLildQdM3lD2bZDyMRPOZQeODuVBsTEvsWjk1woz3KLaBpKfmFl1RCUvR1abxWB2ixMxCxkXbSyMXefGO7gaRWDREI545uPznjYYti5gRN88n3FFFYPukEpr0BDBfcvSP33gdJPK6R4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eoc/9eOH; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eoc/9eOH"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-477619f8ae5so6320545e9.3
        for <patches@lists.linux.dev>; Wed, 12 Nov 2025 05:08:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762952895; x=1763557695; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rZszFFp41//TiDs/7bMBLMV0kim0Oaw39R679g7Q4aw=;
        b=eoc/9eOHDKcTkk1YlXFskGW9vyKS6JG0Wow9n0Wl0e8GVmoALeJNHZuvJhNkU9pXUb
         Bk8w1qJlFrF3jwOsg7vzuUEr95t+YdpsKwkCVJB/Q5H8rYH6p2aF1cwMEjpoQTwcXArY
         raVwr96L+jnBC+9tk13tKImizBR0C2Hb2DS4rcBNvWKLaNH24fmAHdkH+n42dBIKnSvX
         pOlt2jEt9YJgw42B4fcFf5FQhjB1u4H+PqjeYEJMX+7AtLf9ICktGBXCDf9G/VedU9CZ
         sjrT++Mjug0iTVTyb1XLPZnHpXTNAKefKnYvg0tea8KGkO+7KncRyr3ftOcT2VNKNhNx
         82bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762952895; x=1763557695;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=rZszFFp41//TiDs/7bMBLMV0kim0Oaw39R679g7Q4aw=;
        b=UloBYZF8IOgLSFx5LWrLpXNTcWXyjJ/0RMMb3r3ujZn459N5ozOhUco9sWsgl/wP0R
         J476RAil1WHqWuXtn/iNacj5jwqt0PzY7sKhB/ufr/7W++VQGIjRPsKrE4fpMhvbgvCl
         agtZPm+MQHa5FuJMsVJfpw1EMBkm3r+olhx1nh5+K8jo9Xb+hzka5+1cy5Ol1pX9oA9c
         Qnzc2fZWdge2Vl1dC7CqHFi4K0kI4GyXATXNi2XSKjGy8Vs1ahS+frTl/SrPNl7WBwfg
         iYLpeqTsdxpxmsERmciSzSnwAwv00Zo2yS+dx4IO3G0WVTUKKyCFw2phF3mtsbkuf+Of
         Htgg==
X-Forwarded-Encrypted: i=1; AJvYcCVlD/71FE/Y3njVgNqYQDRpU5iQVDIyyWY7zDjM+Jo8Y7z1ePXwNOJPvhCuvb+ueLCjClJ/7BDX@lists.linux.dev
X-Gm-Message-State: AOJu0YznCYVOxgDT+LOuzhVyTF7VOQz88zNsZtXZYyWAEhajPNXL5YB3
	ulAZOEHpz6UKqS58m2tTYg5did87pnpXJpjus3oDOGMnZHcczTVvQl0X
X-Gm-Gg: ASbGncsfreTfJCpWrZIXcw2t7M+XjIxq32E1aKG+Fxb+/MuOEBswmVXKLmuWX2sHQt/
	yGSXPGEH/yVkrgSOvx1FcJgMIGXLgSwh6+saqx+VTUf9XJtzn9Nrua/Vpy3HPbqXD9GciAQq4V9
	UsU9UL+q31JKqTa8KYNt46lqXf5U9O64+Roh+4iLm1ewzVaD3/ynSGGvjXg7sHLTSn2ARQ6hjpr
	ZjFEf3yI5pbn7ZFnnVkOVg59q0ayupzDfWl7+gpY08VuVrX+I17IRFhXyU2s7jg+u36ciD4QHTS
	+rvp5MO8tsNHddhTo0w7Tz9oqwaWLKrUkEesyqc0H5e1IrdKZVSwrCO2ViHmpavQ7TJv62BdTA3
	HJx8kY6wNPkjewip26jxYaPxVUFBVHWSWCo/HvdNcUfl0xCo89IuIAL4Sf4uKpdLYlOfCptOnPz
	1V29fiuenrrVEDQL9mcjT6eMMzXgY+NSwQIVjUcI4IEQ==
X-Google-Smtp-Source: AGHT+IHL9AQYgo6qFd6z0/B2T05jAm1hrIoKtL5TpQMpLpCe7ZFr6wNffq1HGZAD0MUTPoLFq+5yjg==
X-Received: by 2002:a5d:5889:0:b0:42b:3c25:cd07 with SMTP id ffacd0b85a97d-42b4bdd2288mr2450774f8f.61.1762952894523;
        Wed, 12 Nov 2025 05:08:14 -0800 (PST)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42b4789896esm8318176f8f.38.2025.11.12.05.08.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Nov 2025 05:08:14 -0800 (PST)
Date: Wed, 12 Nov 2025 13:08:12 +0000
From: David Laight <david.laight.linux@gmail.com>
To: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghuay@nvidia.com>, Reinette Chatre
 <reinette.chatre@intel.com>, Maciej Wieczor-Retman
 <maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
 James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, Drew
 Fustini <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
 <yu.c.chen@intel.com>, x86@kernel.org, linux-kernel@vger.kernel.org,
 patches@lists.linux.dev
Subject: Re: [PATCH v13 12/32] x86,fs/resctrl: Support binary fixed point
 event counters
Message-ID: <20251112130812.51532c2e@pumpkin>
In-Reply-To: <20251029162118.40604-13-tony.luck@intel.com>
References: <20251029162118.40604-1-tony.luck@intel.com>
	<20251029162118.40604-13-tony.luck@intel.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 29 Oct 2025 09:20:55 -0700
Tony Luck <tony.luck@intel.com> wrote:

> resctrl assumes that all monitor events can be displayed as unsigned
> decimal integers.
> 
> Hardware architecture counters may provide some telemetry events with
> greater precision where the event is not a simple count, but is a
> measurement of some sort (e.g. Joules for energy consumed).
> 
> Add a new argument to resctrl_enable_mon_event() for architecture code
> to inform the file system that the value for a counter is a fixed-point
> value with a specific number of binary places.
> Only allow architecture to use floating point format on events that the
> file system has marked with mon_evt::is_floating_point.
> 
> Display fixed point values with values rounded to an appropriate number
> of decimal places for the precision of the number of binary places
> provided. Add one extra decimal place for every three additional binary
> places, except for low precision binary values where exact representation
> is possible:
> 
>   1 binary place is 0.0 or 0.5			=> 1 decimal place
>   2 binary places is 0.0, 0.25, 0.5, 0.75	=> 2 decimal places
>   3 binary places is 0.0, 0.125, etc.		=> 3 decimal places
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
> ---
>  include/linux/resctrl.h            |  3 +-
>  fs/resctrl/internal.h              |  8 +++
>  arch/x86/kernel/cpu/resctrl/core.c |  6 +--
>  fs/resctrl/ctrlmondata.c           | 84 ++++++++++++++++++++++++++++++
>  fs/resctrl/monitor.c               | 10 +++-
>  5 files changed, 105 insertions(+), 6 deletions(-)
> 
> diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
> index 702205505dc9..a7e5a546152d 100644
> --- a/include/linux/resctrl.h
> +++ b/include/linux/resctrl.h
> @@ -409,7 +409,8 @@ u32 resctrl_arch_get_num_closid(struct rdt_resource *r);
>  u32 resctrl_arch_system_num_rmid_idx(void);
>  int resctrl_arch_update_domains(struct rdt_resource *r, u32 closid);
>  
> -void resctrl_enable_mon_event(enum resctrl_event_id eventid, bool any_cpu);
> +void resctrl_enable_mon_event(enum resctrl_event_id eventid, bool any_cpu,
> +			      unsigned int binary_bits);
>  
>  bool resctrl_is_mon_event_enabled(enum resctrl_event_id eventid);
>  
> diff --git a/fs/resctrl/internal.h b/fs/resctrl/internal.h
> index 40b76eaa33d0..f5189b6771a0 100644
> --- a/fs/resctrl/internal.h
> +++ b/fs/resctrl/internal.h
> @@ -62,6 +62,9 @@ static inline struct rdt_fs_context *rdt_fc2context(struct fs_context *fc)
>   *			Only valid if @evtid is an MBM event.
>   * @configurable:	true if the event is configurable
>   * @any_cpu:		true if the event can be read from any CPU
> + * @is_floating_point:	event values are displayed in floating point format
> + * @binary_bits:	number of fixed-point binary bits from architecture,
> + *			only valid if @is_floating_point is true
>   * @enabled:		true if the event is enabled
>   */
>  struct mon_evt {
> @@ -71,6 +74,8 @@ struct mon_evt {
>  	u32			evt_cfg;
>  	bool			configurable;
>  	bool			any_cpu;
> +	bool			is_floating_point;
> +	unsigned int		binary_bits;
>  	bool			enabled;
>  };

Nit: You've added 4 bytes of padding.

	David
