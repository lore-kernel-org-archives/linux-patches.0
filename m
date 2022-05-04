Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13FF42119
	for <patches@lists.linux.dev>; Wed,  4 May 2022 10:37:53 +0000 (UTC)
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1651660672;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lzcPu6GZE6ZiaZyABqJBDH3V4kDcq2cOcg6QCnZEcyw=;
	b=ovf/Csmq3jTKaCHL/duZUMzM92UA3ybQPuPS/yR4hQyfMAMiBVXU2uBCn6ChoPSyXAfSo9
	bJjhZS94xj7/+QmApH28oJm11Br3PWNSOxp1bUXPqx0rKKdknFjls32DU4SjFa6h2mC9FG
	q+7A5c8xCM1uB60EOvOpVDYCGB+3oW7z4fhOZPG0gkHa//xQgwJAnB9xjOQo5rt++R0SpH
	m3vrDOqhmxFOjkWIraav8Qi6m439Z9DQ1Hn/IY5cMJrQm2FnbzXAZlSiy/4krl1VYmxGXF
	thd/N4iuIhQtjYbGFsrQuRI05DW6z/ZpBhjKJJkcCwB2D2NBsXJyx114mB8ULQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1651660672;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lzcPu6GZE6ZiaZyABqJBDH3V4kDcq2cOcg6QCnZEcyw=;
	b=BC/5VsG6lYSZc3t+ojfusr5IIyCrAsxHoz70LVlfMswd0nu2Kajh4YcdNrqzUc0s9vB/WZ
	ovNrwvd3WjLTtJCw==
To: Tony Luck <tony.luck@intel.com>, hdegoede@redhat.com, markgross@kernel.org
Cc: mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
 x86@kernel.org, hpa@zytor.com, corbet@lwn.net, gregkh@linuxfoundation.org,
 andriy.shevchenko@linux.intel.com, jithu.joseph@intel.com,
 ashok.raj@intel.com, tony.luck@intel.com, rostedt@goodmis.org,
 dan.j.williams@intel.com, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, platform-driver-x86@vger.kernel.org,
 patches@lists.linux.dev, ravi.v.shankar@intel.com
Subject: Re: [PATCH v5 04/10] platform/x86/intel/ifs: Read IFS firmware image
In-Reply-To: <20220428153849.295779-5-tony.luck@intel.com>
References: <20220422200219.2843823-1-tony.luck@intel.com>
 <20220428153849.295779-1-tony.luck@intel.com>
 <20220428153849.295779-5-tony.luck@intel.com>
Date: Wed, 04 May 2022 12:37:52 +0200
Message-ID: <87wnf1k2gv.ffs@tglx>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

On Thu, Apr 28 2022 at 08:38, Tony Luck wrote:
> +/*
> + * Load ifs image. Before loading ifs module, the ifs image must be located
> + * in /lib/firmware/intel/ifs and named as {family/model/stepping}.{testname}.
> + */
> +void ifs_load_firmware(struct device *dev)
> +{
> +	const struct firmware *fw;
> +	char scan_path[32];
> +	int ret;
> +
> +	snprintf(scan_path, sizeof(scan_path), "intel/ifs/%02x-%02x-%02x.scan",
> +		 boot_cpu_data.x86, boot_cpu_data.x86_model, boot_cpu_data.x86_stepping);
> +
> +	ret = request_firmware_direct(&fw, scan_path, dev);
> +	if (ret) {
> +		dev_err(dev, "ifs file %s load failed\n", scan_path);
> +		return;

Why is this not returning an error to the caller?

Thanks,

        tglx
