Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAEDD405CA
	for <patches@lists.linux.dev>; Mon,  8 Jan 2024 14:52:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SivhPnbB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1704725572;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=794xssVY3UWprU6xtQn72foNfENfQl/zR70PtdxL1SY=;
	b=SivhPnbBcQMbVXG9ZhCOLBMRjkXLUkDZRFjDpK/GkKGs4z41ateqfeMjKRqpR3ceiEEeTQ
	zXSQZUVb4NcGx2M6RzZWBiBpIIe5z36tKk0BrNzHwHaTFLO7Mm1FOuVtCgakCB/PXmnXLv
	R09H4ZDeEfyiCSCnNetubmuZUYfm7mk=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-164-GMCorT9SMvyORSEKlPRvgg-1; Mon, 08 Jan 2024 09:52:50 -0500
X-MC-Unique: GMCorT9SMvyORSEKlPRvgg-1
Received: by mail-lf1-f72.google.com with SMTP id 2adb3069b0e04-50e7b20360bso1438933e87.3
        for <patches@lists.linux.dev>; Mon, 08 Jan 2024 06:52:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704725568; x=1705330368;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=794xssVY3UWprU6xtQn72foNfENfQl/zR70PtdxL1SY=;
        b=I1hGFglxzutSqQ6QAiY6rCS2hzlkpa5x7HwbONwNjnMRnyReob8v+u1tPuyJtrAqpA
         f3gFtC47n3NqVcAdIxoXFYdAK1stpXrbq4n399lMI/hPyFOZfrxEl7V88EGfVHRNziy1
         03vnFe6S3H/R8BxYP1FrS+O1yzALMdKYTj59euLD02p8gpqKUA6H4r70nh5otjl4BRgW
         kF0JTaNm4bfkMkSnWs/amms/pEjZ3ymgQ5ERnzN0cz/WjvB25IX5TqWHS3qulIj/kpPy
         GgM1iHh57tPjMPJ4lyHoz4yEPw7A4smotNrbGOCa4bHULCqHe8dTExiSgK3SgdAxT4Jv
         FGkQ==
X-Gm-Message-State: AOJu0Yy+lL/WvUdbBNMFDCuKC4tpcKuXgnBnbp5L5SGPXJJsAyRe7Zac
	NXKDMSq8luZJDIbdizUCv9g826kuA43q4IMnlKn5TJfOs7G/8xneoJhbE3MbuH+UJfcIFZO3gEE
	+UC5UZ2QX50syiCatm+8m17jcYw==
X-Received: by 2002:a19:8c57:0:b0:50e:b204:b6d4 with SMTP id i23-20020a198c57000000b0050eb204b6d4mr1449619lfj.35.1704725568589;
        Mon, 08 Jan 2024 06:52:48 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFTda8KnSzcfucxjSOMlVVPp7393wkBNdRpKd1j6z4nNnIHCLj7t3gH6YaBxn+pCz3Krz8KOg==
X-Received: by 2002:a19:8c57:0:b0:50e:b204:b6d4 with SMTP id i23-20020a198c57000000b0050eb204b6d4mr1449605lfj.35.1704725568149;
        Mon, 08 Jan 2024 06:52:48 -0800 (PST)
Received: from [10.40.98.142] ([78.108.130.194])
        by smtp.gmail.com with ESMTPSA id s27-20020a170906bc5b00b00a2699a54888sm3985890ejv.64.2024.01.08.06.52.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Jan 2024 06:52:47 -0800 (PST)
Message-ID: <6186419a-8107-47e6-b631-1ce8b4a42819@redhat.com>
Date: Mon, 8 Jan 2024 15:52:46 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] platform/x86: intel-uncore-freq: Fix types in sysfs
 callbacks
To: Nathan Chancellor <nathan@kernel.org>,
 srinivas.pandruvada@linux.intel.com, ilpo.jarvinen@linux.intel.com
Cc: keescook@chromium.org, samitolvanen@google.com,
 platform-driver-x86@vger.kernel.org, llvm@lists.linux.dev,
 patches@lists.linux.dev
References: <20240104-intel-uncore-freq-kcfi-fix-v1-1-bf1e8939af40@kernel.org>
From: Hans de Goede <hdegoede@redhat.com>
In-Reply-To: <20240104-intel-uncore-freq-kcfi-fix-v1-1-bf1e8939af40@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi,

On 1/4/24 23:59, Nathan Chancellor wrote:
> When booting a kernel with CONFIG_CFI_CLANG, there is a CFI failure when
> accessing any of the values under
> /sys/devices/system/cpu/intel_uncore_frequency/package_00_die_00:
> 
>   $ cat /sys/devices/system/cpu/intel_uncore_frequency/package_00_die_00/max_freq_khz
>   fish: Job 1, 'cat /sys/devices/system/cpu/int…' terminated by signal SIGSEGV (Address boundary error)
> 
>   $ sudo dmesg &| grep 'CFI failure'
>   [  170.953925] CFI failure at kobj_attr_show+0x19/0x30 (target: show_max_freq_khz+0x0/0xc0 [intel_uncore_frequency_common]; expected type: 0xd34078c5
> 
> The sysfs callback functions such as show_domain_id() are written as if
> they are going to be called by dev_attr_show() but as the above message
> shows, they are instead called by kobj_attr_show(). kCFI checks that the
> destination of an indirect jump has the exact same type as the prototype
> of the function pointer it is called through and fails when they do not.
> 
> These callbacks are called through kobj_attr_show() because
> uncore_root_kobj was initialized with kobject_create_and_add(), which
> means uncore_root_kobj has a ->sysfs_ops of kobj_sysfs_ops from
> kobject_create(), which uses kobj_attr_show() as its ->show() value.
> 
> The only reason there has not been a more noticeable problem until this
> point is that 'struct kobj_attribute' and 'struct device_attribute' have
> the same layout, so getting the callback from container_of() works the
> same with either value.
> 
> Change all the callbacks and their uses to be compatible with
> kobj_attr_show() and kobj_attr_store(), which resolves the kCFI failure
> and allows the sysfs files to work properly.
> 
> Closes: https://github.com/ClangBuiltLinux/linux/issues/1974
> Fixes: ae7b2ce57851 ("platform/x86/intel/uncore-freq: Use sysfs API to create attributes")
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
> I think I got the fixes tag right. I only started seeing this because of
> commit 27f2b08735c9 ("platform/x86: intel-uncore-freq: Add additional
> client processors"), which allows this driver to load on my i7-11700
> test system but I think the commit in the Fixes tag incorrectly changes
> the types of the callbacks.

Thank you for your patch, I've applied this patch to my review-hans 
branch:
https://git.kernel.org/pub/scm/linux/kernel/git/pdx86/platform-drivers-x86.git/log/?h=review-hans

Note it will show up in my review-hans branch once I've pushed my
local branch there, which might take a while.

I will include this patch in my next fixes pull-req to Linus
for the current kernel development cycle.

Regards,

Hans




> ---
>  .../uncore-frequency/uncore-frequency-common.c     | 82 +++++++++++-----------
>  .../uncore-frequency/uncore-frequency-common.h     | 32 ++++-----
>  2 files changed, 57 insertions(+), 57 deletions(-)
> 
> diff --git a/drivers/platform/x86/intel/uncore-frequency/uncore-frequency-common.c b/drivers/platform/x86/intel/uncore-frequency/uncore-frequency-common.c
> index 33ab207493e3..33bb58dc3f78 100644
> --- a/drivers/platform/x86/intel/uncore-frequency/uncore-frequency-common.c
> +++ b/drivers/platform/x86/intel/uncore-frequency/uncore-frequency-common.c
> @@ -23,23 +23,23 @@ static int (*uncore_read)(struct uncore_data *data, unsigned int *min, unsigned
>  static int (*uncore_write)(struct uncore_data *data, unsigned int input, unsigned int min_max);
>  static int (*uncore_read_freq)(struct uncore_data *data, unsigned int *freq);
>  
> -static ssize_t show_domain_id(struct device *dev, struct device_attribute *attr, char *buf)
> +static ssize_t show_domain_id(struct kobject *kobj, struct kobj_attribute *attr, char *buf)
>  {
> -	struct uncore_data *data = container_of(attr, struct uncore_data, domain_id_dev_attr);
> +	struct uncore_data *data = container_of(attr, struct uncore_data, domain_id_kobj_attr);
>  
>  	return sprintf(buf, "%u\n", data->domain_id);
>  }
>  
> -static ssize_t show_fabric_cluster_id(struct device *dev, struct device_attribute *attr, char *buf)
> +static ssize_t show_fabric_cluster_id(struct kobject *kobj, struct kobj_attribute *attr, char *buf)
>  {
> -	struct uncore_data *data = container_of(attr, struct uncore_data, fabric_cluster_id_dev_attr);
> +	struct uncore_data *data = container_of(attr, struct uncore_data, fabric_cluster_id_kobj_attr);
>  
>  	return sprintf(buf, "%u\n", data->cluster_id);
>  }
>  
> -static ssize_t show_package_id(struct device *dev, struct device_attribute *attr, char *buf)
> +static ssize_t show_package_id(struct kobject *kobj, struct kobj_attribute *attr, char *buf)
>  {
> -	struct uncore_data *data = container_of(attr, struct uncore_data, package_id_dev_attr);
> +	struct uncore_data *data = container_of(attr, struct uncore_data, package_id_kobj_attr);
>  
>  	return sprintf(buf, "%u\n", data->package_id);
>  }
> @@ -97,30 +97,30 @@ static ssize_t show_perf_status_freq_khz(struct uncore_data *data, char *buf)
>  }
>  
>  #define store_uncore_min_max(name, min_max)				\
> -	static ssize_t store_##name(struct device *dev,		\
> -				     struct device_attribute *attr,	\
> +	static ssize_t store_##name(struct kobject *kobj,		\
> +				     struct kobj_attribute *attr,	\
>  				     const char *buf, size_t count)	\
>  	{								\
> -		struct uncore_data *data = container_of(attr, struct uncore_data, name##_dev_attr);\
> +		struct uncore_data *data = container_of(attr, struct uncore_data, name##_kobj_attr);\
>  									\
>  		return store_min_max_freq_khz(data, buf, count,	\
>  					      min_max);		\
>  	}
>  
>  #define show_uncore_min_max(name, min_max)				\
> -	static ssize_t show_##name(struct device *dev,		\
> -				    struct device_attribute *attr, char *buf)\
> +	static ssize_t show_##name(struct kobject *kobj,		\
> +				    struct kobj_attribute *attr, char *buf)\
>  	{                                                               \
> -		struct uncore_data *data = container_of(attr, struct uncore_data, name##_dev_attr);\
> +		struct uncore_data *data = container_of(attr, struct uncore_data, name##_kobj_attr);\
>  									\
>  		return show_min_max_freq_khz(data, buf, min_max);	\
>  	}
>  
>  #define show_uncore_perf_status(name)					\
> -	static ssize_t show_##name(struct device *dev,		\
> -				   struct device_attribute *attr, char *buf)\
> +	static ssize_t show_##name(struct kobject *kobj,		\
> +				   struct kobj_attribute *attr, char *buf)\
>  	{                                                               \
> -		struct uncore_data *data = container_of(attr, struct uncore_data, name##_dev_attr);\
> +		struct uncore_data *data = container_of(attr, struct uncore_data, name##_kobj_attr);\
>  									\
>  		return show_perf_status_freq_khz(data, buf); \
>  	}
> @@ -134,11 +134,11 @@ show_uncore_min_max(max_freq_khz, 1);
>  show_uncore_perf_status(current_freq_khz);
>  
>  #define show_uncore_data(member_name)					\
> -	static ssize_t show_##member_name(struct device *dev,	\
> -					   struct device_attribute *attr, char *buf)\
> +	static ssize_t show_##member_name(struct kobject *kobj,	\
> +					   struct kobj_attribute *attr, char *buf)\
>  	{                                                               \
>  		struct uncore_data *data = container_of(attr, struct uncore_data,\
> -							  member_name##_dev_attr);\
> +							  member_name##_kobj_attr);\
>  									\
>  		return sysfs_emit(buf, "%u\n",				\
>  				 data->member_name);			\
> @@ -149,29 +149,29 @@ show_uncore_data(initial_max_freq_khz);
>  
>  #define init_attribute_rw(_name)					\
>  	do {								\
> -		sysfs_attr_init(&data->_name##_dev_attr.attr);	\
> -		data->_name##_dev_attr.show = show_##_name;		\
> -		data->_name##_dev_attr.store = store_##_name;		\
> -		data->_name##_dev_attr.attr.name = #_name;		\
> -		data->_name##_dev_attr.attr.mode = 0644;		\
> +		sysfs_attr_init(&data->_name##_kobj_attr.attr);	\
> +		data->_name##_kobj_attr.show = show_##_name;		\
> +		data->_name##_kobj_attr.store = store_##_name;		\
> +		data->_name##_kobj_attr.attr.name = #_name;		\
> +		data->_name##_kobj_attr.attr.mode = 0644;		\
>  	} while (0)
>  
>  #define init_attribute_ro(_name)					\
>  	do {								\
> -		sysfs_attr_init(&data->_name##_dev_attr.attr);	\
> -		data->_name##_dev_attr.show = show_##_name;		\
> -		data->_name##_dev_attr.store = NULL;			\
> -		data->_name##_dev_attr.attr.name = #_name;		\
> -		data->_name##_dev_attr.attr.mode = 0444;		\
> +		sysfs_attr_init(&data->_name##_kobj_attr.attr);	\
> +		data->_name##_kobj_attr.show = show_##_name;		\
> +		data->_name##_kobj_attr.store = NULL;			\
> +		data->_name##_kobj_attr.attr.name = #_name;		\
> +		data->_name##_kobj_attr.attr.mode = 0444;		\
>  	} while (0)
>  
>  #define init_attribute_root_ro(_name)					\
>  	do {								\
> -		sysfs_attr_init(&data->_name##_dev_attr.attr);	\
> -		data->_name##_dev_attr.show = show_##_name;		\
> -		data->_name##_dev_attr.store = NULL;			\
> -		data->_name##_dev_attr.attr.name = #_name;		\
> -		data->_name##_dev_attr.attr.mode = 0400;		\
> +		sysfs_attr_init(&data->_name##_kobj_attr.attr);	\
> +		data->_name##_kobj_attr.show = show_##_name;		\
> +		data->_name##_kobj_attr.store = NULL;			\
> +		data->_name##_kobj_attr.attr.name = #_name;		\
> +		data->_name##_kobj_attr.attr.mode = 0400;		\
>  	} while (0)
>  
>  static int create_attr_group(struct uncore_data *data, char *name)
> @@ -186,21 +186,21 @@ static int create_attr_group(struct uncore_data *data, char *name)
>  
>  	if (data->domain_id != UNCORE_DOMAIN_ID_INVALID) {
>  		init_attribute_root_ro(domain_id);
> -		data->uncore_attrs[index++] = &data->domain_id_dev_attr.attr;
> +		data->uncore_attrs[index++] = &data->domain_id_kobj_attr.attr;
>  		init_attribute_root_ro(fabric_cluster_id);
> -		data->uncore_attrs[index++] = &data->fabric_cluster_id_dev_attr.attr;
> +		data->uncore_attrs[index++] = &data->fabric_cluster_id_kobj_attr.attr;
>  		init_attribute_root_ro(package_id);
> -		data->uncore_attrs[index++] = &data->package_id_dev_attr.attr;
> +		data->uncore_attrs[index++] = &data->package_id_kobj_attr.attr;
>  	}
>  
> -	data->uncore_attrs[index++] = &data->max_freq_khz_dev_attr.attr;
> -	data->uncore_attrs[index++] = &data->min_freq_khz_dev_attr.attr;
> -	data->uncore_attrs[index++] = &data->initial_min_freq_khz_dev_attr.attr;
> -	data->uncore_attrs[index++] = &data->initial_max_freq_khz_dev_attr.attr;
> +	data->uncore_attrs[index++] = &data->max_freq_khz_kobj_attr.attr;
> +	data->uncore_attrs[index++] = &data->min_freq_khz_kobj_attr.attr;
> +	data->uncore_attrs[index++] = &data->initial_min_freq_khz_kobj_attr.attr;
> +	data->uncore_attrs[index++] = &data->initial_max_freq_khz_kobj_attr.attr;
>  
>  	ret = uncore_read_freq(data, &freq);
>  	if (!ret)
> -		data->uncore_attrs[index++] = &data->current_freq_khz_dev_attr.attr;
> +		data->uncore_attrs[index++] = &data->current_freq_khz_kobj_attr.attr;
>  
>  	data->uncore_attrs[index] = NULL;
>  
> diff --git a/drivers/platform/x86/intel/uncore-frequency/uncore-frequency-common.h b/drivers/platform/x86/intel/uncore-frequency/uncore-frequency-common.h
> index 7afb69977c7e..0e5bf507e555 100644
> --- a/drivers/platform/x86/intel/uncore-frequency/uncore-frequency-common.h
> +++ b/drivers/platform/x86/intel/uncore-frequency/uncore-frequency-common.h
> @@ -26,14 +26,14 @@
>   * @instance_id:	Unique instance id to append to directory name
>   * @name:		Sysfs entry name for this instance
>   * @uncore_attr_group:	Attribute group storage
> - * @max_freq_khz_dev_attr: Storage for device attribute max_freq_khz
> - * @mix_freq_khz_dev_attr: Storage for device attribute min_freq_khz
> - * @initial_max_freq_khz_dev_attr: Storage for device attribute initial_max_freq_khz
> - * @initial_min_freq_khz_dev_attr: Storage for device attribute initial_min_freq_khz
> - * @current_freq_khz_dev_attr: Storage for device attribute current_freq_khz
> - * @domain_id_dev_attr: Storage for device attribute domain_id
> - * @fabric_cluster_id_dev_attr: Storage for device attribute fabric_cluster_id
> - * @package_id_dev_attr: Storage for device attribute package_id
> + * @max_freq_khz_kobj_attr: Storage for kobject attribute max_freq_khz
> + * @mix_freq_khz_kobj_attr: Storage for kobject attribute min_freq_khz
> + * @initial_max_freq_khz_kobj_attr: Storage for kobject attribute initial_max_freq_khz
> + * @initial_min_freq_khz_kobj_attr: Storage for kobject attribute initial_min_freq_khz
> + * @current_freq_khz_kobj_attr: Storage for kobject attribute current_freq_khz
> + * @domain_id_kobj_attr: Storage for kobject attribute domain_id
> + * @fabric_cluster_id_kobj_attr: Storage for kobject attribute fabric_cluster_id
> + * @package_id_kobj_attr: Storage for kobject attribute package_id
>   * @uncore_attrs:	Attribute storage for group creation
>   *
>   * This structure is used to encapsulate all data related to uncore sysfs
> @@ -53,14 +53,14 @@ struct uncore_data {
>  	char name[32];
>  
>  	struct attribute_group uncore_attr_group;
> -	struct device_attribute max_freq_khz_dev_attr;
> -	struct device_attribute min_freq_khz_dev_attr;
> -	struct device_attribute initial_max_freq_khz_dev_attr;
> -	struct device_attribute initial_min_freq_khz_dev_attr;
> -	struct device_attribute current_freq_khz_dev_attr;
> -	struct device_attribute domain_id_dev_attr;
> -	struct device_attribute fabric_cluster_id_dev_attr;
> -	struct device_attribute package_id_dev_attr;
> +	struct kobj_attribute max_freq_khz_kobj_attr;
> +	struct kobj_attribute min_freq_khz_kobj_attr;
> +	struct kobj_attribute initial_max_freq_khz_kobj_attr;
> +	struct kobj_attribute initial_min_freq_khz_kobj_attr;
> +	struct kobj_attribute current_freq_khz_kobj_attr;
> +	struct kobj_attribute domain_id_kobj_attr;
> +	struct kobj_attribute fabric_cluster_id_kobj_attr;
> +	struct kobj_attribute package_id_kobj_attr;
>  	struct attribute *uncore_attrs[9];
>  };
>  
> 
> ---
> base-commit: 236f7d8034ff401d02fa6d74bae494a2b54e1834
> change-id: 20240104-intel-uncore-freq-kcfi-fix-6ef07053db58
> 
> Best regards,

