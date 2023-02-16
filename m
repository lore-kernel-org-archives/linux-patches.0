Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 637947B
	for <patches@lists.linux.dev>; Thu, 16 Feb 2023 00:56:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A658C433EF;
	Thu, 16 Feb 2023 00:56:11 +0000 (UTC)
Date: Wed, 15 Feb 2023 19:56:09 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Jithu Joseph <jithu.joseph@intel.com>
Cc: hdegoede@redhat.com, markgross@kernel.org, tglx@linutronix.de,
 mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
 x86@kernel.org, hpa@zytor.com, gregkh@linuxfoundation.org,
 ashok.raj@intel.com, tony.luck@intel.com, linux-kernel@vger.kernel.org,
 platform-driver-x86@vger.kernel.org, patches@lists.linux.dev,
 ravi.v.shankar@intel.com, thiago.macieira@intel.com,
 athenas.jimenez.gonzalez@intel.com, sohil.mehta@intel.com
Subject: Re: [PATCH v2 5/7] platform/x86/intel/ifs: Trace support for array
 test
Message-ID: <20230215195609.288a5709@rorschach.local.home>
In-Reply-To: <20230214234426.344960-6-jithu.joseph@intel.com>
References: <20230131234302.3997223-1-jithu.joseph@intel.com>
	<20230214234426.344960-1-jithu.joseph@intel.com>
	<20230214234426.344960-6-jithu.joseph@intel.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 14 Feb 2023 15:44:24 -0800
Jithu Joseph <jithu.joseph@intel.com> wrote:

> Enable tracing support in array test flow.
>=20
> Signed-off-by: Jithu Joseph <jithu.joseph@intel.com>
> Reviewed-by: Tony Luck <tony.luck@intel.com>

=46rom the tracing POV:

Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>

-- Steve

> ---
>  include/trace/events/intel_ifs.h         | 25 ++++++++++++++++++++++++
>  drivers/platform/x86/intel/ifs/runtest.c |  1 +
>  2 files changed, 26 insertions(+)
>=20
> diff --git a/include/trace/events/intel_ifs.h b/include/trace/events/inte=
l_ifs.h
> index d7353024016c..d15037943b80 100644
> --- a/include/trace/events/intel_ifs.h
