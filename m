Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0100C24B34;
	Mon, 14 Oct 2024 14:38:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916684; cv=none; b=fpyhzRhpcLfjMAmpOYiHq9FR3Xw71uaAsBZPg/1bYUv/ebInitoAKFR7zSXczL5d+0uFHwqsaXpTiE4xYZ6alcseSHhHXa4V3oV4+tivlwR2NqdY7V/xfK8Egdgyjkgex02HyjIlqT8NUrCtj/bi7fAkRpjpmyvN1b9PEUVg5vw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916684; c=relaxed/simple;
	bh=r8JzXsL5TF+2Ih6SNPOpY1FnH6hmbMO1R/API6ZKt5k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UI3v4tJBPVUTIKOfOcBwR5Iwr02Bo0PAwxNRsguG4GB3++Yjf8lIV2lgnLVFa35ytzgBfOWRiGB4mJj9WhtaYc/hZzzqPK5sq2pYxyJBb5uzoXXxCHWPAYeGGNHrnVz/jwaEOPeZ3VbyA1wwI/iz7qhOYwYh2XYDcompbREBd1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PCQ5Xj7B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PCQ5Xj7B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 252DBC4CEC3;
	Mon, 14 Oct 2024 14:38:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916683;
	bh=r8JzXsL5TF+2Ih6SNPOpY1FnH6hmbMO1R/API6ZKt5k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PCQ5Xj7B9icJbJI9hrV6O+9aaRJvwRvsNLcwNWggB+oyKpDAY/JnfmHTcIjcF8EGp
	 U36Vxw7BSFP6HkKn7IgKPTN+Okr7FG47rgV7f7p9StevZQ7byeSF82LUEKV80hUW9u
	 oGWmLtElJN860joiBjhM4vujgtLgAlqL3VS5zOTk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 035/213] bootconfig: Fix the kerneldoc of _xbc_exit()
Date: Mon, 14 Oct 2024 16:19:01 +0200
Message-ID: <20241014141044.360278967@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141042.954319779@linuxfoundation.org>
References: <20241014141042.954319779@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Masami Hiramatsu (Google) <mhiramat@kernel.org>

[ Upstream commit 298b871cd55a607037ac8af0011b9fdeb54c1e65 ]

Fix the kerneldoc of _xbc_exit() which is updated to have an @early
argument and the function name is changed.

Link: https://lore.kernel.org/all/171321744474.599864.13532445969528690358.stgit@devnote2/

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202404150036.kPJ3HEFA-lkp@intel.com/
Fixes: 89f9a1e876b5 ("bootconfig: use memblock_free_late to free xbc memory to buddy")
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/bootconfig.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/lib/bootconfig.c b/lib/bootconfig.c
index 8841554432d5b..97f8911ea339e 100644
--- a/lib/bootconfig.c
+++ b/lib/bootconfig.c
@@ -901,7 +901,8 @@ static int __init xbc_parse_tree(void)
 }
 
 /**
- * xbc_exit() - Clean up all parsed bootconfig
+ * _xbc_exit() - Clean up all parsed bootconfig
+ * @early: Set true if this is called before budy system is initialized.
  *
  * This clears all data structures of parsed bootconfig on memory.
  * If you need to reuse xbc_init() with new boot config, you can
-- 
2.43.0



