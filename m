Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FDEB69953;
	Wed, 21 Feb 2024 13:20:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708521638; cv=none; b=SZnzfMS8khhPFdBHO3FkYJFSo1zwgEkJH25PU3Z+KgQYlKB0M9jkuTydBAu7pQ7/dhaSuQ8AK4jfr/jrtfw8aD1llBKvO3keL8+nehRXeOA4e15kZfmLSVJuglJz2U5D+OXV7d3wlxIm4zmVgAfyxDDqewoMQAAlFZvXiJWgeMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708521638; c=relaxed/simple;
	bh=ssseN71+A+GaDoxTw6TYRgas2S/l7W6C9OqfFGkFBuY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VzBrtnvt50Tiy083jUqFj0Bh+bGvGmAixyDHxwOVEv31RAJliZcOs6WCY7iX1Yt6InKyjvFRc2Dvf+bQ5NjO8pvrYG6F3sccEZdMHIxj6ym/llvIXT1ggV3b7+IbhyoB/XnVZz73+xvwda6nW8s8oecwRnCdtmq2vB5EK9dpovg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Eads9eqN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Eads9eqN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BA16C433F1;
	Wed, 21 Feb 2024 13:20:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708521638;
	bh=ssseN71+A+GaDoxTw6TYRgas2S/l7W6C9OqfFGkFBuY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Eads9eqNapp1b9IAcpYblzzC5EMYeJDWfL7QmlFQJ/DQbglgJqVjA9GERbI2ejuZ3
	 Qwbzg68NBwehKn4Gwkau3vNMgBt+e5bVQKUVVZqWoyOezJNo3r3NjhHJr16UIboNbq
	 uCT/IRBNG/v7G5SiIP8d0NMqFXgxtqgeAWFb3HNg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 4.19 166/202] btrfs: send: return EOPNOTSUPP on unknown flags
Date: Wed, 21 Feb 2024 14:07:47 +0100
Message-ID: <20240221125937.113831338@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125931.742034354@linuxfoundation.org>
References: <20240221125931.742034354@linuxfoundation.org>
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
@@ -6842,7 +6842,7 @@ long btrfs_ioctl_send(struct file *mnt_f
 	}
 
 	if (arg->flags & ~BTRFS_SEND_FLAG_MASK) {
-		ret = -EINVAL;
+		ret = -EOPNOTSUPP;
 		goto out;
 	}
 


