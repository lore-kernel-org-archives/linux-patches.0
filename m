Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F52A944B
	for <patches@lists.linux.dev>; Fri, 23 Jun 2023 17:06:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB434C433C0;
	Fri, 23 Jun 2023 17:06:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687540016;
	bh=3jVQRBcKX65rdKTJ+cVgvkvbZNTdPu4xBYaCUAWB3C8=;
	h=From:Subject:Date:To:Cc:From;
	b=x0hEnmE/qyHIPyY0WvqmV1pTb9dA1GCz4uGdHJiYI2YT8HC6wmovr+MMJlZB473xu
	 OkBKWn1wG5YKVWUwYftiysSnRRZ1z/Y2B7NPseGt9Qdm0eRtcJyXF5namuFMKs12aY
	 q4IbXaI3DlnDuYRNLIQg5ywia0hFediouBhmarVE=
From: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Subject: [PATCH WIP v2 0/2] b4-test: test series to troubleshoot prefixes
Date: Fri, 23 Jun 2023 13:06:36 -0400
Message-Id: <20230623-test-resend-prefixes-v2-0-72becbfc3fb1@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIABzRlWQC/31OPQ+CMBT8K+TNPlMKgjq5urk5GIYKr/AS05q2E
 Azhv/tC4mpuurvcxwKRAlOEc7ZAoIkjeydE7zJoB+N6Qu6Eg1a6UJUuMFFMGCiS6/AdyPJMEU1
 Z1G1tn4IcJPozJPmA+/UGjYgDx+TDZ5ua8s363zrlqLC0dDLqUFl7bC8vduNs/eg6k+To3ocem
 nVdv90V/VvHAAAA
To: patches@lists.linux.dev
Cc: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
X-Mailer: b4 0.13-dev-87aac
X-Developer-Signature: v=1; a=openpgp-sha256; l=670;
 i=konstantin@linuxfoundation.org; h=from:subject:message-id;
 bh=3jVQRBcKX65rdKTJ+cVgvkvbZNTdPu4xBYaCUAWB3C8=;
 b=owGbwMvMwCW27YjM47CUmTmMp9WSGFKmXtQzT01qmn/l8la1///apkeJ1J6773zotajP4rnLT
 W9LX4pe11HKwiDGxSArpshSti92U1DhQw+59B5TmDmsTCBDGLg4BWAiL8wY/kfYxc4w9mFaL/bq
 bszORfE8e0PM/686wcwgc2VCTLllcA3D//BlmqGLrnU2K57MEWRZ01c8a+e1oEVfv9k+3qc6N/+
 2IyMA
X-Developer-Key: i=konstantin@linuxfoundation.org; a=openpgp;
 fpr=DE0E66E32F1FDD0902666B96E63EDCA9329DD07E

This is a bogus series used to test b4. Please ignore.

Signed-off-by: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
---
Changes in v2:
- No changes, ignore
- Link to v1: https://lore.kernel.org/r/20230623-test-resend-prefixes-v1-0-4fe9a056ff8c@linuxfoundation.org

---
Konstantin Ryabitsev (2):
      README: rename Linux to Lunix
      COPYING: rename Linux into Lunix

 COPYING | 2 +-
 README  | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)
---
base-commit: 45a3e24f65e90a047bef86f927ebdc4c710edaa1
change-id: 20230623-test-resend-prefixes-a437c7fbfbf1

Best regards,
-- 
Konstantin Ryabitsev <konstantin@linuxfoundation.org>

