Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A85641E4B1;
	Tue, 14 May 2024 11:40:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686836; cv=none; b=aC+qf7/q9t/Xvin2Mqdm+5o5efPB7eExWgosgiRoPQNMxi7HVvyjutMICVqcGkQfonZdJwDx6a9h8su9RjBluN3h16bcpsRJth4DfxowwYJx1MxBYyqphTzBmjvjMCO3YBAIhTWFbPKbZTHKyK+hXpWlAYzZoS2wO3IggHnfpG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686836; c=relaxed/simple;
	bh=bBhKPD6P9dae+yAPNzUv3sYX/YpO2mKQ2OWyA8/KMDQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e/zAJz2bTP1zjdOIselEUDQYdafPpzrp7jWjFFqIY14fd1xckT4zQAAL9dHYe82BW9f5vRfVTnfvnWXIZ39qulvXfrzelaf2vj9V1QkRzQVuM3/Rb4z/frjjfSWb8KKuAR7v/kmadwBOeDQygMA1RIPAExIal+C5mRgfQbbkCbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uGlthSpo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uGlthSpo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DA76C2BD10;
	Tue, 14 May 2024 11:40:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686836;
	bh=bBhKPD6P9dae+yAPNzUv3sYX/YpO2mKQ2OWyA8/KMDQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uGlthSpoD1u/B636rmgqOGTnSeOjloXpYLBDSR23rOLI2wv8yDMRxRT0RbOa8vtG0
	 E/AF6aLscJ9gSWY2neK/E/Qa9ehY/hzcIH3x/KbP5nED0qoJTuA1yRjiCO7BUGM2sX
	 7qpiwfvC8Q5AsupHtv5zhxSboyOCXjBc2HAheGJE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joakim Sindholt <opensource@zhasha.com>,
	Eric Van Hensbergen <ericvh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 38/63] fs/9p: translate O_TRUNC into OTRUNC
Date: Tue, 14 May 2024 12:19:59 +0200
Message-ID: <20240514100949.452226487@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514100948.010148088@linuxfoundation.org>
References: <20240514100948.010148088@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joakim Sindholt <opensource@zhasha.com>

[ Upstream commit 87de39e70503e04ddb58965520b15eb9efa7eef3 ]

This one hits both 9P2000 and .u as it appears v9fs has never translated
the O_TRUNC flag.

Signed-off-by: Joakim Sindholt <opensource@zhasha.com>
Signed-off-by: Eric Van Hensbergen <ericvh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/9p/vfs_inode.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
index d1a0f36dcdd43..ea32af83729d9 100644
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -192,6 +192,9 @@ int v9fs_uflags2omode(int uflags, int extended)
 		break;
 	}
 
+	if (uflags & O_TRUNC)
+		ret |= P9_OTRUNC;
+
 	if (extended) {
 		if (uflags & O_EXCL)
 			ret |= P9_OEXCL;
-- 
2.43.0



