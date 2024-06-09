Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 942B824B2A;
	Sun,  9 Jun 2024 11:09:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717931399; cv=none; b=Z41TNrnxIENrLK9UVau81lw3qeioXIcfmw3pN0u3Tvs8DLGpkrbeZHzUzP3wVQBloX+jZUG8WcHxMoFZv6onKwIrc3Y8iZ6CNqTgUbF3z5BU60PMfAy02GVNA7TGuKBZNIOGkeoSlWPLOMprZTYrNwDDaM83xVAKa8IHz39f0eE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717931399; c=relaxed/simple;
	bh=2Ko3ps3LZjszOKOefDuKRAuFihzdn8nmuK+IH+1AQds=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VA93ekSE+AgiM3k6lqsoKNJsM1teGPp4TpHXxW80r/rKlDBS9VNqRvuiGgY93mixmSez0DYMJrZPk8QWIgmon0Z4ZZTuK0CXnYDi3WE3eg03dFPgH96xGLVuXqWYFSgBKmkXRLB34/Ie+vZube+OD39RxfBxUGZo5Ku8gQ2trrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j2qANVHa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j2qANVHa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC0D6C2BD10;
	Sun,  9 Jun 2024 11:09:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717931399;
	bh=2Ko3ps3LZjszOKOefDuKRAuFihzdn8nmuK+IH+1AQds=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=j2qANVHaKhUuJu5ia5q7bsFdBloxKdp2KVESNMt79l0ZS8cr0urLzgWtBpgVQN0K1
	 Vcb4sRrQGwpc8x1Pmx13ndQnxuS7Q1N+tCsbFGJcnzq+GDHzGW0MxA107MMyCzG/tO
	 2QH2f4k0EezQkc0PbNEuZQRvy79JraxvmHAnD0VA=
Date: Sun, 9 Jun 2024 13:09:56 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Armin Wolf <W_Armin@gmx.de>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.6 307/744] platform/x86: xiaomi-wmi: Fix race condition
 when reporting key events
Message-ID: <2024060947-mayflower-trickster-9292@gregkh>
References: <20240606131732.440653204@linuxfoundation.org>
 <20240606131742.234515336@linuxfoundation.org>
 <f48f7d3b-fd25-4d34-9689-dab225d29aff@gmx.de>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f48f7d3b-fd25-4d34-9689-dab225d29aff@gmx.de>

On Fri, Jun 07, 2024 at 07:29:40AM +0200, Armin Wolf wrote:
> Am 06.06.24 um 15:59 schrieb Greg Kroah-Hartman:
> 
> > 6.6-stable review patch.  If anyone has any objections, please let me know.
> 
> Hi,
> 
> i already said that the underlying race condition can only be triggered since
> commit e2ffcda16290 ("ACPI: OSL: Allow Notify () handlers to run on all CPUs"),
> which afaik was introduced with kernel 6.8.
> 
> Because of this, i do not think that we have to backport this commit to kernels
> before 6.8.

Now dropped from all queues, thanks.

greg k-h
