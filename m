Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 598B01F76B0;
	Tue,  3 Dec 2024 15:37:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240249; cv=none; b=V7c/wdsxUE+Mzy09G/+VeG/lAYOCG9860m7r8UG6TxRMBi5X+MVo6BE1eikEw8ydZuqQwbxIydYxsUsIFgkrth+AQYEOQEJjOEeLt8A/TpgfI4RG06VePi1ecK/sYBcqlFH4azbJpCvt25HkFbYb5dPqepg2y9F8YoVR4PE9ha8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240249; c=relaxed/simple;
	bh=+g4ga/lPFB1m6CKgG5pwrT6zYKdC/x5UGmDxHyZntVU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CrHe0AO+5GhxqbRKiAKE8FzKvHGbKZ6S2cvv1nXAEFjLvcuvoQQzTjgB7lt3NUrsIf/GY7HTy9mLQAcEgMUNzMroazESSloYMJpLQ2He4STCGA0R+HA92IIsOJRoHTH1k7JpW0Ieblo02dXNwJu9qmgOeL8vkkfxo8TT9HYBMgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hvhskVN+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hvhskVN+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1A16C4CECF;
	Tue,  3 Dec 2024 15:37:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240249;
	bh=+g4ga/lPFB1m6CKgG5pwrT6zYKdC/x5UGmDxHyZntVU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hvhskVN+KSlYkQlbXfc0lzn9RYYmi5V3q9X7+7bkOKTXS+p933h9gKVXjyeEuwxBE
	 GXsFlL7PVsFG1tTC4TsTYE+BzIvalW9PreccBMeO88phCNE8JhVV09BDErjqe7Gy42
	 91aUpAfwYXKaRa9S0JhIRknVyJ4I9uwaqPa8uTdM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baruch Siach <baruch@tkos.co.il>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
	Frederic Weisbecker <frederic@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 067/826] doc: rcu: update printed dynticks counter bits
Date: Tue,  3 Dec 2024 15:36:34 +0100
Message-ID: <20241203144746.086297997@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



