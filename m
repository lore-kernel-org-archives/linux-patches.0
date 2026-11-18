Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048429;
	b=HxHUU1YJ6dFiLhD1asXdViBS8/i3T+uzh8Li4PjHU5jZ78bIItXA4l6owO0CCY/trnal
	 P8FneyPcBL1akzbhUNv9YSin2ou0NJTYxEKvD0DzklBWANEwqUZphpFzDx3bYC/jZLUNu
	 dgneV7HAcR1ijZIBn3pBBdlu7MtcFhArOsjFmnsRmLFCLPKASqBWdG+FeKKvdqlMAp8xw
	 NLzjsUV14B7W6T6V7hQA1v6Ig0QIqYyV9LW9ni+xoXq1oVUDEmPKL2S1pgB4Z5Jv0pE+1
	 t+4Oz6QaisaeAW1GDM8bGJFI8irBoYPRhoT5quY3ysls3V7BO/gW+DK6nwbaxbToRWw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048429;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qWz9axKeBIFmI63QlihVq2s7wrMnOGMiyEh/9y1sp2U=;
	b=LDBo4rjvuEaoJ9MGPmZBj/+adR44jqTMaSoqNy1H6YhvyivWK9T9Wmx2Z2Xy/BVA8ccU
	 eNEaCabr8Ocj1mCAcniyY4OuoQakG0vRR1VtJlK4IFvZZibdQ2NpEdNK8bqb5NIMUtS6f
	 +XyqPsOkmMxhdLbo6SU09WjsmFLDqbuensJv0H5i+sjiuKkqDkB+uMjPm+k3fuXedP6TK
	 fs6i/IYRW9nYDnic3pEO6Mn38RyT/+3ia/hdVXckjiwwULMHL+HJUfcJ83+DqqIK9dfhK
	 TtvC8N+7da88n/s2r52eFJ2Hrzs63BixHYTj7LMOWpkJphuaCa1ZB8dxftYLw4gtL5w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yDmyenNM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9D74606A330;
	Thu, 19 Nov 2026 00:33:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yDmyenNM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43D4C1F000C4;
	Thu, 19 Nov 2026 00:33:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048428;
	bh=qWz9axKeBIFmI63QlihVq2s7wrMnOGMiyEh/9y1sp2U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yDmyenNMbFqwrAmWEq2pUKUpgWmCqIfoEqca0crIhwPyRRi1t8GoYqLP7c4vFHD2e
	 IPTmRc1gg+BDWxRgvSiKSB9LU0UrGmOden/S6/Iu/SqtDfV/BeiV0SrTZ0nHpqIhz7
	 FxCW7va9l4hIN3hYrsQxHlfd2VCHZjmZzddO1nqE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	Sarthak Sharma <sarthak.sharma@arm.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1950/2857] mm/gup_test: report actual pinned bytes
Date: Wed, 18 Nov 2026 15:49:44 +0100
Message-ID: <20261118150311.623552961@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 4ea1dfa371da2..91e7ec4183609 100644
--- a/mm/gup_test.c
+++ b/mm/gup_test.c
@@ -180,7 +180,7 @@ static int __gup_test_ioctl(unsigned int cmd,
 	nr_pages = i;
 
 	gup->get_delta_usec = ktime_us_delta(end_time, start_time);
-	gup->size = addr - gup->addr;
+	gup->size = nr_pages * PAGE_SIZE;
 
 	/*
 	 * Take an un-benchmark-timed moment to verify DMA pinned
-- 
2.53.0



