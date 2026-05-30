Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37B8B34EF07;
	Sat, 30 May 2026 16:56:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780160173; cv=none; b=UvQzxWp/YDMeYuWS7ibecQhrpMqpES0I2TITjoM1wj0mhTPIzMkf7JMji3BTvUCadhVwbbbAHeUGr4qxe1/FnF17DwjI5NMlc+vwBsYskOO6aURnhDmYqAoiODhemXl9gU3fNBXpFn4ldkYRNVXF4lFf1l4ldJ84nLHbrr0RYdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780160173; c=relaxed/simple;
	bh=WdOjkzad/B9DZVSAAGiiu/zT3XHLvPe9cWDPdV16ssE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=enylei9iBsWI9vKEGuFcRhJeUQblTOBqO718VGWVhW69FNRMxTUdRpzU2fLg9AUVgEzDPbnFyLawnVciCOw4Z6vuMvSG7ppenPr//5xrgDn3pLDbyYfeW12tlpQt45pXMbEFgkltPA2SH6r38bKKQIm1CEViA8W6xpctPzvoCC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xeUSkz0M; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xeUSkz0M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C6F31F00893;
	Sat, 30 May 2026 16:56:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780160172;
	bh=vmmMnhLvzIiMED+4bYgWDAtjxryoli0xB4XwgoLeSho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xeUSkz0MtPPwnlNKENIttSxYK8xt99KG0mL8X6+onH4wu/6syejGdNIwxY2aAbzNi
	 Tz0CSlN6dKIVGFOHUDQ7cxeJzWp9qu4si3y+nGE7rESEweSbArhMezfIsQalUKwQuV
	 gWte4OjofqmrrxWKqcxfukSbbcIm/tNNs1sLebo8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Warthog9 Hawley <warthog9@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 6.1 264/969] ktest: Fix the month in the name of the failure directory
Date: Sat, 30 May 2026 17:56:28 +0200
Message-ID: <20260530160307.766729011@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Rostedt <rostedt@goodmis.org>

commit 768059ede35f197575a38b10797b52402d9d4d2f upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/ktest/ktest.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -1770,7 +1770,7 @@ sub save_logs {
     my ($result, $basedir) = @_;
     my @t = localtime;
     my $date = sprintf "%04d%02d%02d%02d%02d%02d",
-	1900+$t[5],$t[4],$t[3],$t[2],$t[1],$t[0];
+	1900+$t[5],$t[4]+1,$t[3],$t[2],$t[1],$t[0];
 
     my $type = $build_type;
     if ($type =~ /useconfig/) {


