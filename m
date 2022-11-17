Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96D967C
	for <patches@lists.linux.dev>; Thu, 17 Nov 2022 08:51:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1668675094;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9Myyg+bLdQelD4D9kVUB3s2sr8LVncKivkUt152IISU=;
	b=a2sGszdLYLEoU0zVjpjv/YhLb03AazPQUqjE1DPsP2Md/7HpYlp7jrY5Q5Y0ReKl8jYYy8
	W06lP+AK9qBVu0H1c1zpRBiQ4HHUJDNeCqmBZMO0m4tM1yWjYcRcLpgMMBqaMmkasgyUOW
	dgNU5LiIS/LKiZKHb5qd5J6nuxoVvIs=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-617-oBoWDR9oOgOadxZOZviT8g-1; Thu, 17 Nov 2022 03:51:33 -0500
X-MC-Unique: oBoWDR9oOgOadxZOZviT8g-1
Received: by mail-ed1-f71.google.com with SMTP id c9-20020a05640227c900b00463de74bc15so788978ede.13
        for <patches@lists.linux.dev>; Thu, 17 Nov 2022 00:51:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9Myyg+bLdQelD4D9kVUB3s2sr8LVncKivkUt152IISU=;
        b=Z0iBhy410CTbquGjlsjpPN+wQw4e/f+8BXbhRQSgFQPWlYRLkU6X0N7F7rV7eaNj04
         qbRwVoLOacJdfFGlIQmWS1k5inCzl47a9537IitwwJ+QvnzMg0HMokjA6r+8eA7+ZMRK
         MxysdIDjJ019QpcnbNI/JwpOm+ZoW/36nnSo42kG3igN2CVLBlS3F+hAZJ3X3P9GzE3R
         E57uExzFO0Tg4nW+Ld6W9NwDVVksOXcQO0S1dOXJMrSeY4AolEpv629+fysbg3C5wG0P
         BleXEDSTxOROWdoPXtzx2JIG0MUh33Q8qzMVIFipFJ9vHTJsJ5aoDSwySrsfxLq5Ecf/
         2R+w==
X-Gm-Message-State: ANoB5pn5EJLt4NSq4REXpdwYepHOMmApbMuWZBspsQs0TN3gE58iGhNN
	E9e/mm1x4MtmvlFkYo1wwA1u1umBmEaM1nbjAb74KoPd6EjEgLzhgZfsWtI/Fc1jyd4UA8K6yMp
	VYSadz8D2zbZ5RZlzHw==
X-Received: by 2002:aa7:d8ca:0:b0:463:4dd8:d6ea with SMTP id k10-20020aa7d8ca000000b004634dd8d6eamr1288370eds.426.1668675092078;
        Thu, 17 Nov 2022 00:51:32 -0800 (PST)
X-Google-Smtp-Source: AA0mqf4AbtghDuouRfYwOLZ7J+FiQixeQt31XlxfhiSlzeSAYIlyHGD8PPjDd5Mjma+532HHuV7GAw==
X-Received: by 2002:aa7:d8ca:0:b0:463:4dd8:d6ea with SMTP id k10-20020aa7d8ca000000b004634dd8d6eamr1288357eds.426.1668675091923;
        Thu, 17 Nov 2022 00:51:31 -0800 (PST)
Received: from ?IPV6:2001:1c00:c1e:bf00:d69d:5353:dba5:ee81? (2001-1c00-0c1e-bf00-d69d-5353-dba5-ee81.cable.dynamic.v6.ziggo.nl. [2001:1c00:c1e:bf00:d69d:5353:dba5:ee81])
        by smtp.gmail.com with ESMTPSA id u9-20020a1709061da900b007317f017e64sm73516ejh.134.2022.11.17.00.51.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Nov 2022 00:51:31 -0800 (PST)
Message-ID: <77e9d0f2-12d9-fc7a-2161-c579b7bbd673@redhat.com>
Date: Thu, 17 Nov 2022 09:51:30 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Re: [PATCH v3 04/16] platform/x86/intel/ifs: Remove memory allocation
 from load path
To: Jithu Joseph <jithu.joseph@intel.com>, markgross@kernel.org
Cc: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 gregkh@linuxfoundation.org, ashok.raj@intel.com, tony.luck@intel.com,
 linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org,
 patches@lists.linux.dev, ravi.v.shankar@intel.com,
 thiago.macieira@intel.com, athenas.jimenez.gonzalez@intel.com,
 sohil.mehta@intel.com
References: <20221107225323.2733518-1-jithu.joseph@intel.com>
 <20221117035935.4136738-1-jithu.joseph@intel.com>
 <20221117035935.4136738-5-jithu.joseph@intel.com>
From: Hans de Goede <hdegoede@redhat.com>
In-Reply-To: <20221117035935.4136738-5-jithu.joseph@intel.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US, nl
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi,

On 11/17/22 04:59, Jithu Joseph wrote:
> IFS requires tests to be authenticated once for each CPU socket
> on a system.
> 
> scan_chunks_sanity_check() was dynamically allocating memory
> to store the state of whether tests have been authenticated on
> each socket for every load operation.
> 
> Move the memory allocation to init path.
> 
> Reviewed-by: Tony Luck <tony.luck@intel.com>
> Suggested-by: Borislav Petkov <bp@alien8.de>
> Signed-off-by: Jithu Joseph <jithu.joseph@intel.com>
> ---
>  drivers/platform/x86/intel/ifs/ifs.h  |  2 ++
>  drivers/platform/x86/intel/ifs/core.c | 13 +++++++++++--
>  drivers/platform/x86/intel/ifs/load.c | 14 ++++----------
>  3 files changed, 17 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/platform/x86/intel/ifs/ifs.h b/drivers/platform/x86/intel/ifs/ifs.h
> index 3ff1d9aaeaa9..3a051890d9e7 100644
> --- a/drivers/platform/x86/intel/ifs/ifs.h
> +++ b/drivers/platform/x86/intel/ifs/ifs.h
> @@ -229,4 +229,6 @@ void ifs_load_firmware(struct device *dev);
>  int do_core_test(int cpu, struct device *dev);
>  const struct attribute_group **ifs_get_groups(void);
>  
> +extern bool *ifs_pkg_auth;
> +

This is not necessary and ugly, nack for this patch as-is (sorry).

You can simply add this pointer to "struct ifs_data" and then
alloc it in ifs_init() before the misc_register call.

scan_chunks_sanity_check() already has a "struct ifs_data *ifsd",
so it can easily access ifs_pkg_auth through that when you make
ifs_pkg_auth part of "struct ifs_data".

Regards,

Hans
\


>  #endif
> diff --git a/drivers/platform/x86/intel/ifs/core.c b/drivers/platform/x86/intel/ifs/core.c
> index 5fb7f655c291..4b39f2359180 100644
> --- a/drivers/platform/x86/intel/ifs/core.c
> +++ b/drivers/platform/x86/intel/ifs/core.c
> @@ -4,6 +4,7 @@
>  #include <linux/module.h>
>  #include <linux/kdev_t.h>
>  #include <linux/semaphore.h>
> +#include <linux/slab.h>
>  
>  #include <asm/cpu_device_id.h>
>  
> @@ -30,6 +31,8 @@ static struct ifs_device ifs_device = {
>  	},
>  };
>  
> +bool *ifs_pkg_auth;
> +
>  static int __init ifs_init(void)
>  {
>  	const struct x86_cpu_id *m;
> @@ -51,8 +54,13 @@ static int __init ifs_init(void)
>  	ifs_device.misc.groups = ifs_get_groups();
>  
>  	if ((msrval & BIT(ifs_device.data.integrity_cap_bit)) &&
> -	    !misc_register(&ifs_device.misc))
> -		return 0;
> +	    !misc_register(&ifs_device.misc)) {
> +		ifs_pkg_auth = kmalloc_array(topology_max_packages(), sizeof(bool), GFP_KERNEL);
> +		if (!ifs_pkg_auth)
> +			return -ENOMEM;
> +		else
> +			return 0;
> +	}
>  
>  	return -ENODEV;
>  }
> @@ -60,6 +68,7 @@ static int __init ifs_init(void)
>  static void __exit ifs_exit(void)
>  {
>  	misc_deregister(&ifs_device.misc);
> +	kfree(ifs_pkg_auth);
>  }
>  
>  module_init(ifs_init);
> diff --git a/drivers/platform/x86/intel/ifs/load.c b/drivers/platform/x86/intel/ifs/load.c
> index 89ce265887ea..c914e4d359db 100644
> --- a/drivers/platform/x86/intel/ifs/load.c
> +++ b/drivers/platform/x86/intel/ifs/load.c
> @@ -3,7 +3,6 @@
>  
>  #include <linux/firmware.h>
>  #include <asm/cpu.h>
> -#include <linux/slab.h>
>  #include <asm/microcode_intel.h>
>  
>  #include "ifs.h"
> @@ -118,16 +117,12 @@ static void copy_hashes_authenticate_chunks(struct work_struct *work)
>   */
>  static int scan_chunks_sanity_check(struct device *dev)
>  {
> -	int metadata_size, curr_pkg, cpu, ret = -ENOMEM;
> +	int metadata_size, curr_pkg, cpu, ret;
>  	struct ifs_data *ifsd = ifs_get_data(dev);
> -	bool *package_authenticated;
>  	struct ifs_work local_work;
>  	char *test_ptr;
>  
> -	package_authenticated = kcalloc(topology_max_packages(), sizeof(bool), GFP_KERNEL);
> -	if (!package_authenticated)
> -		return ret;
> -
> +	memset(ifs_pkg_auth, 0, (topology_max_packages() * sizeof(bool)));
>  	metadata_size = ifs_header_ptr->metadata_size;
>  
>  	/* Spec says that if the Meta Data Size = 0 then it should be treated as 2000 */
> @@ -150,7 +145,7 @@ static int scan_chunks_sanity_check(struct device *dev)
>  	cpus_read_lock();
>  	for_each_online_cpu(cpu) {
>  		curr_pkg = topology_physical_package_id(cpu);
> -		if (package_authenticated[curr_pkg])
> +		if (ifs_pkg_auth[curr_pkg])
>  			continue;
>  		reinit_completion(&ifs_done);
>  		local_work.dev = dev;
> @@ -161,12 +156,11 @@ static int scan_chunks_sanity_check(struct device *dev)
>  			ret = -EIO;
>  			goto out;
>  		}
> -		package_authenticated[curr_pkg] = 1;
> +		ifs_pkg_auth[curr_pkg] = 1;
>  	}
>  	ret = 0;
>  out:
>  	cpus_read_unlock();
> -	kfree(package_authenticated);
>  
>  	return ret;
>  }

