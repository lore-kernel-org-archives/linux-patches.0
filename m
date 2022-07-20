Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 241434C9F
	for <patches@lists.linux.dev>; Wed, 20 Jul 2022 14:06:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B30B4C3411E
	for <patches@lists.linux.dev>; Wed, 20 Jul 2022 14:06:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1658326018;
	bh=DRYlifQjBt/hsn7jrznmehMlWt+o+IQDV+C9DtxwnOE=;
	h=Subject:From:Date:To:From;
	b=RzSxYdWdSC5jVXCTZLmbbaDfsgMHv96fZpmXXwGEBRXl3KHpvyCkGH9bpyZc2A5a4
	 5v3kbilsB0gStZn2YUe3ur2jZ1pUhExxDON1rpf9cH1aCJE+RkAuNvYtp1r4Gz+VLR
	 8+m236YkFuNDvW5UcSO0as/UUt2rHNjXjUz3KLTE=
Subject: [PATCH v1 0/2] Fake b4 ez-series submission
X-b4-tracking: H4sIAAEM2GIC/xXLMQ6DMAwF0Ksgz1gKqUpFb/MJhlhAkGzEgrh70/EN7yYXU3H6NjeZXOp6lIqubS
 hllEVYp2qKIcbwiYHTBt15PoxX5E3cecA84dW/hx6g+ka48GgoKf/nDj/F6Hl+vRsO0GwAAAA=
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
From: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Date: Wed, 20 Jul 2022 10:06:57 -0400
Message-Id: <20220720-claim-for-kahless-v1-0-f787d95bfb7a@linuxfoundation.org>
To: Linux Patches <patches@lists.linux.dev>
X-Mailer: b4 0.10.0-dev-45aaa
X-Developer-Signature: v=1; a=openpgp-sha256; l=585;
 i=konstantin@linuxfoundation.org; h=from:subject:message-id;
 bh=DRYlifQjBt/hsn7jrznmehMlWt+o+IQDV+C9DtxwnOE=;
 b=owGbwMvMwCW27YjM47CUmTmMp9WSGJJu8DAxKb+aXM23/0rds8QJAg/Z7pdkmJTe38foNOnQf6W/
 ew796yhlYRDjYpAVU2Qp2xe7KajwoYdceo8pzBxWJpAhDFycAjCRCc8Z/sr+W9pS/I7l0bmEULNf0e
 +MhUyvf2g2+ih34sqx477bHnMzMhx8sdI4s3SzBvtSbt+7Tdwlb88e6voTkPdafPa+w6eXafABAA==
X-Developer-Key: i=konstantin@linuxfoundation.org; a=openpgp;
 fpr=DE0E66E32F1FDD0902666B96E63EDCA9329DD07E

This is a fake patch series used to test b4 ez-series. Please ignore
everything about it.

Signed-off-by: Konstantin Ryabitsev <konstantin@linuxfoundation.org>

---
Konstantin Ryabitsev (2):
      Makefile: set appropriate release name
      MAINTAINERS: set Kahless as ultimate maintainer

 MAINTAINERS | 4 ++--
 Makefile    | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)
---
base-commit: 55ea9bd666887ed4159df38d1494c204246cf2bc
change-id: 20220720-claim-for-kahless-9afda36596aa

Best regards,
-- 
Konstantin Ryabitsev <konstantin@linuxfoundation.org>
