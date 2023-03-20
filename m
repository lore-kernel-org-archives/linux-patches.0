Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9B511C03
	for <patches@lists.linux.dev>; Mon, 20 Mar 2023 15:13:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2906FC433D2;
	Mon, 20 Mar 2023 15:13:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1679325191;
	bh=PE5s1Fo+Q2JjH/l2rPGwlQObIGxSqZFvr8EUgKzEocw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JcUEfbX1JEvFgnG1SlViyniV6Gjok8bn+rEQGYBLEqaJXyzDzsgh+nPjA7+UkcWyN
	 s0f8j42HSpC82ejL6abX1apGxJ/gJfO/aO3lZXFcyCatw697KIEhMcnDnStW7hM4PQ
	 3ujQXd4uizrwDsfgPvgqqzME64uMURROgiAa9l3c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Glenn Washburn <development@efficientek.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 015/211] docs: Correct missing "d_" prefix for dentry_operations member d_weak_revalidate
Date: Mon, 20 Mar 2023 15:52:30 +0100
Message-Id: <20230320145513.929373311@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145513.305686421@linuxfoundation.org>
References: <20230320145513.305686421@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Glenn Washburn <development@efficientek.com>

[ Upstream commit 74596085796fae0cfce3e42ee46bf4f8acbdac55 ]

The details for struct dentry_operations member d_weak_revalidate is
missing a "d_" prefix.

Fixes: af96c1e304f7 ("docs: filesystems: vfs: Convert vfs.txt to RST")
Signed-off-by: Glenn Washburn <development@efficientek.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Link: https://lore.kernel.org/r/20230227184042.2375235-1-development@efficientek.com
Signed-off-by: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/filesystems/vfs.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/filesystems/vfs.rst b/Documentation/filesystems/vfs.rst
index 2c15e70531137..2f54e725bd743 100644
--- a/Documentation/filesystems/vfs.rst
+++ b/Documentation/filesystems/vfs.rst
@@ -1222,7 +1222,7 @@ defined:
 	return
 	-ECHILD and it will be called again in ref-walk mode.
 
-``_weak_revalidate``
+``d_weak_revalidate``
 	called when the VFS needs to revalidate a "jumped" dentry.  This
 	is called when a path-walk ends at dentry that was not acquired
 	by doing a lookup in the parent directory.  This includes "/",
-- 
2.39.2



