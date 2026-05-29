Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFBA43E1225;
	Fri, 29 May 2026 12:44:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780058652; cv=none; b=QN6PohdUglN1/jtrsGkbYf+NhrnjiS0a+kGCnLbCaRq/Ug3zU9DPGMaLhTI+W99NTpMi3FkMtdr3w20vpfxYY7VzOX2q6rAxc/uZ8U4jLATa8REf4QcWe9eNpEINpazpfXVkCRFm05Y78tRrxNaHVL8hy+KAyTqLsJZl1/sKKU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780058652; c=relaxed/simple;
	bh=4gAXYJiwPeq/SNk677kWjgOzGdtIa1uR6yntyWWCVBw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OOT12etMZxUXrC/KGkGrjfTmzq+SRshqanUZOLoHg1xgyKrOLikkYZDCCvMPpa9KLGKRJhhh4gpyc4V1t4vEQgCnyfi+iddxsnZGwn8JV5mL7GkeJu27E61A8QuSxup+LWcQFvHGD6w+AzZdo37n0M0WYSl8NASAkS6GaBiSY3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IRWFsgkF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IRWFsgkF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53EFA1F00893;
	Fri, 29 May 2026 12:44:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780058651;
	bh=4gAXYJiwPeq/SNk677kWjgOzGdtIa1uR6yntyWWCVBw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IRWFsgkFqJhR1oyQybAAr6ZeR4t/bu71idc17uBdn4c8ipimROLtAbdXSsjoxBZV1
	 8/WVUTR0lqgMLrNgo7JEFXtBtxPsvVZGT3VonXAB7+f7pVARMTtDZw5neuIO0tt4kb
	 teto0tflV1uOm0NqaSVhRlAe2xTRm3WfkyYRGpel7lXiBZqRxKoXxA9kNt1F3dqbzF
	 CwlTVIOFyw7MZ5M2op1wpZjrSWTZ4y4xNFNC4QA4JppJHX51b1iQDh6MHN0bOZpoCe
	 fL4Re3VTa5uQpXYUUG22eMgXLusAMSOaGV7MlOQmjrSkTChweTY+0dw3/EQ7LYZIwZ
	 DJdm4/dkNkNew==
From: Sasha Levin <sashal@kernel.org>
To: gregkh@linuxfoundation.org
Cc: Sasha Levin <sashal@kernel.org>,
	bird@lzu.edu.cn,
	kuba@kernel.org,
	kuniyu@google.com,
	n05ec@lzu.edu.cn,
	patches@lists.linux.dev,
	stable@kernel.org,
	stable@vger.kernel.org,
	tomapufckgml@gmail.com,
	wangjiexun2025@gmail.com,
	yifanwucs@gmail.com,
	yuantan098@gmail.com,
	Wentao Guan <guanwentao@uniontech.com>
Subject: Re: [PATCH 6.6 229/474] af_unix: Reject SIOCATMARK on non-stream sockets
Date: Fri, 29 May 2026 08:44:03 -0400
Message-ID: <20260529120000.afunix-rc-drop@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260527094544.2344825-1-guanwentao@uniontech.com>
References: <20260515154719.961677988@linuxfoundation.org> <20260527094544.2344825-1-guanwentao@uniontech.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Wed, May 27, 2026 at 05:45:44PM +0800, Wentao Guan wrote:
> [DIFFERENT]:
> original patch patched in unix_ioctl(),
> this patch in 6.6 patched in unix_stream_read_generic().

Thanks, good catch.

--
Thanks,
Sasha
