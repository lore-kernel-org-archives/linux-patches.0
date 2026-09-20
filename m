Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D24A298CAF;
	Sun, 20 Sep 2026 00:47:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789865236; cv=none; b=h8Tk5P1SoDKodDKjKN9qFvsMW95ckqmuOHdZQAEi183hrYPJYFPpOjMehsZDe5wJGcbF4XwZNuRBm5tlY5uNZG0fLmXsV5O5f2IYe+hxTcwemTfaba4nzCvzNbUqdt1fhXno4oOCOqmJiCDNgfgHhLw/3K/IoowO6cGLIyu8LTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789865236; c=relaxed/simple;
	bh=uWKDnEujUaLAltLGmlKe7m7QoDeqXeG7pyjjL/6lT3s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eBdsVVyWd/CnAV64B6dVCYVAtVUGTrQ2Nqz8ez0mCRLSTqjf+AWbP3ht79sUSQOgXUUmzy3i/NVoXSrivxPHoBPXU0/+YJv8UJAoRrjWb3SF0OWKYbwcbRHSM7ouMfxiwZ+PLCffGXepA1ICKqXvHYJXSPHDWOVwKWT93+I5ftY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MjUwFv8F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MjUwFv8F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5B371F000FF;
	Sun, 20 Sep 2026 00:47:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789865234;
	bh=bVkCNHgGvHUNWJ/JvmnQwk8xOIxeLPFbfU1Y3x9KZhU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MjUwFv8F5H8adkefrb0+a517F1L4ElVYar0yELj5jrhkIzYBQOKdQvMZNkmax+00O
	 JrbYjZHO/OF6GiZVkGAAp6OYe+CqeiRmz64T3dbuq/3Sfi7/pK1g3zYMz2GGSqK40V
	 xJV636vx9euFwVkGC1MywxA8yi6T3P5QD28bDlXHDsY+1s3c8wyhxk2q92F2efisD7
	 ouII3DMXGi89uyqr4kK5FOyk8bKcsDzfsOF/BIKKc16EjBngmus9noK5gHr3X9eNpo
	 edKcXosunhLdkEJeiWXPAjvYmbqnfz/UER0YW8cvJQAaO7EmHJ/gHf6VNtbMKISk+D
	 OXko1EsarHdlQ==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Christian Brauner <brauner@kernel.org>,
	Vegard Nossum <vegard.nossum@oracle.com>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: Re: [PATCH 6.12 0991/1102] nscommon: simplify initialization
Date: Sat, 19 Sep 2026 20:47:05 -0400
Message-ID: <20260920000825.1-1-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <275530c5-71cc-4dd4-bb00-d39c236c9edd@oracle.com>
References: <20260917151539.408551884@linuxfoundation.org> <20260917151605.594963317@linuxfoundation.org> <275530c5-71cc-4dd4-bb00-d39c236c9edd@oracle.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Fri, Sep 19, 2026 at 09:39:54PM +0530, Harshit Mogalapalli wrote:
> The commit claims to backport 5612ff3ec588
> ("nscommon: simplify initialization").  That upstream commit changes
> ten namespace initialization files.  The stable commit changes only
> fs/pidfs.c, so the two changed-file sets are disjoint.
[...]
> I think we should drop the change. Thoughts ?

I'll drop it.

Thanks for catching this one.

-- 
Thanks,
Sasha
