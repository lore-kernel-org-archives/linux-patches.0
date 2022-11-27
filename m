Received: from cavan.codon.org.uk (cavan.codon.org.uk [176.126.240.207])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E75858491
	for <patches@lists.linux.dev>; Sun, 27 Nov 2022 21:12:45 +0000 (UTC)
Received: by cavan.codon.org.uk (Postfix, from userid 1000)
	id 3317D424A3; Sun, 27 Nov 2022 21:12:44 +0000 (GMT)
Date: Sun, 27 Nov 2022 21:12:44 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: linux-efi@vger.kernel.org, linux-crypto@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	ardb@kernel.org
Subject: Re: [PATCH v3 2/5] efi: stub: use random seed from EFI variable
Message-ID: <20221127211244.GB32253@srcf.ucam.org>
References: <20221122020404.3476063-1-Jason@zx2c4.com>
 <20221122020404.3476063-3-Jason@zx2c4.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221122020404.3476063-3-Jason@zx2c4.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Tue, Nov 22, 2022 at 03:04:01AM +0100, Jason A. Donenfeld wrote:

> +		 * We delete the seed here, and /hope/ that this causes EFI to
> +		 * also zero out its representation on disk. This is somewhat

Several implementations I've worked with simply append a deletion marker 
or append a new variable value until the variable store fills up 
entirely, at which point a garbage collection event is either run or 
scheduled for the next reboot. The spec doesn't define how this is 
handled so unfortunately I don't think there's any way to get a pony 
here.
