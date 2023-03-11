Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 444A77B;
	Sat, 11 Mar 2023 12:19:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7484DC433EF;
	Sat, 11 Mar 2023 12:19:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678537177;
	bh=4sbylCb/mm440LN5XYoNkavJNTXzJfG4XaJMNkX4Tk0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HPzZiremg3kg23hgzi99VDF/vuDf7YHzI0EHaerOR9XsW4tPTZJypltYSvtQJFuQq
	 cvjRui7W1IJariS4PoGQiCZjK3xh/O0H3R9m8trdBZF+uveLSfJCY7dtfw0hS3zqPp
	 ogvQKez3UVTkJdJXd0kUAE5Yqsdg3RN6omDjUP4Q=
Date: Sat, 11 Mar 2023 13:19:34 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Phillip Potter <phil@philpotter.co.uk>
Cc: linux-staging@lists.linux.dev, linux-kernel@vger.kernel.org,
	patches@lists.linux.dev, Hans de Goede <hdegoede@redhat.com>,
	Martin Kaiser <martin@kaiser.cx>,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH] staging: r8188eu: delete driver
Message-ID: <ZAxx1kYjVKFRE3kz@kroah.com>
References: <20230308131934.380395-1-gregkh@linuxfoundation.org>
 <660ef0b7-fb09-5a72-57b1-3b57ddee924e@gmail.com>
 <ZAxZCJn7AN/yWSRh@equinox>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZAxZCJn7AN/yWSRh@equinox>

On Sat, Mar 11, 2023 at 10:33:44AM +0000, Phillip Potter wrote:
> On Fri, Mar 10, 2023 at 10:08:49PM +0300, Pavel Skripkin wrote:
> > Hi Greg,
> > 
> > Greg Kroah-Hartman <gregkh@linuxfoundation.org> says:
> > > Now that the same hardware that the r8188eu driver supported is
> > > supported by the real wireless driver rtl8xxxu, the r8188eu driver can
> > > be deleted.
> > > 
> > > Also the rtl8xxxu driver supports way more devices, and is a fraction of
> > > the overall size, making this a much better overall solution.
> > > 
> > > Thanks to the r8188eu developers and maintainers and reviewers over the
> > > years, your work allowed Linux users to use their hardware before the
> > > real driver was implemented properly.
> > > 
> > > Reported-by: Hans de Goede <hdegoede@redhat.com>
> > > Cc: Martin Kaiser <martin@kaiser.cx>
> > > Cc: Larry Finger <Larry.Finger@lwfinger.net>
> > > Cc: Phillip Potter <phil@philpotter.co.uk>
> > > Cc: Pavel Skripkin <paskripkin@gmail.com>
> > > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > ---
> > 
> > I guess, I am late to the party, but if it matters
> > 
> > Acked-by: Pavel Skripkin <paskripkin@gmail.com>
> > 
> > 
> > 
> > 
> > With regards,
> > Pavel Skripkin
> 
> Same here, won't make it into the deletion commit log entry, but:
> 
> Acked-by: Phillip Potter <phil@philpotter.co.uk>

Thanks, the link in the commit will point to this thread for the
archives, so it still does matter :)

greg k-h
