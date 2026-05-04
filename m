Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BC6D3DDDDA;
	Mon,  4 May 2026 13:59:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903180; cv=none; b=qT28jlkvEoyk4aLD6E3/Hl2bUCR07PHEhwkTye2V1K45YP+SflZN0DuSmRZBmqLQtOD0LlceqPJxeM774KStCjB2BrVmQTOSFwhyz/7d3NgcSQg5Zk6Doe8luuxgKIf/UCsA5SjL2RF6/keNP4h/AU+UMvAq7GcAtBszRFKLlPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903180; c=relaxed/simple;
	bh=JK4slfr9CgWK5baufDJET563mICcSabfdIPQy5tT0rk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NayaK7OpiOE6nwDy+zbAgEmaFZs52BTxCyjTsz8DKK0e72TY6ugr5W1kO7Sw8GYh/dRyIWRJ47CsAaiTVNeVshWH8f7AdEJjAPZVtRlkDjeO5dwXyKw0PL9nNouETugtaESjmJl6RUmBsoh9Dp6ktJXqB7j8UhIxYwrxPwMszZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kp2Ru+vM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kp2Ru+vM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68BDDC2BCB8;
	Mon,  4 May 2026 13:59:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903179;
	bh=JK4slfr9CgWK5baufDJET563mICcSabfdIPQy5tT0rk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Kp2Ru+vMMr1XJvwxFKPbt1Al7ZuyK5VD/C3+ZMGSXEGDhII0sxFMs1fc1m2ufpaRR
	 JJ5aYb8xQA4We745b5yc1TeEAaflnmK5l27wvK2uxa/3kkL81oUX/QN9sePgL4clXg
	 bp41HuI5OMR2taBxZu8giD888tm0jneYZAs3Lq1g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?G=C3=BCnther=20Noack?= <gnoack@google.com>,
	=?UTF-8?q?G=C3=BCnther=20Noack?= <gnoack3000@gmail.com>,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
Subject: [PATCH 7.0 102/307] selftests/landlock: Fix snprintf truncation checks in audit helpers
Date: Mon,  4 May 2026 15:49:47 +0200
Message-ID: <20260504135146.649630049@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.814938198@linuxfoundation.org>
References: <20260504135142.814938198@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mickaël Salaün <mic@digikod.net>

commit b566f7a4f0e4f15f78f2e5fac273fa954991e03a upstream.

snprintf() returns the number of characters that would have been
written, excluding the terminating NUL byte.  When the output is
truncated, this return value equals or exceeds the buffer size.  Fix
matches_log_domain_allocated() and matches_log_domain_deallocated() to
detect truncation with ">=" instead of ">".

Cc: Günther Noack <gnoack@google.com>
Cc: stable@vger.kernel.org
Fixes: 6a500b22971c ("selftests/landlock: Add tests for audit flags and domain IDs")
Reviewed-by: Günther Noack <gnoack3000@gmail.com>
Link: https://lore.kernel.org/r/20260402192608.1458252-2-mic@digikod.net
Signed-off-by: Mickaël Salaün <mic@digikod.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/landlock/audit.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/landlock/audit.h
+++ b/tools/testing/selftests/landlock/audit.h
@@ -309,7 +309,7 @@ static int __maybe_unused matches_log_do
 
 	log_match_len =
 		snprintf(log_match, sizeof(log_match), log_template, pid);
-	if (log_match_len > sizeof(log_match))
+	if (log_match_len >= sizeof(log_match))
 		return -E2BIG;
 
 	return audit_match_record(audit_fd, AUDIT_LANDLOCK_DOMAIN, log_match,
@@ -326,7 +326,7 @@ static int __maybe_unused matches_log_do
 
 	log_match_len = snprintf(log_match, sizeof(log_match), log_template,
 				 num_denials);
-	if (log_match_len > sizeof(log_match))
+	if (log_match_len >= sizeof(log_match))
 		return -E2BIG;
 
 	return audit_match_record(audit_fd, AUDIT_LANDLOCK_DOMAIN, log_match,


