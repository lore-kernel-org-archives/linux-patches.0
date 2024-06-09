Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CAB639AEC;
	Sun,  9 Jun 2024 11:08:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717931317; cv=none; b=OQOb4MBAgBzrPuoSGlTEvpUXws850SiUPgREKdaPFmWBrXxlwo70RML4OMg01VPANXHF7NTeP1UXVQ4U59O+rkla8UbaONZSiCo8KCHKhXN3PPTWUE7lwx2qRVwtToNXevPlvLKEPhhUk0XvDUaeAp8SsB25u/x7FMZzQGetews=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717931317; c=relaxed/simple;
	bh=LSRLTexohN7r8yvMQQRy2faRLUrI3qqJG9T4R0Ez+ws=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IZZatQu10VlRZHusY6Lnm5sbUnc+8l0GLGdN6UgLZdyU7P7wI289j7N9dsJexCQi53BnxARXuwEPnuYGIYTqsrynBC8pNiKeTcGs3G+wl2R1bMLSSrv3yl3H5hbl0Y737GR+jFFACygZg6X95Sv1j07f7ZrD1fSl8+nDAH6WKJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ck33uY/P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ck33uY/P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B8F4C2BD10;
	Sun,  9 Jun 2024 11:08:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717931316;
	bh=LSRLTexohN7r8yvMQQRy2faRLUrI3qqJG9T4R0Ez+ws=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Ck33uY/PojfY9Q3yvzSnxiOGeGrZYJpdt2K5tIWK+PsuGMfasmaTPOn0mhbnzDXmx
	 q4nD1otRTy+HFsg2pNf2EOshWZ7iaDcS/kyPNhb0SgMpiyBVJkZasM2EGLFzsdTiTG
	 7/dictKmXaEZaQ75WKEbFy3WMVWnl01yOilk407Q=
Date: Sun, 9 Jun 2024 13:08:33 +0200
From: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To: Hui Wang <hui.wang@canonical.com>
Cc: "Zhang, Rui" <rui.zhang@intel.com>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>,
	"pmenzel@molgen.mpg.de" <pmenzel@molgen.mpg.de>,
	"Brandt, Todd E" <todd.e.brandt@intel.com>,
	"Lifshits, Vitaly" <vitaly.lifshits@intel.com>,
	"Keller, Jacob E" <jacob.e.keller@intel.com>,
	"horms@kernel.org" <horms@kernel.org>,
	"naamax.meir@linux.intel.com" <naamax.meir@linux.intel.com>,
	"Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
	"sashal@kernel.org" <sashal@kernel.org>,
	"kuba@kernel.org" <kuba@kernel.org>
Subject: Re: [PATCH 6.6 723/744] e1000e: move force SMBUS near the end of
 enable_ulp function
Message-ID: <2024060924-bony-wrongly-7d10@gregkh>
References: <20240606131732.440653204@linuxfoundation.org>
 <20240606131755.652268611@linuxfoundation.org>
 <3eb7ce5780ccbd08f1d1d50df333d6fc7364b2e9.camel@intel.com>
 <60a65889-130f-479d-b7de-04236316adc3@canonical.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <60a65889-130f-479d-b7de-04236316adc3@canonical.com>

On Fri, Jun 07, 2024 at 09:04:26AM +0800, Hui Wang wrote:
> Hi Greg,
> 
> Please do not apply the commit to the stable kernels, there is a regression
> report on this commit.

Now dropped from everywhere, thanks.

greg k-h
