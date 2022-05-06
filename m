Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A2CB7E8
	for <patches@lists.linux.dev>; Fri,  6 May 2022 08:19:52 +0000 (UTC)
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1651825184;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=oOhsxF87eBvGZL+YwZLT6F/KHew+AJpGncIqoLquwOs=;
	b=CXeCSWbxwhbDLyrcFMoWLLdk08nhSTSzGEiRw4W5Y68sChSOwD6n3HRTyvbjlsRvs42c6m
	WElXi5gEj8/7r6bxZey0LX3IZ7pT5lOcl54ZbVZD8OMN/Ql8LojVe4+L5hY341zEreqBRQ
	lAxeU48SJLvTs4dg0hhIVp64ZF9JxCER/Bc5O/mz/M4b9CHkeokTOrVPtk/wejKkNDFdA6
	Vq524jBEPLQ8hxr9Jv4VDzYVsa5IQiVezb5nJW0a5TZOrYLW2S6HGWh5KrAKc4VGvVqZN9
	LNEz/8g1SSyedUDVIjXrIYbhgE0jm04ztCrAPi2ceto5WNqvGjM8P1Ziu6LOrg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1651825184;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=oOhsxF87eBvGZL+YwZLT6F/KHew+AJpGncIqoLquwOs=;
	b=zsk+ISBvjbLcl4et6zGn7vChVrvkkLJRuGPpaq/6zMOt6d53JDjtPOmVt6AIx9niz1e963
	NIfyWbko3zVYApDg==
To: Tony Luck <tony.luck@intel.com>, hdegoede@redhat.com, markgross@kernel.org
Cc: mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
 x86@kernel.org, hpa@zytor.com, corbet@lwn.net, gregkh@linuxfoundation.org,
 andriy.shevchenko@linux.intel.com, jithu.joseph@intel.com,
 ashok.raj@intel.com, tony.luck@intel.com, rostedt@goodmis.org,
 dan.j.williams@intel.com, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, platform-driver-x86@vger.kernel.org,
 patches@lists.linux.dev, ravi.v.shankar@intel.com
Subject: Re: [PATCH v6 02/11] x86/msr-index: Define INTEGRITY_CAPABILITIES MSR
In-Reply-To: <20220506014035.1173578-3-tony.luck@intel.com>
References: <20220428153849.295779-1-tony.luck@intel.com>
 <20220506014035.1173578-1-tony.luck@intel.com>
 <20220506014035.1173578-3-tony.luck@intel.com>
Date: Fri, 06 May 2022 10:19:44 +0200
Message-ID: <87zgjvgjj3.ffs@tglx>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

On Thu, May 05 2022 at 18:40, Tony Luck wrote:

> The INTEGRITY_CAPABILITIES MSR is enumerated by bit 2 of the
> CORE_CAPABILITIES MSR.
>
> Add defines for the CORE_CAPS enumeration as well as for the integrity
> MSR.
>
> Reviewed-by: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> Reviewed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
