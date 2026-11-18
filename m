Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016337;
	b=AM16G+PWNYhUvtS55pl0Jh6JAXVdonwHbXxG8GsiKqj4u1pQr8vyOtrqCpmAOpF2kSnK
	 66gMw0wPYrbehJSVpsFnZuDexMST5Z3PBfJ5T6OebrnV0Qniqjuka4Xgaqp0we6wf2Wvt
	 /U44r9i0G+XKqS9vxTmrnr/qTkL0/n1fnbMcIzePy9I3hIPVpgYYzJEv27a+vWaTfmNFD
	 fbrqEqyJ3eBiYp34K/Mj6kRbdk0ryxkwLldIu5knTN4JWMNoBImwc5+TYiXG5MUgKdlZR
	 NLqnertXVtgTJSgpI0a+hYwMYcqLPssOE1OXCQP1AFA76PDfg11fMR8ZuIQLYatVlLQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016337;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kpPyD5mZuJoFPctFJMirx8BeZxM2eKc1itVg2NnWRm8=;
	b=PiPrGl86/G4vhTawQsf/pDbWU+1PSrUgx2qcp1Ui3QnIy4VbFuDHu7dlxBjRjcu0Bg0L
	 LF0YRrAT62Ns+Ysfx/UBfGOti6Qr8Eul59NSNIZ2XftWXeb56CYjZ51AoqROXL2m/+24B
	 T0Fh94ioBG/3wJkUdGm0/bqX6TFaU1ozpuREIWF7I43arFQe3nIOQ0Z42VCS62Fb73wBH
	 mi2LMRvfWqQepf+PSSxyD8A61pm68nP6h0Wrxtg3LcBAUCXFcDC7ZdDcRq5zxbDzbrL7P
	 CnyPzdiyhwEe71DRzcOgZ6Ths3Vmm4s/hV5nZzC4tadLttAMmJnFfUKUucfNBY76veA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Rvr+2rWl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5798F60A2601;
	Wed, 18 Nov 2026 15:38:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Rvr+2rWl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD5D71F000C4;
	Wed, 18 Nov 2026 15:38:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016337;
	bh=kpPyD5mZuJoFPctFJMirx8BeZxM2eKc1itVg2NnWRm8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Rvr+2rWlCu0YgqBQjqf+BVx3rS2ZgKfF26ZglfUZR/+m9Spi6kYZ2IPldjuaqjTK7
	 RUHmFZ9RzNofhp+3rndR6PhOMHO4LiPugsOWX0oF3ZcTO6VyAvke1ymXSxzGq1OfkI
	 VNnnonuEW3Ttxo8V32YNb+IBhvAqSD+Tft0TZ/yk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	Sarthak Sharma <sarthak.sharma@arm.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0493/2651] mm/gup_test: report actual pinned bytes
Date: Wed, 18 Nov 2026 15:28:53 +0100
Message-ID: <20261118150305.526016105@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sarthak Sharma <sarthak.sharma@arm.com>

[ Upstream commit 65a79b9b693d8c7bd7e5e4865c02cce922a7cc50 ]

__gup_test_ioctl() advances addr to the end of the current batch before
checking if GUP pinned the entire requested batch. If GUP pins more than
0 pages but less than the requested batch size, addr still advances by
the requested batch size.

The next iteration detects the partial pinning and breaks out of the loop.
Again gup->size is calculated using addr - gup->addr, so it also includes
the unpinned pages of the requested batch.

Calculate gup->size using the actual number of pages pinned multiplied
by PAGE_SIZE.

Fixes: 64c349f4ae78 ("mm: add infrastructure for get_user_pages_fast() benchmarking")
Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Signed-off-by: Sarthak Sharma <sarthak.sharma@arm.com>
Link: https://patch.msgid.link/20260901083452.115365-3-sarthak.sharma@arm.com
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/gup_test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/gup_test.c b/mm/gup_test.c
index 5bb940371a1e1..ba74bf3f41048 100644
--- a/mm/gup_test.c
+++ b/mm/gup_test.c
@@ -187,7 +187,7 @@ static int __gup_test_ioctl(unsigned int cmd,
 	nr_pages = i;
 
 	gup->get_delta_usec = ktime_us_delta(end_time, start_time);
-	gup->size = addr - gup->addr;
+	gup->size = nr_pages * PAGE_SIZE;
 
 	/*
 	 * Take an un-benchmark-timed moment to verify DMA pinned
-- 
2.53.0



