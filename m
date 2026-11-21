Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795274880;
	b=Pgc3t5hTLZj59RzAk40BIuWhgOuPYDOs1Awuf7rEl2n14TPfwfJXn/OHv1CGek73MXgx
	 tZ1yc+ZyVFFFPg58q5MlCU24yat6hcRhH0Ah+uNoN5J5dp7r8tqN65lZJ/UxnZBGMavm3
	 J9yxI2GslCmCE1+p9laoHRjsE/yjiMlWAFHfFbeOk9EiEflnJE1iV+iOXW0NFGI7ZBjtA
	 I2Y/VITmitPhJ/8RKlMD0Eb33W0V0DxTntcz5H1aei1W1TcNsDi6l8Ezi4IpawMBOmx8V
	 vau+03Chu0DYQXuytc7AcsRVHp3iAzBKuSVbG6gUPUXP8RWlxCmk8PWxgsKZ9UfJ5pA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795274880;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=sAkmsL5Pjh41F+E/anfhN68kywwizExW2cPiAYhQH3E=;
	b=lOJQN7cj+BP2wpznFd8ZOvJursb6xVC42wTsVHk6EOaRAdAE0g3zidpLERrBWuGz7fvG
	 tSjl+JF1y39u+W27EG6MT/MPhmDQZ+ibZVEMltU2TQx+7lmiut4PD+pem+/PfxNEdy+7H
	 tBvL/yuJqaheqq+0YRHJbkUUoOGAGnTxLWtd3DL5c6LR25qbscNPuYizmECJfKW03xfxE
	 +QP/Vk5eNxfCO0MW+RWxQnSMcjb0D2Dur5LiffRCCgGHUrf2hOWF1gPJCyXmYXRv/Ph1z
	 xJ64B1WPJVo71IDHvCfU8FkLdvtMcYfspzMLd7maiCBGJXkrmsNDh4rZNwKj2dH9r9w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dLkgt7Aq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8B52606A320;
	Sat, 21 Nov 2026 15:28:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dLkgt7Aq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F3FF1F000D0;
	Sat, 21 Nov 2026 15:27:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795274880;
	bh=sAkmsL5Pjh41F+E/anfhN68kywwizExW2cPiAYhQH3E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dLkgt7AqkZT15bSnhGdbtdrGBW34Z9DtMCH3TGoYlhI+p7yjaYvGg+JxubGRsMWfb
	 KU22vEvH7lhNB/jg7hEM5BGOvRUcVdlIeeTwYIBDkkpZ5sxevNptThbfXO9dn5FG1k
	 1LfEhzfHMFjDVtC6CLwfjan00kv2aGEDq/5Dubot5MaM3SN5JtB98MMwe/jRRntg+x
	 cQCyZoGWbdBAMvcFOctfLQ8Y7Irykhy3FZl+S3QFJ5TfDCSVMmrdsWuXRbIX/jHB1Z
	 Aw2xJ+9980U84pkZxV3aJbd6DaUiX/jyJVZvdzBdy95yn4NrvYe/ytj+qybjwXbjXm
	 FElAsBKMB3MEQ==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	Devin Wittmayer <lucid_duck@justthetip.ca>,
	Eason Lai <eason.lai@mediatek.com>,
	Hans Buchheim <hbuchheim@gmail.com>,
	Sergei Melnichenko <sergei.melnichenko@gmail.com>,
	Felix Fietkau <nbd@nbd.name>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: Re: [PATCH 5.15 0591/2214] wifi: mt76: fix memory leak in USB TX path
Date: Sat, 21 Nov 2026 10:27:40 -0500
Message-ID: <2026-11-21-1-daily-reply-0012@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <7ba937e2-8cb7-4e87-82a2-878b06f88478@oracle.com>
References: <7ba937e2-8cb7-4e87-82a2-878b06f88478@oracle.com>
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

> In 5.15 the freed packet stays on status_list, so a later status walk
> can access freed memory. Before this backport the USB error path
> leaked the packet instead.
>
> lets drop this and fix it later ?

Dropped from 5.15, thanks. 6.1 and 6.6 keep it: they have 2a9e9857473b
("mt76: fix possible pktid leak"), which releases the pktid on that error
path.

-- 
Thanks,
Sasha
