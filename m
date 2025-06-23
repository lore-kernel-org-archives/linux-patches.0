Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F06A253F30;
	Mon, 23 Jun 2025 13:28:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685285; cv=none; b=CA1blc/nCfyEA2ksRSb3FVf4ovbgSSwKIGbeLgzGJvx3aGDrwhSbLn+uyYHb9PD+4FanXVcKPQlsLx6Z5tuKu6f6Wl6MUyABWFsaP/ALf9I1ggJN0mYVfxOCjedjZ2Gx2Il83KMY6Stk2GBfnjOJwDDu5SujvP/Qik5+Zk1jFrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685285; c=relaxed/simple;
	bh=jQXONf81f3SjspITyh8zGx61vLykrHNfZ1pEW6ztNIA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ernGIVUh/i1YKwPu1zTxHaavRYHbZ9EZI6u9ke27quR+UiDLZAGegONgDhxG9DNpAAUINkxPKhWNiakJRfn8hO/g7ti10xz4ki0zARgLWq+l4oNYgmqtvwjAty/pJtgkdUdZrEEWMWorX/Eyjjubj1OY8q2P4gCR91LO+yaaqCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EWbgie/J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EWbgie/J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32EE6C4CEEA;
	Mon, 23 Jun 2025 13:28:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685285;
	bh=jQXONf81f3SjspITyh8zGx61vLykrHNfZ1pEW6ztNIA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EWbgie/JEXXFlrREbInhC6NsbfcFTIjH2CUWPhZViwFEdfFUzJJnx+tR0DfHHGomL
	 ctVDq15INY8nfk8PQ+bd/aO4GTfrzDF0UFJseNUM8LRybhS+tdI+h76u9PqPiY1dQG
	 HbmXCdrWB7tzYPtT86pBhph51jL6Y/xondKu+I+0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <quic_zijuhu@quicinc.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 023/411] PM: wakeup: Delete space in the end of string shown by pm_show_wakelocks()
Date: Mon, 23 Jun 2025 15:02:47 +0200
Message-ID: <20250623130633.698914868@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zijun Hu <quic_zijuhu@quicinc.com>

[ Upstream commit f0050a3e214aa941b78ad4caf122a735a24d81a6 ]

pm_show_wakelocks() is called to generate a string when showing
attributes /sys/power/wake_(lock|unlock), but the string ends
with an unwanted space that was added back by mistake by commit
c9d967b2ce40 ("PM: wakeup: simplify the output logic of
pm_show_wakelocks()").

Remove the unwanted space.

Fixes: c9d967b2ce40 ("PM: wakeup: simplify the output logic of pm_show_wakelocks()")
Signed-off-by: Zijun Hu <quic_zijuhu@quicinc.com>
Link: https://patch.msgid.link/20250505-fix_power-v1-1-0f7f2c2f338c@quicinc.com
[ rjw: Changelog edits ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/power/wakelock.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/power/wakelock.c b/kernel/power/wakelock.c
index 52571dcad768b..4e941999a53ba 100644
--- a/kernel/power/wakelock.c
+++ b/kernel/power/wakelock.c
@@ -49,6 +49,9 @@ ssize_t pm_show_wakelocks(char *buf, bool show_active)
 			len += sysfs_emit_at(buf, len, "%s ", wl->name);
 	}
 
+	if (len > 0)
+		--len;
+
 	len += sysfs_emit_at(buf, len, "\n");
 
 	mutex_unlock(&wakelocks_lock);
-- 
2.39.5



