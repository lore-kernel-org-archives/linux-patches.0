Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E78081D7E20
	for <patches@lists.linux.dev>; Tue,  3 Sep 2024 19:27:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725391640; cv=none; b=ZCGJnvJ64mGeigbe386c23GG36wvgnucBuTWaVBIp7slX6gMeWcK2yBEE4sHvV9K3PjI4T1zIj2mtphPVIij2/nV+waEggiWOVhW59JsSwqpShd4AvotUs1wZcffQaxQecHWERwy+hTsi4pbw51OxcT4oHYCv3o3eJEiQXVqgV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725391640; c=relaxed/simple;
	bh=tyWxhsVYTRl+R9E6ELW5SRl7j9E7+e9hZ2jbj0htGlc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Dz9jmcboQfmSfLPF4/Tj7vK2w1piM/6NwV3N+nvbJEtgS5IfaiUV9YvS/347MObUgoAM63x5xAjrUJhlaZ4NURIXFv6cIyIVEV9H43YwCXI3sxQlCFzg7t20pE48GGVHywAAXxp1G5lO2Ay7Oy61GJ4r4QvRwLHUmJ0BDJ9Et/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=daHZ84FV; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="daHZ84FV"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 918C740E0169;
	Tue,  3 Sep 2024 19:27:15 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id Qm7zIwiZHxlg; Tue,  3 Sep 2024 19:27:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1725391631; bh=h45jq0TJwScbq6yFp9KYP7d+KXV8D6MnNFctu9uAbG4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=daHZ84FVycPj5S2y3kWuzYTojJPo3zq17F8KYaj+YnRr7jBkI1cE4ABPlzbgAtmMa
	 mA9sD1KQg4T2Rev/438cUJPxdb4ubEusTZ4a+IYb2YdCI4DXm3NunCWjGWP4IINmPg
	 bPGZQEgu3v5bXFiFqUWMA/1H1Vnw8eSL17xQDGBkT+b+Lw2BVZXtF9pibfxDJRbjA7
	 QJnbFBg5HJZhXTIbPw/YuAv2VgHfZ0PtQTDzQ2yUgJ7xEDQJ08vFbWoVrhJj7c7NNU
	 vwuv6eD6d/PH47RgR2fJBTkaPu3E2aK8bLe+QEnFpIW3Vv/zrLWYpc6bi6bKqhy1d3
	 SjsPnd558EoWtFmNt4MesShhy/HCiliAIT1vOV79560UILfUaxY9fPA9SQnp1Kb3rl
	 nuHjuYB0WUx6FnEfr7MijVBhBZHJJSoCqV6dlpwGJep+PuxnI5ufOMUZBMzPoDQLgJ
	 bPAfSVypa9SqOQGMb2Pe1Ejw4z6OzsZLaStljM0pDWm4y1yKDoBRgSg5XtYs9A2zNO
	 xCIIR+IuIXO8X4J7P0rOr5edxkTr8gEPg41CRQ/mnJzG9DgdOqrBEuAQNG49L4Xa/E
	 gnVvaM1r7dAjtHu3ryEpcLG5h5eOsbm0GM8GVDWjAo/WWMgBDFWn1tX0oAzK08cEi8
	 n7SR/V/6yilufrJpbUbrT8ZQ=
Received: from zn.tnic (p5de8e8eb.dip0.t-ipconnect.de [93.232.232.235])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 11DEC40E0275;
	Tue,  3 Sep 2024 19:27:01 +0000 (UTC)
Date: Tue, 3 Sep 2024 21:26:55 +0200
From: Borislav Petkov <bp@alien8.de>
To: Tony Luck <tony.luck@intel.com>, Chanwoo Choi <cw00.choi@samsung.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH v8 0/3] Final pieces of Intel new families support
Message-ID: <20240903192655.GCZtdi_w9xN6z9hPGV@fat_crate.local>
References: <20240903173443.7962-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240903173443.7962-1-tony.luck@intel.com>

On Tue, Sep 03, 2024 at 10:34:40AM -0700, Tony Luck wrote:
> All except one of the precursor patches were merged to Linus' tree
> in the v6.11 merge window. The exception is a one-liner that is in
> the maintainer tree and linux-next, but didn't get pulled this time.

So when is Chanwoo planning on sending that one to Linus?

Or should he drop it and I pick up all three and finish this conversion?

Hmmm.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
