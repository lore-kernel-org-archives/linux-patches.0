Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [78.32.30.218])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 562B427721
	for <patches@lists.linux.dev>; Tue, 14 Feb 2023 12:56:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=PtfppDuhmItMbeRFKmWWvY7+fa5G0s4vx2Kkf6nxpmY=; b=yKdpKUYfPQlrROj6L4K4a67X37
	F66BMtigFk6a8nF8FnBv2w4AulKIJ5/Xx2792amfeb+lglzOvNCdgzIyd18Q6rULuny/URlVQXGog
	PLyboSdRAT4P9Zz/NIS2Cu1OH8Q8lvAE9nKFLBBvdyX/MQjFoyt1JmpKIQK80YqLYuFJ35zaUewl1
	VGS/+/Rl1Xr8L6jrrAzIZ3xy0aQmtOFRmnkN//IkvfWAbhLf6yGB36pqI5F7nVhSYrG8J5P3K+TBV
	RoM9agDmcD62YaoVd/TvJ4JXb2Ks3uepLFfKdt56tBmq8To5SjwqHVqNIVpYKvVxXjoMPDkW5uMyx
	Jqh6P5Pg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:35252)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <linux@armlinux.org.uk>)
	id 1pRure-0005Q4-JE; Tue, 14 Feb 2023 12:56:54 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1pRurb-0003vG-LV; Tue, 14 Feb 2023 12:56:51 +0000
Date: Tue, 14 Feb 2023 12:56:51 +0000
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <error27@gmail.com>,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.15 02/67] nvmem: core: fix cleanup after dev_set_name()
Message-ID: <Y+uFE/Q6bb6IhfDf@shell.armlinux.org.uk>
References: <20230213144732.336342050@linuxfoundation.org>
 <20230213144732.453228453@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230213144732.453228453@linuxfoundation.org>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>

On Mon, Feb 13, 2023 at 03:48:43PM +0100, Greg Kroah-Hartman wrote:

> -	if (rval) {
> -		ida_free(&nvmem_ida, nvmem->id);
> -		kfree(nvmem);
> -		return ERR_PTR(rval);
> -	}
> +	if (rval)
> +		goto err_put_device;

I can't work out what you've done here - the hunk seems to suggest
that you've cherry picked 5544e90c8126 ("nvmem: core: add error handling
for dev_set_name") but I can see no evidence of that in my mailbox.
This makes it hard to recreate your 5.15 tree to be able to provide
you an updated patch for the one that failed.

Please provide a list of patches that you have queued for nvmem
from your linux-5.15.y branch.

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
