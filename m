Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A09261C03
	for <patches@lists.linux.dev>; Mon, 20 Mar 2023 15:07:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F666C433D2;
	Mon, 20 Mar 2023 15:07:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1679324862;
	bh=ZAgb/6V3ACNcOb3sVRCoPawyy1OrTkuX8D08bahj+xY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oEFG1m5M1WvVrorP81wn3iAVa0roD5h3Jw6pw3aovXBiQChcXNmQOOSKUKOyWQGgi
	 Gw5m3hUpTnM2VF1iRGaCptl4MhTTZqJd9grayqBnGk+fG2h0Tc18G1jAZrMuQhQol6
	 BJZZPUuvUD5NKNq8T/4gm0WHX9UhaPXyU/w+A1y0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Glenn Washburn <development@efficientek.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 014/198] docs: Correct missing "d_" prefix for dentry_operations member d_weak_revalidate
Date: Mon, 20 Mar 2023 15:52:32 +0100
Message-Id: <20230320145508.085030505@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145507.420176832@linuxfoundation.org>
References: <20230320145507.420176832@linuxfoundation.org>
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
index 2b55f71e2ae19..b5e8b8af8afbb 100644
--- a/Documentation/filesystems/vfs.rst
+++ b/Documentation/filesystems/vfs.rst
@@ -1221,7 +1221,7 @@ defined:
 	return
 	-ECHILD and it will be called again in ref-walk mode.
 
-``_weak_revalidate``
+``d_weak_revalidate``
 	called when the VFS needs to revalidate a "jumped" dentry.  This
 	is called when a path-walk ends at dentry that was not acquired
 	by doing a lookup in the parent directory.  This includes "/",
-- 
2.39.2



