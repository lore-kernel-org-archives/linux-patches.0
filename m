Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B68E5F9D5
	for <patches@lists.linux.dev>; Thu, 17 Aug 2023 23:02:04 +0000 (UTC)
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-1bc3d94d40fso2777745ad.3
        for <patches@lists.linux.dev>; Thu, 17 Aug 2023 16:02:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692313324; x=1692918124;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SwtAWZyaQZccFsvrQPELO3aY17uRAQUdwXsYLsWxG84=;
        b=SJz+JS0kmlmT5XkEfpFfqVO44LP/5i1YgrE49zJ6aeyumE+K8S0tDpll/g5dKU+gvb
         HZjZCKf0eP2/9jKd8xvjc5pzOJpkM6u2oqXvdxMSxgBYv4E9gg29uPOAEvbGZJflYzDH
         lvRs/YfMikglPF7M9x6JnG7Uv2i9WJUYI2hbg4in5/MalF5Vetr9IblddgpGwapWB01w
         Smmmlr8DV+FAc0PlAhpR5JZVS0xscA+xg/Bhz3BWrco58zq+T9TIbaAeGkQ7o1M0TTjM
         8QE3g8gZr1arOMPAUJtiryD4+ibxdKQX++EGv8O1aWhLgUGq9UmzZIZ5dl3E/zqxlHYy
         NlDg==
X-Gm-Message-State: AOJu0YweKoDZG54AzBEmDJyRhhPmSr1NX4N0EuBUZASGO22rTVcUWMkI
	gI3koUdXCD3nRC0CAQRBVBc=
X-Google-Smtp-Source: AGHT+IG2BFK2vmrhXuy5TCdio2ggF+9peVt2is7fV6FO/H95rTuj26QpxJj97gw/YuQUb7+KJafrLg==
X-Received: by 2002:a17:902:d510:b0:1b6:c229:c350 with SMTP id b16-20020a170902d51000b001b6c229c350mr1154091plg.18.1692313324012;
        Thu, 17 Aug 2023 16:02:04 -0700 (PDT)
Received: from liuwe-devbox-debian-v2 ([20.69.120.36])
        by smtp.gmail.com with ESMTPSA id jg1-20020a17090326c100b001bb04755212sm290077plb.228.2023.08.17.16.02.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Aug 2023 16:02:03 -0700 (PDT)
Date: Thu, 17 Aug 2023 23:01:46 +0000
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
	will@kernel.org, catalin.marinas@arm.com,
	Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v2 13/15] uapi: hyperv: Add mshv driver headers hvhdk.h,
 hvhdk_mini.h, hvgdk.h, hvgdk_mini.h
Message-ID: <ZN6m2gVmtVStuEfA@liuwe-devbox-debian-v2>
References: <1692309711-5573-1-git-send-email-nunodasneves@linux.microsoft.com>
 <1692309711-5573-14-git-send-email-nunodasneves@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1692309711-5573-14-git-send-email-nunodasneves@linux.microsoft.com>

On Thu, Aug 17, 2023 at 03:01:49PM -0700, Nuno Das Neves wrote:
> Containing hypervisor ABI definitions to use in mshv driver.
> 
> Version numbers for each file:
> hvhdk.h		25212
> hvhdk_mini.h	25294
> hvgdk.h		25125
> hvgdk_mini.h	25294
> 
> These are unstable interfaces and as such must be compiled independently
> from published interfaces found in hyperv-tlfs.h.
> 
> These are in uapi because they will be used in the mshv ioctl API.
> 
> Signed-off-by: Nuno Das Neves <nunodasneves@linux.microsoft.com>
> Acked-by: Wei Liu <wei.liu@kernel.org>

There were some concerns raised internally about the stability of the
APIs when they are put into UAPI.

I think this is still okay, for a few reasons:

  1. When KVM was first introduced into the kernel tree, it was
     experimental. It was only made stable after some time.
  2. There are other experimental or unstable APIs in UAPI. They
     are clearly marked so.
  3. The coda file system, which has been in tree since 2008, has a
     header file in UAPI which clearly marks as experimental.

All in all introducing a set of unstable / experimental APIs under UAPI
is not unheard of. Rules could've changed now, but I don't find any
document under Documentation/.

I think it will be valuable to have this driver in tree sooner rather
than later, so that it can evolve with Linux kernel, and we can in turn
go back to the hypervisor side to gradually stabilize the APIs.

Greg, I'm told that you may have a strong opinion in this area. Please
let me know what you think about this.

KY, do you have an opinion here?

Thanks,
Wei.
