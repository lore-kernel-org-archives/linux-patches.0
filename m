Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D82BF146D40;
	Mon,  6 Jan 2025 15:23:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177008; cv=none; b=Ev2ex8TZ1L4bftETj/NIrAg4tw5e6E1NX5bDmArt+xcTUhjJ7GKyvbW/DC5rfTg3/zgibOT/9WQfNfyRVMylFR04uZZwzTRu8PYqk7TdZ6OuQNkGctPD4ctuW6HdQftXRgEgFM1ZyxmYhgrvocnJz9942hgeNxetaIOPVOoDNCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177008; c=relaxed/simple;
	bh=iR7a2qoIuVfaADOc3xPxXrvdizlkKfRrhBZy1foBNQk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S0sQ3OkAY8qCWPijuD0TZWSuQHIDfYD7od+Mtq+/W1Na6MTQU+cv6d/UF5p5lQNaM8XiKfHDvK8+1OLDdWPWJjRti4fzMu+rEcq8uFvbQDhgmDGEHrXkZd1EAMiFnSitJKc4s8uN3Z5Hmtth/GDMkNeG0GnyjTjUhIwk3SoohVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=STDIDKFR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="STDIDKFR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 584C8C4CEDF;
	Mon,  6 Jan 2025 15:23:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177008;
	bh=iR7a2qoIuVfaADOc3xPxXrvdizlkKfRrhBZy1foBNQk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=STDIDKFR541S+4cSveqHKhql7GH8U6p2FSkE8f1rDQcxQb7Rw1MLa/sWr+5XOcf1r
	 Tnfzljv4+GmH2Pld/lpMgAQlKig2CEW6WFxwb2n5gHaslYB+v3XrUZ2aeulZNmnqq2
	 iWES6mmslnLxLmf2AW0bMwLU2jEXznveIdwenqB8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 003/222] docs: media: update location of the media patches
Date: Mon,  6 Jan 2025 16:13:27 +0100
Message-ID: <20250106151150.723901375@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151150.585603565@linuxfoundation.org>
References: <20250106151150.585603565@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

[ Upstream commit 72ad4ff638047bbbdf3232178fea4bec1f429319 ]

Due to recent changes on the way we're maintaining media, the
location of the main tree was updated.

Change docs accordingly.

Cc: stable@vger.kernel.org
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Reviewed-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/admin-guide/media/building.rst | 2 +-
 Documentation/admin-guide/media/saa7134.rst  | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/admin-guide/media/building.rst b/Documentation/admin-guide/media/building.rst
index a06473429916..7a413ba07f93 100644
--- a/Documentation/admin-guide/media/building.rst
+++ b/Documentation/admin-guide/media/building.rst
@@ -15,7 +15,7 @@ Please notice, however, that, if:
 
 you should use the main media development tree ``master`` branch:
 
-    https://git.linuxtv.org/media_tree.git/
+    https://git.linuxtv.org/media.git/
 
 In this case, you may find some useful information at the
 `LinuxTv wiki pages <https://linuxtv.org/wiki>`_:
diff --git a/Documentation/admin-guide/media/saa7134.rst b/Documentation/admin-guide/media/saa7134.rst
index 51eae7eb5ab7..18d7cbc897db 100644
--- a/Documentation/admin-guide/media/saa7134.rst
+++ b/Documentation/admin-guide/media/saa7134.rst
@@ -67,7 +67,7 @@ Changes / Fixes
 Please mail to linux-media AT vger.kernel.org unified diffs against
 the linux media git tree:
 
-    https://git.linuxtv.org/media_tree.git/
+    https://git.linuxtv.org/media.git/
 
 This is done by committing a patch at a clone of the git tree and
 submitting the patch using ``git send-email``. Don't forget to
-- 
2.39.5



