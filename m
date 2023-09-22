Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D07042AB4D
	for <patches@lists.linux.dev>; Fri, 22 Sep 2023 13:30:19 +0000 (UTC)
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-7740cd2e393so103730785a.1
        for <patches@lists.linux.dev>; Fri, 22 Sep 2023 06:30:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20230601.gappssmtp.com; s=20230601; t=1695389418; x=1695994218; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=25YXU+FGYNokEvJDmLWZ05x6wqgiem9ZONDjs8ENa1c=;
        b=P4jo0c7xMANhbTaRRziuqWiSor+ITbFiWRqcGPB0DCdROLWyZ88ksyPVw7nHxL7Ig6
         aHmCLA73kpU9ItR5/O9jvRhZ7J54HcMZPJYUdYyxvE90IfZPGB5F3O0RABLOsK++MABA
         S8LtM6ZYYxKtQXwUweHWz5qrD1FIPy9aAIUCzgK0DsX+FtbBLiGmsM6alXODOVz/xvDi
         YJkkgBaILk/hh5D0hMpGKBOz4U30o3nlvukpfnS6CuUjXqUNHsT+RuVWQngFc0zzs1Q4
         wTB6NQ4lMtRvHM4zxeo9b7LS/eK2DvfjVSRtVkHYL6U1bxzEz3xa2J8UzflemiMJ0HBy
         9o/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695389418; x=1695994218;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=25YXU+FGYNokEvJDmLWZ05x6wqgiem9ZONDjs8ENa1c=;
        b=K1nVAH2RE5f0XU76Bk4RrfwvEHccgi5mJcKA9JlFi6RiNlYPp9tQlo6uhS1a0ip2qt
         zcFoCpz1mWi4RAiwreOMxTIP7aXvoa65L0aHLYXWfT1j0QXPyh+v9AuP4z+XH3RLPH0d
         5QAKEvsPoyq4vAL2++YeiF3z0BbBUZ1fC1MAdHzfHAucMuayXK6P3RSUctzBMA6MqRfP
         gA4ZP3eMNROngeQa04S1DgDIZHywzZeJnKgboI/JFx8wDneLQTyZ+y17TEomvXGawvcV
         1by1qoXhrqUq51cnu7a1yKCzFfjC0TAp38FqqWimQvhKwiF+Kg6kDWvc/nkqcmsoPSlF
         l1hw==
X-Gm-Message-State: AOJu0Yws17yPl2jShW4Cm4k00E/oGg4GhStjlAXn9k6k+d3HGdmXrUlw
	yhoeOQWycHNwRbzNfSEWbH5EgQ==
X-Google-Smtp-Source: AGHT+IGXdvy0h/AAP4iGOiWzOq4RBdacLRt7M19j/1maM6/SRiZF/MBIleQ4bgzfkum4End6z3qCgQ==
X-Received: by 2002:a05:620a:795:b0:76d:9b15:de71 with SMTP id 21-20020a05620a079500b0076d9b15de71mr7888694qka.31.1695389418545;
        Fri, 22 Sep 2023 06:30:18 -0700 (PDT)
Received: from localhost ([2620:10d:c091:400::5:ba06])
        by smtp.gmail.com with ESMTPSA id p13-20020a05620a056d00b007740c0e52edsm1240421qkp.89.2023.09.22.06.30.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Sep 2023 06:30:18 -0700 (PDT)
Date: Fri, 22 Sep 2023 09:30:17 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Michal Hocko <mhocko@suse.com>
Cc: Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>,
	Shakeel Butt <shakeelb@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org, patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, regressions@lists.linux.dev,
	mathieu.tortuyaux@gmail.com
Subject: Re: [REGRESSION] Re: [PATCH 6.1 033/219] memcg: drop
 kmem.limit_in_bytes
Message-ID: <20230922133017.GD124289@cmpxchg.org>
References: <4eb47d6a-b127-4aad-af30-896c3b9505b4@linux.microsoft.com>
 <ZQr3+YfcBM2Er6F7@dhcp22.suse.cz>
 <CALvZod7E_Jm9y+40OKtLs5EFA0ptKGjoe2BU58SY29pUiPc93g@mail.gmail.com>
 <ZQskGGAwlsr1YxAp@dhcp22.suse.cz>
 <CALvZod6b3=+=xXEUeWOQW3t_URJpeeVX46WjBHv5BS+436KoFA@mail.gmail.com>
 <ZQtRKzUOfdaVKRCF@dhcp22.suse.cz>
 <CALvZod5DSMoEGY0CwGz=P-2=Opbr4SmMfwHhZRROBx7yCaBdDA@mail.gmail.com>
 <ZQv2MXOynlEPW/bX@dhcp22.suse.cz>
 <f01b5d93-0f43-41c8-b3d8-40ef9696dcf8@linux.microsoft.com>
 <ZQwnUpX7FlzIOWXP@dhcp22.suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZQwnUpX7FlzIOWXP@dhcp22.suse.cz>

On Thu, Sep 21, 2023 at 01:21:54PM +0200, Michal Hocko wrote:
> @@ -3097,6 +3097,7 @@ static void obj_cgroup_uncharge_pages(struct obj_cgroup *objcg,
>  static int obj_cgroup_charge_pages(struct obj_cgroup *objcg, gfp_t gfp,
>  				   unsigned int nr_pages)
>  {
> +	struct page_counter *counter;
>  	struct mem_cgroup *memcg;
>  	int ret;
>  
> @@ -3107,6 +3108,10 @@ static int obj_cgroup_charge_pages(struct obj_cgroup *objcg, gfp_t gfp,
>  		goto out;
>  
>  	memcg_account_kmem(memcg, nr_pages);
> +
> +	/* There is no way to set up kmem hard limit so this operation cannot fail */
> +	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
> +		WARN_ON(!page_counter_try_charge(&memcg->kmem, nr_pages, &counter));

This hunk doesn't look quite right.

static void memcg_account_kmem(struct mem_cgroup *memcg, int nr_pages)
{
	mod_memcg_state(memcg, MEMCG_KMEM, nr_pages);
	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys)) {
		if (nr_pages > 0)
			page_counter_charge(&memcg->kmem, nr_pages);
		else
			page_counter_uncharge(&memcg->kmem, -nr_pages);
	}
}

Other than that, please add

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
