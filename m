Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 773B91EFFA1;
	Sun,  6 Sep 2026 15:02:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788706956; cv=none; b=M8n7q/4jeCpRyl17pUNZGD98dDCt6X0K3sGjotvGs5P/G3od/ofBJdvDirzYyjZzxELdpMcPU6hWvuxTMiOsx6J7e/HKSASs3U3PcDLsAegvW8GtoHY+ezQRBQnOJKhHXh9oizgtXVH6oOGRhr5JDHOWSS896a8SWhyHYnOLDP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788706956; c=relaxed/simple;
	bh=HQHC6yKnfLf3Js6uaGWsSZG2WVoYiDYSCW5FzXf6CO0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TdMIKqKvRI+mTbylrjdLvoesxwe5zmNoVt6Xl7TkAxKeM1t0mKxPwcqn/tvDplrtCZVaMQWA2CIHPF8x14jviiZ317Oga3szMx/tl1ZR9bpgQqiFvNWK3Jnr04IcZgIPHT9EiToWQUNZ1vJNjv4Tyrf7HXa2aM+dkSR/oBbMtdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nQ0Xm7JS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nQ0Xm7JS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F2251F00A3A;
	Sun,  6 Sep 2026 15:02:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788706955;
	bh=WbXlXui8Anyv+Etm1F8ZPmDAWqTncHIJcg09pdQBlZQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nQ0Xm7JSpTQybNzpXBHZMoiWqH43yd3Jo07vCy6R9udNwNp9t8GBwxX6K2wyAblMa
	 Pgcy5LP9zSCrC1bNGyGWuTdohgIK+Fpj4Y9X0eX/lxCMi+57NZ1q+KjlTVqoytAv3f
	 5KcM8jAMdoP2CubrNSwqMhpBdaZhoifngStoMICDkvBe6/qmN4hF621wwj2DELWC8C
	 yFaKpuC/B9ijfGP+FgWOTGx/2e1K5VJNhYCgw5/HDVefA5QYo8hcJGJvM3BlxG2I5F
	 Bk+eIHlTQqeCtAnRsBmD+fusVLZnnOOx5mCP9N5rkkRehE7CmiPAURVptk/hYvOCWj
	 R7HC5cF6Tb4KA==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	Christoph Zwerschke <cito@online.de>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Vegard Nossum <vegard.nossum@oracle.com>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: Re: [PATCH 6.12 161/403] Bluetooth: btusb: Add ASUS USB-BT540 for Realtek 8761CU
Date: Sun,  6 Sep 2026 11:02:26 -0400
Message-ID: <20260906180500.reply1-sasha@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <35c4c0cd-3bfb-46d7-8a05-a91820001915@oracle.com>
References: <20260904045734.806166532@linuxfoundation.org> <20260904045738.512064718@linuxfoundation.org> <35c4c0cd-3bfb-46d7-8a05-a91820001915@oracle.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> I think 6.12.y misses commit: 4a23ce935f74 ("Bluetooth: btrtl: Add
> the support for RTL8761CUV"). Should we drop the backport ?

Righ... 4a23ce935f74 is missing, so no RTL8761CU firmware actually gets loaded.
That said, this leaves the device exactly as non-functional as it was before
the backport rather than introducing a new regression, so I'm not making a
queue change for it this cycle. Thanks for flagging it.

-- 
Thanks,
Sasha
