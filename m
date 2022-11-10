Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A6D71E9E4
	for <patches@lists.linux.dev>; Thu, 10 Nov 2022 21:12:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1668114723;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RUMhYbSQ+8dDnIi2j1iKdswSKUL7FeWIyVtWi8nfYBo=;
	b=Q1V0VfHibqrQtMLeCzFdCqxtMvTzHRHiPCHPtMNG4klWb3fb38sB3DIXpedfZsr8JAd1PF
	dkF6HbDncJmowYKml/QKn5Mxr++yGqQe8R89lRKjg6CUlq3JJRikWCWHeHQcnR/OFJumrF
	PD6Spb0IFOAzgyUWWSplxmxsgk7cVnI=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-427-Ar1CF0CTP9eDTAZDqBKO1Q-1; Thu, 10 Nov 2022 16:11:59 -0500
X-MC-Unique: Ar1CF0CTP9eDTAZDqBKO1Q-1
Received: by mail-ed1-f72.google.com with SMTP id c9-20020a05640227c900b00463de74bc15so2304982ede.13
        for <patches@lists.linux.dev>; Thu, 10 Nov 2022 13:11:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RUMhYbSQ+8dDnIi2j1iKdswSKUL7FeWIyVtWi8nfYBo=;
        b=Y0kyVeQpSM1bFJ9G4652XZsUjS1VTbz6V/ovaxF88dUjXo84Udfno1VlqliVxFPwMb
         3XpNw00cDkIu8PcLaFx8BpIla6FPVIIFyBmfCqSV+aS6uiT19qjO4RMp7MJiHwYvf+JA
         SKL0PEgDCic9y/YYCcuEEKshrV3k0nH5JYJBa2zgXGgJ4m0XPrgm4GqVMTF7srgI6A+g
         NBe2QPhrTt1AxzF/DekgNAnxpo3J/Ta+BZ3jTtZ3hcolfaWATWgya83cvKjHFet84E21
         TPi00bU+8LGXn3Jg/3ca9d5OjUbANtE42KAoyB/vskkMu7L6uDnfpViEQMOEDYvSjKFe
         /Cow==
X-Gm-Message-State: ACrzQf0oxyPBKeWl+H/+/cuNk1n4theOc5cU3INcSx0G57eJn6Fus14u
	gwUcdwr4OJ786/FUO/CUJmOH/N3SmusfUegUx3Ix44KR3852EdL7831naDdYoDN641VcvYB5VXY
	HBzVcLQWH3O0+HQkO8Q==
X-Received: by 2002:a17:907:d504:b0:799:a731:b44d with SMTP id wb4-20020a170907d50400b00799a731b44dmr3911803ejc.405.1668114718387;
        Thu, 10 Nov 2022 13:11:58 -0800 (PST)
X-Google-Smtp-Source: AMsMyM7ravEXyibu99rS9qCBwIUTfCmHL2NXRJDw4Ifz40jcvtAJfVk1kvfuuONZzk0D3T3P5yR4Hg==
X-Received: by 2002:a17:907:d504:b0:799:a731:b44d with SMTP id wb4-20020a170907d50400b00799a731b44dmr3911786ejc.405.1668114718074;
        Thu, 10 Nov 2022 13:11:58 -0800 (PST)
Received: from ?IPV6:2001:1c00:c1e:bf00:d69d:5353:dba5:ee81? (2001-1c00-0c1e-bf00-d69d-5353-dba5-ee81.cable.dynamic.v6.ziggo.nl. [2001:1c00:c1e:bf00:d69d:5353:dba5:ee81])
        by smtp.gmail.com with ESMTPSA id q1-20020a1709066b0100b0073d83f80b05sm140273ejr.94.2022.11.10.13.11.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Nov 2022 13:11:57 -0800 (PST)
Message-ID: <53080422-a1de-0e44-7725-5cb69d1e23cc@redhat.com>
Date: Thu, 10 Nov 2022 22:11:56 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [PATCH v2 09/14] platform/x86/intel/ifs: Use generic microcode
 headers and functions
To: Jithu Joseph <jithu.joseph@intel.com>, markgross@kernel.org
Cc: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 gregkh@linuxfoundation.org, ashok.raj@intel.com, tony.luck@intel.com,
 linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org,
 patches@lists.linux.dev, ravi.v.shankar@intel.com,
 thiago.macieira@intel.com, athenas.jimenez.gonzalez@intel.com,
 sohil.mehta@intel.com
References: <20221021203413.1220137-1-jithu.joseph@intel.com>
 <20221107225323.2733518-1-jithu.joseph@intel.com>
 <20221107225323.2733518-10-jithu.joseph@intel.com>
From: Hans de Goede <hdegoede@redhat.com>
In-Reply-To: <20221107225323.2733518-10-jithu.joseph@intel.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US, nl
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi all,

On 11/7/22 23:53, Jithu Joseph wrote:
> Existing implementation (broken) of IFS used a header format (for IFS
> test images) which was very similar to microcode format, but didn’t
> accommodate extended signatures. This meant same IFS test image had to
> be duplicated for different steppings and the validation code in the
> driver was only looking at the primary header parameters. Going forward
> IFS test image headers has been tweaked to become fully compatible with
> microcode format.
> 
> Newer IFS test image headers will use  microcode_header_intel->hdrver = 2,
> so as to distinguish it from microcode images and older IFS test images.
> 
> In light of the above, use struct microcode_header_intel directly in
> IFS driver instead of duplicating into a separate ifs_header structure.
> Further use existing microcode_sanity_check() and find_matching_signature()
> directly instead of implementing separate ones within the driver.
> 
> More IFS specific checks will be added subsequently.
> 
> Reviewed-by: Tony Luck <tony.luck@intel.com>
> Signed-off-by: Jithu Joseph <jithu.joseph@intel.com>

Thanks, patch looks good to me:

Reviewed-by: Hans de Goede <hdegoede@redhat.com>

Regards,

Hans




> ---
>  arch/x86/include/asm/microcode_intel.h |   1 +
>  drivers/platform/x86/intel/ifs/load.c  | 102 +++++--------------------
>  2 files changed, 20 insertions(+), 83 deletions(-)
> 
> diff --git a/arch/x86/include/asm/microcode_intel.h b/arch/x86/include/asm/microcode_intel.h
> index 0ff4545f72d2..f905238748fc 100644
> --- a/arch/x86/include/asm/microcode_intel.h
> +++ b/arch/x86/include/asm/microcode_intel.h
> @@ -43,6 +43,7 @@ struct extended_sigtable {
>  #define EXT_HEADER_SIZE		(sizeof(struct extended_sigtable))
>  #define EXT_SIGNATURE_SIZE	(sizeof(struct extended_signature))
>  #define MICROCODE_HEADER_VER_UCODE	1
> +#define MICROCODE_HEADER_VER_IFS	2
>  
>  #define get_totalsize(mc) \
>  	(((struct microcode_intel *)mc)->hdr.datasize ? \
> diff --git a/drivers/platform/x86/intel/ifs/load.c b/drivers/platform/x86/intel/ifs/load.c
> index 60ba5a057f91..7c0d8602817b 100644
> --- a/drivers/platform/x86/intel/ifs/load.c
> +++ b/drivers/platform/x86/intel/ifs/load.c
> @@ -8,22 +8,8 @@
>  
>  #include "ifs.h"
>  
> -struct ifs_header {
> -	u32 header_ver;
> -	u32 blob_revision;
> -	u32 date;
> -	u32 processor_sig;
> -	u32 check_sum;
> -	u32 loader_rev;
> -	u32 processor_flags;
> -	u32 metadata_size;
> -	u32 total_size;
> -	u32 fusa_info;
> -	u64 reserved;
> -};
> -
> -#define IFS_HEADER_SIZE	(sizeof(struct ifs_header))
> -static struct ifs_header *ifs_header_ptr;	/* pointer to the ifs image header */
> +#define IFS_HEADER_SIZE	(sizeof(struct microcode_header_intel))
> +static  struct microcode_header_intel *ifs_header_ptr;	/* pointer to the ifs image header */
>  static u64 ifs_hash_ptr;			/* Address of ifs metadata (hash) */
>  static u64 ifs_test_image_ptr;			/* 256B aligned address of test pattern */
>  static DECLARE_COMPLETION(ifs_done);
> @@ -150,33 +136,18 @@ static void copy_hashes_authenticate_chunks(struct work_struct *work)
>   */
>  static int scan_chunks_sanity_check(struct device *dev)
>  {
> -	int metadata_size, curr_pkg, cpu, ret = -ENOMEM;
>  	struct ifs_data *ifsd = ifs_get_data(dev);
> +	int curr_pkg, cpu, ret = -ENOMEM;
>  	bool *package_authenticated;
>  	struct ifs_work local_work;
> -	char *test_ptr;
>  
>  	package_authenticated = kcalloc(topology_max_packages(), sizeof(bool), GFP_KERNEL);
>  	if (!package_authenticated)
>  		return ret;
>  
> -	metadata_size = ifs_header_ptr->metadata_size;
>  
> -	/* Spec says that if the Meta Data Size = 0 then it should be treated as 2000 */
> -	if (metadata_size == 0)
> -		metadata_size = 2000;
> -
> -	/* Scan chunk start must be 256 byte aligned */
> -	if ((metadata_size + IFS_HEADER_SIZE) % 256) {
> -		dev_err(dev, "Scan pattern offset within the binary is not 256 byte aligned\n");
> -		return -EINVAL;
> -	}
> -
> -	test_ptr = (char *)ifs_header_ptr + IFS_HEADER_SIZE + metadata_size;
>  	ifsd->loading_error = false;
> -
> -	ifs_test_image_ptr = (u64)test_ptr;
> -	ifsd->loaded_version = ifs_header_ptr->blob_revision;
> +	ifsd->loaded_version = ifs_header_ptr->rev;
>  
>  	/* copy the scan hash and authenticate per package */
>  	cpus_read_lock();
> @@ -203,67 +174,33 @@ static int scan_chunks_sanity_check(struct device *dev)
>  	return ret;
>  }
>  
> -static int ifs_sanity_check(struct device *dev,
> -			    const struct microcode_header_intel *mc_header)
> +static int ifs_image_sanity_check(struct device *dev, const struct microcode_header_intel *data)
>  {
> -	unsigned long total_size, data_size;
> -	u32 sum, *mc;
> -
> -	total_size = get_totalsize(mc_header);
> -	data_size = get_datasize(mc_header);
> +	struct ucode_cpu_info uci;
>  
> -	if ((data_size + MC_HEADER_SIZE > total_size) || (total_size % sizeof(u32))) {
> -		dev_err(dev, "bad ifs data file size.\n");
> +	/* Provide a specific error message when loading an older/unsupported image */
> +	if (data->hdrver != MICROCODE_HEADER_VER_IFS) {
> +		dev_err(dev, "Header version %d not supported\n", data->hdrver);
>  		return -EINVAL;
>  	}
>  
> -	if (mc_header->ldrver != 1 || mc_header->hdrver != 1) {
> -		dev_err(dev, "invalid/unknown ifs update format.\n");
> +	if (intel_microcode_sanity_check((void *)data, true, MICROCODE_HEADER_VER_IFS)) {
> +		dev_err(dev, "sanity check failed\n");
>  		return -EINVAL;
>  	}
>  
> -	mc = (u32 *)mc_header;
> -	sum = 0;
> -	for (int i = 0; i < total_size / sizeof(u32); i++)
> -		sum += mc[i];
> +	intel_cpu_collect_info(&uci);
>  
> -	if (sum) {
> -		dev_err(dev, "bad ifs data checksum, aborting.\n");
> +	if (!intel_find_matching_signature((void *)data,
> +					   uci.cpu_sig.sig,
> +					   uci.cpu_sig.pf)) {
> +		dev_err(dev, "cpu signature, processor flags not matching\n");
>  		return -EINVAL;
>  	}
>  
>  	return 0;
>  }
>  
> -static bool find_ifs_matching_signature(struct device *dev, struct ucode_cpu_info *uci,
> -					const struct microcode_header_intel *shdr)
> -{
> -	unsigned int mc_size;
> -
> -	mc_size = get_totalsize(shdr);
> -
> -	if (!mc_size || ifs_sanity_check(dev, shdr) < 0) {
> -		dev_err(dev, "ifs sanity check failure\n");
> -		return false;
> -	}
> -
> -	if (!intel_cpu_signatures_match(uci->cpu_sig.sig, uci->cpu_sig.pf, shdr->sig, shdr->pf)) {
> -		dev_err(dev, "ifs signature, pf not matching\n");
> -		return false;
> -	}
> -
> -	return true;
> -}
> -
> -static bool ifs_image_sanity_check(struct device *dev, const struct microcode_header_intel *data)
> -{
> -	struct ucode_cpu_info uci;
> -
> -	intel_cpu_collect_info(&uci);
> -
> -	return find_ifs_matching_signature(dev, &uci, data);
> -}
> -
>  /*
>   * Load ifs image. Before loading ifs module, the ifs image must be located
>   * in /lib/firmware/intel/ifs and named as {family/model/stepping}.{testname}.
> @@ -284,12 +221,11 @@ void ifs_load_firmware(struct device *dev)
>  		goto done;
>  	}
>  
> -	if (!ifs_image_sanity_check(dev, (struct microcode_header_intel *)fw->data)) {
> -		dev_err(dev, "ifs header sanity check failed\n");
> +	ret = ifs_image_sanity_check(dev, (struct microcode_header_intel *)fw->data);
> +	if (ret)
>  		goto release;
> -	}
>  
> -	ifs_header_ptr = (struct ifs_header *)fw->data;
> +	ifs_header_ptr = (struct microcode_header_intel *)fw->data;
>  	ifs_hash_ptr = (u64)(ifs_header_ptr + 1);
>  
>  	ret = scan_chunks_sanity_check(dev);

