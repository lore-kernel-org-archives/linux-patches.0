Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6BFB405F8
	for <patches@lists.linux.dev>; Thu,  4 Jul 2024 21:33:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720128810; cv=none; b=YBB6zeewOPzO0v3Bs/5mRuBnDcgShyFBX4yLw/hPFmfDYQ1Xoc6Dj+kSRW7aYsvc1Hh1OZ/KGmz2UFKgpHE8iuFxld1wS1Okb35MNMTCntdHbwocBy79r7gt8rSnLfKk7I0CITrqhqLxDcP5KTYvfaJEmEGyqtcy6RSIhR6TSGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720128810; c=relaxed/simple;
	bh=kEfmnGTrSFvZ0/R+w8Xhs2oBYsSpp/wcSpRdbNcvl0g=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=PhZJC9N0dalykbWYtMEC/OH3o89Aaiulp+HinyYfu+Wr0ObWGJX6WaV5xybeRypT0L3M24590sD0gtrPtxIwYK51nI1JTnVV/SFGzaR/vIZN20SNFmOSE46bDHiL7NgYaJqLX9R+4Et0oGgfur3k1B7M6xXKFO6PU8MKgfVtpEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=perches.com; spf=pass smtp.mailfrom=perches.com; arc=none smtp.client-ip=216.40.44.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=perches.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=perches.com
Received: from omf19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B596E1614C0;
	Thu,  4 Jul 2024 21:23:44 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf19.hostedemail.com (Postfix) with ESMTPA id 2AC0320029;
	Thu,  4 Jul 2024 21:23:41 +0000 (UTC)
Message-ID: <0e3bf011f0b402f7913164deacd964f02db8ec7d.camel@perches.com>
Subject: Re: [PATCH 4.19 093/139] scsi: mpt3sas: Add ioc_<level> logging
 macros
From: Joe Perches <joe@perches.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, Suganath Prabu
	 <suganath-prabu.subramani@broadcom.com>, "Martin K. Petersen"
	 <martin.petersen@oracle.com>, Sasha Levin <sashal@kernel.org>
Date: Thu, 04 Jul 2024 14:23:40 -0700
In-Reply-To: <2024070449-tarantula-unwieldy-9b51@gregkh>
References: <20240703102830.432293640@linuxfoundation.org>
	 <20240703102833.952003952@linuxfoundation.org>
	 <f054ce9050f20e99afbed174c07f67efc61ef906.camel@perches.com>
	 <2024070449-tarantula-unwieldy-9b51@gregkh>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.2 (3.52.2-1.fc40) 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Rspamd-Queue-Id: 2AC0320029
X-Rspamd-Server: rspamout06
X-Stat-Signature: 9n6craygkn9jg4u4h37aapmr3hxmap5s
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX19bZ2itIB0Y8MkTZZPSeh55cGaj2sUb1PU=
X-HE-Tag: 1720128221-131808
X-HE-Meta: U2FsdGVkX1/3PHzWtQa5ms88/ICqACkAp3G+y3fB5oyfG7FcefCW8Yj9nvMJCJVgd/nXBwZ490aZ5OmT29pjro7hJyhzhK5PlHuFCuK4FpyfLdxXykOiIEywb5e0QmyoWaQTUEaFSeYHugCWE2yQocNlWog0enDSszvBY1T++Ubx8lzvcuq5P6f+Y7mxtzl9PjcvGeomud5qXdoXUt0uYIFH2BkIc/hKL7YyhETyUo9g9TkAFl+bmlttZ2gZctsRY6rlKM3HkaEj7QtmPjjORvL29rdouc+hxWAu7DegeunYzACrdsHhk+d0x1JWxQzFq3KfT8S95p52OLCtGmHOfL2fgE4XuZLdHSfrjFpGYEjXgCk89pnu+8JDKVybA2LUuWb09tMyobD3G7+MpLDaqA==

On Thu, 2024-07-04 at 11:38 +0200, Greg Kroah-Hartman wrote:
> On Wed, Jul 03, 2024 at 04:10:43AM -0700, Joe Perches wrote:
> > On Wed, 2024-07-03 at 12:39 +0200, Greg Kroah-Hartman wrote:
> > > 4.19-stable review patch.  If anyone has any objections, please let m=
e know.
> >=20
> > Still think this isn't necessary.
> >=20
> > see: https://lore.kernel.org/stable/Zn25eTIrGAKneEm_@sashalap/
>=20
> It's needed due to commit ffedeae1fa54 ("scsi: mpt3sas: Gracefully
> handle online firmware update") which is in this series and uses the
> io_info() macro.

Swell, but the dependency chain is not correct

The patch says:

> Stable-dep-of: 4254dfeda82f ("scsi: mpt3sas: Avoid test/set_bit() operati=
ng in non-allocated memory")

