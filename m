Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9997F2C9D
	for <patches@lists.linux.dev>; Mon, 31 Jan 2022 11:35:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE55DC340E8;
	Mon, 31 Jan 2022 11:35:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1643628913;
	bh=Ow54je8UTcAKdwrgrjjuTJRzwEPu54U100XeZaWxyZk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=g0KU3zS3XilzLyYarOVzBTqNf55opYsUgbivSHd4Pao4sqX9QbHKzmpUUWWCODjYA
	 5URzCkyPUXhcIyQmE8quN9IkroZeBL/3pIxp0+tqquK07ZqlR7Y7S99DlufRXf0NJl
	 PRGGZEesj2ztAwcdoDDk35r7KCoORi8waKhm0tgc=
Date: Mon, 31 Jan 2022 12:35:10 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Tony Luck <tony.luck@intel.com>
Cc: Borislav Petkov <bp@alien8.de>, x86@kernel.org,
	linux-kernel@vger.kernel.org,
	Smita Koralahalli Channabasappa <smita.koralahallichannabasappa@amd.com>,
	Wei Huang <wei.huang2@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>, patches@lists.linux.dev
Subject: Re: [PATCH v2 6/6] topology/sysfs: Add PPIN in sysfs under cpu
 topology
Message-ID: <YffJbnO5uyYptFAd@kroah.com>
References: <20220107225442.1690165-1-tony.luck@intel.com>
 <20220121174743.1875294-1-tony.luck@intel.com>
 <20220121174743.1875294-7-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220121174743.1875294-7-tony.luck@intel.com>

On Fri, Jan 21, 2022 at 09:47:43AM -0800, Tony Luck wrote:
> PPIN is the Protected Processor Identification Number.
> This is used to identify the socket as a Field Replaceable Unit (FRU).
> 
> Existing code only displays this when reporting errors. But this makes
> it inconvenient for large clusters to use it for its intended purpose
> of inventory control.
> 
> Add ppin to /sys/devices/system/cpu/cpu*/topology to make what
> is already available using RDMSR more easily accessible. Make
> the file read only for root in case there are still people
> concerned about making a unique system "serial number" available.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  Documentation/ABI/stable/sysfs-devices-system-cpu  | 4 ++++
>  Documentation/ABI/testing/sysfs-devices-system-cpu | 6 ++++++
>  arch/x86/include/asm/topology.h                    | 1 +
>  drivers/base/topology.c                            | 4 ++++
>  include/linux/topology.h                           | 3 +++
>  5 files changed, 18 insertions(+)

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
