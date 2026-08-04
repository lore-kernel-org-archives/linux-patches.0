Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3B892E2EEE;
	Tue,  4 Aug 2026 01:05:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785805552; cv=none; b=mxSuxvl/hnbHiIr2iIGjKjw3RVf7d5lV4iin/8/+J8mcIx2yMxgZqCyY6f9BBHjEtFJ/uVkntrbclnModrMsMWd/amlUK7gujnCL9A4iwwLDcxZHSj2mjp/U/xDBueRT2pYQ7pUogjutJf/nLMdEarQH6J0MYWnTbomX8rtZqw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785805552; c=relaxed/simple;
	bh=lWUGhc423+6wGV9CUveGtvHfcRTL20devA05qBEnehk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z2vkA130fxMBskVX20cesG6CgyfDkobCp5oPtjrdFWuTfsC/7Csfcq0lUCHMCCHlydnd/cgkowHhIHJszrtBdvFQbbqLTFI2musdM/0nKyxh+imZpLHxnc9DKg+XHz/n/LAqXhjXzoSilI2Prw6wBbJUkpQ//ytIcJfjg5V9PFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OXZc0eZe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OXZc0eZe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB0371F000E9;
	Tue,  4 Aug 2026 01:05:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785805551;
	bh=3f6HTSELri+C+1MU+vUJHFzHN03fFLSGfeDM9yyeOG0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OXZc0eZeCInnxO+cd/ilXIZY4pQyvLnWvbTDd3+F3604T58ISMwrltRCjLkhcGW6K
	 jurLQkXNjfRz9U331bkzHSgzsC6e6ZQWPYeAE0bL5i/SzCqPAybLxyhXsFCgddFmOm
	 Rc83wVFczIy71wfmSjESYuxymsseQvkVwJQUCTGlV4SI3WMB8/SfAEXke7QCJGXPMm
	 5bbnfdVMhKNIVxRhY23/X/Dh/YMrn2YzNVlWxPu64t4UQFT1T29ILa0aLJloN32Jhs
	 hFDKdBPNXdiBKdCKHm/d+e1wIsbqWMAnmuLt2aDI4/OfeMs01ar69fcOBhh/qf/NTI
	 6UQDHzT0JygJA==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	vegard.nossum@oracle.com,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: Re: [PATCH 6.12 528/602] thunderbolt: Prevent XDomain delayed work use-after-free on disconnect
Date: Mon,  3 Aug 2026 21:05:44 -0400
Message-ID: <20260803210500.stable-0001@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <11d7b24c-6bc1-4ad8-9ef8-0c9fb96e36ac@oracle.com>
References: <11d7b24c-6bc1-4ad8-9ef8-0c9fb96e36ac@oracle.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Mon, Aug 03, 2026 at 10:38:20AM +0530, Harshit Mogalapalli wrote:
>> The actual upstream commit applies cleanly to all four branches, so I'll
>> requeue it properly next cycle.
>
>thanks a lot Sasha, as you know, it's very useful to get this fixed
>before they get merged :)

Queued for 7.1, 6.18, 6.12 and 6.6, thanks.

-- 
Thanks,
Sasha
