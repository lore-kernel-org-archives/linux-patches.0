Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023704;
	b=yXqS7Y9LIIaMMn579FGF5TOTCZN8sB7UUQeD3gqEAZMVzeUrQYrGtYKnmy5GuuMSGp8c
	 6g0U98YxiEVwy4S3B+dToVMpiapeRh1zt0FR3ccyLMyh4xVCoAwawNZe1QgIipnnq1iUU
	 jhCUBD0EXbmcqB2sk3mbx24eBJs230X6lSoW1R7Q1hHUqMNUvoJt+yaBGhikhfxPGAxa7
	 cJd0dyx6xo7ErL9iPe0EcERznInDLmstFb868OcDKS7pMQpzVkSiluGXHMoRy00YSNuG8
	 8uOiQBMqLYDmQLr+ekaIuIrmBrtiNzsY1KX/jwA8nhUIn+OaxfAMQgXN6dqLkk0nAaA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023704;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rx5z/cybwPzn2nw1/6IAh/nJOodPa6c+zeAHuIJndxk=;
	b=x2/8DdKcH4/tcno+u3+EmuUApfOfWS98CoROdlz1JB+GSUy36ecd8pwaDBPJ0Vc4/9RU
	 YaCXa9gAgWHRnUcPnVM3UuF71SObV0Sy5WSY/NocPj8nwOrEK0DvgYG96eoJeO2xYvlm2
	 5Gtint3PnH9609fT+vc9rCZHhn0AnFawQRTOYFWb45XNs4oVYLKUl0QVwhRB0QaJfy30/
	 hiwCcxwanIyTsE1Igi0T8a7ZbOL3YVxV7Bf+XXM8FzlwBHkK4kVY6aCZrwLygGWMrMnar
	 1wNMByl9KgHAO2u0CgAFCjL6xAT0l8PnBKR8OebPa8JGdyKYRg+CRw8CSFBjpld++2g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MQcExdCh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B360606A320;
	Wed, 18 Nov 2026 17:41:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MQcExdCh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71CF21F000C4;
	Wed, 18 Nov 2026 17:41:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023704;
	bh=rx5z/cybwPzn2nw1/6IAh/nJOodPa6c+zeAHuIJndxk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MQcExdChrW2oRYVStAcsGOn1HD5w7yvXyjlTzlYbDh/T9VlEAAThuUt0qhp06z0lC
	 pjEDVgsPcwtZVWb3PBkcinBYb2hnpARMmbev6xTCkdcfWGzWklc5hLCXl5oLMSgFyi
	 3LhV3v/1+qfba53pjT84s/SfB6DrSIVbFekd5Ri4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	Sarthak Sharma <sarthak.sharma@arm.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0463/2151] mm/gup_test: report actual pinned bytes
Date: Wed, 18 Nov 2026 15:36:38 +0100
Message-ID: <20261118150138.888222860@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 6de8064090ea1..6014bbf2aadeb 100644
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



