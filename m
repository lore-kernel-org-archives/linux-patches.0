Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3247366
	for <patches@lists.linux.dev>; Wed, 30 Mar 2022 01:51:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E26FC340ED;
	Wed, 30 Mar 2022 01:51:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1648605078;
	bh=uPVPTPqQ+zjGcNlvIVQgAcOHL8ZFkPOnSUmQa1IAbc8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=euEDuvVmQ+NysAcpunoPlA4u5Lj99bpDC2rHg8SeBEttV29jpVA7yNy0GcIDBFYrZ
	 WPUewfyVqc521SS1ubdvvYF6d292X/cncpMCzQKYS4fygPZ4suk093Du92+EXUd0Nm
	 uez0iwNY0sP15O5QAMd2wpTFQ63vRB7IgChDUukBooxWVFnX1A3hY+nbXrinzNZ3UM
	 +s+uzxUsbX7MJYzaiMBmDJ4WuNKEUffMtmRuZBKsMq8nXxou8CKV/T04cuZxBGg0MX
	 XPuL+jSu0nguYK6hrTyO+Rfo/4ZsgTQY9Sr5yBRTfF2LSOysU5JD1ZqhVRkCoDf60a
	 BvsXfn2ECcK0w==
Date: Tue, 29 Mar 2022 18:51:16 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: netdev@vger.kernel.org, patches@lists.linux.dev, kernel test robot
 <lkp@intel.com>, Horatiu Vultur <horatiu.vultur@microchip.com>, Lars
 Povlsen <lars.povlsen@microchip.com>, Steen Hegelund
 <Steen.Hegelund@microchip.com>, UNGLinuxDriver@microchip.com, "David S.
 Miller" <davem@davemloft.net>, Paolo Abeni <pabeni@redhat.com>,
 bjarni.jonasson@microchip.com, p.zabel@pengutronix.de
Subject: Re: [PATCH] net: sparx5: uses, depends on BRIDGE or !BRIDGE
Message-ID: <20220329185116.24c44f2f@kernel.org>
In-Reply-To: <20220330012025.29560-1-rdunlap@infradead.org>
References: <20220330012025.29560-1-rdunlap@infradead.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 29 Mar 2022 18:20:25 -0700 Randy Dunlap wrote:
> Fix build errors when BRIDGE=m and SPARX5_SWITCH=y:
> 
> riscv64-linux-ld: drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.o: in function `.L305':
> sparx5_switchdev.c:(.text+0xdb0): undefined reference to `br_vlan_enabled'
> riscv64-linux-ld: drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.o: in function `.L283':
> sparx5_switchdev.c:(.text+0xee0): undefined reference to `br_vlan_enabled'
> 
> Fixes: 3cfa11bac9bb ("net: sparx5: add the basic sparx5 driver")
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Reported-by: kernel test robot <lkp@intel.com>
> Cc: Horatiu Vultur <horatiu.vultur@microchip.com>
> Cc: Lars Povlsen <lars.povlsen@microchip.com>
> Cc: Steen Hegelund <Steen.Hegelund@microchip.com>
> Cc: UNGLinuxDriver@microchip.com
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Paolo Abeni <pabeni@redhat.com>

Gotta CC all the authors of the change under Fixes, please.
Adding them now.

> --- linux-next-20220329.orig/drivers/net/ethernet/microchip/sparx5/Kconfig
> +++ linux-next-20220329/drivers/net/ethernet/microchip/sparx5/Kconfig
> @@ -5,6 +5,7 @@ config SPARX5_SWITCH
>  	depends on OF
>  	depends on ARCH_SPARX5 || COMPILE_TEST
>  	depends on PTP_1588_CLOCK_OPTIONAL
> +	depends on BRIDGE || BRIDGE=n
>  	select PHYLINK
>  	select PHY_SPARX5_SERDES
>  	select RESET_CONTROLLER

