Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792443353;
	b=gzm0F2WfxA3QahQ+SrKtGGv4LrQ2sndwBidzKKiwvnWP179HOhFFR74r2/K9SOBktj3N
	 xTUA6w3m0xbHkhXZxnBJGHZqcxI3Z5ig0zstypEujyAjF/j/l49MXytc1UtZzJk/qOLoQ
	 Ket/F8xsJ0hlpA+/YuwUlmjlkazgkZUnz/R4s8UrziyfGttSql3uWF5mIb6OHQAn2+I0C
	 KaScLO/q9YWNjO8uIhuV+ikBqbFGU/57aAMjS8SLPNalFKWLh/BthL/JxGtNxW8klkCIl
	 lCfN0P5qDzmtncbsiaOWCkVEDA+Ji0wo3UoCjTj91MR9HmaLru3yKXFNxlFr7ZPR+Sg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792443353;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=KJs5uZLUTkFcXq/jZfUqNzqxWYFujtuEaluqbHjbanU=;
	b=hf/6Ns5OtsRV2iSqrf+qSWGQ11HUs7xz0dp62xp8Wz3xX8aet62ev12tXedhoExhmH31
	 Ia6H1uoAaI7PmwIXojIGPlzYqs5J2aKPnEwaoRJn8q0l9tM9s2aniAHTizjoznn4TBa/u
	 5EXst3dds9a2/ewe95Ao2NbUwr3XKPTDHXK7Nd0GZpXfvNtXEnHA3c44owLMP7ODayDby
	 WHT5LBUWb7Vq6blOiGd9oYm8VXGvVgsGFAoHH5xF07cCcQe69RUPDE22ptGJF2nwq4bMy
	 tGCzGraJdSgmjDP+wu/IJDy9rWoEbNNrnTSIqn+ChRpokV1Ccfi4uZHf8Gvx5WOvOzg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="bb/AIN/D";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FD25606A324;
	Mon, 19 Oct 2026 20:55:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bb/AIN/D
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09F2F1F000C4;
	Mon, 19 Oct 2026 20:55:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792443352;
	bh=KJs5uZLUTkFcXq/jZfUqNzqxWYFujtuEaluqbHjbanU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bb/AIN/Dw4UFSHdm9GYeb3CtHa4vRryepBmift4oze0qwRADkNXW5TOcJfcB+y9ER
	 7q7ewZcS+94GHjDKpsEhjV4CX0lggznD8MZmXwLvKUYuBZtd3ikXuGa9eWpz5XNAEg
	 Y32nxhjUHEM5nTAh1C7Haskf/pGgQY1AQW/yfrjYJPmygSbqtqP7pmjXUVp7FKn4oU
	 8qwasuv7xLOoZzHOBgM9YYioBJ8w5urbKS9Zo5tI0VhQmxuP/aN8jjfKzPKNSezKH5
	 Q4AaApeobgFkLHVEy+imUo8G+NY6NSodCkFj+ioPq8lAcsNEMXJuHxGxmpjUKntmQG
	 RsTwdkKuX/MVA==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Harin Lee <me@harin.net>
Subject: Re: [PATCH 6.12 205/869] ALSA: ctxfi: Refactor resource alloc for sparse mappings
Date: Mon, 19 Oct 2026 16:55:29 -0400
Message-ID: <2026-10-19-1-daily-reply-0003-ctxfi-spdifi1-6-18@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <0029273a-f61f-4b08-9a0a-79eb96a02998@harin.net>
References: <0029273a-f61f-4b08-9a0a-79eb96a02998@harin.net>
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

> Please check my earlier emails if you missed them:
> https://lore.kernel.org/stable/e5b53e3f-02ac-4afc-9fa1-823ddb80875e@harin.net/
> https://lore.kernel.org/stable/d19f3435-57fd-4ddf-9465-36f359c8b8bd@harin.net/

Queued the three follow-ups for 6.18, thanks. 6.18 does not have the
dedicated RCA switching change, so the RCA references were dropped from
the patches.

-- 
Thanks,
Sasha
