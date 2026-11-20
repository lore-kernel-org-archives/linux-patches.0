Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795207190;
	b=LU72ZPQ34x0YsvPToeLtAZeyby1LE8+FFU+Rt2fhbGm+1ApBMhy2otpq92lioTSPHHRv
	 aCQ0/OEXsCftNz9ti5oPvDARAwEvRDIjJ4XUoP3CYBm2tvOUvw53xA4bv6cw4OtA2RNCO
	 pkQymyUBQhv2JiIM2dKReFwoC1HhI1tu+3+/NNKGJI1W0fqmyFA/MGSSAt6UXIF9LY1kQ
	 uXtzOVkHxvG0MK80Xq6QT/2itV8Ny0fe28TZMRXYDa90cwgtfNqm/KIcfOkoAQ2/cz1cP
	 WI4F9GfDRfNDoAFL4gOQVTtXiB4bdatFa7/m0ekGAogrWWgTKluyHPrYDlGiksx8FIQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795207190;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=0fg85nWoIkAcbBBbrcWVKrN+WE80IqFFapI5wpCmhDE=;
	b=CjO+KL7+UdknHNgHeqZLJv05oO2H5PFR3FSHsyHxMKANNloloNl9uy9v1vXOiuefhHIq
	 6Z9gvga/aw7zYZBtQNhY1/7FoAUFLRDwh7VmjJVFbR951A30/cjj9QAhBPpjsHFcVv/d5
	 a1zsI9p134c6rXRKKymKPqK2y7KvjrI/r10HqT1kXztr/X/SrhYDzWhIgjbDYVbUoBDAb
	 JHTRLrv9DjUXpVNYBYvW3ozyF7Vya2WsMIZ8UEilU+BqlLxQ5eC+om91yzGQIHUI6g4QJ
	 XFWpHkVVvXtNkYJnMn7LjdA5574Jm10b6W9pEn/ZEfwgAwzhzAfClOV07bIq+7aj1bg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MOxZ4Y0Z;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AD71606A6DB;
	Fri, 20 Nov 2026 20:39:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MOxZ4Y0Z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDA031F000CA;
	Fri, 20 Nov 2026 20:39:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795207189;
	bh=0fg85nWoIkAcbBBbrcWVKrN+WE80IqFFapI5wpCmhDE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MOxZ4Y0Z7e7uxIkC5oCSsFAne6YOy1JCG8nEwgygQk5HRsFntiNUpPPWvwm5H3QSo
	 abrNtmIuDRfVY1AXRrCqOs1kUfTNcNiQ1PsAJJ+SFWH+N+ld1zmSg4sR4LfHdodE82
	 8k9tQjQKLp586NkeCwpGuQMqc6DHJxsb8Q/MHS37Fry07MX4GlNGRfDSeGAyV7/t37
	 D9ar76gTAwzLNTdRySJ8U/saLW0EKF5yRbD1bl6IB10sxl1174WWRJd9t/LIS5HrOx
	 hCZPfMKlQL/G2cJtlFZmZxs3kcxXRK/9zwcdSFRpN/5wUOmfwc67VwF475OK1myIbR
	 cVaTKZZ8JhpfA==
From: Sasha Levin <sashal@kernel.org>
To: Matthieu Baerts <matttbe@kernel.org>
Cc: Sasha Levin <sashal@kernel.org>,
	stable@vger.kernel.org,
	patches@lists.linux.dev,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Pedro Falcato <pfalcato@suse.de>,
	Muhammad Usama Anjum <usama.anjum@arm.com>,
	Lance Yang <lance.yang@linux.dev>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 6.1 1649/2857] mm/mremap: recheck PUDs under the page table lock
Date: Fri, 20 Nov 2026 15:39:06 -0500
Message-ID: <2026-11-20-1-daily-reply-0017@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <2026112048-scheme-cornstalk-9990@gregkh>
References: <2026112048-scheme-cornstalk-9990@gregkh>
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

> thanks, now dropped from here and 5.15.y

The build break is fixed by 54a948a1e97a ("mm/huge pud: use transparent huge
pud helpers only with CONFIG_TRANSPARENT_HUGEPAGE"), which is now queued ahead
of it, so I've requeued the recheck patch for 6.1 and 5.15.

-- 
Thanks,
Sasha
