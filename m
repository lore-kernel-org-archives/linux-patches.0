Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33D371C2E
	for <patches@lists.linux.dev>; Thu, 25 Aug 2022 21:09:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DE08CC433C1
	for <patches@lists.linux.dev>; Thu, 25 Aug 2022 21:09:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1661461790;
	bh=Z8j/+jp4qFpGpKCK3gnIoOIhH9ThiA7LAT4TdrFysgc=;
	h=Subject:From:Date:To:From;
	b=PGB6Wl7ah5opOvIzzjV/C2b9UZi5ft+bwXNAcRyx7CLnrRDkeulbLO8pyqToR6Po9
	 hFn9KphTYHSYoVCv3dbO6sgPxcbNUzkAF2yKHnBRK7Cye2xnVwGSh6Dl75p6HN6ZQa
	 nfRqUaTzHWtdP4wKnRtMFYic0ssOhbrWERNeNamk=
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C359AECAAA2
	for <patches@lists.linux.dev>; Thu, 25 Aug 2022 21:09:50 +0000 (UTC)
Subject: [PATCH v1 0/4] Completely fake series
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
From: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Date: Thu, 25 Aug 2022 17:09:16 -0400
Message-Id: <20220825-test-endpoint-send-2-v1-0-e732ebcaa48a@linuxfoundation.org>
X-b4-tracking: H4sIAB3lB2MC/w3LSwqEQAwA0atI1gbaDIJ6m/5EDUiUTutGvPtkV29RLxhXYYOle6HyIyanOoa+g7
 xH3RiluIECUZhoxMbWkLVcp2hD80LCPNNv5TyEEhL4mqIxpho17z7rfRzf9wf+ImWBawAAAA==
To: patches@lists.linux.dev
X-Mailer: b4 0.10.0-dev-65ba7
X-Developer-Signature: v=1; a=openpgp-sha256; l=955;
 i=konstantin@linuxfoundation.org; h=from:subject:message-id;
 bh=Z8j/+jp4qFpGpKCK3gnIoOIhH9ThiA7LAT4TdrFysgc=;
 b=owGbwMvMwCW27YjM47CUmTmMp9WSGJLZn8oanH7ye4fDvcXMr9/WMO0Q6V1woM3gK8M8f6HFqasO
 a0+72VHKwiDGxSArpshSti92U1DhQw+59B5TmDmsTCBDGLg4BWAib0QY/vv5Wm/0as2ef2ye5HZZVz
 8FH1l3+7eil3sLXm1qK32XeJ7hf1mTXVXxHXG+Qw/4dk90yLG9bO7p733D+/Ka/rDG6VdsuAA=
X-Developer-Key: i=konstantin@linuxfoundation.org; a=openpgp;
 fpr=DE0E66E32F1FDD0902666B96E63EDCA9329DD07E
X-Endpoint-Received: by B4 Submission Endpoint with auth_id=1

Another completely fake series to test b4 endpoint sending. Please
ignore it -- it's a random set of patches that exists elsewhere.

Signed-off-by: Konstantin Ryabitsev <konstantin@linuxfoundation.org>

---
Clément Péron (4):
      arm64: defconfig: Enable devfreq cooling device
      arm64: dts: allwinner: h6: Add cooling map for GPU
      arm64: dts: allwinner: h6: Add GPU OPP table
      arm64: dts: allwinner: beelink-gs1: Enable GPU OPP

 .../boot/dts/allwinner/sun50i-h6-beelink-gs1.dts   |  2 +
 .../boot/dts/allwinner/sun50i-h6-gpu-opp.dtsi      | 88 ++++++++++++++++++++++
 arch/arm64/boot/dts/allwinner/sun50i-h6.dtsi       | 22 ++++++
 arch/arm64/configs/defconfig                       |  1 +
 4 files changed, 113 insertions(+)
---
base-commit: 4c2d0b039c5cc0112206a5b22431b577cb1c57ad
change-id: 20220825-test-endpoint-send-2-c923fec10d0b

Best regards,
-- 
Konstantin Ryabitsev <konstantin@linuxfoundation.org>

