Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78D4B6FA7
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:00:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1968C433C9;
	Sun, 17 Sep 2023 20:00:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694980855;
	bh=gwVcaf30Pfjogt0h9om2AC4GabOGeu71ECpEXmIirHk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UmMXqyezHGs4Q1MuebIlXnYzYlMIqnV928rdA0pdtvUuMIR0m62KccYWbqKwgDN4e
	 avOkD0Q06ZcjD9WLwWZrDtBVxNFgjWoRPig5efZMzdVaLTQQVZoPrvPl9zY0usGXbZ
	 WLffd6YX8NADtAXSUBv4+ZOplXZ8Qxozz7DbYhc8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Dave Airlie <airlied@redhat.com>,
	dri-devel@lists.freedesktop.org,
	Sui Jingfeng <suijingfeng@loongson.cn>,
	Jocelyn Falempe <jfalempe@redhat.com>
Subject: [PATCH 6.1 028/219] drm/ast: Fix DRAM init on AST2200
Date: Sun, 17 Sep 2023 21:12:35 +0200
Message-ID: <20230917191042.010511579@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191040.964416434@linuxfoundation.org>
References: <20230917191040.964416434@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Zimmermann <tzimmermann@suse.de>

commit 4cfe75f0f14f044dae66ad0e6eea812d038465d9 upstream.

Fix the test for the AST2200 in the DRAM initialization. The value
in ast->chip has to be compared against an enum constant instead of
a numerical value.

This bug got introduced when the driver was first imported into the
kernel.

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Fixes: 312fec1405dd ("drm: Initial KMS driver for AST (ASpeed Technologies) 2000 series (v2)")
Cc: Dave Airlie <airlied@redhat.com>
Cc: dri-devel@lists.freedesktop.org
Cc: <stable@vger.kernel.org> # v3.5+
Reviewed-by: Sui Jingfeng <suijingfeng@loongson.cn>
Reviewed-by: Jocelyn Falempe <jfalempe@redhat.com>
Tested-by: Jocelyn Falempe <jfalempe@redhat.com> # AST2600
Link: https://patchwork.freedesktop.org/patch/msgid/20230621130032.3568-2-tzimmermann@suse.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/ast/ast_post.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/ast/ast_post.c
+++ b/drivers/gpu/drm/ast/ast_post.c
@@ -291,7 +291,7 @@ static void ast_init_dram_reg(struct drm
 				;
 			} while (ast_read32(ast, 0x10100) != 0xa8);
 		} else {/* AST2100/1100 */
-			if (ast->chip == AST2100 || ast->chip == 2200)
+			if (ast->chip == AST2100 || ast->chip == AST2200)
 				dram_reg_info = ast2100_dram_table_data;
 			else
 				dram_reg_info = ast1100_dram_table_data;


