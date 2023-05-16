Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA6B8156F2
	for <patches@lists.linux.dev>; Tue, 16 May 2023 09:18:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 234A0C433D2;
	Tue, 16 May 2023 09:18:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684228707;
	bh=8BJ+s5vIHAO4GubJlcqW6iAuHjFow3RHcI4fHoEz8l0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YX1tZTc7H7B3YOGuXOCgpLm7vNWJMxLIbZPUKGYrFXKTcFYbTyi9C2rJmqBXMlcQt
	 7HGlKtVUthFlmYH40oHlJsjXDPeZCW3DDINYZLb7ly3rQfCVN77rKTd8Y9R3xo4U/k
	 Yquru0Lbfv6sQD9NSOjVjQoCThSwSxSKHigVjJAA=
Date: Tue, 16 May 2023 11:18:24 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	Fabio Estevam <festevam@gmail.com>,
	Richard Weinberger <richard@nod.at>,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-um@lists.infradead.org, Mimi Zohar <zohar@linux.ibm.com>
Subject: Re: [PATCH 4.19 007/191] IMA: allow/fix UML builds
Message-ID: <2023051655-dinghy-uncolored-6480@gregkh>
References: <20230515161707.203549282@linuxfoundation.org>
 <20230515161707.460071056@linuxfoundation.org>
 <CAMuHMdWjkZ-FAKrwQkoyZRHLpyvaVYT0NvAUwaCs+30qC2VZmA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMuHMdWjkZ-FAKrwQkoyZRHLpyvaVYT0NvAUwaCs+30qC2VZmA@mail.gmail.com>

On Tue, May 16, 2023 at 10:47:13AM +0200, Geert Uytterhoeven wrote:
> Hi Greg,
> 
> On Mon, May 15, 2023 at 6:39 PM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> > From: Randy Dunlap <rdunlap@infradead.org>
> >
> > commit 644f17412f5acf01a19af9d04a921937a2bc86c6 upstream.
> >
> > UML supports HAS_IOMEM since 0bbadafdc49d (um: allow disabling
> > NO_IOMEM).
> 
> 0bbadafdc49d is in v5.14.
> Was it backported to older versions?

Nope.

> > Current IMA build on UML fails on allmodconfig (with TCG_TPM=m):
> >
> > ld: security/integrity/ima/ima_queue.o: in function `ima_add_template_entry':
> > ima_queue.c:(.text+0x2d9): undefined reference to `tpm_pcr_extend'
> > ld: security/integrity/ima/ima_init.o: in function `ima_init':
> > ima_init.c:(.init.text+0x43f): undefined reference to `tpm_default_chip'
> > ld: security/integrity/ima/ima_crypto.o: in function `ima_calc_boot_aggregate_tfm':
> > ima_crypto.c:(.text+0x1044): undefined reference to `tpm_pcr_read'
> > ld: ima_crypto.c:(.text+0x10d8): undefined reference to `tpm_pcr_read'
> >
> > Modify the IMA Kconfig entry so that it selects TCG_TPM if HAS_IOMEM
> > is set, regardless of the UML Kconfig setting.
> > This updates TCG_TPM from =m to =y and fixes the linker errors.
> >
> > Fixes: f4a0391dfa91 ("ima: fix Kconfig dependencies")

This is what I triggered off of.

> > Cc: Stable <stable@vger.kernel.org> # v5.14+
> 
> "v5.14+"

Sorry, good catch, I'll go drop this from all of the older queues.

thanks for the review!

greg k-h
