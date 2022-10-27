Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76AF87B;
	Thu, 27 Oct 2022 21:03:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C405C433D6;
	Thu, 27 Oct 2022 21:03:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1666904639;
	bh=IpWjvcAKWtmr9r3KTcFTTN+OHQVAquGDM/oYiw7nMnQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NTxMV0vvnMGf/eKY4bycKXsPNm79Hcbd/hluuC81cnXObzTmY612zfJOEmn6+Cvm1
	 5+K/4iLePN5vGB53YOeriq6if+X4m64mFsCWuXEViHt5gi4IPAei9VECG7hagJ6/SY
	 NhfMIyrZKyLnrSuxeg9GbRrm9b8xfFpkI9GnV1rv5YWaJqyXFZuo8vYwyWxLDPNClD
	 y+9FKfGhKV4l47GqhzsCoGrcllKIDFbzFmk5ROCR32A2f0CzCQ3c30eQjrsazi+/ym
	 CJQ487cZvSFuQGrq/gU3NZ6E2W/dmDgwO4EsF/P2d5tuqqehBf/fVIqqgwYqHKBdrF
	 Tp5J8IzWz9YPw==
Date: Thu, 27 Oct 2022 14:03:56 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Jean Delvare <jdelvare@suse.com>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Tom Rix <trix@redhat.com>,
	Quan Nguyen <quan@os.amperecomputing.com>,
	linux-hwmon@vger.kernel.org, linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev, patches@lists.linux.dev
Subject: Re: [PATCH -next] hwmon: (smpro-hwmon) Add missing break in
 smpro_is_visible()
Message-ID: <Y1ryPDF4CD+6gIMY@dev-arch.thelio-3990X>
References: <20221027195238.1789586-1-nathan@kernel.org>
 <20221027210016.GA1938309@roeck-us.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221027210016.GA1938309@roeck-us.net>

On Thu, Oct 27, 2022 at 02:00:16PM -0700, Guenter Roeck wrote:
> On Thu, Oct 27, 2022 at 12:52:38PM -0700, Nathan Chancellor wrote:
> > Clang warns:
> > 
> >   drivers/hwmon/smpro-hwmon.c:378:2: error: unannotated fall-through between switch labels [-Werror,-Wimplicit-fallthrough]
> >           default:
> >           ^
> >   drivers/hwmon/smpro-hwmon.c:378:2: note: insert 'break;' to avoid fall-through
> >           default:
> >           ^
> >           break;
> >   1 error generated.
> > 
> > Clang is a little more pedantic than GCC, which does not warn when
> > falling through to a case that is just break or return. Clang's version
> > is more in line with the kernel's own stance in deprecated.rst, which
> > states that all switch/case blocks must end in either break,
> > fallthrough, continue, goto, or return. Add the missing break to silence
> > the warning.
> > 
> > Fixes: a87456864cbb ("hwmon: Add Ampere's Altra smpro-hwmon driver")
> > Link: https://github.com/ClangBuiltLinux/linux/issues/1751
> > Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> > ---
> >  drivers/hwmon/smpro-hwmon.c | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/drivers/hwmon/smpro-hwmon.c b/drivers/hwmon/smpro-hwmon.c
> > index ee54e21c2c12..667e88b6bae5 100644
> > --- a/drivers/hwmon/smpro-hwmon.c
> > +++ b/drivers/hwmon/smpro-hwmon.c
> > @@ -375,6 +375,7 @@ static umode_t smpro_is_visible(const void *data, enum hwmon_sensor_types type,
> >  				return 0;
> >  		break;
> >  		}
> > +		break;
> 
> The alignment of the break; statement above is also bad, and a default:
> for switch (attr) is missing.

Would you prefer those fixed in the same patch or a separate one?

> >  	default:
> >  		break;
> >  	}
> > 
> > base-commit: 0ffb687b6508c36a17b99bdaf014b38532404182
> > -- 
> > 2.38.1
> > 
