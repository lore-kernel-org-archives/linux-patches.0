Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68A6E369
	for <patches@lists.linux.dev>; Thu,  5 May 2022 09:01:30 +0000 (UTC)
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1651741287;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NBH1gFjnIQzahzJKDpgyGdyjqnsj7PYnMtU9OaVJyYA=;
	b=Vk7T23Z2kxMOWJJ8QsGbVyEx+m/o9PzOvoxJJAzUJ09ITAuT2zy0d5xLv3JzcWbz5lfXEk
	pOgOxBzoNln8mjYTAionappG8dFL5wuDqRS3jOf8BDEVJCZqJrGZwb+Y9RtUgWC6KfpRx2
	zd7DRhu4I+zFCJAdGfr6cr/xn0zMZI99FvfD5epsRN23vHQAaO7MzozJOP1H7jcVY2ZoW2
	xerXJEzHelK33MSGqiNI9UwPOfAuEV6Bnb5UQ2SDkoXJtagsvnYmJXr6wr+kBV/BiwY+mD
	kTpMZL1QY5DJn0G/4FSk7eZr3m5lXNm4Sh6qGpqbWuRODU72mkHILVSgByAaBg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1651741287;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NBH1gFjnIQzahzJKDpgyGdyjqnsj7PYnMtU9OaVJyYA=;
	b=94EEqp97FWTSI4XD39inzTx78Dsm3/zxPnX226a0G3lezjj5RTzp/ysR2PflCTT4Rgzy5D
	OO09by74/We4KKDw==
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Luck, Tony" <tony.luck@intel.com>, hdegoede@redhat.com,
 markgross@kernel.org, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 corbet@lwn.net, gregkh@linuxfoundation.org,
 andriy.shevchenko@linux.intel.com, jithu.joseph@intel.com,
 ashok.raj@intel.com, rostedt@goodmis.org, dan.j.williams@intel.com,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 platform-driver-x86@vger.kernel.org, patches@lists.linux.dev,
 ravi.v.shankar@intel.com
Subject: Re: [PATCH v5 07/10] platform/x86/intel/ifs: Add scan test support
In-Reply-To: <20220505082824.GD2501@worktop.programming.kicks-ass.net>
References: <20220422200219.2843823-1-tony.luck@intel.com>
 <20220428153849.295779-1-tony.luck@intel.com>
 <20220428153849.295779-8-tony.luck@intel.com> <87r159jxaq.ffs@tglx>
 <YnLLekoripdY2oQU@agluck-desk3.sc.intel.com> <87tua4j3es.ffs@tglx>
 <20220505082824.GD2501@worktop.programming.kicks-ass.net>
Date: Thu, 05 May 2022 11:01:27 +0200
Message-ID: <87bkwcic9k.ffs@tglx>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

On Thu, May 05 2022 at 10:28, Peter Zijlstra wrote:
> On Thu, May 05, 2022 at 01:15:07AM +0200, Thomas Gleixner wrote:
>> We don't have stomp_cpumask() today, but that's trivial enough to
>> implement.
>
> I don't think we want to gift people a random cpumask stop_machine(),

Fair enough.

> but here's one that stops a core. It runs the @fn on every cpu since I
> thought to have understood that was the requirement for this muck.

Yes.

> *completely* untestededed.

Looks about right neverthelessesseess.
