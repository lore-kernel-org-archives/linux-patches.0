Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058739;
	b=1VhHkmSL0OZGHYLAtjcfDpTMsWph0+D4Yuu43OF7m+qRfMaR5lGfTj65J0tV45J0YY7X
	 S5gV+NDkud/wcwt51cjGOaJfdOCS3yXXNrWQqekOfN0pKGzABgLOUYHNoblIUvZXuUNy6
	 gSIVX7PBU6No98l/yoIEynx1ZoItDrfUvRfA3CGHYxCcnIG6hdQhD9v81DdRGHl2p0XSF
	 NGBlC+CfMcZV+CIRwCRlQ6eciTW0UbgPUDCmd9V/48eDQEvZmOIZ6Q+mYexYsklAHCLP1
	 DWrgZ67A8IYL6UxV4zV7NDzzKMyeC9QMhEvqGpET5aoOm825xWbZ7EPUoJyGt29u6jA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058739;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GAiz2Scew+l/KbyB030KT/81KLJYR3174vPkoH752og=;
	b=NC2DHtupKrRRMIiQdDiP4tzi/V8lv88U3WEAY2ZvElkli2G81yJ7ununqp/WLuEGd8YD
	 kvFsdBGFNzDwJwc9Rsf/JWojMF38eR98ajWfhokKYMaA7A+R8Re2sleKPovoAijBUndiA
	 CjOvtaP2cIjLTDvC4aeSMr5Yx4f8CDb/P4780bEu0Q1dpEVLA/UG8UeqGUwdCH1rHrmQL
	 J/Fb8NYJBLOQqIZKP0nfVJBg0XX+5P2SmcFxDTsvNTzJdeqkmONtci7LuNVQFX0Mruxfz
	 aflfFViVO2C0TRr0DSVbcawnq6dUyIGCbdWAKZUAEcFX1YVdsgHXi8X5UmcJjJk/2Ew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Xo6gw4Wj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CB70606A31C;
	Thu, 19 Nov 2026 03:25:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Xo6gw4Wj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B69261F000C4;
	Thu, 19 Nov 2026 03:25:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058739;
	bh=GAiz2Scew+l/KbyB030KT/81KLJYR3174vPkoH752og=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Xo6gw4Wj9Lh5lAFBzNf7NCyUn1wTfL8Bj8N7or9gL3U+80Qws0P1NA1D2bIrhAETS
	 p+UuJdsui+Sdu55uIuxONIM8J7fQs5E1f/RhtvX8jbM0wuQ63X7YzusiNXJ9bAU1Dw
	 REnCJBgWmzWw1Lk0hjzyXDqcZFzT8Geff+yeDFbw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0593/1848] cpufreq: stats: Fix potential out-of-bounds access in deferred reset
Date: Wed, 18 Nov 2026 15:43:51 +0100
Message-ID: <20261118145940.225018201@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>

[ Upstream commit 8a702989677216489e471a6f27599da53f753567 ]

cpufreq_stats_create_table() sets stats->last_index to -1 if policy->cur
is not in the frequency table. It then stays at -1, because
cpufreq_stats_record_transition() returns early on old_index == -1 before
it gets to update last_index.

Commit 46a310b80bc2 ("[CPUFREQ] Don't set stat->last_index to -1 if
the pol->cur has incorrect value.") added that check. However, since
commit 40c3bd4cfa6f ("cpufreq: stats: Defer stats update to
cpufreq_stats_record_transition()"), the stats reset is deferred to the
beginning of cpufreq_stats_record_transition(), before that check, and
cpufreq_stats_reset_table() ends with an unconditional
cpufreq_stats_update(). So if the "reset" attribute is written while
last_index is -1, the next frequency transition accesses
time_in_state[-1].

Fix it by also returning early on last_index == -1 in
cpufreq_stats_reset_table().

Fixes: 40c3bd4cfa6f ("cpufreq: stats: Defer stats update to cpufreq_stats_record_transition()")
Cc: 5.10+ <stable@vger.kernel.org> # 5.10+
Signed-off-by: Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>
Link: https://patch.msgid.link/20261027133332.377546-1-zhongqiu.han@oss.qualcomm.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/cpufreq_stats.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/cpufreq/cpufreq_stats.c b/drivers/cpufreq/cpufreq_stats.c
index ab856dd2d5fc0..fdf9fd938e4b7 100644
--- a/drivers/cpufreq/cpufreq_stats.c
+++ b/drivers/cpufreq/cpufreq_stats.c
@@ -52,6 +52,10 @@ static void cpufreq_stats_reset_table(struct cpufreq_stats *stats)
 	 * reset_pending accesses in cpufreq_stats_record_transition().
 	 */
 	smp_rmb();
+
+	if (stats->last_index == -1)
+		return;
+
 	cpufreq_stats_update(stats, READ_ONCE(stats->reset_time));
 }
 
-- 
2.53.0



