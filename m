Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C3AC1442E8;
	Fri,  6 Dec 2024 14:52:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496755; cv=none; b=VUs022dwUGuYqRE2yl4xBLJMk8l8SQfkTcGKObciB0i++ba6LsnG5Of7OQ6vouo8UlxGRlDSd0JPuvF1gtQZZp9si3AdFrKBQ3zWeR8txXK2Tl4bwo82mR3SeAIJz7VOhNKHiKk+r182+DVz/BHdkSrPhl1b7bUC4M1mJwIMKhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496755; c=relaxed/simple;
	bh=5CHvMlsyBIEb6Q4BgnYTgMrWL7cHV0/io00cS5oh7xs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MtQJZPyJCWqt45A8QsmE2gGRa18i5OfNTStblEGoeNTTq2+W7zZ2NgE7T+6wPYOumZCQyl+omDAh/UGaWkS+hinX5cCZN+odqVdudh7VDy1/I1M+KOcdayppwbDx1Cdh0ZH6fGF5ysTAZUm8NE7cuQ48UxCu+VygpwHPACcCIq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1HVYLvJA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1HVYLvJA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54433C4CED1;
	Fri,  6 Dec 2024 14:52:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496754;
	bh=5CHvMlsyBIEb6Q4BgnYTgMrWL7cHV0/io00cS5oh7xs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1HVYLvJAgt/W7kRnlOC+pSGbYovxGJCEzV/usRyIHFJVUW0D+6/iQcNTLG19nScPo
	 WOjDDjptKzmd85O/CNsr7rF/st8HcL3zeilE3YQva++5YyIr6uY8UYciGK4ZBkNMU8
	 KSbVE8L+1+sWzw9XO7PiF81jecG5HawZHg0dnm6U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baruch Siach <baruch@tkos.co.il>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
	Frederic Weisbecker <frederic@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 093/676] doc: rcu: update printed dynticks counter bits
Date: Fri,  6 Dec 2024 15:28:32 +0100
Message-ID: <20241206143656.994447591@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index ca7b7cd806a16..30080ff6f4062 100644
--- a/Documentation/RCU/stallwarn.rst
+++ b/Documentation/RCU/stallwarn.rst
@@ -249,7 +249,7 @@ ticks this GP)" indicates that this CPU has not taken any scheduling-clock
 interrupts during the current stalled grace period.
 
 The "idle=" portion of the message prints the dyntick-idle state.
-The hex number before the first "/" is the low-order 12 bits of the
+The hex number before the first "/" is the low-order 16 bits of the
 dynticks counter, which will have an even-numbered value if the CPU
 is in dyntick-idle mode and an odd-numbered value otherwise.  The hex
 number between the two "/"s is the value of the nesting, which will be
-- 
2.43.0



