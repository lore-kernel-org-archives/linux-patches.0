Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6B671865
	for <patches@lists.linux.dev>; Mon,  9 May 2022 12:11:45 +0000 (UTC)
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1652098303;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=c1S4qgIexVxUkg4g5IflBR6xhHVXFV+CK8zLjORoMnw=;
	b=xp/12Eat/21EiV3V4r0xtNB/4ne0G6vT/efQcJXHM+NGiVq/o9LtWorbLwW5K1n55sDX6b
	k7kqDPz0ZHI19lblZQfltwa0zip0iM/RKOKIujUpToXMIRcRnF7KxglRBBtWY3VrhAS5gG
	N6YdMsBfVwWhGUQM4h6SdOxvByma8rmKtf05XtwftDX8NcWy5FeUCdTuumTrbt2/2H8R25
	gdi8s5eA9aUwLLis+LFW5TQoJZPG3AOoWQTFab7QXsINu4FIzF/cRfyhsSEo1P43Uko60g
	q9w4LhDgPOFVr6nDKc1D4Z6CSpyevF2uKWadPKJLDW3q42lg6qUAF742VoRSAg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1652098303;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=c1S4qgIexVxUkg4g5IflBR6xhHVXFV+CK8zLjORoMnw=;
	b=QxD+yS9aIoH6knf8wRR3INj6y6PJW/73wM3pElyFAD9vc10r++07BeJPBl0x+tpib57aUf
	0UVI+auBOhXXsrBQ==
To: Tony Luck <tony.luck@intel.com>, hdegoede@redhat.com, markgross@kernel.org
Cc: mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
 x86@kernel.org, hpa@zytor.com, corbet@lwn.net, gregkh@linuxfoundation.org,
 andriy.shevchenko@linux.intel.com, jithu.joseph@intel.com,
 ashok.raj@intel.com, tony.luck@intel.com, rostedt@goodmis.org,
 dan.j.williams@intel.com, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, platform-driver-x86@vger.kernel.org,
 patches@lists.linux.dev, ravi.v.shankar@intel.com
Subject: Re: [PATCH v7 07/12] platform/x86/intel/ifs: Authenticate and copy
 to secured memory
In-Reply-To: <20220506225410.1652287-8-tony.luck@intel.com>
References: <20220506014035.1173578-1-tony.luck@intel.com>
 <20220506225410.1652287-1-tony.luck@intel.com>
 <20220506225410.1652287-8-tony.luck@intel.com>
Date: Mon, 09 May 2022 14:11:43 +0200
Message-ID: <87zgjqrjls.ffs@tglx>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

On Fri, May 06 2022 at 15:54, Tony Luck wrote:
> Use schedule_work_on() to perform the hash copy and authentication. Note
> this needs only be done on the first logical cpu of each socket.
>
> Reviewed-by: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Jithu Joseph <jithu.joseph@intel.com>
> Co-developed-by: Tony Luck <tony.luck@intel.com>
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> Acked-by: Hans de Goede <hdegoede@redhat.com>
> Reviewed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
