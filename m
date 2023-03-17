Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68A0E62D
	for <patches@lists.linux.dev>; Fri, 17 Mar 2023 03:30:13 +0000 (UTC)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
	id 1pd0mm-005att-HO; Fri, 17 Mar 2023 11:29:45 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 17 Mar 2023 11:29:44 +0800
Date: Fri, 17 Mar 2023 11:29:44 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: davem@davemloft.net, ebiederm@xmission.com,
	linux-crypto@vger.kernel.org, keescook@chromium.org,
	yzaikin@google.com, j.granados@samsung.com, patches@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: simplify one-level sysctl registration for
 crypto_sysctl_table
Message-ID: <ZBPeqNByhWkpkDv/@gondor.apana.org.au>
References: <20230310232150.3957148-1-mcgrof@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230310232150.3957148-1-mcgrof@kernel.org>

On Fri, Mar 10, 2023 at 03:21:50PM -0800, Luis Chamberlain wrote:
> There is no need to declare an extra tables to just create directory,
> this can be easily be done with a prefix path with register_sysctl().
> 
> Simplify this registration.
> 
> Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
> ---
> 
> If not clear, see this new doc:
> 
> https://lore.kernel.org/all/20230310223947.3917711-1-mcgrof@kernel.org/T/#u     
> 
> But the skinny is we can deprecate long term APIs from sysctl that
> uses recursion.
> 
>  crypto/fips.c | 11 +----------
>  1 file changed, 1 insertion(+), 10 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
