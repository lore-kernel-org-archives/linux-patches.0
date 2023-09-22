Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A883542C11
	for <patches@lists.linux.dev>; Fri, 22 Sep 2023 18:53:53 +0000 (UTC)
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-690fe10b6a4so2371709b3a.3
        for <patches@lists.linux.dev>; Fri, 22 Sep 2023 11:53:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695408833; x=1696013633;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XyufS6U3IQklYUt2ci6ahYWNxLqO+WW3OlDCROay6ew=;
        b=ae6/n9u2mLJbZQMmPcGflUUqOj0iWkjqV+jndnkyi1uyzufvhmc0QpQJIFstjVWVbA
         E6hxw7NfUJwWEVcGl8tHxvKISFPCFGBOo3HfwDKcm2Gadp8kJRXU2WcTEA9TTrSY8NKh
         thFFE7m8TOkcKIcXSh08SfEa1Gsbx8SgdMavn2/KZMuLu9Lbz+AuBxWN7h85JkBpAqqY
         EFT73AJRnSdr1uH85JjItAavCwz4vfZEeB/CMvCbqFxzCtoJObh186TzN3JMponBDSdC
         zPQtpis/ZDTogqqnwcewwm0A8fcCR+oe5jKE23b7/MYNLbokxocDFJDTzTwvzbMqXRUr
         c00Q==
X-Gm-Message-State: AOJu0Yz6XBFztCTASRjM3cpEGyB70QpOEy/OmPTUoVX6dX6+1lWnWnqQ
	1gAyKaCPIF4uqi4WI9mwrJs=
X-Google-Smtp-Source: AGHT+IGOzg9RTsyttQDdVui32fWhrE83yhzu41HT1TK1Q9puqq0koGTP4Espho+J5bs0KrsUPw9zQg==
X-Received: by 2002:a05:6a00:10c8:b0:690:cd6e:8d38 with SMTP id d8-20020a056a0010c800b00690cd6e8d38mr227642pfu.25.1695408833024;
        Fri, 22 Sep 2023 11:53:53 -0700 (PDT)
Received: from liuwe-devbox-debian-v2 ([20.69.120.36])
        by smtp.gmail.com with ESMTPSA id b124-20020a633482000000b00563df2ba23bsm3460692pga.50.2023.09.22.11.53.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Sep 2023 11:53:52 -0700 (PDT)
Date: Fri, 22 Sep 2023 18:53:09 +0000
From: Wei Liu <wei.liu@kernel.org>
To: Nuno Das Neves <nunodasneves@linux.microsoft.com>
Cc: linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
	x86@kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-arch@vger.kernel.org, patches@lists.linux.dev,
	mikelley@microsoft.com, kys@microsoft.com, wei.liu@kernel.org,
	gregkh@linuxfoundation.org, haiyangz@microsoft.com,
	decui@microsoft.com, apais@linux.microsoft.com,
	Tianyu.Lan@microsoft.com, ssengar@linux.microsoft.com,
	mukeshrathor@microsoft.com, stanislav.kinsburskiy@gmail.com,
	jinankjain@linux.microsoft.com, vkuznets@redhat.com,
	tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
	dave.hansen@linux.intel.com, hpa@zytor.com, will@kernel.org,
	catalin.marinas@arm.com
Subject: Re: [PATCH v3 02/15] mshyperv: Introduce hv_get_hypervisor_version
 function
Message-ID: <ZQ3ilYnlBYaPMXxG@liuwe-devbox-debian-v2>
References: <1695407915-12216-1-git-send-email-nunodasneves@linux.microsoft.com>
 <1695407915-12216-3-git-send-email-nunodasneves@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1695407915-12216-3-git-send-email-nunodasneves@linux.microsoft.com>

On Fri, Sep 22, 2023 at 11:38:22AM -0700, Nuno Das Neves wrote:
> x86_64 and arm64 implementations to get the hypervisor version
> information. Store these in hv_hypervisor_version_info structure to
> simplify parsing the fields.
> 
> Replace the existing parsing when printing the version numbers at boot.
> 
> Signed-off-by: Nuno Das Neves <nunodasneves@linux.microsoft.com>

Acked-by: Wei Liu <wei.liu@kernel.org>
