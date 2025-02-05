Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4B1C7E792;
	Wed,  5 Feb 2025 14:33:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766007; cv=none; b=FFlioillIGXvvCKATgynvdSp1zJpgcCFazrfyMAXUKhl6rjlhD/Q7kYyPeJCM/gliC6ECMLKWIE5nZ1x2CFLzUBBZQpG+0ugmytv8jFFJcm50KFMihhHH3ebi+FCjEzrYZSjA/bRt3hsDT741W5Xu67jNMz3YRBYeme0nVFCfNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766007; c=relaxed/simple;
	bh=JvUBMSn2o0SBm+nqXyNHksTcOVcnUnxCx0t1Kl/n7UY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rfXTmz/MSqFt32GsWirccveI0AE51mY275ukWbZKxwk9bui01b8Q1eg4KFKYOr42DXmJzgfUkE8Pi5kvwrXhkURt7S4RVxPou4wegrUSZ2fQ6XYtglgGjP5ejtYPdfUhuBDjIukHo0GASK8P/1R45LmN5Fyv9RvQGTS9iRYvJYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kmo3qxEm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kmo3qxEm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AF56C4CED1;
	Wed,  5 Feb 2025 14:33:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766007;
	bh=JvUBMSn2o0SBm+nqXyNHksTcOVcnUnxCx0t1Kl/n7UY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kmo3qxEmja17hgpTDxn6na9SqmvZxxLQgWZXpj41hAElNfx+c76phE1rFGrzYTNc6
	 49axYvfiYn9lSqXkZ2wvNRuI6tQi4UZ0+phYEULBtJXF9eIPQcF1Ok2iKiaOjVcVZ3
	 4kPhX9vsnksY8I2n2mTA+W/evCzob1OprOf2xHyE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ba Jing <bajing@cmss.chinamobile.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 256/590] ktest.pl: Remove unused declarations in run_bisect_test function
Date: Wed,  5 Feb 2025 14:40:11 +0100
Message-ID: <20250205134505.073660176@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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
index dacad94e2be42..ecb22626805d5 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -2960,8 +2960,6 @@ sub run_bisect_test {
 
     my $failed = 0;
     my $result;
-    my $output;
-    my $ret;
 
     $in_bisect = 1;
 
-- 
2.39.5



