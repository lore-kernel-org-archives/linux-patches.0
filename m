Received: from fout-b3-smtp.messagingengine.com (fout-b3-smtp.messagingengine.com [202.12.124.146])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D37929C338
	for <patches@lists.linux.dev>; Wed, 17 Dec 2025 11:22:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.146
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765970578; cv=none; b=CroH9adEHJ9Wg6XLXAKAB7N2SRgvFhSGDHtD8YeA3wxuTNfEqhde+cGdiqtaqrAR2se46pMoumHwidaRqcUKaKq+RqX4nOAYf+OrUFxW0oJj/m3lXHUXa013dg9YvkKgRRTU7FlyBH9vgwmeWo6lNGlBF8GvmiinB5d14+y5O6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765970578; c=relaxed/simple;
	bh=CsqHCuWp6oaJbUFH9wnV4UAp/PLpXRw8TRnIxMSheqw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AyrcXKwaisZgbxTTCVghseX9gUOW8bw4wtFq4etQMVrgTy0S1npNvWaErw0wsA2nrHozs1WpY7BE+vKMJTnpqxC+Oo4WxKJnZEt/XWcNGQTuXJOIi5MBA3OoSUwJGCr+qUDb8XTpEiBzMeOC4Fb/HMJGy7A+WIYteVuUoqDECbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com; spf=pass smtp.mailfrom=pobox.com; dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b=Kq186RJq; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=RRbVC0qu; arc=none smtp.client-ip=202.12.124.146
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pobox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b="Kq186RJq";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="RRbVC0qu"
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfout.stl.internal (Postfix) with ESMTP id BA7DB1D000B0;
	Wed, 17 Dec 2025 06:22:53 -0500 (EST)
Received: from phl-frontend-02 ([10.202.2.161])
  by phl-compute-01.internal (MEProxy); Wed, 17 Dec 2025 06:22:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pobox.com; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1765970573;
	 x=1766056973; bh=ZdFcV9dDakGjGQhFz+ILP/Izrq7rPekzmvf73rU5D+o=; b=
	Kq186RJqzO3QcXS1Il1faKExdux9fOUeRuKVCL8Xb9Wzzm054OcjeUbCb3COpDbQ
	+D6iiEgf99fNItXRMF6xf2d00V3iyJoXe9UxkADQxW/m9evDiM7xWCepgiz5aZV/
	PN5GsCTGTPHw5x2x+2tEdn8Okj5ZP0NNdlV3H6KXHZxXAxZ1pGlT+/0+pf/xFFfa
	hCgHYwzuQJ0uT/VkVOvuGmiQTGeUi+zoWKI1MtZZybnF9Ah/GP8XeQ3GChT8pJs1
	Z/pUBew3IpDzsRg7Fl+Cih2T4estGPABJTxXitcdkP1O9KaC6SavWv28bwZKCaHj
	XLsxP3Lzy5s/dqr+c4mNvQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1765970573; x=
	1766056973; bh=ZdFcV9dDakGjGQhFz+ILP/Izrq7rPekzmvf73rU5D+o=; b=R
	RbVC0quIiLDD24J8EfZOUpzgOoOSepuLsOF/40WRPWjkUZjb7GtqDAB174BoSyBs
	uZVW19OpUOEpQO2R0huR/5FkJZChm8bbk9WMbjb71jDlicFB1uKGjN8m32k0RUFG
	rwV17GUMkaObk7okooA8kZG6jduYcZbwfH0GM/QWlbYYitTfdKqHfc16zCAs3lTV
	zUbjswPhkGQ/BhWeMc5ZQsX5O3aTyZTrft4HZDlmUUhkl2BbSW7Y3a+RRJcTQg9U
	zFF7j9Ke6H44q7MYtD23aXLFWLU9p9e8WfcWwuXXnLh152V5LFVFmFnreUjDueQn
	T2/0zdJ+t2vOHfhFS8GZw==
X-ME-Sender: <xms:jJJCaS865p84O_7wdebeVmbv8U0vjfza_muAlk61EVFWgdGV3vuKgg>
    <xme:jJJCacBvjjbUnyxTcFxZo3a6T9iVpo-vLr-BfYeQvAqI7ctX2WuauxiBAcwViZE1O
    wjJJFHa5JItmHCnkxizT48bnxPlIA6lPNyuESyoEAg9boZWtIDuKbg>
X-ME-Received: <xmr:jJJCafTjgR4KksdcsGfAryk8bKW9wx1UkM65R7fVeDzqi-Rf10Zoy9e2VO_PFyOWOsM3t-KbadF9BkDc-gbcSxl-n5B1Kw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdegvdegvdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpefkffggfgfuvfevfhfhjggtgfesthejredttddvjeenucfhrhhomhepfdeurghrrhih
    ucfmrdcupfgrthhhrghnfdcuoegsrghrrhihnhesphhosghogidrtghomheqnecuggftrf
    grthhtvghrnhephfeivddvveeutdfguefgleehffejudehieefleeiueefvddtleejgfei
    ieelveehnecuffhomhgrihhnpehlohhgrdhinhhfohenucevlhhushhtvghrufhiiigvpe
    dtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegsrghrrhihnhesphhosghogidrtghomhdp
    nhgspghrtghpthhtohepiedpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtohepghhrvg
    hgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpthhtohepshhtrggs
    lhgvsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtohepphgrthgthhgvsheslh
    hishhtshdrlhhinhhugidruggvvhdprhgtphhtthhopehjrggtohgsrdgvrdhkvghllhgv
    rhesihhnthgvlhdrtghomhdprhgtphhtthhopegtohhrsggvtheslhifnhdrnhgvthdprh
    gtphhtthhopehsrghshhgrlheskhgvrhhnvghlrdhorhhg
X-ME-Proxy: <xmx:jJJCabtlO_xI5hrnO0UaaCPRdC0QT8J-7jI45ZQzbrcSxKgbpagC0g>
    <xmx:jJJCaT3JHMPMpaV2JOfQVXk1ycIbH_3QZlfQD-xoFTa33efVtCO24A>
    <xmx:jJJCaUWBGFk9oX_VUXbMpjHlc4LLQw7radNwkxvGz5BSrFH9rQnr1A>
    <xmx:jJJCaWLkcuBhib1Ie6D-Gme7tKKwKebFt3kh1WbMtcnFbeHWfNN5eg>
    <xmx:jZJCad3_Re6qZRs0mfkXmRMDg5Ju9ETdH9josiJ9s5pTe8nCEiQtDoFU>
Feedback-ID: i6289494f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 17 Dec 2025 06:22:51 -0500 (EST)
Message-ID: <153a28b8-5933-470a-b1af-e91f6f3e8a5a@pobox.com>
Date: Wed, 17 Dec 2025 03:22:50 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 159/614] docs: kdoc: fix duplicate section warning
 message
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Jacob Keller <jacob.e.keller@intel.com>,
 Jonathan Corbet <corbet@lwn.net>, Sasha Levin <sashal@kernel.org>
References: <20251216111401.280873349@linuxfoundation.org>
 <20251216111407.097805254@linuxfoundation.org>
Content-Language: en-US
From: "Barry K. Nathan" <barryn@pobox.com>
In-Reply-To: <20251216111407.097805254@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/16/25 03:08, Greg Kroah-Hartman wrote:
> 6.18-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Jacob Keller <jacob.e.keller@intel.com>
> 
> [ Upstream commit e5e7ca66a7fc6b8073c30a048e1157b88d427980 ]
> 
> The python version of the kernel-doc parser emits some strange warnings
> with just a line number in certain cases:
> 
> $ ./scripts/kernel-doc -Wall -none 'include/linux/virtio_config.h'
> Warning: 174
> Warning: 184
> Warning: 190
> Warning: include/linux/virtio_config.h:226 No description found for return value of '__virtio_test_bit'
> Warning: include/linux/virtio_config.h:259 No description found for return value of 'virtio_has_feature'
> Warning: include/linux/virtio_config.h:283 No description found for return value of 'virtio_has_dma_quirk'
> Warning: include/linux/virtio_config.h:392 No description found for return value of 'virtqueue_set_affinity'
> 
> I eventually tracked this down to the lone call of emit_msg() in the
> KernelEntry class, which looks like:
> 
>    self.emit_msg(self.new_start_line, f"duplicate section name '{name}'\n")
> 
> This looks like all the other emit_msg calls. Unfortunately, the definition
> within the KernelEntry class takes only a message parameter and not a line
> number. The intended message is passed as the warning!
> 
> Pass the filename to the KernelEntry class, and use this to build the log
> message in the same way as the KernelDoc class does.
> 
> To avoid future errors, mark the warning parameter for both emit_msg
> definitions as a keyword-only argument. This will prevent accidentally
> passing a string as the warning parameter in the future.
> 
> Also fix the call in dump_section to avoid an unnecessary additional
> newline.
> 
> Fixes: e3b42e94cf10 ("scripts/lib/kdoc/kdoc_parser.py: move kernel entry to a class")
> Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
> Signed-off-by: Jonathan Corbet <corbet@lwn.net>
> Message-ID: <20251030-jk-fix-kernel-doc-duplicate-return-warning-v2-1-ec4b5c662881@intel.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   scripts/lib/kdoc/kdoc_parser.py | 16 ++++++++++------
>   1 file changed, 10 insertions(+), 6 deletions(-)
> 
> diff --git a/scripts/lib/kdoc/kdoc_parser.py b/scripts/lib/kdoc/kdoc_parser.py
> index 2376f180b1fa9..ccbc1fe4b7ccd 100644
> --- a/scripts/lib/kdoc/kdoc_parser.py
> +++ b/scripts/lib/kdoc/kdoc_parser.py
> @@ -274,6 +274,8 @@ class KernelEntry:
>   
>           self.leading_space = None
>   
> +        self.fname = fname
> +
>           # State flags
>           self.brcount = 0
>           self.declaration_start_line = ln + 1
> @@ -288,9 +290,11 @@ class KernelEntry:
>           return '\n'.join(self._contents) + '\n'
>   
>       # TODO: rename to emit_message after removal of kernel-doc.pl
> -    def emit_msg(self, log_msg, warning=True):
> +    def emit_msg(self, ln, msg, *, warning=True):
>           """Emit a message"""
>   
> +        log_msg = f"{self.fname}:{ln} {msg}"
> +
>           if not warning:
>               self.config.log.info(log_msg)
>               return
> @@ -336,7 +340,7 @@ class KernelEntry:
>                   # Only warn on user-specified duplicate section names
>                   if name != SECTION_DEFAULT:
>                       self.emit_msg(self.new_start_line,
> -                                  f"duplicate section name '{name}'\n")
> +                                  f"duplicate section name '{name}'")
>                   # Treat as a new paragraph - add a blank line
>                   self.sections[name] += '\n' + contents
>               else:
> @@ -387,15 +391,15 @@ class KernelDoc:
>               self.emit_msg(0,
>                             'Python 3.7 or later is required for correct results')
>   
> -    def emit_msg(self, ln, msg, warning=True):
> +    def emit_msg(self, ln, msg, *, warning=True):
>           """Emit a message"""
>   
> -        log_msg = f"{self.fname}:{ln} {msg}"
> -
>           if self.entry:
> -            self.entry.emit_msg(log_msg, warning)
> +            self.entry.emit_msg(ln, msg, warning=warning)
>               return
>   
> +        log_msg = f"{self.fname}:{ln} {msg}"
> +
>           if warning:
>               self.config.log.warning(log_msg)
>           else:

On 6.18.2-rc1 and 6.17.13-rc2, this patch causes amd64 kernel builds 
with my usual configs to fail with the following error:

   CC      drivers/gpu/drm/i915/i915_driver.o
Traceback (most recent call last):
   File 
"/home/barryn/src/linux/build-amd64/linux-6.18.2-rc1/./scripts/kernel-doc.py", 
line 339, in <module>
     main()
   File 
"/home/barryn/src/linux/build-amd64/linux-6.18.2-rc1/./scripts/kernel-doc.py", 
line 310, in main
     kfiles.parse(args.files, export_file=args.export_file)
   File 
"/home/barryn/src/linux/build-amd64/linux-6.18.2-rc1/scripts/lib/kdoc/kdoc_files.py", 
line 222, in parse
     self.parse_file(fname)
   File 
"/home/barryn/src/linux/build-amd64/linux-6.18.2-rc1/scripts/lib/kdoc/kdoc_files.py", 
line 120, in parse_file
     export_table, entries = doc.parse_kdoc()
                             ^^^^^^^^^^^^^^^^
   File 
"/home/barryn/src/linux/build-amd64/linux-6.18.2-rc1/scripts/lib/kdoc/kdoc_parser.py", 
line 1648, in parse_kdoc
     self.state_actions[self.state](self, ln, line)
   File 
"/home/barryn/src/linux/build-amd64/linux-6.18.2-rc1/scripts/lib/kdoc/kdoc_parser.py", 
line 1123, in process_normal
     self.reset_state(ln)
   File 
"/home/barryn/src/linux/build-amd64/linux-6.18.2-rc1/scripts/lib/kdoc/kdoc_parser.py", 
line 447, in reset_state
     self.entry = KernelEntry(self.config, ln)
                  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^
   File 
"/home/barryn/src/linux/build-amd64/linux-6.18.2-rc1/scripts/lib/kdoc/kdoc_parser.py", 
line 277, in __init__
     self.fname = fname
                  ^^^^^
NameError: name 'fname' is not defined
make[6]: *** [scripts/Makefile.build:287: 
drivers/gpu/drm/i915/i915_driver.o] Error 1
make[6]: *** Deleting file 'drivers/gpu/drm/i915/i915_driver.o'
make[5]: *** [scripts/Makefile.build:556: drivers/gpu/drm/i915] Error 2
make[4]: *** [scripts/Makefile.build:556: drivers/gpu/drm] Error 2
make[3]: *** [scripts/Makefile.build:556: drivers/gpu] Error 2
make[2]: *** [scripts/Makefile.build:556: drivers] Error 2
make[1]: *** 
[/home/barryn/src/linux/build-amd64/linux-6.18.2-rc1/Makefile:2010: .] 
Error 2
make: *** [Makefile:248: __sub-make] Error 2

Here is a minimal config to reproduce (make a .config with just these 6 
lines, then run `make olddefconfig`):

CONFIG_64BIT=y
CONFIG_EXPERT=y
CONFIG_PCI=y
CONFIG_DRM=y
CONFIG_DRM_I915=y
CONFIG_DRM_I915_WERROR=y

This bug happens if and only if CONFIG_DRM_I915_WERROR=y. (By the way, 
allyesconfig and allmodconfig set CONFIG_COMPILE_TEST=y, which disables 
CONFIG_DRM_I915_DEBUG and CONFIG_DRM_I915_WERROR. So neither 
allyesconfig nor allmodconfig reproduce this.)

It happens whether building for amd64 or i386 (so CONFIG_64BIT=y is not 
strictly necessary). It happens on both fully updated Debian 12 Bookworm 
and fully updated Debian 13 Trixie. It happens both when compiling 
natively on amd64 and when cross-compiling from an arm64 system.

It happens on 6.18.2-rc1 and 6.17.13-rc2, but not on 6.19-rc1. Also, if 
I revert this patch on 6.18.2-rc1 or 6.17.13-rc2, the bug no longer 
reproduces.

-- 
-Barry K. Nathan  <barryn@pobox.com>
