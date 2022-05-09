Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 215661865
	for <patches@lists.linux.dev>; Mon,  9 May 2022 12:11:58 +0000 (UTC)
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1652098315;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fdMlXl/5cbOn67j58YZZq3Iq75451DHzugIa12n6YdQ=;
	b=uw8lq4AsfqLcbN4Dvu2spbaWFtpItEctuzNfDt1KLAXwEV+7SEEKdAxcy6LqH9DsYWZ7qR
	vWhkZp+n3rYuXxlKOvBwmb6FJT5KM010IFdFurHrTHaWtN17SRf8DAZ16CMjh4D6teTvKV
	Uz66TJlF0vViY4BIyUCTWfOX2Rv7d3HtIRZJZsIqche3E1aG94M4PEEa8UfD2lX08dMqmn
	kjnf4R4SHeZ+DzPUnKh2kMdxCo/rGV1vhDqtnvhdae30v/0IcAXhhEnUwkpSe3O3YG5RXN
	+jbR6ZOYkQv2IiUzhLYUmQAJDy/1wbz7uNwdoZEnDBiLd5URRJHaEzCLf26CjA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1652098315;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fdMlXl/5cbOn67j58YZZq3Iq75451DHzugIa12n6YdQ=;
	b=WLJ4qQc0Pa4ernlDQdXt7u481TctoUyjRBzb8N1ON36rdqEHvGO8EI2nCJDOqwl1NJs8OL
	JMEO5k5QQKc/lxDA==
To: Tony Luck <tony.luck@intel.com>, hdegoede@redhat.com, markgross@kernel.org
Cc: mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
 x86@kernel.org, hpa@zytor.com, corbet@lwn.net, gregkh@linuxfoundation.org,
 andriy.shevchenko@linux.intel.com, jithu.joseph@intel.com,
 ashok.raj@intel.com, tony.luck@intel.com, rostedt@goodmis.org,
 dan.j.williams@intel.com, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, platform-driver-x86@vger.kernel.org,
 patches@lists.linux.dev, ravi.v.shankar@intel.com
Subject: Re: [PATCH v7 08/12] platform/x86/intel/ifs: Add scan test support
In-Reply-To: <20220506225410.1652287-9-tony.luck@intel.com>
References: <20220506014035.1173578-1-tony.luck@intel.com>
 <20220506225410.1652287-1-tony.luck@intel.com>
 <20220506225410.1652287-9-tony.luck@intel.com>
Date: Mon, 09 May 2022 14:11:55 +0200
Message-ID: <87wneurjlg.ffs@tglx>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

On Fri, May 06 2022 at 15:54, Tony Luck wrote:
> From: Jithu Joseph <jithu.joseph@intel.com>
>
> In a core, the scan engine is shared between sibling cpus.
>
> When a Scan test (for a particular core) is triggered by the user,
> the scan chunks are executed on all the threads on the core using
> stop_core_cpuslocked.
>
> Scan may be aborted by some reasons. Scan test will be aborted in certain
> circumstances such as when interrupt occurred or cpu does not have enough
> power budget for scan. In this case, the kernel restart scan from the chunk
> where it stopped. Scan will also be aborted when the test is failed. In
> this case, the test is immediately stopped without retry.
>
> Reviewed-by: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Jithu Joseph <jithu.joseph@intel.com>
> Co-developed-by: Tony Luck <tony.luck@intel.com>
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> Acked-by: Hans de Goede <hdegoede@redhat.com>
> Reviewed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
