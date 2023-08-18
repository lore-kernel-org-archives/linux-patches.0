Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0403317AC9
	for <patches@lists.linux.dev>; Fri, 18 Aug 2023 23:23:31 +0000 (UTC)
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-1bdbf10333bso12061855ad.1
        for <patches@lists.linux.dev>; Fri, 18 Aug 2023 16:23:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692401011; x=1693005811;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1h2USv9/D30/s9txAiqRvw8UknERd9pDiuV16mFYCUg=;
        b=aQ/jEvaTT77Qyjx4NdR/t3HvgS5+mBAgMyE7eDc53xL5Nk268M0PpiPTQz1WDxm4qe
         u3SpEqsi2qw4ooJPqEECzIkirhEEzrSgh0WCm1DiUzDUrjXlhNd/Yq8uQDv35h6n5LDw
         f48M8ZoYXoLUjP4GgoX4bnzuXcylHeaZjjvuQ+xu0Hz7d/KBmXRhPJCfJGRxk0p0+ZHS
         RpWAEZzjfMJhTa7Z81XMkgjJtde/ZxjAnaZiaFYJhbmp2ckSCmFTEg9IfoHgj1lzJQrH
         U9xv0uJeYKtG0BC4QB3b+BxLva1RZ3J6UNwVp9OFM11pHk4jDquHIYq0dCWTTxxUz2c/
         U8Ew==
X-Gm-Message-State: AOJu0YysxXk/S8ppsZp9RtDBxR0OlnX6LZ6McQ4HxcKME5VFLPTH+8LV
	GD8kMvihEFGqcZ9X+NcWC+I=
X-Google-Smtp-Source: AGHT+IF9qWGcmBVVfF0EL+9TcYfKNHMZhClqyBpQhnA0cOKHPR3KnalzNL144dlz2GUaB7RJXZboAw==
X-Received: by 2002:a17:902:c381:b0:1b8:4baa:52ff with SMTP id g1-20020a170902c38100b001b84baa52ffmr679420plg.47.1692401011347;
        Fri, 18 Aug 2023 16:23:31 -0700 (PDT)
Received: from liuwe-devbox-debian-v2 ([20.69.120.36])
        by smtp.gmail.com with ESMTPSA id 12-20020a170902ee4c00b001bbb1eec92dsm2296658plo.224.2023.08.18.16.23.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Aug 2023 16:23:30 -0700 (PDT)
Date: Fri, 18 Aug 2023 23:23:13 +0000
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
Subject: Re: [PATCH v2 06/15] hyperv-tlfs: Introduce hv_status_to_string and
 hv_status_to_errno
Message-ID: <ZN/9YfdgFuC0EEXO@liuwe-devbox-debian-v2>
References: <1692309711-5573-1-git-send-email-nunodasneves@linux.microsoft.com>
 <1692309711-5573-7-git-send-email-nunodasneves@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1692309711-5573-7-git-send-email-nunodasneves@linux.microsoft.com>

On Thu, Aug 17, 2023 at 03:01:42PM -0700, Nuno Das Neves wrote:
> hv_status_to_errno translates hyperv statuses to linux error codes.
> This is useful for returning something linux-friendly from a hypercall
> helper function.
> 
> hv_status_to_string improves clarity of error messages.
> 
> Signed-off-by: Nuno Das Neves <nunodasneves@linux.microsoft.com>

Acked-by: Wei Liu <wei.liu@kernel.org>
