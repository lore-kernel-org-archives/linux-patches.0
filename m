Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E35A38F5D
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:41:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 657ABC433C7;
	Sun, 16 Jul 2023 20:41:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689540098;
	bh=xlt2rCYQK8j9KdN5cAp7h4zDjdxEVsFvgl5MYrFHLEE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ap2M3EkvRaXfilNXZt3FMC8C4bLkMEufEfJZa3lHusA2yeQvd2NFVPv5uRqH/92Ne
	 6mXggMdkwYqNUwSCzde/z79yAanyk23wFe+YsxwD5AlCBDYRTWv/HzRGHPJMaWeTsR
	 m45WN6c47ZrekiwJ0WGQQLVA8kF2qwwEkVxZzfz0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	David Gow <davidgow@google.com>,
	=?UTF-8?q?Jos=C3=A9=20Exp=C3=B3sito?= <jose.exposito89@gmail.com>,
	Jiri Kosina <jkosina@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 242/591] HID: uclogic: Modular KUnit tests should not depend on KUNIT=y
Date: Sun, 16 Jul 2023 21:46:21 +0200
Message-ID: <20230716194930.129922991@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194923.861634455@linuxfoundation.org>
References: <20230716194923.861634455@linuxfoundation.org>
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
 drivers/hid/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -1262,7 +1262,7 @@ config HID_MCP2221
 
 config HID_KUNIT_TEST
 	tristate "KUnit tests for HID" if !KUNIT_ALL_TESTS
-	depends on KUNIT=y
+	depends on KUNIT
 	depends on HID_UCLOGIC
 	default KUNIT_ALL_TESTS
 	help


