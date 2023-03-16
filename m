Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 710C8AD28
	for <patches@lists.linux.dev>; Thu, 16 Mar 2023 20:26:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678998382; x=1710534382;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=N/UV/JGFwalfx0oPNUccNM6ZJrQ5XofHq51SxDHotNo=;
  b=VJV/8KRCs3wxroAv60gZcbBm6NbPNxoq3keHuo+MySnELWPuyDa4WOx6
   5KlSGAVp2HJxiJiWN6zip0fS+PD/hEfav/8aHj7WvTDlXSTXWLQelMKCM
   teJcqNPWpYi5eADDt2a9fmJEm5guA5pX0YlhpI2KBmEctDaVR9aYRvKU/
   AcrH0KzcdWb3bP+xdXCuonaU9QvxdNGVPKktxzflGwcpbkymH+fcPQIxF
   +lQAWM+nHQVFfrmayZlmh3XF446VI/WZugoM3uS2KVbtqp5aj5o64iJ8X
   g2i+BD2XQjLRAZ5F4Z54uIvJPxBlqDlvSV3w/4C65q9aPWrWMSMOWIfyb
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10651"; a="424376016"
X-IronPort-AV: E=Sophos;i="5.98,265,1673942400"; 
   d="scan'208";a="424376016"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2023 13:26:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10651"; a="803874716"
X-IronPort-AV: E=Sophos;i="5.98,265,1673942400"; 
   d="scan'208";a="803874716"
Received: from djiang5-mobl3.amr.corp.intel.com (HELO [10.213.182.83]) ([10.213.182.83])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2023 13:26:20 -0700
Message-ID: <b7a0b5c0-61a0-9843-09a6-3c4c606221be@intel.com>
Date: Thu, 16 Mar 2023 13:26:20 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.6.0
Subject: Re: [PATCH] ACPI: APEI: EINJ: Add CXL error types
Content-Language: en-US
To: Tony Luck <tony.luck@intel.com>,
 "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Cc: Borislav Petkov <bp@alien8.de>, x86@kernel.org,
 linux-acpi@vger.kernel.org, linux-cxl@vger.kernel.org,
 linux-kernel@vger.kernel.org, patches@lists.linux.dev
References: <20230314004611.48583-1-tony.luck@intel.com>
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20230314004611.48583-1-tony.luck@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 3/13/23 5:46 PM, Tony Luck wrote:
> ACPI 6.5 added six new error types for CXL. See chapter 18
> table 18.30.
> 
> Add strings for the new types so that Linux will list them in the
> /sys/kernel/debug/apei/einj/available_error_types file.
> 
> It seems no other changes are needed. Linux already accepts
> the CXL codes (on a BIOS that advertises them).
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>

> ---
>   drivers/acpi/apei/einj.c | 6 ++++++
>   1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/acpi/apei/einj.c b/drivers/acpi/apei/einj.c
> index b4373e575660..39bee5a067cc 100644
> --- a/drivers/acpi/apei/einj.c
> +++ b/drivers/acpi/apei/einj.c
> @@ -584,6 +584,12 @@ static const char * const einj_error_type_string[] = {
>   	"0x00000200\tPlatform Correctable\n",
>   	"0x00000400\tPlatform Uncorrectable non-fatal\n",
>   	"0x00000800\tPlatform Uncorrectable fatal\n",
> +	"0x00001000\tCXL.cache Protocol Correctable\n",
> +	"0x00002000\tCXL.cache Protocol Uncorrectable non-fatal\n",
> +	"0x00004000\tCXL.cache Protocol Uncorrectable fatal\n",
> +	"0x00008000\tCXL.mem Protocol Correctable\n",
> +	"0x00010000\tCXL.mem Protocol Uncorrectable non-fatal\n",
> +	"0x00020000\tCXL.mem Protocol Uncorrectable fatal\n",
>   };
>   
>   static int available_error_type_show(struct seq_file *m, void *v)
