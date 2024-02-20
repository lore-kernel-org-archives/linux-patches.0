Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2328E151CD8;
	Tue, 20 Feb 2024 20:59:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708462791; cv=none; b=kRGegKqm9/gmg8aUOLrtT1ag4wtkJhf8p3OcumxLogfRnvBq1bAbUigUMLbepmZio3G0n0CYmvGSKBGDLjXSCsVIApgIm8B4k4NUId5BYkvIa2n94mVL5IygClrgdjisL+swM0pVgKt511cp59sc9OeHG9occn0fEJyeY8YvxHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708462791; c=relaxed/simple;
	bh=1+MV5JjB6yy6dOmB3joPeMZDf0EwjsABW1w15z57zHM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AYTkQ4oiGurtPkFcD9ug2QpDhKIgEVWoJBGXSS7DmSsc1kkrXg1nmc/K+4ps1tTicDzeN6xLhmhgi5tIiBALOv4chvzSnlKtyDFwq7KVdmhJJkSa2l5NWDWzCEV/t2IAZRPmdUYae9etmb2NlrKi1CqWjthJzQcHDUPg8DgFnvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JDq9kV6q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JDq9kV6q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87AAFC433C7;
	Tue, 20 Feb 2024 20:59:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708462791;
	bh=1+MV5JjB6yy6dOmB3joPeMZDf0EwjsABW1w15z57zHM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JDq9kV6qN9fbBcj6jH7/rdWnYmLItqNicTnMJQzKF3axoHwuMCNTAZN1ZaGiDAjZM
	 fk4+vRkUcb0CdreeBM5ipEMMoWqaNJcVQDap+7UAnWPH6A4rgfikVb+554K4HUypTP
	 vEhKGvhXIrDziXhYQJCB8Ql81JSNEP0cUcoB/7Rw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.1 008/197] btrfs: send: return EOPNOTSUPP on unknown flags
Date: Tue, 20 Feb 2024 21:49:27 +0100
Message-ID: <20240220204841.329982920@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220204841.073267068@linuxfoundation.org>
References: <20240220204841.073267068@linuxfoundation.org>
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

From: David Sterba <dsterba@suse.com>

commit f884a9f9e59206a2d41f265e7e403f080d10b493 upstream.

When some ioctl flags are checked we return EOPNOTSUPP, like for
BTRFS_SCRUB_SUPPORTED_FLAGS, BTRFS_SUBVOL_CREATE_ARGS_MASK or fallocate
modes. The EINVAL is supposed to be for a supported but invalid
values or combination of options. Fix that when checking send flags so
it's consistent with the rest.

CC: stable@vger.kernel.org # 4.14+
Link: https://lore.kernel.org/linux-btrfs/CAL3q7H5rryOLzp3EKq8RTbjMHMHeaJubfpsVLF6H4qJnKCUR1w@mail.gmail.com/
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/send.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -7852,7 +7852,7 @@ long btrfs_ioctl_send(struct inode *inod
 	}
 
 	if (arg->flags & ~BTRFS_SEND_FLAG_MASK) {
-		ret = -EINVAL;
+		ret = -EOPNOTSUPP;
 		goto out;
 	}
 


