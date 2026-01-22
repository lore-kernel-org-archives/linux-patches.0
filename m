Received: from n169-113.mail.139.com (n169-113.mail.139.com [120.232.169.113])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 637D03101D2
	for <patches@lists.linux.dev>; Thu, 22 Jan 2026 10:29:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=120.232.169.113
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769077758; cv=none; b=hTixFkN+14mO2nV+LixHfMSyGfffmy8DksQV517NEtPdy0VDabyUDa+Fvdtltckd4LfE1TwQk2TsSHXkmUxcWZ3FO+0LJxVb18YdHI1nUZ5G0l/kJw7wWQ9/M/2lPx1BtU/ry7ffVPtTvjgRO5iMbBMVBnKzZeNLTQ9/W8q4Bj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769077758; c=relaxed/simple;
	bh=Qo/Idojv7W9PxPMWg9eRWXP9+GoOHhCzycGU4LuQ0ig=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=XVZBQlW01GYnDOe0V2pQYlvIepuIWGe7YGa/mUEtksWN/RJ9RWJUsT5geKBGhx8Gyh7DYpGqJD2ez6mi2MGUTvDgD509nR1TO6JLR3/pyhbiSLU61yD7snU1Hk5k1uXNP0LXLTdiJACQZZshGTRtrnRo/+zcnQInEr1Rk5lwJm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=139.com; spf=pass smtp.mailfrom=139.com; dkim=pass (1024-bit key) header.d=139.com header.i=@139.com header.b=Kl65nDrX; arc=none smtp.client-ip=120.232.169.113
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=139.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=139.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=139.com header.i=@139.com header.b="Kl65nDrX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=139.com; s=dkim; l=0;
	h=from:subject:message-id:to:cc:mime-version;
	bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
	b=Kl65nDrXubBwKQ330Vkjy5642NylqNnNwGt3OeSHEABWIqNGZlTvMhpIi2uOfou17R/0KF5rcVw0k
	 O5OcFXF6GlExI/faZJHmD5Z3V2ZFB0md8p6B68co/iSJrMSGDy7L3zzXnglcnEfKy039klzht1tdl5
	 4b7H3+FgBCmbYNsM=
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM:                                                                                        
X-RM-SPAM-FLAG:00000000
Received:from NTT-kernel-dev (unknown[60.247.85.88])
	by rmsmtp-lg-appmail-29-12034 (RichMail) with SMTP id 2f026971fbd3353-03391;
	Thu, 22 Jan 2026 18:29:11 +0800 (CST)
X-RM-TRANSID:2f026971fbd3353-03391
From: Rajani Kantha <681739313@139.com>
To: gregkh@linuxfoundation.org,
	stable@vger.kernel.org
Cc: patches@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6.6.y] iomap: Fix possible overflow condition in iomap_write_delalloc_scan
Date: Thu, 22 Jan 2026 18:28:37 +0800
Message-Id: <20260122102837.3379366-1-681739313@139.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260122033826.3110454-1-681739313@139.com>
References: <20260122033826.3110454-1-681739313@139.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hello,
Sorry, I accidentally wrote 'PATCH 6.6' as' PATCH 6.1 ', please ignore this series.
I will resend the correct one, thanks.

