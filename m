Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57209381EAF;
	Tue, 22 Sep 2026 02:23:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790043832; cv=none; b=XdtkMXTXr1Eb0A84W+aySVMHTGZrqNO50PTaaYpuxI49+4AlO7LIPZ9u0pYPR7PfhBhVLX0+ImAQujdws3ZU0IsGjJV1VT0S6v2XTKZUf3poRqSd3hkLQ3VdAtS9okRoibgiuPn+ORts80nq939i55NadQfWVvIRjn73xPOCjq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790043832; c=relaxed/simple;
	bh=TjVsCdoMOgxC4qmub43FU8vqX/COiNe8A2cDmY4oc/Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NowN4q91xOLNVeyM7DorfEtuWWmEkSDkwmUXB8TzZGqmW316HvUWB5fWUvZbkUiEPidJKw5gyVeaEjtAldPNBv4yokyhV9fxUUxephAgviuRfGAoZeCcYPCFi79k2hmAYJaQZvDK13/Lr+eNo9iAVgeNvjQTG94BgIF814z4HvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JMB6bSuf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JMB6bSuf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E1B61F00899;
	Tue, 22 Sep 2026 02:23:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790043831;
	bh=DvpHe9goWKptvXpvHaZISQed/cSncJ9KwzC6BY4n1Lc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JMB6bSuffAh1cD/6qgVMYEsniGAlIS1GzO/8ghMqgZ3ZBPsCkoswLuwKmX84RVLBH
	 d8HgifVHOOncBv7e8Ygaw2F6wtd+4VAs1RXjEEb5MMGLWje7zg0HCLv42kw49JzanL
	 C5qpQc42hhDz/87CXIPziZm5k44BNeY8x4trwwJWkIC4brt9lBKhCaEoTPaW49kJkM
	 CSdMPZTPR+nkUq5wrdGGG6jnbp+FaBYCp9lLjmHDA2UHewkb4O1NTRQNNY0I36CVYe
	 YX+t3kUxgF4mzBdJ3krv79cWctah7W/aH7XqL9jBaGUH8IPaQLcXauBcBGSDY/nyjU
	 +vPAqvsOBSeyw==
From: Sasha Levin <sashal@kernel.org>
To: Zi Yan <ziy@nvidia.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	Johannes Weiner <hannes@cmpxchg.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Barry Song <baohua@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Lance Yang <lance.yang@linux.dev>,
	Vegard Nossum <vegard.nossum@oracle.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: Re: [PATCH 6.12 0472/1102] mm/huge_memory: use folios memcg inside __folio_split()
Date: Mon, 21 Sep 2026 22:23:39 -0400
Message-ID: <2026-09-21-daily-reply-0002-re-folio-split-memcg-requeue@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <9200dfdc-009a-4998-8d2f-b106d362e6ad@oracle.com>
References: <9200dfdc-009a-4998-8d2f-b106d362e6ad@oracle.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> Looks like a very similar report was clarified by Johannes and Zi. Sorry 
> for the noise.
> 
> Sasha: Will it be possible for you to re-queue this ?

Re-queued for 6.12 and 6.6, thanks. No noise at all, it is easier to put a
patch back than to ship a broken one.

-- 
Thanks,
Sasha
