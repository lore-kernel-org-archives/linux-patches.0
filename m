Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00A7413792B;
	Thu, 12 Dec 2024 15:55:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734018953; cv=none; b=KLiSBNHiB2SxwYn/uLq6HjjpOzcmYsCgBq99wXePJCtzCZ03Xf0pqcGb0jlaoAMEjJ0RN6b5LHEnqUQRsai8x1+FVvfqTqPt/8lvd5DTIGPT76RfNLvH0SU8GAAeXetgfHHNpvNJYbJ7VOyLCWZFjAhzvZFJkcUo+bWVUHtx4Gs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734018953; c=relaxed/simple;
	bh=i4tG++Js78/zaOhKMXinOXykeBUP968uqvevIODWT/0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jFm7dnpT/hy0BsKYaQ/rzzfHxiyclSoQuDdU6KOkCVxuKl7747kQzWjcPsdm0Y1elDeFRswJebmswocwfd8r7dhhROC6XZvi8Lb0T/9cVk69tNGrZTzSGYXdXShYcvtoAHzstBLm1gVI1/fZif6Tf8eQ5k3Pl86aGjTK63YBKUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pd20Ji3k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pd20Ji3k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64CCCC4CECE;
	Thu, 12 Dec 2024 15:55:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734018952;
	bh=i4tG++Js78/zaOhKMXinOXykeBUP968uqvevIODWT/0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Pd20Ji3k7OwtWQWIJDIQLzsMbnE/IXyl9pTY3NBj9m3uXg9fplOgPzJJ1fcdbER9p
	 VroR/ymlXUhyEUp5PoUJSm3Wv6ny8d8YX4TBDSMauLKO/KU4d6ZkSm9HeZPXN90cN6
	 wNVj8M9fpSkZlGjwRGBBmmZgbK52CC5ycLSPukcA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baruch Siach <baruch@tkos.co.il>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
	Frederic Weisbecker <frederic@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 078/772] doc: rcu: update printed dynticks counter bits
Date: Thu, 12 Dec 2024 15:50:23 +0100
Message-ID: <20241212144353.157596464@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baruch Siach <baruch@tkos.co.il>

[ Upstream commit 4a09e358922381f9b258e863bcd9c910584203b9 ]

The stall warning prints 16 bits since commit 171476775d32
("context_tracking: Convert state to atomic_t").

Fixes: 171476775d32 ("context_tracking: Convert state to atomic_t")
Signed-off-by: Baruch Siach <baruch@tkos.co.il>
Reviewed-by: "Paul E. McKenney" <paulmck@kernel.org>
Signed-off-by: Neeraj Upadhyay <neeraj.upadhyay@kernel.org>
Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/RCU/stallwarn.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/RCU/stallwarn.rst b/Documentation/RCU/stallwarn.rst
index e38c587067fc8..397e067db566a 100644
--- a/Documentation/RCU/stallwarn.rst
+++ b/Documentation/RCU/stallwarn.rst
@@ -243,7 +243,7 @@ ticks this GP)" indicates that this CPU has not taken any scheduling-clock
 interrupts during the current stalled grace period.
 
 The "idle=" portion of the message prints the dyntick-idle state.
-The hex number before the first "/" is the low-order 12 bits of the
+The hex number before the first "/" is the low-order 16 bits of the
 dynticks counter, which will have an even-numbered value if the CPU
 is in dyntick-idle mode and an odd-numbered value otherwise.  The hex
 number between the two "/"s is the value of the nesting, which will be
-- 
2.43.0



