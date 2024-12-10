Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48DE486321
	for <patches@lists.linux.dev>; Tue, 10 Dec 2024 18:59:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733857198; cv=none; b=Lx6Z+te2fVlsKpXk9bUMO/jLpqMSCzLxP78GDSUK4qtzhG1wmdHYn610IYYieUx/0oq6AQZXRVjEE2i/mTH3xVvAff9qxH3RRWIp5ozHWtFIF+S+9AesctT52f18/J6LEO47lUHxeAdvRaIeyRReFYd2DMb5+MniAMS/6MaCabg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733857198; c=relaxed/simple;
	bh=ZAHpBCV0lXfjmv6MFDB/huh9iLzsToSHDZNemxGJ87g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Pii1MsXFShjAU1t0Ltvo0dAiLgvPLG/t8eiKTy77I1KjGmvwG9J3EL/tVfk2EDS85/FDtIqORxrzuS2b23VnFQNgCFOtmgsqSFhNHivU02fUGbYE1l2E9B0fhuB3GGYAO9aZMfwm3qg9M3fDbWZJpVFu/xhNqlkDlinXH0AwKK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=QsolPUrE; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="QsolPUrE"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 080F340E028B;
	Tue, 10 Dec 2024 18:59:54 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id IY-pcDPvLQw9; Tue, 10 Dec 2024 18:59:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1733857190; bh=73993ZhNk8Vz2C5elSu8B9z9bDco9lC36eLTi5WNmrc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QsolPUrEE2pGB9QTAZtADtqc5h7W9uztmRqhVrU6nr5tNiknhkzMn8OlxPy+AGrwJ
	 kq06XlVJjmmoaJ+R/35BV32WjccuZxHyY/ofQ14t19PtP6LhrYizn/A0Kh3N0XmI+c
	 512Hadc0Buods8uUd39w6F/IX1pkDA4hB5r58cJmBlW7ouRd09pnVhsCzvCDy164lf
	 574DHtcN4K+lw4rqROJj0qTX0/qaY83BTzWseYjiHI9HH7onBBpRTvtbf+rhiV6hTa
	 71lK4SmbVT/L5ggUXBDQaqyuWacMV6GKy3E2lAfcuaIw6xQrVLyQ+oCmnN62hqXNVl
	 lkIuBm9XrtoojQd+r6KoAKk4nuBQq9UqQHJtLXme0qTUyqRYBU5XWbWSE1ExGgvDSt
	 j3++qN+6EQqCgZb/L4fOh48Y3MXNFYNO+j132ONo2lllc8rit7zGkyVVY+ZS/ovf4v
	 /uf0tLsFPAuQKMVXPhcBrGCDSGIk9UpYfl+w714E3kf14bGEI0JNsbOFmCnyc0im2b
	 odEfoijApyBiZbbirTJVtHVzd9LHohQJqZXD2sjzoi3jBA84ay+0/xZcxHLIa+hCMk
	 CMxetnlGt/2p+kSlCedKhDJyp5ajXGdox6crmijIku419372GUTHOUE4igrT2lIv03
	 bbdhHl9dWPKoazdHJnPZxT7s=
Received: from zn.tnic (p200300ea971f930C329C23FfFEA6A903.dip0.t-ipconnect.de [IPv6:2003:ea:971f:930c:329c:23ff:fea6:a903])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 7ECF540E0286;
	Tue, 10 Dec 2024 18:59:36 +0000 (UTC)
Date: Tue, 10 Dec 2024 19:59:28 +0100
From: Borislav Petkov <bp@alien8.de>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: "Luck, Tony" <tony.luck@intel.com>,
	"Yu, Fenghua" <fenghua.yu@intel.com>,
	Peter Newman <peternewman@google.com>,
	Jonathan Corbet <corbet@lwn.net>, "x86@kernel.org" <x86@kernel.org>,
	James Morse <james.morse@arm.com>,
	Jamie Iles <quic_jiles@quicinc.com>,
	Babu Moger <babu.moger@amd.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	"Shaopeng Tan (Fujitsu)" <tan.shaopeng@fujitsu.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>
Subject: Re: [PATCH v11 2/8] x86/resctrl: Prepare for per-CTRL_MON group
 mba_MBps control
Message-ID: <20241210185928.GMZ1iPkLeB_Wb2zSDt@fat_crate.local>
References: <20241206163148.83828-1-tony.luck@intel.com>
 <20241206163148.83828-3-tony.luck@intel.com>
 <20241209204519.GAZ1dW3-NjcL4Sewaf@fat_crate.local>
 <SJ1PR11MB6083BA367F2CDFC92D87FDA1FC3C2@SJ1PR11MB6083.namprd11.prod.outlook.com>
 <20241209222047.GKZ1dtPxIu5_Hxs1fp@fat_crate.local>
 <SJ1PR11MB60830B8ED36CCA7E304D9E97FC3C2@SJ1PR11MB6083.namprd11.prod.outlook.com>
 <678cef69-78ef-4951-bd31-10abe646e6d8@intel.com>
 <Z1eEti6Kswtb3HC5@agluck-desk3>
 <20241210101339.GBZ1gUU3LiI7wAS3vQ@fat_crate.local>
 <5267f71d-3313-4cbf-a834-a30c96da0fea@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5267f71d-3313-4cbf-a834-a30c96da0fea@intel.com>

On Tue, Dec 10, 2024 at 10:42:33AM -0800, Reinette Chatre wrote:
> Thank you very much for catching the issue and taking the time to create
> the fix.

For nothing. :)

> The middle hunk looks to be an unrelated change.

Yeah, I zapped the superfluous newline while at it.

> I squashed the first and
> last hunk of this change into the original patch and all my tests pass.
> I am still waiting the 0day test report though. 
> 
> What would work best for you to have this fix included?

Already folded into Tony's patchset.

Will push out once I've gone through the set.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
