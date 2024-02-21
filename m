Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BD647FBC8;
	Wed, 21 Feb 2024 14:09:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708524584; cv=none; b=DO617g4+DysQrNG+/O+M0jaXjyjDUE+am/sRKHV5ntOQd5nBXYZFh9vk5YIjAmVKS6zkPVQgPWlJFAf7qmvPKpDHHBX7iQ55qPEU8jPuv+id5U7kr2cQZKktKC0FTy36ThpJ/RDceaISj+0njPoGiban1gQD6HPrUwl6MtA0F7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708524584; c=relaxed/simple;
	bh=Y81jBjDsXrqbM+zcprjjRPMaM0e7vR40gFWS9lrKe7g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=obILO7TrI0va3xLp2LU8RhRQZQ/rgKNlkqtLS+A+Q60FNxqU6w7LaZPiYVz/tyK4cVOVCi3uLPYBLw+a7OZmIYd1GDTVtMsyPRC0P5uIVPhzXH0hYBbHklUKiM/5RldB9T66oT9weHCfJCk5HQFqWIXcmqsl3AJIYxI83DbnCUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RwK43MUg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RwK43MUg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC07EC433F1;
	Wed, 21 Feb 2024 14:09:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708524584;
	bh=Y81jBjDsXrqbM+zcprjjRPMaM0e7vR40gFWS9lrKe7g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RwK43MUgIP9PAFE3YqcStvfKSttShmkCxdHIN0WOy5Kj2wGwT0viznKWvvj0r40QP
	 q+FhZLGL0b9KjKWW1Qk0gtAVHfwrI0C4lxXUbB3uAi5glfUPd/oQqo8YZsvlSQupoK
	 FsPe/lUNn5sVjV49wIZf0A/mWwOXsF04H8wLKMnY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 5.10 289/379] btrfs: send: return EOPNOTSUPP on unknown flags
Date: Wed, 21 Feb 2024 14:07:48 +0100
Message-ID: <20240221130003.458337274@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -7285,7 +7285,7 @@ long btrfs_ioctl_send(struct file *mnt_f
 	}
 
 	if (arg->flags & ~BTRFS_SEND_FLAG_MASK) {
-		ret = -EINVAL;
+		ret = -EOPNOTSUPP;
 		goto out;
 	}
 


