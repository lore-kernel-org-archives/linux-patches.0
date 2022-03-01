Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B12957C
	for <patches@lists.linux.dev>; Tue,  1 Mar 2022 20:17:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69D77C340F1;
	Tue,  1 Mar 2022 20:17:46 +0000 (UTC)
Date: Tue, 1 Mar 2022 15:17:44 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Jithu Joseph <jithu.joseph@intel.com>
Cc: hdegoede@redhat.com, markgross@kernel.org, tglx@linutronix.de,
 mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
 x86@kernel.org, hpa@zytor.com, corbet@lwn.net, gregkh@linuxfoundation.org,
 andriy.shevchenko@linux.intel.com, ashok.raj@intel.com,
 tony.luck@intel.com, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, platform-driver-x86@vger.kernel.org,
 patches@lists.linux.dev, ravi.v.shankar@intel.com
Subject: Re: [RFC 10/10] trace: platform/x86/intel/ifs: Add trace point to
 track Intel IFS operations
Message-ID: <20220301151744.1ad5e11a@gandalf.local.home>
In-Reply-To: <20220301195457.21152-11-jithu.joseph@intel.com>
References: <20220301195457.21152-1-jithu.joseph@intel.com>
	<20220301195457.21152-11-jithu.joseph@intel.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue,  1 Mar 2022 11:54:57 -0800
Jithu Joseph <jithu.joseph@intel.com> wrote:

> +	TP_STRUCT__entry(
> +		__field(	u8,	start	)
> +		__field(	u8,	stop	)
> +		__field(	u64,	status	)
> +	),

I'd suggest swapping this to:

		__field(	u64,	status	)
		__field(	u8,	start	)
		__field(	u8,	stop	)

As trace events are usually aligned by 4 bytes (sometimes 8 for archs that
require 8byte alignment for 8 byte words), but any event, putting the
padding at the end of the event is better than in the middle of the event.

Having the u64 come after two u8 (two byes) will pretty much guarantee a 6
bytes hole in the middle of the event.

-- Steve
