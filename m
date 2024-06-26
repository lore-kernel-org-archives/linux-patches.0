Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B4CC17FAAE;
	Wed, 26 Jun 2024 17:19:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719422368; cv=none; b=Tjhq/QUGfceiHT7MEU/oFPKgfDLXmmD61tQe4u9KtjZb8WChPT7y9B5MRJLPFIQLUb4uLEUbdhmzfNDBnLFyCWAVBGtu8ij3r22egrlqM3XtbxfgOnf3YP+5iviamKN8W6l+t4yromhYEilEmy23Z93eQY0FNUtjkibBDLBmifY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719422368; c=relaxed/simple;
	bh=5L2XLcaOaNS9j8FXIQm08bzTygnbxe+iXT7ihnuCW+Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ebi+zgkkKBWlQnECBVxJFCsmWpaf/5+1o7UhIepyRJCb4aS2c22k/rxBBduTyPWviSK6ftxST/7Y8g8jdq6+xrNvEQPoEO6E9QdP/rjm0BtakNqWXkEt6B9Gs3s/FcY6uVr7ld6Qt5jlSY1XdOXyb6EUSH0oc2QctemJq7ZgOz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HQZdRhK5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HQZdRhK5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BB5FC116B1;
	Wed, 26 Jun 2024 17:19:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719422367;
	bh=5L2XLcaOaNS9j8FXIQm08bzTygnbxe+iXT7ihnuCW+Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HQZdRhK5VmyWJ4PxyO3UC796RprehCtodGm+ubsb0pU4pzwMADIxaki4x1BdyWSkw
	 lSP4sVEi90FtBcSO3TWjgi3c/YpsAo6kQIXDYYl3A7VRqvl/zzoUASF0PQ/ch4Uykx
	 swDlKJ7UInDd0a14EAtRkaykEkscy6CfYzCYtbF2uX/xgGivJUGSA9/Ay0UDMTfGPx
	 IEj+XHuUNOVP+51DwhvLKKLvnmdSvyUDd97AHQndG0+07csWmXCCVdkt3sNiAwda9M
	 pfdGuvGJ4dSpFvBGY9KfiW8dtQfCvSaSJH7tWK3PW8QBPwfKd5ODkUZCsZaq8hDELl
	 RaF9a5YxYOyYg==
Date: Wed, 26 Jun 2024 11:19:24 -0600
From: Keith Busch <kbusch@kernel.org>
To: Nathan Chancellor <nathan@kernel.org>
Cc: James Smart <james.smart@broadcom.com>, Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Kees Cook <keescook@chromium.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>,
	linux-nvme@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-hardening@vger.kernel.org, llvm@lists.linux.dev,
	patches@lists.linux.dev, stable@vger.kernel.org
Subject: Re: [PATCH] nvmet-fc: Remove __counted_by from
 nvmet_fc_tgt_queue.fod[]
Message-ID: <ZnxNnFxTQCcPWhQM@kbusch-mbp.dhcp.thefacebook.com>
References: <20240529-drop-counted-by-fod-nvmet-fc-tgt-queue-v1-1-286adbc25943@kernel.org>
 <20240626170605.GA66745@fedora-macbook-air-m2>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240626170605.GA66745@fedora-macbook-air-m2>

On Wed, Jun 26, 2024 at 10:06:05AM -0700, Nathan Chancellor wrote:
> Ping? This is still relevant and I don't think this is a compiler bug
> that would justify withholding this change.

Sorry, I misunderstood the discussion to "wait" on this. Queued up in
nvme-6.10 now.
