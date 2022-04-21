Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFA341FC0
	for <patches@lists.linux.dev>; Thu, 21 Apr 2022 15:04:20 +0000 (UTC)
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1650552979;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3kCmmeBFyKdPCM39jp9rfdUy/VRt431xwBuf3wpfKds=;
	b=2YIcM1pfi0m8RrAtM3GW/cEzGwM03IHx14kKmkky9jseLGxHS6boPU+SJS3IvaUX6qGz24
	PfmoWSDYkoxmvNYCv3P84Of2ewTlBA+PN2z5tNozCdUir+Z/MBJR/XaVDP7ljPv0HgZeGL
	Cnmfhky8wIhx7Rd+6IEwEpAMRdDJvOHMCk+yXqsqwuvg+PyHeu1CiF0YDOa8uDrbPCq4J5
	UGiu3wnbzj5PQgdtGSoI/sxK8GGpygszVEf5E4S6s0byZZpScssgN2Qez7XAPVcEwopsS+
	Wa8XMDCV4/5GDRwxI8InboSUHZvv9GCKdCy534HIpOyPzIvwJhIcsZCTu/WZIA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1650552979;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3kCmmeBFyKdPCM39jp9rfdUy/VRt431xwBuf3wpfKds=;
	b=cUFWYXFbRStTQNvqnNyN8QiNjcTaVlh1mE6iJSETtZjT1l9CRDvaI9pfkvMK+ZplQogoOE
	iEAdRr16VWtQrTDQ==
To: Borislav Petkov <bp@alien8.de>, Jithu Joseph <jithu.joseph@intel.com>
Cc: hdegoede@redhat.com, markgross@kernel.org, mingo@redhat.com,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 corbet@lwn.net, gregkh@linuxfoundation.org,
 andriy.shevchenko@linux.intel.com, ashok.raj@intel.com,
 tony.luck@intel.com, rostedt@goodmis.org, dan.j.williams@intel.com,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 platform-driver-x86@vger.kernel.org, patches@lists.linux.dev,
 ravi.v.shankar@intel.com
Subject: Re: [PATCH v2 01/10] x86/microcode/intel: expose
 collect_cpu_info_early() for IFS
In-Reply-To: <Yk/zhV3SGib6TaI5@zn.tnic>
References: <20220407191347.9681-1-jithu.joseph@intel.com>
 <20220407191347.9681-2-jithu.joseph@intel.com> <Yk/zhV3SGib6TaI5@zn.tnic>
Date: Thu, 21 Apr 2022 16:56:19 +0200
Message-ID: <871qxqtrho.ffs@tglx>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

On Fri, Apr 08 2022 at 10:34, Borislav Petkov wrote:
> On Thu, Apr 07, 2022 at 12:13:38PM -0700, Jithu Joseph wrote:
>> +EXPORT_SYMBOL_GPL(cpu_signatures_match);
>> +
>> +int cpu_collect_info_early(struct ucode_cpu_info *uci)
>
> intel_collect_cpu_info_early()

That function name does not make sense in context of that driver...

Thanks,

        tglx
