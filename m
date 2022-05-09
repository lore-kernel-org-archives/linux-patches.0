Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B0F71865
	for <patches@lists.linux.dev>; Mon,  9 May 2022 12:11:22 +0000 (UTC)
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1652098274;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=azpewdwyr1bDmpn1HTMmZ9HZHXGFtPT95Bi3ep9m4fU=;
	b=vBRHlPnl5xDIhHDIHNVzv9T+v1RKY6WkBo52fMHuIVQmg/hc7oZYgIuoRPa7kWYgNwp3dU
	uFQ5zabmE+nnDplq7WK+P9N964ou7YU8aca+msKAtFOx6tVhQpxxAplL5k/PLRoi7jjVRo
	QBokAUK9ECysANDWZFOX4zL0du4bLCX5HeMqBNbp8xbk7cwmiTgdEjvQH9crPoRna8XlKm
	rO8Z23ljW9OInHn4Bx1Q3+4eMzwFGa58wUDsJxhGrxPPzsQHn3LSyvKJ9mvwzkHV0uVIDX
	Q1sd+t3P6LEF8ETZvllWofJVIJW3i2GX8tH6XFJWVVPK4URxcWOaYGe+7AO0qA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1652098274;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=azpewdwyr1bDmpn1HTMmZ9HZHXGFtPT95Bi3ep9m4fU=;
	b=Fa8LWCVkhpeu9m58BXxLAYB5dyjrVQfXlBW/0MxqCqwLqvv1fLtbYFSwhCkbv6vE1bz0d2
	ipJdkCbAdtHtw+DA==
To: Tony Luck <tony.luck@intel.com>, hdegoede@redhat.com, markgross@kernel.org
Cc: mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
 x86@kernel.org, hpa@zytor.com, corbet@lwn.net, gregkh@linuxfoundation.org,
 andriy.shevchenko@linux.intel.com, jithu.joseph@intel.com,
 ashok.raj@intel.com, tony.luck@intel.com, rostedt@goodmis.org,
 dan.j.williams@intel.com, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, platform-driver-x86@vger.kernel.org,
 patches@lists.linux.dev, ravi.v.shankar@intel.com
Subject: Re: [PATCH v7 05/12] platform/x86/intel/ifs: Read IFS firmware image
In-Reply-To: <20220506225410.1652287-6-tony.luck@intel.com>
References: <20220506014035.1173578-1-tony.luck@intel.com>
 <20220506225410.1652287-1-tony.luck@intel.com>
 <20220506225410.1652287-6-tony.luck@intel.com>
Date: Mon, 09 May 2022 14:11:14 +0200
Message-ID: <875ymesy71.ffs@tglx>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

On Fri, May 06 2022 at 15:54, Tony Luck wrote:
> Reviewed-by: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Jithu Joseph <jithu.joseph@intel.com>
> Co-developed-by: Tony Luck <tony.luck@intel.com>
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> Acked-by: Hans de Goede <hdegoede@redhat.com>
> Reviewed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
