Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9483271449;
	Mon,  3 Nov 2025 01:42:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762134136; cv=none; b=Yyp5vBUdMpCpRGEGHs3122rIVGoISQYYnEdGFR6Kk22eHffdWdBxZT1AiCjqiAXxJ19ZgXHtntz3KaMD9vG7AfQBr+SaiUE1I0XDyVDrAZDe0PVLjShx1W7EZ4HVzyoiny55fZSyOPnpK+x2oqUw2LquWYxkXFc80yU9p/ppx3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762134136; c=relaxed/simple;
	bh=7DyJ0mgP+/dhoWWLx9uhqYps1Z/ilfTcOoyMFH3j4FE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Kk9HVFMbIBdhZAtygEvpCX8OB2RT+C1EA4oVJJ12iSLv+SThZr583lO3/t3F1m9xNE5mYifyxTEgKkOKZs/8Hb6br4a3rKgt5lbSl72uyW/1Sl5/3sNa23zT7LNtyJfvfZ5FSvJCLwGWGC0rcnOiArlegpCG4Uu0gpJnCNCLK/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YC8S9U37; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YC8S9U37"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6645BC4CEF7;
	Mon,  3 Nov 2025 01:42:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762134136;
	bh=7DyJ0mgP+/dhoWWLx9uhqYps1Z/ilfTcOoyMFH3j4FE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YC8S9U37UUIECwLBVkStspoLdcPWsL9YmaoaeNn2WtsdZj83ZDHXYF/dbmHEHKP9f
	 yUns3JGpiX8o380o5sK6peFqMgOwfd/g0H/nN4PcS1jltPTih0VMR4b1P+eEOm1v7c
	 fs+ItA3sxzrv0nGtb/U7qkM51uxY300h8IB27kNk=
Date: Mon, 3 Nov 2025 10:42:14 +0900
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Eric Biggers <ebiggers@google.com>
Subject: Re: [PATCH 5.10 171/332] lib/crypto/curve25519-hacl64: Disable KASAN
 with clang-17 and older
Message-ID: <2025110304-footbath-unearned-6bfb@gregkh>
References: <20251027183524.611456697@linuxfoundation.org>
 <20251027183529.142271445@linuxfoundation.org>
 <67ef17680d4e107847c688f9bb7fa45f4e6b51a3.camel@decadent.org.uk>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <67ef17680d4e107847c688f9bb7fa45f4e6b51a3.camel@decadent.org.uk>

On Fri, Oct 31, 2025 at 08:47:23PM +0100, Ben Hutchings wrote:
> On Mon, 2025-10-27 at 19:33 +0100, Greg Kroah-Hartman wrote:
> > 5.10-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Nathan Chancellor <nathan@kernel.org>
> > 
> > commit 2f13daee2a72bb962f5fd356c3a263a6f16da965 upstream.
> [...]
> > --- a/lib/crypto/Makefile
> > +++ b/lib/crypto/Makefile
> > @@ -22,6 +22,10 @@ obj-$(CONFIG_CRYPTO_LIB_CURVE25519_GENER
> >  libcurve25519-generic-y				:= curve25519-fiat32.o
> >  libcurve25519-generic-$(CONFIG_ARCH_SUPPORTS_INT128)	:= curve25519-hacl64.o
> >  libcurve25519-generic-y				+= curve25519-generic.o
> > +# clang versions prior to 18 may blow out the stack with KASAN
> > +ifeq ($(call clang-min-version, 180000),)
> [...]
> 
> The clang-min-version macro isn't defined in 5.10 or 5.15, so this test
> doesn't work as intended.

So should I revert it?

thanks,

greg k-h
