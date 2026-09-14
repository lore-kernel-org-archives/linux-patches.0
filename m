Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 885D64028F2
	for <patches@lists.linux.dev>; Mon, 14 Sep 2026 15:51:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789401079; cv=none; b=ZkUB7BGBpPALiogmOTnqncpnTIDLkPd/6XyG4GHfJP1KN1fl4j59zkEd2g4LCS2dqMCFU2W9heuARGvhUG01D8t4y5MOYM1Gsn7+y0qd6YEmukQMwx1XVJlpPbug/oRqXHtR5lWI7NKLOknVHouzXxWsZoDhVUfIKcyWDW64iAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789401079; c=relaxed/simple;
	bh=rVfAhaMRwZYiEpg6dw/fmsfziMwKNFHeaO2+oHPAsqk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VH9HFv2+sfhr2cyMdZ4xe2hHYb/qa7UQYamkSi0Om4joH7LX7YqXmPEuSc9PQtjva0y7BxUr/82sK7sshOwDCyoLOclY8DL4HBkScjyq3uMlfLSbQKM6u3amzeA4baw32BfgycVipQpVBuS+Yroc1U2D6R9SQB3vgQ3f611vfZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HksHhqxO; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HksHhqxO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1789401078; x=1820937078;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=rVfAhaMRwZYiEpg6dw/fmsfziMwKNFHeaO2+oHPAsqk=;
  b=HksHhqxOMEUuuKrubDZRIfD8pitjEWAIKiQ10H8EhfYGSPlbl4xmWLaK
   GJoEPKJkIOPY1y0UmUlURPs5A+9Qw63CU6DGmKWz79wel9dLjnYJ5IzGx
   hic7QV7bucbn0+lV0rsfNkyv0qQGavrIHkybIoCqwFiM1eUw0v893URMv
   3v8zES6267SeJ1/ZhUcmbrX/mMsKLkM0qw12+30/aov8m82C2mJudtE/B
   heM9eWfyEyG3EPK23DjNUtW/kSSLz02VPlYTVutYipqdiF2gk6qDDju4H
   kd5JAHUAxYD5QSLB6DiPT4auB4vvOYfZ3dEM0bSCwrTfqSKuPPb5N9PBi
   g==;
X-CSE-ConnectionGUID: +RcI1wpxSy2h7oJ7XV/qyg==
X-CSE-MsgGUID: zOf759S/TA6UB0zyjIkZEg==
X-IronPort-AV: E=McAfee;i="6800,10657,11905"; a="100418147"
X-IronPort-AV: E=Sophos;i="6.27,103,1787036400"; 
   d="scan'208";a="100418147"
Received: from fmviesa013.fm.intel.com ([10.60.135.153])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2026 08:51:07 -0700
X-CSE-ConnectionGUID: EEFOzE9iQEq7bHmWCZ1/0Q==
X-CSE-MsgGUID: M4Bub+T8SaqqaHzsGTJAeg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,103,1787036400"; 
   d="scan'208";a="1072035"
Received: from tassilo.jf.intel.com (HELO tassilo) ([10.54.38.190])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2026 08:51:07 -0700
Date: Mon, 14 Sep 2026 08:51:05 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	James Clark <james.clark@linaro.org>,
	Ian Rogers <irogers@google.com>,
	Colin Ian King <colin.i.king@gmail.com>,
	Howard Chu <howardchu95@gmail.com>,
	Weilin Wang <weilin.wang@intel.com>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Thomas Richter <tmricht@linux.ibm.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Athira Jajeev <atrajeev@linux.vnet.ibm.com>,
	Michael Petlan <mpetlan@redhat.com>,
	Veronika Molnarova <vmolnaro@redhat.com>,
	Namhyung Kim <namhyung@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.12 1009/1376] perf test: Display number of active
 running tests
Message-ID: <aqgX6Xsr5GmddTTj@tassilo>
References: <20260912065607.535295758@linuxfoundation.org>
 <20260912065630.052286725@linuxfoundation.org>
 <aqbt2-Kh76GZxmPK@tassilo>
 <2026091402-eccentric-curry-66f6@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2026091402-eccentric-curry-66f6@gregkh>

On Mon, Sep 14, 2026 at 11:51:19AM +0200, Greg Kroah-Hartman wrote:
> On Sun, Sep 13, 2026 at 11:39:23AM -0700, Andi Kleen wrote:
> > On Sat, Sep 12, 2026 at 08:57:15AM +0200, Greg Kroah-Hartman wrote:
> > > 6.12-stable review patch.  If anyone has any objections, please let me know.
> > 
> > It's hard to see how these 6 perf test patches are stable material.
> > 
> > They seem at best be nice to have.
> 
> They were needed because of:
> 
> > > Stable-dep-of: 44e82c4d2ff3 ("perf test: Fix skiplist leak in cmd_test")
> 
> thanks,

It's same there, I don't think anything perf test is stable material.

It's just a test suite after all.

-Andi
