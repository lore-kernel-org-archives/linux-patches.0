Received: from cavan.codon.org.uk (cavan.codon.org.uk [176.126.240.207])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01EB47E
	for <patches@lists.linux.dev>; Mon, 28 Nov 2022 01:35:24 +0000 (UTC)
Received: by cavan.codon.org.uk (Postfix, from userid 1000)
	id 15B6A424A2; Mon, 28 Nov 2022 01:35:23 +0000 (GMT)
Date: Mon, 28 Nov 2022 01:35:23 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: linux-efi@vger.kernel.org, linux-crypto@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	ardb@kernel.org
Subject: Re: [PATCH v3 2/5] efi: stub: use random seed from EFI variable
Message-ID: <20221128013523.GA6780@srcf.ucam.org>
References: <20221122020404.3476063-1-Jason@zx2c4.com>
 <20221122020404.3476063-3-Jason@zx2c4.com>
 <20221127211244.GB32253@srcf.ucam.org>
 <Y4QLBnoJGUoqwo4p@zx2c4.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y4QLBnoJGUoqwo4p@zx2c4.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Mon, Nov 28, 2022 at 02:12:38AM +0100, Jason A. Donenfeld wrote:

> Yea this is a bummer. During my first attempt at this, I actually
> overwrote the whole thing with zeros and then deleted it. But Ard
> pointed out that this doesn't make a difference anyway. But, as it turns
> out, that's more or less the same thing that happens with seed files on
> SSDs (nobody calls fstrim after overwriting a seed file). So at the very
> least, it's no worse?

Anyone with the ability to directly read the flash variable store is 
almost certainly in a position to do worse things, so I wouldn't worry 
about it.
