Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D8522512C8;
	Sun,  6 Sep 2026 15:02:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788706957; cv=none; b=tOhX93Pv/KSmhNa6FRbS0aJT/8XRHIwUTSaJ2j4rlreGCkIl6sFepKcVaXsVVRWzq5gWp7qocnUcdjdryBRMcE1tuaZR9u3ZpV8XmDQ5PvvNg2SDiXm6fbZ1ainFTMI8hYESPhEyijzIvcZrDV4OTuoyhzAVgugFHTcCfNrOmpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788706957; c=relaxed/simple;
	bh=epM8sq4bymXWhuK0aQM1VwaWRCHzsaIrgg2BHQTVQe4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hY0khzImPM5mmKeSJ/JHj7jeKTv2qvjdsNEnl6RFmH2ESVD72j23XplfJtB0yp6/XM/hc/TQmZAKzelHsibnfOeu/AqBZ/j5KFGwS8zIrsIzghlR7oLwZscg+ioebhMwSUWgBEJYMo6Vlkibc34y+XdKrD76Pm+iuPkTAymyFKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nbled6sJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nbled6sJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49C9E1F00A3D;
	Sun,  6 Sep 2026 15:02:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788706956;
	bh=IfI9e7dHNkVIoYnm+0Jl3gYrCIyG3gJEPSIXoZK/iv4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nbled6sJloctjJivgUthVlrPN10xwh4PxCi7PGzYl6b9NRrXTdRp6tw5ABTh17eYh
	 QNQaI7pZIe8U0ELy48/lxjzpsDzSPD1CaVP1m147SR4NqrmoRF5Re8IotQundWbbhp
	 iuUsMjGrIVMWZql/wGQqPow+LsCZDgH8IZ30PAp+9BJTItIPEe+KAirIsUaY41cAZi
	 6BIAsEuUtEcTUFqv9T4/Pco5NIYGH4cn17UOmJ458oYUy8UStV8O8+dQdDxZt+JZuk
	 q24K2fxKEboHk2ycyEqiE+V/2IO06dVYv0QKq1tuRBErnZjyxnlYdpioFpAIlsxqIl
	 4wfKxgjgZE6yA==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	Chris Mason <clm@meta.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Vegard Nossum <vegard.nossum@oracle.com>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: Re: [PATCH 6.12 211/403] SUNRPC: reject duplicate CREDS_VALUE options
Date: Sun,  6 Sep 2026 11:02:27 -0400
Message-ID: <20260906180600.reply2-sasha@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <c811e534-e196-4bef-b4c9-aa2bf80f204c@oracle.com>
References: <20260904045734.806166532@linuxfoundation.org> <20260904045739.654582047@linuxfoundation.org> <c811e534-e196-4bef-b4c9-aa2bf80f204c@oracle.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> I think 6.12.y misses commit: 5e9a94539b1 ("SUNRPC: fix
> gssx_dec_option_array error path bugs").  Thoughts?
>
> I think we should pull in a prerequisite or drop this.

Confirmed, thanks. Rather than drop it, We'll queue prerequisite
5e9a94539b1e later.

-- 
Thanks,
Sasha
