Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18A5428F2
	for <patches@lists.linux.dev>; Mon, 13 Mar 2023 16:10:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1678723830;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Od6/H639PYAwrqiiKkC/+gT3zZNHjYxP+NHFrRa3plo=;
	b=AymGYGu2rzH5OnLnkwJBuLBMxD21cIoYqIUllufPLgTTPE034z0YomV4q2wxiHqCyG9a+l
	txYqN5Cv0JThhYHNSpoBLCjje2nLzSnpFc0WcOM35LVczNB1KPmHAaMHHP3Ym2bB0DQuj6
	5tEIB4tHIbBZi7FaiEhAnTKtew1/RBU=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-493--KLP2LHKPrGoMnKUG4CwBg-1; Mon, 13 Mar 2023 12:10:28 -0400
X-MC-Unique: -KLP2LHKPrGoMnKUG4CwBg-1
Received: by mail-ed1-f72.google.com with SMTP id m8-20020a056402430800b004cdaaa4f428so17759137edc.20
        for <patches@lists.linux.dev>; Mon, 13 Mar 2023 09:10:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678723827;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Od6/H639PYAwrqiiKkC/+gT3zZNHjYxP+NHFrRa3plo=;
        b=p02zzOWphIsxAAqu2VtODY+YxnxOY9FnMlcIXv9lgcuV1xO5RQMdBW+LCZXO4pYpAA
         NJ/R8iNkfZx7x7P2Vf116Jo0JmGgeP8sbEvbr3w3X/xaNs8XIOyBP3LPODPhoq4G8+Cs
         PR9Ez6n99lZFpydNLCqJGL6NM2HGOUOaQ2NmfjLA7yR+BMbALVP0y1jTL+WRrQoyfFtx
         1lJOeK/1EaHcvd95GULrm/6XL4IrokDngJnYGrbZt51SkEs0eBuLG/dHEx3GubKE9qvF
         SniYQJ3I+cbNkIX4cSO4rYog1CH/T2dW91rZR00QFpKyVHNteipoe0FDUhgnJOqmHWvU
         x89w==
X-Gm-Message-State: AO0yUKVMlB9BTbjWrolV1zFBrBNv2dVJRurWEypFSZq/E20Ipq1X/xPI
	Qu8lCNImJLox5uWIiQMjjr48VkyZVdHFyNw5Kzxe/DtS6qUKSnV060MexEbzu93J5Zn8qYGvkPy
	mVxIUYX2PtbofM5onUA==
X-Received: by 2002:a17:907:6eab:b0:86f:64bb:47eb with SMTP id sh43-20020a1709076eab00b0086f64bb47ebmr40242825ejc.3.1678723827652;
        Mon, 13 Mar 2023 09:10:27 -0700 (PDT)
X-Google-Smtp-Source: AK7set824KFDb82qxno6QuOMylDaFSeEjfD0D+kLd+4F9tgRNO68SWM0PRGf6gRU/Kr7BuF4WseHJg==
X-Received: by 2002:a17:907:6eab:b0:86f:64bb:47eb with SMTP id sh43-20020a1709076eab00b0086f64bb47ebmr40242785ejc.3.1678723827310;
        Mon, 13 Mar 2023 09:10:27 -0700 (PDT)
Received: from [10.40.98.142] ([78.108.130.194])
        by smtp.gmail.com with ESMTPSA id ox29-20020a170907101d00b008e53874f8d8sm3560405ejb.180.2023.03.13.09.10.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Mar 2023 09:10:26 -0700 (PDT)
Message-ID: <7f82f241-39ee-15e0-1ae7-e98e50730c95@redhat.com>
Date: Mon, 13 Mar 2023 17:10:25 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH v3 4/8] platform/x86/intel/ifs: Introduce Array Scan test
 to IFS
To: Jithu Joseph <jithu.joseph@intel.com>, markgross@kernel.org
Cc: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 gregkh@linuxfoundation.org, rostedt@goodmis.org, ashok.raj@intel.com,
 tony.luck@intel.com, linux-kernel@vger.kernel.org,
 platform-driver-x86@vger.kernel.org, patches@lists.linux.dev,
 ravi.v.shankar@intel.com, thiago.macieira@intel.com,
 athenas.jimenez.gonzalez@intel.com, sohil.mehta@intel.com
References: <20230214234426.344960-1-jithu.joseph@intel.com>
 <20230301015942.462799-1-jithu.joseph@intel.com>
 <20230301015942.462799-5-jithu.joseph@intel.com>
From: Hans de Goede <hdegoede@redhat.com>
In-Reply-To: <20230301015942.462799-5-jithu.joseph@intel.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi,

On 3/1/23 02:59, Jithu Joseph wrote:
> Array BIST is a new type of core test introduced under the Intel Infield
> Scan (IFS) suite of tests.
> 
> Emerald Rapids (EMR) is the first CPU to support Array BIST.
> Array BIST performs tests on some portions of the core logic such as
> caches and register files. These are different portions of the silicon
> compared to the parts tested by the first test type
> i.e Scan at Field (SAF).
> 
> Make changes in the device driver init flow to register this new test
> type with the device driver framework. Each test will have its own
> sysfs directory (intel_ifs_0 , intel_ifs_1) under misc hierarchy to
> accommodate for the differences in test type and how they are initiated.
> 
> Upcoming patches will add actual support.
> 
> Signed-off-by: Jithu Joseph <jithu.joseph@intel.com>
> Reviewed-by: Tony Luck <tony.luck@intel.com>
> ---
>  drivers/platform/x86/intel/ifs/ifs.h  |  3 +
>  drivers/platform/x86/intel/ifs/core.c | 85 +++++++++++++++++++--------
>  2 files changed, 62 insertions(+), 26 deletions(-)
> 
> diff --git a/drivers/platform/x86/intel/ifs/ifs.h b/drivers/platform/x86/intel/ifs/ifs.h
> index ab168ddf28f1..b8b956e29653 100644
> --- a/drivers/platform/x86/intel/ifs/ifs.h
> +++ b/drivers/platform/x86/intel/ifs/ifs.h
> @@ -137,6 +137,9 @@
>  #define SCAN_TEST_PASS				1
>  #define SCAN_TEST_FAIL				2
>  
> +#define IFS_TYPE_SAF			0
> +#define IFS_TYPE_ARRAY_BIST		1
> +
>  /* MSR_SCAN_HASHES_STATUS bit fields */
>  union ifs_scan_hashes_status {
>  	u64	data;
> diff --git a/drivers/platform/x86/intel/ifs/core.c b/drivers/platform/x86/intel/ifs/core.c
> index 62c44dbae757..2237aaba7078 100644
> --- a/drivers/platform/x86/intel/ifs/core.c
> +++ b/drivers/platform/x86/intel/ifs/core.c
> @@ -16,6 +16,7 @@
>  
>  static const struct x86_cpu_id ifs_cpu_ids[] __initconst = {
>  	X86_MATCH(SAPPHIRERAPIDS_X),
> +	X86_MATCH(EMERALDRAPIDS_X),
>  	{}
>  };
>  MODULE_DEVICE_TABLE(x86cpu, ifs_cpu_ids);

Note you can add driver_data to a match table like this. What you should
do here is use the driver data to point to the const ifs_hw_caps discussed
before, so what you get here is:

#define X86_MATCH(model, data)                          \
        X86_MATCH_VENDOR_FAM_MODEL_FEATURE(INTEL, 6,    \
                INTEL_FAM6_##model, X86_FEATURE_CORE_CAPABILITIES, (unsigned long)(data))

static const struct ifs_hw_caps saphire_rapids_caps = {
	.integrity_cap_bit = MSR_INTEGRITY_CAPS_PERIODIC_BIST_BIT,
	.test_num = 0,
};

static const struct ifs_hw_caps emerald_rapids_caps = {
	.integrity_cap_bit = MSR_INTEGRITY_CAPS_PERIODIC_BIST_BIT,
	.test_num = 0,
};

static const struct x86_cpu_id ifs_cpu_ids[] __initconst = {
	X86_MATCH(SAPPHIRERAPIDS_X, &saphire_rapids_caps),
	X86_MATCH(EMERALDRAPIDS_X, &emerald_rapids_caps),
	{}
};
MODULE_DEVICE_TABLE(x86cpu, ifs_cpu_ids);

and then drop all the code related to having an array of ifs_device structs
(of which only 1 will ever get used) and instead at the beginning of
ifs_init(void), after:

        m = x86_match_cpu(ifs_cpu_ids);
        if (!m)
                return -ENODEV;

add:

	ifs_device.hwcaps = (const struct ifs_hw_caps *)m->driver_data;

And then you can pretty much drop all the rest of this patch and we
end up with much nicer code for differentiating between the models :)

Regards,

Hans






> @@ -24,23 +25,51 @@ ATTRIBUTE_GROUPS(plat_ifs);
>  
>  bool *ifs_pkg_auth;
>  
> -static struct ifs_device ifs_device = {
> -	.ro_data = {
> -		.integrity_cap_bit = MSR_INTEGRITY_CAPS_PERIODIC_BIST_BIT,
> -		.test_num = 0,
> +static struct ifs_device ifs_devices[] = {
> +	[IFS_TYPE_SAF] = {
> +		.ro_data = {
> +			.integrity_cap_bit = MSR_INTEGRITY_CAPS_PERIODIC_BIST_BIT,
> +			.test_num = IFS_TYPE_SAF,
> +		},
> +		.misc = {
> +			.name = "intel_ifs_0",
> +			.minor = MISC_DYNAMIC_MINOR,
> +			.groups = plat_ifs_groups,
> +		},
>  	},
> -	.misc = {
> -		.name = "intel_ifs_0",
> -		.minor = MISC_DYNAMIC_MINOR,
> -		.groups = plat_ifs_groups,
> +	[IFS_TYPE_ARRAY_BIST] = {
> +		.ro_data = {
> +			.integrity_cap_bit = MSR_INTEGRITY_CAPS_ARRAY_BIST_BIT,
> +			.test_num = IFS_TYPE_ARRAY_BIST,
> +		},
> +		.misc = {
> +			.name = "intel_ifs_1",
> +			.minor = MISC_DYNAMIC_MINOR,
> +		},
>  	},
>  };
>  
> +#define IFS_NUMTESTS ARRAY_SIZE(ifs_devices)
> +
> +static void ifs_cleanup(void)
> +{
> +	int i;
> +
> +	for (i = 0; i < IFS_NUMTESTS; i++) {
> +		if (ifs_devices[i].misc.this_device) {
> +			misc_deregister(&ifs_devices[i].misc);
> +			kfree(ifs_devices[i].rw_data);
> +		}
> +	}
> +	kfree(ifs_pkg_auth);
> +}
> +
>  static int __init ifs_init(void)
>  {
>  	const struct x86_cpu_id *m;
>  	struct ifs_data *ifsd;
>  	u64 msrval;
> +	int i, ret;
>  
>  	m = x86_match_cpu(ifs_cpu_ids);
>  	if (!m)
> @@ -55,35 +84,39 @@ static int __init ifs_init(void)
>  	if (rdmsrl_safe(MSR_INTEGRITY_CAPS, &msrval))
>  		return -ENODEV;
>  
> -	if (!(msrval & BIT(ifs_device.ro_data.integrity_cap_bit)))
> -		return -ENODEV;
> -
>  	ifs_pkg_auth = kmalloc_array(topology_max_packages(), sizeof(bool), GFP_KERNEL);
>  	if (!ifs_pkg_auth)
>  		return -ENOMEM;
>  
> -	ifsd = kzalloc(sizeof(*ifsd), GFP_KERNEL);
> -	if (!ifsd)
> -		return -ENOMEM;
> -
> -	ifsd->ro_info = &ifs_device.ro_data;
> -	ifs_device.rw_data = ifsd;
> -
> -	if (misc_register(&ifs_device.misc)) {
> -		kfree(ifsd);
> -		kfree(ifs_pkg_auth);
> -		return -ENODEV;
> +	for (i = 0; i < IFS_NUMTESTS; i++) {
> +		ifsd = NULL;
> +		if (!(msrval & BIT(ifs_devices[i].ro_data.integrity_cap_bit)))
> +			continue;
> +
> +		ifsd = kzalloc(sizeof(*ifsd), GFP_KERNEL);
> +		if (!ifsd) {
> +			ret = -ENOMEM;
> +			goto err_exit;
> +		}
> +		ifsd->ro_info = &ifs_devices[i].ro_data;
> +		ifs_devices[i].rw_data = ifsd;
> +
> +		if (misc_register(&ifs_devices[i].misc)) {
> +			ret = -ENODEV;
> +			kfree(ifsd);
> +			goto err_exit;
> +		}
>  	}
> -
>  	return 0;
>  
> +err_exit:
> +	ifs_cleanup();
> +	return ret;
>  }
>  
>  static void __exit ifs_exit(void)
>  {
> -	misc_deregister(&ifs_device.misc);
> -	kfree(ifs_device.rw_data);
> -	kfree(ifs_pkg_auth);
> +	ifs_cleanup();
>  }
>  
>  module_init(ifs_init);

