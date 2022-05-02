Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB9CA2908
	for <patches@lists.linux.dev>; Mon,  2 May 2022 15:15:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1651504544;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=k0PmxSPmOOMkFAuEyKaFUSMzJFbtZ7TiEfjWg6xe3gM=;
	b=EtmHq6cYEU8RklNLJCP7sDP4nXxtUGHDAJyd0c1J2McnKkfT1jE3SEGy3VYXSxSZNu5T3Y
	AQ8QYGgX6fRRm1yDW8QH8uPbxhKCEUsbgryrNY+ZBH1Q640bI7YGEFZ0mbjAZVAz5r0qr2
	RzQB3bY+uxG96zau/S4jhv21INHCqJY=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-461-zaACzSQmPWiMbkn2TJDnDw-1; Mon, 02 May 2022 11:15:41 -0400
X-MC-Unique: zaACzSQmPWiMbkn2TJDnDw-1
Received: by mail-ej1-f69.google.com with SMTP id go17-20020a1709070d9100b006f46e53a2a9so691683ejc.10
        for <patches@lists.linux.dev>; Mon, 02 May 2022 08:15:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=k0PmxSPmOOMkFAuEyKaFUSMzJFbtZ7TiEfjWg6xe3gM=;
        b=z99uTTwod56t/C1EzOPGqk1Z1qGm0wXDIPFXbQnHBKXy5wnaWF/NvLiXD1z/erZ7+f
         7OAM2Y3N+qk8f+t8bo7m9xEGM2r+d4JaHeXjhhk1/I3oFb3yYopj0mzCaWjIUZRkFxm5
         2uwo5y4/ZNbxzC5sM08XGT/Cvm5WxponI4fkTxqFsOC//9VJ1fe7b8QakaSIaNGTyC9V
         oRJLfbyD4BhTQt2OdU3RM+GdNJmULp63f7acZsJmLo5eQ4r2WwqptWx7dUzIMBeiIvAJ
         G7g16eoGNDnDFOyLui4SbRkdvJ2ntblBGFWYVlIvIkbk/9YpQ8bBC3iZtdlCF4mT3wLp
         /M8Q==
X-Gm-Message-State: AOAM532vvg8phS5CBVA2A905zsm7EAT93mVumAuvvhdVSZeARKkRzmYQ
	l1spPOXGb1JluqBjrJTNNnKYBIUy62G4BunOLtSQcVR/q8lxuls27HwWvCcRImOSfgpkFcYzfhH
	1WCcu49htmb/fNu6c0A==
X-Received: by 2002:a05:6402:1148:b0:413:11e0:1f58 with SMTP id g8-20020a056402114800b0041311e01f58mr13664143edw.113.1651504540322;
        Mon, 02 May 2022 08:15:40 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx+Wx4u3ZHl7XBE4iREwsA0F30U0LmfGsKXoUrOxDiIE238dzfMlpndx5BLZugy4pp841JHrQ==
X-Received: by 2002:a05:6402:1148:b0:413:11e0:1f58 with SMTP id g8-20020a056402114800b0041311e01f58mr13664112edw.113.1651504540096;
        Mon, 02 May 2022 08:15:40 -0700 (PDT)
Received: from [10.40.98.142] ([78.108.130.194])
        by smtp.gmail.com with ESMTPSA id dq9-20020a170907734900b006f3ef214de3sm3671912ejc.73.2022.05.02.08.15.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 May 2022 08:15:39 -0700 (PDT)
Message-ID: <13054c5c-ed48-b7a2-a800-25b9b1b1ab0d@redhat.com>
Date: Mon, 2 May 2022 17:15:39 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH v5 00/10] Introduce In Field Scan driver
To: Tony Luck <tony.luck@intel.com>, markgross@kernel.org
Cc: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, corbet@lwn.net,
 gregkh@linuxfoundation.org, andriy.shevchenko@linux.intel.com,
 jithu.joseph@intel.com, ashok.raj@intel.com, rostedt@goodmis.org,
 dan.j.williams@intel.com, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, platform-driver-x86@vger.kernel.org,
 patches@lists.linux.dev, ravi.v.shankar@intel.com
References: <20220422200219.2843823-1-tony.luck@intel.com>
 <20220428153849.295779-1-tony.luck@intel.com>
From: Hans de Goede <hdegoede@redhat.com>
In-Reply-To: <20220428153849.295779-1-tony.luck@intel.com>
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=hdegoede@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi,

On 4/28/22 17:38, Tony Luck wrote:
> Hopefully this is close enough to done to begin discussion on which
> maintainer tree will take this series.
> 
> Choices:
> 1) Hans/Mark take it into the platform-drivers tree
>    Needs an Ack from x86 maintainers on parts 1 & 2
> 2) X86 maintainers take it into TIP
>    Needs Ack from Hans/Mark on parts 2-10

I've taken a quick look at the entire series and it looks good to me.

I'm fine with this entire series getting merged through the TIP
tree, here is my ack for merging the drivers/platform/x86 bits
through the TIP tree:

Acked-by: Hans de Goede <hdegoede@redhat.com>

Regards,

Hans






> 
> TL;DR this driver loads scan test files that can check whether silicon
> in a CPU core is still running correctly. It is expected that these tests
> would be run several times per day to catch problems as silicon ages.
> 
> Changes since v4:
> 
> Greg Kroah-Hartman
> ------------------
>  "Cute way to do this, but I don't see you ever have any more devices
>  added to this list in this series."
> 
>  Removed the enum, arrays, loops, and count of test types discovered.
>  Now just check for enumeration of the single test type that is being
>  deployed on Sapphire Rapids.
> 
> 
> Jithu Joseph (7):
>   x86/microcode/intel: Expose collect_cpu_info_early() for IFS
>   platform/x86/intel/ifs: Read IFS firmware image
>   platform/x86/intel/ifs: Check IFS Image sanity
>   platform/x86/intel/ifs: Authenticate and copy to secured memory
>   platform/x86/intel/ifs: Add scan test support
>   platform/x86/intel/ifs: Add IFS sysfs interface
>   platform/x86/intel/ifs: add ABI documentation for IFS
> 
> Tony Luck (3):
>   x86/msr-index: Define INTEGRITY_CAPABILITIES MSR
>   platform/x86/intel/ifs: Add stub driver for In-Field Scan
>   trace: platform/x86/intel/ifs: Add trace point to track Intel IFS
>     operations
> 
>  .../ABI/testing/sysfs-platform-intel-ifs      |  39 ++
>  MAINTAINERS                                   |   8 +
>  arch/x86/include/asm/cpu.h                    |  18 +
>  arch/x86/include/asm/msr-index.h              |   7 +
>  arch/x86/kernel/cpu/intel.c                   |  32 ++
>  arch/x86/kernel/cpu/microcode/intel.c         |  59 +---
>  drivers/platform/x86/intel/Kconfig            |   1 +
>  drivers/platform/x86/intel/Makefile           |   1 +
>  drivers/platform/x86/intel/ifs/Kconfig        |  13 +
>  drivers/platform/x86/intel/ifs/Makefile       |   3 +
>  drivers/platform/x86/intel/ifs/core.c         |  80 +++++
>  drivers/platform/x86/intel/ifs/ifs.h          | 123 +++++++
>  drivers/platform/x86/intel/ifs/load.c         | 262 ++++++++++++++
>  drivers/platform/x86/intel/ifs/runtest.c      | 332 ++++++++++++++++++
>  drivers/platform/x86/intel/ifs/sysfs.c        | 147 ++++++++
>  include/trace/events/intel_ifs.h              |  38 ++
>  16 files changed, 1111 insertions(+), 52 deletions(-)
>  create mode 100644 Documentation/ABI/testing/sysfs-platform-intel-ifs
>  create mode 100644 drivers/platform/x86/intel/ifs/Kconfig
>  create mode 100644 drivers/platform/x86/intel/ifs/Makefile
>  create mode 100644 drivers/platform/x86/intel/ifs/core.c
>  create mode 100644 drivers/platform/x86/intel/ifs/ifs.h
>  create mode 100644 drivers/platform/x86/intel/ifs/load.c
>  create mode 100644 drivers/platform/x86/intel/ifs/runtest.c
>  create mode 100644 drivers/platform/x86/intel/ifs/sysfs.c
>  create mode 100644 include/trace/events/intel_ifs.h
> 
> 
> base-commit: af2d861d4cd2a4da5137f795ee3509e6f944a25b

