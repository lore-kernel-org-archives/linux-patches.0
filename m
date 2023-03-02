Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D09CD524
	for <patches@lists.linux.dev>; Thu,  2 Mar 2023 22:17:58 +0000 (UTC)
Received: by mail-qt1-f173.google.com with SMTP id d7so919721qtr.12
        for <patches@lists.linux.dev>; Thu, 02 Mar 2023 14:17:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677795477;
        h=in-reply-to:content-disposition:mime-version:references:reply-to
         :message-id:subject:cc:to:from:date:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=V0eFa8ILkm7saCjWoXNnQHqm1RHUvtu7xtFURhRmKWU=;
        b=GWIdVRbSbgGAneugFpQgdh5lGR+K1O2RColDxiylPsGvgbxgTi3suTXXA6wFi8OCK0
         VNr55Ah0Gc82W4FpWSTsMpjDZ1Erp/WmIRnZDS0YpniCm5SeKBzDA3FCJ8OcngRfT3am
         LJR4Wv1lndNYH/Q/fwVcsuZerou4gr/yo1YSLP0kQcvMrmf2NmdjcDnwIAjLduXqmPNe
         VlNJuhUG6Jamo98Ukf3GRQnXMF/KhWX9aS1xIH9/YtXknnp6o/3S59Xtp1bxusSnAubi
         fOjhj1lJxSPeHuAjqExElFjdtMpPl+2YjDqfLqGQB/n6i2Ayg1FV3OBABQqVd1q1TZM5
         StNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677795477;
        h=in-reply-to:content-disposition:mime-version:references:reply-to
         :message-id:subject:cc:to:from:date:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=V0eFa8ILkm7saCjWoXNnQHqm1RHUvtu7xtFURhRmKWU=;
        b=dfYEBEdOHB0hjtIBYVxk9zWvu8i0+ZtO+YybLYHAxYw7WtiVfSC7Bst6NA53wuO/LB
         F4doQnT50AvKaJq+kQ2rQcWYKOtI51CdvRqtWcofhSKaY6IudFjuX2MlasGh6UxiOdyQ
         mk+sc1+Mm0SJDkvOO7AvALiPKgtI8uxk2EC8LSsN1rDEKSD/moEM8afzDAEEsXPpbTfh
         yPlqpNpRo8gFwx6OE2B2JloIipw7ZWaPCppkeHDqr7/uUCfBFd4WSA+kcYK3HzTJo9HR
         ROrv5Q1yrVo/88CBxP+HsBRPg4PYq67OtVSPySt+jjisGuR8tGshNtJnuz3oSHCLMooK
         lFww==
X-Gm-Message-State: AO0yUKUW2sptWF+2B5TkLvA+gpY9QIPoxcdUz3nJ60b9OE16Ws6uBhF5
	DnoEA58r/rJ32LNmtYOgEw==
X-Google-Smtp-Source: AK7set/y+bOjExP+nvbPQ/5QcDoAS99DJhG2vCN39iU8gau82df1z2MZqb9gk8YkNPi+sskmliPrlQ==
X-Received: by 2002:ac8:5f47:0:b0:3bf:dd45:ed68 with SMTP id y7-20020ac85f47000000b003bfdd45ed68mr19008132qta.47.1677795476934;
        Thu, 02 Mar 2023 14:17:56 -0800 (PST)
Received: from serve.minyard.net ([47.184.176.248])
        by smtp.gmail.com with ESMTPSA id w19-20020ac843d3000000b003bfbf3afe51sm468742qtn.93.2023.03.02.14.17.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Mar 2023 14:17:56 -0800 (PST)
Sender: Corey Minyard <tcminyard@gmail.com>
Received: from minyard.net (unknown [IPv6:2001:470:b8f6:1b:9812:99fe:c8aa:e89a])
	by serve.minyard.net (Postfix) with ESMTPSA id 2843A18000C;
	Thu,  2 Mar 2023 22:17:55 +0000 (UTC)
Date: Thu, 2 Mar 2023 16:17:53 -0600
From: Corey Minyard <minyard@acm.org>
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: ebiederm@xmission.com, keescook@chromium.org, yzaikin@google.com,
	jejb@linux.ibm.com, martin.petersen@oracle.com, kys@microsoft.com,
	haiyangz@microsoft.com, wei.liu@kernel.org, decui@microsoft.com,
	song@kernel.org, robinmholt@gmail.com, steve.wahl@hpe.com,
	mike.travis@hpe.com, arnd@arndb.de, gregkh@linuxfoundation.org,
	jirislaby@kernel.org, jgross@suse.com, sstabellini@kernel.org,
	oleksandr_tyshchenko@epam.com, xen-devel@lists.xenproject.org,
	j.granados@samsung.com, zhangpeng362@huawei.com,
	tangmeng@uniontech.com, willy@infradead.org, nixiaoming@huawei.com,
	sujiaxun@uniontech.com, patches@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, apparmor@lists.ubuntu.com,
	linux-raid@vger.kernel.org, linux-scsi@vger.kernel.org,
	linux-hyperv@vger.kernel.org,
	openipmi-developer@lists.sourceforge.net,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/7] ipmi: simplify sysctl registration
Message-ID: <ZAEgkeb6E+k8PFZc@minyard.net>
Reply-To: minyard@acm.org
References: <20230302204612.782387-1-mcgrof@kernel.org>
 <20230302204612.782387-3-mcgrof@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230302204612.782387-3-mcgrof@kernel.org>

On Thu, Mar 02, 2023 at 12:46:07PM -0800, Luis Chamberlain wrote:
> register_sysctl_table() is a deprecated compatibility wrapper.
> register_sysctl() can do the directory creation for you so just use
> that.

Thanks, I have included this in my tree for the next merge window.

-corey

> 
> Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
> ---
>  drivers/char/ipmi/ipmi_poweroff.c | 16 +---------------
>  1 file changed, 1 insertion(+), 15 deletions(-)
> 
> diff --git a/drivers/char/ipmi/ipmi_poweroff.c b/drivers/char/ipmi/ipmi_poweroff.c
> index 163ec9749e55..870659d91db2 100644
> --- a/drivers/char/ipmi/ipmi_poweroff.c
> +++ b/drivers/char/ipmi/ipmi_poweroff.c
> @@ -659,20 +659,6 @@ static struct ctl_table ipmi_table[] = {
>  	{ }
>  };
>  
> -static struct ctl_table ipmi_dir_table[] = {
> -	{ .procname	= "ipmi",
> -	  .mode		= 0555,
> -	  .child	= ipmi_table },
> -	{ }
> -};
> -
> -static struct ctl_table ipmi_root_table[] = {
> -	{ .procname	= "dev",
> -	  .mode		= 0555,
> -	  .child	= ipmi_dir_table },
> -	{ }
> -};
> -
>  static struct ctl_table_header *ipmi_table_header;
>  #endif /* CONFIG_PROC_FS */
>  
> @@ -689,7 +675,7 @@ static int __init ipmi_poweroff_init(void)
>  		pr_info("Power cycle is enabled\n");
>  
>  #ifdef CONFIG_PROC_FS
> -	ipmi_table_header = register_sysctl_table(ipmi_root_table);
> +	ipmi_table_header = register_sysctl("dev/ipmi", ipmi_table);
>  	if (!ipmi_table_header) {
>  		pr_err("Unable to register powercycle sysctl\n");
>  		rv = -ENOMEM;
> -- 
> 2.39.1
> 
