Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90627522F;
	Thu,  5 Dec 2024 03:48:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733370492; cv=none; b=tQEtsSexaZVWzE2Q2/jnEaqZVpEuiPVVtpS1EcLYDERitJkMO7a7OwSgIHdCJwcRC/va4kKS1dh4DOeV0SoLX+6zNlSOfPcvBFMrv577qOHcLCnJUJ3Ph2CQvkubcFBM+pwN2ssucbv0lW9ofj4403HRFOn7W7p/2GAp2LDI1tQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733370492; c=relaxed/simple;
	bh=YKaeDk6x8sT94ZXgUpP0dQYXp4EizeeRTLfcbKqpifU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j0J8cmYq0pWoIT0xi41n3WlTt7pU2tMZ0IiiqxiWLIVM4dTkiKBFY1+lCfDYzfzdbRJIgzM03IMYTxlIDkkhqwOM2IDHqaEvkieWBUFUtPZAj5FamgbhdjKJ30t3LNHDws0LwPzKig65MbJQs8HC3PrfZT8/Y+SBN73XVl8qVvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ghXQR+uS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ghXQR+uS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5587C4CED6;
	Thu,  5 Dec 2024 03:48:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733370491;
	bh=YKaeDk6x8sT94ZXgUpP0dQYXp4EizeeRTLfcbKqpifU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ghXQR+uSMsWLYB7bsBrvH9swW+2/hvdprPESRAyIB0im9wrET7LmaFO1JJw99egI0
	 u0Rn+M76NcbNFV6wlU1LWIqaZipVDSdW4fzO1xrOORbxHIEGCXiDzcVtMLtmBhChJI
	 WKetL7RmcF/uwwfc116SzyaJxVHEGaVjm/3y1wTfNyhIKARVqYAFDiPNdS+lb4hUZr
	 +tbbAZ7pk4o98Lt8X8Imx64Cx1QEMa2ejQYXQMJCS11Vf6+ZUUKWm1DtI5jNXQMhCp
	 3f3hbVAG4l6mJQECFIsIBmjFf2n5P6M7Z/knbtSAwnpsO87DBkoHTr+Fb3M3zAgJ+L
	 ahnVEkqIIOyxQ==
Date: Wed, 4 Dec 2024 19:48:09 -0800
From: Luis Chamberlain <mcgrof@kernel.org>
To: patches@lists.linux.dev, fstests@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, gost.dev@samsung.com, sandeen@redhat.com
Subject: Re: [PATCH] common/config: use modprobe -w when supported
Message-ID: <Z1EieZ5gXwpOeU3D@bombadil.infradead.org>
References: <20241205002624.3420504-1-mcgrof@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241205002624.3420504-1-mcgrof@kernel.org>

On Wed, Dec 04, 2024 at 04:26:24PM -0800, Luis Chamberlain wrote:
> -modprobe --help >& /dev/null && modprobe --help 2>&1 | grep -q -1 "remove-patiently"
> +modprobe --help >& /dev/null && modprobe --help 2>&1 | grep -q -1 "wait TIMEOUT_MSEC"

Silly me, this is wrong, this should be:

+modprobe --help >& /dev/null && modprobe --help 2>&1 | grep -q -1 "wait up to MSEC"

  Luis
