Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 212041F7561;
	Tue,  3 Dec 2024 16:05:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241913; cv=none; b=mCtV6SvgmapmcFormh0Y2RLQGc/NhqSXofQ91gtHlkuqBPWCe4GgcTN+IMUf3+Z2szmPeb3nw4bjjFO+eoKeh2b7cGB/LuE+gLmUMbAbDLvGwXVNS7bHXZzbvwtfmw6pzXebZd+qX0mNs+AYHhHmAmIo9I5DLEhmNFCkBGcoHNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241913; c=relaxed/simple;
	bh=7XprV/rrMyfHr241w1qxgloDuDmF60WOeqsi4Keax4A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bc9IzRMC3qf18yvL7S2Eb4ibt/QkfIEQF9+/vuuMw02VSpDDKfS2Eycd1RmnN1nAQFBzILGA2oDvQtYETb2TA+Rz9ttYYNgf40O5RKjGOFgoU2lYCk2mLFc/sAVxT2rlXJi1WH/okts+kd8dKN7cWCZ4hGXKVUPdMdpP6U2cyTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Oa5UJNXs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Oa5UJNXs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 300D6C4CECF;
	Tue,  3 Dec 2024 16:05:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241912;
	bh=7XprV/rrMyfHr241w1qxgloDuDmF60WOeqsi4Keax4A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Oa5UJNXsV4y2q4j0uxtUpx3ow5ScTs/DADLv6QeNbe32Df4rOVc0a77soaIO26nxD
	 ciQo2EZt2kowTjq6vgdr9BDfBf/u6SYglMhX5xdTjkDcWQogjqwuIu42fCyxOlQpdy
	 U0e024YZf0d7QfgjSMF8xj1lgLaamzy+FytvbzQ8=
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
Subject: [PATCH 6.12 545/826] fs_parser: update mount_api doc to match function signature
Date: Tue,  3 Dec 2024 15:44:32 +0100
Message-ID: <20241203144805.011517326@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



