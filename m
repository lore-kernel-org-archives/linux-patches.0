Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFB0E18C322;
	Fri, 15 Nov 2024 09:27:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731662873; cv=none; b=njonGseXDaHvM6idw0i27hLibP+o5BU6ozsuUhftxmMQ7ovnhy2XC05jOCdTZ88/zvwMrVATxhee+UV1lBQN0lbEd5CMkZxjgRnmVMm43fX0V2FBgLJbhpue07jvwLehWfbgIfxB5IyXtpKGw6vxAeDDpN2vuAZxkQmgRdkNYcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731662873; c=relaxed/simple;
	bh=mg83la0+yDt2i+9t2hMD4P4lI7sOjoyj28c2ogmN+Cg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kR5sEo1JiaUvJuLc1cqSPBKHLg8fTi5OurPek5Mikv6HR1AfBeiv961zRSr6DnMl7uZ+QFa1HpYJuvBULdJDagM0XlosmS3P1LCD/4uqwxuCzIah5mdh2iTvZSVjmjfKJGtWkg4Ct4dPTB7ya/d5TYfF50tshpDSSPDsfsWu+lw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2lL1c4ui; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2lL1c4ui"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC8ACC4CECF;
	Fri, 15 Nov 2024 09:27:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731662873;
	bh=mg83la0+yDt2i+9t2hMD4P4lI7sOjoyj28c2ogmN+Cg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=2lL1c4uiOFJ/EGpdRbGOJ7MVrWBXTCeuemVaBSQ/taXvatFdypi7pfIkYJdScS/6b
	 eaX7gglU23/QFKRX257aJVP9tvYykQyTC80kRDSskGZQUDS5/ieHdjGWYWTrx1RVJP
	 SOXvge8DLFMboNRrhp86/vnNEqVm8ex99R8aDSfw=
Date: Fri, 15 Nov 2024 10:27:49 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jiri Slaby <jslaby@suse.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Mark Rutland <mark.rutland@arm.com>,
	syzbot+908886656a02769af987@syzkaller.appspotmail.com,
	Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.11 25/63] kasan: Disable Software Tag-Based KASAN with
 GCC
Message-ID: <2024111551-uncouple-pug-fee4@gregkh>
References: <20241115063725.892410236@linuxfoundation.org>
 <20241115063726.828422420@linuxfoundation.org>
 <a01c8667-1de5-4f3e-b15d-cd765238a538@suse.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a01c8667-1de5-4f3e-b15d-cd765238a538@suse.com>

On Fri, Nov 15, 2024 at 07:55:11AM +0100, Jiri Slaby wrote:
> On 15. 11. 24, 7:37, Greg Kroah-Hartman wrote:
> > 6.11-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Will Deacon <will@kernel.org>
> > 
> > [ Upstream commit 7aed6a2c51ffc97a126e0ea0c270fab7af97ae18 ]
> 
> But we have:
>   894b00a3350c kasan: Fix Software Tag-Based KASAN with GCC
> in 6.11.7.
> 
> This 7aed6a2c51f was reverted right after that 894b00a3350c by:
>   237ab03e301d Revert "kasan: Disable Software Tag-Based KASAN with GCC"
> 
> IMO, drop and blacklist this patch.

Ok, will do, thanks for noticing!

greg k-h
