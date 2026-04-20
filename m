Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D9EA344057;
	Mon, 20 Apr 2026 16:11:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776701501; cv=none; b=u3OLumB1fKN4YbjJM8gklHQwyj+gfPUQOmA11uy903o4DcPCyOk11W5XyXU/eFfKXO5Uc5xjaYYnGVokdh/sZ2TFJHEbFpz+0mX8Y6sVruWEsiCkT76m8TPF/+FahmBlLwGM3XdpbZ2p5+esNDYYy5qkesj0W3WQtMwsSiTiUO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776701501; c=relaxed/simple;
	bh=VWGiMmcmL5+tiLXsq6ZqN9D+3zPvhNP5ZJ3yMvbASqA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nTjbvR53+x3R1+5snwhuG6taZTyYieao7BBH0dmcA/5td+pxvxVHuE04UHhly6TKlUrrDIqXxXFElQDJ5Y32HgTG7ObsXuTxAgepBukRBalD9THLtQyLXLBQ3OaFt109dFJgaRy0dgcJmd4nxN29BwyLInbzwse+CQG3d/nsiSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ahcaBMI2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ahcaBMI2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A83B8C19425;
	Mon, 20 Apr 2026 16:11:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776701501;
	bh=VWGiMmcmL5+tiLXsq6ZqN9D+3zPvhNP5ZJ3yMvbASqA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ahcaBMI2xKLnUpy5MW1+L2LvI2aG4NZ1FgIRIz4u0O7GcBlveusn485CK1vgXssLB
	 N1lhoqOJ6JzaTbUGZ+QPzghWlyV3THyxwVQL8FYdDEfGt8dgaoVIg696WZbM94Xy1A
	 FJZQQso99mO4ZehLQ7CMIlD8e0pB3xyJjWWX2FS0=
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
Subject: [PATCH 6.12 138/162] checkpatch: add support for Assisted-by tag
Date: Mon, 20 Apr 2026 17:42:50 +0200
Message-ID: <20260420153932.045455554@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153927.006696811@linuxfoundation.org>
References: <20260420153927.006696811@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -622,6 +622,7 @@ our $signature_tags = qr{(?xi:
 	Reviewed-by:|
 	Reported-by:|
 	Suggested-by:|
+	Assisted-by:|
 	To:|
 	Cc:
 )};
@@ -3070,6 +3071,15 @@ sub process {
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


