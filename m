Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AD891865
	for <patches@lists.linux.dev>; Mon,  9 May 2022 12:12:19 +0000 (UTC)
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1652098337;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=srsynYuBpe8e28DoE8JdVL1cys9Y1o9AwvMFSnIsIfQ=;
	b=OFA8QOSVTQ+hT7lcy5Ybp/F+7o/kCZtozbzATnblIZ4ALc9fjHFlabtwKXW34AYHXVuD8K
	qa4j3YI7mI8KJXl+xE9u/8ZSAaGs221b6DhHCabeKJBDtRVZbRxqdKnZNVn0p6Aboj1wt4
	DXaxjqGESKSMxd9Slcav5dfaSVF9FqUoIk/9Y3mp26voUhL4LKGkZdEBnQD6sM5r1d39W/
	p7Y79x6/rAw/9qow5Rjg6QFbunCHE3hfkXcvBcEMvUmFCvUDXQl0PvhuKcVr/HvKvRPQBd
	GLxL1jHysWCcfeP3V6j8AdYMz82/m4CZnm4IMb5LlYeLMun6N3BxTCxdi7WKWQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1652098337;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=srsynYuBpe8e28DoE8JdVL1cys9Y1o9AwvMFSnIsIfQ=;
	b=X2n3wm36y9cSAsKWfZVzmKtJuTc4pxZ7p30ZG04EmnHzCkHRiOpVjJX+/wKjNdl9rCaqxG
	1XMTA/DwhKIb/tBw==
To: Tony Luck <tony.luck@intel.com>, hdegoede@redhat.com, markgross@kernel.org
Cc: mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
 x86@kernel.org, hpa@zytor.com, corbet@lwn.net, gregkh@linuxfoundation.org,
 andriy.shevchenko@linux.intel.com, jithu.joseph@intel.com,
 ashok.raj@intel.com, tony.luck@intel.com, rostedt@goodmis.org,
 dan.j.williams@intel.com, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, platform-driver-x86@vger.kernel.org,
 patches@lists.linux.dev, ravi.v.shankar@intel.com
Subject: Re: [PATCH v7 09/12] platform/x86/intel/ifs: Add IFS sysfs interface
In-Reply-To: <20220506225410.1652287-10-tony.luck@intel.com>
References: <20220506014035.1173578-1-tony.luck@intel.com>
 <20220506225410.1652287-1-tony.luck@intel.com>
 <20220506225410.1652287-10-tony.luck@intel.com>
Date: Mon, 09 May 2022 14:12:17 +0200
Message-ID: <87tu9yrjku.ffs@tglx>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

On Fri, May 06 2022 at 15:54, Tony Luck wrote:
> Implement sysfs interface to trigger ifs test for a specific cpu.
> Additional interfaces related to checking the status of the
> scan test and seeing the version of the loaded IFS binary
> are also added.
>
> The basic usage is as below.
>    - To start test, for example on cpu5:
>        echo 5 > /sys/devices/platform/intel_ifs/run_test
>    - To see the status of the last test
>        cat /sys/devices/platform/intel_ifs/status
>    - To see the version of the loaded scan binary
>        cat /sys/devices/platform/intel_ifs/image_version
>
> Reviewed-by: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Jithu Joseph <jithu.joseph@intel.com>
> Co-developed-by: Tony Luck <tony.luck@intel.com>
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> Acked-by: Hans de Goede <hdegoede@redhat.com>
> Reviewed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
