Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE3826EB56;
	Thu, 13 Jun 2024 12:29:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281784; cv=none; b=nZWscdHAF7XJQIORb2C9kDIVPEFSytzOmBQE9QVjlhjHCo8q7jbpQXluzSx3Rhdb0aHBN8xPMja4ZSW2SaDJWCP+blTGCosw4PFyzfWhWNCiwmEf4Ht2AYMta64Jsy732tnzp9NjCW6gW2so3+T2F6KrOZNc2AxpTYm0nq6Xvrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281784; c=relaxed/simple;
	bh=qev2aEd5sfKvuCoTa2I+xdkSfVyHsF0H8nGJUpw/QUI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VQxStCdng4dYpQ/yZKF/SQ5NyNt8QcsMq+LdyXpcfZ6AqLhfbAovqWPzjp959wbUcTQVsL/eB3BzF4Enj+U5CN0JgaWWYAMDUhqjeEoA31r4QvfO13OKBoMt+xp/bhiQk0WvCi1to3kiyh2YNY5fjjPACmWaJfF+xdZtTppbNgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FM3XX20n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FM3XX20n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B85EC32786;
	Thu, 13 Jun 2024 12:29:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281783;
	bh=qev2aEd5sfKvuCoTa2I+xdkSfVyHsF0H8nGJUpw/QUI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FM3XX20nL4wgqs5+UCsdmXdKZWFDNPpNByIHCmpdSDSMXchmwoSryksEsN59E9Z57
	 4mNJ5bX4xxTu03eHFiKthJF62VuOR6EDM4Clyx+xpfVN0FiKCzSa2L05r+GpukbLj9
	 o3rPN8VuctAmZ0cHV0fpmNMevjnJksNMQc/eqZpc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Subject: [PATCH 5.15 013/402] fs/ntfs3: Remove max link count info display during driver init
Date: Thu, 13 Jun 2024 13:29:30 +0200
Message-ID: <20240613113302.655167464@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

commit a8948b5450e7c65a3a34ebf4ccfcebc19335d4fb upstream.

Removes the output of this purely informational message from the
kernel buffer:

	"ntfs3: Max link count 4000"

Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ntfs3/super.c |    2 --
 1 file changed, 2 deletions(-)

--- a/fs/ntfs3/super.c
+++ b/fs/ntfs3/super.c
@@ -1448,8 +1448,6 @@ static int __init init_ntfs_fs(void)
 {
 	int err;
 
-	pr_info("ntfs3: Max link count %u\n", NTFS_LINK_MAX);
-
 	if (IS_ENABLED(CONFIG_NTFS3_FS_POSIX_ACL))
 		pr_info("ntfs3: Enabled Linux POSIX ACLs support\n");
 	if (IS_ENABLED(CONFIG_NTFS3_64BIT_CLUSTER))


