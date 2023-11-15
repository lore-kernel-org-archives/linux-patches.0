Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FEE52FB3
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:20:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UDrqbr8I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA12AC433C9;
	Wed, 15 Nov 2023 19:20:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700076033;
	bh=xHXjuu60BFQjn0VzFv3/X84qpP4DHjfz5tE3w5KbI5w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UDrqbr8ImZI5FNTBssYaF+YUt3cWnIBJCgwRsX9FTCf5BasgYbtlkOTWLMlYmrIx5
	 eBUSZo+Cm4C3MHVwUpRCYPMfqiJsMkUbyfhND/jG2TS/aoSJldR3loBrYcIVxUIB3J
	 16FYmPrhFI6ceuipG3RhRkTrPNEEdC7tD4DHUp9c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aaron Plattner <aplattner@nvidia.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 009/550] objtool: Propagate early errors
Date: Wed, 15 Nov 2023 14:09:53 -0500
Message-ID: <20231115191601.363945767@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191600.708733204@linuxfoundation.org>
References: <20231115191600.708733204@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aaron Plattner <aplattner@nvidia.com>

[ Upstream commit e959c279d391c10b35ce300fb4b0fe3b98e86bd2 ]

If objtool runs into a problem that causes it to exit early, the overall
tool still returns a status code of 0, which causes the build to
continue as if nothing went wrong.

Note this only affects early errors, as later errors are still ignored
by check().

Fixes: b51277eb9775 ("objtool: Ditch subcommands")
Signed-off-by: Aaron Plattner <aplattner@nvidia.com>
Link: https://lore.kernel.org/r/cb6a28832d24b2ebfafd26da9abb95f874c83045.1696355111.git.aplattner@nvidia.com
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/objtool/objtool.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/tools/objtool/objtool.c b/tools/objtool/objtool.c
index c54f7235c5d94..f40febdd6e36a 100644
--- a/tools/objtool/objtool.c
+++ b/tools/objtool/objtool.c
@@ -146,7 +146,5 @@ int main(int argc, const char **argv)
 	exec_cmd_init("objtool", UNUSED, UNUSED, UNUSED);
 	pager_init(UNUSED);
 
-	objtool_run(argc, argv);
-
-	return 0;
+	return objtool_run(argc, argv);
 }
-- 
2.42.0



