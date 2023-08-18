Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F2A917AC9
	for <patches@lists.linux.dev>; Fri, 18 Aug 2023 23:24:15 +0000 (UTC)
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-6889078ee66so1229592b3a.0
        for <patches@lists.linux.dev>; Fri, 18 Aug 2023 16:24:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692401055; x=1693005855;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GNywJLT9Zeb+aU5QBwgeatkpR3WL+zSNxCwRayoHWcE=;
        b=Ww7c3uOYMBJ9PPoFVUpO75DZiHi3vqC8IjSpYzVMyoc6L+3yxTVWKfvLQN9CV/XzWX
         Od22w5GxSa2OJUpScMoFU75sXS+HHvf7d3k1Y3kITK1SB9JenWbzRKMhtkwKioDC2TwC
         o9DWUoj0tyslnTED+iCuyBzEYiW9q6+ATNV3BrRzNlLTP6BpTmShCfekGiQaiuQrBvOi
         RqCv0QPbtyWhoMkliwlbWjOBaOmvkaxnkO/QKaBG4yDYOGcotNqrc1vwIpPOmduVye1V
         4EU9tv9GDgHHRQQdf0kQrfH4OO4KBqaAbDW+X1g/L7w7F+QGobiJRGujSS4D9QzJtJAo
         Couw==
X-Gm-Message-State: AOJu0Yw6/bD+K+c1aMzBfZM0ZgaNJxuoZkVTruEZs8Pr4KzrNA2HmRnJ
	tAZhqultle447bsaC/pmP8w=
X-Google-Smtp-Source: AGHT+IHICoDj+Bu8qaZ0k8/jKJTzFsmF4iLDzjapo9tqi6IHWto2QdWi5Mwpo6ob7C97GSpV6rcrfg==
X-Received: by 2002:a05:6a00:188f:b0:688:7948:6978 with SMTP id x15-20020a056a00188f00b0068879486978mr831088pfh.2.1692401054562;
        Fri, 18 Aug 2023 16:24:14 -0700 (PDT)
Received: from liuwe-devbox-debian-v2 ([20.69.120.36])
        by smtp.gmail.com with ESMTPSA id b1-20020aa78701000000b0068895d26b79sm2118207pfo.10.2023.08.18.16.24.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Aug 2023 16:24:14 -0700 (PDT)
Date: Fri, 18 Aug 2023 23:23:56 +0000
From: Wei Liu <wei.liu@kernel.org>
To: Nuno Das Neves <nunodasneves@linux.microsoft.com>
Cc: linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
	x86@kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-arch@vger.kernel.org, patches@lists.linux.dev,
	mikelley@microsoft.com, kys@microsoft.com, wei.liu@kernel.org,
	haiyangz@microsoft.com, decui@microsoft.com,
	apais@linux.microsoft.com, Tianyu.Lan@microsoft.com,
	ssengar@linux.microsoft.com, mukeshrathor@microsoft.com,
	stanislav.kinsburskiy@gmail.com, jinankjain@linux.microsoft.com,
	vkuznets@redhat.com, tglx@linutronix.de, mingo@redhat.com,
	bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
	will@kernel.org, catalin.marinas@arm.com
Subject: Re: [PATCH v2 09/15] Drivers: hv: Introduce hv_output_arg_exists in
 hv_common.c
Message-ID: <ZN/9jBNZYtLdYe+m@liuwe-devbox-debian-v2>
References: <1692309711-5573-1-git-send-email-nunodasneves@linux.microsoft.com>
 <1692309711-5573-10-git-send-email-nunodasneves@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1692309711-5573-10-git-send-email-nunodasneves@linux.microsoft.com>

On Thu, Aug 17, 2023 at 03:01:45PM -0700, Nuno Das Neves wrote:
> This is a more flexible approach for determining whether to allocate the
> output page.
> 
> Signed-off-by: Nuno Das Neves <nunodasneves@linux.microsoft.com>

Acked-by: Wei Liu <wei.liu@kernel.org>
