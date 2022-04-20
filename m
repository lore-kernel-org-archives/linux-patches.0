Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EC9A1FA9
	for <patches@lists.linux.dev>; Wed, 20 Apr 2022 23:38:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CCADC385A1;
	Wed, 20 Apr 2022 23:38:41 +0000 (UTC)
Date: Wed, 20 Apr 2022 19:38:39 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Tony Luck <tony.luck@intel.com>
Cc: hdegoede@redhat.com, markgross@kernel.org, tglx@linutronix.de,
 mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
 x86@kernel.org, hpa@zytor.com, corbet@lwn.net, gregkh@linuxfoundation.org,
 andriy.shevchenko@linux.intel.com, jithu.joseph@intel.com,
 ashok.raj@intel.com, dan.j.williams@intel.com,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 platform-driver-x86@vger.kernel.org, patches@lists.linux.dev,
 ravi.v.shankar@intel.com
Subject: Re: [PATCH v3 10/11] trace: platform/x86/intel/ifs: Add trace point
 to track Intel IFS operations
Message-ID: <20220420193839.6e9d810b@gandalf.local.home>
In-Reply-To: <20220419163859.2228874-11-tony.luck@intel.com>
References: <20220407191347.9681-1-jithu.joseph@intel.com>
	<20220419163859.2228874-1-tony.luck@intel.com>
	<20220419163859.2228874-11-tony.luck@intel.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 19 Apr 2022 09:38:58 -0700
Tony Luck <tony.luck@intel.com> wrote:

> +TRACE_EVENT(ifs_status,
> +
> +	TP_PROTO(union ifs_scan activate, union ifs_status status),

Really, you want to pass the structure in by value, so that we have two
copies? One to get to this function and then one to write to the ring
buffer?

-- Steve


> +
> +	TP_ARGS(activate, status),
> +
> +	TP_STRUCT__entry(
> +		__field(	u64,	status	)
> +		__field(	u8,	start	)
> +		__field(	u8,	stop	)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->start	= activate.start;
> +		__entry->stop	= activate.stop;
> +		__entry->status	= status.data;
> +	),
> +
> +	TP_printk("start: %.2x, stop: %.2x, status: %llx",
> +		__entry->start,
> +		__entry->stop,
> +		__entry->status)
> +);
> +
> +#endif /* _TRACE_IFS_H */
