Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=62.245.111.132
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792786056;
	b=NlD+og0OmCm1QPT90EMZMvjLggB1NhDMi3IVl6mt6FST9VOpLrBTvl8zzTgKzx1r5iTf
	 v0nxW2XtGMBgXht9q8Di6BJXR3FgzECwFPQfotHOvnN3Vqj6vSVePBUxmWUIAB000eFbO
	 koy5ITjOvsIDGQBL7zmQeAS6VhCy33scBzvcUk+G6MAJaLMWnlZZE8IPRLnPk6nBpOC6g
	 eTpRe5dU2zBBLmWJcqju/X1fo0Z6KuqGQT9ln4BN0OOxQdzpq4hPF5Yo1tXyELBEMkmcn
	 EGOjH9QPBmyofbF3FbxZ9pwmrzIKUVFLqsaQ8npfaFouPfeBB2Rj5kdq6J7lG1Zoxbg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792786056;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To:X-Scanned-By:
	 X-Scanned-By:X-Scanned-By:X-Antivirus:X-Spam-Score:
	 X-Milter-Copy-Status;
	bh=nqP/eOBDzoJa/3Q/UL15lkOHI2wlxM3CXdjzfat0vOg=;
	b=aaDw4IzaUXjzfYwOAO7k4NkTuQrfBewOuszYBIdqxdtvpF8EDX1uf4TXkCmZrhoaZY3Z
	 ZQHn/PbtTkzf3umc9DLCeRpbSjcMYSs3xCOPZdCIca8qmRSjakfyJOnOrlrDQcoKa7DVK
	 gBY+S5Z/A/WsFuSCCSoL8wW/qVJCuD+JqJVBFNlXCfjBoMOBquWwL/vDrgKaDsBTSwDSi
	 K7uWIkC8+6ADYLXfa7ifhaNPtiGEIVtVNmKCk5zFEJi4v08FAH3tiVdRrorSmYOC9+IMA
	 IiecxakqQGXZWDMrgB+FY9PyKs7/2UFuLAwDzS2nmQKETuqFujO66JGblx7CLpCzocQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linuxbox.cz;
	spf=pass smtp.mailfrom=linuxbox.cz;
	dkim=pass header.d=linuxbox.cz header.i=@linuxbox.cz header.a=rsa-sha256 header.s=default header.b=wajqHXsl;
	arc=none smtp.remote-ip=62.245.111.132
Received: from gwu.lbox.cz (gwu.lbox.cz [62.245.111.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2821606A32E;
	Fri, 23 Oct 2026 20:07:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E2821606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxbox.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxbox.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxbox.cz header.i=@linuxbox.cz header.a=rsa-sha256 header.s=default header.b=wajqHXsl
Received: from linuxbox.linuxbox.cz (linuxbox.linuxbox.cz [10.76.66.10])
	by gwu.lbox.cz (Sendmail) with ESMTPS id 69NK7G53113710
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Fri, 23 Oct 2026 22:07:16 +0200
DKIM-Filter: OpenDKIM Filter v2.11.0 gwu.lbox.cz 69NK7G53113710
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxbox.cz;
	s=default; t=1792786037;
	bh=nqP/eOBDzoJa/3Q/UL15lkOHI2wlxM3CXdjzfat0vOg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=wajqHXsliu196SAxHuImIkI53Kt1MPiNz+PfgmZsMIhPQfPWeOuzPslO1z9vSbd3P
	 u58b+ZbboOpQw0egBseyF8uVN7wFbZ2RSeJ4wcGoUMBfBo+f4OgMd7e5YnpGL4Qamd
	 9mwHq4CJ/jczlXyWvDmVWva5YCDm5iPvR8y4+yLI=
Received: from pcnci.linuxbox.cz (pcnci.linuxbox.cz [10.76.3.14])
	by linuxbox.linuxbox.cz (Sendmail) with ESMTPS id 69NK7FpA026575
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Fri, 23 Oct 2026 22:07:15 +0200
Received: from pcnci.linuxbox.cz (localhost [127.0.0.1])
	by pcnci.linuxbox.cz (8.18.1/8.15.2) with ESMTPS id 69NK7DFG3371910
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 23 Oct 2026 22:07:15 +0200
Date: Fri, 23 Oct 2026 22:07:13 +0200
From: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
To: Sasha Levin <sashal@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        patches@lists.linux.dev, Jacob Keller <jacob.e.keller@intel.com>,
        Michal Kubiak <michal.kubiak@intel.com>,
        Alexander Nowlin <alexander.nowlin@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Alexander Lobakin <aleksander.lobakin@intel.com>,
        Nikola Ciprich <nikola.ciprich@linuxbox.cz>
Subject: Re: [PATCH 6.18 158/621] ice: drop page splitting and recycling
Message-ID: <atu+cRNdhA17unBY@pcnci.linuxbox.cz>
References: <atsythEG2rkGdc6Z@pcnci.linuxbox.cz>
 <2026-10-23-1-daily-reply-0018-ice-page-pool-6-18@kernel.org>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2026-10-23-1-daily-reply-0018-ice-page-pool-6-18@kernel.org>
X-Scanned-By: MIMEDefang 3.7.1 on 10.76.66.3
X-Scanned-By: MIMEDefang v3.7.1/SpamAssassin v4.000002 on lbxovapx9 (nik)
X-Scanned-By: MIMEDefang 2.86 on 10.76.66.10
X-Antivirus: on lbxovapx9 by Antivirus 
X-Spam-Score: N/A (trusted relay)
X-Milter-Copy-Status: O


> The partial series that leaked is out. Greg has now queued the full ice Page
> Pool conversion for 6.18 (remove legacy Rx, drop page splitting, switch to
> Page Pool, plus the two follow-up fixes), so please test the next 6.18 rc.

already testing :-)  now it looks OK to me. thanks. n.


> 
> -- 
> Thanks,
> Sasha
> 
