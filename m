Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 514268F74
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:10:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9561C433C8;
	Sun, 16 Jul 2023 20:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689538214;
	bh=5Xs0rP7IrtOLhUV4Wke7GmulTfWYdBbBkBkJ00NlK0M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q6NZ3TuUtvTQ7U8fRTh40L/P1coIzPd1ujCgY4Q28rtjsGsoG+RWwz2XKMBXcCppv
	 ozNz4FedYgR8KtUEwD3PvJzq8ZdhUu97Ebl+3KMPsOQOr2K7aaQVcbR7Tk0SgWkSNh
	 yC27VUQMcJtFs9ptfhrOGoJQys0Hk/KvAjoNRXzc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	David Gow <davidgow@google.com>,
	=?UTF-8?q?Jos=C3=A9=20Exp=C3=B3sito?= <jose.exposito89@gmail.com>,
	Jiri Kosina <jkosina@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 371/800] HID: uclogic: Modular KUnit tests should not depend on KUNIT=y
Date: Sun, 16 Jul 2023 21:43:44 +0200
Message-ID: <20230716194957.692816284@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 49904a0ebf23b15aad288a10f5354e7cd8193121 ]

While KUnit tests that cannot be built as a loadable module must depend
on "KUNIT=y", this is not true for modular tests, where it adds an
unnecessary limitation.

Fix this by relaxing the dependency to "KUNIT".

Fixes: 08809e482a1c44d9 ("HID: uclogic: KUnit best practices and naming conventions")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: David Gow <davidgow@google.com>
Reviewed-by: José Expósito <jose.exposito89@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
index 4ce012f83253e..b977450cac752 100644
--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -1285,7 +1285,7 @@ config HID_MCP2221
 
 config HID_KUNIT_TEST
 	tristate "KUnit tests for HID" if !KUNIT_ALL_TESTS
-	depends on KUNIT=y
+	depends on KUNIT
 	depends on HID_BATTERY_STRENGTH
 	depends on HID_UCLOGIC
 	default KUNIT_ALL_TESTS
-- 
2.39.2



