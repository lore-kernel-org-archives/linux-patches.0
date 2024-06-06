Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 747AB1A01C6;
	Thu,  6 Jun 2024 14:12:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683145; cv=none; b=ffwJlRtgSgJ7ZIY1evgvBhBYwxIT9sOUMDdnt47Uxhf1fWFbWqKpXuxHwiV4zAXW8Crbl9bv7q+VHbUIBSkSt7MMZOz/P7M0KdNftU38S/HqTMHWjTpHmz8B65fH3UE/xWDPMp74rdKmUW1VGzXOQIceWgSdtjpR3a2yocSp278=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683145; c=relaxed/simple;
	bh=69SM+kKzD7bpAqxwp+CY2M1xiaUZzrGKMmgqInpGjzk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W434XhBxv0ssffjUr0bLgwUvf8xq6JJCCd34dAITXQAaHPcZ5S4FoxG4oLrUiYJ0Mc1GS1If7csHwZj9XMxTjwErW6fBOLmHMy2G/SN4p/Yn2U5il+9sZnuboyxsoPhk2EpUakvFuDKflSTHxxsMY/FjV4vF5hz6HtOC8WhV7zA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UHTXl0oq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UHTXl0oq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55F22C2BD10;
	Thu,  6 Jun 2024 14:12:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683145;
	bh=69SM+kKzD7bpAqxwp+CY2M1xiaUZzrGKMmgqInpGjzk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UHTXl0oqgnjCMLEZPwQDWgEz2ssDlqO/5FtJaX6WewLoX3R9hOOLV7VcZP1E5I+MT
	 dZBN+G27M6e/N0rPlt6W43kVfLxrddqvgvR2SSHO2IAOJQ9Qyk2elnyfpa4apC99CZ
	 JvJmbHN2kG18KJl1KsfXsZ00KguEYhkXOA/KTE0w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Subject: [PATCH 6.1 017/473] fs/ntfs3: Remove max link count info display during driver init
Date: Thu,  6 Jun 2024 15:59:06 +0200
Message-ID: <20240606131700.413841049@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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
@@ -1453,8 +1453,6 @@ static int __init init_ntfs_fs(void)
 {
 	int err;
 
-	pr_info("ntfs3: Max link count %u\n", NTFS_LINK_MAX);
-
 	if (IS_ENABLED(CONFIG_NTFS3_FS_POSIX_ACL))
 		pr_info("ntfs3: Enabled Linux POSIX ACLs support\n");
 	if (IS_ENABLED(CONFIG_NTFS3_64BIT_CLUSTER))


