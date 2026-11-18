Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052144;
	b=o9bc36xbGKC72yssWCYyA8+4e03o4o1w79+mXt5ShN/FIiXdJrMcM0+b/GX/mHTbEYNk
	 usuIaQPMReChxbkVLc8Z6bW/coobSbUmALC55GCnoxuiWc8V0TAyCA4bee6q5DaWxlQwQ
	 PVOJt4GCJzer1JQdDGKsCegD3ZaM2//6dvGt9VxVTKuhQcCCgUdhD0rCejVtJfMySeODg
	 IAkq8CPV1OxXtjFsTyrPmpRiyuh69l+3dXcPawHJiN5jXHNRoZCZ1Zcey33/jgyC5TtfM
	 mKRvgf4ZOKkn0gF0fB0G0WBhRIvmuTAKUtpZG4Ra9WQXnpcoWuFy0PjoM6Lc6P8BBfw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052144;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uUW6KCr3tkYg4x8Fkx1ryhzJqCz+YrNuHKQz6taCrow=;
	b=Gdoklb5sOZAVlls+/C9z5WhBzDfNXwWR0JyOTr2qQGpvOUwUAufs+gE56EoUFz45NrXp
	 UJ92SagNiTgwR8qdnqYvn5fdzrXveekZBttTIoxqfD5GTF3ckgJR7BdlQegUux3GlZR3W
	 W+0i4eene7F/5NzftJhp0gZx7oUJYmX3pGyiRaMQ23//M6yI1m117kqZuyylwiWlXGSIP
	 QFO17hZlWiLDFVXoDvUPnKJuyEhtGsqxQf4/orrDx9dLmX23sIg9C93fXpg1BTrmb3mZD
	 9MwxKF8nfsi3D6trst2xNDIDAdF+BZQaUFR8/EyEZoRM5ZVP5KLukRtYObXjS7TlYwQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qfCvU0Vd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83FAD606A31C;
	Thu, 19 Nov 2026 01:35:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qfCvU0Vd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D553E1F000C4;
	Thu, 19 Nov 2026 01:35:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052144;
	bh=uUW6KCr3tkYg4x8Fkx1ryhzJqCz+YrNuHKQz6taCrow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qfCvU0VdNxQifoVjRxZwnuoF9C6cmQ0DjcQTtxAlP2WecPUIDm713TZGfYKKKOJ2L
	 Lj2TrodHRqtryc8PwEIATfU5xCzQfj09z+qKkbOyqu2Fcl4gsjMhdLW6eoSFZWW1lB
	 Mw9JUzXEwZ/JdQLalldl5iRBVeFIzNm5WmgYD4jY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0457/2214] thermal: intel: powerclamp: Reject invalid window_size values
Date: Wed, 18 Nov 2026 15:35:33 +0100
Message-ID: <20261118150029.523971447@linuxfoundation.org>
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

From: Thorsten Blum <thorsten.blum@linux.dev>

[ Upstream commit 40989202104e498ff9adfb8c575d6cd159f13988 ]

window_size_set() sets ret to -EINVAL if new_window_size is outside the
valid range, but then falls through and still updates window_size to the
clamped value.

Return -EINVAL immediately and do not update window_size. Also drop the
now-redundant clamp() call.

Fixes: d6d71ee4a14a ("PM: Introduce Intel PowerClamp Driver")
Cc: All applicable <stable@vger.kernel.org>
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Link: https://patch.msgid.link/20260815090136.88540-2-thorsten.blum@linux.dev
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/intel/intel_powerclamp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/thermal/intel/intel_powerclamp.c b/drivers/thermal/intel/intel_powerclamp.c
index 08ea6cdb25b88..a93b648eac98d 100644
--- a/drivers/thermal/intel/intel_powerclamp.c
+++ b/drivers/thermal/intel/intel_powerclamp.c
@@ -154,9 +154,10 @@ static int window_size_set(const char *arg, const struct kernel_param *kp)
 		pr_err("Out of recommended window size %lu, between 2-10\n",
 			new_window_size);
 		ret = -EINVAL;
+		goto exit_win;
 	}
 
-	window_size = clamp(new_window_size, 2ul, 10ul);
+	window_size = new_window_size;
 	smp_mb();
 
 exit_win:
-- 
2.53.0



