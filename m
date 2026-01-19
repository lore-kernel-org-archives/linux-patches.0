Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D3FA35293E;
	Mon, 19 Jan 2026 11:14:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768821267; cv=none; b=j2NKiZCyIwuI67kV/EL0c3APGuTMh9mpQEnIJ6P8sECr35qUQf/mUs+VpiQRjWa9EpR6M225oZ//4oz/6KewS6mQlV5tL1XFqFg+ABaeAluPUy/YeElxQ/fWmNXyD7kzXljHvXV0wLkMxJWHMuOEMYM+DloggZGq8PTFH+/htfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768821267; c=relaxed/simple;
	bh=IDHGwUYov3TFysdOj69gbf74V050BVsTKwN0yWC8CgY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QCXWj8pSV4UXUcDKiM/UW4cdegrUOufhq2PasRyuI0b33d2bE8qeEcrwZmGi+zzQfjpgwhDc0YxnltlhAxQ+NGkrBMNxX4p39EPtm37HTq6VKQ+kGrSFx1HMD6G1PSwikmTAPdXXS27N7IWLfVv1Hy17wE4Cebk8uAQSYb+olhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ycC5QECu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ycC5QECu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D861EC116C6;
	Mon, 19 Jan 2026 11:14:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768821267;
	bh=IDHGwUYov3TFysdOj69gbf74V050BVsTKwN0yWC8CgY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ycC5QECugumsh8Aes0gzRbpbr0BlL8uiHgO7W82IKi83BSiYtBOTjSr7iQ7PtnGa0
	 aNiZgyvLRKVi2yS1hOkvv0FhPragIqDBLkwyCNgreOt4GM56b/jt3PQOwV1IyWqR/N
	 VRDTkCbcLa21XuvOBrdkLeeekGXtTzYNop+jK8Yg=
Date: Mon, 19 Jan 2026 12:14:24 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Duoming Zhou <duoming@zju.edu.cn>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: Re: [PATCH 5.10 324/451] media: TDA1997x: Remove redundant
 cancel_delayed_work in probe
Message-ID: <2026011905-progeny-muppet-d537@gregkh>
References: <20260115164230.864985076@linuxfoundation.org>
 <20260115164242.620539205@linuxfoundation.org>
 <df0940555d70eb912f2962a70b59270d0f579b9b.camel@decadent.org.uk>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <df0940555d70eb912f2962a70b59270d0f579b9b.camel@decadent.org.uk>

On Sun, Jan 18, 2026 at 03:05:36PM +0100, Ben Hutchings wrote:
> On Thu, 2026-01-15 at 17:48 +0100, Greg Kroah-Hartman wrote:
> > 5.10-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Duoming Zhou <duoming@zju.edu.cn>
> > 
> > commit 29de195ca39fc2ac0af6fd45522994df9f431f80 upstream.
> > 
> > The delayed_work delayed_work_enable_hpd is initialized with
> > INIT_DELAYED_WORK(), but it is never scheduled in tda1997x_probe().
> > 
> 
> It seems like it can be scheduled as soon as the probe function calls
> v4l2_async_register_subdev().
> 
> > Calling cancel_delayed_work() on a work that has never been
> > scheduled is redundant and unnecessary, as there is no pending
> > work to cancel.
> > 
> > Remove the redundant cancel_delayed_work() from error handling
> > path in tda1997x_probe() to avoid potential confusion.
> 
> I don't believe this is redundant at all.
> 
> In any case, this doesn't seem to be a candidate for stable since a
> redundant cancel_delayed_work() is harmless.

Let's leave this as that's what is in Linus's tree, and the other stable
releases.

thanks,

greg k-h
