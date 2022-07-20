Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6304853A4
	for <patches@lists.linux.dev>; Wed, 20 Jul 2022 14:17:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E392AC3411E
	for <patches@lists.linux.dev>; Wed, 20 Jul 2022 14:17:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1658326655;
	bh=L80Oq4/CuK00S0bUL4Opbj0f3/9Y4DjAN9i+iIUUY10=;
	h=Subject:From:Date:To:From;
	b=Dz+A9C6Mnw70jyCj+kE6Bk9haE5rZK79KKeSGuTmPAta4rZ9AeVWHDBR3Rdvxatlj
	 3QReLBmm4+p7TkYGvoemIwZNs4CmU5lXfHDFGlDkQSPV4DghMFGnUkVlhwDcw24CVR
	 gPeKhnTjUdXDW7avfn/51i/V6W6DpIXbodAppHDQ=
Subject: [PATCH v2 0/3] Fake b4 ez-series submission
X-b4-tracking: H4sIAH0O2GIC/32OQQ6CMBREr0K69ptSAxVX3sO4+KW/tBHapB+IhnB3iwdwNZlM3sxsgikHYnGrNp
 FpDRxSLEadKtF7jANBsMULJZWSWknoRwwTuJThhX4kZujQWby0TdciisIZZAKTMfb+ICfkmfIR+MBz
 yp/f1loXefyrXWuQ4PRV264xzmi8jyEub5eWaHEuN88pD+K57/sXCf/BNsUAAAA=
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
From: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Date: Wed, 20 Jul 2022 10:17:33 -0400
Message-Id: <20220720-claim-for-kahless-v2-0-ddbde3dd27ea@linuxfoundation.org>
To: Linux Patches <patches@lists.linux.dev>
X-Mailer: b4 0.10.0-dev-45aaa
X-Developer-Signature: v=1; a=openpgp-sha256; l=837;
 i=konstantin@linuxfoundation.org; h=from:subject:message-id;
 bh=L80Oq4/CuK00S0bUL4Opbj0f3/9Y4DjAN9i+iIUUY10=;
 b=owGbwMvMwCW27YjM47CUmTmMp9WSGJJu8NX5MmhZyTc9FeDtOlERwyJVfzk/PzzBKX3THPUfjQVM
 bdM7SlkYxLgYZMUUWcr2xW4KKnzoIZfeYwozh5UJZAgDF6cATGSTNCPDqoMVoVy8u2c8XHY8Nbmq9O
 jWNs4GS64VEkprL/x1C3newchwfvL0lZPN2Vdoh0Y2XIkou3+4U3mF7Lz3Thbbf29vDVvOCgA=
X-Developer-Key: i=konstantin@linuxfoundation.org; a=openpgp;
 fpr=DE0E66E32F1FDD0902666B96E63EDCA9329DD07E

This is a fake patch series used to test b4 ez-series. Please ignore
everything about it.

Signed-off-by: Konstantin Ryabitsev <konstantin@linuxfoundation.org>

---
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
