Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A543F139B;
	Thu, 30 Jan 2025 16:26:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738254400; cv=none; b=SIrD8TQXCVrwcavHfTd8S444vbYo/vAORwWdbT5lC6kUhAN5f4a4PH9n/VjaHe6hGmFcUsuRbX6Ec9Jq7H53hI+ibcxTgqYC9qvEoRcpyABuvmpquqgb0qumNgQsaXvgEugM66M27IhGxnIsqvhbQC1q55a7UoZxQSncYY1R+cU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738254400; c=relaxed/simple;
	bh=HN1mRR8TFX8KYO/njRdpKDYUyYE0DKdmMdh/XV3HVtk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RRveI3fnrVjg2O5FShR7pnOASeMXg4oWuk4dlk60VdGHz54vX4WKb1EIjss5NX6AjrD3XR4LjSpNrWaQx6SbPjQG5MZCAsTxQBYrdnyXO2Q2WfyglFuRFJtrupfAlguMV5vbJ1rwn8rCe7bgO0xmHWipgczgFu5Lxrj7qK2dbZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Iv7fcrGV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Iv7fcrGV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4B84C4CED2;
	Thu, 30 Jan 2025 16:26:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738254400;
	bh=HN1mRR8TFX8KYO/njRdpKDYUyYE0DKdmMdh/XV3HVtk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Iv7fcrGVruVe8rsz9Yme4phEnCXenJuV1l067ak10qI/PlGsbQkLRjVckxEvGSZ2q
	 Vd6PVXDhP3IKaNnWL7Cb1F2VmBGIDpaZioqIBHZDuxNEPWqSidJ8XAPf9PkgE+USm0
	 rVnKAWciKRbBuVODwjwfasS31LIlssj0kAUAl7PU=
Date: Thu, 30 Jan 2025 17:26:37 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: =?iso-8859-1?Q?Ma=EDra?= Canal <mcanal@igalia.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Jose Maria Casanova Crespo <jmcasanova@igalia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 082/133] drm/v3d: Ensure job pointer is set to NULL
 after job completion
Message-ID: <2025013044-tipped-discourse-e9e7@gregkh>
References: <20250130140142.491490528@linuxfoundation.org>
 <20250130140145.823285670@linuxfoundation.org>
 <12607ce2-01f3-4fb6-8b50-33a9f7f26381@igalia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <12607ce2-01f3-4fb6-8b50-33a9f7f26381@igalia.com>

On Thu, Jan 30, 2025 at 12:56:25PM -0300, Maíra Canal wrote:
> Hi Greg,
> 
> This patch introduced a race-condition that was fixed in
> 6e64d6b3a3c39655de56682ec83e894978d23412 ("drm/v3d: Assign job pointer
> to NULL before signaling the fence") - already in torvalds/master. Is it
> possible to push the two patches together? This way we wouldn't break
> any devices.

As all 5.15 and newer devices are broken right now, that's not good :(

> If possible, same thing for 5.4.

Ok, let me queue it up now, thanks.

greg k-h
