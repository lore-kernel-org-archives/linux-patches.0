Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28C3B1865
	for <patches@lists.linux.dev>; Mon,  9 May 2022 12:11:30 +0000 (UTC)
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1652098288;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=azpewdwyr1bDmpn1HTMmZ9HZHXGFtPT95Bi3ep9m4fU=;
	b=u70MPVD8ERKX1uNmwc7uEvWWOziwIe0sK5l5/8PprTbFop5Wh+3UBHzTYsVXZ4iGGjo2sB
	TJ1iGbJleqVU5kHAKtaCtmJBtr8qw6LeqGC5LXftcheFpj9wbK5KmP5S/B36mYyKpfk65t
	7lw6Jpa0b7ZbqxPiGmhs+eiz2UlavI5B6GQU/nFVs9LtQO+k475KNaUxVPBoGTZDW/Q6kr
	R+lcPp34M2O+KGQjO1VpsiihXJkCnT1N+zaAxmC/CyNi2gskzcgG1jf8dAvEI1gHmUstVn
	HMdbSBX0CSewShErKJdiNVemiyjr5Tr3WzJnbPQ+tHb/p1BIg5DKO115eZooKQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1652098288;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=azpewdwyr1bDmpn1HTMmZ9HZHXGFtPT95Bi3ep9m4fU=;
	b=1/c7846O+NuvxIDeuK3kKtYyi3Qj1aWmj6uHAMvLoVPfxEM8nEF0oO7G3HeIOTbzVAv/69
	gzz3Jzm4Pekgx+Cw==
To: Tony Luck <tony.luck@intel.com>, hdegoede@redhat.com, markgross@kernel.org
Cc: mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
 x86@kernel.org, hpa@zytor.com, corbet@lwn.net, gregkh@linuxfoundation.org,
 andriy.shevchenko@linux.intel.com, jithu.joseph@intel.com,
 ashok.raj@intel.com, tony.luck@intel.com, rostedt@goodmis.org,
 dan.j.williams@intel.com, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, platform-driver-x86@vger.kernel.org,
 patches@lists.linux.dev, ravi.v.shankar@intel.com
Subject: Re: [PATCH v7 06/12] platform/x86/intel/ifs: Check IFS Image sanity
In-Reply-To: <20220506225410.1652287-7-tony.luck@intel.com>
References: <20220506014035.1173578-1-tony.luck@intel.com>
 <20220506225410.1652287-1-tony.luck@intel.com>
 <20220506225410.1652287-7-tony.luck@intel.com>
Date: Mon, 09 May 2022 14:11:27 +0200
Message-ID: <8735hisy6o.ffs@tglx>
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
