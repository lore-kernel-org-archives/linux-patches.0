Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795207209;
	b=zDr0gZaT7c0/xqiCMPYa0CYy/oT/mPEA8aYV0mo1djQ66anRxyLgkeEA3R+MWW7APgv7
	 HEXvTLPZSwKozjFYlfnGeKKCGZe7Q0NjT95NDeLyw5XxQrx6FMnHzIavotfG+c+jAJWOZ
	 lzqjnEgLU8QH9ucRrTigPzi/iMMtY1gKXp8PtLdoQVogYgsN4dhxjNZwEEPqAup7LlXBg
	 A8+svA4zim8fIRgnTwQun/GAERo4A3GrU+nFh400l2UFWJpc+gPD7lSS71J8MVtt4vL5v
	 /vmEY/1R3BMl/xRvEjU4KRDxRmC2FTOUeFRr8vZVkNTYZCexnNupLXcDEeiRyEwWklA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795207209;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=XWE9ACIHV/6VpLcxPb5BEoeDXClfpUgM3S7kPnfV7Us=;
	b=x63fh6CDzA27Bgt/r2s9RC0pl8OapGnKQgKB8w/cEjVmEi9AyCE7j6hbZedGavnkkco1
	 xqTQjIl0ObQvqAMSQqlLzsVwBI/DlFaN9xcJyVfIye2/xw8Q8+re3Ws0pNnBWK0OiLFbf
	 7lt4JB4/La6AFKCBM8uKHnBpbUNJKbZ90Ded2NM6gxkQ4AMPv2NheAApZquZ8ELhqKYAL
	 QN+VRgmoJDaWp5KR8GDge7dr+N4ei32b8R3dhsPLGiXfnSwjKvpuYmThIySXBXtpdXAjJ
	 1fHSkQDsaFNhDbb3pHCMgsLs/ZozbRs9J8W7LjoY6vec5cbHeoXadP92cGPEf8HLcUQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ah0wMjJb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 421EB606A6F0;
	Fri, 20 Nov 2026 20:40:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ah0wMjJb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E02D61F000C6;
	Fri, 20 Nov 2026 20:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795207208;
	bh=XWE9ACIHV/6VpLcxPb5BEoeDXClfpUgM3S7kPnfV7Us=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ah0wMjJb0LWFLWbL3LmK0aYrdlnjpYEIvB1beaedEm1KmFizDP2GX+2G+2t0T5Wjh
	 F8wzn6UDC+H6Ris5jam2lfYbwVmdTBrx47ytou52+sEgQCqFMWvZuHQOYPYfe2/zav
	 EHCMIt7uW7g/ftTFpf2DEnGnaeutCg2JQztPU34VgM+/Q+w5CJFBr7qGgPvqb1QPoJ
	 mTdNPZiSlGFUAaryfDZIRjQHS6WNn6LLq37I//qigtMHqi/++CNpPwqAatXFFIj8Mj
	 ifzIr82UAVORjfkwBeUXHfeksPtLpGM/ekjlTFdW5jmGn+zyPAs0kh5WAOHqSNaSW4
	 pKzjXfo1Pz3oA==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	Tal Zussman <tz2294@columbia.edu>,
	David Sterba <dsterba@suse.com>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: Re: [PATCH 6.12 1345/1756] btrfs: update the inode item when removing a free space inode
Date: Fri, 20 Nov 2026 15:39:16 -0500
Message-ID: <2026-11-20-1-daily-reply-0027@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <60ee151c-fcd5-4125-bc51-a21f28fde1ed@oracle.com>
References: <60ee151c-fcd5-4125-bc51-a21f28fde1ed@oracle.com>
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

> Could we change the new error branch to use that cleanup?
>
>        if (ret) {
>            btrfs_add_delayed_iput(BTRFS_I(inode));
>    -       return ret;
>    +       goto out;
>        }

Fixed in the 6.12 queue, thanks.

-- 
Thanks,
Sasha
