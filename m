Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795318781;
	b=HBADAgVKUCD0o5ms6UQlkUUmkZLVr7f5y+7vdozdYyVGaC94Nqkj1yAI+Vw/GKBUSca3
	 iqaWZVbRuD83ZifAX6OdqWMsIbIVIRHMR6zqPoZCyLfBgVApT2b+msaNVzfykTL4HdRy5
	 ho9srAQGV+F8aPKmACPCO6C13lfI0nxBZrOAmy8wLnT37Nol5LoW6heipCI3fz4n9LWpT
	 N5abcRMN4k1yKNZ5BfMQBVZKG6QH0+Dkan/RtnnX/1GMKX+UpKDXMOoeDsfaUToM5bjqr
	 4ylt8bX+0mEqgeXcGXXKSxRs8OOuUPYk8CVxYXUgg49Zbh84CdOJDeYMYKbAiDQEPWg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795318781;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=SrRmysftA+cVQxu75poMEOgZe+eiUmykfI0fyxQcnws=;
	b=usP0yt82AMxwDLHeTS8cDx3nODq442FrSHYCbu/SYhihnzRFwb1FP3kNJ0222F2AWhe5
	 kTj+otcH8cjZpzY/5VRdP/BGADCqJAg5mh2PYsQd72M1Na4gBxR027Fn8XLhH7WnFbLw3
	 AAgRoDvbe7pPx4mJBpzc7beRRXTKnNA4upyhFURRlwDw6t2yTs/dadEqh0Fm+yl7UWwhl
	 NInF6pS5qVFpGBl0NfrEXEeNwajmL4gu2qMGbkHiOPu/6VZs4bVes3E73xzmxTQqJnKAa
	 16UTOBpgL30PLWkQhvCogfdAbRGaDbSLMaGaGSBNW3STJRm2aHsGPV90w6F0c/yXtDA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OfoLH+SA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DC76606A335;
	Sun, 22 Nov 2026 03:39:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OfoLH+SA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2167C1F000C4;
	Sun, 22 Nov 2026 03:39:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795318780;
	bh=SrRmysftA+cVQxu75poMEOgZe+eiUmykfI0fyxQcnws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OfoLH+SAVViWC9U/yhq/EeP4PLyIMVvDL2Crhu3fxne1rzkQVKu/UcTXHLE+IDvJj
	 i5D8E5BPU4OQN5Q7EyTTL38geYzc2K6TQ3D5Al28zXGPzddiR0a/70jEkkFzt24V2R
	 1n2cydvhXz4pd9VOK/DPZiGR1agNtPcBXMApNYWMYsqVJ91Ec9gfev7bmNQ9xr8ANh
	 Q+Ildcavbq31cNAdVZXiGipWb5O5mVor6YfETEo29+NXOzVaRkdqLVUpgPrhf47C2r
	 QL4fwH25+L9pOGRIKfLkhIsc2NwBPzPEyVdx3p7b+blT7DoO+NVQKoXJcgEQdfgRTv
	 a/tnIpDmcwtCw==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	Antoni Pokusinski <apokusinski01@gmail.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: Re: [PATCH 5.15 1832/2214] rtc: abx80x: properly handle shared IRQs
Date: Sat, 21 Nov 2026 22:39:06 -0500
Message-ID: <2026-11-21-2-daily-reply-0023@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <0da409e5-d7dd-4f46-a88d-d33ef17ed32a@oracle.com>
References: <0da409e5-d7dd-4f46-a88d-d33ef17ed32a@oracle.com>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> Maybe we should pull in commit: 74bff654a4ce ("rtc:
> abx80x: add mutex protection for register writes").

Queued 74bff654a4ce ahead of it for 7.3, 6.18, 6.12 and 6.6. The lock
doesn't backport cleanly to 6.1, 5.15 and 5.10, so I dropped the IRQ
patch from those three instead. Thanks!

-- 
Thanks,
Sasha
