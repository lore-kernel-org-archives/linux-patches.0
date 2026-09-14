Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0FE535DA6E
	for <patches@lists.linux.dev>; Mon, 14 Sep 2026 05:42:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789364541; cv=none; b=YzZk9HAX8/kmkFVIlurBtVjza9tBZidG48dueaY9pGnIZ8pxVcS2avx2kIc+cs3rHw+lkRHDSKwrourNnr2vF+1azC69Qovi64+ZwiI4k6xVXuKrUU+/y2RoPFo6SpmFxjHml2BwGHhgPo1LAVd1XZADJwLwtgtNff/f/h3Lu9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789364541; c=relaxed/simple;
	bh=HZ7li8J0qxVb84XIjd5q24c8u7KbIRY0PiglY6QizGQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VImnIlQaLRP0uEqi1k76z8MQMcnURp3YHfqAhwj26+4t6RrkeP7jOoid4eM3rPtciqw6jF4hTNbRSq8wFBGPoLxZggszs1zjFDed994GC80XASjsQbTPD6MkHyOarv+t51nw9K0EWFandQggKndVG0JxP/vWgAG9NSfBXlR33fA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=M50gQlKF; arc=none smtp.client-ip=192.198.163.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="M50gQlKF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1789364540; x=1820900540;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HZ7li8J0qxVb84XIjd5q24c8u7KbIRY0PiglY6QizGQ=;
  b=M50gQlKFnSz4KBJOKNc2H+CNMLm676y/8bZhyjjqqlUDgyKk/qhJ8WKr
   zZXO5RgTPOi+aW5Oc2Aw7cleyKpXQ0X+ZR4jkgCeybxdxfsI1huVBr7Jc
   MV16C7B+bQwEZdHIprzYVjMmPCZspj1yZYla0CcUngxbjyA2L15rk1hqO
   a3G5eStHWy8ZQPvhho6VdT/ybokb9+icFi5f3n89evFfos/DN2vH983Gf
   qYnVGs3ZoHBWF0aEhPxgfBH3ZEYpKRU7pdRXrs3i82DOXFkD4tRwLPF2I
   L/UTduNk73/ZN0bSg9j2Ab8ud5GEmUvw0/IJas/e3GLyVOngol4043iVW
   w==;
X-CSE-ConnectionGUID: YPVTkO1YScqCQ9/f1kE1Ww==
X-CSE-MsgGUID: h/2XlZkCQ1eV801gibnOvg==
X-IronPort-AV: E=McAfee;i="6800,10657,11904"; a="225439"
X-IronPort-AV: E=Sophos;i="6.27,102,1787036400"; 
   d="scan'208";a="225439"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa114.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2026 22:42:20 -0700
X-CSE-ConnectionGUID: FfSTL7X8R8aPjNf7ZyO6LQ==
X-CSE-MsgGUID: XM0tuVznTSaclyjFcvPteA==
X-ExtLoop1: 1
Received: from junjie-desk-dev.bj.intel.com ([10.238.152.71])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2026 22:42:17 -0700
From: Junjie Cao <junjie.cao@intel.com>
To: Sasha Levin <sashal@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org,
	patches@lists.linux.dev,
	Laxman Acharya Padhya <acharyalaxman8848@gmail.com>,
	Felix Fietkau <nbd@nbd.name>,
	Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 7.2 0862/1815] wifi: mt76: mt7921: validate CLC firmware records
Date: Mon, 14 Sep 2026 13:42:09 +0800
Message-ID: <20260914054209.635949-1-junjie.cao@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <d0f1d893ec55405d@kernel.org>
References: <d0f1d893ec55405d@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Sat, 12 Sep 2026 17:00:19 -0400, Sasha Levin wrote:
> Dropped from the 7.2, 6.18, 6.12, 6.6, and 6.1 queues.

The follow-up is in mainline as of v7.3-rc3:

  1a296bfd3e77 ("wifi: mt76: mt7921: skip unknown CLC firmware records")

Please queue it with 9417c5818a01 for 7.2, 6.18, 6.12, 6.6 and 6.1.
Your dropped backports of 9417c5818a01 plus 1a296bfd3e775e on top
apply on 7.2.5, 6.18.51, 6.12.109, 6.6.156 and 6.1.187.
