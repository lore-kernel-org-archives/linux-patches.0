Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 742133D9024;
	Thu, 21 May 2026 12:56:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779368168; cv=none; b=YslTE+CSr3W3bVcyPr/2z5b4elhrdyMPW+QNjUTRm7vdd4MjZRmyKtfM1p1SVR1ZrGIS2SsDZ9pj7cApEC7hfOJiTx2Z4+LMNTR/g2wkqXS+R8vNS7XlyNyu4obqicYNQGGLioTbh6cEvoHi4rQtNe1lmiwGYU+SSJUt/ew8d2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779368168; c=relaxed/simple;
	bh=eMvfHEL7MtvLfkaOfm4Ac40HGyLNl15M0ikcIJJ8dvY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rUpDkfRq4pQSr3acY7yTmjtNGmyHAZXRqZoVcpnvUcCV9BkdaLvXctD2uP/UVWVeANq3ObKSgaKZOK1WYJ6lhPQVmJcBAERHFDureSmOwSyzEzwZdQp62UYnNoqkCVqofXwiXOCCWlTxOgPnRImH5nztdsMl/Oh+rHkEB4mSJIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ycfnr0Qb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ycfnr0Qb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31F4E1F00A3D;
	Thu, 21 May 2026 12:56:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779368167;
	bh=eMvfHEL7MtvLfkaOfm4Ac40HGyLNl15M0ikcIJJ8dvY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ycfnr0QblCmhyYgideIIYkwRnZxcali9+y+iz1S8su5YZRYBFUhIPG0l7pbqq1k8U
	 Safp78AcRSh4FL8L4DKbAoFeekYUszs+j0IAN5/xRI6K2pXH0mZ3DQg+ZQO8H1+2pS
	 Oi95FDeF6Zz7tsiRZkcOCZdSf2pYv8/19RxFShqAqBn35gd17vPFkB4oyiJlB+hD8f
	 AkN0kh2ts+oV4xJA1DgPshsLTn2PVC6Q/osJojwEwCAgba6fg6IDVSVRDTdK+1bm35
	 qLMYkDfnQidLyP30K62FB1E7a/yF7v5S4hYCULZIkk4gpFMeE6wBVw6YMnWM0B9lcw
	 Kaf5MxyiS+n1A==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sasha Levin <sashal@kernel.org>,
	stable@vger.kernel.org,
	patches@lists.linux.dev,
	Amir Goldstein <amir73il@gmail.com>,
	Chunhai Guo <guochunhai@vivo.com>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Gao Xiang <xiang@kernel.org>
Subject: Re: [PATCH 6.12 011/666] erofs: verify metadata accesses for file-backed mounts
Date: Thu, 21 May 2026 08:55:52 -0400
Message-ID: <20260521-erofs-6.12-drop-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <ag37lbajmtyv9xBd@debian>
References: <20260520162111.222830634@linuxfoundation.org> <20260520162111.476779194@linuxfoundation.org> <ag37lbajmtyv9xBd@debian>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Thu, May 21, 2026 at 02:21:09AM +0800, Gao Xiang wrote:
> Could you please help drop this too, the same reason as:
> https://lore.kernel.org/r/ag3qlMOcTYM2FBUQ@debian
>
> I will address this backport manually later.

Dropped from the 6.12 queue (along with the 7.0 and 6.18 counterparts).
Thanks.

--
Thanks,
Sasha
