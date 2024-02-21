Received: from out28-59.mail.aliyun.com (out28-59.mail.aliyun.com [115.124.28.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FF104A1D
	for <patches@lists.linux.dev>; Wed, 21 Feb 2024 22:19:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.28.59
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708553958; cv=none; b=jOxsZiNnktclRvSlKrWPmZw1i/QqVaAqfxj+V2BARecE4R0r9YX8DkHJn2CdCV2gausAEUma1eY0rY2SzlYcK1bFTL+lcywp8/jSVy3GrhbtLXPQVYX4uMzv4I2pjrYkxfUICVBRVBIxcOytn1Yh1NDHBZvcY1NTVbBJqhW4aU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708553958; c=relaxed/simple;
	bh=Oput9+z1s8a17hFVDYGrHltO5nBaI5cr4eCCcitGUc8=;
	h=Date:From:To:Subject:Cc:In-Reply-To:References:Message-Id:
	 MIME-Version:Content-Type; b=Y0uGe8LRoVmDcCeTyadSKQguqyXuryoYIgd4j5pdaJQrKuIImDqRG6sm3spjNEI5DOlRq2gvCf6T6hqaQpp5+GNVRj+GTDRizQUF+u7JRckGwLjyd3DZSwzIE9Hvs3MujMWXdJd/alh47/KUmm6x15lhXme11QeV5Wm3w2S+6xI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=e16-tech.com; spf=pass smtp.mailfrom=e16-tech.com; arc=none smtp.client-ip=115.124.28.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=e16-tech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=e16-tech.com
X-Alimail-AntiSpam:AC=CONTINUE;BC=0.2776432|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_enroll_verification|0.159163-0.00167879-0.839158;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047192;MF=wangyugui@e16-tech.com;NM=1;PH=DS;RN=5;RT=5;SR=0;TI=SMTPD_---.WWYDqlO_1708553949;
Received: from 192.168.2.112(mailfrom:wangyugui@e16-tech.com fp:SMTPD_---.WWYDqlO_1708553949)
          by smtp.aliyun-inc.com;
          Thu, 22 Feb 2024 06:19:10 +0800
Date: Thu, 22 Feb 2024 06:19:12 +0800
From: Wang Yugui <wangyugui@e16-tech.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 5.15 111/476] NFSD: Modernize nfsd4_release_lockowner()
Cc: stable@vger.kernel.org,
 patches@lists.linux.dev,
 Chuck Lever <chuck.lever@oracle.com>,
 Sasha Levin <sashal@kernel.org>
In-Reply-To: <20240221130012.081046577@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org> <20240221130012.081046577@linuxfoundation.org>
Message-Id: <20240222061911.6F1A.409509F4@e16-tech.com>
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


> 5.15-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Chuck Lever <chuck.lever@oracle.com>
> 
> [ Upstream commit bd8fdb6e545f950f4654a9a10d7e819ad48146e5 ]
> 
> Refactor: Use existing helpers that other lock operations use. This
> change removes several automatic variables, so re-organize the
> variable declarations for readability.
> 
> Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
> Stable-dep-of: edcf9725150e ("nfsd: fix RELEASE_LOCKOWNER")
> Signed-off-by: Sasha Levin <sashal@kernel.org>


"nfsd: fix RELEASE_LOCKOWNER" is yet not in 5.15.149-rc1?
or I missed something?

Best Regards
Wang Yugui (wangyugui@e16-tech.com)
2024/02/22

