Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3EE61E9E4
	for <patches@lists.linux.dev>; Thu, 10 Nov 2022 21:22:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1668115373;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rx8igAdRVif5IuP2ahd0j6gNB1lqotXIjznDQLYpYw0=;
	b=N+p1JFREPN6USai97FXqTSUS3a2geMJYshWB4XJTe3YjkKiT1sm8OjIfBOHHeRuU4zKz9g
	T635hH16oXLrR/j0saYnsadKRMrR1gb/Desd/l0dquPjWQYiYYG3LNKJKtJ3gjmMTDUfPt
	2N2zHzuhWT6c0R7//faMHDqMg4Qenpo=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-489-LrrM890tP7iO-bYwOmQuig-1; Thu, 10 Nov 2022 16:22:52 -0500
X-MC-Unique: LrrM890tP7iO-bYwOmQuig-1
Received: by mail-ej1-f71.google.com with SMTP id jg27-20020a170907971b00b007ad9892f5f6so1904635ejc.7
        for <patches@lists.linux.dev>; Thu, 10 Nov 2022 13:22:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rx8igAdRVif5IuP2ahd0j6gNB1lqotXIjznDQLYpYw0=;
        b=0JX0Kr3znJYcwotV3IT4DlGC4SqEq46PZkZCWPWC68914jv55PRrdCDCBHUIYiMNjI
         B5v87oqJZIUK7e72i34Bv9V1CoXv+cdZuZcl/oq2gfIzJ2+YtUVPMaGWtLvylzuVf3rb
         E148QZqtEP7yf3K1/gIwU7HicHg6lGGoFxZkcN87R8fuHgLKZnugAXwgIMZui7HN3EJN
         4Rq48g3BnTB75wDjmlyj/rdg9dpRdRDHqsUFbhDxDFHOtnjbJ0fzoBrFagJOcXbcywxp
         CBav/S57h2uEbqE8u/uQG8xVy9AKt2voCo49IKfsx/dC94IQqucuc19+Q0HxwrZ3xuEJ
         DNVA==
X-Gm-Message-State: ACrzQf1UuVdlrg7rOw/ggkbk0Dp33qObtSVVKo4jwEBT5P5n5WeLS2ca
	0s8xEzLA8a1k3QrtMsGiLCc4MimDpLMWytstdg4QtgTTkdlJM8uSZVnGJDXcN/QbmM2aQqiYtOD
	BRbWCzUDa26EvWlkGyw==
X-Received: by 2002:a50:ec91:0:b0:461:9fe:6d8a with SMTP id e17-20020a50ec91000000b0046109fe6d8amr3375833edr.4.1668115371071;
        Thu, 10 Nov 2022 13:22:51 -0800 (PST)
X-Google-Smtp-Source: AMsMyM7Pv5JQHjwClEd4PCZVII9t8lcGx8BeXVJB3MsHUc5glx/OxxsVnbuBNf7Tc3cXgCv632eNQA==
X-Received: by 2002:a50:ec91:0:b0:461:9fe:6d8a with SMTP id e17-20020a50ec91000000b0046109fe6d8amr3375810edr.4.1668115370825;
        Thu, 10 Nov 2022 13:22:50 -0800 (PST)
Received: from ?IPV6:2001:1c00:c1e:bf00:d69d:5353:dba5:ee81? (2001-1c00-0c1e-bf00-d69d-5353-dba5-ee81.cable.dynamic.v6.ziggo.nl. [2001:1c00:c1e:bf00:d69d:5353:dba5:ee81])
        by smtp.gmail.com with ESMTPSA id ce11-20020a170906b24b00b007ad9c826d75sm152732ejb.61.2022.11.10.13.22.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Nov 2022 13:22:50 -0800 (PST)
Message-ID: <e6acf1f9-5441-d7b8-0eb4-3913f6f3392e@redhat.com>
Date: Thu, 10 Nov 2022 22:22:49 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [PATCH v2 12/14] platform/x86/intel/ifs: Add current_batch sysfs
 entry
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
 <20221107225323.2733518-13-jithu.joseph@intel.com>
From: Hans de Goede <hdegoede@redhat.com>
In-Reply-To: <20221107225323.2733518-13-jithu.joseph@intel.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US, nl
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi,

On 11/7/22 23:53, Jithu Joseph wrote:
> Initial implementation assumed a single IFS test image file with a
> fixed name ff-mm-ss.scan. (where ff, mm, ss refers to family, model
> and stepping  of the core)
> 
> Subsequently, it became evident that supporting more than one
> test image file is needed to provide more comprehensive
> test coverage. (Test coverage in this scenario refers to testing
> more transistors in the core to identify faults)
> 
> The other alternative of increasing the size of a single scan test image
> file would not work as the  upper bound is limited by the size of memory
> area reserved by BIOS for loading IFS test image.
> 
> Introduce "current_batch" file which accepts a number. Writing a
> number to the current_batch file would load the test image file by name
> ff-mm-ss-<xy>.scan, where <xy> is the number written to the
> "current_batch" file in hex. Range check of the input is done to verify
> it not greater than 0xff.
> 
> For e.g if the scan test image comprises of 6 files, they would be named
> as show below:
> 	06-8f-06-01.scan
> 	06-8f-06-02.scan
> 	06-8f-06-03.scan
> 	06-8f-06-04.scan
> 	06-8f-06-05.scan
> 	06-8f-06-06.scan
> 
> And writing 3 to current_batch would result in loading 06-8f-06-03.scan
> in the above e.g. The file can also be read to know the currently loaded
> file.
> 
> And testing a system looks like:
> 	for each scan file
> 	do
> 		load the IFS test image file (write to the batch file)
> 		for each core
> 		do
> 			test the core with this set of tests
> 		done
> 	done
> 
> Qualify few error messages with the test image file suffix to
> provide better context.
> 
> Reviewed-by: Tony Luck <tony.luck@intel.com>
> Signed-off-by: Jithu Joseph <jithu.joseph@intel.com>

Thanks, patch looks good to me:

Reviewed-by: Hans de Goede <hdegoede@redhat.com>

Regards,

Hans


> ---
>  drivers/platform/x86/intel/ifs/ifs.h     | 23 ++++++++++----
>  drivers/platform/x86/intel/ifs/core.c    |  1 +
>  drivers/platform/x86/intel/ifs/load.c    | 18 +++++++----
>  drivers/platform/x86/intel/ifs/runtest.c | 10 ++++---
>  drivers/platform/x86/intel/ifs/sysfs.c   | 38 ++++++++++++++++++++++++
>  5 files changed, 74 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/platform/x86/intel/ifs/ifs.h b/drivers/platform/x86/intel/ifs/ifs.h
> index 98ca91bdd5ca..390e508faf57 100644
> --- a/drivers/platform/x86/intel/ifs/ifs.h
> +++ b/drivers/platform/x86/intel/ifs/ifs.h
> @@ -33,13 +33,23 @@
>   * The driver loads the tests into memory reserved BIOS local to each CPU
>   * socket in a two step process using writes to MSRs to first load the
>   * SHA hashes for the test. Then the tests themselves. Status MSRs provide
> - * feedback on the success/failure of these steps. When a new test file
> - * is installed it can be loaded by writing to the driver reload file::
> + * feedback on the success/failure of these steps.
>   *
> - *   # echo 1 > /sys/devices/virtual/misc/intel_ifs_0/reload
> + * The test files are kept in a fixed location: /lib/firmware/intel/ifs_0/
> + * For e.g if there are 3 test files, they would be named in the following
> + * fashion:
> + * ff-mm-ss-01.scan
> + * ff-mm-ss-02.scan
> + * ff-mm-ss-03.scan
> + * (where ff refers to family, mm indicates model and ss indicates stepping)
>   *
> - * Similar to microcode, the current version of the scan tests is stored
> - * in a fixed location: /lib/firmware/intel/ifs.0/family-model-stepping.scan
> + * A different testfile can be loaded by writing the numerical portion
> + * (e.g 1, 2 or 3 in the above scenario) into the curent_batch file.
> + * To load ff-mm-ss-02.scan, the following command can be used::
> + *
> + *   # echo 2 > /sys/devices/virtual/misc/intel_ifs_0/current_batch
> + *
> + * The above file can also be read to know the currently loaded image.
>   *
>   * Running tests
>   * -------------
> @@ -207,6 +217,7 @@ struct ifs_data {
>  	int	status;
>  	u64	scan_details;
>  	int	cur_batch;
> +	int	test_num;
>  };
>  
>  struct ifs_work {
> @@ -227,7 +238,7 @@ static inline struct ifs_data *ifs_get_data(struct device *dev)
>  	return &d->data;
>  }
>  
> -void ifs_load_firmware(struct device *dev);
> +int ifs_load_firmware(struct device *dev);
>  int do_core_test(int cpu, struct device *dev);
>  const struct attribute_group **ifs_get_groups(void);
>  
> diff --git a/drivers/platform/x86/intel/ifs/core.c b/drivers/platform/x86/intel/ifs/core.c
> index 5fb7f655c291..1f040837e8eb 100644
> --- a/drivers/platform/x86/intel/ifs/core.c
> +++ b/drivers/platform/x86/intel/ifs/core.c
> @@ -22,6 +22,7 @@ MODULE_DEVICE_TABLE(x86cpu, ifs_cpu_ids);
>  static struct ifs_device ifs_device = {
>  	.data = {
>  		.integrity_cap_bit = MSR_INTEGRITY_CAPS_PERIODIC_BIST_BIT,
> +		.test_num = 0,
>  	},
>  	.misc = {
>  		.name = "intel_ifs_0",
> diff --git a/drivers/platform/x86/intel/ifs/load.c b/drivers/platform/x86/intel/ifs/load.c
> index f361fd42a320..c6414958a691 100644
> --- a/drivers/platform/x86/intel/ifs/load.c
> +++ b/drivers/platform/x86/intel/ifs/load.c
> @@ -256,17 +256,18 @@ static int ifs_image_sanity_check(struct device *dev, const struct microcode_hea
>  
>  /*
>   * Load ifs image. Before loading ifs module, the ifs image must be located
> - * in /lib/firmware/intel/ifs and named as {family/model/stepping}.{testname}.
> + * in /lib/firmware/intel/ifs_x/ and named as family-model-stepping-02x.{testname}.
>   */
> -void ifs_load_firmware(struct device *dev)
> +int ifs_load_firmware(struct device *dev)
>  {
>  	struct ifs_data *ifsd = ifs_get_data(dev);
>  	const struct firmware *fw;
> -	char scan_path[32];
> -	int ret;
> +	char scan_path[64];
> +	int ret = -EINVAL;
>  
> -	snprintf(scan_path, sizeof(scan_path), "intel/ifs/%02x-%02x-%02x.scan",
> -		 boot_cpu_data.x86, boot_cpu_data.x86_model, boot_cpu_data.x86_stepping);
> +	snprintf(scan_path, sizeof(scan_path), "intel/ifs_%d/%02x-%02x-%02x-%02x.scan",
> +		 ifsd->test_num, boot_cpu_data.x86, boot_cpu_data.x86_model,
> +		 boot_cpu_data.x86_stepping, ifsd->cur_batch);
>  
>  	ret = request_firmware_direct(&fw, scan_path, dev);
>  	if (ret) {
> @@ -282,8 +283,13 @@ void ifs_load_firmware(struct device *dev)
>  	ifs_hash_ptr = (u64)(ifs_header_ptr + 1);
>  
>  	ret = scan_chunks_sanity_check(dev);
> +	if (ret)
> +		dev_err(dev, "Load failure for batch: %02x\n", ifsd->cur_batch);
> +
>  release:
>  	release_firmware(fw);
>  done:
>  	ifsd->loaded = (ret == 0);
> +
> +	return ret;
>  }
> diff --git a/drivers/platform/x86/intel/ifs/runtest.c b/drivers/platform/x86/intel/ifs/runtest.c
> index b2ca2bb4501f..0bfd8fcdd7e8 100644
> --- a/drivers/platform/x86/intel/ifs/runtest.c
> +++ b/drivers/platform/x86/intel/ifs/runtest.c
> @@ -78,14 +78,16 @@ static void message_not_tested(struct device *dev, int cpu, union ifs_status sta
>  
>  static void message_fail(struct device *dev, int cpu, union ifs_status status)
>  {
> +	struct ifs_data *ifsd = ifs_get_data(dev);
> +
>  	/*
>  	 * control_error is set when the microcode runs into a problem
>  	 * loading the image from the reserved BIOS memory, or it has
>  	 * been corrupted. Reloading the image may fix this issue.
>  	 */
>  	if (status.control_error) {
> -		dev_err(dev, "CPU(s) %*pbl: could not execute from loaded scan image\n",
> -			cpumask_pr_args(cpu_smt_mask(cpu)));
> +		dev_err(dev, "CPU(s) %*pbl: could not execute from loaded scan image. Batch: %02x version: 0x%x\n",
> +			cpumask_pr_args(cpu_smt_mask(cpu)), ifsd->cur_batch, ifsd->loaded_version);
>  	}
>  
>  	/*
> @@ -96,8 +98,8 @@ static void message_fail(struct device *dev, int cpu, union ifs_status status)
>  	 * the core being tested.
>  	 */
>  	if (status.signature_error) {
> -		dev_err(dev, "CPU(s) %*pbl: test signature incorrect.\n",
> -			cpumask_pr_args(cpu_smt_mask(cpu)));
> +		dev_err(dev, "CPU(s) %*pbl: test signature incorrect. Batch: %02x version: 0x%x\n",
> +			cpumask_pr_args(cpu_smt_mask(cpu)), ifsd->cur_batch, ifsd->loaded_version);
>  	}
>  }
>  
> diff --git a/drivers/platform/x86/intel/ifs/sysfs.c b/drivers/platform/x86/intel/ifs/sysfs.c
> index e077910c5d28..d2eeeb04d760 100644
> --- a/drivers/platform/x86/intel/ifs/sysfs.c
> +++ b/drivers/platform/x86/intel/ifs/sysfs.c
> @@ -87,6 +87,43 @@ static ssize_t run_test_store(struct device *dev,
>  
>  static DEVICE_ATTR_WO(run_test);
>  
> +static ssize_t current_batch_store(struct device *dev,
> +				   struct device_attribute *attr,
> +				   const char *buf, size_t count)
> +{
> +	struct ifs_data *ifsd = ifs_get_data(dev);
> +	int cur_batch;
> +	int rc;
> +
> +	rc = kstrtouint(buf, 0, &cur_batch);
> +	if (rc < 0 || cur_batch > 0xff)
> +		return -EINVAL;
> +
> +	if (down_interruptible(&ifs_sem))
> +		return -EINTR;
> +
> +	ifsd->cur_batch = cur_batch;
> +
> +	rc = ifs_load_firmware(dev);
> +
> +	up(&ifs_sem);
> +
> +	return (rc == 0) ? count : rc;
> +}
> +
> +static ssize_t current_batch_show(struct device *dev,
> +				  struct device_attribute *attr, char *buf)
> +{
> +	struct ifs_data *ifsd = ifs_get_data(dev);
> +
> +	if (!ifsd->loaded)
> +		return sysfs_emit(buf, "none\n");
> +	else
> +		return sysfs_emit(buf, "0x%02x\n", ifsd->cur_batch);
> +}
> +
> +static DEVICE_ATTR_RW(current_batch);
> +
>  /*
>   * Display currently loaded IFS image version.
>   */
> @@ -108,6 +145,7 @@ static struct attribute *plat_ifs_attrs[] = {
>  	&dev_attr_details.attr,
>  	&dev_attr_status.attr,
>  	&dev_attr_run_test.attr,
> +	&dev_attr_current_batch.attr,
>  	&dev_attr_image_version.attr,
>  	NULL
>  };

