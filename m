Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17CD9137F
	for <patches@lists.linux.dev>; Fri,  1 Apr 2022 18:03:29 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id C9C9221A90;
	Fri,  1 Apr 2022 17:57:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1648835873; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=f9SA9jeVPibQzcd8buCsF/7ncM5s4P2vkUi1q8Zs7CY=;
	b=DxJtlKfGw7I8XKrtf1bX1ayliLJE1/HBoPKnInbfEaYnJcrTcuxIcXni+ZLHUBHHYHkk4E
	/49/bpeH3DHKUfkY/T7GkPU02w5cKAjZhbSQNNJOSOi9DY6MaCTu8dhEr2KHH3oUcwTLse
	874pn+g+lYgfyH5/Yb6wzTFGq2Rib+c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1648835873;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=f9SA9jeVPibQzcd8buCsF/7ncM5s4P2vkUi1q8Zs7CY=;
	b=4z3k24IAgNOcQY00d6mCG8q35YEwDAyyDBO7c3g+e2U7yNs9S0W0hYwhx6y4TC8AuBl+5t
	5DLMowwkKmvEy4DA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id BED3A132C1;
	Fri,  1 Apr 2022 17:57:53 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id SZqJLiE9R2JpWQAAMHmgww
	(envelope-from <bp@suse.de>); Fri, 01 Apr 2022 17:57:53 +0000
Date: Fri, 1 Apr 2022 19:57:51 +0200
From: Borislav Petkov <bp@suse.de>
To: Dave Hansen <dave.hansen@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@lists.linux.dev, corbet@lwn.net,
	tglx@linutronix.de, x86@kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH] [v2] x86/configs: Add x86 debugging Kconfig fragment
 plus docs
Message-ID: <Ykc9H801hkMRUd8t@zn.tnic>
References: <20220331175728.299103A0@davehans-spike.ostc.intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220331175728.299103A0@davehans-spike.ostc.intel.com>

On Thu, Mar 31, 2022 at 10:57:28AM -0700, Dave Hansen wrote:
> 
> Changes from v1:
> 
>  * Add actual .config fragment instead of just documenting it
>  * Note that these partially x86-specific, but the rest can be
>    used to test all tip contributions.

Good, that looks nice. I'll queue it next week with this hunk added:

---
diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index 63d50f65b828..1abd7cc9d6cd 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -313,5 +313,6 @@ define archhelp
   echo  ''
   echo  '  kvm_guest.config	- Enable Kconfig items for running this kernel as a KVM guest'
   echo  '  xen.config		- Enable Kconfig items for running this kernel as a Xen guest'
+  echo  '  x86_debug.config	- Enable tip tree debugging options for testing'
 
 endef

-- 
Regards/Gruss,
    Boris.

SUSE Software Solutions Germany GmbH, GF: Ivo Totev, HRB 36809, AG Nürnberg
