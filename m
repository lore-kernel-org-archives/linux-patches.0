Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66E97411FB3;
	Wed, 16 Sep 2026 19:28:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789586927; cv=none; b=TlqZjQSfJvgAtCU3dciM8GhpkjicbzAjNwbW3hAul2cyO5VCtImaxg+mDsSlW+id8TnAan0E77hEfHy26j6TpIiMC5FN15NSqYRtA/+tT7QMEEsYijEvqYsL2gmJcRBTxkgVAxV2VoDieBlFE1fHk0/badjiS2qJIPsAcTP0YOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789586927; c=relaxed/simple;
	bh=sbhTcLYtVqefh7fq4T8HW0mraU5xjymTUJLjNZ8u9X4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=odV/TxqF4+7HDuCp9KB0oZAdDk8UTfF43dU9RG7L0cNWhE/eXvPPgUfq6NA60UADH81VrpCQikwSEm7T8f83Hvah2HkKYRZtP0XOTld5MgeUPMo2HVILhQ2u5YyK6PXpkRo8aKdK4cIj5v9OtVU+sYyZzaKP0cxT4mc1IhDJe+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=idgTZnHT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="idgTZnHT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21F221F00898;
	Wed, 16 Sep 2026 19:28:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789586908;
	bh=DzraeT7Rg3cRyLztxA+mbPb9OEVmqTqRNLwXjf4BgDg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=idgTZnHT6C4I8K0BepihP97rGPLO+SsPh6CSTSwYgfhg/ETTd8uzJrthpQqWBDHor
	 eUnYR2ZV1Np5b5t5LcNgc0fly5L9hWmJLAXk37UsBvzALAc2wns9uKT79gzwIdZGkm
	 iztiG4Ciyo1kUohqj8j2IrFCsUfKz9nVh+bfYDCPBr7vlbPri790EIn8+qsZi1qrCM
	 KWc1G0UqShDWvybOOkfYr2AxH3VofbOCsUmBaxNNjIIuTraZIBLLSBAl61Q//tu7PN
	 wJ9vcCf0OSqNne2lCUK7U4HoTHqmVvRAQ5pPy/0yEdrgCoDUsVQEYQg/7nNl0g76+r
	 1AC+BSG4llYjA==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Atish Patra <atishp@meta.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Vegard Nossum <vegard.nossum@oracle.com>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: Re: [PATCH 6.12 0505/1376] crypto: ccp - Fix memory leak in SEV INIT_EX path
Date: Wed, 16 Sep 2026 15:27:53 -0400
Message-ID: <daily-reply-20260916-0003-re-ccp-sev-deadlock@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <8552fcb3-e14a-4485-9f86-52a0c5f6119d@oracle.com>
References: <8552fcb3-e14a-4485-9f86-52a0c5f6119d@oracle.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> Upstream c8e53ada20d3 follows b0e7ec0dab242c5e480121ba12400d0513e37ca2,
> "crypto: ccp - Fix possible deadlock in SEV init failure path", but 6.12
> has only the former. The backport retains locked=false in
> rmp_mark_pages_firmware() while sev_cmd_mutex is already held.

Queued for 6.18 and 6.12, thanks. 6.18 had the same gap.

-- 
Thanks,
Sasha
