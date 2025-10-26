Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 017C1223DF9;
	Sun, 26 Oct 2025 08:12:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.181.97.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761466364; cv=none; b=QCEdbLAjCFnlqjmQvlt/OKtw51loYwjh5ivgJnHoCGjkTeVFk/1afEgzm22xWY9AwH8CSd16uKEWt+Nqkp6zBEIF1jyvMTVh4zgrdhi0hJmBYchdFVBJm1fFeLv8fzhIXuQiSHRK/W3CWW0kJH6SVLY/J1/vGx9Xf1Lk4kzSiSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761466364; c=relaxed/simple;
	bh=rqdNEMsMhFsdzIj4jlmk14eVtdhgCbjIL4gLgvIJA1Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BvTcwvwZbxMqxrfiUpnO4WyW7lV34+QLnEsAdhaUyjnpwCleFlJLhDP1PDo/hSGlH7PKd3VBgmnTgv8GbOi7dqf10JdRKnwVC5PHZ2J5nY6sTrFA6z80EC2egbCap9/rS+TlJ5IPEWlF7TIzwt/lDOErXFzR6axsJFpirskK+hM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=I-love.SAKURA.ne.jp; spf=pass smtp.mailfrom=I-love.SAKURA.ne.jp; arc=none smtp.client-ip=202.181.97.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=I-love.SAKURA.ne.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=I-love.SAKURA.ne.jp
Received: from www262.sakura.ne.jp (localhost [127.0.0.1])
	by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 59Q8COLX072897;
	Sun, 26 Oct 2025 17:12:24 +0900 (JST)
	(envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from [192.168.1.10] (M106072142033.v4.enabler.ne.jp [106.72.142.33])
	(authenticated bits=0)
	by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 59Q8COq9072892
	(version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
	Sun, 26 Oct 2025 17:12:24 +0900 (JST)
	(envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Message-ID: <cde69513-a413-447e-8cb4-5627da29550e@I-love.SAKURA.ne.jp>
Date: Sun, 26 Oct 2025 17:12:23 +0900
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH AUTOSEL 6.17-5.15] ntfs3: pretend $Extend records as
 regular files
To: Sasha Levin <sashal@kernel.org>, patches@lists.linux.dev,
        stable@vger.kernel.org
Cc: syzbot <syzbot+895c23f6917da440ed0d@syzkaller.appspotmail.com>,
        Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
        ntfs3@lists.linux.dev
References: <20251025160905.3857885-1-sashal@kernel.org>
 <20251025160905.3857885-125-sashal@kernel.org>
Content-Language: en-US
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
In-Reply-To: <20251025160905.3857885-125-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Virus-Status: clean
X-Anti-Virus-Server: fsav204.rs.sakura.ne.jp

On 2025/10/26 0:55, Sasha Levin wrote:
> Conclusion: This is a targeted bugfix to comply with VFS invariants and
> prevent failures when interacting with $Extend records. It’s safe and
> appropriate to backport to stable kernels that include ntfs3 and the
> may_open() invariant check.

Please consider waiting for
https://lkml.kernel.org/r/tencent_F24B651BC22523BA92BB5A337D9E2A1B5F08@qq.com
to arrive at linux.git before backporting "ntfs3: pretend $Extend records
as regular files".

