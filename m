Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA81F1E9EA
	for <patches@lists.linux.dev>; Thu, 10 Nov 2022 21:18:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1668115104;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wyanxJQo8O8tyLYuJxAe30a/zahGnsdNcEvhKOiSFyw=;
	b=GHj2IYVmQweUEQVMVPxQ/Xq9qvByR6v/ySQ8P7X4VikW4TeIvFK4YZm6s85Y6QKiBVJKv8
	qvlVjbQQdPwkJ8K+hpEfN1a58rsbVFaUkzjheWFpCmmz7BqhY+j4JB43Pyyn1aOLtEyfbX
	SCeLgD1UkEAeaAoRY4Rlr2Hdi9ZwH1k=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-8-uIBejSRcOsS3XjGbiEJgRQ-1; Thu, 10 Nov 2022 16:18:23 -0500
X-MC-Unique: uIBejSRcOsS3XjGbiEJgRQ-1
Received: by mail-ej1-f69.google.com with SMTP id xj11-20020a170906db0b00b0077b6ecb23fcso1908437ejb.5
        for <patches@lists.linux.dev>; Thu, 10 Nov 2022 13:18:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wyanxJQo8O8tyLYuJxAe30a/zahGnsdNcEvhKOiSFyw=;
        b=iAHDvQuIwsV5HPyXrSiQPY0EJeQfrrmegB2Pe4HJ+bTyz3dHUwFBnBixbf+i2t9zR2
         XsHJXGXdg2rQHUeKqGHcbI+dUuI+MHBoUceihwOQRkhhqztHWbFDPVbvbjsQHrkbEdfu
         TuPSbey1IpcRjFTT/Ob71jDk2HPqmF+ffYNcZJ2DCp7fq3ZPYrHdMdp9GI1OhRTPxN/+
         IfFEe3lOz2zQSaobZ2QgoJUrpcrYrUUROcNwSPKrLFGK05pSePzmeL2GejrdOcb+5Otu
         GXh9J6h96xAEym7QRh+JxBDbJ2/K4A9foDsD4/qVP7qCvix3zWh6nwp6J3am/cpI+QR8
         zZew==
X-Gm-Message-State: ACrzQf1qd6IxwLljmIT/eT/HmKyR2Hcspgqq27XjFh/kWh5XXJN/jFxx
	CPGXrPXKVx99VVKsfI5ToWPWozHxq859uN++XVnKXokWDcYkFB3gJ17cmO9PHgbnbIhx8Rry46j
	tZjiDQhaCq860Ex5F6A==
X-Received: by 2002:a17:906:456:b0:78d:a01b:b474 with SMTP id e22-20020a170906045600b0078da01bb474mr3933786eja.8.1668115102167;
        Thu, 10 Nov 2022 13:18:22 -0800 (PST)
X-Google-Smtp-Source: AMsMyM53PNvGGxh9kTmc1lDCcu/Wa92QTRpwzY7HGiOC2LyH6DTM8Gozdbedc89+dWdIY0l8HUk55Q==
X-Received: by 2002:a17:906:456:b0:78d:a01b:b474 with SMTP id e22-20020a170906045600b0078da01bb474mr3933782eja.8.1668115101961;
        Thu, 10 Nov 2022 13:18:21 -0800 (PST)
Received: from ?IPV6:2001:1c00:c1e:bf00:d69d:5353:dba5:ee81? (2001-1c00-0c1e-bf00-d69d-5353-dba5-ee81.cable.dynamic.v6.ziggo.nl. [2001:1c00:c1e:bf00:d69d:5353:dba5:ee81])
        by smtp.gmail.com with ESMTPSA id bc22-20020a056402205600b0045bccd8ab83sm322006edb.1.2022.11.10.13.18.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Nov 2022 13:18:21 -0800 (PST)
Message-ID: <ecf5632b-5fba-ad84-41be-a335b164809f@redhat.com>
Date: Thu, 10 Nov 2022 22:18:20 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [PATCH v2 10/14] platform/x86/intel/ifs: Add metadata validation
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
 <20221107225323.2733518-11-jithu.joseph@intel.com>
From: Hans de Goede <hdegoede@redhat.com>
In-Reply-To: <20221107225323.2733518-11-jithu.joseph@intel.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US, nl
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi,

On 11/7/22 23:53, Jithu Joseph wrote:
> The data portion of IFS test image file contains a metadata
> region containing possibly multiple metadata structures in
> addition to test data and hashes.
> 
> Introduce the layout of this meta_data structure and validate
> the sanity of certain fields of the new image before loading.
> 
> Tweak references to IFS test image chunks to reflect the updated
> layout of the test image.
> 
> Reviewed-by: Tony Luck <tony.luck@intel.com>
> Signed-off-by: Jithu Joseph <jithu.joseph@intel.com>

Thanks, patch looks good to me:

Reviewed-by: Hans de Goede <hdegoede@redhat.com>

Regards,

Hans



> ---
>  drivers/platform/x86/intel/ifs/ifs.h  |  2 +
>  drivers/platform/x86/intel/ifs/load.c | 53 +++++++++++++++++++++++++++
>  2 files changed, 55 insertions(+)
> 
> diff --git a/drivers/platform/x86/intel/ifs/ifs.h b/drivers/platform/x86/intel/ifs/ifs.h
> index 3ff1d9aaeaa9..98ca91bdd5ca 100644
> --- a/drivers/platform/x86/intel/ifs/ifs.h
> +++ b/drivers/platform/x86/intel/ifs/ifs.h
> @@ -196,6 +196,7 @@ union ifs_status {
>   * @valid_chunks: number of chunks which could be validated.
>   * @status: it holds simple status pass/fail/untested
>   * @scan_details: opaque scan status code from h/w
> + * @cur_batch: number indicating the currently loaded test file
>   */
>  struct ifs_data {
>  	int	integrity_cap_bit;
> @@ -205,6 +206,7 @@ struct ifs_data {
>  	int	valid_chunks;
>  	int	status;
>  	u64	scan_details;
> +	int	cur_batch;
>  };
>  
>  struct ifs_work {
> diff --git a/drivers/platform/x86/intel/ifs/load.c b/drivers/platform/x86/intel/ifs/load.c
> index 7c0d8602817b..f361fd42a320 100644
> --- a/drivers/platform/x86/intel/ifs/load.c
> +++ b/drivers/platform/x86/intel/ifs/load.c
> @@ -8,7 +8,23 @@
>  
>  #include "ifs.h"
>  
> +struct meta_data {
> +	unsigned int meta_type;		// metadata type
> +	unsigned int meta_size;		// size of this entire struct including hdrs.
> +	unsigned int test_type;		// IFS test type
> +	unsigned int fusa_info;		// Fusa info
> +	unsigned int total_images;	// Total number of images
> +	unsigned int current_image;	// Current Image #
> +	unsigned int total_chunks;	// Total number of chunks in this image
> +	unsigned int starting_chunk;	// Starting chunk number in this image
> +	unsigned int size_per_chunk;	// size of each chunk
> +	unsigned int chunks_per_stride;	// number of chunks in a stride
> +	unsigned int reserved[54];	// Align to 256 bytes for chunk alignment.
> +};
> +
>  #define IFS_HEADER_SIZE	(sizeof(struct microcode_header_intel))
> +#define META_TYPE_IFS	1
> +#define IFS_CHUNK_ALIGNMENT	256
>  static  struct microcode_header_intel *ifs_header_ptr;	/* pointer to the ifs image header */
>  static u64 ifs_hash_ptr;			/* Address of ifs metadata (hash) */
>  static u64 ifs_test_image_ptr;			/* 256B aligned address of test pattern */
> @@ -129,6 +145,40 @@ static void copy_hashes_authenticate_chunks(struct work_struct *work)
>  	complete(&ifs_done);
>  }
>  
> +static int validate_ifs_metadata(struct device *dev)
> +{
> +	struct ifs_data *ifsd = ifs_get_data(dev);
> +	struct meta_data *ifs_meta;
> +	char test_file[64];
> +	int ret = -EINVAL;
> +
> +	snprintf(test_file, sizeof(test_file), "%02x-%02x-%02x-%02x.scan",
> +		 boot_cpu_data.x86, boot_cpu_data.x86_model,
> +		 boot_cpu_data.x86_stepping, ifsd->cur_batch);
> +
> +	ifs_meta = (struct meta_data *)ifs_find_meta_data(ifs_header_ptr, META_TYPE_IFS);
> +	if (!ifs_meta) {
> +		dev_err(dev, "IFS Metadata missing in file %s\n", test_file);
> +		return ret;
> +	}
> +
> +	ifs_test_image_ptr = (u64)ifs_meta + sizeof(struct meta_data);
> +
> +	/* Scan chunk start must be 256 byte aligned */
> +	if (!IS_ALIGNED(ifs_test_image_ptr, IFS_CHUNK_ALIGNMENT)) {
> +		dev_err(dev, "Scan pattern offset is not 256 byte aligned in %s\n", test_file);
> +		return ret;
> +	}
> +
> +	if (ifs_meta->current_image != ifsd->cur_batch) {
> +		dev_warn(dev, "Mismatch between filename %s and batch metadata 0x%02x\n",
> +			 test_file, ifs_meta->current_image);
> +		return ret;
> +	}
> +
> +	return 0;
> +}
> +
>  /*
>   * IFS requires scan chunks authenticated per each socket in the platform.
>   * Once the test chunk is authenticated, it is automatically copied to secured memory
> @@ -145,6 +195,9 @@ static int scan_chunks_sanity_check(struct device *dev)
>  	if (!package_authenticated)
>  		return ret;
>  
> +	ret = validate_ifs_metadata(dev);
> +	if (ret)
> +		return ret;
>  
>  	ifsd->loading_error = false;
>  	ifsd->loaded_version = ifs_header_ptr->rev;

