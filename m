Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60ABF366
	for <patches@lists.linux.dev>; Fri,  8 Apr 2022 05:02:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F015C385A1;
	Fri,  8 Apr 2022 05:02:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1649394131;
	bh=8Me5S15U2F7dvfg9grdHqoSj3D7p+UN1Je6bZ9/30xQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=1ejXQHolNEw61TXM0OE4CIyklLuxg9JFPBmpT1uzODSwUvl7OLGDDC1ayaKzwItrt
	 Yr++lY1imkBXSlDamHgCnlIjP2f237tfE3jXojGbYltzJswhf8AtTkhJBEjKRnhgCl
	 w00S1Yq6d7zHp0plWsG8KD8zTPwuPVn+BuyXtWqM=
Date: Fri, 8 Apr 2022 07:02:08 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Jithu Joseph <jithu.joseph@intel.com>
Cc: hdegoede@redhat.com, markgross@kernel.org, tglx@linutronix.de,
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
	x86@kernel.org, hpa@zytor.com, corbet@lwn.net,
	andriy.shevchenko@linux.intel.com, ashok.raj@intel.com,
	tony.luck@intel.com, rostedt@goodmis.org, dan.j.williams@intel.com,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	platform-driver-x86@vger.kernel.org, patches@lists.linux.dev,
	ravi.v.shankar@intel.com
Subject: Re: [PATCH v2 09/10] platform/x86/intel/ifs: add ABI documentation
 for IFS
Message-ID: <Yk/B0D1wQXlQ2MqF@kroah.com>
References: <20220407191347.9681-1-jithu.joseph@intel.com>
 <20220407191347.9681-10-jithu.joseph@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220407191347.9681-10-jithu.joseph@intel.com>

On Thu, Apr 07, 2022 at 12:13:46PM -0700, Jithu Joseph wrote:
> Add the sysfs attributes in ABI/testing for In-Field Scan.
> 
> Reviewed-by: Tony Luck <tony.luck@intel.com>
> Signed-off-by: Jithu Joseph <jithu.joseph@intel.com>
> ---
>  .../ABI/testing/sysfs-platform-intel-ifs      | 54 +++++++++++++++++++
>  1 file changed, 54 insertions(+)
>  create mode 100644 Documentation/ABI/testing/sysfs-platform-intel-ifs
> 
> diff --git a/Documentation/ABI/testing/sysfs-platform-intel-ifs b/Documentation/ABI/testing/sysfs-platform-intel-ifs
> new file mode 100644
> index 000000000000..54dc6cd75484
> --- /dev/null
> +++ b/Documentation/ABI/testing/sysfs-platform-intel-ifs
> @@ -0,0 +1,54 @@
> +What:		/sys/devices/platform/intel_ifs/run_test
> +Date:		April 07, 2022
> +KernelVersion:	5.19.0

No need for ".0"

> +Contact:	"Jithu Joseph" <jithu.joseph@intel.com>
> +Description:	echo <cpu#> to trigger ifs test for all online cores.
> +		For e.g to test cpu5 do echo 5 > /sys/devices/platform/intel_ifs/run_test

So core numbers are different than cpu numbers here?  How are users
going to map them?

> +
> +What:		/sys/devices/platform/intel_ifs/status
> +Date:		April 07, 2022
> +KernelVersion:	5.19.0
> +Contact:	"Jithu Joseph" <jithu.joseph@intel.com>
> +Description:	The status of the last test. It can be one of "pass", "fail"
> +		or "untested".
> +
> +What:		/sys/devices/system/cpu/cpu#/ifs/details
> +Date:		April 07, 2022
> +KernelVersion:	5.19.0
> +Contact:	"Jithu Joseph" <jithu.joseph@intel.com>
> +Description:	Additional information regarding the last test. The details file reports
> +		the hex value of the SCAN_STATUS MSR. Note that the error_code field
> +		may contain driver defined software code not defined in the Intel SDM.
> +
> +What:		/sys/devices/platform/intel_ifs/image_version
> +Date:		April 07, 2022
> +KernelVersion:	5.19.0
> +Contact:	"Jithu Joseph" <jithu.joseph@intel.com>
> +Description:	Version of loaded IFS binary image.

In what format?

> +
> +What:		/sys/bus/platform/drivers/intel_ifs/bind
> +Date:		April 07, 2022
> +KernelVersion:	5.19.0
> +Contact:	"Jithu Joseph" <jithu.joseph@intel.com>
> +Description:	echo "intel_ifs" to reload IFS image.

Huh?  Why are you using a common sysfs file for this type of attribute?
Please do not do so, make it "reload" or something like that.

> +
> +What:		/sys/module/intel_ifs/parameters/noirq
> +Date:		April 07, 2022
> +KernelVersion:	5.19.0
> +Contact:	"Jithu Joseph" <jithu.joseph@intel.com>
> +Description:	IFS tunable parameter that user can modify before
> +		the scan run if they wish to override default value.

And where are those parameters documented?  What are valid values here?

> +		When set, system interrupts are not allowed to interrupt an IFS. The
> +		default state for this parameter is set.

set to what?

> +
> +What:		/sys/module/intel_ifs/parameters/retry
> +Date:		April 07, 2022
> +KernelVersion:	5.19.0
> +Contact:	"Jithu Joseph" <jithu.joseph@intel.com>
> +Description:	IFS tunable parameter that user can modify before scan run
> +		if they wish to override default value.
> +
> +		Maximum retry counter when the test is not executed due to an
> +		event such as interrupt. The default value is 5, it can be set to any
> +		value from 1 to 20.

Why would anyone ever want to change this value?  Why doesn't it "just
work" without needing anything tuned?

thanks,

greg k-h
