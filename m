Received: from cavan.codon.org.uk (cavan.codon.org.uk [176.126.240.207])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27D5A8491
	for <patches@lists.linux.dev>; Sun, 27 Nov 2022 21:08:39 +0000 (UTC)
Received: by cavan.codon.org.uk (Postfix, from userid 1000)
	id 00784424A4; Sun, 27 Nov 2022 21:00:40 +0000 (GMT)
Date: Sun, 27 Nov 2022 21:00:40 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: linux-efi@vger.kernel.org, linux-crypto@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	ardb@kernel.org
Subject: Re: [PATCH v3 1/5] efi: vars: prohibit reading random seed variables
Message-ID: <20221127210040.GA32253@srcf.ucam.org>
References: <20221122020404.3476063-1-Jason@zx2c4.com>
 <20221122020404.3476063-2-Jason@zx2c4.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221122020404.3476063-2-Jason@zx2c4.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Tue, Nov 22, 2022 at 03:04:00AM +0100, Jason A. Donenfeld wrote:
> In anticipation of putting random seeds in EFI variables, it's important
> that the random GUID namespace of variables remains hidden from
> userspace. We accomplish this by not populating efivarfs with entries
> from that GUID, as well as denying the creation of new ones in that
> GUID.

What's the concern here? Booting an older kernel would allow a malicious 
actor to either read the seed variable or set it to a value under their 
control, so we can't guarantee that the information is secret.
