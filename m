Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C9763D6690;
	Fri, 24 Apr 2026 13:38:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777037901; cv=none; b=F4u7egPeBaWP1WL9zJEvMUQ3giN/cGo4XYb8EcfxBDUd8U2I9XfxXf34R7Rj8eU8oNdVO8VK0vMUjSIlAU3cVUsxHly/zEYncfZplzdHC0/1cgwDcu/K0X1q+Pnh/cAiCeLFDtpPFSGMG+MRdHo5JRmqgvkHvhreRMTivxlwDb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777037901; c=relaxed/simple;
	bh=3ZRGVp+lF5jwOd7xa1CpJkoYChp8VQw9z4ME1ADLo2s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sdOapwXgkpQVLDz3vUmKWhlGqTJzN+/GVwAoegXUDF+x+uDcfLD2wYKCVjpseiQ5bO9d+xnBdpj9tC82/tswiI90sJ4Z+Luz5ChWytEx+0UAFOXNU0nhFwoanFIhhhIb2tuYjUZ9OURI8oJSVu73AzGr7hxdK+qj+xGjVs5093g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S9rzRqXQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S9rzRqXQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3D80C19425;
	Fri, 24 Apr 2026 13:38:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777037901;
	bh=3ZRGVp+lF5jwOd7xa1CpJkoYChp8VQw9z4ME1ADLo2s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S9rzRqXQrBt0JgIHxVo2L9cQJZEGgSBG6ujeZwSvRkAoKKjeE6P14txrGmmokbnz+
	 8/adCxRzxe2h/ITGANzL7UuawuflkmZ+9BQz7pNPKW4/FtOk/PasKVuBCgsNZX6Pyv
	 VzrYbMqWyosxkHx8R1Nf/QGFNxMRQnuP0DHnZFEU=
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
Subject: [PATCH 6.6 112/166] checkpatch: add support for Assisted-by tag
Date: Fri, 24 Apr 2026 15:30:26 +0200
Message-ID: <20260424132556.263629356@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260424132532.812258529@linuxfoundation.org>
References: <20260424132532.812258529@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -621,6 +621,7 @@ our $signature_tags = qr{(?xi:
 	Reviewed-by:|
 	Reported-by:|
 	Suggested-by:|
+	Assisted-by:|
 	To:|
 	Cc:
 )};
@@ -3069,6 +3070,15 @@ sub process {
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


