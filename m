Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619488;
	b=h8i2vuaQjOzwQ5ZBinufe1QS8l3o5lJsQiDJKoICGic+9r3CXnN0/iL8DlCP8/utTfFj
	 N2X4l41HTDVa0DPTJx2ZmkVpy680ZEkZK4JMqwf5SgRwe/U7iuLAZMo+k/p+G4ATKJ41X
	 IoGgiAijfNcqgMeE6ykoBhmWijgJdf0Ipa2W2Lqh4Ogl8jaRDGff9Mkemu1Uukg8Dj2kV
	 DwISktXSjSZFgxS0Qk6vjYJZSKXZPcMEUe3SPPb1PVFO38m7pyG3nxIzJMDk/gSARMpZH
	 wj1AHCqNRFGDsyCWjvoX3hYhiGMcUEFJnpAXy1i1Pv9Rm8ZaCCw6Dn/+Lpj+4+e8qog==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619488;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=L5EdM1F1EqVw7KZ5CfxjkntirbeLf8S3xPu0xlcNdq0=;
	b=WBprL6GlIxq7G7pcZFXhJ18qluH5ppDEfBeWGDWl4KHOhrCMS/J58+BT/SyNdP9QtXj/
	 eWHY8Z7GNdJE94IryFbLS8EZxV9/R7Rh9P4ZXsqb/Adkmb76uzFJwcjF3APGJw5RzCZaS
	 A8KG7IELw81NiOgz6BuJv1pHLXIPhxQELph/yZ4AghaxheS94r42mBNuQvdVcL9G5Udo7
	 DnOqt3mfFZAUG645Umvfi7jR7fu/NaMg/WLtiwBJNAJVcgL6EKeEpyb899B6dFs1F8oPN
	 p2+1Q4D2QogbK972ZbKH6leHv25wCEJNxxF+lpRYVrcEQNnWj9Pgj9nl3DvIjAPk5dQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aluag8xT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F2F8606A323;
	Wed, 25 Nov 2026 15:11:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aluag8xT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57C821F000C4;
	Wed, 25 Nov 2026 15:11:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619487;
	bh=L5EdM1F1EqVw7KZ5CfxjkntirbeLf8S3xPu0xlcNdq0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aluag8xTJ7ObXuwT4XqY36WgloV4FcNTJF18f+EVQ9Ug401+YEh0NcCnClXWQtEy2
	 RWHvUKSO0cQj5X+Kh5oo1dZawYzQy9qAIR5ss9ZZEPCrXqDp9qvDxUDVNmLqziGske
	 wJuSrwLm3tiCGOW2FHgZOaiFMYtfiHI6jSI1lt8I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <quwenruo.btrfs@gmx.com>,
	Cheng Yongkang <teel4res@gmail.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 7.3 0613/1005] btrfs: reject refs=0 subvolume without DEAD in SUBVOL_SYNC_WAIT
Date: Wed, 25 Nov 2026 15:32:31 +0100
Message-ID: <20261125143836.105481052@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cheng Yongkang <teel4res@gmail.com>

commit 9a58e56e70f610e29b53821e9c706600e529cca3 upstream.

btrfs_ioctl_subvol_sync() assumes that a cached root with zero
references has BTRFS_ROOT_SUBVOL_DEAD set, and asserts that before
waiting for the cleaner. Two states break the assumption:

- A corrupt ROOT_ITEM with zero references and a matching orphan item,
  on a writable filesystem.
- A failed subvolume deletion. btrfs_delete_subvolume() zeroes the
  root references, aborts the transaction, which forces the filesystem
  read-only, and then clears DEAD again. No on-disk metadata is
  corrupted in this case.

With CONFIG_BTRFS_ASSERT=y, both reach a BUG().

Change the ASSERT() into a proper rejection to avoid triggering a BUG().

Fixes: 6c83d153ed86 ("btrfs: add new ioctl to wait for cleaned subvolumes")
CC: stable@vger.kernel.org
Suggested-by: Qu Wenruo <quwenruo.btrfs@gmx.com>
Link: https://lore.kernel.org/linux-btrfs/dd97efe9-91ec-495b-b698-acff1447421c@gmx.com/
Signed-off-by: Cheng Yongkang <teel4res@gmail.com>
[ Rework the commit message, drop the ad-hoc RW check. ]
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/ioctl.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -5173,8 +5173,12 @@ static int btrfs_ioctl_subvol_sync(struc
 			return -ENOENT;
 
 		wait_for_deletion = true;
-		ASSERT(root_flags & BTRFS_ROOT_SUBVOL_DEAD, "root_flags=0x%llx",
-		       root_flags);
+		if (unlikely(!(root_flags & BTRFS_ROOT_SUBVOL_DEAD))) {
+			btrfs_err(fs_info,
+				  "subvol %llu has refs 0 without DEAD flag",
+				  args.subvolid);
+			return -EUCLEAN;
+		}
 		sched_ret = schedule_timeout_interruptible(HZ);
 		/* Early wake up or error. */
 		if (sched_ret != 0)


