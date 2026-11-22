Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795318786;
	b=L2FUOtzHyQ3PxGxo2xzeV2E8OkC0Ng7fTV0pxv5oYz47PRg9M4yY8wphM4lKeR+fcXpv
	 eFIDDXfqBuPTdx0uinMtGMZ6KBmzjnBSAUQwd6bbeqQIx9nYvEuugEwk5/zcVdRF74A/c
	 c3WeOPpFAJoWgDiMkFmNEAY9pl3JNqUO3TiH8Eu5KpGt8CO5aquYfCaFjUtBMC11mmoY4
	 sknCO5j/UYPm6TllBEz9MWqwwW/o4XWhNJMTCV7y+J8gfhbr/2hLCdTpDiwnHUSrSeopy
	 4Pfq/vAIFaosCDnt+MtUkkwNes2AZdKbFxqE972UxKfuyxoT1lWEynNPnSTgIQ5SOQw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795318786;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=PdTt4l87ID43qofAwDMprv0gY4y5BLUSZ1tGVUCLsNU=;
	b=sjrCp1X/8NYODYKFY5G64/LBcDZ3b8+8JFFg0uZpCWrsRI8jAhSf4OYkLh7uZsQp9K92
	 JgrgrrCJiFAELdDttmp5AMFwNOGHCYxT63GfFex0jehMaW39gzcXZZFo5axZzGP9r7FnB
	 aI+Bdjb23EcKTY8xWCANHWj9g/efYET6SQb3GvOwCkPk1HqnPNmt60IkQx8cYMyqrwkAm
	 5MvY8FfueZ6oFBz228qkSDmp8PvGqt1z7+SPz92XYdE7iMncB+gi2+RMD+d7W8nuDnPbZ
	 BGvuSpVFXNwyhUeJr94IXyUCj1kxwbnKi8m8VknvibnOJ8cUaNHsDUEc1VNPbyybfjA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PQtAuVVR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE9B3606A32C;
	Sun, 22 Nov 2026 03:39:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PQtAuVVR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 593261F000C4;
	Sun, 22 Nov 2026 03:39:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795318786;
	bh=PdTt4l87ID43qofAwDMprv0gY4y5BLUSZ1tGVUCLsNU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PQtAuVVRlo940IiLmLtzcJXLu4O97gUyWWvm/exbvfpO12K2vQoj1/WUgxLeQ820w
	 l/QySThToO3OIjO1LuhSj2BJnQlXBZ2rmzPqCr5OxRwchX5WbauWIeGA9dKTHaN4zc
	 KAprn+qYCBXNh0G13eo1R2VHr4wCwOVjnniGPpZzDGaGWfnYSzgfOtIQoThT4gNQ6T
	 lkteUTpgfo0Ml6OxkUGC5OFPwedYGd6TbyUEPzKs3wB7qs1pq+8iBho5fexEhI4fXB
	 H8oXMrgyI+a1PFMlPkEohjD6RVHREgS08Ja5ZrJSzDZj0kJr3ocYDT1PT+jn+tHmIm
	 qh53TN0+V9TaA==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	Florian Westphal <fw@strlen.de>,
	Eric Dumazet <edumazet@kernel.org>,
	Ido Schimmel <idosch@nvidia.com>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Wang Zhan <wang.zhan@smartx.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: Re: [PATCH 5.15 1213/2214] inet: frags: limit the truesize of a reassembly queue
Date: Sat, 21 Nov 2026 22:39:10 -0500
Message-ID: <2026-11-21-2-daily-reply-0027@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <6389e16f-c7ec-4bd9-aa46-9abf015fb19c@oracle.com>
References: <6389e16f-c7ec-4bd9-aa46-9abf015fb19c@oracle.com>
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

> IPFRAG_TOOBIG reaches the unconditional increment even though no
> fragments overlap. This result is new in the backport.
>
> Let us not drop this but somehow deal with fixing statistics later.

Agreed, it stays as queued. The counter will be fixed by a backport of
6fb4e32f2ce3 ("inet: frags: prevent acceptance of partially
authenticated reassembly"), which failed to apply to these trees earlier
this month; I still owe that one.

-- 
Thanks,
Sasha
