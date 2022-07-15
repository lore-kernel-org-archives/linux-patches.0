Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C05C4C65
	for <patches@lists.linux.dev>; Fri, 15 Jul 2022 19:20:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1947BC3411E
	for <patches@lists.linux.dev>; Fri, 15 Jul 2022 19:20:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1657912829;
	bh=hq3R7l6EjejFZdW/hYnBP48vF8zIaulKJR3en89llbY=;
	h=Subject:From:Date:To:From;
	b=ZM5Lbp/IbLxtvVo9m1HkXXnOyfpgXGxD7cHe6HID1HUPbZVaadlotwu/Cb/e3mrUA
	 nQz5Sdw52vGeyWDuEz/nCgCFgQvjvJrOrdHxt6itZE7XQlh+FnaU7GmpTdi2EXqWLm
	 MI3SRj+kz30QjtBMZGllyHyXTZDOpHKXByTey4D4=
Subject: [PATCH v2 0/3] Fake series to test out b4 submit
From: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Date: Fri, 15 Jul 2022 15:20:28 -0400
Message-Id: <20220707-my-new-branch-v2-0-c378d618b16b@linuxfoundation.org>
To: Linux Patches <patches@lists.linux.dev>
X-Mailer: b4 0.10.0-dev-05523
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Developer-Signature: v=1; a=openpgp-sha256; l=934;
 i=konstantin@linuxfoundation.org; h=from:subject:message-id;
 bh=hq3R7l6EjejFZdW/hYnBP48vF8zIaulKJR3en89llbY=;
 b=owGbwMvMwCW27YjM47CUmTmMp9WSGJIu7v1zksv5+bHyvyk600MfKJ/WePRX9vBXV/PzHN+O1dpc
 FZPZ1VHKwiDGxSArpshSti92U1DhQw+59B5TmDmsTCBDGLg4BWAitUsZGXpuR+RuaA3J32ChYLfwvd
 yGrMvOFmwdEu4vNhTPz03YpM7wP3bSu1Vz50pXK8vXzOgQuXvg1XbLW5+/bFo+WS1MyEjWhA0A
X-Developer-Key: i=konstantin@linuxfoundation.org; a=openpgp;
 fpr=DE0E66E32F1FDD0902666B96E63EDCA9329DD07E

This is a fake series that I created to test b4 submit. It will be sent
to the patches list, but it's not a real set of patches. You can ignore
everything about it.

Signed-off-by: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Suggested-by: Sockpuppet Squirrel <mricon@gmail.com>

---
Changes in v2:
- Now claiming Linux specifically in the name of Kahless the Unforgettable
- Link to v1: https://lore.kernel.org/r/20220707-my-new-branch-v1-0-8d355bae1bb5@linuxfoundation.org

---
Konstantin Ryabitsev (3):
      Add myself as ultimate maintainer
      Our version goes to 11
      Rename Linux into Konix

 MAINTAINERS | 4 ++--
 Makefile    | 2 +-
 README      | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)
---
base-commit: 88084a3df1672e131ddc1b4e39eeacfd39864acf
change-id: 20220707-my-new-branch-1325e0e7fd1c

Best regards,
-- 
Konstantin Ryabitsev <konstantin@linuxfoundation.org>
