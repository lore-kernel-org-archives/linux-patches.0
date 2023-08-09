Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 838B811C98
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 11:14:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06309C433C9;
	Wed,  9 Aug 2023 11:14:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691579666;
	bh=SJRLfXNX5xD4yBI2WxsBEywwWlMAQkRWlzL6ARqtnBU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ukM77xwpFZSEhJ6FCGq+2ctGr/N5a55h16/DuJjQ1bYVEF8m3ZqBfhvLyi2oiWhCE
	 muLj9zmEqwgf1pNsBVkbxazwbal4cX695a4b6CbV2j4fTM8ShUPxmvUDXt9+SacrPp
	 bviarg321n/n22Aw7pl6/G4E/JMmsuhwtIEDlYSg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 044/323] memstick r592: make memstick_debug_get_tpc_name() static
Date: Wed,  9 Aug 2023 12:38:02 +0200
Message-ID: <20230809103700.145518000@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103658.104386911@linuxfoundation.org>
References: <20230809103658.104386911@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 434587df9f7fd68575f99a889cc5f2efc2eaee5e ]

There are no other files referencing this function, apparently
it was left global to avoid an 'unused function' warning when
the only caller is left out. With a 'W=1' build, it causes
a 'missing prototype' warning though:

drivers/memstick/host/r592.c:47:13: error: no previous prototype for 'memstick_debug_get_tpc_name' [-Werror=missing-prototypes]

Annotate the function as 'static __maybe_unused' to avoid both
problems.

Fixes: 926341250102 ("memstick: add driver for Ricoh R5C592 card reader")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Link: https://lore.kernel.org/r/20230516202714.560929-1-arnd@kernel.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/memstick/host/r592.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/memstick/host/r592.c b/drivers/memstick/host/r592.c
index edb1b5588b7a0..6360f5c6d3958 100644
--- a/drivers/memstick/host/r592.c
+++ b/drivers/memstick/host/r592.c
@@ -47,12 +47,10 @@ static const char *tpc_names[] = {
  * memstick_debug_get_tpc_name - debug helper that returns string for
  * a TPC number
  */
-const char *memstick_debug_get_tpc_name(int tpc)
+static __maybe_unused const char *memstick_debug_get_tpc_name(int tpc)
 {
 	return tpc_names[tpc-1];
 }
-EXPORT_SYMBOL(memstick_debug_get_tpc_name);
-
 
 /* Read a register*/
 static inline u32 r592_read_reg(struct r592_device *dev, int address)
-- 
2.39.2



