Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E83F1519AA;
	Wed,  5 Feb 2025 14:06:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764363; cv=none; b=l+dOGJuNjPmUyS2KM8GYEhpGV6XXDQkxOAruEyf8fjldwPnZOBEkkIIs08LcXHsl2btj3uJkL/w+VladpU3SMP9MoTRvRlM+IEr6zL7A7LKlNASFkZWbTubrN7hYG22OpZlycEbHvJPR+IDa2MBKhm3IQgE6SSh4nWptb+TfCbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764363; c=relaxed/simple;
	bh=aeyyR/BS0bAmyLeUaPCpvkMUXUb9NCTXeRS4qBxbMY4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FT9nBPxInsORKoLjgf8vRtt5b8gwlhRD44s8QPBYewrLV3iZC2Lp0De/CfGNodOCouM+V8MwrmujN7/EaHPNECIpXN+iAfQ0fJmbLfBjhn5Ug0x2Qso0qjfuy1F77eCTCzCloAba/Hz9y3M5MFAiejhmGUnsUxtQqQy1Ktue704=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jQV/1PHt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jQV/1PHt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CC0DC4CED1;
	Wed,  5 Feb 2025 14:06:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764363;
	bh=aeyyR/BS0bAmyLeUaPCpvkMUXUb9NCTXeRS4qBxbMY4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jQV/1PHth5APJKFp4mLlIGDCIxqSjzGFoMrsXwCUN57QtIpENY5Il687YwUAi6RXg
	 BngqmrkH+eWURnVHk0X8n7+PXperdPpEPSBcinKArwuXEIjEHeixVHNgG9cosi2bhv
	 fzDgVuw+lNL/T1ndyed0gZX+w+r7GOdOehoLnwWY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ba Jing <bajing@cmss.chinamobile.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 165/393] ktest.pl: Remove unused declarations in run_bisect_test function
Date: Wed,  5 Feb 2025 14:41:24 +0100
Message-ID: <20250205134426.610150480@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ba Jing <bajing@cmss.chinamobile.com>

[ Upstream commit 776735b954f49f85fd19e1198efa421fae2ad77c ]

Since $output and $ret are not used in the subsequent code, the declarations
should be removed.

Fixes: a75fececff3c ("ktest: Added sample.conf, new %default option format")
Link: https://lore.kernel.org/20240902130735.6034-1-bajing@cmss.chinamobile.com
Signed-off-by: Ba Jing <bajing@cmss.chinamobile.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/ktest/ktest.pl | 2 --
 1 file changed, 2 deletions(-)

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index 045090085ac5b..e84464d80e183 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -2946,8 +2946,6 @@ sub run_bisect_test {
 
     my $failed = 0;
     my $result;
-    my $output;
-    my $ret;
 
     $in_bisect = 1;
 
-- 
2.39.5



