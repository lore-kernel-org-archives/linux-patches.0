Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 865C4242D9B;
	Mon, 31 Aug 2026 01:39:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788140374; cv=none; b=oT9wA1oPXgS/1l57MFwJvzg9STcK230YqyAJH4JEd6jZWDWGpmEV/xNxM3dqo6Kv3RvkyAgO3C6GH/yHFZNWH+LcaVUxHGgx41IJhmjC9UhDpp9TDtuJYlYtWxe7PVoydIGHvbVOOxjiJBvoi1XBLPkzxbODYXqcwvzM7OUdf1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788140374; c=relaxed/simple;
	bh=JpVRu4UgUrwnVu40/zGcKma8H/e37M6O0fMVe4U6HHo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KhqveFdhabOB8nVQJRutWf5BVWishfRSDnlFUGTZXsOUQoHlNyYixFK/WNqSk48B0OGAytMP3Orldk+ZO/cX7sPg0isz9+/kHVQYkdJj+w9h/JlNReFyI6HyhVmT0apUB8ncAeCgc8AeqwFKfCiT/zzfOg1lQau3YmPyWcmKgf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RxWT3+ls; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RxWT3+ls"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36F9B1F000E9;
	Mon, 31 Aug 2026 01:39:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788140373;
	bh=drkipPCvC4eIPeEIJFlhnnomHKRHuTgHrPFpyW42ugc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RxWT3+lsBuRSJymI2AjhFPbjqfrMLBam+BlT3rvpVnXabTj5HYbFGpz64RD6zJZDJ
	 XANQReqKPjIjl77x/A7WaMBxXtzInqfvuNhKMTvoig+U9D4dp9Np+36tkQh8sqqf1a
	 OM7MHeo5OB8zQkw5cmeonH97x3wc+rmCPZSkHW628xaO443HTaNI4BiVYYyxAHuMFM
	 4Dvqv4CcivVkcMps9XdCE0n6z/rfm36FTOuoXySJ0ZVID/nHBI26bAJ3c5u8gtoIww
	 ADu/LgMnlkyw3H1E8JDNqYwmFSpJIMs6SnQor5OY3U6rozjQjDdTh9yfaqvPM1vmbE
	 FehaAI+KAw4yg==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org,
	Vegard Nossum <vegard.nossum@oracle.com>
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	Yiyang Chen <chenyy23@mails.tsinghua.edu.cn>,
	Daniel Wade <danjwade95@gmail.com>,
	Shung-Hsi Yu <shung-hsi.yu@suse.com>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: Re: [PATCH 5.15 372/456] bpf: Preserve pointer state for commuted arithmetic
Date: Sun, 30 Aug 2026 21:39:15 -0400
Message-ID: <20260830195400.0010-1-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <24f50ccf-4a9a-40b5-a1db-cc48a7acf556@oracle.com>
References: <24f50ccf-4a9a-40b5-a1db-cc48a7acf556@oracle.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> Current upstream no longer stores verifier liveness in bpf_reg_state;
> it has pointer-provenance fields such as parent_id and frameno.
> Upstream a4c6f804b44c can therefore use:
>
>         if (dst_reg != ptr_reg)
>                 *dst_reg = *ptr

Yup, looks right. A tested backport will be more than welcome :)

-- 
Thanks,
Sasha
