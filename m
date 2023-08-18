Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11BA417AC9
	for <patches@lists.linux.dev>; Fri, 18 Aug 2023 23:22:30 +0000 (UTC)
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-1bf55a81eeaso2018165ad.0
        for <patches@lists.linux.dev>; Fri, 18 Aug 2023 16:22:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692400950; x=1693005750;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7qYtGq59zin9uHa3ggwJoqxjied2x9Zxiu9P/symY5c=;
        b=XPUTRPL+UMZk1nb0ObNubjWwR5VzdUy/kMBXMJNxC/eGKp630q8P2sqYrVOSHf0rIy
         y0s5h9GDrOh7aFBjcRiQqc8TeLMk9QVIMXxAKxwd0A/o/9WaFvA4+VHfMZRHNhZu2UvX
         u6Nakr43OOqe8qozPWp5yDYYtwbQBzZKpRsVsr1no1XaMYx0w90rYx6qjdIaWGg/bOWM
         hKJihRkXHxPOv0+2UZkWBp7q+rnW2cwgk9Po03wb9hVfrRbkg94c931orl96xN02G57g
         9WLm1WO3ZTk8rqO3n2gjqCuMBHJm4dTuKMecTMM3K5xz1GjOaiui11NIu8HYytPBw1Nv
         Yj7w==
X-Gm-Message-State: AOJu0YyI3Wss8uY+HcA+t9x00r1kkjqFwgcSuDhLUrwV4WTBXb+kExiA
	iF7uNh8gm2tvA3fx4e9gCHA=
X-Google-Smtp-Source: AGHT+IEKSrt1dc+AYw5tbCHnGumAQmr7S5KGpU/LDuisCST2TbkwtFJexNytNi5qJnGEvHVTR2tWqg==
X-Received: by 2002:a17:902:d511:b0:1bc:5e50:9345 with SMTP id b17-20020a170902d51100b001bc5e509345mr671945plg.50.1692400950200;
        Fri, 18 Aug 2023 16:22:30 -0700 (PDT)
Received: from liuwe-devbox-debian-v2 ([20.69.120.36])
        by smtp.gmail.com with ESMTPSA id n4-20020a170902968400b001bbb7af4963sm2292110plp.68.2023.08.18.16.22.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Aug 2023 16:22:29 -0700 (PDT)
Date: Fri, 18 Aug 2023 23:22:12 +0000
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
Subject: Re: [PATCH v2 05/15] hyperv: Move hv_connection_id to hyperv-tlfs
Message-ID: <ZN/9JDlUAFFdEVGU@liuwe-devbox-debian-v2>
References: <1692309711-5573-1-git-send-email-nunodasneves@linux.microsoft.com>
 <1692309711-5573-6-git-send-email-nunodasneves@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1692309711-5573-6-git-send-email-nunodasneves@linux.microsoft.com>

On Thu, Aug 17, 2023 at 03:01:41PM -0700, Nuno Das Neves wrote:
> The definition conflicts with one added in hvgdk.h as part of the mshv
> driver so must be moved to hyperv-tlfs.h.
> 
> This structure should be in hyperv-tlfs.h anyway, since it is part of
> the TLFS document.
> 
> Signed-off-by: Nuno Das Neves <nunodasneves@linux.microsoft.com>

Acked-by: Wei Liu <wei.liu@kernel.org>
