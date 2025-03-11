Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 974531C5D77;
	Tue, 11 Mar 2025 15:04:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741705492; cv=none; b=a8TIqiBhi8ou/BylaAGShiKvvkO2aDFgh+vlc8eVS69IkcmpsPxTKJc4Hro2ogiHNtg8nsE+Msz1/AWzthCwal6jrRebAt1akUa83hAPMFahvZyObFZ1BQW3NA6YkFU+6pd+et/Da/IcfVOByhq0nhYJ5V5T7j91N12kJRreZ2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741705492; c=relaxed/simple;
	bh=dQy3lQBbwZkDiC34cFT3ersxLJBgCpGdCCC98t6jlyQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gB1bn2kUffeLKjJD3W1KPdMER7+03vIte2W1Uyz4VWI+Ev/e1wFcCHtYa7jHTGVZmZvXOJ7gu2RrRMwoR0RkfplEH9vqNQvMrvTh5sNk9pmn2GIWPkJa2IUFNUxhm8wWfoQemBdvFq7XzgRdUwTE6iLlkM6IXoFQJ8blrFIaia0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Cy5ujDpG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Cy5ujDpG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C588C4CEE9;
	Tue, 11 Mar 2025 15:04:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741705492;
	bh=dQy3lQBbwZkDiC34cFT3ersxLJBgCpGdCCC98t6jlyQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Cy5ujDpGtUNoloPtldC5AYkkYdfWfnj6jfbQzR9VbLWZinYnuBskBcT3ce83+pILY
	 WzWNoF2evtlUYRED1YYcQLEE2ybMpdotmpEQc9Cyl2pfajrNVAAkyv9zkdyiUJuZnm
	 eNTBM6qqqB0sBL789AxlLsaV3khD1dWljwfax2Ig=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ba Jing <bajing@cmss.chinamobile.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 037/328] ktest.pl: Remove unused declarations in run_bisect_test function
Date: Tue, 11 Mar 2025 15:56:47 +0100
Message-ID: <20250311145716.370656516@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145714.865727435@linuxfoundation.org>
References: <20250311145714.865727435@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index e7adb429018b2..184af2fcc1597 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -2861,8 +2861,6 @@ sub run_bisect_test {
 
     my $failed = 0;
     my $result;
-    my $output;
-    my $ret;
 
     $in_bisect = 1;
 
-- 
2.39.5



