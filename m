Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C00F2110
	for <patches@lists.linux.dev>; Wed,  4 May 2022 10:28:35 +0000 (UTC)
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1651660107;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+p02m4NybtoYkCAp7qOzZK/r9dVhwWNCaV0MHp4YzOA=;
	b=Otdai8w7VXz67RzUE5XSQmT2/Nd3ubJw/iakDnDoxp9DehhbkNO1Vb/WFz0CJ+pvB4t8YP
	LN5o5ykv5TfR56hguAugW7oIlKo5w51JuG8/STTOWnu2V06KUkVFQevsv2sLCdC682G4pS
	k7RrtghYswPqJuSUq8uwbf3RlUtlcO28qloxGGE/STp/e2si20zaMwc6pP5yRmT86mJv/z
	J5JcON7SEUVFjH42qddQG7+qpfJuDS5xaZH144vHlTDGTCRcc6eTrVjwsEiqyNUocrDwTr
	3drUcZdC7xH/zPfhimNggICUo8DHu/5aPRoNcc2Kb5iDajzyTZQm6VXKmP6YCQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1651660107;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+p02m4NybtoYkCAp7qOzZK/r9dVhwWNCaV0MHp4YzOA=;
	b=B6VxQKFHlQCHU2LFvEypkmPmWEWQvlBAc/zif7fWOm0uwcZWEWSJSXfHgGcQKgfByVxHwI
	cbKgzLNZC3+sLQBA==
To: Tony Luck <tony.luck@intel.com>, hdegoede@redhat.com, markgross@kernel.org
Cc: mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
 x86@kernel.org, hpa@zytor.com, corbet@lwn.net, gregkh@linuxfoundation.org,
 andriy.shevchenko@linux.intel.com, jithu.joseph@intel.com,
 ashok.raj@intel.com, tony.luck@intel.com, rostedt@goodmis.org,
 dan.j.williams@intel.com, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, platform-driver-x86@vger.kernel.org,
 patches@lists.linux.dev, ravi.v.shankar@intel.com
Subject: Re: [PATCH v5 01/10] x86/microcode/intel: Expose
 collect_cpu_info_early() for IFS
In-Reply-To: <20220428153849.295779-2-tony.luck@intel.com>
References: <20220422200219.2843823-1-tony.luck@intel.com>
 <20220428153849.295779-1-tony.luck@intel.com>
 <20220428153849.295779-2-tony.luck@intel.com>
Date: Wed, 04 May 2022 12:28:26 +0200
Message-ID: <8735hplhh1.ffs@tglx>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

On Thu, Apr 28 2022 at 08:38, Tony Luck wrote:
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

Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
