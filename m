Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 265BC9474
	for <patches@lists.linux.dev>; Tue, 14 Nov 2023 04:15:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="RNnr6bXF"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-1cc3bc5df96so37691565ad.2
        for <patches@lists.linux.dev>; Mon, 13 Nov 2023 20:15:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1699935300; x=1700540100; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=OUC30dXlQK5fmzms4eR9YZ2PZDBao2AfV4/azmUSi6E=;
        b=RNnr6bXF46WRerDe7i3/jLJ3Fdqe1C0d6Hbudkv+X23qJVEtwdPt532w1sLybP2bqy
         1QktMSp0iRivd+s7bUbMXChvIkoShZa5irJwKGvy/6STi0R1l9R7648WwZheIuAvMZip
         62v3bKdPyy8lGwlVHPamHMWU9+TvcnMmYYExU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699935300; x=1700540100;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OUC30dXlQK5fmzms4eR9YZ2PZDBao2AfV4/azmUSi6E=;
        b=aud4Dh8rPTZxDr+Zo7gp+hVZhuZTDzg5vRZQ++OZqAIm/VxIKYWUm6/7qBQc4Qaj/y
         4gRRSU6hZnw7HwK0oIiSwQ+KI1EAPRejDysfl/k7a2SziodYnVrHrWUNbvn26/iSWXr8
         0tbnh/SjVB1ZiiWufdnZYBBLMFx/SJ2H08Zmh8QBxRa6YWO7Jvq5CDgaG2ig7XdGHC8s
         5IxAASWh9g5iS8CL6iOxR3jDzAVtp2L5h/YpCvrN1I99Z7RhGmDsXQiFh0Aa8jRWDXmM
         Yz6knjo27b065GZUZC3QUQ351QKYX/XpeDO7TM5/peIgNX+I3XWVbcXVtw2MmVpTrK+7
         tpBA==
X-Gm-Message-State: AOJu0Yx4FWgUz/V5uoBsQz1dhC7srpo30sOvQ08D0xFY7+ZI1f9ikZNQ
	cNrd/gwen+dKNNzH7oe11wXaqg==
X-Google-Smtp-Source: AGHT+IEmPIYVtjWrKxgWx/6E037p3LrYP3ZvBjQTSGRoCVVM2HVRsHTaY6qgDIjr5rZO1Nl3XZts5A==
X-Received: by 2002:a17:902:7d8e:b0:1c5:d063:b70e with SMTP id a14-20020a1709027d8e00b001c5d063b70emr1114726plm.53.1699935300585;
        Mon, 13 Nov 2023 20:15:00 -0800 (PST)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id iw17-20020a170903045100b001c9cc44eb60sm4799660plb.201.2023.11.13.20.15.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Nov 2023 20:15:00 -0800 (PST)
Date: Mon, 13 Nov 2023 20:14:59 -0800
From: Kees Cook <keescook@chromium.org>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: David Rientjes <rientjes@google.com>, Christoph Lameter <cl@linux.com>,
	Pekka Enberg <penberg@kernel.org>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Hyeonggon Yoo <42.hyeyoo@gmail.com>,
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Alexander Potapenko <glider@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Marco Elver <elver@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Shakeel Butt <shakeelb@google.com>,
	Muchun Song <muchun.song@linux.dev>, kasan-dev@googlegroups.com,
	cgroups@vger.kernel.org
Subject: Re: [PATCH 04/20] mm/memcontrol: remove CONFIG_SLAB #ifdef guards
Message-ID: <202311132014.F03494F@keescook>
References: <20231113191340.17482-22-vbabka@suse.cz>
 <20231113191340.17482-26-vbabka@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231113191340.17482-26-vbabka@suse.cz>

On Mon, Nov 13, 2023 at 08:13:45PM +0100, Vlastimil Babka wrote:
> With SLAB removed, these are never true anymore so we can clean up.
> 
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
