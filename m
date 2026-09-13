Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57A9C36998A
	for <patches@lists.linux.dev>; Sun, 13 Sep 2026 19:21:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789327301; cv=none; b=R5VUjw8tScv+SySti0K0QbUJB06Rw8AFwIZ5bFF7qMtqAIH702qKXwz46AUUdiAKSpiCkwzJKlNLgq0cj9LaCcnrz9faY/cJkbbspkE4qrOyrZOt/4qkQy3H1dveMUPbms6g1QlmHzvcNVtesHDEHZTrDNcRRxVob6YvxsXsenU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789327301; c=relaxed/simple;
	bh=jAspQQ6QLSyolmznrEa6PcbeUeNNtkpmVdRb8KClrg8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=qQORBgWqLp9eSprblYRwQmm/dLrst3mXWD6ro6xC/ZBr0R6izqzmG9wu0TABncVwTaREpw/Zudg9V+ZauS+Bpt/+WHW62nOPqKNUNXv1DLmr+cxmSCI7FQC2rRdTmP0kTbntJWJqmxPCnOJCIPd9NuQgk8F/Dfj+rEhOw42EB1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NBvTSnlf; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NBvTSnlf"
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-485888b3c3dso2419983f8f.2
        for <patches@lists.linux.dev>; Sun, 13 Sep 2026 12:21:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789327298; x=1789932098; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jAspQQ6QLSyolmznrEa6PcbeUeNNtkpmVdRb8KClrg8=;
        b=NBvTSnlfrOJ6StSWorVSO53WxXKvasfOcFzgh1JvSf+zCpPc4cPYWNLLhqe37rJKfe
         yKusrgSqsfKxBbgP7klSAtpCoExbFnkCt59kTQU5zNtOx9WfaCfwrDScDGAkXBHbKdZE
         4r0ubTupUQ0SajSCUPEEfF9lQ/HcP9t3I8rQSV2XGIT6gmGYzzXq3lTv8Vi9p1rf85BC
         EkdchZyTW9Gne8KTGj1S70fEo8nwVQJ3p+pENku2SL1oKxX5C43XiHE+Dege+0mSPWyl
         O/bCDl1a/mDu2TcfUwTAnkCrGJsfuNZgyduVbE9npp+dl3sqEi/w3E2K6iy2Yw8hKt9G
         815A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789327298; x=1789932098;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=jAspQQ6QLSyolmznrEa6PcbeUeNNtkpmVdRb8KClrg8=;
        b=ZpysHOYAia+xIJetiro6BrIQqG2A3R9Ccd4Xht0Mmnh9SCxq8PXPmjzhEmsQm3RCzK
         WdAMJOFxXYPxdlpPGzUgCsQACr1YtPYuZHdITsgsdrT57b0FccJ5Na6J0NCwov0eRzm2
         gKDOsBLNVMzOO+ErVVcP8bfJqLaA6EWFisPjavv4AnPRBeCXQpqgl7Jv51JW3wg/qVMX
         JloLGqjRD9EDbaTL9X6JEOpBqBzzt7mLgTWRyHBUcCfjTPCjHSC7a4dgs/sR0GioXCxq
         vE+b6jfpiUR1u79ryaF+RASyj7+jB9/szwfh896XH1lHyiotrdTmCFgk/VhaQzky67B8
         pxBA==
X-Forwarded-Encrypted: i=1; AKwUvBxLx7HakSg2qppEfqZ7JVQ/kJHFhOc1KIy18UvJMtopRxDgydYtc7P3hbNjTj6KG8CJGG7nTV91@lists.linux.dev
X-Gm-Message-State: AFuF++l4fXEQqY1owmlNXYpibhLt4yTbpmSMy+4dywf2zOwxqnK8/Bn1
	opgSnN/AXX0AwFUKl6F9ttTNg8sQHUw1In5Tq1N5Vmicq28uCtfNG6BH
X-Gm-Gg: AYBFou2i+KRuxjsb8rWYs0sznTrDspZRcAiHS5uSVW4T6RJ+Xw1PBcAq5izoM9hRZ41
	dl0rmd8iOA/x4ddlkxxVKNGsmkhmKlBdebCT68HpxJptywbLylkF1YDdFjdrwApcp+weaRrJey+
	iyZqGPpRtRlNeXYVeefvoa0t/xcJvMMolAxKHbFGzxEe+6mIOycdcL0cMvZzOrhXOazaP95sKy3
	QdXtFDps9c6VvvnBVo1Vf6mlD8DX42svne+apkthokNPigzzwJfI8dUFDn/2qaJGn9cih/Oo7Cc
	mJR3TopBkIG7FnyoS1Eni3pExkDRs6VJSL5LxQeMdeSbbKUBFLzD1oOfrUxy4EwHJzz+CLvlbE2
	6cb5VUi9uEsxi9WZwB8+W9jL1THLCAJY5/l2Bj8f1ouZqGA7I+wr6hVOzRdfkDaevGun/vYzlQo
	6lcjpUAgZ4SOBRH0zf3LDbs7LbJbZXzoO6/ZTV6CGhcnpLnOkEGXQ/7YmdHsu7GvS3BvVCAggZs
	yF0HrTS8B6o5vXTmea3nl9r197OjPq/A27xBpKCE46TUcKK20AU2otvLeVWpVzH78yw/FB56b3Z
	3iKIlBKqcJJuwnw97uSAiqiMcoxdjHW3VmZXJ+fBwnOJEcNbMITSrOoHOKRYSgfGchfRL6Qcn0p
	ftg==
X-Received: by 2002:a05:6000:40dc:b0:486:f614:dd0f with SMTP id ffacd0b85a97d-486f614df05mr8750281f8f.52.1789327297885;
        Sun, 13 Sep 2026 12:21:37 -0700 (PDT)
Received: from localhost.localdomain (dynamic-2a02-3100-a0e6-2301-7846-2cfb-35f5-6359.310.pool.telefonica.de. [2a02:3100:a0e6:2301:7846:2cfb:35f5:6359])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-486eb35f3d9sm20244963f8f.35.2026.09.13.12.21.36
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 13 Sep 2026 12:21:36 -0700 (PDT)
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Karl Mehltretter <kmehltretter@gmail.com>,
	stable@vger.kernel.org,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Pu Lehui <pulehui@huawei.com>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.1 0632/1191] bpf: Sync tail_call_reachable with callee state on entry
Date: Sun, 13 Sep 2026 21:21:27 +0200
Message-Id: <20260913192127.2336-1-kmehltretter@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20260912065602.449560744@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org> <20260912065602.449560744@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Please hold this patch unless 6.1 backports of upstream commits
01793ed86b5d ("bpf, verifier: Correct tail_call_reachable for bpf prog")
and 54c27ea6dadb ("bpf: Fix tail_call_reachable leak") can also be
included.

This patch resets tail_call_reachable on callee entry, but 6.1 lacks both
the direct-tail-call initialization and the parent-state restoration it
relies on. This can leave the root program falsely unmarked and make the x86
JIT omit required tail-call counter handling.

I reproduced this on 6.1.188-rc1 in QEMU: Linux permits 33 successful tail
calls, so the test must stop after 34 program entries including the initial
invocation. The unmodified rc1 reached 35, bypassing the limit.

With tested 6.1 adaptations of both commits applied, the same test stopped
at the expected 34 entries.

Thanks,
Karl
