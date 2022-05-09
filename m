Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 427041865
	for <patches@lists.linux.dev>; Mon,  9 May 2022 12:16:26 +0000 (UTC)
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1652098584;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qJHxy69CHJC0fW0RUic58UUaRLbHK6HeLX4XWrP5DrY=;
	b=pgzvbJOQH8lej+TkKOsMSFhJRMJMColPNkYzFZVBBlpf/46dIROYO5vORg8k2Vf0rtSl15
	yL21hz9LihhpHVhcQNphshrsealyrBUoDu1O7vgwgxK2ZO+heHUCuDNQkbK8lwbUsYVJrV
	qqXkQ2xjnw+2c+CM6LMfuekiUILP6Esh45CmKwL6Le+ajHzF3vWukaITypPKTSv83oUvKj
	CDeTrXxADtlbITbhv7GnQ+PO8+g/5xqNcPoM3CZWX+9QdUaYPcdx1TiUKEFyY55BQwXcI/
	noTVMEUWz2Z3maEOy8hcYHAL9e7d+JtH59Ii2eINADAPcsx/eXO6C5fEzTodeg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1652098584;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qJHxy69CHJC0fW0RUic58UUaRLbHK6HeLX4XWrP5DrY=;
	b=wNbjnljwg8nS7pLu+J1h+4gw/qT50N9VyINHaSbRy43iV2OtX9W+UKOUwZW6rx0dyuRNcY
	JCj5N7vE0W7rdCAQ==
To: Tony Luck <tony.luck@intel.com>, hdegoede@redhat.com, markgross@kernel.org
Cc: mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
 x86@kernel.org, hpa@zytor.com, corbet@lwn.net, gregkh@linuxfoundation.org,
 andriy.shevchenko@linux.intel.com, jithu.joseph@intel.com,
 ashok.raj@intel.com, tony.luck@intel.com, rostedt@goodmis.org,
 dan.j.williams@intel.com, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, platform-driver-x86@vger.kernel.org,
 patches@lists.linux.dev, ravi.v.shankar@intel.com
Subject: Re: [PATCH v7 12/12] Documentation: In-Field Scan
In-Reply-To: <20220506225410.1652287-13-tony.luck@intel.com>
References: <20220506014035.1173578-1-tony.luck@intel.com>
 <20220506225410.1652287-1-tony.luck@intel.com>
 <20220506225410.1652287-13-tony.luck@intel.com>
Date: Mon, 09 May 2022 14:16:23 +0200
Message-ID: <87pmkmrje0.ffs@tglx>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

On Fri, May 06 2022 at 15:54, Tony Luck wrote:
> Add documentation for In-Field Scan (IFS). This documentation
> describes the basics of IFS, the loading IFS image, chunk
> authentication, running scan and how to check result via sysfs.
>
> The CORE_CAPABILITIES MSR enumerates whether IFS is supported.
>
> The full  github location for distributing the IFS images is
> still being decided. So just a placeholder included for now
> in the documentation.
>
> Future CPUs will support more than one type of test. Plan for
> that now by using a "_0" suffix on the ABI directory names.
> Additional test types will use "_1", etc.
>
> Reviewed-by: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Tony Luck <tony.luck@intel.com>

Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
