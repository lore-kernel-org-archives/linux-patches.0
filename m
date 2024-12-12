Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7783222D66;
	Thu, 12 Dec 2024 16:09:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734019789; cv=none; b=PJDtKlleR2d/yhqq0Kh8TFpvUpbK2JbmROBEFfEtHruYVv2k/ddJf0ocmjoNpZ1qjxM2vJx6uMJ50cwb57AcpT/I34nIDfEL4L0a00vUtE/56URVtVl+Em1fzAqw80Ee3r8wIoiIXtySkxtFW6LYCAlPrZeOd9ykOOEDDI/fP2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734019789; c=relaxed/simple;
	bh=fDqRjijaz456aYbVWyHZZ1MmjXa+B8kxqfFtvHyPU5I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bBKEujqtLyUc6SH0YHjisDIJMW9lcmB0jbkBKYGsINYiWjcNvkbAjYPRtkvN+bzywjuThPJQXe7LrAracS/EGITyCR0RofiVvXSNqN7yrTqiEzOKT1ajrIuWiaaiyzpyC+PvIMjgnB480OnkXZloWIKjZOU0HiHCM7ZOz/b1jto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=biAPHzCF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="biAPHzCF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F406C4CECE;
	Thu, 12 Dec 2024 16:09:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734019789;
	bh=fDqRjijaz456aYbVWyHZZ1MmjXa+B8kxqfFtvHyPU5I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=biAPHzCF337IdwWWv4IXDCn7vfaG68B4RnyiZU07Kap/QSe9H0wTrmNISGViLxQ1y
	 kMw7Ot1Xe8hl3FR3xc4ePz4kgwJxy05YqJQSzCnw35xCexhGvWd9VOdb91dPOl+4Xb
	 p/AtQG7APnFzn/qYaV9uP6smpJT8WViplAkmdPew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	Eric Sandeen <sandeen@redhat.com>,
	David Howells <dhowells@redhat.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Jonathan Corbet <corbet@lwn.net>,
	linux-doc@vger.kernel.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 299/772] fs_parser: update mount_api doc to match function signature
Date: Thu, 12 Dec 2024 15:54:04 +0100
Message-ID: <20241212144402.255957403@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit c66f759832a83cb273ba5a55c66dcc99384efa74 ]

Add the missing 'name' parameter to the mount_api documentation for
fs_validate_description().

Fixes: 96cafb9ccb15 ("fs_parser: remove fs_parameter_description name field")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Link: https://lore.kernel.org/r/20241125215021.231758-1-rdunlap@infradead.org
Cc: Eric Sandeen <sandeen@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: linux-doc@vger.kernel.org
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/filesystems/mount_api.rst | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/Documentation/filesystems/mount_api.rst b/Documentation/filesystems/mount_api.rst
index 1d16787a00e95..253078b997990 100644
--- a/Documentation/filesystems/mount_api.rst
+++ b/Documentation/filesystems/mount_api.rst
@@ -778,7 +778,8 @@ process the parameters it is given.
 
    * ::
 
-       bool fs_validate_description(const struct fs_parameter_description *desc);
+       bool fs_validate_description(const char *name,
+                                    const struct fs_parameter_description *desc);
 
      This performs some validation checks on a parameter description.  It
      returns true if the description is good and false if it is not.  It will
-- 
2.43.0



