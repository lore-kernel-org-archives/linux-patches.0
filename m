Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65F33601C
	for <patches@lists.linux.dev>; Tue, 26 Jul 2022 19:46:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5C4AC433D6;
	Tue, 26 Jul 2022 19:46:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1658864796;
	bh=O8eazX/75Zat+vyAEJh77iaaxubpSrYenBRI6CjjW4E=;
	h=Subject:From:Date:To:Cc:From;
	b=qUSo1PRmTF1pJYqgffCyBtp6/Cln1HQjdNV2ReKoN5+Jx5IWHzljUdOtsjOcx5J+H
	 7Hno0VR6Hjvo9s0joWr1nXKeQpAWj0d+u5dIcXmstEe1+JUF0LI3naWH6FkmpDkIZI
	 h0i6j+64+aKSf370y//oct3A04zBgGKFYu5vOzUE=
Subject: [PATCH v1 0/3] Another completely fake submission
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
From: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Date: Tue, 26 Jul 2022 15:46:26 -0400
Message-Id: <20220726-claim-for-great-pumpkin-v1-0-cba88581a0b0@linuxfoundation.org>
X-b4-tracking: H4sIAJtE4GIC/w3LQQqEMAwAwK9Izgbasirsb9I2q2FrlFS9iH+3xznMDZVNuMK3u8H4kiqbNvi+g7
 SQzoySmyG4ENwURkyFZMXfZjgb04H7ue5/URzIUfbZf6bI0HakyhiNNC3t61nK87y4dZSjbgAAAA==
To: Linux Patches <patches@lists.linux.dev>
Cc: Konstantin Ryabitsev <konstantin.ryabitsev@linux.dev>
X-Mailer: b4 0.10.0-dev-13c24
X-Developer-Signature: v=1; a=ed25519-sha256; t=1658864795; l=605;
 i=konstantin@linuxfoundation.org; s=20211109; h=from:subject:message-id;
 bh=O8eazX/75Zat+vyAEJh77iaaxubpSrYenBRI6CjjW4E=;
 b=+XgzT/XBiUk72HD/woVMKyfXjgetb8coLEzU7Gn3O7BOFm1MNGj3W1dLt+VdwI85//9dIDaXj5i+
 4xKS4ZMDCt21YaVIORtSyjengT51PVSxMA+VK1itiV4HgEkyEfLQ
X-Developer-Key: i=konstantin@linuxfoundation.org; a=ed25519;
 pk=fAfUubVyx9rNeSbf8qETNADGwWcptn+Ur6Aaf++c4AY=

This is further work to test submissions. Please ignore everything about
this series.

Signed-off-by: Konstantin Ryabitsev <konstantin@linuxfoundation.org>

---
Konstantin Ryabitsev (3):
      Rename into Pumpkix
      Makefile: Let's start our version at 200
      COPYING: tweak license

 COPYING  | 2 +-
 Makefile | 4 ++--
 README   | 4 ++--
 3 files changed, 5 insertions(+), 5 deletions(-)
---
base-commit: e0dccc3b76fb35bb257b4118367a883073d7390e
change-id: 20220726-claim-for-great-pumpkin-5a0ad1d147be

Best regards,
-- 
Konstantin Ryabitsev <konstantin@linuxfoundation.org>
