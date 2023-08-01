Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C715D1FB4F
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:38:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A61DC433C8;
	Tue,  1 Aug 2023 09:38:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690882732;
	bh=D6/ImxoH9T4HOxUCh1VIDSXf5DTrEFBySBTS6g6aIAI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kgTxvGEwVb5bU0U/z6QoCxlJOCHqPbMKwi9KzZsd5krEzg2eN8m2BM9Z6iUlKuwac
	 rEP5m5Nes3P9PTunMD0MUHuclEv1ip22Ot2F9ECU0sSBWfbTjrRZ61Ic2ilf+n1Jvh
	 B7co7bNnpb8Qu7Msww91/7vRWvKWgRrxL+fJR6/Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kees Cook <keescook@chromium.org>
Subject: [PATCH 6.1 173/228] Documentation: security-bugs.rst: update preferences when dealing with the linux-distros group
Date: Tue,  1 Aug 2023 11:20:31 +0200
Message-ID: <20230801091929.121060644@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801091922.799813980@linuxfoundation.org>
References: <20230801091922.799813980@linuxfoundation.org>
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
@@ -63,20 +63,18 @@ information submitted to the security li
 of the report are treated confidentially even after the embargo has been
 lifted, in perpetuity.
 
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


