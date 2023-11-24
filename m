Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1208833CFB;
	Fri, 24 Nov 2023 18:40:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dfx4d0oV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84D00C433C7;
	Fri, 24 Nov 2023 18:40:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700851256;
	bh=xOzFa5DV11m4JbM6euWUvptTL1fOXZ5HZwAtmdE2/Tg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dfx4d0oVPckUP6IE6WvyO37FQY+Y4Vo05RgvYM2KOWm9N7FUXYIVHCIM9zdv7noxf
	 dA0Rudxk/9xXY9yTNM+ZDvGzv4oKBpVUjMiZXocPMgjaQrqpA/XHcchuCBqrM7WTdh
	 JwDovLtk27/cDlPtDUPFCyKzow5+tBObIqMsp8NI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 375/491] torture: Make torture_hrtimeout_*() use TASK_IDLE
Date: Fri, 24 Nov 2023 17:50:11 +0000
Message-ID: <20231124172035.862782124@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172024.664207345@linuxfoundation.org>
References: <20231124172024.664207345@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul E. McKenney <paulmck@kernel.org>

[ Upstream commit 872948c665f50a1446e8a34b1ed57bb0b3a9ca4a ]

Given that it is expected that more code will use torture_hrtimeout_*(),
including for longer timeouts, make it use TASK_IDLE instead of
TASK_UNINTERRUPTIBLE.

Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Stable-dep-of: cca42bd8eb1b ("rcutorture: Fix stuttering races and other issues")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/torture.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/torture.c b/kernel/torture.c
index e06b03e987c9f..4a2e0512f9197 100644
--- a/kernel/torture.c
+++ b/kernel/torture.c
@@ -90,7 +90,7 @@ int torture_hrtimeout_ns(ktime_t baset_ns, u32 fuzzt_ns, struct torture_random_s
 
 	if (trsp)
 		hto += (torture_random(trsp) >> 3) % fuzzt_ns;
-	set_current_state(TASK_UNINTERRUPTIBLE);
+	set_current_state(TASK_IDLE);
 	return schedule_hrtimeout(&hto, HRTIMER_MODE_REL);
 }
 EXPORT_SYMBOL_GPL(torture_hrtimeout_ns);
-- 
2.42.0



