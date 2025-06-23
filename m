Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F2B2257436;
	Mon, 23 Jun 2025 13:30:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685428; cv=none; b=dly/9x3n2paUbWJUGQQjVNfGeUwwx0NZVAE1LInOUiWcy80YqhbKcFnZDU3T/VXAZoTWgemqtam1kipYpN3YVtoE4zXZXKdidbmeOEKCZ3wW2iY0X9u9M+jbWJVOE4XPOpHQXcjNjM1gTJA75rBhgYvVEYzf9ovrANNFo/J4xes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685428; c=relaxed/simple;
	bh=uSOAXLVfux347zgSN9mNysJF1TEndxCTFh1dN5r+B0A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=icSaa7sDt/762qgKEGa3pOCXqgQ0BA1KV1dKFEbP04Oh9cPpAufGB70nLq5AwwBoaTtxIx2CXSIjdWdeiIdvdJQXqqKdEGdR6yeWY1VPj4DbmR/4cbEYM5Ipc+rxLNJTiOIgEm6T1oJMYAbQ68Juu+M+TKmguqhcYHVa4uSahPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TnnOFkTC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TnnOFkTC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A41AFC4CEF1;
	Mon, 23 Jun 2025 13:30:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685428;
	bh=uSOAXLVfux347zgSN9mNysJF1TEndxCTFh1dN5r+B0A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TnnOFkTCZzIVsWTVIGmp5tCm10MLNwUaiOm/HeHWbvYjmopQgzjG7sgWZnP8SX8jg
	 1/7+0L8K2Vm6aHQ/+JcVP2lSDlMmDXx47r6gRhJaIkLGJGBFWUqfjGbXUqy+8XoqwU
	 QVs0zH9NvlbGYyiBZq5DT8AtHYut6/jiMbFWe8Fs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <quic_zijuhu@quicinc.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 031/508] PM: wakeup: Delete space in the end of string shown by pm_show_wakelocks()
Date: Mon, 23 Jun 2025 15:01:16 +0200
Message-ID: <20250623130646.012624827@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



