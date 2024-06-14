Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FA241922FA;
	Fri, 14 Jun 2024 09:42:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718358133; cv=none; b=c3cEEu+szBSMNZ8/ICt5/McDn/5vqBs1YWY9O8hTcWsaiZuT7W9z/vXvCqvTUvJJ6po7c2LLRpliY6KDMCW7CJlxKo5CN5GjVdhqVYnhSDsj9Yd15IxjxCdTeZwQeY/wRwm9uAr4Ac7snDJXnGcugMj6PF1rNXCOzS8eo/lV0Ic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718358133; c=relaxed/simple;
	bh=3ZCYct1jR4rbj5YFkVtgr3ow682HEO9o5cI6WRTIIvw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cOeXhVwHmWIRXmQAsmOzhXr1KB4hjvYcD25MO+5k3awruA8TUd0KO6GyGTdzJwQh7x/NLMmj1+XOo18K/Gk/nvbH0c67AeFFuPDpeBcGV3NlaG7o3UMVJScwgY0S4ucZ6IBHh10a5iJD6U2YTHsK8VSRy38pz7mL2iR8kS3SaCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EJvA09pm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EJvA09pm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 750E5C2BD10;
	Fri, 14 Jun 2024 09:42:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718358132;
	bh=3ZCYct1jR4rbj5YFkVtgr3ow682HEO9o5cI6WRTIIvw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=EJvA09pmDh/gnovpyWBFX6R0guny535UTTvibzNCQzNAdb8NbCfBffYAieNBM7rLW
	 0zDKLTVsnfgteER1G6sNXd+N2V3Nm7c8CrvKNK0LiNOrzNMXRIiCn1B8moyUg9POpF
	 2i3XplKVSIRcXvY6682HctTGVCyB5CeVt5pwwgqo=
Date: Fri, 14 Jun 2024 11:42:10 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Alexey Khoroshilov <khoroshilov@ispras.ru>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Dan Moulding <dan@danm.net>, Dave Airlie <airlied@redhat.com>,
	"lvc-project@linuxtesting.org" <lvc-project@linuxtesting.org>
Subject: Re: [PATCH 6.6 267/301] Revert "drm/nouveau/firmware: Fix SG_DEBUG
 error with nvkm_firmware_ctor()"
Message-ID: <2024061447-clamp-pretender-bac9@gregkh>
References: <20240514101032.219857983@linuxfoundation.org>
 <20240514101042.344516025@linuxfoundation.org>
 <1fc2fb82-aad2-8587-cc5a-2076d1f63862@ispras.ru>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1fc2fb82-aad2-8587-cc5a-2076d1f63862@ispras.ru>

On Fri, Jun 14, 2024 at 12:34:02PM +0300, Alexey Khoroshilov wrote:
> On 14.05.2024 13:18, Greg Kroah-Hartman wrote:
> > 6.6-stable review patch.  If anyone has any objections, please let me know.
> 
> A little bit strange situation to add and revert commit in the same
> stable release.
> 
> Is it intentional? Or some scripts should be updated to avoid that?

Totally intentional, otherwise we would notice that the original commit
was not applied later on and try to apply it there again.

thanks,

greg k-h
