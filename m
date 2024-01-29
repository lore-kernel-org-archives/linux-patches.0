Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37F1F15AAC2;
	Mon, 29 Jan 2024 17:09:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548178; cv=none; b=jNxYEInffa7Zn2YJfJ74X8MosXnTkrqGnkPzivAH03xDoM4wbezXX0oo17nE3pHrLYz/dfVXF1LkdFpC+0f5wUaWyN6WEZFARA1Vs8qRuY7dq1DAFPJ44U7zTzY9qXMFBz3hO6fMv/kVD9nJ0gvrw8REJzMxUJUYPvm6ufkGXDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548178; c=relaxed/simple;
	bh=Szu7bdytwR1itOEpSHsFe8g68QHLPvrYJRKNc97zzh8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jKt+rzN7CtGSNY9DjiwATEKgCD31acjDf235kpq7xYG5B0A/E5pxvrz2dy7HKBxmP70dF6p9cLhHSS9+G1CunjnCAw4GrHm3kecbR+gNd2mRTxTXzW0GAH0rf61ziw0z8OWvpDLXzneD1cxrk33dLdeQidEv7/BeAFbYuktHdro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iUdg2RjS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iUdg2RjS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1967C43399;
	Mon, 29 Jan 2024 17:09:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548178;
	bh=Szu7bdytwR1itOEpSHsFe8g68QHLPvrYJRKNc97zzh8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iUdg2RjSZreozvR/pBXnGWGz5EML81jj9SUNrcvahebv6HU766IVjFvFp7TAPkU9l
	 oTWD0QIF1lVkZXR82SuPKMgrIhMQrL+yqvigWrMHoqM3YexBOQHZkso9ay+NKUtK19
	 0pvoZrgIjZwBd7/0eHvjXA1vcoJMBUkHB4i1o+D4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+be14ed7728594dc8bd42@syzkaller.appspotmail.com,
	syzbot+c563a3c79927971f950f@syzkaller.appspotmail.com,
	Anand Jain <anand.jain@oracle.com>,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.7 224/346] btrfs: ref-verify: free ref cache before clearing mount opt
Date: Mon, 29 Jan 2024 09:04:15 -0800
Message-ID: <20240129170022.982934337@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fedor Pchelkin <pchelkin@ispras.ru>

commit f03e274a8b29d1d1c1bbd7f764766cb5ca537ab7 upstream.

As clearing REF_VERIFY mount option indicates there were some errors in a
ref-verify process, a ref cache is not relevant anymore and should be
freed.

btrfs_free_ref_cache() requires REF_VERIFY option being set so call
it just before clearing the mount option.

Found by Linux Verification Center (linuxtesting.org) with Syzkaller.

Reported-by: syzbot+be14ed7728594dc8bd42@syzkaller.appspotmail.com
Fixes: fd708b81d972 ("Btrfs: add a extent ref verify tool")
CC: stable@vger.kernel.org # 5.4+
Closes: https://lore.kernel.org/lkml/000000000000e5a65c05ee832054@google.com/
Reported-by: syzbot+c563a3c79927971f950f@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/lkml/0000000000007fe09705fdc6086c@google.com/
Reviewed-by: Anand Jain <anand.jain@oracle.com>
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/ref-verify.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/fs/btrfs/ref-verify.c
+++ b/fs/btrfs/ref-verify.c
@@ -889,8 +889,10 @@ int btrfs_ref_tree_mod(struct btrfs_fs_i
 out_unlock:
 	spin_unlock(&fs_info->ref_verify_lock);
 out:
-	if (ret)
+	if (ret) {
+		btrfs_free_ref_cache(fs_info);
 		btrfs_clear_opt(fs_info->mount_opt, REF_VERIFY);
+	}
 	return ret;
 }
 
@@ -1021,8 +1023,8 @@ int btrfs_build_ref_tree(struct btrfs_fs
 		}
 	}
 	if (ret) {
-		btrfs_clear_opt(fs_info->mount_opt, REF_VERIFY);
 		btrfs_free_ref_cache(fs_info);
+		btrfs_clear_opt(fs_info->mount_opt, REF_VERIFY);
 	}
 	btrfs_free_path(path);
 	return ret;


