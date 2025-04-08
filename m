Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1644F224AEB;
	Tue,  8 Apr 2025 11:33:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112032; cv=none; b=Bfb0LJui6+ceA6D2jb6qXXhO7nwXSM0xkyooCm3/XwwM++Pc/hbPn6Tsrp0lVy9RQy2uwBboGz6o6970dNcAizsFPdCDm0Qa4thgH+Mz2Nhou2hvc98BcjzU/0LzAmcfTh33fujxlrkJKhM3mC+W8FW5m+wUcrEtEIT9TgY4IG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112032; c=relaxed/simple;
	bh=1fG0NUBLkygwLyfAlPI2KvmyA6PyYmveTCV/oS5ZsRs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mdco2NJht/zaJv/Y/k5OUYMzPk+H9hUpzdQrdCCo0+w5S604T67zY+0vXfzuGn4urt39uK9bpdkyZc+WEDHe75SHZkW8dWWR/z3ICn9/+yaPQKq6zW5MUK0xgvjBYeJ8dtmhvTizwBIXqbpCw9lMyZIbUHvj8is0GHZIQNoNQFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rHL4TSsQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rHL4TSsQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7511FC4CEE5;
	Tue,  8 Apr 2025 11:33:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744112032;
	bh=1fG0NUBLkygwLyfAlPI2KvmyA6PyYmveTCV/oS5ZsRs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rHL4TSsQoJGRrRjM5dpeXq5I+VVa3bAeeNfCnZtw/5moMbjJIfaSz8tWH8e6wRA7n
	 ehMRK/ZYCUCCyiaMh5ziPOtcKK8ypD2nBhe8tHLmX79mcPKedH+4Nj6yTOM2TULM21
	 ZgMT2UOkAUKKEJpZlWfNTExcOj/tN70mPWRoviCo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Rui <rui.zhang@intel.com>,
	Len Brown <len.brown@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 651/731] tools/power turbostat: Restore GFX sysfs fflush() call
Date: Tue,  8 Apr 2025 12:49:08 +0200
Message-ID: <20250408104929.407252240@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Rui <rui.zhang@intel.com>

[ Upstream commit f8b136ef2605c1bf62020462d10e35228760aa19 ]

Do fflush() to discard the buffered data, before each read of the
graphics sysfs knobs.

Fixes: ba99a4fc8c24 ("tools/power turbostat: Remove unnecessary fflush() call")
Signed-off-by: Zhang Rui <rui.zhang@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/power/x86/turbostat/turbostat.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/power/x86/turbostat/turbostat.c b/tools/power/x86/turbostat/turbostat.c
index 5b36f1fd885c9..4155d9bfcfc6d 100644
--- a/tools/power/x86/turbostat/turbostat.c
+++ b/tools/power/x86/turbostat/turbostat.c
@@ -6039,6 +6039,7 @@ int snapshot_graphics(int idx)
 	int retval;
 
 	rewind(gfx_info[idx].fp);
+	fflush(gfx_info[idx].fp);
 
 	switch (idx) {
 	case GFX_rc6:
-- 
2.39.5



