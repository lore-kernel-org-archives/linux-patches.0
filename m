Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB545349B0D;
	Mon, 31 Aug 2026 01:39:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788140370; cv=none; b=m/d3zFIuJBz2UhIzO/fkcPnbnIS2OvSu0XteGLWhj1d8F5OX3bwe/3jsXMyimvyk2OrsFk2ZF+ZbCzaAVCngpNuibp4FDkLj7y6drbE7462EwjnsA41qVY5dTtOAyXA/Zg97TsmAZZjSQN92Fc8D/xJ4IJ1rUBOYSfdNW3Fm5O4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788140370; c=relaxed/simple;
	bh=KX6RqxGb2gpNb2sML9Phv+hD0yu25/kxmRKxVKFA0gw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ML2lYFmRIO4BnFe6g4ZRNF/0BSCpjOxPW3xu/30WLyhPAIl5WcHPIiOibGqmNBVhEnspJhEg/whT26kG8tJV0DyWwMg0ZtmhhMUc7xkGDt5b7EfiX7cow7kFQr90vWFvIF+wpKGmSkcs9Ult2kYDiIQa7bVd5J91TzPj4hH+YWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ob0rjlvs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ob0rjlvs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD0081F000E9;
	Mon, 31 Aug 2026 01:39:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788140369;
	bh=t+3qGX1snLlx02qwHiC6vKte+QLAAwTMJ9wqjC6TKR4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ob0rjlvsv5Ywz0ntqQiu3GY77b+TvCsdIZ7u1xpQZEuAdYQA+1Jm58Z9Td417w3Wh
	 ygbMb4rkvPE72wkRp0UQnjhc/3xRTL6mvNDgvIotXw4trmekqXs3GwCpMnPOvOCdBN
	 jvVWPsbdZEqOWLY60ulnfvZyjM296EPkbL1zFl8lzJcdToHrGucpZKfDutRatrYX4M
	 ktJkC4zWaxOUhKjLPS16tvK3auqjRWZdRszNjeUn661EOc6Zl7df5wU9iuYy754Bbe
	 0qop/PSYnLcJ+uCA0xXtVkmvOfukXcTxECPMlqDtPFELQC1qvnF0EM8hWOFX32g03Z
	 i1Jef4bTnWY8Q==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	Runa Takemoto <takemotoruna223@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Vegard Nossum <vegard.nossum@oracle.com>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: Re: [PATCH 5.15 224/272] ksmbd: reject repeated SMB2 NEGOTIATE requests
Date: Sun, 30 Aug 2026 21:39:12 -0400
Message-ID: <20260830195100.0007-1-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <80031e30-bf30-4bab-8e78-54a43829ead8@oracle.com>
References: <80031e30-bf30-4bab-8e78-54a43829ead8@oracle.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> Upstream, after c8b5b7c5da7d, a successful direct SMB2 negotiation does:
>
>         ksmbd_conn_set_need_setup(conn);
>
> and cb469993b3a6 only permits another SMB2 NEGOTIATE for a new
> connection or the SMB1 hand-off state.

Confirmed, and 6.1.y is missing it too. c8b5b7c5da7d needs the same
reduction 6.6.y already carries - it doesn't cherry-pick cleanly to
either tree.

-- 
Thanks,
Sasha
