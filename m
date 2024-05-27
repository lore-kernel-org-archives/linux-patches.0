Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE0EA15FCF0;
	Mon, 27 May 2024 19:37:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716838648; cv=none; b=HeLR/yE5q/s+U+u5t44oa/+zGmyP8z1/bc/uap8ebN0ckccrfgY1o+cVr86gGAGUWdrAAoXZuav1Kf70CubwSg6Y2sgU5ZGbRaGMYCszEYYeQSv7Xj2mH3rUzOzYXEpX0FD2Os5p7XikE8EqGzDmlGvWTn8ZwzJTE6Ca40XE0j8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716838648; c=relaxed/simple;
	bh=89FeXCuC7W5ClLjKxzTxUGZxeZ/0ycraZpGEjiwx5RI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rhRZge5bTzC8gMjtMGc0SDeWg4oMkT5xoDRszg3+jzzoSm/KyQFCqmnjoNXjOoRVDLOgIlhXD4JwELaCux+rE+4on0yPJ3dmtSNC8VsbMz0sgl+3USzSIF/1SLc2Sii+SFhVCEI6lTbmkpmjbRJNPb1TMP1gx5azN2z3x8JqUk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u22vZ22n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u22vZ22n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 552A1C2BBFC;
	Mon, 27 May 2024 19:37:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716838648;
	bh=89FeXCuC7W5ClLjKxzTxUGZxeZ/0ycraZpGEjiwx5RI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u22vZ22nOeektUkr72Hwu3rnlCkI3WvC3R/Zgi2dtsbsswgkZNvvUBe91yuAeV4oA
	 9ZkyM4QtZ2auPuIK3MqyzbYytolBu3EJXWv+vh+DcTK6guBes3Sb1Fc+LReULbvNLI
	 fwQwmJu2Ax2rQtLX7IREVndgVKyx4gZnSWXC/n1c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang Yao <wangyao@lemote.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 473/493] modules: Drop the .export_symbol section from the final modules
Date: Mon, 27 May 2024 20:57:55 +0200
Message-ID: <20240527185645.627134892@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wang Yao <wangyao@lemote.com>

[ Upstream commit 8fe51b45c5645c259f759479c374648e9dfeaa03 ]

Commit ddb5cdbafaaa ("kbuild: generate KSYMTAB entries by modpost")
forget drop the .export_symbol section from the final modules.

Fixes: ddb5cdbafaaa ("kbuild: generate KSYMTAB entries by modpost")
Signed-off-by: Wang Yao <wangyao@lemote.com>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/module.lds.S | 1 +
 1 file changed, 1 insertion(+)

diff --git a/scripts/module.lds.S b/scripts/module.lds.S
index bf5bcf2836d81..89ff01a22634f 100644
--- a/scripts/module.lds.S
+++ b/scripts/module.lds.S
@@ -13,6 +13,7 @@ SECTIONS {
 	/DISCARD/ : {
 		*(.discard)
 		*(.discard.*)
+		*(.export_symbol)
 	}
 
 	__ksymtab		0 : { *(SORT(___ksymtab+*)) }
-- 
2.43.0



