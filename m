Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE47D2F8EA3;
	Fri, 18 Sep 2026 00:52:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789692772; cv=none; b=tCzozaDiHKSLcI/GVjRIRxMncWg6xCpMoC2Kvoe1O7luxBUy+I+mx6o0gbtznFIGiUtmnWcSsqI+oFhPVy+QdmzajpvpEFPMcrzDgBX/gC2iKihvOsvNp/2XQ4BYz4d6cAj6GQmhBSiJ/dC7lgHPPGRZ+hM7a3Q1kFbMwIIN7/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789692772; c=relaxed/simple;
	bh=RIWe9JJYTIJ08u0damYVibDfKedlRdwA3qZjV2J0ba0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eJonztRIlKfT/1ewV4wXTEnpiAxDF7LHxl/SLQObhMvyhztpCNwQpKpXS4SCqsBrmuFFlx0+kugwkPq7wHSDbons+6sldR60sBEyTpof7uIxe1Xj6wQvTJ5Kt22qZExsoCCdcccPmowGEepIR11OalnPOOLsgGAgqkgJ9Wn7gbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Dcz/BkpI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Dcz/BkpI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6965B1F00893;
	Fri, 18 Sep 2026 00:52:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789692771;
	bh=aU1WmNXjGgLFEwV3D7HSJUfixZMg0wdQKZK+8KHzZcw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Dcz/BkpIPVDPh2Ill5gIkIwZv9rq6JjdAzHTh5rsmDk1clInF3XBugAUppakw+FJ6
	 zYhti3YkNBpXGZLld6mJt/TD7M6WUR3xvMxDKqDGslqUYmnlRW1Vi6EMKlNh5fk+BM
	 EqvQo9aCDPds6ZdCdIHYBd8qIafffd5DiJAI94ZaLG2J3Gbhg4p7LEA6HQHvlSc8ZL
	 ZFj3S6e2kiuoNRXynXW0VaFvXFyaOWBHB9yR8notvJZeit8EcHgHUS+ICnBWXK7iYj
	 Wgx/dc7xWzScthPqbWsQ+pw/tUPIj8RDTJLKC4Pe37UqzZhT/L4z87ZiTQ2l3b9Yh6
	 ZpIsFCKPXb2bw==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sasha Levin <sashal@kernel.org>,
	stable@vger.kernel.org,
	patches@lists.linux.dev,
	Tianyou Li <tianyou.li@intel.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Mitchell Levy <levymitchell0@gmail.com>
Subject: Re: [PATCH 6.18 1481/1518] perf annotate: Fix build with NO_SLANG=1
Date: Thu, 17 Sep 2026 20:52:29 -0400
Message-ID: <2026-09-17-daily-reply-0002-perf-annotate-no-slang@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <aqsb9cc0sIUtI265@Cyndaquil.localdomain>
References: <aqsb9cc0sIUtI265@Cyndaquil.localdomain>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> This appears to be the same patch from [1] that was previously dropped.
> With this patch applied, I'm seeing the same build error as Jiri Slaby
> did on the linked thread when !HAVE_SLANG_SUPPORT.

Reverted from 6.18, thanks for catching it.

The commit only adds the fourth parameter to the !HAVE_SLANG_SUPPORT
stubs. 6.18 does not carry cd3466cd2639 ("perf c2c: Add annotation
support to perf c2c report"), so the HAVE_SLANG_SUPPORT declarations and
the only caller still use three arguments, and the patch breaks the
NO_SLANG=1 build here instead of fixing it.

-- 
Thanks,
Sasha
