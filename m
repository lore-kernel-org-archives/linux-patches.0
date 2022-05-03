Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7CFF3204
	for <patches@lists.linux.dev>; Tue,  3 May 2022 15:29:54 +0000 (UTC)
Received: from zn.tnic (p5de8eeb4.dip0.t-ipconnect.de [93.232.238.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id DD34D1EC01E0;
	Tue,  3 May 2022 17:29:47 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
	t=1651591787;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
	bh=OAZ8BBOMxTQtT+Y2LCxiEZ74Q/wI8Prs/+c/U9ygqlQ=;
	b=kOflgr9V+B/lhxJDjEXpqEJ26xqWXMcviI9WtoHBenBDjgyL6CaISHHLmijO5hT9Y5yo6S
	FRHD9nA6M9V9uonbkwNXstNrxKYYOkkbWtZCYV0xI7ZAqmyaMSeBeramQqOc3sDfDHBvxN
	4KUMGrxsPLvKHeWEIqvWs84xLjaVRLc=
Date: Tue, 3 May 2022 17:29:46 +0200
From: Borislav Petkov <bp@alien8.de>
To: Tony Luck <tony.luck@intel.com>
Cc: hdegoede@redhat.com, markgross@kernel.org, tglx@linutronix.de,
	mingo@redhat.com, dave.hansen@linux.intel.com, x86@kernel.org,
	hpa@zytor.com, corbet@lwn.net, gregkh@linuxfoundation.org,
	andriy.shevchenko@linux.intel.com, jithu.joseph@intel.com,
	ashok.raj@intel.com, rostedt@goodmis.org, dan.j.williams@intel.com,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	platform-driver-x86@vger.kernel.org, patches@lists.linux.dev,
	ravi.v.shankar@intel.com
Subject: Re: [PATCH v5 01/10] x86/microcode/intel: Expose
 collect_cpu_info_early() for IFS
Message-ID: <YnFKarR+8fxKwBvg@zn.tnic>
References: <20220422200219.2843823-1-tony.luck@intel.com>
 <20220428153849.295779-1-tony.luck@intel.com>
 <20220428153849.295779-2-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220428153849.295779-2-tony.luck@intel.com>

On Thu, Apr 28, 2022 at 08:38:40AM -0700, Tony Luck wrote:
> From: Jithu Joseph <jithu.joseph@intel.com>
> 
> IFS is a CPU feature that allows a binary blob, similar to microcode,
> to be loaded and consumed to perform low level validation of CPU
> circuitry. In fact, it carries the same Processor Signature
> (family/model/stepping) details that are contained in Intel microcode
> blobs.
> 
> In support of an IFS driver to trigger loading, validation, and running
> of these tests blobs, make the functionality of cpu_signatures_match()
> and collect_cpu_info_early() available outside of the microcode driver.
> 
> Add an "intel_" prefix and drop the "_early" suffix from
> collect_cpu_info_early() and EXPORT_SYMBOL_GPL() it. Add
> declaration to x86 <asm/cpu.h>
> 
> Make cpu_signatures_match() an inline function in x86 <asm/cpu.h>,
> and also give it an "intel_" prefix.
> 
> No functional change intended.
> 
> Reviewed-by: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Jithu Joseph <jithu.joseph@intel.com>
> Co-developed-by: Tony Luck <tony.luck@intel.com>
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  arch/x86/include/asm/cpu.h            | 18 ++++++++
>  arch/x86/kernel/cpu/intel.c           | 32 +++++++++++++++
>  arch/x86/kernel/cpu/microcode/intel.c | 59 ++++-----------------------
>  3 files changed, 57 insertions(+), 52 deletions(-)

Acked-by: Borislav Petkov <bp@suse.de>

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
