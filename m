Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 038102562
	for <patches@lists.linux.dev>; Mon, 25 Apr 2022 14:52:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD35CC385A4;
	Mon, 25 Apr 2022 14:52:52 +0000 (UTC)
Date: Mon, 25 Apr 2022 10:52:51 -0400
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
Subject: Re: [PATCH v4 09/10] trace: platform/x86/intel/ifs: Add trace point
 to track Intel IFS operations
Message-ID: <20220425105251.3f5e8021@gandalf.local.home>
In-Reply-To: <20220422200219.2843823-10-tony.luck@intel.com>
References: <20220419163859.2228874-1-tony.luck@intel.com>
	<20220422200219.2843823-1-tony.luck@intel.com>
	<20220422200219.2843823-10-tony.luck@intel.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 22 Apr 2022 13:02:18 -0700
Tony Luck <tony.luck@intel.com> wrote:

> Add tracing support which may be useful for debugging systems that fail t=
o complete
> In Field Scan tests.
>=20
> Reviewed-by: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  MAINTAINERS                              |  1 +
>  drivers/platform/x86/intel/ifs/runtest.c |  5 ++++
>  include/trace/events/intel_ifs.h         | 38 ++++++++++++++++++++++++

=46rom the tracing POV:

Acked-by: Steven Rostedt (Google) <rostedt@goodmis.org>

-- Steve
