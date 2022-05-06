Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C6B77E8
	for <patches@lists.linux.dev>; Fri,  6 May 2022 08:20:26 +0000 (UTC)
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1651825224;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XvECXZlKv//5WXr2Qh3h1YJR2CNLvzofteXK2A2O1ho=;
	b=C8ni3HIp+lksZAPvlwAD6tGqGcAuY5WJ7CQCJojWPzOWWgQTwgRyNAgCBFQkV5VfxGHFGe
	j0MqyYE+lNEt0MQkpP1deH5GhC+aE0GlsIllCQm8coNDB+hSk34j0R0CiEKpxsoyzbGmtt
	Su3DU3ch9uDjbQwNHvnkTMAclmQFDC4jTzbTDvWR7T+JOI2VDOlgW+SEZAFnENWVURKSq4
	8W+P05Oix32+ZM4SwrKRoZkCtr+Q805Y12gvaEma15l7o6dcJCAG27PGQDKIQJOmVB+9q3
	kw0oucAN942TB66n8wMEAs2fo1vHp2B047hKLXSIrSU/6/SAqw2dPQTFIZ+r2A==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1651825224;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XvECXZlKv//5WXr2Qh3h1YJR2CNLvzofteXK2A2O1ho=;
	b=EvVTeBAWPkgbWcXilyuBQ16WAspalSc/xW7PUI/iM2W3GpiEZJY2Q7Lf7/3O4+mx8be/Ik
	7JbcLOHcn+8IU6BA==
To: Tony Luck <tony.luck@intel.com>, hdegoede@redhat.com, markgross@kernel.org
Cc: mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
 x86@kernel.org, hpa@zytor.com, corbet@lwn.net, gregkh@linuxfoundation.org,
 andriy.shevchenko@linux.intel.com, jithu.joseph@intel.com,
 ashok.raj@intel.com, tony.luck@intel.com, rostedt@goodmis.org,
 dan.j.williams@intel.com, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, platform-driver-x86@vger.kernel.org,
 patches@lists.linux.dev, ravi.v.shankar@intel.com, Peter Zijlstra
 <peterz@infradead.org>
Subject: Re: [PATCH v6 03/11] stop_machine: Add stop_core_cpuslocked() for
 per-core operations
In-Reply-To: <20220506014035.1173578-4-tony.luck@intel.com>
References: <20220428153849.295779-1-tony.luck@intel.com>
 <20220506014035.1173578-1-tony.luck@intel.com>
 <20220506014035.1173578-4-tony.luck@intel.com>
Date: Fri, 06 May 2022 10:20:23 +0200
Message-ID: <87wnezgji0.ffs@tglx>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

On Thu, May 05 2022 at 18:40, Tony Luck wrote:
> From: Peter Zijlstra <peterz@infradead.org>
>
> Hardware core level testing features require near simultaneous execution
> of WRMSR instructions on all threads of a core to initiate a test.
>
> Provide a customized cut down version of stop_machine_cpuslocked() that
> just operates on the threads of a single core.
>
> Suggested-by: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> Signed-off-by: Tony Luck <tony.luck@intel.com>

Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
