Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E9D63D7D66;
	Thu, 21 May 2026 12:56:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779368166; cv=none; b=kUUjjl5CRSelHBokwPwviomZSfP5GT4ngWKXue5y4PeWxNRn3b7sHzh1KYyY+e1zphgpLuOvfJ+2CBi6WOOpT9FLkoZBvqZ8unMwSZtiO9pCk6H8mPjVxuHVnpRHpGKz9y1sT7nlgu2V4a+fQeAUVWeZgIlsBg0l/HNkbe3zrMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779368166; c=relaxed/simple;
	bh=nJik46eEYfsCg2hdV4+nyfsSrm54MBpbXPIsthiHv5g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AXm4Lw87QNlwj7ce58CTASx7/RFa/901wR34lP0xVv2md6MAvCO3NlBmwnPya6t9zrelxl3hdUFEF2S11y2TBlUpbi3Zym456xrQIPgcBCRpLMy6ibX1v12ug8WhdnEcl2n22QCoNTOpqiBPEAn5woocRNEPlZG2eY1iCV9SoRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=D2a596D4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="D2a596D4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3EBC1F000E9;
	Thu, 21 May 2026 12:56:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779368164;
	bh=nJik46eEYfsCg2hdV4+nyfsSrm54MBpbXPIsthiHv5g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D2a596D4nBGte6R81CgY0XfgzbDebOQuHfMpUM/sUIvUR9ns76lnUPELSi4vvMnlR
	 w7Asou8tm0Ly+uPh6beUSE1E8K3n2YwAvKzL4QUfvMjRRMi1/G8ePqZLF4ahRa/M0W
	 QzvLKj0lFJzGwDUtnqhVT/foSBL7aygYB3MHSJZ5fXmoK4Ybr06MD8/cDxdxIAG7UZ
	 UXI49fXpsRyTiaNGiy4Vw4iKUUKczyWhMrplH5+SrRx9UyBJZXPRXqXG/UZ1XLcy0p
	 CiQ+Si8vuSEiS3nitOduTA+6TKoArIF9dc3E9o+bIwMOwHxs75h7Q1w5uOv6GumncJ
	 /eKTkREcC/4kQ==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sasha Levin <sashal@kernel.org>,
	stable@vger.kernel.org,
	patches@lists.linux.dev,
	Amir Goldstein <amir73il@gmail.com>,
	Chunhai Guo <guochunhai@vivo.com>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Gao Xiang <xiang@kernel.org>
Subject: Re: [PATCH 7.0 0013/1146] erofs: verify metadata accesses for file-backed mounts
Date: Thu, 21 May 2026 08:55:50 -0400
Message-ID: <20260521-erofs-7.0-drop-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <ag3qlMOcTYM2FBUQ@debian>
References: <20260520162148.390695140@linuxfoundation.org> <20260520162148.691068692@linuxfoundation.org> <ag3qlMOcTYM2FBUQ@debian>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Thu, May 21, 2026 at 01:08:36AM +0800, Gao Xiang wrote:
> Please help dropping this patch from auto-backporting flow
> since this fix commit needs another fix, but Christoph
> doesn't like that fix so it never gets upstream:
>
> https://lore.kernel.org/all/agF0wJSFRAEcRP8M@infradead.org/T/#u
>
> Since it impacts Android use cases (SELinux), I will
> backport this manually later, and for now not backporting
> this won't impact any.

Dropped from the 7.0, 6.18, and 6.12 queues. Please ping us when the
follow-up fix lands and you're ready for the manual backport.

Thanks.

--
Thanks,
Sasha
