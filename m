Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61A3E42125B;
	Mon, 14 Sep 2026 09:43:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789378983; cv=none; b=XDvyiY0fb2ic8Tb9+SMM8ELvvfruM+9Jk9pXxSYXkZcDFSfctie0eaZjIHXnah8f96vbG85tsYk8nYI2fpx4DO7IP3/Lodxyj8l5ye3i86weRqMX6/NaDdN4JbWDkF2ihAbox2AvNWT6w3FmYqOGzuBW5g9Jmgex42SUyinpFzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789378983; c=relaxed/simple;
	bh=o2hzGVCizd4BCq78guFMds11B3XoGYMBrAXgwtExwOA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Jml0g9dXcyAEPvmZFYR6TuHOyPQMsxXsS03iqXNwMQTevk6rIStRoyaWEOp57XhiWX5rxgB9mleDzDlViih2NSn18yGNOKs/b8VdBbVxjQdJFjrdPigy4OaQtFft1miqOadXQ9hflCGWLSNeY93ofFxU2C/+ynT8OEMG2znbA/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bhtYly/0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bhtYly/0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C59C61F00899;
	Mon, 14 Sep 2026 09:43:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789378982;
	bh=i7JtPoa7gn7yBN1Ybavx4DAM5d9leKjt5ow5O+x60mM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=bhtYly/04Yn+q16wLdzUf1hDnV0Je5gsOmUzdTUCmnO97E4dO0q34wUJvTondXjAi
	 XRyAv7kStTTKVg0Ffqi1aAryrpUw9HIflrslJ8WT0CiVYeqY2XIUfhmQmoXmKLkSh3
	 KP9A1G0XX0ljg7r4DWwpLrpxZHXcZRMytOJG0pNg=
Date: Mon, 14 Sep 2026 11:42:52 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.18 0937/1518] gpiolib: move legacy interface into
 linux/gpio/legacy.h
Message-ID: <2026091443-garland-hamster-710b@gregkh>
References: <20260912065623.398859879@linuxfoundation.org>
 <20260912065644.647595753@linuxfoundation.org>
 <d6c294c1-4e40-4646-b5f1-065a3a9b16a4@app.fastmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d6c294c1-4e40-4646-b5f1-065a3a9b16a4@app.fastmail.com>

On Sat, Sep 12, 2026 at 12:57:36PM +0200, Arnd Bergmann wrote:
> On Sat, Sep 12, 2026, at 08:51, Greg Kroah-Hartman wrote:
> > 6.18-stable review patch.  If anyone has any objections, please let me know.
> >
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> > Link: https://patch.msgid.link/20260428154522.2861492-1-arnd@kernel.org
> > Signed-off-by: Bartosz Golaszewski 
> > <bartosz.golaszewski@oss.qualcomm.com>
> > Stable-dep-of: 942901eeda93 ("leds: gpio: Clear error pointers for 
> > skipped LEDs")
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > ---
> >  include/linux/gpio.h        | 162 +--------------------------------
> >  include/linux/gpio/legacy.h | 173 ++++++++++++++++++++++++++++++++++++
> >  2 files changed, 177 insertions(+), 158 deletions(-)
> >  create mode 100644 include/linux/gpio/legacy.h
> 
> I don't see how this would related to 942901eeda93, this only moves code
> around that is not touched by that patch.

Odd, yeah, that's not needed, now dropped, thanks!

greg k-h
