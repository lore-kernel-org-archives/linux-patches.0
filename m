Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25534174FF
	for <patches@lists.linux.dev>; Fri, 18 Aug 2023 23:31:10 +0000 (UTC)
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-1bb84194bf3so11288025ad.3
        for <patches@lists.linux.dev>; Fri, 18 Aug 2023 16:31:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692401470; x=1693006270;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=X0VrumJjXJtBH0MCiqRAB25wxy5fETy8C315CEQSkOI=;
        b=ft+lk12M+OCnTD86GAE/PP5wSCkAn9oFTEbwCyAAoJMaBda6ZdnFgCPpO4B7tPpRe+
         +mcKs11PaASJYCBHgAACWVmWv2T4It5rFrlm2Bha7hfmVf8nQegBYKBUYSV32KFvzvVV
         YYLUUcXQTZ06ReXsVlmQT5gu9EfHOgGNVWTV3i+8AIcJVpt9PhPrh9FHPm+qi2a6xDZA
         um3j+Rz8Q2V8vHvQbkqvgvPNsMT38K+s1Meirw+nybZKAdHUoaq0NcJgsxtH4OWXq9Gm
         nKxZ7+J2BbuWKIt4Dj1qVItsWCOAxYqn4n67EKZsMSJP+czKMhgV3g/nThCUmovm7Qc4
         3pCA==
X-Gm-Message-State: AOJu0YynrW26LqBPu9wVRmL5vCXkHMo1NXn6TmX9Aovqy+x65yB0hpKn
	7WWxOFwXOi/HWP4pvNuz9x+rktlanDM=
X-Google-Smtp-Source: AGHT+IHTQ4leX3gaB2UBapnVqB5I/AgZBLaIfW34OqI1+sD+yGPUlnFWei0O+z0QrwTB+gAkYxdWRw==
X-Received: by 2002:a17:903:11c6:b0:1bb:98a0:b78a with SMTP id q6-20020a17090311c600b001bb98a0b78amr830369plh.18.1692401470267;
        Fri, 18 Aug 2023 16:31:10 -0700 (PDT)
Received: from liuwe-devbox-debian-v2 ([20.69.120.36])
        by smtp.gmail.com with ESMTPSA id c11-20020a170902724b00b001bb515e6b39sm2273755pll.306.2023.08.18.16.31.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Aug 2023 16:31:09 -0700 (PDT)
Date: Fri, 18 Aug 2023 23:30:52 +0000
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
Subject: Re: [PATCH v2 14/15] asm-generic: hyperv: Use mshv headers
 conditionally. Add asm-generic/hyperv-defs.h
Message-ID: <ZN//LCO3mVzC4gv9@liuwe-devbox-debian-v2>
References: <1692309711-5573-1-git-send-email-nunodasneves@linux.microsoft.com>
 <1692309711-5573-15-git-send-email-nunodasneves@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1692309711-5573-15-git-send-email-nunodasneves@linux.microsoft.com>

On Thu, Aug 17, 2023 at 03:01:50PM -0700, Nuno Das Neves wrote:
> Add hyperv-defs.h to replace some inclusions of hyperv-tlfs.h.
> 
> It includes hyperv-tlfs.h or hvhdk.h depending on a compile-time constant
> HV_HYPERV_DEFS which will be defined in the mshv driver.
> 
> This is needed to keep unstable Hyper-V interfaces independent of
> hyperv-tlfs.h. This ensures hvhdk.h replaces hyperv-tlfs.h in the mshv driver,
> even via indirect includes.
> 
> Signed-off-by: Nuno Das Neves <nunodasneves@linux.microsoft.com>

Acked-by: Wei Liu <wei.liu@kernel.org>
