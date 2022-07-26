Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B42C601C
	for <patches@lists.linux.dev>; Tue, 26 Jul 2022 20:24:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4AFEC433D6;
	Tue, 26 Jul 2022 20:24:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1658867068;
	bh=zXA7mR5EGlTaBGIDA6V0idHYqRgQ+DPPDRxZMKDL66c=;
	h=Subject:From:Date:To:Cc:From;
	b=B1PiFCelxwMoCuabdi2eeAttMS5WizKYYFES8zayDBpIMUtOq7rA6cKFRXkqSaPvQ
	 qBwDsZpUoV+jE9+W7aQa9Dr3qrylHTyqb+ATnE7uExPD8OZE9VVOk7nqENvS1iz26/
	 mk/qrVfKlxfypkjZHM1o7xQR8y/twu+4Z+SUg150=
Subject: [PATCH v2 0/4] Another completely fake submission
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
From: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Date: Tue, 26 Jul 2022 16:24:26 -0400
Message-Id: <20220726-claim-for-great-pumpkin-v2-0-a99ee69dec8e@linuxfoundation.org>
X-b4-tracking: H4sIAHxN4GIC/4WOzQrCMBCEX6Xk7EoSrC2efA/xsPlpu5huStIUpfTdDb6Ap2EGvpnZRfaJfBa3Zh
 fJb5QpcjX61Ag7IY8eyFUvtNRadvoKNiDNMMQEY/K4wlLm5UUMLUp0yqlLZ7yotMHswSRkO1WeSwg1
 nCivMX1+a5uq8vhfvCmQYA32fdsrlEbeA3F5D7Gww7XePcc0iudxHF+kbPLzzQAAAA==
To: Linux Patches <patches@lists.linux.dev>
Cc: Konstantin Ryabitsev <konstantin.ryabitsev@linux.dev>
X-Mailer: b4 0.10.0-dev-13c24
X-Developer-Signature: v=1; a=ed25519-sha256; t=1658867068; l=857;
 i=konstantin@linuxfoundation.org; s=20211109; h=from:subject:message-id;
 bh=zXA7mR5EGlTaBGIDA6V0idHYqRgQ+DPPDRxZMKDL66c=;
 b=5h5EdEASB34mzYUmQ3qDqpKU50yNuTEE/ExeUjTDWUbP+ToKlWp67Iv4csi6n0KMDMR9WNWDSO8d
 A0j2ZEjIDJvc3X3HMldSnQjQHZga0cB1h1tvY6PTLsooeStFrVfM
X-Developer-Key: i=konstantin@linuxfoundation.org; a=ed25519;
 pk=fAfUubVyx9rNeSbf8qETNADGwWcptn+Ur6Aaf++c4AY=

This is further work to test submissions. Please ignore everything about
this series.

Signed-off-by: Konstantin Ryabitsev <konstantin@linuxfoundation.org>

---
Changes in v2:
- Rebased on latest master
- Added MAINTAINERS
- Link to v1: https://lore.kernel.org/r/20220726-claim-for-great-pumpkin-v1-0-cba88581a0b0@linuxfoundation.org

---
Konstantin Ryabitsev (4):
      Rename into Pumpkix
      Makefile: Let's start our version at 200
      COPYING: tweak license
      MAINTAINERS: Add Great Pumpkin

 COPYING     | 2 +-
 MAINTAINERS | 2 +-
 Makefile    | 4 ++--
 README      | 4 ++--
 4 files changed, 6 insertions(+), 6 deletions(-)
---
base-commit: 5de64d44968e4ae66ebdb0a2d08b443f189d3651
change-id: 20220726-claim-for-great-pumpkin-5a0ad1d147be

Best regards,
-- 
Konstantin Ryabitsev <konstantin@linuxfoundation.org>
