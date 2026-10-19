Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792428891;
	b=YnhvJRIs2vv5iGpvKck5xkiQ4dsyAPiqkmX+1k+bPyBW0hYvHS+iiMcmONPySAuET+91
	 xk/KTmCOsY0tzpd7yiZn4fpUI1gHvINQ1r2R6ciuE6V4zNIDOMfeezY/moY2yMfZb6z3X
	 jy9Qt1IxVQPobNR9EaOtusZPGSFlKZogMnhIRH4i9CPcds0enia8jWsPga9INI5ZGHZaW
	 cV+SvsBoDwb1fojhP+98J7oHtceTgz54KIzV/tlFZDKd7FaqOiKlgV5Z9OqFHKv1MPQ87
	 j2rCL4tBLcUPhhHfnyyt2b+nS4qofmUoRtVcF0LLuKOHcS8OXyjXX78p8MvBnqm6Raw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792428891;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=blYG7okg8nrSPkvv1vYfUDKjZfs9B9neDOavkO6laDc=;
	b=1p2iiCPFk2lUpTQoDuMFBb00yDBa3sP+ZW4GZk4MtjmS0C8zpAtNtCXykTmw3cpe4sAf
	 4nUpHu5I1VrAsRH1vPFDwZUk/N6ybrELTE/PXf4CYpiMEXU0m0NlkSAXDCU0S4jDUS+wK
	 c3kEQG/fqvmKwqQ+e+r0e7MSsHLdWe4BdY/3RmDhgMug3DT4XVUUT35kMvxgey/PVYwSh
	 X+bE4Wpt5ud+Kw1l7gJY8c6m5eLiuhAK8g/h1KsYCjWG+tu9aJGkSaxoHfnhYirws+8KS
	 +nAhUuIF4TjPYN45ZR6zCbR1VEQ4+AvP8cirdFl/GutGeErhffdPTc5XtyerGf3dkqg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XL0S+1Ln;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73D0460A2611;
	Mon, 19 Oct 2026 16:54:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XL0S+1Ln
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 831521F000D4;
	Mon, 19 Oct 2026 16:54:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792428891;
	bh=blYG7okg8nrSPkvv1vYfUDKjZfs9B9neDOavkO6laDc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XL0S+1Lnl/QzEeJ37XpI/DtM6a8e/G6sGobAPQaE4QH2246uA3Vq7QVoGvGPjvtTO
	 0YrCX1JG0Ayqnl5XFG0gierCLG6xD94UzW32g9Pf1PQa8fuZmucJKqzpx0e0OWaJMJ
	 qmEKiqJaNrXOGN1BE9NkDi3om4jI4Kc5m+JkdYB3yqljt8oVKW5EPnjPmAAQjDgsL/
	 HpBsCFkmWBXBx2nu86JI7xhpPxbUF6xxBjbMngJwyeg0BitS/F7z4SjcKpxU5ugadC
	 eKv4sGhWg+i/2Rvc/VYNE3VsXn7YiVUxnJ3r2s2pMaJ0bmFjJlzcGE4h/0qneXelJE
	 YdONs+GzvOmkA==
From: Sasha Levin <sashal@kernel.org>
To: Wang Yugui <wangyugui@e16-tech.com>
Cc: Sasha Levin <sashal@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Kan Liang <kan.liang@intel.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 6.12 543/869] perf tools: Use perf_env__get_cpu_topology() in machine__resolve()
Date: Mon, 19 Oct 2026 12:54:31 -0400
Message-ID: <rc-reply-0003-65f0fe218835@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261018212219.A23A.409509F4@e16-tech.com>
References: <20261017160036.979869304@linuxfoundation.org> <20261017160051.014967079@linuxfoundation.org> <20261018212219.A23A.409509F4@e16-tech.com>
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

On Sun, Oct 18, 2026 at 09:22:20PM +0800, Wang Yugui wrote:
> please drop this patch for 6.12.y or add some dependency.
>
> because of the build error:
> util/event.c:775:32: error: implicit declaration of function ‘perf_env__get_cpu_topology’; did you mean ‘perf_env__read_cpu_topology_map’? [-Wimplicit-function-declaration]

Dropped 5484b43a0ec8 ("perf tools: Use perf_env__get_cpu_topology() in
machine__resolve()") from the 6.12 queue. It is also dropped from 6.6
and 6.1, where the same perf_env__get_cpu_topology() helper is missing.

Thanks for the report.

-- 
Thanks,
Sasha
