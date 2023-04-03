Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE5F85683
	for <patches@lists.linux.dev>; Mon,  3 Apr 2023 14:15:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35FF1C4339C;
	Mon,  3 Apr 2023 14:15:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680531344;
	bh=elm+YIuYB1h0vRw9Tw6xtnf3/u3yo11apVUZqf9lJVY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eOJb0siH1P7OOdxmxTFG5r7sDwqPsAfkWGNh1NzZjMGXGFEQPLaxjs0UwhYfq7lh1
	 NNKR/g2KL6ypCTqcvrjeBzMclrZfoAVERWJ/KDtLe49yDogdHqbjXMgADQSNj9wmAv
	 VTVr14T2c64yoJBLlWDZG8SE5Kjph932y25V0Wc0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sanju Mehta <Sanju.Mehta@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 4.19 27/84] thunderbolt: Use const qualifier for `ring_interrupt_index`
Date: Mon,  3 Apr 2023 16:08:28 +0200
Message-Id: <20230403140354.298984248@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140353.406927418@linuxfoundation.org>
References: <20230403140353.406927418@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mario Limonciello <mario.limonciello@amd.com>

commit 1716efdb07938bd6510e1127d02012799112c433 upstream.

`ring_interrupt_index` doesn't change the data for `ring` so mark it as
const. This is needed by the following patch that disables interrupt
auto clear for rings.

Cc: Sanju Mehta <Sanju.Mehta@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thunderbolt/nhi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/thunderbolt/nhi.c
+++ b/drivers/thunderbolt/nhi.c
@@ -38,7 +38,7 @@
 
 #define NHI_MAILBOX_TIMEOUT	500 /* ms */
 
-static int ring_interrupt_index(struct tb_ring *ring)
+static int ring_interrupt_index(const struct tb_ring *ring)
 {
 	int bit = ring->hop;
 	if (!ring->is_tx)


