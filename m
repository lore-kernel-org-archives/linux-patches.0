Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795207192;
	b=jYHAUSX0polJ23nk9b9XoA+I8T96kguQz3pytLGz84456fhgO/JD0ux/DL4KjbTKp0a0
	 ZLR94u+6A7hSh+hMLDOqxzzsFZEwRQnygC52RGLlvLpSr/BOnv6d+vsP1ZK7dpeq4FXNm
	 LAMb0dgHDCZaSuX6yNfLc74iJkWzJfvnWRFomrwpzKxymHco3ZJO5ekwsM314GWb34QXN
	 gQKha9EWE508s3tvnSQlTQSioq+L2jJIq74B3ylPUgah0oKG1ybuOxYZranFkpgv3wjWU
	 fS+KKOKBjGs0XLjXYdXNp6t6n7zbxxz6oonr7gXdOeJ6PzAf4T2vNQ1pDBhRP08hOUw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795207192;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=SXGcYSJjE18HEd7COUwvpeZIMq21m/Yk7b11F9sA7Rg=;
	b=UQl00dE2SatzdBTXLNDKK++BInwPtJ7gZ+gxJWaIF5x53pmY8+EUpCWIgaL9ebbp9q4h
	 wiZULWcaxtFZsdR4VqlgogE38W/edhxF8ULvcksHZ6+Y12YS1MwpwnuLkUGEGIhNyJG9L
	 /FB2+4cEyXWcvhRhM2MbpVB9lWEnn5gkPd3fe2VTElc1VHiKW9xpB816W59SJOl7vIKQv
	 Qx0mHHWSD6mYKnWju9aYLcnw2CDn2+Ob6FbiUmsdYl/UOsOCEgarfgAEWaRHl6ow4DwSq
	 KlOrkd7cOL6hGLcP+dVANT8GV0NR+aomP3mt+ABmTdIjyPK6LoXTw5uIw1qQU5E1W9w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dH+z4263;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B414A606A6F7;
	Fri, 20 Nov 2026 20:39:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dH+z4263
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 856651F000C4;
	Fri, 20 Nov 2026 20:39:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795207192;
	bh=SXGcYSJjE18HEd7COUwvpeZIMq21m/Yk7b11F9sA7Rg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dH+z42633h6ZHnq0cWt5DLWnyEYW24DsxmfJfjaPoOcThumezEMlziMP3CMHgizqN
	 9SjCtDaird2TXWnzik7fv5ffSY1InK0sOAMN2nOY/AHgPYIpvQPRoRf14qLsz3VpQG
	 3FwUS9aOjuyH+WBKtA6wwu9bdY4OcZgPHqkWGGY1OkiaYynEr5RlLGJXe5lR6zLMWC
	 czUpNNqAmAGLfYJ/aVVQOaBmfiYo1+YETnncRelZPndSNzywg1lHkmzBwzW9051aoJ
	 hlYxtcJOf/UKqprDoAG2AjDvTNQaSX3p0EYTJLqru1GB9lxZf9cEey7/WdqojpZH1S
	 y0H+B18oucaAQ==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sasha Levin <sashal@kernel.org>,
	stable@vger.kernel.org,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	benh@debian.org,
	Salvatore Bonaccorso <carnil@debian.org>
Subject: Re: [PATCH 6.12 0695/1756] perf python: Initialize debug output on module load
Date: Fri, 20 Nov 2026 15:39:08 -0500
Message-ID: <2026-11-20-1-daily-reply-0019@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <awAMD5kuizXPSt-7@eldamar.lan>
References: <awAMD5kuizXPSt-7@eldamar.lan>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

> /home/build/linux-stable-rc/tools/perf/util/python.c:1374:9: error: implicit declaration of function ‘perf_debug_setup’ [-Wimplicit-function-declaration]

Thanks, dropped from 6.12 and 6.18: python.c doesn't include debug.h on
those trees.

-- 
Thanks,
Sasha
