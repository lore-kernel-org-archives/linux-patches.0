Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDEA01CCB26;
	Wed,  4 Sep 2024 09:35:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725442502; cv=none; b=lzYKuHoh8omzkq4ewu4Anwf9EmLLtmOYlewHSuSl7Hd4QcZLPdMB/6CY1lI2fUT3vDFKP/GZggShQqHc1WZ0X0+GkHzORHbocW4Whp2XvDAwIsc7Onmv77yWkEGvufLOWZ36/cAXT2+0H3/CkSzJsEwmnP4WEaUZufh4jqANlFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725442502; c=relaxed/simple;
	bh=etQsRFqDOsSDuim1MqlIjuHK2o6JooOUeqtKdpk9YhA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=a9Ws9aPgypjIxf24Gg9e9LBOAZ8yGDYvuONjk6FbRXetccO4DVcGMjOUVxIM99F2fTSMzjC4K0g0bDIhKMWAZDjA1H0UwA2f/dm6D2itmUsfiK9mAXN5LDqyqVOGX5Wr6It/rut7nc8VQUnHbH95WlfDK9A57NDn8ajaCRABDsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OyJjmxxv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OyJjmxxv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A9ABC4CEC2;
	Wed,  4 Sep 2024 09:35:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725442502;
	bh=etQsRFqDOsSDuim1MqlIjuHK2o6JooOUeqtKdpk9YhA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OyJjmxxvq0GnhUm6Elst4+tsbJu78CeKW3/TV7Fl2dmKCHOUdXUusfvJ1APwx9nRI
	 mFNLIQwcf7FEC2K1IwCArgfV0gC9yF7NfxOqu4Mg3g1lRPoY4DdIbGn/+0QCsIQl45
	 ZBjEs4Rqw6xWe47VQAKXFsX3MoB1+ubpQdug0lBk=
Date: Wed, 4 Sep 2024 11:34:59 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.15 187/215] ksmbd: the buffer of smb2 query dir
 response has at least 1 byte
Message-ID: <2024090406-uncertain-casket-d946@gregkh>
References: <20240901160823.230213148@linuxfoundation.org>
 <20240901160830.426516431@linuxfoundation.org>
 <CAKYAXd_UvscfaXpnoJNv2GEeDU0sUfg3_=gG7VX7My60EzXgfA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKYAXd_UvscfaXpnoJNv2GEeDU0sUfg3_=gG7VX7My60EzXgfA@mail.gmail.com>

On Tue, Sep 03, 2024 at 08:16:07AM +0900, Namjae Jeon wrote:
> On Mon, Sep 2, 2024 at 2:07 AM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> Hi Greg,
> > 5.15-stable review patch.  If anyone has any objections, please let me know.
> Please drop this patch.
> I told you this patch was required for 6.1 kernel versions or later in
> previous mail.

This was added because commit eb3e28c1e89b ("smb3: Replace smb2pdu
1-element arrays with flex-arrays") has been backported to 5.15 and 5.10
stable kernels.

But hey, I'll go drop it now, and will be glad to add it back later if
needed.

thanks,

greg k-h
