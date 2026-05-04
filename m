Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79903315785;
	Mon,  4 May 2026 14:18:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904321; cv=none; b=SqoSfNEWZoHjqNevMSZSDHWQEdaRPI7rLDXTO6rEVI8/7fNl7lql//WDw1pCypDsS4o4j1a7+kuqBSaV6toFasrKU43ZiZCGWFiORN0Lo7ofc1obOG3hsop5+6ewmcbzz3BpbC6M4f2xcl3+5/SAUQ95UL7FscwD7gMmuMKoDWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904321; c=relaxed/simple;
	bh=Sm+/dzXBehUwtovZEZ/4BZr+XpPZW1JKS99QAfRRDtQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sbmmseBkTxSDZIkSMvvCh2Yr2xFqobfZXOSpaqg4QkP9zDJWBXss64gZZP3eQu+e3YaG0j/o3lkYICRVI3us76rqtnua92d2JO/Zrl0S6WOZsGnp5KIALv3FxjnANQvm1gIYHHHw2tdmFpFLFoaJqMY5CxKGweMmb8dQXo6yKGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wQDfcYLv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wQDfcYLv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11049C2BCB8;
	Mon,  4 May 2026 14:18:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904321;
	bh=Sm+/dzXBehUwtovZEZ/4BZr+XpPZW1JKS99QAfRRDtQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wQDfcYLvhmtoVR0TPMUcZfveQS0gxwSaLbNaH/ulhVdFJCnDNsnpCpyU1iz5dN/IR
	 EcHQpav23O9fYRJcpTioNCVxifqr5wb66Ui/JuFlxWb37eARQGRY24WDEtX1MF7ZYD
	 tn+ZCRrJ8i4/Zb4LhaTYCUhKQxkJHCbXEihTanIg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Warthog9 Hawley <warthog9@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 6.18 237/275] ktest: Fix the month in the name of the failure directory
Date: Mon,  4 May 2026 15:52:57 +0200
Message-ID: <20260504135151.852959734@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.929052779@linuxfoundation.org>
References: <20260504135142.929052779@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1815,7 +1815,7 @@ sub save_logs {
     my ($result, $basedir) = @_;
     my @t = localtime;
     my $date = sprintf "%04d%02d%02d%02d%02d%02d",
-	1900+$t[5],$t[4],$t[3],$t[2],$t[1],$t[0];
+	1900+$t[5],$t[4]+1,$t[3],$t[2],$t[1],$t[0];
 
     my $type = $build_type;
     if ($type =~ /useconfig/) {


