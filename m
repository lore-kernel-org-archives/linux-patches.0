Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019749;
	b=TBdNfKyUh5DCGLGe/JNA72NCG8phwh731in8dQUe0Rm0eOfpHOSdld6E9bWdLx7v38AT
	 +CLIkS9nxLd/Z7uGe+Hi+7hiOTQ0KA3mqwB8UESi7KH22J3qa+2w6/jlb2X9LWzFITezk
	 xkwnl42DM8ZO/rmpeE/t/5lcuE4CFz/mJABL2a0gcsXj2pjw7xAqtm+rlIEwFwY0aXcA3
	 n0cSZgJIa8W4HHOtmJ1WO2fu8gl/WDVJywIKLtPvkmXDzP2GZwb86mEHjTFM5ZNsXIZNg
	 0UbJJbccMQmur0cDLLD5bxHXZK3d66XCl/P4CERxgPXKsiJcVNrCjFxUVKIxpXTQICA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019749;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Ed/LJCi4jK1J7S7kp3m/caUErjiKoGU2ZK5oVId5gCk=;
	b=NGeS+0CanKaA8rcBASI5I+e5XztiQ8vHn/OJL5EMamAGa107ZA4FWjyRDMkKraOTPOpo
	 26Qgx5VumRs2dlUZX1T0gJ7jFqj+rA0yb30i/PbD9CO8/SQfyXGJSz3fN0oe3ff3yiKjV
	 YovFY0b/hLw7IiTVM+Pq9bU1DkwXe4krmm5WVqmlVVkE5EWYmF84zfjbNh5Gwb0TbMvyR
	 ZAsg3icp0a+VgGFIFz+rlKbBo4V/ivnmWgjfCSdqvRyntwANPgqLyl57/dbNca8hUp5aq
	 b1wQQzV3PeKEdP/50CVT36eqxOGJD1/OXjpLUNa7t7L1zZ+fFkB+MzG4WLbyWYEwX0Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=y6OmIN8Y;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD6E2606A320;
	Wed, 18 Nov 2026 16:35:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=y6OmIN8Y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0979C1F000C5;
	Wed, 18 Nov 2026 16:35:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019749;
	bh=Ed/LJCi4jK1J7S7kp3m/caUErjiKoGU2ZK5oVId5gCk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y6OmIN8YG98HIunkKopW5r2vW0Nr4jd1Jwh/1I3GPcSbxn4gAYvVdDpxnqEOiIiPa
	 0dIVswgtl3uh11VBeQNLOg1FTba/vDnUsZTu2khaQuTeXh8Q3lcClWaoEEzxedhzof
	 vLSADE5vd0ZsWV+0m0iXuJojK9dwWMVpyrwU0YDE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1657/2651] btrfs: fix duplicated code in fs state string in logged messages
Date: Wed, 18 Nov 2026 15:48:17 +0100
Message-ID: <20261118150347.408918439@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit 3edda5249553b708c378a0d766018976315c63ad ]

We are using the code 'E' when the fs is in an error state (transaction
aborted) and when it's in the emergency shutdown state, which is confusing
and not intentional. Fix this by using an unused code such as 'H' for the
emergency shutdown state and add a comment over the fs_state_chars array
to warn to not use 'E' as its use is not defined in the array but instead
in the function btrfs_state_to_string(), since the fs state error is not
defined as a bit but as an error code in fs_info->fs_error.

Fixes: 9b2839451dfc ("btrfs: introduce a new shutdown state")
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/messages.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/messages.c b/fs/btrfs/messages.c
index 6debf0d4acadf..5fe5d34ab629c 100644
--- a/fs/btrfs/messages.c
+++ b/fs/btrfs/messages.c
@@ -13,6 +13,8 @@
 /*
  * Characters to print to indicate error conditions or uncommon filesystem state.
  * RO is not an error.
+ * Don't use 'E' because that's used to signal that there's an error stored in
+ * fs_info->fs_error (see btrfs_state_to_string() below).
  */
 static const char fs_state_chars[] = {
 	[BTRFS_FS_STATE_REMOUNTING]		= 'M',
@@ -24,7 +26,7 @@ static const char fs_state_chars[] = {
 	[BTRFS_FS_STATE_NO_DATA_CSUMS]		= 'C',
 	[BTRFS_FS_STATE_SKIP_META_CSUMS]	= 'S',
 	[BTRFS_FS_STATE_LOG_CLEANUP_ERROR]	= 'L',
-	[BTRFS_FS_STATE_EMERGENCY_SHUTDOWN]	= 'E',
+	[BTRFS_FS_STATE_EMERGENCY_SHUTDOWN]	= 'H',
 };
 
 static void btrfs_state_to_string(const struct btrfs_fs_info *info, char *buf)
-- 
2.53.0



