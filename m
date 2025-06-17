Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48DC42264B7;
	Tue, 17 Jun 2025 15:38:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750174684; cv=none; b=iygUhyiPZfkg7bQBp0O9eK+zHFysa1Jwguct8mx5bv4fYcoNf/PUCjgqb47VPkj/Ip+6hdcF4GLHvolm5Fw6OJ+VQOC3MwflLDIz60TSVJO4Xr2+j8u7NgAVPIOhctQ2s98apzfv4eaDndH451CjiYRettFrBdrVxWNSd9lgafg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750174684; c=relaxed/simple;
	bh=d3N67LdHakgdlrMmqUHmnHzQR5N07OaisGFgInXAPCs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=otDUw69SzpM3TH8JmXwumn4TyVLMDvafaWPCFTokRpBg3utNgInJf8qFC7QlA02/HRPqqLGsVoDJ3PMcbShW+NrR0Ntmha9RgiNIsFP6p89avLTNggBPqCqw0sJvuQX4ott+cvoH1egP3k2iozCw+6gD6Fdjk0tShJRLTTWgIU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wgiQj2EG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wgiQj2EG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FEDCC4CEF4;
	Tue, 17 Jun 2025 15:38:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750174681;
	bh=d3N67LdHakgdlrMmqUHmnHzQR5N07OaisGFgInXAPCs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wgiQj2EGuMDTcEOJ3Ob8I96EdXM5Zu7ju15M/V15zAqboU+j+wpy60VGrie2KbWv3
	 XHRSNaF45QljIf0frp3OsJFvAnp+bY0qyktswU58GC37ISZCQ4d2u9KClQlgkBypoF
	 BTDV/PBbLB0kfE1g9WFSl6d7/mfeOjJ2F7bWm6Lw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <quic_zijuhu@quicinc.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 050/512] PM: wakeup: Delete space in the end of string shown by pm_show_wakelocks()
Date: Tue, 17 Jun 2025 17:20:16 +0200
Message-ID: <20250617152421.561678575@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



