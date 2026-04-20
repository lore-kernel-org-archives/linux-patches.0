Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8754A2D978C;
	Mon, 20 Apr 2026 16:05:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776701108; cv=none; b=lV1RZ/nexrGW9V3q8SOifqBlRUOoK7W72O17S/4FtKfH4aqeF8uGTxyblWmw+2jqHd3/nTMxWjyPcK4mJUfKh7B3bYh/xCMHQ6cQ7Gq0X1ToS3ObHFUabW4p2L5wiiwxwF4ajd1a8HUVXpj7N3cOVY1cvHD9v7O+wWRbDw2+pLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776701108; c=relaxed/simple;
	bh=UvHFnvYJaYA3dkgsoIvkZ60U1ZO/iYFp77rVRGCvmqI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SBleGPzv8FAtpZknvSpWCbJtvrT54+xErOYDKeVbRUj+6871vTfEWr5NjO4YKdcawxM+Rj0l/hlHmcKsJWVive/85WKJKBZORXJluyCakwFrUqs6rMW+5eAMgi7kQPp0k0SRc0H15NFC17yfiaBGsb4oZTio/wj6XxXSUiFztqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x5WCzch6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x5WCzch6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 133BEC19425;
	Mon, 20 Apr 2026 16:05:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776701108;
	bh=UvHFnvYJaYA3dkgsoIvkZ60U1ZO/iYFp77rVRGCvmqI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x5WCzch6DZFGERqAUMsQzaKBXH8cvkBNiFd65WbfKfLfcY9d+HHZG5EmKWMNzHNCS
	 gxLDU7c5mtHYPHqHv+DGqb3gAjq5x+nmjZU6NremGgtEhVsSeUpsbbRPi7tZEkGVZ8
	 3pq0EawEzQwTm0+LQ8FDzY82qNpzPpijbjS4UiTw=
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
Subject: [PATCH 6.18 177/198] checkpatch: add support for Assisted-by tag
Date: Mon, 20 Apr 2026 17:42:36 +0200
Message-ID: <20260420153941.990587474@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153935.605963767@linuxfoundation.org>
References: <20260420153935.605963767@linuxfoundation.org>
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
@@ -3087,6 +3088,15 @@ sub process {
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


