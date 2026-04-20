Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22470331A78;
	Mon, 20 Apr 2026 15:55:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776700507; cv=none; b=j8IxWaB43JaJmt3j8fNPeNlKosuRDP5YJRcX64FotPxN8rZmUxvOlYMEujscAoe3YmYz6Jhsxs6mIGSxVNsKTaTQbijWN9QAs3nlFXPPHlKlxyl23NkexGkpaTWCNXTaDnnKMb9+CVbOiHHKdzO6G0+4KNVkaA74liphOx1+ajw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776700507; c=relaxed/simple;
	bh=HlvshGJS4ADLeYzZ97VhwvBJ3FzpUwtg9aLkfvChbgE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FoyFsTysHLZCwHjCpDrJPvYggiZiWf6sETKpTNXLw8Fn2V+iDWk21g5k3Qw09jI2qOo+DAIVluUJ93GPCyJHxL3S9S1MGZ5xQsuIkl6xWlzlzg+NknMIfuFDnmPi8Dkz3jqvG3eMZTV3Xotfatbihh03hLJ0RPU57BMJxM1clb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k4Rqbq2Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k4Rqbq2Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC150C19425;
	Mon, 20 Apr 2026 15:55:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776700507;
	bh=HlvshGJS4ADLeYzZ97VhwvBJ3FzpUwtg9aLkfvChbgE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k4Rqbq2YLjqB8lu24WzB1dJlv/yLRRu78PsLyIM35PcfFvuecuAcNnIEoNNsaEhJ8
	 Og6IEWYlKhJWxsn0MAJCTe3LY9BCJCFh6btalQKeO1bCOl8TgChNVBimtvjpDT6Pb6
	 Dt+wlM0VlV9DVUegpLYy5+Bbhq8Nx9HBw4xDVFE0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>,
	Joe Perches <joe@perches.com>,
	Andy Whitcroft <apw@canonical.com>,
	Dwaipayan Ray <dwaipayanray1@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Lukas Bulwahn <lukas.bulwahn@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.19 199/220] checkpatch: add support for Assisted-by tag
Date: Mon, 20 Apr 2026 17:42:20 +0200
Message-ID: <20260420153941.193836427@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153934.013228280@linuxfoundation.org>
References: <20260420153934.013228280@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sasha Levin <sashal@kernel.org>

commit d1db4118489fffd2b2f612140b7acbb477880839 upstream.

The Assisted-by tag was introduced in
Documentation/process/coding-assistants.rst for attributing AI tool
contributions to kernel patches.  However, checkpatch.pl did not recognize
this tag, causing two issues:

  WARNING: Non-standard signature: Assisted-by:
  ERROR: Unrecognized email address: 'AGENT_NAME:MODEL_VERSION'

Fix this by:
1. Adding Assisted-by to the recognized $signature_tags list
2. Skipping email validation for Assisted-by lines since they use the
   AGENT_NAME:MODEL_VERSION format instead of an email address
3. Warning when the Assisted-by value doesn't match the expected format

Link: https://lkml.kernel.org/r/20260311215818.518930-1-sashal@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
Reported-by: Bart Van Assche <bvanassche@acm.org>
Acked-by: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Dwaipayan Ray <dwaipayanray1@gmail.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 scripts/checkpatch.pl |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -641,6 +641,7 @@ our $signature_tags = qr{(?xi:
 	Reviewed-by:|
 	Reported-by:|
 	Suggested-by:|
+	Assisted-by:|
 	To:|
 	Cc:
 )};
@@ -3091,6 +3092,15 @@ sub process {
 				}
 			}
 
+			# Assisted-by uses AGENT_NAME:MODEL_VERSION format, not email
+			if ($sign_off =~ /^Assisted-by:/i) {
+				if ($email !~ /^\S+:\S+/) {
+					WARN("BAD_SIGN_OFF",
+					     "Assisted-by expects 'AGENT_NAME:MODEL_VERSION [TOOL1] [TOOL2]' format\n" . $herecurr);
+				}
+				next;
+			}
+
 			my ($email_name, $name_comment, $email_address, $comment) = parse_email($email);
 			my $suggested_email = format_email(($email_name, $name_comment, $email_address, $comment));
 			if ($suggested_email eq "") {


