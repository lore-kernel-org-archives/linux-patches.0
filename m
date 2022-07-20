Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B89D6AA0
	for <patches@lists.linux.dev>; Wed, 20 Jul 2022 17:57:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D12C1C3411E
	for <patches@lists.linux.dev>; Wed, 20 Jul 2022 17:57:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1658339821;
	bh=0qN2RibB32ql9tQL4Hz6RYTpjllqWzGIgc5Zrdxp5js=;
	h=Subject:From:Date:To:From;
	b=NYTrygaov76L1eNMymXNuXqdQGVXX3EQRizdIF6NAsWBkvE6GaiRffyiP4lvhouSb
	 xsP7Z801CHS81A16B6Ekoyji04TVA5BqQckbCbeoF9AXQWrQVlJKfuzjbyOD6lqNXB
	 VhBPDxzWnW5JM97AjnCa6zNAxoxY/x+8MPuOo7/w=
Subject: [PATCH v3 0/3] Fake b4 ez-series submission
X-b4-tracking: H4sIAOtB2GIC/4XOwQ7CIAwG4FdZOItBlg3nyfcwHspaBnGDBDaiWfbuMu/qqfnT/F+7skTRUWKXam
 WRsksu+BLqQ8V6C34g7rBkJoWUQknB+xHcxE2I/AF2pJR4BwahbpuuBWClpyER1xF8b/fmBGmmuC+s
 S3OIr8+tfCrj9ovNJy64UWeFXaONVnAdnV+eJiweYS5vHkMc2L24Wf61ZLEQNVKNKBV9sbZtewPTkW VEEQEAAA==
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
From: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Date: Wed, 20 Jul 2022 13:56:59 -0400
Message-Id: <20220720-claim-for-kahless-v3-0-7874906a7515@linuxfoundation.org>
To: Linux Patches <patches@lists.linux.dev>
X-Mailer: b4 0.10.0-dev-e2b6f
X-Developer-Signature: v=1; a=openpgp-sha256; l=992;
 i=konstantin@linuxfoundation.org; h=from:subject:message-id;
 bh=0qN2RibB32ql9tQL4Hz6RYTpjllqWzGIgc5Zrdxp5js=;
 b=owGbwMvMwCW27YjM47CUmTmMp9WSGJJuOL7Zd+jxIeUamXyFs+8UluT5262pq3piXcGfXRD688ri
 eTUvO0pZGMS4GGTFFFnK9sVuCip86CGX3mMKM4eVCWQIAxenAEzEoJiRYVvokjc1xzu+RM3p2/NvH2
 OMcKM+92LffnHH0K8v45vq6hj+2W9/1LXQ9TejT/iSpbvXv3/ac21rSNquoNpMq9LMZr6fDAA=
X-Developer-Key: i=konstantin@linuxfoundation.org; a=openpgp;
 fpr=DE0E66E32F1FDD0902666B96E63EDCA9329DD07E

This is a fake patch series used to test b4 ez-series. Please ignore
everything about it.

Signed-off-by: Konstantin Ryabitsev <konstantin@linuxfoundation.org>

---
Changes in v3:
- Update with latest trailers
- Link to v2: https://lore.kernel.org/r/20220720-claim-for-kahless-v2-0-ddbde3dd27ea@linuxfoundation.org

Changes in v2:
- Updated with latest trailers
- Changed name in the README
- Link to v1: https://lore.kernel.org/r/20220720-claim-for-kahless-v1-0-f787d95bfb7a@linuxfoundation.org

---
Konstantin Ryabitsev (3):
      Makefile: set appropriate release name
      MAINTAINERS: set Kahless as ultimate maintainer
      README: rename Linux to Kahlux

 MAINTAINERS | 4 ++--
 Makefile    | 2 +-
 README      | 4 ++--
 3 files changed, 5 insertions(+), 5 deletions(-)
---
base-commit: 80e19f34c2887a8881084b7bb7480e9544d56b91
change-id: 20220720-claim-for-kahless-9afda36596aa

Best regards,
-- 
Konstantin Ryabitsev <konstantin@linuxfoundation.org>
