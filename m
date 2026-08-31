Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A9E05762AB;
	Mon, 31 Aug 2026 13:49:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184155; cv=none; b=d2SEsugMy2lo11hPBJ0m4YynKQkTBYatSmAC7m4TQq70RQMM9ldeXzSwBb+wQA1/2LiZCLkGzTrZqWrMoQ9EAd5l10j0CzHKAfxn29JtnMc5WxI03dn583/N/LmhmgjtDB++gcYoIbyzm3nAPt4HqSVyfmRH8Rmc7sELOp2zJS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184155; c=relaxed/simple;
	bh=we7/sGcmEB5nvAErT7wHuq+La6JCVtVp0ENMTZqmdJU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=m+vZLuRJk4q8Hi0Z7ouM+Jj/szVPi7g4/2/uncyKir2YmTphKp7ww7IUSe0frCpakVPKD4afKRGhRQtUHI+LCM5PlwwBqNMwK+a0T6jT6O6Z0ThMfDT438LYkCqi0EwzZ8t0yKOhRC3TbUi9pPAlXeiY13+7d/Xc1rThglpjuJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hSpCn9Hj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hSpCn9Hj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BE591F000E9;
	Mon, 31 Aug 2026 13:49:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184153;
	bh=eMfgeDBHC7Y+1FXjCNguhMHe/Bn4MgSkBitNQjV8cE4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hSpCn9Hjz5fWitanSz4Uitn7yHUbSuhm1FlviE6JMzFgbmtXR1KtQxXQ3N73IL3XJ
	 AXDPlb+Hp6OiSuZzq5gXqOmjgyp5SGR+VUQyIzJMaM9FWgS50LI1sxvjpPMfC76aGv
	 9a799b532WZ1HmSoZIzuk9tH3lJIkyHdU5+NiX8WBPqZhkeg4qG6rf+6PyAMtyO2bE
	 nsvDz2j0rQXhqV0Gj3dQMhuNHfCqmBleesfgb9Redw6q97S7DJDGUTzc6zrPlDii4Y
	 uMPYmCkZZ80s8Nul2mBsQI3TuU3eus1yMORxKw0CgmnwUsOM3pW0CgIYkynXPjYZSM
	 GV5OALygpBZWw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>,
	andreas.noever@gmail.com,
	westeri@kernel.org,
	YehezkelShB@gmail.com,
	linux-usb@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] thunderbolt: Set tb->root_switch to NULL when domain is stopped
Date: Mon, 31 Aug 2026 09:29:11 -0400
Message-ID: <20260831133314.4125787-523-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mika Westerberg <mika.westerberg@linux.intel.com>

[ Upstream commit e56249d8a68e712f3b60e1f3fdbb5b4fea146468 ]

Similarly what we do with the firmware connection manager. This makes
tb_xdp_handle_request() return error to the remote host. However, we
need to make sure we keep the uuid alive so that we can reply until the
whole domain is released.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The background `git branch -a --contains` lookup timed out — this repo
has too many branches for that to finish quickly.

The analysis itself is complete. **Verdict: YES** for backport to this
tree (`linux-6.18.y` at v6.18.43).

The fix is missing from your current checkout and from
`stable/linux-6.18.y`, but is already present in mainline
(`origin/master`). It's a small teardown fix: `tb_stop()` leaves a
dangling `tb->root_switch` after switch removal, which can cause a UAF
crash when in-flight XDomain request work runs during driver unload. The
patch mirrors what `icm_stop()` already does and applies cleanly
here.The `git branch -a --contains e56249d8a68e7` lookup timed out again
— too many branches in this repo for that to finish in a reasonable
time.

I checked the important branches directly instead: the fix is **not** in
your current `6.18.43` checkout or `stable/linux-6.18.y`, but **is** in
`origin/master`. That supports the earlier **YES** backport verdict.

 drivers/thunderbolt/tb.c      | 1 +
 drivers/thunderbolt/xdomain.c | 6 +++++-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/thunderbolt/tb.c b/drivers/thunderbolt/tb.c
index 041a4c8e10fb9..b516b1ad83a19 100644
--- a/drivers/thunderbolt/tb.c
+++ b/drivers/thunderbolt/tb.c
@@ -2952,6 +2952,7 @@ static void tb_stop(struct tb *tb)
 		tb_tunnel_put(tunnel);
 	}
 	tb_switch_remove(tb->root_switch);
+	tb->root_switch = NULL;
 	tcm->hotplug_active = false; /* signal tb_handle_hotplug to quit */
 }
 
diff --git a/drivers/thunderbolt/xdomain.c b/drivers/thunderbolt/xdomain.c
index fed0fae2a6299..1eb149445fa05 100644
--- a/drivers/thunderbolt/xdomain.c
+++ b/drivers/thunderbolt/xdomain.c
@@ -756,7 +756,7 @@ static void tb_xdp_handle_request(struct work_struct *work)
 
 	mutex_lock(&tb->lock);
 	if (tb->root_switch)
-		uuid = tb->root_switch->uuid;
+		uuid = kmemdup(tb->root_switch->uuid, sizeof(*uuid), GFP_KERNEL);
 	else
 		uuid = NULL;
 	mutex_unlock(&tb->lock);
@@ -870,6 +870,7 @@ static void tb_xdp_handle_request(struct work_struct *work)
 	}
 
 out:
+	kfree(uuid);
 	kfree(xw->pkg);
 	kfree(xw);
 
@@ -2344,6 +2345,9 @@ static struct tb_xdomain *switch_find_xdomain(struct tb_switch *sw,
 {
 	struct tb_port *port;
 
+	if (!sw)
+		return NULL;
+
 	tb_switch_for_each_port(sw, port) {
 		struct tb_xdomain *xd;
 
-- 
2.53.0

