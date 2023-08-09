Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22CA11FA6
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 11:09:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 301E1C433C7;
	Wed,  9 Aug 2023 11:09:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691579366;
	bh=H0TKRjdDOb6PBxwTn9p9QlwmdCfsVF23J9kHlRFZVtY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bj3hQx5qiELIWNzOkyDRIxI8Erx066zHfTg1jQcHTIUd00/K4PsIyZSLOPRUDKqh0
	 MnEK3LjMeOx7oUlDogRyJDa71HMrBXjqWUIDGWFzfD8BBuirQP+bqxA2WfrzE1q+DG
	 5PzMiWw6oWtmw8llO66DoJeLsGwNtokVy3IDFsqQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kees Cook <keescook@chromium.org>
Subject: [PATCH 4.14 169/204] Documentation: security-bugs.rst: update preferences when dealing with the linux-distros group
Date: Wed,  9 Aug 2023 12:41:47 +0200
Message-ID: <20230809103648.170684536@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103642.552405807@linuxfoundation.org>
References: <20230809103642.552405807@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 4fee0915e649bd0cea56dece6d96f8f4643df33c upstream.

Because the linux-distros group forces reporters to release information
about reported bugs, and they impose arbitrary deadlines in having those
bugs fixed despite not actually being kernel developers, the kernel
security team recommends not interacting with them at all as this just
causes confusion and the early-release of reported security problems.

Reviewed-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/2023063020-throat-pantyhose-f110@gregkh
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/admin-guide/security-bugs.rst |   24 +++++++++++-------------
 1 file changed, 11 insertions(+), 13 deletions(-)

--- a/Documentation/admin-guide/security-bugs.rst
+++ b/Documentation/admin-guide/security-bugs.rst
@@ -42,20 +42,18 @@ disclosure is from immediate (esp. if it
 to a few weeks.  As a basic default policy, we expect report date to
 disclosure date to be on the order of 7 days.
 
-Coordination
-------------
+Coordination with other groups
+------------------------------
 
-Fixes for sensitive bugs, such as those that might lead to privilege
-escalations, may need to be coordinated with the private
-<linux-distros@vs.openwall.org> mailing list so that distribution vendors
-are well prepared to issue a fixed kernel upon public disclosure of the
-upstream fix. Distros will need some time to test the proposed patch and
-will generally request at least a few days of embargo, and vendor update
-publication prefers to happen Tuesday through Thursday. When appropriate,
-the security team can assist with this coordination, or the reporter can
-include linux-distros from the start. In this case, remember to prefix
-the email Subject line with "[vs]" as described in the linux-distros wiki:
-<http://oss-security.openwall.org/wiki/mailing-lists/distros#how-to-use-the-lists>
+The kernel security team strongly recommends that reporters of potential
+security issues NEVER contact the "linux-distros" mailing list until
+AFTER discussing it with the kernel security team.  Do not Cc: both
+lists at once.  You may contact the linux-distros mailing list after a
+fix has been agreed on and you fully understand the requirements that
+doing so will impose on you and the kernel community.
+
+The different lists have different goals and the linux-distros rules do
+not contribute to actually fixing any potential security problems.
 
 CVE assignment
 --------------


