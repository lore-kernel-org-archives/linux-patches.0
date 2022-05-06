Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E49797E8
	for <patches@lists.linux.dev>; Fri,  6 May 2022 08:23:56 +0000 (UTC)
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1651825434;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=770rOCEglJcTn6tOCmhg2DWqxE2dENlNOc6UvMrWrn0=;
	b=SWdlPTx50Sth51PvJ895RJTrT4U24BL4jUAFpr4iLPHiAGZqSnszudzX19JIt0rBwORvW3
	ln9dKTaD7e5bdN9HhwZW5AuVU8kpBDN/Zf+Qp2D7P//NP0vxRiLhfrB55uXMNnMk95IQST
	RZzjuDfS3O3YMH65RtEkxPX821YxIClVWuMvwbBt494vVZ00B+wyWbJ/Jkv2llZsm7jDeC
	V8YIzlYWLaA5aW2RAgVsM3OMkER8elfU/FqfdJcq5hQxoo1jutEacwxDQO1JalB9NFvS05
	JWSaPxdmnw01ddtTlx+F6tx2EkpZaV5YGyXadPsrOYGJX2PC481JPpEhAYoj5g==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1651825434;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=770rOCEglJcTn6tOCmhg2DWqxE2dENlNOc6UvMrWrn0=;
	b=UhQ+wS469qIUvvXkeMoQ2z5tuJDuxrtHGkFcCGrgMQ8u1/Wh2cDAchumGeta7jwV0+SXE0
	j/73GWMjRB3BwWCA==
To: Tony Luck <tony.luck@intel.com>, hdegoede@redhat.com, markgross@kernel.org
Cc: mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
 x86@kernel.org, hpa@zytor.com, corbet@lwn.net, gregkh@linuxfoundation.org,
 andriy.shevchenko@linux.intel.com, jithu.joseph@intel.com,
 ashok.raj@intel.com, tony.luck@intel.com, rostedt@goodmis.org,
 dan.j.williams@intel.com, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, platform-driver-x86@vger.kernel.org,
 patches@lists.linux.dev, ravi.v.shankar@intel.com
Subject: Re: [PATCH v6 04/11] platform/x86/intel/ifs: Add stub driver for
 In-Field Scan
In-Reply-To: <20220506014035.1173578-5-tony.luck@intel.com>
References: <20220428153849.295779-1-tony.luck@intel.com>
 <20220506014035.1173578-1-tony.luck@intel.com>
 <20220506014035.1173578-5-tony.luck@intel.com>
Date: Fri, 06 May 2022 10:23:54 +0200
Message-ID: <87tua3gjc5.ffs@tglx>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

On Thu, May 05 2022 at 18:40, Tony Luck wrote:
> +#include <asm/cpu_device_id.h>
> +
> +#define X86_MATCH(model)				\
> +	X86_MATCH_VENDOR_FAM_MODEL_FEATURE(INTEL, 6,	\
> +		INTEL_FAM6_##model, X86_FEATURE_CORE_CAPABILITIES, NULL)
> +
> +static const struct x86_cpu_id ifs_cpu_ids[] __initconst = {
> +	X86_MATCH(SAPPHIRERAPIDS_X),

I still hate this with a passion. Nevertheless:

Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
