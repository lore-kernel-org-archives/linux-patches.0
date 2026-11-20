Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795207191;
	b=UgLbTelguT4Z6P3/MOHBXM4rIF3MDaxMmZS3sw9G02+hPV+knrrNUy0Mm+1dnLXgIMzf
	 jQSchbgY4EwGhj5Qsu8qhxI8Qeplw3Mb/WjWEvUAJhPYtjraZy+QLaYubpVFYtpz1F5+b
	 8R0HH5j8bIwkg0irjPKtQ001BWp6x6wcFnpQHJEZAOvykaDg6llWOqp/Ysfudbnu6hiZv
	 MbU9QI+RctSPnu3J9kXlTZvVia0S1aG6ahSzZQdxAHv0ZRlTQj4bAuTpbgaIumIxsMS1B
	 wG5zt9H3sISM3ywi3xec+hgKN6ZmNDtRXwijZe9fL5HVtcZOkNWdhja3VHZt7qUyntQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795207191;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=y4ktv8LnI0QyrmsVLYgwBkh9j/OSk33rJ3hww2GTZ6E=;
	b=SPaDd23sj39E0MFnh0VRmqGv3MwwCRlUynhQrX1tWIs9zt0vptMd/0O+B0u0qGfmPGLY
	 tSLvn/eXyA5hwjfMf52ndE+mzzixesxq8hWz8sZtfxHKYjOhx1T11YhS3yEljnNrmXeWI
	 Ha9u8sS7mfDbL6F7cp2nzh1n6XuoNpaDrr1pA6BV7yGwIKRCh3MgKARHDupUKOHYBfa3g
	 f8+DiarHDpmPGJsdCgGyuPRhh4Ardz3lvHKo4Rksj5cgvJdA923V1kBrJqih0KGY+H8Jw
	 xL0NfPiayLz7L+U70m3jfoVn/yMu71JeIzgCZvNgbmGaOE1ngBTiHOuiJPW4xeqPOAw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eIiuzBtC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B8AB606A6CE;
	Fri, 20 Nov 2026 20:39:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eIiuzBtC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39D1E1F000C0;
	Fri, 20 Nov 2026 20:39:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795207191;
	bh=y4ktv8LnI0QyrmsVLYgwBkh9j/OSk33rJ3hww2GTZ6E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eIiuzBtC0vqpkqnfygCEYPwzId72f2L5Tc0hL1kIYPCqGZpJz4ZmBPbIZRZm+Q1G3
	 YGIow38MMiqKr1+S+twDXERppuoxtVDHScN5xQ75nDe+QFXKv75YGcZFwJHRsUrKPz
	 6cDpyekhEamuKJnormtdGe5FScpH59INK7We/EAWV0bTaCOMdTFbazNYT3aEu6GVEA
	 JKsT3OCaQxebuFlwQZwS2BM8n5hkia4RU5pVl3NsOGh4IiTzYQDCqQkICDARFlcHH0
	 vk6YzxfDSqDiOGyEdP+/NcYHzD8ZNIq+ZiUrSEvIv0jPOuAsyV8lHrTC0pH3KiHvhz
	 3k7JJm0UCrKhQ==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	Usama Arif <usamaarif642@gmail.com>,
	Joel Fernandes <joelagnelf@nvidia.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: Re: [PATCH 6.12 0450/1756] Revert "rcu/nocb: Fix rcuog wake-up from offline softirq"
Date: Fri, 20 Nov 2026 15:39:07 -0500
Message-ID: <2026-11-20-1-daily-reply-0018@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <417bce40-3566-4079-8241-2704cce5f7a4@oracle.com>
References: <417bce40-3566-4079-8241-2704cce5f7a4@oracle.com>
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

> Could we include 0999f6156013, or retain the offline-CPU guard until the
> IPI helper is removed?

Queued 0999f6156013 ("rcu: Remove swake_up_one_online() bandaid") ahead of the
revert for 6.12 and 6.6, thanks.

-- 
Thanks,
Sasha
