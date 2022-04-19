Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58E551374
	for <patches@lists.linux.dev>; Tue, 19 Apr 2022 17:35:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650389720; x=1681925720;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=triG9sStW3mhLDVpzsgT7KUGak7lE+Nmr/MDoWwbIcY=;
  b=MLGjNJopeXoweog+N+fvvvv72X5HSgzvns7eGpe1EW2+C3G+fK3rxkW2
   Wx+rRvnNYjLtlFRsaSJGyf9vR9uYSWjmwKSf5JBUHu7BnOK6COupN8Caq
   y3Q9ccPuRe/WhcKfw2JnMIiJnS72U6fAP4SeJriW3ZO4ZqFRm/xNObF/a
   N+AAct2VX+OyxoXhpqJNBLeTDnRIq1uXAq9RbAbVHx4bcxetklSzUwmnx
   tr1FQ7bNQkr2+qED0aHn9WAjZu5hb34fsB+F80MJQ2s8J8i2eiwHLsPQR
   kwW1r9m6OWjQs9qC6KxdY9nciHUSR+qpGYwliBA9ApSNId5rUuR3GdMD3
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10322"; a="243757627"
X-IronPort-AV: E=Sophos;i="5.90,273,1643702400"; 
   d="scan'208";a="243757627"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Apr 2022 10:35:19 -0700
X-IronPort-AV: E=Sophos;i="5.90,273,1643702400"; 
   d="scan'208";a="530532553"
Received: from agluck-desk3.sc.intel.com ([172.25.222.78])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Apr 2022 10:35:18 -0700
Date: Tue, 19 Apr 2022 10:35:17 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: hdegoede@redhat.com, markgross@kernel.org, tglx@linutronix.de,
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
	x86@kernel.org, hpa@zytor.com, corbet@lwn.net,
	andriy.shevchenko@linux.intel.com, jithu.joseph@intel.com,
	ashok.raj@intel.com, rostedt@goodmis.org, dan.j.williams@intel.com,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	platform-driver-x86@vger.kernel.org, patches@lists.linux.dev,
	ravi.v.shankar@intel.com
Subject: Re: [PATCH v3 09/11] platform/x86/intel/ifs: Add IFS sysfs interface
Message-ID: <Yl7y1YDaNVxyDnKI@agluck-desk3.sc.intel.com>
References: <20220407191347.9681-1-jithu.joseph@intel.com>
 <20220419163859.2228874-1-tony.luck@intel.com>
 <20220419163859.2228874-10-tony.luck@intel.com>
 <Yl7vdpJgKYRL1jeW@kroah.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yl7vdpJgKYRL1jeW@kroah.com>

On Tue, Apr 19, 2022 at 07:20:54PM +0200, Greg KH wrote:
> > +/*
> > + * Note there is no need for a ->remove() call back. There isn't an
> > + * "unload" operation to remove the scan binary from the BIOS reserved
> > + * area. Also ".dev_groups" removal order will guarantee that any in
> > + * flight tests have completed.
> > + */
> 
> So you are ok with the warning the kernel gives you when you unload the
> driver?  That feels wrong :(

What warning?

# dmesg | tail -5
[   38.084165] virbr0: port 1(virbr0-nic) entered listening state
[   38.149621] virbr0: port 1(virbr0-nic) entered disabled state
[   38.582054] broken atomic modeset userspace detected, disabling atomic
[   43.703321] igc 0000:01:00.0 enp1s0: NIC Link is Up 2500 Mbps Full Duplex, Flow Control: RX
[   43.703470] IPv6: ADDRCONF(NETDEV_CHANGE): enp1s0: link becomes ready
# modprobe intel_ifs
# ls /sys/devices/platform/intel_ifs.0/
details  driver_override  modalias  reload    status     uevent
driver   image_version    power     run_test  subsystem
# rmmod intel_ifs
# dmesg | tail -5
[   38.084165] virbr0: port 1(virbr0-nic) entered listening state
[   38.149621] virbr0: port 1(virbr0-nic) entered disabled state
[   38.582054] broken atomic modeset userspace detected, disabling atomic
[   43.703321] igc 0000:01:00.0 enp1s0: NIC Link is Up 2500 Mbps Full Duplex, Flow Control: RX
[   43.703470] IPv6: ADDRCONF(NETDEV_CHANGE): enp1s0: link becomes ready
#

-Tony
