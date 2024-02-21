Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A09FF3B287;
	Wed, 21 Feb 2024 14:26:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708525603; cv=none; b=KYDQRY/d3aQjXvWRS37jxHouMfYYjmBhNsV7yMJP09iqTSPL7rEQzkyYcnUUhSzR6Sa/j9MeblJH3udL8yKlEHCMPZ+8WLivCp9ZDSDUsfI6WwFy9hZu1x3/SjXSzuI6rbi6nne2QqYTjZEgsvppRmZxIo9NbXkLbOo9ypJwfQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708525603; c=relaxed/simple;
	bh=ZyRWxMa+e5VC92YNZEdmTcX4QEpSB9vwnTm+hoY+gpM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RMLB/Kw7LbpHaKZXVAqFdww/DJ1G1owIAZ3sDFpwDMAsjoYxI82vmaGlJDokdbcqtcbx06zTcDuQOgQ1d/oOR2mOe/DH1hAb2yv3NjlollfB3qRS5obmpAGANJf8Zveus8gdFEXCcFp4FnaVkWRKia6C7piEEg1QH5fw0IDso30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HenriSG1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HenriSG1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31875C433C7;
	Wed, 21 Feb 2024 14:26:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708525603;
	bh=ZyRWxMa+e5VC92YNZEdmTcX4QEpSB9vwnTm+hoY+gpM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HenriSG1s5H+8gSHVSX7Iz7DCnxXk7akaHk3C+HyYXMRU5l3ruuL9Cm6fA3JQ7jR4
	 iyWD3t5LtJLfat45QhhHxO5htBao+TDk3s/kUbW9oiZAZ2RGuzITyFVDBKZVSAtO7h
	 u6s+Jndo3Af7wxCzTWlHroJ8RtsT8IIBRyB6FWkg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 5.4 206/267] btrfs: send: return EOPNOTSUPP on unknown flags
Date: Wed, 21 Feb 2024 14:09:07 +0100
Message-ID: <20240221125946.651109128@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125940.058369148@linuxfoundation.org>
References: <20240221125940.058369148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -7363,7 +7363,7 @@ long btrfs_ioctl_send(struct file *mnt_f
 	}
 
 	if (arg->flags & ~BTRFS_SEND_FLAG_MASK) {
-		ret = -EINVAL;
+		ret = -EOPNOTSUPP;
 		goto out;
 	}
 


