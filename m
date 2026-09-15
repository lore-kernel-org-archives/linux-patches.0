Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A30663D0C1D;
	Tue, 15 Sep 2026 02:04:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789437846; cv=none; b=TmPqdLiOaPrt+0/Uy0ZpzwubLDv1dlc6N0tDtzFsvFkqFraPBupFgF0cTFMv1dzgtvi9sVLSuvFFwhFAQc0M/35kkBzF3quXyxga8AQwYVLh1zbgP5cHiDAGHQX3Me/SH+sOT+wFhMqb7xOTGY+4szN9LE8MhywZTXdGCtKAEPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789437846; c=relaxed/simple;
	bh=EoQr2qYfamCC/2irzz5uRRl/kQJpvHipyiWEJsXnY1w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kkjzJ0Vx1AbFuQqkiknH1co0D1IcnNXbE9QVVSx4Z0xZdIOdAuL8XxyGhL+0+8ZhE70LuEE93sxX9A3o89IErh0nwzqOyuVsHsi8WdjT+pOTI1uxBjMiAdmdDFkuJyPqSPuZP/ks1VFHmgqDR4QwjmsjAbcIkxtDK96OGbNYdZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UIoTNmkt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UIoTNmkt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7A591F00898;
	Tue, 15 Sep 2026 02:04:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789437845;
	bh=Z3b7D1X8v3uRsLY20dIkfU7a2HrwYbTrpLsHn1BzQdc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UIoTNmkthik2Iz9IKbaU4aDDIemE4djin7b5bWs/Po4j8KVqbPrZWnXLQjIb6fZKa
	 iZ5MOsMCcuSQOBxh99hiZaYzgYtrRs+p9eBLuiAjof8CfwyqtafW9ACaNlOKLGDMXp
	 jTfviLUCokbDuYygyHgR7nRA6xBCbYQ6bNT+2+fRRHkiZHhucNNZTfSQOiik63vmvk
	 DVXheHP44UP4SU4zDbuaYgIt7ChC9SQSQ3IpJC+kE+WTCMyLK3fFUF+LwGTy82IdJX
	 244JgfZTaR1FE6tIjJ1b3r+BlZxvTCpKyeOk6SSIkU92+jEQm9cG0Ds8Eqycc8nngv
	 sz+YIFA4JKWww==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	Lee Jones <lee@kernel.org>,
	Manuel Fombuena <fombuena@outlook.com>
Subject: Re: [PATCH 6.18 0286/1518] leds: st1202: Stop pattern sequence before reprogramming
Date: Mon, 14 Sep 2026 22:03:36 -0400
Message-ID: <daily-reply-0020-re-leds-st1202-validate-pattern@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <GV1PR08MB8497A49470CF9120A7C93A11C5BB2@GV1PR08MB8497.eurprd08.prod.outlook.com>
References: <GV1PR08MB8497A49470CF9120A7C93A11C5BB2@GV1PR08MB8497.eurprd08.prod.outlook.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> The testing I carried out on real hardware included the complete series,
> including upstream commit fd2529ba8fb44cd4b56f1069363b949644b42cec,
> "leds: st1202: Validate pattern input before stopping the sequence".

Thanks for pointing it out, that is worth having. Queued for 7.2 and 6.18,
so the series matches what you tested.

-- 
Thanks,
Sasha
