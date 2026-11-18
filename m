Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055605;
	b=I/KIajO/tEdrlM9aExGJNCgBQO5AYz8Nb8ReopDqP6q5q3S1Jh+CRJB8C4+reahPsna0
	 rTPNdX1wZ2hj1qa79biStZNilpgVuZD3Tw7qHCX209m7XAPysWbUNInOEeM33IpNgaGkc
	 QAPPbsEqzULFs5BMiUOeVlvOQp2WICHfA9mwo8UpaoBwmJz379t0SGEtK/hXHTBkaT+Pb
	 gPnAS3fJ56Dxe16d8SHYqp4BO7tvBT3rLyTRE1NE+ctR7AnK7wYYZJTWl1jWed+uWVUD0
	 QJzp3e8qKs5yE8C3K3jzaSx9yYIbTgydqj4S/bRvjcRZ/QBeI5Uu3h/hnmWWwF6FRwQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055605;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DBl+u2jP6z3x/AiAWWx0Fvhx0VXUgILawUb5eTKSBDw=;
	b=hVpnZhW/v6weJBFfE+UK+v0uRnjhXcqaMa/TPKxl0Bty7yaYTSNtgr64pqvkIbiwVZFF
	 iJeYvmsooa8YJLnbqj2BgKBx/0hi96/JlJTHHUj7fwgzml00Le6WNkbLjESiA4pZpUa3a
	 Fx8LSf5n5OXjcjE6hRxbNUI6i2IuzWZ4/elMKhB8TcvZh7ENBLwo4dHDQk/bEX1+M1QvA
	 LJh//JX1dbUK6DaOi45h5z0yUq+WwMNHwPhKWMxqt4GndkOU3EIYfcW6JKH84yTQQjzqk
	 CC/mnHnOjgNdC17WFbp6v7D6HzRAfQDav2ZHR6sLa+c7puPTjqCLz5GYu0J3F4lYg8g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="zEAWVQL/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D693D606A320;
	Thu, 19 Nov 2026 02:33:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zEAWVQL/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E18C11F000C5;
	Thu, 19 Nov 2026 02:33:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055605;
	bh=DBl+u2jP6z3x/AiAWWx0Fvhx0VXUgILawUb5eTKSBDw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zEAWVQL/+xzbPkCZk7vy3lndEuDSD/TaC0rsDym4MmqjRLNrtc4qcHeDGcBl/Kvmd
	 u2T6OFbe8lCMRYC6sVoSkIwRsGGhGtfsX90kJ5z5DVdRckXLEZnDElpabQq86UmhF0
	 2Gl0rPJQmO9qyg7wlR+ZUf/AGGuNGNJQCSSeO9zs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1692/2214] OPP: Fix the return value in dev_pm_opp_get_of_node() kernel-doc
Date: Wed, 18 Nov 2026 15:56:08 +0100
Message-ID: <20261118150119.507748848@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit 706081c6b9327dd611dd72b20130a77f0f059b6e ]

dev_pm_opp_get_of_node() returns NULL when the OPP is invalid, but its
kernel-doc says "else 0 on success", which was never true. Say NULL.

Fixes: e2f4b5f8dc59 ("PM / OPP: Implement dev_pm_opp_get_of_node()")
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/opp/of.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/opp/of.c b/drivers/opp/of.c
index 83c2e62e92142..f31a33ce90888 100644
--- a/drivers/opp/of.c
+++ b/drivers/opp/of.c
@@ -1348,7 +1348,7 @@ EXPORT_SYMBOL_GPL(of_get_required_opp_performance_state);
  * dev_pm_opp_get_of_node() - Gets the DT node corresponding to an opp
  * @opp:	opp for which DT node has to be returned for
  *
- * Return: DT node corresponding to the opp, else 0 on success.
+ * Return: DT node corresponding to the opp, else NULL.
  *
  * The caller needs to put the node with of_node_put() after using it.
  */
-- 
2.53.0



