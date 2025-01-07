Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26E8D1E573B;
	Tue,  7 Jan 2025 10:39:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736246376; cv=none; b=kRuMtqbHKiFMaQ7KZzbeW7atgJgDuP+zBO5SQh951gKzT9pWozxqFFH4/V8EEyXFe+iwUPxUpdZmN3V4Dx8F+UZj886y8E6kFfHc4+bcwqh2yOfrwwSsIGx+iJeuV1exUFmk27r5XykA/jGK3c1hT3TkqV5PKZszDccZyQtUjhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736246376; c=relaxed/simple;
	bh=0UtoztvkGqO74lDBXkcUkB7JSpBiKVH6jVMstbnte4U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cR+7DKwXlucjBeh3fmPHiHtWSH3qTUAOc5idyDrWs6CoLhP3rZdFCYsC1ekPpp9HnE2nHvJ3PVuhNwt1gJgO155zZoNcQejK9TyuOjOMzP5Tt9LikO82e/RiQ+2iG5hVvwjvCcYb/ikL6l25K8sIjozbCGm3CB9c7oAFdsTk3jk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jpfIcCH3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jpfIcCH3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26D14C4CEDD;
	Tue,  7 Jan 2025 10:39:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736246375;
	bh=0UtoztvkGqO74lDBXkcUkB7JSpBiKVH6jVMstbnte4U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jpfIcCH3Bneqgna3SeS1sg8rBPN+RnK2xfhtZVD7bhbefvy5699TzibpSqQQ8ez3B
	 UGVQsMKzdCVnGT+JRIr/GI3p62BKNIId7S8WyuhHmMZ+rv5AkElrYYgcGhqEEPsKLG
	 NvEJ5+Rtw9PP4NauzUPZAsl0XzZSuI9NjsQQP0Wk=
Date: Tue, 7 Jan 2025 11:39:32 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Cc: patches@lists.linux.dev,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH 6.6 027/222] cleanup: Adjust scoped_guard() macros to
 avoid potential warning
Message-ID: <2025010725-cartoon-semantic-da14@gregkh>
References: <20250106151150.585603565@linuxfoundation.org>
 <20250106151151.629422119@linuxfoundation.org>
 <35ac0170-8979-4047-9b11-cd2c9ffea014@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <35ac0170-8979-4047-9b11-cd2c9ffea014@intel.com>

On Tue, Jan 07, 2025 at 11:01:23AM +0100, Przemek Kitszel wrote:
> On 1/6/25 16:13, Greg Kroah-Hartman wrote:
> > 6.6-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Przemek Kitszel <przemyslaw.kitszel@intel.com>
> > 
> > [ Upstream commit fcc22ac5baf06dd17193de44b60dbceea6461983 ]
> > 
> > Change scoped_guard() and scoped_cond_guard() macros to make reasoning
> > about them easier for static analysis tools (smatch, compiler
> > diagnostics), especially to enable them to tell if the given usage of
> > scoped_guard() is with a conditional lock class (interruptible-locks,
> > try-locks) or not (like simple mutex_lock()).
> > 
> 
> please also consider cherry pick of the commit 9a884bdb6e95 ("iio:
> magnetometer: fix if () scoped_guard() formatting") when picking
> the one in the subject

Did you try to apply that commit to the 6.6.y tree?  If you have it
working, please send us the correct backport because as-is, it does not
apply at all.

thanks,

greg k-h
