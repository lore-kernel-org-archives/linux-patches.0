Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACFEF28F2
	for <patches@lists.linux.dev>; Mon, 13 Mar 2023 16:24:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1678724662;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EKtb7EpHXRAMX2Z7IyQHJ5bWLz0eoLShXEZ2QZIhbro=;
	b=WTRuc1YkcNOGFVP3TJryE7vGfzVqSFQqdIuWun1MHX6/ADiaB/UZmpPijjZcGwvddxHZti
	fGLO6X34Rmoa+pVrQVPWHVVg5Yn472H+Woi3YpI+G7y0BedwHh2ulfyp9UDE5O6hs6My6V
	dtodwY7atvoVOHOnbn0ZpIeYklREe/g=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-547-8HZ9tAAGPrmgeFU3tKpPXg-1; Mon, 13 Mar 2023 12:24:20 -0400
X-MC-Unique: 8HZ9tAAGPrmgeFU3tKpPXg-1
Received: by mail-ed1-f69.google.com with SMTP id i22-20020a05640242d600b004f5962985f4so17471617edc.12
        for <patches@lists.linux.dev>; Mon, 13 Mar 2023 09:24:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678724659;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EKtb7EpHXRAMX2Z7IyQHJ5bWLz0eoLShXEZ2QZIhbro=;
        b=aVKxVCekQmqteldhHIm5hlK0VDtV22ISbMKWAr7eg2Lq27S7KOi0DZqTe9CFtVBcnZ
         cIGwGxV4nWOQLwO9xQnSzy6r4NZqEz1/66nN5FnS+PdVhwezyhqAi7BWV9Po5Uaj2hJg
         ZhipiYfED1DdkD1iMfkAioem5Z507jFllngCV8xuoA1LEpoQ9PcC2bpD+3wml2h+hemw
         r6zJhzHfFu7FXvKU/bR+mcKPi9dTSiVze/YP1+sf3SwXZ86bSMK9lkAy1/LPyxEJFCul
         Cg3XcpyMisVIzpGiDTh/OitOtac0LnL14d0FxOb42fFhDLL7NlmJRfyGXhMmbc3ae6ha
         /pyA==
X-Gm-Message-State: AO0yUKWIbLcI2dqrdBDXtcLKAayYAYS68CEVC4n4qeY3pBd7SfgiPYCp
	wdsnRpSvJ5aomawm8kMMQI52EZDv/iCKXGKAi1aHfgWodi6COH+1MYOnVZxIVjo8nyTQ1a3c8JC
	nspxu/wNzDQCru5B5mA==
X-Received: by 2002:aa7:d814:0:b0:4ae:f496:ee2 with SMTP id v20-20020aa7d814000000b004aef4960ee2mr32009669edq.20.1678724659012;
        Mon, 13 Mar 2023 09:24:19 -0700 (PDT)
X-Google-Smtp-Source: AK7set8LRMrIh6Vsyr5TWm3hlEFXujVApzsp43JInL7wnyXfZ5cHE5NKyywj8ukEwWJ0Nx2GPZ6zfg==
X-Received: by 2002:aa7:d814:0:b0:4ae:f496:ee2 with SMTP id v20-20020aa7d814000000b004aef4960ee2mr32009644edq.20.1678724658723;
        Mon, 13 Mar 2023 09:24:18 -0700 (PDT)
Received: from [10.40.98.142] ([78.108.130.194])
        by smtp.gmail.com with ESMTPSA id d11-20020a056402400b00b004fadc041e13sm2623964eda.42.2023.03.13.09.24.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Mar 2023 09:24:18 -0700 (PDT)
Message-ID: <628e092c-793e-96ce-71f5-80392ad69569@redhat.com>
Date: Mon, 13 Mar 2023 17:24:17 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH v3 6/8] platform/x86/intel/ifs: Implement Array BIST test
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
 <20230301015942.462799-7-jithu.joseph@intel.com>
From: Hans de Goede <hdegoede@redhat.com>
In-Reply-To: <20230301015942.462799-7-jithu.joseph@intel.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi,

On 3/1/23 02:59, Jithu Joseph wrote:
> Array BIST test (for a particlular core) is triggered by writing
> to MSR_ARRAY_BIST from one sibling of the core.
> 
> This will initiate a test for all supported arrays on that
> CPU. Array BIST test may be aborted before completing all the
> arrays in the event of an interrupt or other reasons.
> In this case, kernel will restart the test from that point
> onwards. Array test will also be aborted when the test fails,
> in which case the test is stopped immediately without further
> retry.
> 
> Signed-off-by: Jithu Joseph <jithu.joseph@intel.com>
> Reviewed-by: Tony Luck <tony.luck@intel.com>
> ---
>  drivers/platform/x86/intel/ifs/ifs.h     | 12 ++++
>  drivers/platform/x86/intel/ifs/runtest.c | 81 ++++++++++++++++++++++++
>  2 files changed, 93 insertions(+)
> 
> diff --git a/drivers/platform/x86/intel/ifs/ifs.h b/drivers/platform/x86/intel/ifs/ifs.h
> index f31966e291df..1228101de201 100644
> --- a/drivers/platform/x86/intel/ifs/ifs.h
> +++ b/drivers/platform/x86/intel/ifs/ifs.h
> @@ -127,6 +127,7 @@
>  #include <linux/device.h>
>  #include <linux/miscdevice.h>
>  
> +#define MSR_ARRAY_BIST				0x00000105
>  #define MSR_COPY_SCAN_HASHES			0x000002c2
>  #define MSR_SCAN_HASHES_STATUS			0x000002c3
>  #define MSR_AUTHENTICATE_AND_COPY_CHUNK		0x000002c4
> @@ -192,6 +193,17 @@ union ifs_status {
>  	};
>  };
>  
> +/* MSR_ARRAY_BIST bit fields */
> +union ifs_array {
> +	u64	data;
> +	struct {
> +		u32	array_bitmask;
> +		u16	array_bank;
> +		u16	rsvd			:15;
> +		u16	ctrl_result		:1;
> +	};
> +};
> +
>  /*
>   * Driver populated error-codes
>   * 0xFD: Test timed out before completing all the chunks.
> diff --git a/drivers/platform/x86/intel/ifs/runtest.c b/drivers/platform/x86/intel/ifs/runtest.c
> index 969b3e0946d5..3a5442796c7d 100644
> --- a/drivers/platform/x86/intel/ifs/runtest.c
> +++ b/drivers/platform/x86/intel/ifs/runtest.c
> @@ -229,6 +229,85 @@ static void ifs_test_core(int cpu, struct device *dev)
>  	}
>  }
>  
> +#define SPINUNIT 100 /* 100 nsec */
> +static atomic_t array_cpus_out;

This variable is only inc-ed + read, it is never reset to 0
so the "while (atomic_read(t) < all_cpus)"
check only works for the first test run.

Also even static atomic_t variables must be initialized, you cannot
assume that using using zeroed mem is a valid value for an atomic_t.

And this is also shared between all smt pairs, so if 2 "real"
CPU cores with both 2 sibblings are asked to run IFS tests at
the same time, then array_cpus_out will get increased 4 times
in total, breaking the wait_for_sibbling loop as soon as
the counter reaches 2, so before the tests are done.

It looks like this bit needs to be reworked so that the busy spinning
the sibbling uses per "real" cpu core data and so that the counter
is reset before the tests are started.

Regards,

Hans

> +
> +/*
> + * Simplified cpu sibling rendezvous loop based on microcode loader __wait_for_cpus()
> + */
> +static void wait_for_sibling_cpu(atomic_t *t, long long timeout)
> +{
> +	int cpu = smp_processor_id();
> +	const struct cpumask *smt_mask = cpu_smt_mask(cpu);
> +	int all_cpus = cpumask_weight(smt_mask);
> +
> +	atomic_inc(t);
> +	while (atomic_read(t) < all_cpus) {
> +		if (timeout < SPINUNIT)
> +			return;
> +		ndelay(SPINUNIT);
> +		timeout -= SPINUNIT;
> +		touch_nmi_watchdog();
> +	}
> +}
> +
> +static int do_array_test(void *data)
> +{
> +	union ifs_array *command = data;
> +	int cpu = smp_processor_id();
> +	int first;
> +
> +	/*
> +	 * Only one logical CPU on a core needs to trigger the Array test via MSR write.
> +	 */
> +	first = cpumask_first(cpu_smt_mask(cpu));
> +
> +	if (cpu == first) {
> +		wrmsrl(MSR_ARRAY_BIST, command->data);
> +		/* Pass back the result of the test */
> +		rdmsrl(MSR_ARRAY_BIST, command->data);
> +	}
> +
> +	/* Tests complete faster if the sibling is spinning here */
> +	wait_for_sibling_cpu(&array_cpus_out, NSEC_PER_SEC);
> +
> +	return 0;
> +}
> +
> +static void ifs_array_test_core(int cpu, struct device *dev)
> +{
> +	union ifs_array command = {};
> +	bool timed_out = false;
> +	struct ifs_data *ifsd;
> +	unsigned long timeout;
> +
> +	ifsd = ifs_get_data(dev);
> +
> +	command.array_bitmask = ~0U;
> +	timeout = jiffies + HZ / 2;
> +
> +	do {
> +		if (time_after(jiffies, timeout)) {
> +			timed_out = true;
> +			break;
> +		}
> +		atomic_set(&array_cpus_out, 0);
> +		stop_core_cpuslocked(cpu, do_array_test, &command);
> +
> +		if (command.ctrl_result)
> +			break;
> +	} while (command.array_bitmask);
> +
> +	ifsd->scan_details = command.data;
> +
> +	if (command.ctrl_result)
> +		ifsd->status = SCAN_TEST_FAIL;
> +	else if (timed_out || command.array_bitmask)
> +		ifsd->status = SCAN_NOT_TESTED;
> +	else
> +		ifsd->status = SCAN_TEST_PASS;
> +}
> +
>  /*
>   * Initiate per core test. It wakes up work queue threads on the target cpu and
>   * its sibling cpu. Once all sibling threads wake up, the scan test gets executed and
> @@ -253,6 +332,8 @@ int do_core_test(int cpu, struct device *dev)
>  		ifs_test_core(cpu, dev);
>  		break;
>  	case IFS_TYPE_ARRAY_BIST:
> +		ifs_array_test_core(cpu, dev);
> +		break;
>  	default:
>  		return -EINVAL;
>  	}

