Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99D2F6AD6;
	Wed,  8 Mar 2023 13:44:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0A51C433EF;
	Wed,  8 Mar 2023 13:44:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678283072;
	bh=T3BhXhqPw1Ry5pwlB5UiFGpWEf72+tgetxv/kX5mlgg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FcNZcVXEAaLi4NRN1qlE+ZupXqhjP6RES1lwgbBgCydVaOPY4o4W+riai+/EIL/i3
	 y3KTI42/0CVIgnPCXjWndoVR1YRAxLIwOzEieAt0OiHMzGNDoXrk8KsqbHiZLb3r+i
	 w+W7+2nOZM9ZWFg2axT41JJpClFtvRwrI0VWyk0w=
Date: Wed, 8 Mar 2023 14:44:29 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Hans de Goede <hdegoede@redhat.com>
Cc: linux-staging@lists.linux.dev, linux-kernel@vger.kernel.org,
	patches@lists.linux.dev, Martin Kaiser <martin@kaiser.cx>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Phillip Potter <phil@philpotter.co.uk>,
	Pavel Skripkin <paskripkin@gmail.com>
Subject: Re: [PATCH] staging: r8188eu: delete driver
Message-ID: <ZAiRPbXff1f27HUz@kroah.com>
References: <20230308131934.380395-1-gregkh@linuxfoundation.org>
 <92a9442a-cece-4179-fbdc-3c9188da073e@redhat.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="VY891N1Axxtm6cyk"
Content-Disposition: inline
In-Reply-To: <92a9442a-cece-4179-fbdc-3c9188da073e@redhat.com>


--VY891N1Axxtm6cyk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Mar 08, 2023 at 02:26:39PM +0100, Hans de Goede wrote:
> Hi All,
> 
> > Now that the same hardware that the r8188eu driver supported is
> > supported by the real wireless driver rtl8xxxu, the r8188eu driver can
> > be deleted.
> >
> > Also the rtl8xxxu driver supports way more devices, and is a fraction of
> > the overall size, making this a much better overall solution.
> >
> > Thanks to the r8188eu developers and maintainers and reviewers over the
> > years, your work allowed Linux users to use their hardware before the
> > real driver was implemented properly.
> >
> > Reported-by: Hans de Goede <hdegoede@redhat.com>
> > Cc: Martin Kaiser <martin@kaiser.cx>
> > Cc: Larry Finger <Larry.Finger@lwfinger.net>
> > Cc: Phillip Potter <phil@philpotter.co.uk>
> > Cc: Pavel Skripkin <paskripkin@gmail.com>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> Thank you for doing this, I agree that this is the best solution
> moving forward:
> 
> Acked-by: Hans de Goede <hdegoede@redhat.com>

Great!

Also, to verify the "these devices are supported", I compared the list
of module aliases exported by both drivers.  The r8188eu is a tiny
subset of the rtl8xxxu driver, with no devices listed in the r8188eu
that are not in the rtl8xxxu driver.

Attached are the lists of the vendor/product USB ids for each driver as
proof.

thanks,

greg k-h

--VY891N1Axxtm6cyk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="r8188eu.devices"

v056Ep4008
v07B8p8179
v0B05p18F0
v0BDAp0179
v0BDAp8179
v0BDApFFEF
v0DF6p0076
v2001p330F
v2001p3310
v2001p3311
v2001p331B
v2357p010C
v2357p0111
v2C4Ep0102
v7392pB811

--VY891N1Axxtm6cyk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="rtl8xxxu.devices"

v04BBp094C
v04BBp0950
v04F2pAFF7
v04F2pAFF8
v04F2pAFF9
v04F2pAFFA
v04F2pAFFB
v04F2pAFFC
v050Dp1004
v050Dp1102
v050Dp2102
v050Dp2103
v056Ep4008
v0586p341F
v06F8pE033
v06F8pE035
v0789p016D
v07AAp0056
v07B8p8178
v07B8p8179
v07B8p8189
v0846p9021
v0846p9041
v0846pF001
v0B05p17AB
v0B05p17BA
v0B05p18F0
v0BDAp0179
v0BDAp018A
v0BDAp0724
v0BDAp1724
v0BDAp1E1E
v0BDAp2E2E
v0BDAp317F
v0BDAp5088
v0BDAp8170
v0BDAp8176
v0BDAp8177
v0BDAp8178
v0BDAp8179
v0BDAp817A
v0BDAp817B
v0BDAp817D
v0BDAp817E
v0BDAp817F
v0BDAp818A
v0BDAp818B
v0BDAp818C
v0BDAp8191
v0BDAp8724
v0BDApB720
v0BDApF179
v0BDApFFEF
v0DF6p0052
v0DF6p005C
v0DF6p0061
v0DF6p0070
v0DF6p0076
v0E66p0019
v0E66p0020
v0EB0p9071
v103Cp1629
v1058p0631
v13D3p3357
v2001p3307
v2001p3308
v2001p3309
v2001p330A
v2001p330B
v2001p330F
v2001p3310
v2001p3311
v2001p3319
v2001p331B
v2019p1201
v2019p4902
v2019pAB2A
v2019pAB2B
v2019pAB2E
v2019pAB33
v2019pED17
v20F4p624D
v20F4p648B
v2357p0100
v2357p0107
v2357p0108
v2357p0109
v2357p010C
v2357p0111
v2C4Ep0102
v4855p0090
v4855p0091
v4856p0091
v7392p7811
v7392p7822
v7392pA611
v7392pB811
vCDABp8010

--VY891N1Axxtm6cyk--
