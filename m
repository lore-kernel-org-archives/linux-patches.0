Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A70A83191BA;
	Tue, 16 Jun 2026 19:01:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781636489; cv=none; b=OtNZJ2B30kXiy8tRwixqv1CuJjSR0rwfRw/YPMzzDBCAfYZYNJHUQxRhk6hFI8hdBI9xvCJPIq1BHlJb6gxDWAX1t2CC2BVtYhVv8fdqcro1GR01P7FIBknZ7zkyVzRthBH9ljUaizz+4pvmafOqIvuPKLy4ULA0Qbe8zuG6qz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781636489; c=relaxed/simple;
	bh=ARf1JyhW60Ll/CF6luldv0c9qFF/QZrDVPWiKc/C63E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QznztzGlg473DiMZtwGtnzdEAFYmpeJSpxC1ybNjgA0SWz9zoKeKf8n1pk6m91RRUFOu1BgDNDl8U5MpnxX+OOmGsPpFsMAGZV6D8WAH6ZskDtOGvh5ZYTR0wkx8dYKfwAZpxDfq3pNv8Fe/ukjJ61U4mv52tq1+8rAs3gZcv5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2I5gXXGu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2I5gXXGu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A78A91F000E9;
	Tue, 16 Jun 2026 19:01:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781636488;
	bh=d1bSscMfBnY31OkjDb7Dn4OmAHGWaO9mj7XTX3424Y4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2I5gXXGuLAdfzmPmxqb/+eEmeVHITrfK/g2mCblsJayj4u4ThEI7NtJew16K+QvMp
	 yy6EyCi0GDKaxM1Q+59IaHiEyjGrFoRWjPT8fC/+jPWRaWh91XmthMrP+cISG3xiC4
	 1XoRjcIxuWc5AA5tjgdOW0ftXe7WyaXZgZ7zzZEQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Warthog9 Hawley <warthog9@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 247/342] ktest: Fix the month in the name of the failure directory
Date: Tue, 16 Jun 2026 20:29:03 +0530
Message-ID: <20260616145059.732729147@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145048.348037099@linuxfoundation.org>
References: <20260616145048.348037099@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Rostedt <rostedt@goodmis.org>

[ Upstream commit 768059ede35f197575a38b10797b52402d9d4d2f ]

The Perl localtime() function returns the month starting at 0 not 1. This
caused the date produced to create the directory for saving files of a
failed run to have the month off by one.

  machine-test-useconfig-fail-20260314073628

The above happened in April, not March. The correct name should have been:

  machine-test-useconfig-fail-20260414073628

This was somewhat confusing.

Cc: stable@vger.kernel.org
Cc: John 'Warthog9' Hawley <warthog9@kernel.org>
Link: https://patch.msgid.link/20260420142426.33ad0293@fedora
Fixes: 7faafbd69639b ("ktest: Add open and close console and start stop monitor")
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/ktest/ktest.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -1739,7 +1739,7 @@ sub save_logs {
     my ($result, $basedir) = @_;
     my @t = localtime;
     my $date = sprintf "%04d%02d%02d%02d%02d%02d",
-	1900+$t[5],$t[4],$t[3],$t[2],$t[1],$t[0];
+	1900+$t[5],$t[4]+1,$t[3],$t[2],$t[1],$t[0];
 
     my $type = $build_type;
     if ($type =~ /useconfig/) {


