Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CA7D53A7;
	Fri,  6 Dec 2024 15:09:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497778; cv=none; b=gDl3yGa51CIYM6CZ82h8G8BiKt0ZA4JhpdeTW6u2wMdZ7fVxafVIRW1mMhF6cIVELMpO9Jwz3iVwmDJEd3CN8yPMut4k9mW/D4Kf8eS1mDCdLUvSLvLCDY7pz0u4jL463X50u+SKorqmYqdqq6G9Mmf40681nzbx0Fzk4ijqYD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497778; c=relaxed/simple;
	bh=8bdF//VF/Yqah0H58GsnbOgNrFZ3UFm2SlqMEGMvVuk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kAKnTjDHRvGnvNl/uTH0wPtevHBAXlzvhfxu1EmfHERFH5KgoW2DehzKfSiiOQesBrsZOsyCmWaGRvadYaMcr0H0NsMfbxjB57XRvzl6byUTiTwoso1TVHL7xflFtn5BQ74c6+53Tf/mso0COhrlF49s97DRKOKBsps1Pea3LGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C93lbj+n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C93lbj+n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AC31C4CEDC;
	Fri,  6 Dec 2024 15:09:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497778;
	bh=8bdF//VF/Yqah0H58GsnbOgNrFZ3UFm2SlqMEGMvVuk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C93lbj+nuJTzfIieo+kvkZWMM0BqbhIbtB2JBYotZ5HV5XpOxevAVIw3t/ItQdMC4
	 VduqdyWBMTIJtpwLlTzFFia4VQzBfOXZQjwpdAc7Wp9lmtQHKcx8gogisiBPMocEig
	 aHZznNiV17pFnVnzBN6w95jbUEsm3+dSFYYE//Uk=
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
Subject: [PATCH 6.6 391/676] fs_parser: update mount_api doc to match function signature
Date: Fri,  6 Dec 2024 15:33:30 +0100
Message-ID: <20241206143708.622883163@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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
index 9aaf6ef75eb53..0c69aa574ab9a 100644
--- a/Documentation/filesystems/mount_api.rst
+++ b/Documentation/filesystems/mount_api.rst
@@ -766,7 +766,8 @@ process the parameters it is given.
 
    * ::
 
-       bool fs_validate_description(const struct fs_parameter_description *desc);
+       bool fs_validate_description(const char *name,
+                                    const struct fs_parameter_description *desc);
 
      This performs some validation checks on a parameter description.  It
      returns true if the description is good and false if it is not.  It will
-- 
2.43.0



