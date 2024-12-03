Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61B741EF0AE;
	Tue,  3 Dec 2024 15:21:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239277; cv=none; b=h2C4kFawvatghOOAti9q6/1rMeorCmrUAJO+8KDN6Ww8/1PiBHeZBWJh+Md2l4o80/FivN1yeS5rsUMAx068hKWH4b7CUGdH7nS+SbHg3V6b8/YDnE+GZatokIKH5SLyVNebY2UOakBChri3emyIuZdGANTSlZae5AGGCqZbRtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239277; c=relaxed/simple;
	bh=+Nq4My9g1vdyzSL1StkGEF63W3Q2D94lemKMk22LqOg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bzMk+PeIsSxVwy8ESkSXNSMpwDJk0t5dnSCv+/T5zVplNlK69mqOQci2x9tpftfjj7ecNRdXkh5rPJDasjIXYZaeE5RQfNmr5TcO4UXC5YG8jCmhncAs4AE3K29Vv656o547J4LSNXB0nsinaRP0f7EijR5tHaD2qQLi5SfdmEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SnOT8F7A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SnOT8F7A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9696CC4CECF;
	Tue,  3 Dec 2024 15:21:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239277;
	bh=+Nq4My9g1vdyzSL1StkGEF63W3Q2D94lemKMk22LqOg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SnOT8F7Aud95pFIoEo7AS3SlIZzeNN64Nc4L6ktcHtDhKduwiecgpVTHmAaG+Ocvh
	 t042K0zjSC1u1KrFX0sVQq0Y53Bwcqtv81KVyyOY7WMR8wp8UDjvHjyFn/lSVOezbA
	 AdvhMeIPMcUIhbE8N/f3eyYEd7xPAdypliegv1wQ=
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
Subject: [PATCH 6.11 559/817] fs_parser: update mount_api doc to match function signature
Date: Tue,  3 Dec 2024 15:42:11 +0100
Message-ID: <20241203144017.730779526@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 317934c9e8fca..d92c276f1575a 100644
--- a/Documentation/filesystems/mount_api.rst
+++ b/Documentation/filesystems/mount_api.rst
@@ -770,7 +770,8 @@ process the parameters it is given.
 
    * ::
 
-       bool fs_validate_description(const struct fs_parameter_description *desc);
+       bool fs_validate_description(const char *name,
+                                    const struct fs_parameter_description *desc);
 
      This performs some validation checks on a parameter description.  It
      returns true if the description is good and false if it is not.  It will
-- 
2.43.0



