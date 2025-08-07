Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C6691FBE80
	for <patches@lists.linux.dev>; Thu,  7 Aug 2025 18:34:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754591671; cv=none; b=P64OUHcOe1k2yxIotCDIsOGD+AZ/59Zkw856bp8ozk54URFiNAJ1P59zdTUw6CuBu/7REXnqZDKebf+PvilSheU+J/SFcaVKBnd0LzQH1aNvH2PcRc2s6DpSszPYMiMy07BLqAeWfwD+LU5yV7cHfX4h/q1sFWkhKJ3xu0vzs90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754591671; c=relaxed/simple;
	bh=qomyOJlP8+fFRS3e8TnUEJQ752WmzYy9drpK/3qTeCI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Pj9FcoBPZtq0FuUngqgFPB7JWmwy8O4P1idr/+PEl9TRTH252+48LfHQlW9X4z9rq+DEBAjJM8D1DLwNHHDSJ5w3798DB3oNGOYV/2ic0/NCetuSOULhXxyzddhQo/9E1i1jT8sfGFEoyzlQOOVmwSzaMnokkPWP3yTeCY+6NMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qQvnrPoZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qQvnrPoZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97800C4CEEB;
	Thu,  7 Aug 2025 18:34:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754591670;
	bh=qomyOJlP8+fFRS3e8TnUEJQ752WmzYy9drpK/3qTeCI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qQvnrPoZJgAP95w0F59+ZhvMha/tl1ph/pabCPphlbWtUHlACCXYD6lDbVk/y+ODC
	 bmWfFayWLcwngK+YbCLOEf71+Gr4EsA7hSSpgMYICRgAxtl/f/GsL1ivXSeaiKRSer
	 2p7MF87y2nSzw29WOi/guBIANGLd1SOVKM8RugGW2qVWg0ObcKdoR6gi+5tVjGR1s8
	 qeu+4lVtW0sUfcSL539KheGBHHKJp8pW1ab3Wn8z6T54jtiHPdrv8zQafxCE7LAXc4
	 5jG+Uf4l0yT0RdeAeLhHYltLv1i1ljCEsmIj+x22xY+Ayg07rL3qVDiHR8dQiJDlh6
	 C8jMxQp/wE7+w==
Date: Thu, 7 Aug 2025 11:34:28 -0700
From: Luis Chamberlain <mcgrof@kernel.org>
To: Kundan Kumar <kundan.kumar@samsung.com>
Cc: patches@lists.linux.dev
Subject: Re: [PATCH v2 00/15] Test patch Parallelizing filesystem writeback
Message-ID: <aJTxtFMk_HOJMioP@bombadil.infradead.org>
References: <CGME20250807045740epcas5p4cdec49f07b86acf2eea832890393d256@epcas5p4.samsung.com>
 <20250807045706.2848-1-kundan.kumar@samsung.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250807045706.2848-1-kundan.kumar@samsung.com>

Thanks, I pushed this out for testing under the branch on my linux
kernel.org repo

20250807-migrate-folios-stats-pw

I added my migration stats before this so to help enable testing of
that.

  Luis
