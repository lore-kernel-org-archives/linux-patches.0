Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81A9E3D0C09;
	Fri,  2 Oct 2026 21:10:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790975444; cv=none; b=HSFSvb5vJcZ67nbdApGHYws+q66Teq6RCLUNInsz8wcXiPGWllP6V85maqprcFdX3Q6o9B7r6P4WIjpeBKaQdrVfevIoqogEWFmOezrceWeEbCWzgj/ml8SqXvL9Ao6+ykkjf+J1p4ChRFt9D0PK62e44ICO3h3oSzZq10n0Nok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790975444; c=relaxed/simple;
	bh=5viF3FTVSxzNhenKfzP8MHsTg4FlbmCUqz5hmdgyPRg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N7PTSxe73h7U18fC5PBoKWYwffDsiL4HvBeiGKJ5eCFlp7Xo3/QJ7D/00oFE5w9XHXtnT8GPeDiSDFL2EE9YwT0MDgSyJDT8s/U7bf0RiokX5UuHqu9DgfqP8jTcYmFxbka+5cTgG2OxhzMvJ8NRSHFoRH8FX5ePlVirU8E++qE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bRmFtACJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bRmFtACJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 600331F00893;
	Fri,  2 Oct 2026 21:10:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790975443;
	bh=CBIxHqiN4nOzcrJLXofdggDFZzY+PkhLAqMUs18AoeM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bRmFtACJbxZCCnt/DWoBSrhmm7756H+5XPEA0VLvsLX6DsN7+/vBI3bUgCHxWQKs3
	 mtyDH6jDiucOLEuO1/T3fdiWzeMKv5bTb1SwjTBLFw2aeenFIFzXZ6pGtS5qD5dHeV
	 35h8qGgHpJEs6ZXCGgaEhwzE+KXWX3U3fo8O4Z75M8+upYS+70f3JTeAkCjnIDCmxg
	 UtegnshrYvvq+5ezqe94jJHF1ScgdkGJcvFry59YeHqT0pDv5VExdbEeptM1iqvaxf
	 TQdnmwR/asH9AD74PmExkv+pJHETbiVadsZorcZbeZAS5BHF+gd/pPJlsiVvKKz1LG
	 o6pzBDDUMYk3w==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: Re: [PATCH 6.12 107/877] ASoC: soc-pcm: Apply snd_soc_dai_link_ch_map.codec_ch_mask to codec params
Date: Fri,  2 Oct 2026 17:10:30 -0400
Message-ID: <2026-10-02-1-daily-reply-0004-re-sdw-utils-codec-ch-mask-capture@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <73b99ddb-996b-4978-a801-69a825da9954@oracle.com>
References: <20260930152414.738996857@linuxfoundation.org> <20260930152417.048647943@linuxfoundation.org> <73b99ddb-996b-4978-a801-69a825da9954@oracle.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> Could the ASoC maintainer confirm whether
> 290845e151cd4e307cc1f25319583aaceb4eeb30 ("ASoC: sdw_utils: Set
> snd_soc_dai_link_ch_map.codec_ch_mask for capture") should accompany
> this 6.12 series to complete the SoundWire capture fix?

Queued for 7.2, 6.18 and 6.12, thanks.

-- 
Thanks,
Sasha
