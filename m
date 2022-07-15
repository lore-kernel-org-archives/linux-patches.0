Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B19494C7A
	for <patches@lists.linux.dev>; Fri, 15 Jul 2022 20:04:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48AC4C341C8
	for <patches@lists.linux.dev>; Fri, 15 Jul 2022 20:04:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1657915480;
	bh=ygAOzsuRszTxXX2uLOMN4xDmUKAf4thK5eL/NAMNP1s=;
	h=Subject:From:Date:To:From;
	b=IyZupOf0fF7+/pTJVO06G0CgFF88m8CxQDn/cwesGA1le9+FMbQHHHbtttrmRDpkG
	 3zGGmPg8Aggq2It/uIW4XHlXzx2HCpv05HbcK1EA0LdZVx+xuLegCquvZKftNN7Oah
	 sU3bf2bTPeYbzDw2bocE2++UnQ7HzaabxW93jPYI=
Subject: [PATCH v3 0/3] Fake series to test out b4 submit
From: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Date: Fri, 15 Jul 2022 16:04:39 -0400
Message-Id: <20220707-my-new-branch-v3-0-feb2652699b2@linuxfoundation.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1086;
 i=konstantin@linuxfoundation.org; h=from:subject:message-id;
 bh=ygAOzsuRszTxXX2uLOMN4xDmUKAf4thK5eL/NAMNP1s=;
 b=owGbwMvMwCW27YjM47CUmTmMp9WSGJIunoioMWT12ntku9DFO6suyq6K9enbeE3P/Mjkh/s+BvnO
 3F11rKOUhUGMi0FWTJGlbF/spqDChx5y6T2mMHNYmUCGMHBxCsBE7PUZGfZxs/Gu9vZi0713TrTK5A
 fPn4Jf5yqZaxlk6g58eaa66DTDP/WZ05/7r0p3m9zaf2SOQNCGRfdX7JxeMjeap4Htie5+Y1YA
X-Developer-Key: i=konstantin@linuxfoundation.org; a=openpgp;
 fpr=DE0E66E32F1FDD0902666B96E63EDCA9329DD07E

This is a fake series that I created to test b4 submit. It will be sent
to the patches list, but it's not a real set of patches. You can ignore
everything about it.

Signed-off-by: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Suggested-by: Sockpuppet Squirrel <mricon@gmail.com>

---
Changes in v3:
- Change the name to Kahlix
- Link to v2: https://lore.kernel.org/r/20220707-my-new-branch-v2-0-c378d618b16b@linuxfoundation.org

Changes in v2:
- Now claiming Linux specifically in the name of Kahless the Unforgettable
- Link to v1: https://lore.kernel.org/r/20220707-my-new-branch-v1-0-8d355bae1bb5@linuxfoundation.org

---
Konstantin Ryabitsev (3):
      Add myself as ultimate maintainer
      Our version goes to 11
      Rename Linux into Kahlix

 MAINTAINERS | 4 ++--
 Makefile    | 2 +-
 README      | 4 ++--
 3 files changed, 5 insertions(+), 5 deletions(-)
---
base-commit: 88084a3df1672e131ddc1b4e39eeacfd39864acf
change-id: 20220707-my-new-branch-1325e0e7fd1c

Best regards,
-- 
Konstantin Ryabitsev <konstantin@linuxfoundation.org>
