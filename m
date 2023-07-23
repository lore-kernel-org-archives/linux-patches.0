Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A94397F;
	Sun, 23 Jul 2023 11:08:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90142C433C8;
	Sun, 23 Jul 2023 11:08:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690110512;
	bh=MY3+XIRfy4ch9ILW/sZpzfS0/HM9qWO4gOnXMp7ifi8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bTHjlHq/Y5vDLrX1gTya8fksxEE2o2E5CNmHtzErjFJRm2b7phRNejTnvrtYCLUHW
	 XGfVyPa7v+9AjDAF+UC/qSQapKFSwuCuTCE+hy2q/07TlcPZy7NqiqKJRHHVfbQLva
	 A319u/06KQ0aaNEUSFb5GATtHH+NQR+e71Pxr47Q=
Date: Sun, 23 Jul 2023 13:08:29 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Linux regressions mailing list <regressions@lists.linux.dev>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Igor Mammedov <imammedo@redhat.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	"Rafael J. Wysocki" <rafael@kernel.org>
Subject: Re: [PATCH 6.4 172/292] PCI: acpiphp: Reassign resources on bridge
 if necessary
Message-ID: <2023072315-lubricate-given-0afa@gregkh>
References: <20230721160528.800311148@linuxfoundation.org>
 <20230721160536.293573004@linuxfoundation.org>
 <9b5838ea-91ef-a758-2d32-481ee3b4345e@leemhuis.info>
 <67104736-e96f-559d-350d-0d1845d39a5a@leemhuis.info>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <67104736-e96f-559d-350d-0d1845d39a5a@leemhuis.info>

On Sun, Jul 23, 2023 at 11:25:29AM +0200, Linux regression tracking (Thorsten Leemhuis) wrote:
> On 23.07.23 11:17, Thorsten Leemhuis wrote:
> > On 21.07.23 18:04, Greg Kroah-Hartman wrote:
> >> From: Igor Mammedov <imammedo@redhat.com>
> >>
> >> commit 40613da52b13fb21c5566f10b287e0ca8c12c4e9 upstream.
> >>
> >> When using ACPI PCI hotplug, hotplugging a device with large BARs may fail
> >> if bridge windows programmed by firmware are not large enough.
> >>
> >> [...]
> > 
> > Greg, just so you know, that patch (which is also queued for 6.1 and
> > 5.15) is known to cause a regression in 6.5-rc. To quote
> > https://lore.kernel.org/all/11fc981c-af49-ce64-6b43-3e282728bd1a@gmail.com/
> > 
> > ```
> > Laptop shows a kernel crash trace after a first suspend to ram, on a
> > second attempt to suspend it becomes frozen solid. This is 100%
> > repeatable with a 6.5-rc2 kernel, not happening with a 6.4 kernel - see
> > the attached dmesg output.
> > 
> > I have bisected the kernel uilds and it points to :
> > [40613da52b13fb21c5566f10b287e0ca8c12c4e9] PCI: acpiphp: Reassign
> > resources on bridge if necessary
> > 
> > Reversing this patch seems to fix the kernel crash problem on my laptop.
> > ```
> 
> Forgot to mention the reply from Bjorn:
> 
> ```
> I queued up a revert of 40613da52b13 ("PCI: acpiphp: Reassign
> resources on bridge if necessary") (on my for-linus branch for v6.5).
> 
> It looks like a NULL pointer dereference; hopefully the fix is obvious
> and I can drop the revert and replace it with the fix.
> ```

Thanks, I've dropped this from the stable queues now.

greg k-h
