Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062174;
	b=2mb5xJnr838TVHInIJHSbyheL8mTNFFZAGEiQ78Y6NqHozBj1F2voRBvXbko8KDzxnEh
	 0T+90i1fjG0foZ9xIVmKuHmstbcqMLT6xIpS0G1TE4vV1nWH1GJI8+cuOa0pSy3xTq6Hj
	 RV/+ai0sujBmH1DuUMaljqxMZrSVWfV5dlho9Jh9kl1iWcs8VQyqPEMO3QyFjiTlL+wT3
	 C7hbmLVGJE/k5sHFeC5vRQIXqFEwTczuRsgxuiu1Q8N1/KeR1I31ZoC1yLSaGb3rVEqfa
	 FEe6nPpJ+KwklP9nYVc2/n4BEAeI4aqfjhKgScSRyvlhjx/4clYxz8E8b2ZxnZV+WhA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062174;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Ps3Vy8M/uydEBvRAnZ56lTcweSMZ9X/F4fGgD3B/7v0=;
	b=fLbHXGwQ9PqpVhMcxffTgGl7QSTnu2/FitKuKkUQmUskKfgDYCbJ95x/VHdLVJO1YjNq
	 sfabI+1UrO48fbf9Jw1BuzkBOzhDEfGRbYNJG+djorHyp97/HVD0593akPwiZe8bbmL+V
	 CqtNRkLlnnHPcAYj+UNPUV74JhXYbE4ZOPhKhjHO3OSpDpiqyERuX6YB0vHh0AwiaZ02z
	 KafKCHTpDmC4DtSiuM0gqJACBsrOCEvqg8qRO6RSwtXDHDdxu4ond8eCGGG9M8DosMhXD
	 lD3Bdl8scrwqVZb6QvppF8QpQnX+IqxlqPnQjaJ0y4VwmJ/5K6eLpIMyQG2adOkhLZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=etbEuCFQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5AAE606A326;
	Sat,  7 Nov 2026 14:36:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=etbEuCFQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9249C1F008A2;
	Sat,  7 Nov 2026 14:36:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062173;
	bh=Ps3Vy8M/uydEBvRAnZ56lTcweSMZ9X/F4fGgD3B/7v0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=etbEuCFQAPrzu20I1oNoIX5PDX3QGZmGZK1QBxaVY1NurB3R0wfPjmlmE1bef8yWM
	 SkqKaN/SUtOrsJIayxLWsfErwSaEpUmCl35vMDmUsLNAhnSHtgOYt9MX5gEHhD/72X
	 BOYQBpKztdyWUjQPXaZk++xpXMjLSyCwo08u/rXE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <blum@kernel.org>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1134/1536] hwrng: core - reject unknown RNG names
Date: Sat,  7 Nov 2026 08:52:30 -0500
Message-ID: <20261107135029.566065823@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thorsten Blum <blum@kernel.org>

[ Upstream commit 7e7be8815143751c20260f80cb4e7fe14dd24b74 ]

In rng_current_store(), err is 0 after successfully locking rng_mutex,
and if the requested RNG name cannot be found, the function reports
success even though the current RNG was not changed.

Set err = -ENODEV before searching the RNG list to reject unknown names.

Fixes: 142a27f0a731 ("hwrng: core - Reset user selected rng by writing "" to rng_current")
Cc: stable@vger.kernel.org
Signed-off-by: Thorsten Blum <blum@kernel.org>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/hw_random/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
index 008f81a82131d..0c42a31e33067 100644
--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -374,6 +374,7 @@ static ssize_t rng_current_store(struct device *dev,
 		cur_rng_set_by_user = 1;
 		drop_current_rng();
 	} else {
+		err = -ENODEV;
 		list_for_each_entry(rng, &rng_list, list) {
 			if (sysfs_streq(rng->name, buf)) {
 				err = set_current_rng(rng);
-- 
2.53.0



