Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DB602EFDA2;
	Mon, 12 Jan 2026 10:54:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768215298; cv=none; b=cpcGK5lM21LcymZlIjvXKbqoOqfA6zHH7IuDwpv89Ubgx2+5zC7sawAYnKf4Du9VFJnAAWoBtXUdYvZLIUPufQ9r1YiUJR9SLV2zUdvUj5TsjZTwJlXDFggNGW/XuC7OT/LFIY6jrsxd8sqL4sVgqA1rywFXKIjdJbmp+qCyCTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768215298; c=relaxed/simple;
	bh=hhWJFA+5gdnhWFuBhiWppXhxrKk0LhnJg8KFP+xKb/o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cKmuLgf8pPoXIjHmo1QiIB/fmuiGLCfxlFlvPLfEqC0i3PE5h28Gf3oEHqqVEMMf0v+ilrh8xe9+5Wl/ZI8ciELCpEaM65LeNP9j5Ll19VweJF+10nRWVzWOn/DgLDehpbFBhd2oagQfEaCUReGsw0XOThVYyKhGUTz2AKGFC3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zn2QbWy0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zn2QbWy0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05048C19422;
	Mon, 12 Jan 2026 10:54:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768215297;
	bh=hhWJFA+5gdnhWFuBhiWppXhxrKk0LhnJg8KFP+xKb/o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Zn2QbWy07QNYBYo4rV2F6B3MVBWkQBGPHdCZ8/m2o4w4neivvcIt2NswrXeJcHufx
	 RwL4Cd2qoCOf2/5j0z/7+Fro5BrYF2Xv8Ym5ARSVQ209YKA9JEY2fdhJD3TlNotD8h
	 URsUjKONteo4dgy4n54cgE+gcVZvCnrjSP1Vn3As=
Date: Mon, 12 Jan 2026 11:54:54 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Askar Safin <safinaskar@gmail.com>
Cc: Sasha Levin <sashal@kernel.org>, patches@lists.linux.dev,
	stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	kai.vehmanen@linux.intel.com, cezary.rojewski@intel.com,
	ranjani.sridharan@linux.intel.com, rf@opensource.cirrus.com,
	bradynorander@gmail.com
Subject: Re: [PATCH AUTOSEL 6.18-6.17] ALSA: hda: intel-dsp-config: Prefer
 legacy driver as fallback
Message-ID: <2026011237-stage-cognitive-53c0@gregkh>
References: <20251215004145.2760442-1-sashal@kernel.org>
 <20251215004145.2760442-3-sashal@kernel.org>
 <CAPnZJGD0ifVdHTRcMzKBFX8UEf_me1KTrkbwezZrhzndcTx-3Q@mail.gmail.com>
 <aV5Ap8TgMEDLucWR@laps>
 <CAPnZJGCJ1LZRzfzO=958EfcrLm4Z3pYdtHZEpp812fstsUcOAQ@mail.gmail.com>
 <2026011119-stadium-trilogy-22ac@gregkh>
 <CAPnZJGAXLEgqKx+XA3RugES1kcawtqMEYPTzFERcf2kgRjNbFQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPnZJGAXLEgqKx+XA3RugES1kcawtqMEYPTzFERcf2kgRjNbFQ@mail.gmail.com>

On Sun, Jan 11, 2026 at 07:01:53PM +0300, Askar Safin wrote:
> On Sun, Jan 11, 2026 at 3:24 PM Greg KH <gregkh@linuxfoundation.org> wrote:
> > > You mean that 82d9d54a6c0e is in all trees? Okay, then,
> > > please, backport 161a0c617ab172bbcda7ce61803addeb2124dbff
> > > to all trees.
> >
> > Why?  I see no context here :(
> 
> Please, backport 161a0c617ab1 to all stable kernels, which have 82d9d54a6c0e.
> 
> 161a0c617ab1 fixes bug, reported by me here:
> https://lore.kernel.org/all/20251014034156.4480-1-safinaskar@gmail.com/ .
> 
> I did bisect and found that 2d9223d2d64c is the culprit. But then Takashi Iwai
> explained that the bug appeared earlier:
> https://lore.kernel.org/all/87345iebky.wl-tiwai@suse.de/ .
> Iwai said: "the bug itself was introduced
> from the very beginning, and it could hit earlier".
> 
> I assume "the very beginning" here should be interpreted as
> "commit, where intel-dsp-config.c appeared", because the fix
> modifies "intel-dsp-config.c".
> 
> "intel-dsp-config.c" introduced in 82d9d54a6c0e, so
> 161a0c617ab1 should be backported to all kernels, which
> have 82d9d54a6c0e.

This only applies to one tree (6.18.y), can you provide working
backports for all of the other stable trees?

thanks,

greg k-h
