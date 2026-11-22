Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795318777;
	b=qguRdJHMDghf9NloF3ms09zTIL4GX2fviR6gWipd+EAIeI0TB8DI0qRLL5KvMhtZfpPm
	 3+TWENIuOeFRYFEJgceW0bZCjNMLTsSL+guR9khlp3b5rLc6GrBj6HdK0DsU4mnaN49y9
	 FZjgr2a5rNzzW2QgTBBtz3fQozY4lrby3FyKKUR8vS42/GgPeOEp7szKFpnRZ9jHcMNiF
	 iCl+bT6dqXHZMAU41vHHo6CIw5G3twukmtIaEZpt942qq4faJD92VpLGSbbNc2xkgrfFU
	 kmW6nl/hGCGbcHdjNf25EMmfPzn8HKjqKRw7xW1QqPPQ/cvvpHEtRu9K3MKjjPfpPrA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795318777;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=LB6nbpBWcVgSYiPy7SprD3fL8p/ujs5B8Y6va5tsZ5Q=;
	b=WZTGZxUr9qnSHg7IVX/2Wovz0CrmelyrdUPn3Hyuq+aHPME4ZROLQMcaVhAMggFTlAjj
	 isiAkWWJ1YC2/PYnLOoKzHSxzWpWQQvPddxY9bBmCc/Om6//PajuWoPuvJ9DEzDTNgbOZ
	 2JDLX5jWD8lTaZgB70ZZa3Vz3GtcdB7a54a3pFGIBBeIIWs/rS43Ce6+JG2OvHnZWYPBd
	 lkS9Estax8soWuGrjT8cHLR1gU58aO5DSitnUYwdbRbo9SDM5wurF5kUnMRTGuehncJE8
	 +fB9BHk3LFuTJFTrXwlCWUfYF/9eAMtMD49G02quCSjKsIJYRVfl60MHM/CZIXefdNQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TkKfbi4m;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 821CB606A68A;
	Sun, 22 Nov 2026 03:39:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TkKfbi4m
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6C901F000D4;
	Sun, 22 Nov 2026 03:39:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795318776;
	bh=LB6nbpBWcVgSYiPy7SprD3fL8p/ujs5B8Y6va5tsZ5Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TkKfbi4mIZwR+/rM13yEdTdNf568YzbHxBZgZ1U7eEn+RyvbmUXP5UxdO7+YivH12
	 J2A9wvzlrhUq2qISEI8rRmDie1kWAiEWW1249Mzsjl9jzcbOSPSnFJYEh06M1jFXNN
	 E8H5nmdBkQCnh8qRval1ujyldnKFwV1JIwWeIOoSi1OGJXyu5WHVNKTSU5KghVF0bo
	 cnmqzghZmXU88Ga7L9X32mQeGoEc3SUZveeRUD8gPTdmVYwBVBCobb4PL6EhCBYHia
	 Mnx8RDg9fgYNK8ngA44onE+ZS3C7OrRytOa7IrpZkNqxLUz5x79H1q3ShgeawMLfVL
	 OlbmovsgHoK1Q==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Takashi Iwai <tiwai@suse.de>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: Re: [PATCH 5.15 0726/2214] ALSA: hda: Reject codec reset on ASoC (ext_ops) buses
Date: Sat, 21 Nov 2026 22:39:02 -0500
Message-ID: <2026-11-21-2-daily-reply-0019@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <f23e1065-bffa-465a-a421-415b09665e0e@oracle.com>
References: <f23e1065-bffa-465a-a421-415b09665e0e@oracle.com>
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

> Maybe we shoul route -EOPNOTSUPP through the existing error label to
> balance the power reference.

Fixed in the 5.15 and 5.10 queues: the -EOPNOTSUPP case now goes through
the error label. Thanks!

-- 
Thanks,
Sasha
