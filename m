Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26BD61374
	for <patches@lists.linux.dev>; Tue, 19 Apr 2022 17:58:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E7BBC385A7;
	Tue, 19 Apr 2022 17:58:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1650391092;
	bh=PyCi/R7D11Eq63jFFcn8CrOSrYW4Icv3Cc8hVK/o9Nw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mkouKYH10qpYpR37xgoj92ARtNZD204xnwd2vl2YgbfFPPI2rRPHy3U8U6TdS7wFW
	 zKavvgXs//b6usNiMjzM7jfz9e8R8Gnx5YK7VDFzV66bdph6zE01KZ0EBhBFoPYBuR
	 7KolZj5YnEHqDRmP1UG1keyJ/ZO3JKbs8/Cw7k+I=
Date: Tue, 19 Apr 2022 19:58:09 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: hdegoede@redhat.com, markgross@kernel.org, tglx@linutronix.de,
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
	x86@kernel.org, hpa@zytor.com, corbet@lwn.net,
	andriy.shevchenko@linux.intel.com, jithu.joseph@intel.com,
	ashok.raj@intel.com, rostedt@goodmis.org, dan.j.williams@intel.com,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	platform-driver-x86@vger.kernel.org, patches@lists.linux.dev,
	ravi.v.shankar@intel.com
Subject: Re: [PATCH v3 09/11] platform/x86/intel/ifs: Add IFS sysfs interface
Message-ID: <Yl74MYW1+NgH4tOX@kroah.com>
References: <20220407191347.9681-1-jithu.joseph@intel.com>
 <20220419163859.2228874-1-tony.luck@intel.com>
 <20220419163859.2228874-10-tony.luck@intel.com>
 <Yl7vdpJgKYRL1jeW@kroah.com>
 <Yl7y1YDaNVxyDnKI@agluck-desk3.sc.intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yl7y1YDaNVxyDnKI@agluck-desk3.sc.intel.com>

On Tue, Apr 19, 2022 at 10:35:17AM -0700, Luck, Tony wrote:
> On Tue, Apr 19, 2022 at 07:20:54PM +0200, Greg KH wrote:
> > > +/*
> > > + * Note there is no need for a ->remove() call back. There isn't an
> > > + * "unload" operation to remove the scan binary from the BIOS reserved
> > > + * area. Also ".dev_groups" removal order will guarantee that any in
> > > + * flight tests have completed.
> > > + */
> > 
> > So you are ok with the warning the kernel gives you when you unload the
> > driver?  That feels wrong :(
> 
> What warning?
> 
> # dmesg | tail -5
> [   38.084165] virbr0: port 1(virbr0-nic) entered listening state
> [   38.149621] virbr0: port 1(virbr0-nic) entered disabled state
> [   38.582054] broken atomic modeset userspace detected, disabling atomic
> [   43.703321] igc 0000:01:00.0 enp1s0: NIC Link is Up 2500 Mbps Full Duplex, Flow Control: RX
> [   43.703470] IPv6: ADDRCONF(NETDEV_CHANGE): enp1s0: link becomes ready
> # modprobe intel_ifs
> # ls /sys/devices/platform/intel_ifs.0/
> details  driver_override  modalias  reload    status     uevent
> driver   image_version    power     run_test  subsystem
> # rmmod intel_ifs
> # dmesg | tail -5
> [   38.084165] virbr0: port 1(virbr0-nic) entered listening state
> [   38.149621] virbr0: port 1(virbr0-nic) entered disabled state
> [   38.582054] broken atomic modeset userspace detected, disabling atomic
> [   43.703321] igc 0000:01:00.0 enp1s0: NIC Link is Up 2500 Mbps Full Duplex, Flow Control: RX
> [   43.703470] IPv6: ADDRCONF(NETDEV_CHANGE): enp1s0: link becomes ready
> #

If there's no warning when the device goes away, why the crazy comment
trying to justify the lack of a remove callback?

confused,

greg k-h
