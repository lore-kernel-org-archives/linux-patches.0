Received: from out198-154.us.a.mail.aliyun.com (out198-154.us.a.mail.aliyun.com [47.90.198.154])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DC9C12D756
	for <patches@lists.linux.dev>; Thu, 22 Feb 2024 13:02:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=47.90.198.154
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708606949; cv=none; b=fUc3rOh3JTdYhqjWnHDAdVDjhtJuibisnVTzXnxCmd3OOr2L3jurR1CUphQX+BBKvLKoROflpveZZ+LqCCmQjrEAdvFJN2MCb/HsS72YnRgItGC5HtO6UJxDj6gxKbpRE2UB30NnbxuZEJ0Upezzt6bxCtv+HMR3+j2aTRoTYAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708606949; c=relaxed/simple;
	bh=7dY0J6tWUfZDjRXqq+3RTmoIss7uMaGRscXZvaR85HE=;
	h=Date:From:To:Subject:Cc:In-Reply-To:References:Message-Id:
	 MIME-Version:Content-Type; b=N2+RiUZ0NTsLFNxOWNzQwxNV5sctS/EKkLXEABdDqQM72NG1r5+3Ah9zvJeqhR/T5HDj2QUMntj31Il/LQmd3uhgT5NhyDsYKZ2MQj24/Ju3xVUl42WCqqwTKZDgmUQCYrfOrdu0zwEzVlSSqUcOe90YaKu3ugrR1a3pNDyOr4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=e16-tech.com; spf=pass smtp.mailfrom=e16-tech.com; arc=none smtp.client-ip=47.90.198.154
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=e16-tech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=e16-tech.com
X-Alimail-AntiSpam:AC=CONTINUE;BC=0.09046134|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_enroll_verification|0.082199-0.00234652-0.915454;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047202;MF=wangyugui@e16-tech.com;NM=1;PH=DS;RN=5;RT=5;SR=0;TI=SMTPD_---.WX5xhwP_1708606924;
Received: from 192.168.2.112(mailfrom:wangyugui@e16-tech.com fp:SMTPD_---.WX5xhwP_1708606924)
          by smtp.aliyun-inc.com;
          Thu, 22 Feb 2024 21:02:05 +0800
Date: Thu, 22 Feb 2024 21:02:05 +0800
From: Wang Yugui <wangyugui@e16-tech.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 5.15 111/476] NFSD: Modernize nfsd4_release_lockowner()
Cc: stable@vger.kernel.org,
 patches@lists.linux.dev,
 Chuck Lever <chuck.lever@oracle.com>,
 Sasha Levin <sashal@kernel.org>
In-Reply-To: <2024022213-salami-earflap-aec9@gregkh>
References: <20240222061911.6F1A.409509F4@e16-tech.com> <2024022213-salami-earflap-aec9@gregkh>
Message-Id: <20240222210204.4F83.409509F4@e16-tech.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.81.05 [en]

Hi,

> On Thu, Feb 22, 2024 at 06:19:12AM +0800, Wang Yugui wrote:
> > Hi,
> > 
> > 
> > > 5.15-stable review patch.  If anyone has any objections, please let me know.
> > > 
> > > ------------------
> > > 
> > > From: Chuck Lever <chuck.lever@oracle.com>
> > > 
> > > [ Upstream commit bd8fdb6e545f950f4654a9a10d7e819ad48146e5 ]
> > > 
> > > Refactor: Use existing helpers that other lock operations use. This
> > > change removes several automatic variables, so re-organize the
> > > variable declarations for readability.
> > > 
> > > Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
> > > Stable-dep-of: edcf9725150e ("nfsd: fix RELEASE_LOCKOWNER")
> > > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > 
> > 
> > "nfsd: fix RELEASE_LOCKOWNER" is yet not in 5.15.149-rc1?
> > or I missed something?
> 
> Good catch, you are correct!  I'll go drop this, and the other nfsd
> "dep-of" commit in this queue, and in the 5.10 and 5.4 queues.

Will we add "nfsd: fix RELEASE_LOCKOWNER" to 5.15.y later?

It seems that at least 5.15.y need "nfsd: fix RELEASE_LOCKOWNER".

Best Regards
Wang Yugui (wangyugui@e16-tech.com)
2024/02/22

