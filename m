Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73916522E
	for <patches@lists.linux.dev>; Sun,  9 Jul 2023 11:21:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA28DC433C7;
	Sun,  9 Jul 2023 11:21:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1688901709;
	bh=rvKtnN98+cSQHDuLVFywgMt/5YiKKt0Jw0+1rq4baBc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R//zaFrcrzHfyFvfwNGqMaaymBWGRAH50/g2dwaIRvBXpwFx1DfdGHGXQH+TOpdMC
	 gF3o5kHQTU6rWf1b/+lL5R52qo1xP9wEIQjF99h13oXNwOZrM3LgXsBEZqwmy1mgg3
	 nxVWeAVVeQa2sPEV6ssaFZDYExl6XfuGBFj0KX4A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 116/431] memstick r592: make memstick_debug_get_tpc_name() static
Date: Sun,  9 Jul 2023 13:11:04 +0200
Message-ID: <20230709111453.874246528@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230709111451.101012554@linuxfoundation.org>
References: <20230709111451.101012554@linuxfoundation.org>
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
index 42bfc46842b82..461f5ffd02bc1 100644
--- a/drivers/memstick/host/r592.c
+++ b/drivers/memstick/host/r592.c
@@ -44,12 +44,10 @@ static const char *tpc_names[] = {
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



