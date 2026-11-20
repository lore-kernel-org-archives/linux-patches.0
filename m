Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795207184;
	b=rkR4uTJxCc1DW51wbAuuVzXvYR4MmQ+fynD0I4XyNKU+i8w1NvKR0N6PcEkaUTP3wRFi
	 r2A98mhJfC1QMpapkYPNQzV66PRHlm/LqzFYQlQkUNlrvFqpAvPctihGVsM+ToELhestk
	 kPaEUNZob8XIy7V9dt7oS47UD3fRiB6Efb8gNJpif5esdObkrr3TIFDa6kR3qOkrkFvI+
	 e2Bw/uj4DCVWpXFWzcStQ4Xw9odPms/5y0/CrxFkTXuzVkw8RYbBlwzKgKOWfUgmezM7+
	 V+J+EmxwX6xD9E7Mvka6Vw3ogL/HHwjdPXNFJ7ZGUAKH03wJKth5x0mzzA2W/zXc2rQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795207184;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=RQjHoQg2SeAtlNCOrDFf/6LByv3VuE1etO4z+1nXNYg=;
	b=iuf6Tf5kvTr+C0Wmd0rYFwMD8ZSA0N6yPeoYSzrmXMf12jCcG4RHDgXV2mkxt841cwTg
	 ToWT4InaMW00KgPDVue1YUn+0WES8VtBfuDqmsklmWXSikxjSR0hUuaYAcqDep5+NVdZd
	 7SkLWS07rsj65oHFkao3m6AvTHmNU28llRKgeI/pcN3jii0vgMVV3S0FKBvjG7wOpkUEg
	 obDZvUTkb167/HhWzBPxKmsy/l9TDi63GKqQ1DHdjWaXsH7c76Tix7LazaBjr4KhdXuIC
	 wKa4GoGrJAfksYNsF60QDQXSzaXkdvWufeI+UY91OHfrpMgTjX2488dEB6LxOvjSWZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="SmQt5/oJ";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E990606A6FE;
	Fri, 20 Nov 2026 20:39:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SmQt5/oJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50BF71F000CA;
	Fri, 20 Nov 2026 20:39:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795207184;
	bh=RQjHoQg2SeAtlNCOrDFf/6LByv3VuE1etO4z+1nXNYg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SmQt5/oJ9bZbmyDto71PfevgmDEBgE+Us0fmbH14VbMSXi73GJBLMq+CnJml6nLNb
	 ZC/r8m0IrlslQceu78B+DQNMs3JISUjxmcaJ3HHNI9rGQRBgaDv6c8YgiA4BGAdJjt
	 hpB2cLlUpi2NsRD43FWpG4LZsj4B78PFnsL8lcFkws17Jws0xSk2oLMCVH/A29B2Wj
	 4SedFKDX+HKxSxCPpGujgUkfDx1xFTLgz8umHoeU3OQa20TQOwlfUkBDXG9KWTzlOJ
	 dUgcMvHgQUaL/OBSEGS8I/x8RzXhqAflcM3oIKHaV78A3BE9xvJ+BqP+KKOO1ZS7Gs
	 soEDUZ6ijJRVA==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	Tao Chen <chen.dylane@linux.dev>,
	Andrii Nakryiko <andrii@kernel.org>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: Re: [PATCH 6.12 1363/1756] bpf: Add show_fdinfo for perf_event
Date: Fri, 20 Nov 2026 15:39:02 -0500
Message-ID: <2026-11-20-1-daily-reply-0013@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <e454c187-a5ac-4662-a2b4-d186ad3777d4@oracle.com>
References: <e454c187-a5ac-4662-a2b4-d186ad3777d4@oracle.com>
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

> Could we include the helper change from 823153334042 ("bpf: Add
> support to retrieve ref_ctr_offset for uprobe perf link")?

Queued for 6.12 and 6.6, thanks.

-- 
Thanks,
Sasha
